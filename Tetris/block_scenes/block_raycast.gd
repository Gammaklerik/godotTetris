extends ShapeCast2D

signal shape_cast

func _ready():
	#self.shape_cast.connect(shape_casted)
	pass

func _physics_process(delta):
	var col = get_collider(0)
	if col == null:
		print("didn't hit shit")
	else:
		print(col.name)

func shape_casted(normal: Vector2, collider: Node, collider_shape: int, self_shape: int):
	if collider is Node:
		print(collider.name)
