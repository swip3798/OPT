extends Control

onready var pcollection: GridContainer = $VBoxContainer/Control/ScrollContainer/PageCollection
var page_dragger_scene: PackedScene = preload("res://widgets/PageDragger.tscn")
var page_count: int
onready var dialog: FileDialog = $FileDialog

func _on_Button_pressed():
	if pcollection.get_child_count() > 0:
		$WindowDialog.popup()
	else:
		$AcceptDialog.popup()

func _on_FileChooser_valid_file_selected(path):
	Utility.clear_thumbnail_path()
	for i in pcollection.get_children():
		i.queue_free()
# warning-ignore:return_value_discarded
	PdfBackend.render_thumbnails(path)
	page_count = PdfBackend.get_page_count(path)
	for i in range(page_count):
		var holder: Control = page_dragger_scene.instance()
		holder.page_number = i
		pcollection.add_child(holder)
		holder.load_texture()
# warning-ignore:return_value_discarded
		holder.connect("cut_point_changed", self, "_on_cut_point_changed")
	pcollection.reset_neighbors()


func _on_Override_pressed():
	_on_FileDialog_file_selected($VBoxContainer/FileChooser.selected_path)


func _on_NewCopy_pressed():
	dialog.deselect_items()
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.popup()


func _on_FileDialog_file_selected(path):
	pass # Replace with function body.


func _on_Cancel_pressed():
	$WindowDialog.hide()


func _on_RemoveButton_pressed():
	pass # Replace with function body.
