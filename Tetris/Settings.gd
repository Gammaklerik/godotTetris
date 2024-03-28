extends Node

var save_path := "res://settings.json"

var bg_music_vol : int = -28
var sfx_vol : int = 0

func save():
	var data := {
		"bg_music_volume" : bg_music_vol,
		"sfx_music_volume" : sfx_vol
	}
	
	var json_string := JSON.stringify(data)
	
	var file_access := FileAccess.open(save_path, FileAccess.WRITE)
	if not file_access:
		print("ERROR")
		return
	
	file_access.store_line(json_string)
	file_access.close()

func load():
	if not FileAccess.file_exists(save_path):
		return
	var file_access := FileAccess.open(save_path, FileAccess.READ)
	var json_string := file_access.get_line()
	file_access.close()
	
	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("PARSE ERROR")
		return
	
	var data : Dictionary = json.data
	bg_music_vol = int(data.get("bg_music_volume"))
	sfx_vol = int(data.get("sfx_music_volume"))
