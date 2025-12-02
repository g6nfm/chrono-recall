extends Area2D

@onready var manager: Node = %Manager
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_body_entered(_body: Node2D) -> void:
	GameState.dead_enemies.clear()
	Transition.change_level("res://scenes/levels/level1/level1_presentremake.tscn")
