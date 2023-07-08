extends TextureRect

var rand = RandomNumberGenerator.new()
@export var DebrisScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_debris_timer_timeout():
	$Path2D/DebrisPlacer.progress_ratio = rand.randf()
	var newObject = DebrisScene.instantiate()
	newObject.position = $Path2D/DebrisPlacer.position
	add_child(newObject)
