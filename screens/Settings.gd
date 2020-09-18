extends VBoxContainer

func _ready():
	if TranslationServer.get_language() == "de":
		$HBoxContainer/OptionButton.select(1)
	else:
		$HBoxContainer/OptionButton.select(0)

func _on_OptionButton_item_selected(index):
	if index == 0:
		Settings.change_language("en")
	elif index == 1:
		Settings.change_language("de")
