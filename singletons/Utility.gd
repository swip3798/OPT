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
	if OS.get_name() == "Windows":
# warning-ignore:return_value_discarded
		OS.execute("del", ["/F", "/Q", PdfBackend.get_thumbnail_path() + "*"], true)
	else:
# warning-ignore:return_value_discarded
		OS.execute("rm", ["-rf", PdfBackend.get_thumbnail_path() + "*"], true)
