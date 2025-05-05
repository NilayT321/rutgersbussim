extends VehicleBody3D

@export var steering_angle = 0.3
@export var max_rpm = 500
@export var brake_force = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta):
	# Steering amount 
	var steer = Input.get_axis("move_right", "move_left") * 0.4
	steering = lerp(steering, steer, delta)
	
	# Engine_force 
	engine_force = Input.get_axis("move_down", "move_up") * 100
