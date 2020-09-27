extends Node

func backslash_path(path: String) -> String:
	return path.replace("/", "\\")
	
func show_dir(dir: String):
	if OS.get_name() == "Windows":
		dir = backslash_path(dir)
# warning-ignore:return_value_discarded
	OS.shell_open(dir)
	
func show_folder(path: String):
	path = path.get_base_dir()
	show_dir(path)

func clear_thumbnail_path():
	var output = []
	var thumbnail_path: String = PdfBackend.get_thumbnail_path()
	if OS.get_name() == "Windows":
# warning-ignore:return_value_discarded
		thumbnail_path = backslash_path(thumbnail_path)
		OS.execute("del", ["/F", "/Q", thumbnail_path + "*"], true, output, true)
	else:
# warning-ignore:return_value_discarded
		OS.execute("rm", ["-rf", thumbnail_path + "*"], true, output, true)
	print("clear_thumbnail_path: ", output)
