extends RigidBody2D

var engine = Vector2(0, -3000)
var torque = 40000
var rotation_dir
signal honk

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Compute movement
	if Input.is_action_pressed("accelerate"):
		apply_central_force(engine.rotated(rotation))
	elif Input.is_action_pressed("decelerate"):
		apply_central_force(-engine.rotated(rotation))
	
	# Rotation
	rotation_dir = 0
	if Input.is_action_pressed("left"):
		rotation_dir = -1
	elif Input.is_action_pressed("right"):
		rotation_dir = 1
		
	# I hate this so much
	if linear_velocity.x < -20 || linear_velocity.x > 20 || linear_velocity.y < -20 || linear_velocity.y > 20:
		apply_torque(rotation_dir * torque)

func _process(delta):
	# Honking
	if Input.is_action_just_pressed("honk"):
		honk.emit()
		$Horn.play()
	if Input.is_action_just_released("honk"):
		$Horn.stop()
		
	
	# Debug
	#print(speed)

