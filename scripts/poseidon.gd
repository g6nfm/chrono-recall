extends CharacterBody2D
var HP=30
var next_segment=HP-2
var rng = RandomNumberGenerator.new()

var flashing = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown: Timer = $cooldown
@onready var boss_bar: Control = $Boss_Bar/CanvasLayer/Shake
@onready var audio_stream_player: AudioStreamPlayer = $AnimationPlayer/AudioStreamPlayer
@onready var hitbox: Area2D = $hitbox
@onready var attackhitbox: Area2D = $attackhitbox
@onready var playerdetector: Area2D = $playerdetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var contacthitbox: Area2D = $contacthitbox


var WaveScene = preload("res://scenes/Enemies/Poseidon/Wave.tscn")
var GeyserScene = preload("res://scenes/Enemies/Poseidon/geyser.tscn")

@export var enemy_id : String = ""
@export var scene_name : String

func _ready():
	
	if GameState.bosshp==0:
		GameState.bosshp=HP
	else:
		HP=GameState.bosshp
		boss_bar.set_health(HP)
	
	randomize()  # Initialize random number generator
	var noise_texture = animated_sprite_2d.material.get("shader_parameter/Noise")
	var noise = noise_texture.noise
	noise.seed = randi_range(0,10)
	noise_texture.noise = noise 
	
	cooldown.start()
	rng.randomize()
	
	if enemy_id == "":
		enemy_id=name
	
	scene_name = get_tree().current_scene.name
	if GameState.dead_enemies.get(scene_name, {}).get(enemy_id,false):
		queue_free()

func _physics_process(_delta: float) -> void:
	
	if HP<=0:
		animation_player.play("RESET")
		contacthitbox.monitoring=false
		if animated_sprite_2d.material.get_shader_parameter("Dissolvevalue")<=0.0:
			if not GameState.dead_enemies.has(scene_name):
				GameState.dead_enemies[scene_name] = {}
			GameState.dead_enemies[scene_name][enemy_id]=true
			queue_free()
		animated_sprite_2d.material.set_shader_parameter("Dissolvevalue",animated_sprite_2d.material.get_shader_parameter("Dissolvevalue")-0.02)
		return
		
		
	if !cooldown.is_stopped():
		return
	
	if  !playerdetector.get_overlapping_bodies().is_empty():
		
		animation_player.play("Stab")
		
	if animation_player.current_animation==("Idle"):
		
		var coin=rng.randi_range(1, 2)
		print(coin)
		if coin==1:
			animation_player.play("Wave")
		else:
			animation_player.play("Geyser")
	

func wave():
	
	var Wave = WaveScene.instantiate()
	get_tree().current_scene.add_child(Wave)
	Wave.global_position = playerdetector.global_position
	Wave.global_position.y+=17
	
	
func Geyser():
	for n in range(1,8):
		var geyser = GeyserScene.instantiate()
		get_tree().current_scene.add_child(geyser)
		geyser.global_position = playerdetector.global_position
		geyser.global_position.y+=8
		
		geyser.global_position.x+=-50*n-(rng.randi_range(0,50))
func Idle():
	animation_player.play("Idle")
	cooldown.start()
func hit():
	attackhitbox.monitoring = true
	
	
func end_of_hit():
	
	attackhitbox.monitoring = false	

func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player_attack"):
		flash_white()
		HP-=1
		GameState.bosshp-=1
		if HP==next_segment:
			next_segment-=2
			boss_bar.damage(HP-1)
			
	
	
func flash_white() -> void:
	audio_stream_player.stream=load("res://assets/sounds/player melee hit sound.mp3")
	audio_stream_player.play()
	if flashing:
		return
	flashing = true
	hitbox.set_deferred("monitoring",false)
	var mat = animated_sprite_2d.material
	mat.set("shader_parameter/flash_amount", 1.0)
	await get_tree().create_timer(0.1).timeout
	
	mat.set("shader_parameter/flash_amount", 0.0)
	await get_tree().create_timer(0.2).timeout
	hitbox.set_deferred("monitoring",true)
	flashing = false
	
