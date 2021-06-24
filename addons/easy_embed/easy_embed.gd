tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here
	# Add the new type with a name, a parent type, a script and an icon
	add_custom_type("EasyEmbedClient", "Node", preload("EasyEmbedClient.gd"), preload("icon.svg"))
	add_custom_type("EasyEmbedCommand", "Node", preload("EasyEmbedCommand.gd"), preload("icon.svg"))
	add_custom_type("EEClientHTTP", "Node", preload("res://addons/easy_embed/HTTP/EEClientHTTP.gd"), preload("icon.svg"))
	add_custom_type("EECommandHTTP", "Node", preload("res://addons/easy_embed/HTTP/EECommandHTTP.gd"), preload("icon.svg"))
	add_autoload_singleton("EEBackendManager", "res://addons/easy_embed/singleton/EEBackendManager.gd")

func _exit_tree():
	# Clean-up of the plugin goes here
	# Always remember to remove it from the engine when deactivated
	remove_custom_type("EasyEmbedClient")
	remove_custom_type("EasyEmbedCommand")
	remove_custom_type("EEClientHTTP")
	remove_custom_type("EECommandHTTP")
	remove_autoload_singleton("EEBackendManager")
	
