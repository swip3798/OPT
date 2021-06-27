tool
extends Node

onready var client := preload("EasyEmbedClient.gd").new()

export var basepath: String = ""
export var baseargs: PoolStringArray = []
export var command: String = ""
export var synchronous: bool = false

signal command_successful(response)
signal command_failed(status_code, traceback)
# In case response can't be parsed
signal embedding_error(stdouterr)
signal base_path_wrong(stdouterr)

func get_is_running() -> bool:
	return client.get_is_running()

func _ready():
	client.connect("command_successful", self, "_on_command_successful")
	client.connect("command_failed", self, "_on_command_failed")
	client.connect("embedding_error", self, "_on_embedding_error")
	client.connect("base_path_wrong", self, "_on_base_path_wrong")

func execute(data):
	client.basepath = self.basepath
	client.baseargs = self.baseargs
	client.synchronous = self.synchronous
	client.execute(self.command, data)
	
func _on_command_successful(command, response):
	emit_signal("command_successful", response)

func _on_command_failed(command, status_code, traceback):
	emit_signal("command_failed", status_code, traceback)

func _on_embedding_error(stdouterr):
	emit_signal("embedding_error", stdouterr)
	
func _on_base_path_wrong(stdouterr):
	emit_signal("base_path_wrong", stdouterr)
	
func _exit_tree():
	client.free()
