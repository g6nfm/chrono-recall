extends Area2D

@onready var manager: Node = %Manager
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_body_entered(_body: Node2D) -> void:
	manager.add_point()
	animation_player.play("pickup")
	
