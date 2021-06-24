tool
extends Node

onready var _http = HTTPRequest.new()

var _connected := false
var _last_command: String
var _last_type: int

export var PORT := 43512
export var timeout := 5.0
export var use_threads := false

enum RESPONSE_TYPE {
	JSON_STRING = 0
	BINARY = 1
}

signal command_successful(command, response)
signal command_failed(command, status_code, traceback)
# In case response can't be parsed
signal embedding_error()
# In case no connection to ee backend
signal no_connection()

func _setup_http():
	add_child(_http)
	_http.connect("request_completed", self, "_http_request_completed")
	_http.timeout = timeout
	_http.use_threads = use_threads

func _url_construct(command, ssl := false):
	if not ssl:
		return "http://localhost:" + str(PORT) + "/" + command
	else:
		return "https://localhost:" + str(PORT) + "/" + command

func _init_connection():
	execute("info", null)

func _ready():
	_setup_http()
	_init_connection()

func execute(command: String, data, response_type: int = RESPONSE_TYPE.JSON_STRING):
	var data_json = JSON.print(data)
	while _http.get_http_client_status() != 0:
		yield(Engine.get_main_loop(), "idle_frame")
	var err = _http.request(_url_construct(command), PoolStringArray(), true, HTTPClient.METHOD_POST, data_json)
	if err != ERR_BUSY:
		_last_command = command
		_last_type = response_type
	return err

func _http_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		_evaluate_response(body)
	else:
		emit_signal("no_connection")
		
func _evaluate_response(body: PoolByteArray):
	if _last_type == RESPONSE_TYPE.JSON_STRING:
		var result = JSON.parse(body.get_string_from_utf8())
		if result.error != OK:
			emit_signal("embedding_error")
			return null
		if not _connected and _last_command == "info":
			_connected = true
			return null
		var res_data: Dictionary = result.result
		if res_data.get("status") != 0:
			emit_signal("command_failed", _last_command, res_data.get("status"), res_data.get("exception"))
			return null
		emit_signal("command_successful", _last_command, res_data.get("response"))
	else:
		emit_signal("command_successful", _last_command, body)
