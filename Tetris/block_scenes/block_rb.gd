extends RigidBody2D

signal block_land

func _ready():
	pass
	
func _on_body_entered(body):
	#print("hit: " + str(global_position.y))
	#if (int(global_position.y) % 50) != 0:
		#global_position.y = int(int(global_position.y) - (int(global_position.y) % 50))
	#print("subtract: " + str(global_position.y))
	block_land.emit()
	name = "debris"
