extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area2D = $hurtbox

func _ready() -> void:
	hurtbox.monitoring=false
	animation_player.play("Geyser")
	
func hit():
	hurtbox.monitoring = true
func end_of_hit():
	hurtbox.monitoring = false
func done():
	queue_free()
