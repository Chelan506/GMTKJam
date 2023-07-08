extends Node2D

# Just trying to draw a circle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _draw():
	draw_circle(Vector2.ZERO, 150, Color.DARK_RED)
	modulate.a = 0.25
