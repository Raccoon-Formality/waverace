extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var counter = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += 1
	var t = cos((delta * counter * 0.1) * TAU * 2.0) * 0.25
	
	var t2 =  cos((0.2 + delta*counter * 0.1) * TAU * 2.0) * 0.25
	
	rotation.x += t * delta * cos(position.x)
	rotation.z += t2 * delta * cos(position.z)
