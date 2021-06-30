extends Button

onready var page_collection: GridContainer

signal on_delete(idx)

func drop_data(_pos, data):
	emit_signal("on_delete", data)


func can_drop_data(_pos, data):
	return true
