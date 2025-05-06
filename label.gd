extends Label

@onready var bus = get_node("/root/MainMap/Bus")

# Called when the node enters the scene tree for the first time.
func _onready() -> void:
	if bus != null:
		print("Bus not null!")
		
	set_text("Speed: %s" % 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	set_text("Speed: %.1f" % bus.linear_velocity.length())
