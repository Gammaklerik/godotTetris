extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://level.tscn")

func _on_to_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
