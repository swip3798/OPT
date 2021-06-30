extends Control

const TARGET_HEIGHT: int = 200

export var page_number: int = 0
var cut_point: bool = false
var last: bool = false
var dragger_texture
var image_path: String

onready var tex_rect: TextureRect = $VBoxContainer/TextureRect
onready var label: Label = $VBoxContainer/Label

signal cut_point_changed(page_number)

func _ready():
	$VBoxContainer/Label.text = str(page_number)
	if dragger_texture != null:
		tex_rect.texture = dragger_texture

func load_texture(b64data: String):
	var buffer := Marshalls.base64_to_raw(b64data)
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load_png_from_buffer(buffer)
	texture.create_from_image(image, 0)
	tex_rect.texture = texture
	label.text = tr("page") + " " + str(page_number + 1)

func load_texture_from_img(path: String):
	image_path = path
	var image = Image.new()
	var texture = ImageTexture.new()
	image.load(path)
	var scaling_factor: float = float(TARGET_HEIGHT) / float(image.get_height())
	image.resize(int(image.get_width()*scaling_factor), TARGET_HEIGHT)
	texture.create_from_image(image, 0)
	tex_rect.texture = texture
	label.text = tr("page") + " " + str(page_number + 1)

func set_page_number(number: int):
	page_number = number
	label.text = tr("page") + " " + str(page_number + 1)

func make_last():
	last = true
	$Button.free()

func set_alpha(alpha):
	modulate.a = alpha

func _on_Button_pressed():
	cut_point = true
	emit_signal("cut_point_changed", page_number)


func _on_Button_focus_exited():
	cut_point = false
