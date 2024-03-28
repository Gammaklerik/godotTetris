extends TileMap

# SFX
var land_sfx : AudioStreamPlayer
var clear_sfx : AudioStreamPlayer

@export var game : Node2D
signal game_end

@export var pause_menu : Control

# Construction of the line piece and all its rotations
var line_0 = [Vector2i(1,0), Vector2i(0,0), Vector2i(2,0), Vector2i(3,0)]
var line_90 = [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)]
var line_180 = [Vector2i(1,0), Vector2i(0,0), Vector2i(2,0), Vector2i(3,0)]
var line_270 = [Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3)]
var line_piece = [line_0, line_90, line_180, line_270]
# Construction of the T piece and all its rotations
var t_0 = [Vector2i(1,1), Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)]
var t_90 = [Vector2i(1,1), Vector2i(0,1), Vector2i(1,0), Vector2i(1,2)]
var t_180 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(2,1)]
var t_270 = [Vector2i(2,1), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)]
var t_piece = [t_0, t_90, t_180, t_270]
# Construction of the square piece and all its rotations
var square_0 = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var square_90 = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var square_180 = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var square_270 = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]
var square_piece = [square_0, square_90, square_180, square_270]
# Construction of the z piece and all its rotations
var z_0 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,0), Vector2i(2,1)]
var z_90 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(0,2)]
var z_180 = [Vector2i(1,1), Vector2i(0,0), Vector2i(1,0), Vector2i(2,1)]
var z_270 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(0,2)]
var z_piece = [z_0, z_90, z_180, z_270]
# Construction of the s piece and all its rotations
var s_0 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(2,0)]
var s_90 = [Vector2i(1,1), Vector2i(1,0), Vector2i(2,1), Vector2i(2,2)]
var s_180 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(2,0)]
var s_270 = [Vector2i(1,1), Vector2i(1,0), Vector2i(2,1), Vector2i(2,2)]
var s_piece = [s_0, s_90, s_180, s_270]
# Construction of the L piece and all its rotations
var l_0 = [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(2,0)]
var l_90 = [Vector2i(0,0), Vector2i(0,1), Vector2i(0,2), Vector2i(1,2)]
var l_180 = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(2,0)]
var l_270 = [Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)]
var l_piece = [l_0, l_90, l_180, l_270]
# Construction of the J piece and all its rotations
var j_0 = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(2,1)]
var j_90 = [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(0,2)]
var j_180 = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
var j_270 = [Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(0,2)]
var j_piece = [j_0, j_90, j_180, j_270]

var pieces = [line_piece, t_piece, square_piece, z_piece, l_piece, s_piece, j_piece]

var rows : int = 20
var cols : int = 10

var atlas : Vector2i
var piece_type
var active_piece

var start_pos = Vector2i(5,0)
var cur_pos : Vector2i
var rotation_index : int = 0

var filled_cells

var playing : bool = true

func _ready():
	land_sfx = get_node("/root/piece_land_sfx")
	clear_sfx = get_node("/root/line_clear_sfx")

func start_game():
	new_piece()

func _process(delta):
	if Input.is_action_just_pressed("escape") && !playing:
		resume()
	elif Input.is_action_just_pressed("escape"):
		pause()
	
	if playing:
		if Input.is_action_just_pressed("rotate"):
			if ((rotation_index + 1) == 4):
				if !is_overlapping(active_piece, piece_type[0], cur_pos, Vector2i(0,0)):
					erase_piece(active_piece, cur_pos)
					rotation_index = 0
				# If overlap occurs, it is then checked if shifting the piece left or right will make it fit
				# this is done to ensure pieces can still be rotated against a wall that otherwise wouldn't allow it
				else:
					if !is_overlapping(active_piece, piece_type[0], cur_pos, Vector2i(1,0)):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(1,0)
						rotation_index = 0
					elif !is_overlapping(active_piece, piece_type[0], cur_pos, Vector2i(-1,0)):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(-1,0)
						rotation_index = 0
					elif piece_type == line_piece && !is_overlapping(active_piece, piece_type[0], cur_pos, Vector2i(3,0)) && !(cur_pos.x >= 11):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(3,0)
						rotation_index = 0
					elif piece_type == line_piece && !is_overlapping(active_piece, piece_type[0], cur_pos, Vector2i(-3,0)) && !(cur_pos.x <= 0):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(-3,0)
						rotation_index = 0
			else:
				if !is_overlapping(active_piece, piece_type[rotation_index + 1], cur_pos, Vector2i(0,0)):
					erase_piece(active_piece, cur_pos)
					rotation_index += 1
				# If overlap occurs, it is then checked if shifting the piece left or right will make it fit
				# this is done to ensure pieces can still be rotated against a wall that otherwise wouldn't allow it
				else:
					if !is_overlapping(active_piece, piece_type[rotation_index + 1], cur_pos, Vector2i(1,0)):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(1,0)
						rotation_index += 1
					elif !is_overlapping(active_piece, piece_type[rotation_index + 1], cur_pos, Vector2i(-1,0)):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(-1,0)
						rotation_index += 1
					elif piece_type == line_piece && !is_overlapping(active_piece, piece_type[rotation_index + 1], cur_pos, Vector2i(2,0)) && !(cur_pos.x >= 11):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(2,0)
						rotation_index += 1
					elif piece_type == line_piece && !is_overlapping(active_piece, piece_type[rotation_index + 1], cur_pos, Vector2i(-2,0)) && !(cur_pos.x <= 0):
						erase_piece(active_piece, cur_pos)
						cur_pos += Vector2i(-2,0)
						rotation_index += 1
		if Input.is_action_just_pressed("shift_left"):
			if !is_overlapping(active_piece, active_piece, cur_pos, Vector2i(-1,0)):
				erase_piece(active_piece, cur_pos)
				cur_pos += Vector2i(-1,0)
		if Input.is_action_just_pressed("shift_right"):
			if !is_overlapping(active_piece, active_piece, cur_pos, Vector2i(1,0)):
				erase_piece(active_piece, cur_pos)
				cur_pos += Vector2i(1,0)
		if Input.is_action_just_pressed("shift_down"):
			if !is_overlapping(active_piece, active_piece, cur_pos, Vector2i(0,1)):
				erase_piece(active_piece, cur_pos)
				cur_pos += Vector2i(0,1)
			# If the piece is overlapping on the way down that means it has hit
			# the lowest point it can and must be fully placed with a new piece to be created
			else:
				land_piece()
		if Input.is_action_just_pressed("drop"):
			# Iterate through each row from top to bottom checking if there is
			# empty space for the piece to go, as well as ground for the piece to land on.
			var r = range(rows)
			for i in r:
				if !is_overlapping(active_piece, active_piece, cur_pos, Vector2i(0,i)) && is_overlapping(active_piece, active_piece, cur_pos, Vector2i(0,i + 1)):
					erase_piece(active_piece, cur_pos)
					cur_pos += Vector2i(0,i)
					land_piece()
					break
		active_piece = piece_type[rotation_index]
		draw_piece(active_piece, cur_pos, atlas)
# Create a new piece at the set starting position with no rotation
func new_piece():
	piece_type = pick_piece()
	cur_pos = start_pos
	active_piece = piece_type[rotation_index]
	if is_overlapping(active_piece, active_piece, cur_pos, Vector2i(0,0)):
		end_game()
	else:
		draw_piece(active_piece, cur_pos, atlas)
		$fall_timer.start()
# Select a piece at random from the list initialized at the top of the script
# the index of the piece aligns with a tile on the atlas so colors on each piece always match
func pick_piece():
	var tile_index = randi_range(0,6)
	atlas = Vector2i(tile_index, 0)
	return pieces[tile_index]
# Draw the tiles of the piece based on the given piece, its position, and the tile it used from the atlas
func draw_piece(piece, pos, atlas):
	for i in piece:
		set_cell(1, pos + i, 0, atlas)
# Erase all the tiles of a piece based on the given piece and its position
func erase_piece(piece, pos):
	for i in piece:
		erase_cell(1, pos + i)
# Check if the piece is about to move into a cell that is already filled
func is_overlapping(old_piece, changed_piece, pos, shift):
	filled_cells = get_used_cells(1)
	# Compares each of the cells in the piece with the cells used in the level,
	# which includes the cells of the piece itself, this is done to ensure it doesn't
	# constantly overlap.
	for i in old_piece:
		if filled_cells.has(pos + i):
			filled_cells.erase(pos + i)
	# Once the previous position of the piece is removed from the used cells,
	# the new placement of the piece is cross referenced with all the used cells to ensure it doesn't overlap on its new placement
	for i in changed_piece:
		if filled_cells.has(pos + i + shift):
			return true
	return false

func land_piece():
	draw_piece(active_piece, cur_pos, atlas)
	land_sfx.play()
	checklines()
	$fall_timer.stop()
	if playing:
		new_piece()

# Check every row and see if it is full
func checklines():
	filled_cells.clear()
	filled_cells = get_used_cells(1)
	var full_rows : int = 0 # Used to count up the full rows and calculate points
	var first_clear : int = 0 # Determine where the row clear begins from the bottom of the level
	
	for i in filled_cells:
		if i.y == 0 && i.x != 0 && i.x != 11:
			end_game()

	for i in filled_cells:
		if i.y == 20 || i.x == 11 || i.x == 0:
			filled_cells.erase(i)
	
	# Iterate through every row from top to bottom
	for r in range(rows):
		var used_cells = 0
		# Iterate through every cell of the current row
		for c in range(cols):
			# Iterate through every used cell
			if filled_cells.has(Vector2i(c + 1, r)):
				used_cells += 1
		# If 'used_cells' matches the amount of columns possible in a row, then the row is full and then deleted
		if used_cells == cols:
			for c in range(cols):
				erase_cell(1, Vector2i(c + 1, r))
			if r > first_clear:
				first_clear = r
			full_rows += 1
	if full_rows > 0:
		clear_sfx.play()
		game.add_score(full_rows)
		shift_lines(full_rows, first_clear)

func shift_lines(rows_cleared, first_cleared_row):
	var row_num = first_cleared_row
	while row_num >= 0:
		var col_num = cols
		var debris = get_used_cells(1)
		while col_num > 0:
			if debris.has(Vector2i(col_num, row_num)):
				var i : int = rows_cleared
				while i > 0:
					# If the row space is used and there is enought empty space below it to shift, then it will
					if !debris.has(Vector2i(col_num, row_num + i)) && !((row_num + i) > first_cleared_row):
						var atlas_coords = get_cell_atlas_coords(1, Vector2i(col_num, row_num))
						erase_cell(1, Vector2i(col_num, row_num))
						set_cell(1, Vector2i(col_num, row_num + i), 0, atlas_coords)
						break
					i -= 1
			col_num -= 1
		row_num -= 1

func end_game():
	playing = false
	game_end.emit()
	$fall_timer.stop()

func pause():
	playing = false
	$fall_timer.stop()
	pause_menu.visible = true

func resume():
	playing = true
	$fall_timer.start()
	pause_menu.visible = false

func _on_fall_timer_timeout():
	erase_piece(active_piece, cur_pos)
	if !is_overlapping(active_piece, active_piece, cur_pos, Vector2i(0,1)):
		erase_piece(active_piece, cur_pos)
		cur_pos += Vector2i(0,1)
		draw_piece(active_piece, cur_pos, atlas)
	else:
		land_piece()
