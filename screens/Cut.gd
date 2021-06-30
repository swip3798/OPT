extends Control

var page_holders: Array = []
var page_holder_scene: PackedScene = preload("res://widgets/PageHolder.tscn")
var cut_point: int
var page_count: int

onready var dialog: FileDialog = $FileDialog
onready var file_chooser: HBoxContainer = $VBoxContainer/FileChooser
onready var page_collection: Container = $VBoxContainer/ScrollContainer/PageCollection
onready var ee_render_thumbs := $RenderThumbs
onready var ee_cut_pdf := $CutPdf
onready var except_err := $ExceptionError
onready var drop_files_info := $DropFilesInfo

func _ready():
	get_tree().connect("files_dropped", self, "_get_dropped_files_path")

func _get_dropped_files_path(files: PoolStringArray, _screen: int):
	for file in files: 
		if file.get_extension() == "pdf":
			file_chooser.set_selected_path(file)
			break

# Opening and page rendering
func _on_FileChooser_valid_file_selected(path):
	ee_render_thumbs.execute({"input_file": path})
	drop_files_info.hide()
	
func _on_RenderThumbs_command_successful(response):
	for i in page_holders:
		page_collection.remove_child(i)
		i.queue_free()
	page_holders = []
	var i = 0
	for thumbnail_b64 in response.get("thumbnails", []):
		var holder: Control = page_holder_scene.instance()
		holder.page_number = i
		page_holders.append(holder)
		page_collection.add_child(holder)
		holder.load_texture(thumbnail_b64)
		holder.connect("cut_point_changed", self, "_on_cut_point_changed")
		i += 1
	page_collection.get_child(page_collection.get_child_count() - 1).make_last()

func _on_cut_point_changed(page_number):
	$VBoxContainer/Cut.disabled = false
	cut_point = page_number
	for i in range(page_number + 1, page_collection.get_child_count()):
		page_collection.get_child(i).set_alpha(0.5)
	for i in range(0, page_number + 1):
		page_collection.get_child(i).set_alpha(1)

func _on_Cut_pressed():
	if page_collection.get_child_count() > 0:
		dialog.deselect_items()
		dialog.mode = FileDialog.MODE_OPEN_DIR
		dialog.popup()

func _on_FileDialog_dir_selected(dir):
	var output_prefix: String = dir + "/" + file_chooser.selected_path.get_file().get_basename()
	var args: Array = Utility.cut_document(cut_point, page_collection.get_child_count(), output_prefix)
	for arg in args:
		ee_cut_pdf.execute({
			"input_file": file_chooser.selected_path,
			"pages": arg[0],
			"output_file": arg[1]
		})


func _on_CutPdf_command_successful(response):
	Utility.show_dir(response.get("output_file").get_base_dir())

func _on_command_failed(status_code, traceback):
	except_err.show_error(status_code, traceback)

func _on_embedding_error():
	except_err.show_error(-4, "Embedding error")
