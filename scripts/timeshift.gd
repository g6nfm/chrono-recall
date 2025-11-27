extends Control

@export var test: Control
@onready var manager: Node = $"../../Manager"
@onready var shiftmenu: MarginContainer = $shiftmenu
@onready var hp: MarginContainer = $CanvasLayer/HP


# Called when the node enters the scene tree for the first time.
@onready var player: CharacterBody2D = $".."

func shifthide():
	test.visible = !test.visible

func _on_past_pressed() -> void:	
	manager.display()
	global.x = player.position.x
	global.y = player.position.y
	global.changed=true
	Transition.change_level("res://scenes/levels/level1/level1_atlantispast.tscn")
	


func _on_present_pressed() -> void:
	manager.display()
	global.x = player.global_position.x
	global.y = player.global_position.y
	global.changed=true
	
	Transition.change_level("res://scenes/levels/level1/level1_present.tscn")


func _on_future_pressed() -> void:
	manager.display()
	global.x = player.position.x
	global.y = player.position.y
	global.changed=true
	Transition.change_level( "res://scenes/levels/level1/level1_future.tscn")
	
