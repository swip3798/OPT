tool
extends Node

onready var client := preload("EEClientHTTP.gd").new()

export var command: String = ""
export var PORT := 43512
export var timeout := 5.0
export var use_threads := false

enum RESPONSE_TYPE {
	JSON_STRING = 0
	BINARY = 1
}
export(RESPONSE_TYPE) var response_type := RESPONSE_TYPE.JSON_STRING

signal command_successful(response)
signal command_failed(status_code, traceback)
# In case response can't be parsed
signal embedding_error()
# In case no connection to ee backend
signal no_connection()

func get_is_running() -> bool:
	return client.get_is_running()

func _ready():
	client.PORT = self.PORT
	client.timeout = self.timeout
	client.use_threads = self.use_threads
	client.connect("command_successful", self, "_on_command_successful")
	client.connect("command_failed", self, "_on_command_failed")
	client.connect("embedding_error", self, "_on_embedding_error")
	client.connect("no_connection", self, "_on_no_connection")
	add_child(client)

func execute(data):
	client.PORT = self.PORT
	client.timeout = self.timeout
	client.use_threads = self.use_threads
	client.execute(self.command, data, response_type)
	
func _on_command_successful(command, response):
	emit_signal("command_successful", response)

func _on_command_failed(command, status_code, traceback):
	emit_signal("command_failed", status_code, traceback)

func _on_embedding_error():
	emit_signal("embedding_error")
	
func _on_no_connection():
	emit_signal("no_connection")
	
func _exit_tree():
	client.free()
