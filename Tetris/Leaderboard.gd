extends Node

var save_path := "res://leaderboard_data.json"

var scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

func save_score(score):
	if FileAccess.file_exists(save_path):
		load_file()
	var scored : bool = false
	for i in scores:
		if scored == false:
			if score >= i:
				var index : int = scores.find(i)
				var x : int = scores.size() - 1
				while x >= index:
					if x != scores.size() - 1:
						scores[x + 1] = scores[x]
					x -= 1
				scores[index] = score
				scored = true
	var data := {
		"scores" : scores
	}
	
	var json_string := JSON.stringify(data)
	
	var file_access := FileAccess.open(save_path, FileAccess.WRITE)
	if not file_access:
		print("ERROR")
		return
	
	file_access.store_line(json_string)
	file_access.close()

func load_file():
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
	var i : int = data.get("scores").size() - 1
	while i >= 0:
		scores[i] = int(data.get("scores")[i])
		i -= 1
