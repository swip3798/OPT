extends Control

onready var pcollection: GridContainer = $PageCollection

func _ready():
	reset_neighbors()
	
func reset_neighbors():
	for idx in range(1, pcollection.get_child_count()):
		pcollection.get_child(idx).left_dragger = pcollection.get_child(idx - 1).separator
		pcollection.get_child(idx).reset_first()
	pcollection.get_child(0).make_first()
