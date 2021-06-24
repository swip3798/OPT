tool
extends Node

var thread: Thread = Thread.new()
var _mutex: Mutex = Mutex.new()

export var basepath: String = ""
export var baseargs: PoolStringArray = []
export var synchronous: bool = false

var _is_running: bool = false
var _base_path_validated: bool = false

signal command_successful(command, response)
signal command_failed(command, status_code, traceback)
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
	execute("info", null)

func execute(command: String, data):
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
	var response
	if not synchronous:
		thread.start(self, "_thread_runner", [path, arguments])
		# Wait for thread to finish, so that signal is executed in main thread
		while get_is_running():
			yield(Engine.get_main_loop(), "idle_frame")
		response = thread.wait_to_finish()
	else:
		response = _thread_runner([path, arguments])
	if response != null:
		if response.get("signal_name") == "command_failed":
			emit_signal("command_failed", response.get("command"), response.get("status_code"), response.get("traceback"))
		elif response.get("signal_name") == "command_successful":
			emit_signal("command_successful", response.get("command"), response.get("res_data"))
		else:
			emit_signal(response.get("signal_name"), response.get("res_data"))
	

func _thread_runner(parameters):
	var path: String = parameters[0]
	var args: PoolStringArray = parameters[1]
	var output: Array = []
	var exit_code := OS.execute(path, args, true, output, true)
	var returnvals = _evaluate_response(args, output[0])
	_set_is_running(false)
	return returnvals

func _evaluate_response(args: PoolStringArray, output: String):
	var command = args[len(args) - 2]
	var res_parse: JSONParseResult = JSON.parse(output)
	if res_parse.error != OK:
		if not _base_path_validated:
			return {
				"signal_name": "base_path_wrong",
				"command": command,
				"res_data": output,
			}
		else:
			return {
				"signal_name": "embedding_error",
				"command": command,
				"res_data": output,
			}
	var res_data: Dictionary = res_parse.result
	if res_data.get("status") != 0:
		return {
			"signal_name": "command_failed",
			"command": command,
			"traceback": res_data.get("exception"),
			"status_code": res_data.get("status")
		}
	if not _base_path_validated and command == "info":
		_base_path_validated = true
		return null
	return {
		"signal_name": "command_successful",
		"command": command,
		"res_data": res_data.get("response"),
	}
	
func _cleanup():
	if thread.is_active() and not get_is_running():
		thread.wait_to_finish()
	
func _exit_tree():
	_cleanup()
