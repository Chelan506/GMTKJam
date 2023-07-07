extends Area2D

var speed = 0
@export var speedOffset = 2;
@export var rotationOffset = 1;
signal honk

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Compute movement
	var velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta * speedOffset
	
	# Check for input
	
	# Acceleration and deceleration
	if Input.is_action_pressed("accelerate"):
		speed += 3 * lookupSpeedTable(speed)
		if speed < 0: # We can accelerate much faster if we're braking
			speed += 5
	elif Input.is_action_pressed("decelerate"):
		speed -= 2 * lookupSpeedTable(speed)
		if speed > 0: # We can decelerate much faster if we're braking
			speed -= 5
	else: # Neither accelerating nor decelerating, car will slow to halt
		if speed > -1 && speed < 1: # Stop the car completely if we're moving very slow
			speed = 0
		if speed > 0:
			speed -= 1
		elif speed < 0:
			speed += 1
	
	# Rotation
	if Input.is_action_pressed("left") && speed != 0:
		if speed > 0:
			rotation -= 2 * delta * rotationOffset
		else:
			rotation += 2 * delta * rotationOffset
	elif Input.is_action_pressed("right") && speed != 0:
		if speed > 0:
			rotation += 2 * delta * rotationOffset
		else:
			rotation -= 2 * delta * rotationOffset
	
	# Honking
	if Input.is_action_just_pressed("honk"):
		honk.emit()
	
	# Debug
	print(speed)

func lookupSpeedTable(val):
	# Speed multiplier so that the car can't go too fast
	if val > 0:
		if val < 60:
			return 1
		elif val < 100:
			return 0.8
		elif val < 225:
			return 0.5
		else:
			return 0;
	elif val < 0:
		if val > -10:
			return 1
		elif val > -25:
			return 0.8
		elif val > -50:
			return 0.5
		else:
			return 0;
	else:
		return 1;

