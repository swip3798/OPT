extends Control

func _ready():
	pass


func _on_AddDoc_pressed():
	$FileDialog.mode = FileDialog.MODE_OPEN_FILES
	$FileDialog.deselect_items()
	$FileDialog.show()


func _on_FileDialog_files_selected(paths):
	for path in paths:
		$Merge/ItemList
		$Merge/ItemList.add_item(path)


func _on_RemoveDoc_pressed():
	var selected_items: Array = $Merge/ItemList.get_selected_items()
	var idx = selected_items.pop_back()
	while idx != null:
		$Merge/ItemList.remove_item(idx)
		idx = selected_items.pop_back()


func _on_Merge_pressed():
	if $Merge/ItemList.get_item_count() == 0:
		$AlertNoFile.show()
		return
	elif $Merge/ItemList.get_item_count() == 1:
		$AlertOneFile.show()
		return 
	$FileDialog.mode = FileDialog.MODE_SAVE_FILE
	$FileDialog.deselect_items()
	$FileDialog.show()


func _on_FileDialog_file_selected(path):
	var output = []
	var docs = []
	for i in range($Merge/ItemList.get_item_count()):
		docs.append($Merge/ItemList.get_item_text(i))
	PdfBackend.merge_docs(docs, path)
	Utility.show_folder(path)
		#OS.execute("shellscripts\\open_file_ex.bat", [path], true, output, true)
