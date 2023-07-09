extends RigidBody2D

var engine = Vector2(0, -3000)
var torque = 40000
var rotation_dir
var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Rotation
	rotation_dir = 0
	if Input.is_action_pressed("left"):
		rotation_dir = -1
	elif Input.is_action_pressed("right"):
		rotation_dir = 1
	
	# Compute movement
	if Input.is_action_pressed("accelerate"):
		apply_central_force(engine.rotated(rotation))
	elif Input.is_action_pressed("decelerate"):
		apply_central_force(-engine.rotated(rotation))
		rotation_dir *= -1
		
	# I hate this so much
	if linear_velocity.x < -20 || linear_velocity.x > 20 || linear_velocity.y < -20 || linear_velocity.y > 20:
		apply_torque(rotation_dir * torque)

func _process(delta):
	# Honking
	if Input.is_action_just_pressed("honk"): # Single-fire detection
		$Horn.play()
	if Input.is_action_pressed("honk") && Engine.get_process_frames() % 5 == 0: # Continuous detection, every 5 frames for efficiency
		detectCivs()
	if Input.is_action_just_released("honk"):
		$Horn.stop()
	
	# Every few frames, check if a player has gotten close to a civ without honking. Move out of the way 
	if Engine.get_process_frames() % 5 == 0:
		detectCivs()
	
func detectCivs():
	for i in get_parent().get_children():
		if i.is_in_group("civillians") && $CloseArea.overlaps_body(i):
			i.honked_at(global_position)

# This function and associated Area2D shouldn't have to exist, but godot isn't playing nice today
func _on_collision_workaround_area_body_entered(body):
	if body.is_in_group("civillians"): # Is the thing we hit a civillian
		if linear_velocity.length() > 300 && !body.dead: # Did we hit it hard enough to kill it?
			body.die()
			
	else: # If it isn't a civillian, it should be a wall or debris
		if linear_velocity.length() > 300: # Did we hit it hard enough to damage us?
			# FIXME this code doesn't work probably because the collision zeroes the velocity before this check happens
			takeDamage()
		else:
			print("didn't hit wall hard enough")

func takeDamage():
	# Apply damage to health
	health -= 1
	$"../../HUD/HealthLabel".set_text("Health: " + str(health))
	
	if health == 0: # Are we dead now?
		get_parent().gameOver()
	
