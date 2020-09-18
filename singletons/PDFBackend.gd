extends Node

var thumbnail_path = "user://thumbnails/"

func _ready():
	thumbnail_path = ProjectSettings.globalize_path(thumbnail_path)
	var dir: Directory = Directory.new()
	dir.make_dir_recursive(thumbnail_path)

func merge_docs(doc_paths: Array, output_path: String) -> Array:
	var output = []
	doc_paths.append(output_path)
	OS.execute("mergedoc", doc_paths, true, output, true)
	return output

func render_thumbnails(path: String) -> Array:
	var output: Array = []
	OS.execute("renderthumbnails", [path, thumbnail_path], true, output, true)
	return output

func get_thumbnail_path() -> String:
	return thumbnail_path
	
func get_thumbnail(page_number: int) -> Texture:
	var texture = ImageTexture.new();
	var image = Image.new();
	image.load(thumbnail_path + str(page_number) + ".png");
	texture.create_from_image(image,0);
	return texture
	
func get_page_count(path: String) -> int:
	var output: Array = []
	OS.execute("docinfo", [path], true, output, true)
	return int(output[0])

func select_pages(path: String, page_sequence: Array, output_path: String) -> Array:
	var output: Array = []
	var arguments: Array = [path]
	for i in range(len(page_sequence)):
		arguments.append(str(page_sequence[i]))
	arguments.append(output_path)
	OS.execute("pageselect", arguments, true, output, true)
	return output

func cut_document(path: String, cut_point_inc: int, page_count: int, output_prefix: String):
	var page_sequence1: Array = []
	for i in range(cut_point_inc + 1):
		page_sequence1.append(i)
	var page_sequence2: Array = []
	for i in range(cut_point_inc + 1, page_count):
		page_sequence2.append(i)
	select_pages(path, page_sequence1, output_prefix + "-1.pdf")
	select_pages(path, page_sequence2, output_prefix + "-2.pdf")
