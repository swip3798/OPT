extends Control

onready var dialog := $FileDialog
onready var eemerge := $MergePDF
onready var excep_err := $ExceptionError
onready var drop_files_info := $DropFilesInfo

func _ready():
	get_tree().connect("files_dropped", self, "_get_dropped_files_path")

func _update_drop_info():
	if $Merge/ItemList.get_item_count() == 0:
		drop_files_info.show()
	else:
		drop_files_info.hide()
	if $Merge/ItemList.get_item_count() > 1:
		$Merge/Merge.disabled = false
	else:
		$Merge/Merge.disabled = true
		

func _get_dropped_files_path(files: PoolStringArray, screen: int):
	for path in files:
		if path.get_extension() == "pdf":
			$Merge/ItemList.add_item(path)
	_update_drop_info()

func _on_AddDoc_pressed():
	dialog.mode = FileDialog.MODE_OPEN_FILES
	dialog.deselect_items()
	dialog.popup()


func _on_FileDialog_files_selected(paths):
	for path in paths:
		$Merge/ItemList.add_item(path)
	_update_drop_info()


func _on_RemoveDoc_pressed():
	var selected_items: Array = $Merge/ItemList.get_selected_items()
	var idx = selected_items.pop_back()
	while idx != null:
		$Merge/ItemList.remove_item(idx)
		idx = selected_items.pop_back()
	_update_drop_info()


func _on_Merge_pressed():
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.window_title = tr("save_file")
	dialog.deselect_items()
	dialog.popup()


func _on_FileDialog_file_selected(path):
	var docs = []
	for i in range($Merge/ItemList.get_item_count()):
		docs.append($Merge/ItemList.get_item_text(i))
	eemerge.execute({
		"input_files": docs,
		"output_file": path
	})


func _on_MergePDF_command_successful(response):
	Utility.show_folder(response.get("output_file", ""))


func _on_MergePDF_command_failed(status_code, traceback):
	excep_err.show_error(status_code, traceback)


func _on_MergePDF_embedding_error():
	excep_err.show_error(-4, "Embedding error")


func _on_MergePDF_no_connection():
	excep_err.show_error(-5, "No connection to OPT-Backend")
