extends CharacterBody3D

# Player speed and velocity
@export var speed = 14

@onready var camera = $Camera3D

# Camera speed and velocity
@export var camera_sensitivty = 0.001

func _physics_process(delta: float) -> void:
	move_player()
	
func move_player():
	# The input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed 
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Start capturing mouse inputs
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		# Release the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			# The neck should rotate about the y-axis
			rotate_y(-event.relative.x * camera_sensitivty)
			
			# The camera should rotate about the x-axis
			camera.rotate_x(-event.relative.y * camera_sensitivty)
			
			# Clamp the camera's rotation. We don't want the neck to rotate too much
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
