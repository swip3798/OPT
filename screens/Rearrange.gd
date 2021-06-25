extends Control

onready var pcollection: GridContainer = $VBoxContainer/Control/ScrollContainer/PageCollection
var page_dragger_scene: PackedScene = preload("res://widgets/PageDragger.tscn")
var page_count: int
var page_holders: Array = []

onready var dialog: FileDialog = $FileDialog
onready var ee_render_thumbs := $RenderThumbs
onready var ee_rearrange := $Rearrange
onready var page_collection := $VBoxContainer/Control/ScrollContainer/PageCollection
onready var save_button := $VBoxContainer/Button
onready var choice_dialog := $WindowDialog
onready var file_chooser := $VBoxContainer/FileChooser

func _ready():
	get_tree().connect("files_dropped", self, "_get_dropped_files_path")

func _get_dropped_files_path(files: PoolStringArray, screen: int):
	for file in files: 
		if file.get_extension() == "pdf":
			file_chooser.set_selected_path(file)
			break

func _on_Button_pressed():
	if pcollection.get_child_count() > 0:
		$WindowDialog.popup()
	else:
		$AcceptDialog.popup()

func _on_FileChooser_valid_file_selected(path):
	ee_render_thumbs.execute({"input_file": path})
	save_button.disabled = false
	
	
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
	page_collection.reset_neighbors()

func _on_Override_pressed():
	_on_FileDialog_file_selected($VBoxContainer/FileChooser.selected_path)
	choice_dialog.hide()


func _on_NewCopy_pressed():
	dialog.mode = FileDialog.MODE_SAVE_FILE
	choice_dialog.hide()
	dialog.popup()


func _on_FileDialog_file_selected(path):
	var page_sequence: Array = []
	for page in page_collection.get_children():
		page_sequence.append(page.page_number)
	ee_rearrange.execute({
		"input_file": file_chooser.selected_path,
		"pages": page_sequence,
		"output_file": path
	})
	Utility.show_dir(path)


func _on_Cancel_pressed():
	$WindowDialog.hide()


func _on_RemoveButton_pressed():
	pass # Replace with function body.



