extends Control

@export var map : Node
@export var options_menu : Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://level.tscn")

func _on_resume_pressed():
	map.resume()

func _on_options_pressed():
	self.visible = false
	options_menu.visible = true

func _on_quit_pressed():
	get_tree().quit()
