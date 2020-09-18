extends Control

var page_holder: Array = []
var page_holder_scene: PackedScene = preload("res://widgets/PageHolder.tscn")
onready var page_collection: Container = $VBoxContainer/ScrollContainer/PageCollection
var cut_point: int
var page_count: int
onready var dialog: FileDialog = $FileDialog
onready var file_chooser: HBoxContainer = $VBoxContainer/FileChooser

func _on_FileChooser_valid_file_selected(path):
	Utility.clear_thumbnail_path()
	for i in page_holder:
		i.free()
# warning-ignore:return_value_discarded
	PdfBackend.render_thumbnails(path)
	page_count = PdfBackend.get_page_count(path)
	for i in range(page_count):
		var holder: Control = page_holder_scene.instance()
		holder.page_number = i
		page_holder.append(holder)
		page_collection.add_child(holder)
		holder.load_texture()
# warning-ignore:return_value_discarded
		holder.connect("cut_point_changed", self, "_on_cut_point_changed")
	page_collection.get_child(page_collection.get_child_count() - 1).make_last()

func _on_cut_point_changed(page_number):
	print(page_number)
	cut_point = page_number
	for i in range(page_number + 1, page_collection.get_child_count()):
		page_collection.get_child(i).set_alpha(0.5)
	for i in range(0, page_number + 1):
		page_collection.get_child(i).set_alpha(1)

func _on_Cut_pressed():
	dialog.deselect_items()
	dialog.mode = FileDialog.MODE_OPEN_DIR
	dialog.show()

func _on_FileDialog_dir_selected(dir):
	var output_prefix: String = dir + "/" + file_chooser.selected_path.get_file().get_basename()
	PdfBackend.cut_document(file_chooser.selected_path, cut_point, page_count, output_prefix)
	Utility.show_dir(dir)
