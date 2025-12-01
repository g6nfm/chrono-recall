extends Area2D

@onready var manager: Node = %Manager
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_body_entered(_body: Node2D) -> void:
	
	global.Player_HP+=3
	queue_free()
