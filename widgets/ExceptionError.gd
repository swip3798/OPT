extends AcceptDialog

var message
var error_code: int

onready var label: Label = $VBoxContainer/Label
onready var message_box: RichTextLabel = $VBoxContainer/MessageBox

func show_error(error_code: int, message):
	self.error_code = error_code
	self.message = message
	self.label.text = TranslationServer.translate("error_occured_exception") + " (Code: " + str(self.error_code) + ")"
	if message == null:
		match error_code:
			-1:
				self.message_box.text = "OPT command not existing"
			-2:
				self.message_box.text = "No OPT command issued"
			-3:
				self.message_box.text = "JSON serialization failed"
	else:
		self.message_box.text = message
	self.show()


func _on_CheckButton_toggled(button_pressed):
	if button_pressed:
		message_box.size_flags_vertical = SIZE_EXPAND_FILL
	else:
		message_box.size_flags_vertical = SIZE_EXPAND
