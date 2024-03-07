extends Node

var block_list = [preload("res://block_scenes/line_block.tscn"), preload("res://block_scenes/square_block.tscn"), preload("res://block_scenes/l_block_right.tscn"), preload("res://block_scenes/l_block_left.tscn"), preload("res://block_scenes/squiggle_block_right.tscn"), preload("res://block_scenes/squiggle_block_left.tscn"), preload("res://block_scenes/t_block.tscn")]

var block

var level_size

# Called when the node enters the scene tree for the first time.
func _ready():
	level_size = Vector2(500, 648)
	new_block()

func _process(delta):
	if block != null:
		if Input.is_action_just_pressed("rotate"):
			block.rotation += deg_to_rad(90)
		if Input.is_action_just_pressed("shift_left"):
			block.global_position += Vector2(-50, 0)
		if Input.is_action_just_pressed("shift_right"):
			block.global_position += Vector2(50, 0)
		if Input.is_action_just_pressed("shift_down"):
			block.global_position += Vector2(0, 50)
		if Input.is_action_just_pressed("drop"):
			# Drop the block immediately down and place it on the map
			pass

func new_block():
	block = block_list[randf_range(0, 6)].instantiate()
	add_child(block)
	block.global_position = Vector2(250, -50)
	block.block_land.connect(_on_block_land)
	$fall_timer.start()

func _on_fall_timer_timeout():
	block.global_position += Vector2(0, 50)

func _on_block_land():
	block.block_land.disconnect(_on_block_land)
	$fall_timer.stop()
	new_block()
