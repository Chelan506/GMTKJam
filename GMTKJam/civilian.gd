extends CharacterBody2D

@export var movement_speed: float = 200
@export var navigation_agent = NavigationAgent2D.new()
var randAnimOffset
var rand = RandomNumberGenerator.new()
var dead = false

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	randAnimOffset = rand.randi_range(0,4)
	
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	var desired_position = global_position
	desired_position[0] += rand.randi_range(-150,150)
	desired_position[1] += rand.randi_range(-150,150)
	set_movement_target(desired_position)

func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	
func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		var desired_position = global_position
		desired_position[0] += rand.randi_range(-150,150)
		desired_position[1] += rand.randi_range(-150,150)
		set_movement_target(desired_position)
		
	if dead:
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
	if !dead:
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
	dead = true
	$CollisionShape2D.disabled = true # You can run over dead bodies
	$Sprite2D.texture = load("res://Assets/littleguyidle.png")
	rotation += 80 + rand.randi_range(0,20)
	get_parent().deathCount += 1
	$"../../HUD/DeathCountLabel".set_text("Death count: " + str(get_parent().deathCount))
	
func honked_at(carPos):
	print("I have been honked at. How very rude. I think I will walk in the opposite direction now.")
