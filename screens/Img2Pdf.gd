extends Control

onready var pcollection: GridContainer = $VBoxContainer/Control/ScrollContainer/PageCollection
var page_dragger_scene: PackedScene = preload("res://widgets/PageDragger.tscn")
var page_count: int
var page_holders: Array = []

onready var dialog: FileDialog = $SaveFileDialog
onready var open_dialog: FileDialog = $OpenFileDialog
onready var ee_img2pdf := $Img2Pdf
onready var page_collection := $VBoxContainer/Control/ScrollContainer/PageCollection
onready var save_button := $VBoxContainer/Button
onready var except_err := $ExceptionError
onready var drop_files_info := $DropFilesInfo


func _update_drop_info():
	if page_collection.get_child_count() == 0:
		drop_files_info.show()
		save_button.disabled = true
	else:
		drop_files_info.hide()
		save_button.disabled = false
		

func _ready():
	get_tree().connect("files_dropped", self, "_get_dropped_files_path")

func _get_dropped_files_path(files: PoolStringArray, _screen: int):
	var filtered_files: PoolStringArray = []
	for file in files: 
		if file.get_extension() in ["bmp", "png", "jpg", "jpeg"]:
			filtered_files.append(file)
	_on_OpenFileDialog_files_selected(filtered_files)
			
func _on_AddImg_pressed():
	open_dialog.mode = FileDialog.MODE_OPEN_FILES
	open_dialog.deselect_items()
	open_dialog.popup()
	
func _on_OpenFileDialog_files_selected(paths):
	var i = page_collection.get_child_count()
	for path in paths:
		var dragger: Control = page_dragger_scene.instance()
		dragger.page_number = i
		page_holders.append(dragger)
		page_collection.add_child(dragger)
		dragger.load_texture_from_img(path)
		i += 1
	page_collection.reset_neighbors()
	_update_drop_info()

func _on_Button_pressed():
	dialog.mode = FileDialog.MODE_SAVE_FILE
	dialog.deselect_items()
	dialog.popup()

func _clear_pages():
	for i in page_holders:
		page_collection.remove_child(i)
		i.queue_free()
	page_holders = []
	_update_drop_info()

func _on_command_failed(status_code, traceback):
	except_err.show_error(status_code, traceback)

func _on_embedding_error():
	except_err.show_error(-4, "Embedding error")


func _on_SaveFileDialog_file_selected(path):
	var img_pages: PoolStringArray = []
	for page in page_collection.get_children():
		img_pages.append(page.image_path)
	ee_img2pdf.execute(
		{
			"images": img_pages,
			"compress": true,
			"output_file": path
		}
	)
	


func _on_RemoveButton_on_delete(idx):
	page_collection.remove_child(page_collection.get_child(idx))
	_update_drop_info()


func _on_ClearImgs_pressed():
	_clear_pages()


func _on_Img2Pdf_command_successful(response):
	Utility.show_dir(response.get("output_file").get_base_dir())
