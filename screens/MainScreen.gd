extends Control

func _ready():
	EEBackendManager.start_ee_backend_http("backend\\pythonw.exe", ["backend\\main.py"])
