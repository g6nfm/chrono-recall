extends CharacterBody2D
var HP=30
var rng = RandomNumberGenerator.new()
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown: Timer = $cooldown

@onready var attackhitbox: Area2D = $attackhitbox
@onready var playerdetector: Area2D = $playerdetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var WaveScene = preload("res://scenes/Enemies/Poseidon/Wave.tscn")

@export var enemy_id : String = ""
@export var scene_name : String

func _ready():
	cooldown.start()
	rng.randomize()
	
	if enemy_id == "":
		enemy_id=name
	
	scene_name = get_tree().current_scene.name
	if GameState.dead_enemies.get(scene_name, {}).get(enemy_id,false):
		queue_free()

func _physics_process(_delta: float) -> void:
	
	if HP<=0:
		if not GameState.dead_enemies.has(scene_name):
			GameState.dead_enemies[scene_name] = {}
		GameState.dead_enemies[scene_name][enemy_id]=true
		queue_free()
		
		
	if !cooldown.is_stopped():
		return
	
	if  !playerdetector.get_overlapping_bodies().is_empty():
		
		animation_player.play("Slash")
		cooldown.start()
	if animation_player.current_animation==("Idle"):
		
		var coin=rng.randi_range(1, 2)
		print(coin)
		if coin==1:
			animation_player.play("Wave")
		else:
			animation_player.play("Wave")
	


	
	
	

	
	
	
func wave():
	
	var Wave = WaveScene.instantiate()
	get_tree().current_scene.add_child(Wave)
	Wave.global_position = playerdetector.global_position
	Wave.global_position.y+=12
	
	
func geyser():
	attackhitbox.monitoring = false
func Idle():
	animation_player.play("Idle")
	cooldown.start()
	

func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player_attack"):
		
		HP-=1
		
	
