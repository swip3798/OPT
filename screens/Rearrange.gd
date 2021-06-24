extends Control

onready var pcollection: GridContainer = $VBoxContainer/Control/ScrollContainer/PageCollection
var page_dragger_scene: PackedScene = preload("res://widgets/PageDragger.tscn")
var page_count: int
var page_holders: Array = []

onready var dialog: FileDialog = $FileDialog
onready var ee_render_thumbs := $RenderThumbs
onready var ee_cut_pdf := $CutPdf
onready var page_collection: Container = $VBoxContainer/Control/ScrollContainer/PageCollection

func _on_Button_pressed():
	if pcollection.get_child_count() > 0:
		$WindowDialog.popup()
	else:
		$AcceptDialog.popup()

func _on_FileChooser_valid_file_selected(path):
	ee_render_thumbs.execute({"input_file": path})
	
func _on_RenderThumbs_command_successful(response):
	for i in page_holders:
		i.queue_free()
	page_holders = []
	var i = 0
	for thumbnail_b64 in response.get("thumbnails", []):
		var dragger: Control = page_dragger_scene.instance()
		dragger.page_number = i
		page_holders.append(dragger)
		page_collection.add_child(dragger)
		dragger.load_texture(thumbnail_b64)
		i += 1

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



