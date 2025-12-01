
extends Area2D

	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		global.Player_HP+=-1
		if $"..".is_in_group("Boss"):
			global.boss=2
		else:
			global.boss=1
		global.hitx=global_position.x
	
	
