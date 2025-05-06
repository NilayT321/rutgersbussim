extends VehicleBody3D

@export var steering_angle = 0.3
@export var max_rpm = 500
@export var brake_force = 100
@export var max_engine_force = 100

# Cameras
@onready var front_camera = $FrontCamera 
@onready var back_cam_pivot = $BackCamPivot
@onready var back_camera = $BackCamPivot/SpringArm3D/BackCamera

# The current camera mode 
# 0 = First person, 1 = back camera 
# Default is back camera
var camera_mode = 1 

func _ready():
	#set_linear_velocity(Vector3(0,0,0))
	#assert(linear_velocity != null)
	pass

func _physics_process(delta):
	# Steering amount 
	var steer = Input.get_axis("move_right", "move_left") * 0.7
	
	# Gradually improve the steering
	steering = lerp(steering, steer, delta)
	
	# Engine_force 
	engine_force = Input.get_axis("move_down", "move_up") * max_engine_force
	

# Camera logic 
func _unhandled_input(event: InputEvent):
	# Change camera mode 
	if event.is_action_pressed("change_camera"): 
		# 0 (Front) -> 1 (Back) or vice versa
		camera_mode = (camera_mode + 1) % 2
		
	# Back camera 
	if camera_mode == 1:
		back_camera.current = true 
		front_camera.current = false 
	else:
		back_camera.current = false 
		front_camera.current = true
