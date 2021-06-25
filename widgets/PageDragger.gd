extends "res://widgets/PageHolder.gd"

var dragger_scene = load("res://widgets/PageDragger.tscn")
var left_dragger: Button
onready var separator = $DropSeparator
enum {STATE_LEFT = 0, STATE_RIGHT = 1}
var state: int

func make_first():
	left_dragger = $DropSeparator2
	left_dragger.show()

func reset_first():
	$DropSeparator2.hide()

func get_drag_data(_pos):
	var drag: HBoxContainer = dragger_scene.instance()
	drag.rect_scale = Vector2(0.5, 0.5)
	set_drag_preview(drag)
	get_parent().set_drag_on(true)
	return get_index()

func can_drop_data(_pos, data):
	return typeof(data) == TYPE_INT

func _on_PageDragger_gui_input(event):
	if event is InputEventMouseMotion:
		if get_parent().drag_on:
			var is_left = get_local_mouse_position().x <= rect_size.x / 2
			separator.disabled = is_left
			if left_dragger != null:
				left_dragger.disabled = not is_left
			if is_left:
				state = STATE_LEFT
			else:
				state = STATE_RIGHT
		else:
			left_dragger.disabled = true
			separator.disabled = true

func drop_data(_pos, data):
	print("data:", data)
	print("page_number:", get_index())
	print("Right:", state == STATE_RIGHT)
	print("Left:", state == STATE_LEFT)
	var dropped = get_parent().get_child(data)
	var next_idx = get_index()
	if state == STATE_LEFT:
		if data < page_number:
			next_idx -= 1
	if state == STATE_RIGHT:
		if data > page_number:
			next_idx += 1
	next_idx = max(0, next_idx)
	get_parent().move_child(dropped, next_idx)
	get_parent().reset_neighbors()
	separator.disabled = true
	left_dragger.disabled = true
	get_parent().set_drag_on(false)


func _on_PageDragger_mouse_exited():
	separator.disabled = true
	if left_dragger != null:
		left_dragger.disabled = true
