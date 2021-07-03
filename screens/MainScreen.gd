extends Control

func _ready():
	print("Starting path: ", Utility.translate_res_path_absolute("backend/pythonw.exe"))
	print("Starting args: ", Utility.translate_res_path_absolute("backend/main.py"))
	EEBackendManager.start_ee_backend_http(Utility.translate_res_path_absolute("backend/pythonw.exe"), [Utility.translate_res_path_absolute("backend/main.py")])
