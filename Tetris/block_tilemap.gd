extends TileMap

# Construction of the line piece and all its rotations
var line_0 = [Vector2i(1,0), Vector2i(0,0), Vector2i(2,0), Vector2i(3,0)]
var line_90 = [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)]
var line_180 = [Vector2i(1,0), Vector2i(0,0), Vector2i(2,0), Vector2i(3,0)]
var line_270 = [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)]
var line_piece = [line_0, line_90, line_180, line_270]
# Construction of the T piece and all its rotations
var t_0 = [Vector2i(1,1), Vector2i(0,0), Vector2i(1,0), Vector2i(2,0)]
var t_90 = [Vector2i(1,1), Vector2i(0,1), Vector2i(1,0), Vector2i(1,2)]
var t_180 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(2,1)]
var t_270 = [Vector2i(1,1), Vector2i(0,1), Vector2i(1,0), Vector2i(2,1)]
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
var z_270 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,0), Vector2i(2,1)]
var z_piece = [z_0, z_90, z_180, z_270]
# Construction of the s piece and all its rotations
var s_0 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(2,0)]
var s_90 = [Vector2i(1,1), Vector2i(1,0), Vector2i(2,1), Vector2i(2,2)]
var s_180 = [Vector2i(1,1), Vector2i(1,0), Vector2i(0,1), Vector2i(2,0)]
var s_270 = [Vector2i(1,1), Vector2i(1,0), Vector2i(2,1), Vector2i(2,2)]
var s_piece = [s_0, s_90, s_180, s_270]
# Construction of the L piece and all its rotations
var l_0 = [Vector2i(0,0), Vector2i(0,1), Vector2i(0,2), Vector2i(1,2)]
var l_90 = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(2,0)]
var l_180 = [Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)]
var l_270 = [Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(2,0)]
var l_piece = [l_0, l_90, l_180, l_270]
# Construction of the J piece and all its rotations
var j_0 = [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(0,2)]
var j_90 = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)]
var j_180 = [Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(2,0)]
var j_270 = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(2,1)]
var j_piece = [j_0, j_90, j_180, j_270]

var pieces = [line_piece, t_piece, square_piece, z_piece, l_piece, s_piece, j_piece]

var atlas : Vector2i
var piece_type

func _ready():
	piece_type = pick_piece()

func _process(delta):
	draw_piece(piece_type[0], Vector2i(6,0), atlas)

func pick_piece():
	var tile_index = randi_range(0,6)
	atlas = Vector2i(tile_index, 0)
	
	return pieces[tile_index]

func draw_piece(piece, pos, atlas):
	for i in piece:
		set_cell(1, pos + i, 0, atlas)
