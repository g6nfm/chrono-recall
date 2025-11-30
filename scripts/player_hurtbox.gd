extends Area2D
@onready var hurtbox: Area2D = $"."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"



	

func _process(_delta):
	
	if Input.is_action_just_pressed("Attack"):
		
		animation_player.play("Swing")
		

func hit():
	
	set_collision_layer_value(1,1)
	set_collision_layer_value(2,1)
	set_collision_mask_value(1,1)
	set_collision_mask_value(2,1)
	hurtbox.monitorable = true
	
func end_of_hit():
	hurtbox.monitorable = false
	set_collision_layer_value(1,0)
	set_collision_layer_value(2,0)
	set_collision_mask_value(1,0)
	set_collision_mask_value(2,0)
	
	


	
	
