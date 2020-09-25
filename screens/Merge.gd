extends Control

onready var dialog = $FileDialog

func _on_AddDoc_pressed():
	dialog.mode = FileDialog.MODE_OPEN_FILES
	dialog.deselect_items()
	dialog.popup()


func _on_FileDialog_files_selected(paths):
	for path in paths:
		$Merge/ItemList.add_item(path)


func _on_RemoveDoc_pressed():
	var selected_items: Array = $Merge/ItemList.get_selected_items()
	var idx = selected_items.pop_back()
	while idx != null:
		$Merge/ItemList.remove_item(idx)
		idx = selected_items.pop_back()


func _on_Merge_pressed():
	if $Merge/ItemList.get_item_count() == 0:
		$AlertNoFile.popup()
		return
	elif $Merge/ItemList.get_item_count() == 1:
		$AlertOneFile.popup()
		return 
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.window_title = tr("save_file")
	dialog.deselect_items()
	dialog.popup()


func _on_FileDialog_file_selected(path):
	var output = []
	var docs = []
	for i in range($Merge/ItemList.get_item_count()):
		docs.append($Merge/ItemList.get_item_text(i))
	PdfBackend.merge_docs(docs, path)
	Utility.show_folder(path)
		#OS.execute("shellscripts\\open_file_ex.bat", [path], true, output, true)
