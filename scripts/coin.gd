extends Area2D

@onready var manager: Node = %Manager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enemy_id : String = ""
@export var scene_name : String


func _ready():
	if enemy_id == "":
		enemy_id=name
		
	scene_name = get_tree().current_scene.name
	
	if GameState.dead_enemies.get(scene_name, {}).get(enemy_id,false):
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	
	global.Player_HP+=3
	
	if not GameState.dead_enemies.has(scene_name):
		GameState.dead_enemies[scene_name] = {}
	GameState.dead_enemies[scene_name][enemy_id]=true
	
	queue_free()
