extends Node

func backslash_path(path: String) -> String:
	return path.replace("/", "\\")

func show_folder(path: String):
	path = path.get_base_dir()
	if OS.get_name() == "Windows":
		path = backslash_path(path)
	OS.shell_open(path)

func clear_thumbnail_path():
	if OS.get_name() == "Windows":
		OS.execute("del", ["/F", "/Q", PdfBackend.get_thumbnail_path() + "*"], true)
	else:
		OS.execute("rm", ["-rf", PdfBackend.get_thumbnail_path() + "*"], true)
