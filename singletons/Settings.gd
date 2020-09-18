extends Node

var global_dict: Dictionary 
const persistent_path = "user://settings.dat"

func _ready():
	global_dict = {
		"language": TranslationServer.get_locale()
	}
	_load_json()
	change_language(get_value("language"))

func set_value(name: String, value):
	global_dict[name] = value
	_save_json()
	
func get_value(name: String):
	return global_dict.get(name, null)
	
func change_language(locale: String):
	TranslationServer.set_locale(locale)
	set_value("language", locale)

func get_language() -> String:
	return TranslationServer.get_locale()
	
func _save_json():
	var json: String = JSON.print(global_dict)
	_save_file(json)

func _load_json():
	var json: String = _load_file()
	global_dict = JSON.parse(json).result

func _load_file():
	var file: File = File.new()
	if not file.file_exists(persistent_path):
		_save_json()
	file.open(persistent_path, File.READ)
	var content:String = file.get_as_text()
	file.close()
	return content

func _save_file(content: String):
	var file: File = File.new()
	file.open(persistent_path, File.WRITE)
	file.store_string(content)
	file.close()
