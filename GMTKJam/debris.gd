extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$DebrisHitAudio.play()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Debris strikes
func _on_hit_timer_timeout():
	$AnimatedSprite2D.animation = "debris"
	$DebrisExplodeAudio.play()
	collision_layer = 1