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

func cut_document(cut_point_inc: int, page_count: int, output_prefix: String):
	var page_sequence1: Array = []
	for i in range(cut_point_inc + 1):
		page_sequence1.append(i)
	var page_sequence2: Array = []
	for i in range(cut_point_inc + 1, page_count):
		page_sequence2.append(i)
	return [[page_sequence1, output_prefix + "-1.pdf"], [page_sequence2, output_prefix + "-2.pdf"]]

func translate_res_path_absolute(path):
	if OS.has_feature("editor"):
		return ProjectSettings.globalize_path("res://" + path).replace("/", "\\")
	else:
		return (OS.get_executable_path().get_base_dir() + "/" + path).replace("/", "\\")
	
