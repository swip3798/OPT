extends Control

export var page_number: int = 0
var cut_point: bool = false
var last: bool = false

signal cut_point_changed(page_number)

func _ready():
	$VBoxContainer/Label.text = str(page_number)

func load_texture():
	$VBoxContainer/TextureRect.texture = PdfBackend.get_thumbnail(page_number)
	$VBoxContainer/Label.text = str(page_number)
	
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
