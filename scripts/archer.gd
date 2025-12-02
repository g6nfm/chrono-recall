extends CharacterBody2D

const speed =50
var target_position: Vector2 = Vector2.ZERO
var direction = -1
const firing_range=200
var HP=2
var flashing = false
var dir=0
var side=1


@onready var hitbox: Area2D = $hitbox
@onready var ray_cast_y: RayCast2D = $RayCastY
@onready var ray_cast_playerfinder: RayCast2D = $RayCastPlayerfinder
@onready var contacthurtbox: Area2D = $contacthurtbox

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AnimatedSprite2D/AnimationPlayer/AudioStreamPlayer
@onready var player: CharacterBody2D = $"../player"



var ArrowScene = preload("res://scenes/Enemies/arrow.tscn")
@export var enemy_id : String = ""
@export var scene_name : String
func _ready():
	
	if scale.x>0:
		direction=-1
	elif scale.x<0:
		direction=1
		side=-1
		ray_cast_playerfinder.scale.x=-1
	
	randomize()  # Initialize random number generator
 
	var noise_texture = animated_sprite_2d.material.get("shader_parameter/Noise")
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
		contacthurtbox.monitoring=false
		if animated_sprite_2d.material.get_shader_parameter("Dissolvevalue")<=0.0:
			if not GameState.dead_enemies.has(scene_name):
				GameState.dead_enemies[scene_name] = {}
			GameState.dead_enemies[scene_name][enemy_id]=true
			queue_free()
		animated_sprite_2d.material.set_shader_parameter("Dissolvevalue",animated_sprite_2d.material.get_shader_parameter("Dissolvevalue")-0.02)
		return
		
	if animation_player.current_animation==("attack"):
		velocity.x=0
		velocity+=get_gravity() * delta
		
		move_and_collide(velocity)
		
		return
	ray_cast_playerfinder.target_position=(player.position - (ray_cast_playerfinder.global_position)).normalized()*firing_range
	animation_player.play("walk")
	
	if not ray_cast_y.is_colliding() and is_on_floor():
		direction*=-1
		scale.x=-scale.x
		ray_cast_playerfinder.scale.x=-direction
	elif velocity.x==0 and is_on_floor() and !animation_player.current_animation=="attack":
		direction*=-1
		scale.x=-scale.x
		ray_cast_playerfinder.scale.x=-direction
	
	
	
	
	if ray_cast_playerfinder.is_colliding() and animation_player.current_animation != "attack":
		
		if (ray_cast_playerfinder.get_collider().is_in_group("Player")):
			
			target_position=player.global_position
			if  player.global_position.x<global_position.x:
				scale.x=1*side
			elif player.global_position.x>global_position.x:
				scale.x=-1.0*side
			dir=scale.x
			
			animation_player.play("attack")
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = speed * direction
	move_and_slide()
	
func shoot_arrow() -> void:
	
	var arrow = ArrowScene.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = ray_cast_playerfinder.global_position
	
	arrow.setup_arrow(target_position)
	

func start_walk():
	
	scale.x=dir
	
	ray_cast_playerfinder.scale.x=-direction
	velocity.x = speed * direction
	
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
	var mat = animated_sprite_2d.material
	mat.set("shader_parameter/flash_amount", 1.0)
	await get_tree().create_timer(0.1).timeout
	
	mat.set("shader_parameter/flash_amount", 0.0)
	await get_tree().create_timer(0.2).timeout
	hitbox.set_deferred("monitoring",true)
	flashing = false
