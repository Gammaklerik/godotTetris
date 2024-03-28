extends Control

@export var pause_menu : Control
@export var music_vol_slider : HSlider
@export var sfx_vol_slider : HSlider

var bg_music : AudioStreamPlayer
var clear_sfx : AudioStreamPlayer
var level_sfx : AudioStreamPlayer
var land_sfx : AudioStreamPlayer

var settings : Node

func _ready():
	bg_music = get_node("/root/bg_music")
	clear_sfx = get_node("/root/line_clear_sfx")
	level_sfx = get_node("/root/line_clear_sfx")
	land_sfx = get_node("/root/line_clear_sfx")
	settings = get_node("/root/Settings")
	
	if settings.bg_music_vol != null && settings.sfx_vol != null:
		settings.load()
		bg_music.volume_db = settings.bg_music_vol
		music_vol_slider.value = settings.bg_music_vol
		clear_sfx.volume_db = settings.sfx_vol
		level_sfx.volume_db = settings.sfx_vol
		land_sfx.volume_db = settings.sfx_vol
		sfx_vol_slider.value = settings.sfx_vol

func _on_to_menu_pressed():
	settings.save()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_back_pressed():
	self.visible = false
	pause_menu.visible = true

func _on_music_vol_slider_drag_ended(value_changed):
	settings.bg_music_vol = music_vol_slider.value
	bg_music.volume_db = music_vol_slider.value

func _on_sfx_vol_slider_drag_ended(value_changed):
	settings.sfx_vol = sfx_vol_slider.value
	clear_sfx.volume_db = sfx_vol_slider.value
	level_sfx.volume_db = sfx_vol_slider.value
	land_sfx.volume_db = sfx_vol_slider.value
