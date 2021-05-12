tool
extends Node

onready var thread: Thread = Thread.new()
onready var _mutex: Mutex = Mutex.new()

export var basepath: String = ""
export var baseargs: PoolStringArray = []
export var command: String = ""

var _is_running: bool = false
var _base_path_validated: bool = false

signal command_successful(response)
signal command_failed(status_code, traceback)
# In case response can't be parsed
signal embedding_error(stdouterr)
signal base_path_wrong(stdouterr)

func _set_is_running(running: bool):
	_mutex.lock()
	_is_running = running
	_mutex.unlock()

func get_is_running() -> bool:
	_mutex.lock()
	var res = _is_running
	_mutex.unlock()
	return res

func _ready():
	_execute_command("info", null)

func execute(data):
	_execute_command(self.command, data)

func _execute_command(command: String, data):
	var data_json = JSON.print(data)
	data_json = data_json.c_escape()
	var args = baseargs
	args.append_array([command, data_json])
	_queue_in_shell_command(basepath, args)

func _queue_in_shell_command(path: String, arguments: PoolStringArray):
	while get_is_running():
		yield(Engine.get_main_loop(), "idle_frame")
	_cleanup()
	_execute_shell_command(path, arguments)

func _execute_shell_command(path: String, arguments: PoolStringArray):
	_set_is_running(true)
	thread.start(self, "_thread_runner", [path, arguments])

func _thread_runner(parameters):
	var path: String = parameters[0]
	var args: PoolStringArray = parameters[1]
	var output: Array = []
	var exit_code := OS.execute(path, args, true, output, true)
	_evaluate_response(args, output[0])
	_set_is_running(false)

func _evaluate_response(args: PoolStringArray, output: String):
	var command = args[len(args) - 2]
	var res_parse: JSONParseResult = JSON.parse(output)
	if res_parse.error != OK:
		if not _base_path_validated:
			emit_signal("base_path_wrong", output)
		else:
			emit_signal("embedding_error", output)
		return null
	var res_data: Dictionary = res_parse.result
	if res_data.get("status") != 0:
		emit_signal("command_failed", res_data.get("status"), res_data.get("exception"))
		return null
	if not _base_path_validated and command == "info":
		_base_path_validated = true
		return null
	emit_signal("command_successful", res_data.get("response"))
	
func _cleanup():
	if thread.is_active() and not get_is_running():
		thread.wait_to_finish()
	
func _exit_tree():
	_cleanup()
