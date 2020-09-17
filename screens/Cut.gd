extends Control

var page_holder: Array = []
var page_holder_scene: PackedScene = preload("res://widgets/PageHolder.tscn")
onready var page_collection: Container = $VBoxContainer/ScrollContainer/PageCollection
var cut_point: int

func _on_FileChooser_valid_file_selected(path):
	Utility.clear_thumbnail_path()
	PdfBackend.render_thumbnails(path)
	var page_count: int = PdfBackend.get_page_count(path)
	for i in range(page_count):
		var holder: Control = page_holder_scene.instance()
		holder.page_number = i
		page_holder.append(holder)
		page_collection.add_child(holder)
		holder.load_texture()
		holder.connect("cut_point_changed", self, "_on_cut_point_changed")
	page_collection.get_child(page_collection.get_child_count() - 1).make_last()

func _on_cut_point_changed(page_number):
	print(page_number)
	cut_point = page_number
	for i in range(page_number + 1, page_collection.get_child_count()):
		page_collection.get_child(i).set_alpha(0.5)
	for i in range(0, page_number + 1):
		page_collection.get_child(i).set_alpha(1)
