extends CharacterBody2D


var target_position: Vector2 = Vector2.ZERO

const firing_range=150
var HP=5
var flashing = false

@onready var hitbox: Area2D = $hitbox


@onready var ray_cast_playerfinder: RayCast2D = $RayCastPlayerfinder
@onready var player: CharacterBody2D = $"../player"

@onready var audio_stream_player: AudioStreamPlayer = $AnimationPlayer/AudioStreamPlayer

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var dir=scale.x
var bulletScene = preload("res://scenes/Enemies/officer_bullet.tscn")
@export var enemy_id : String = ""
@export var scene_name : String
func _ready():
	
	
	randomize()  # Initialize random number generator
 
	var noise_texture = sprite_2d.material.get("shader_parameter/Noise")
	var noise = noise_texture.noise
	noise.seed = randi_range(0,10)
	noise_texture.noise = noise 
	
	if enemy_id == "":
		enemy_id=name

	scene_name = get_tree().current_scene.name
	
	if GameState.dead_enemies.get(scene_name, {}).get(enemy_id,false):
		queue_free()
	
	
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if HP<=0:
		animation_player.play("RESET")
		if sprite_2d.material.get_shader_parameter("Dissolvevalue")<=0.0:
			if not GameState.dead_enemies.has(scene_name):
				GameState.dead_enemies[scene_name] = {}
			GameState.dead_enemies[scene_name][enemy_id]=true
			queue_free()
		sprite_2d.material.set_shader_parameter("Dissolvevalue",sprite_2d.material.get_shader_parameter("Dissolvevalue")-0.02)
		return
	if animation_player.current_animation==("attack"):
		
		velocity.x=0
		velocity+=get_gravity()
		scale.y = -0.1
		set_rotation(179.07)
		
		
		move_and_collide(velocity)
		scale.y = 0.1
		set_rotation(0)
		scale.x=dir
		return
	
	ray_cast_playerfinder.target_position=(player.position - (ray_cast_playerfinder.global_position)).normalized()*firing_range
	
	

		
		
		
	
	animation_player.play("walk")
	if not is_on_floor():
		velocity+=get_gravity() * delta

	

	

	if ray_cast_playerfinder.is_colliding() and animation_player.current_animation != "attack":
		
		if (ray_cast_playerfinder.get_collider().is_in_group("Player")):
			
			target_position=player.global_position
			if target_position.x<global_position.x:
				scale.x=0.1
				ray_cast_playerfinder.scale.x=10
			elif target_position.x>global_position.x:
				scale.x=-0.1
				ray_cast_playerfinder.scale.x=-10
			
			dir=scale.x
			animation_player.play("attack")
		
			
	
	
func shoot_arrow(N) -> void:

	var bullet = bulletScene.instantiate()
	
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = ray_cast_playerfinder.global_position

	bullet.setup_arrow(target_position,N)
	

func start_walk():
	
	
	animation_player.play("walk")

func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player_attack"):
		flash_white()
		HP-=1
		if global.direction < 0:
			velocity=Vector2(-1000,-100)
		
		else:
			velocity=Vector2(1000,-100)
		move_and_slide()
	
	
		
func flash_white() -> void:
	audio_stream_player.stream=load("res://assets/sounds/player melee hit sound.mp3")
	audio_stream_player.play()
	if flashing:
		return
	flashing = true
	hitbox.set_deferred("monitoring",false)
	var mat = sprite_2d.material
	mat.set("shader_parameter/flash_amount", 1.0)
	await get_tree().create_timer(0.1).timeout
	
	mat.set("shader_parameter/flash_amount", 0.0)
	await get_tree().create_timer(0.2).timeout
	hitbox.set_deferred("monitoring",true)
	flashing = false
	
