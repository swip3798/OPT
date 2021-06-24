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

func cut_document(cut_point_inc: int, page_count: int, output_prefix: String):
	var page_sequence1: Array = []
	for i in range(cut_point_inc + 1):
		page_sequence1.append(i)
	var page_sequence2: Array = []
	for i in range(cut_point_inc + 1, page_count):
		page_sequence2.append(i)
	return [[page_sequence1, output_prefix + "-1.pdf"], [page_sequence2, output_prefix + "-2.pdf"]]
