extends Control

func _ready():
	print()
	EEBackendManager.start_ee_backend_http(Utility.translate_res_path_absolute("res://backend/pythonw.exe"), [Utility.translate_res_path_absolute("res://backend/main.py")])
