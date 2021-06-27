extends FileDialog

func _ready():
	current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)

func popup(bounds: Rect2=Rect2( 0, 0, 0, 0 )):
	get_cancel().text = tr("cancel")
	.popup(bounds)
