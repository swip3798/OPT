extends GridContainer

var drag_on := false
export(NodePath) var removeButton

func _ready():
	removeButton = get_node(removeButton)

func set_drag_on(on: bool):
	drag_on = on
	if drag_on:
		removeButton.show()
	else:
		removeButton.hide()

func reset_neighbors():
	for idx in range(1, get_child_count()):
		get_child(idx).left_dragger = get_child(idx - 1).separator
		get_child(idx).reset_first()
	get_child(0).make_first()
