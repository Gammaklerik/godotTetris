extends Node2D

# UI Elements
@export var ui : Control
var score_text : Label
var level_text : Label
var score : int = 0
var level : int = 0
@export var game_over_ui : Control

# Tilemap
var fall_timer : Timer
var block_tilemap : TileMap

# Leaderboard
var leaderboard : Node
var leaderboard_text : RichTextLabel

# SFX
var level_up_sfx : AudioStreamPlayer

func _ready():
	score_text = $Level_UI/score_label
	level_text = $Level_UI/level_label
	block_tilemap = $Tilemap
	fall_timer = $Tilemap/fall_timer
	leaderboard = get_node("/root/leaderboard")
	leaderboard_text = $Game_Over_UI/leaderboard_text
	level_up_sfx = get_node("/root/level_up_sfx")
	new_game()

func new_game():
	$Tilemap.start_game()

func add_score(lines_cleared):
	if lines_cleared == 4:
		score += lines_cleared * 150
		score_text.text = "Score:\n" + var_to_str(score)
	else:
		score += lines_cleared * 100
		score_text.text = "Score:\n" + var_to_str(score)
	
	if score >= 1000:
		if ((score / 1000) + 1) > level:
			level_up_sfx.play()
			level = (score / 1000) + 1
			level_text.text = "Level:\n" + var_to_str(level)
			fall_timer.wait_time = fall_timer.wait_time * 0.80

# When the game end signal emits, the score of the game is shown, the score is saved in the leaderboard file
# the top 10 scores are then shown
func _on_tilemap_game_end():
	game_over_ui.get_node("final_score").text = "Score: " + var_to_str(score)
	leaderboard.save_score(score)
	print(leaderboard.scores)
	var i : int = 1
	var leaderboard_list : String
	while i <= leaderboard.scores.size():
		leaderboard_list += var_to_str(i) + ". " + var_to_str(leaderboard.scores[i - 1]) + "\n"
		i += 1
	leaderboard_text.text = leaderboard_list
	game_over_ui.visible = true
