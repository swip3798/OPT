extends Control

var in_resize: bool = false

enum STATE {
	UP,
	LEFT,
	RIGHT,
	DOWN,
	RIGHT_UP,
	RIGHT_DOWN,
	LEFT_UP,
	LEFT_DOWN
}

var current_mouse_state: int


func _ready():
	get_tree().get_root().set_transparent_background(true)

func _on_Minimize_pressed():
	OS.set_window_minimized(!OS.window_minimized)


func _on_Maximize_pressed():
	OS.set_window_maximized(!OS.window_maximized)


func _on_Exit_pressed():
	get_tree().quit()
	
func resize_mode():
	pass


func _on_CustomWindow_gui_input(event):
	if event is InputEventMouseMotion:
		print(event.global_position)
	elif event is InputEventMouseButton:
		print(event.button_index, event.pressed)
