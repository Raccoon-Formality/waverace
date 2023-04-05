extends CharacterBody3D


const SPEED = 5.0
const FAST_SPEED = 10.0
const JUMP_VELOCITY = 5.0

var current_speed = 0.0

@onready var camerabase = $CameraBase

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var global_delta = 0

var mouse_sensistivity = 0.2

func _ready():
	Input.mouse_mode = 2

func _input(event):
	if event is InputEventMouseMotion:
		camerabase.rotation.x -= deg_to_rad(event.relative.y * mouse_sensistivity * 1)
		camerabase.rotation.x = clamp(camerabase.rotation.x, deg_to_rad(-45), deg_to_rad(15))
		rotation.y -= deg_to_rad(event.relative.x * 1 * mouse_sensistivity)

func _physics_process(delta):
	global_delta = delta
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	current_speed = SPEED
	# run
	if Input.is_action_pressed("shift"):
		current_speed = FAST_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		$AnimationPlayer.play("walk_up")
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.25)
		velocity.z = lerp(velocity.z, 0.0, 0.25)
		$AnimationPlayer.play("idle")

	move_and_slide()




func _on_area_3d_body_entered(body):
	print("fuck")
	if body.is_in_group("water"):
		
		velocity.y += gravity*1.2 * global_delta
