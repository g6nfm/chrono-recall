extends Control
@onready var manager: Node = %Manager


# Called when the node enters the scene tree for the first time.
@onready var player: CharacterBody2D = $".."



func _on_past_pressed() -> void:
	manager.display()
	global.x = player.position.x
	global.y = player.position.y
	global.changed=true
	get_tree().change_scene_to_file("res://scenes/levels/level1/level1_atlantispast.tscn")
	


func _on_present_pressed() -> void:
	manager.display()
	global.x = player.position.x
	global.y = player.position.y
	global.changed=true
	get_tree().change_scene_to_file("res://scenes/levels/level1/level1_present.tscn")


func _on_future_pressed() -> void:
	manager.display()
	global.x = player.position.x
	global.y = player.position.y
	global.changed=true
	get_tree().change_scene_to_file( "res://scenes/levels/level1/level1_future.tscn")
	
