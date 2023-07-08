extends CharacterBody2D

@export var movement_speed: float = 200
@export var movement_target = Node2D.new()
@export var navigation_agent = NavigationAgent2D.new()
var randAnimOffset
var rand = RandomNumberGenerator.new()

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	randAnimOffset = rand.randi_range(0,4)
	
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	
	set_movement_target(movement_target.global_position)

func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized() * movement_speed
	velocity = new_velocity
	move_and_slide()

func _process(delta):
	# Do animation in a 8 frame cycle
	# randAnimOffset so that not all civs are synced
	match (Engine.get_process_frames() + randAnimOffset) % 8:
		0:
			position.y += 5
		1:
			pass
		2:
			position.y += 3
		3:
			pass
		4:
			position.y -= 3
		5:
			pass
		6: 
			position.y -= 5
		7: 
			pass
	
func test_function():
	print("I am dead now")
	
func honked_at():
	print("I have been honked at. How very rude. I think I will walk in the opposite direction now.")
