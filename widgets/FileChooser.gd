extends HBoxContainer

export(NodePath) var dialog_path
export var info_text_key: String = "choose_pdf_file"
var dialog: FileDialog
var selected_path: String

signal valid_file_selected(path)

func _ready():
	dialog = get_node(dialog_path)
	dialog.connect("file_selected", self, "_on_file_selected")
	
func _validate_and_emit(path):
	var file = File.new()
	if file.file_exists(path):
		selected_path = path
		emit_signal("valid_file_selected", path)

func _on_TextEdit_text_changed():
	_validate_and_emit($TextEdit.text)

func _on_Browse_pressed():
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.deselect_items()
	dialog.dialog_text = tr(info_text_key)
	dialog.popup()

func _on_file_selected(path):
	if dialog.mode == FileDialog.MODE_OPEN_FILE:
		$TextEdit.text = path
		_validate_and_emit(path)
