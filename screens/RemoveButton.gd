extends Button

onready var page_collection: GridContainer

func _ready():
	page_collection = get_node("../VBoxContainer/Control/ScrollContainer/PageCollection")

func drop_data(_pos, data):
	page_collection.remove_child(page_collection.get_child(data))


func can_drop_data(_pos, data):
	return true
