extends TextureRect

var rand = RandomNumberGenerator.new()
@export var DebrisScene : PackedScene
@export var CivillianScene : PackedScene
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn 50 civillians at random positions
	for i in 50:
		$Path2D/DebrisPlacer.progress_ratio = rand.randf()
		var newPerson = CivillianScene.instantiate()
		newPerson.position = $Path2D/DebrisPlacer.position
		add_child(newPerson)
		newPerson.add_to_group("civillians")
	
	$Path2D/DebrisPlacer.progress_ratio = 0 # Set fight path back to start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path2D/DebrisPlacer.progress += 2.5 # Move the fight over time

# Every n seconds, spawn a new piece of falling debris. Pattern according to Path2D
func _on_debris_timer_timeout():
	# Spawn a debris object
	var newObject = DebrisScene.instantiate()
	newObject.position = $Path2D/DebrisPlacer.position
	add_child(newObject)
	
	# Randomly set the time to next debris
	$DebrisTimer.wait_time = 4 + rand.randi_range(0,6)
