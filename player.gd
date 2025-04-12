extends CharacterBody3D

# Player speed and velocity
@export var speed = 14

# Variable to see if the camera should be in FP/TP 
# 0 = FP, 1 = TP 
var camera_mode = 0

# First person camera
@onready var camera = $FPCamera

# Third person camera
@onready var tp_camera_pivot = $TPCameraPivot
@onready var tp_camera = $TPCameraPivot/SpringArm3D/TPCamera

# Camera speed and velocity
@export var camera_sensitivty = 0.001

# Quit game on hitting escape 
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Change camera modes 
	if Input.is_action_pressed("change_camera"):
		# Change camera mode. 0 (FP) -> 1 (TP) or 1 (TP) -> 0 (FP)
		camera_mode = (camera_mode + 1) % 2
		
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
	# First person camera logic 
	if camera_mode == 0:
		# Set the camera to current. This automatically deselects the other camera
		camera.current = true
		
		# Start capturing the mouse 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				# The neck should rotate about the y-axis
				rotate_y(-event.relative.x * camera_sensitivty)
				
				# The camera should rotate about the x-axis
				camera.rotate_x(-event.relative.y * camera_sensitivty)
				
				# Clamp the camera's rotation. We don't want the neck to rotate too much
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
				
	# Third person camera logic 
	if camera_mode == 1:
		# Lock the mouse. We don't want it to move. 
		# Instead, we want the camera to follow the player
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		# Set the tp_camera to true. This automatically disables the other camera.
		tp_camera.current = true
		
		
