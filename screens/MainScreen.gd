extends Control

func _ready():
	EEBackendManager.start_ee_backend_http("backend\\python.exe", ["backend\\main.py"])
