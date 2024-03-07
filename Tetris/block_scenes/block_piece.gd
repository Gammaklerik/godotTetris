extends CollisionShape2D

# signal for returning raycast data

func _ready():
	pass

func _process(delta):
	print($block_raycast.get_collision_point(0))

