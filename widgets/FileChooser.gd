extends HBoxContainer

export(NodePath) var dialog_path
var dialog: FileDialog

signal valid_file_selected(path)

func _ready():
	dialog = get_node(dialog_path)
	dialog.connect("file_selected", self, "_on_file_selected")
	
func _validate_and_emit(path):
	var file = File.new()
	if file.file_exists(path):
		emit_signal("valid_file_selected", path)

func _on_TextEdit_text_changed():
	_validate_and_emit($TextEdit.text)

func _on_Browse_pressed():
	dialog.show()

func _on_file_selected(path):
	$TextEdit.text = path
	_validate_and_emit(path)
