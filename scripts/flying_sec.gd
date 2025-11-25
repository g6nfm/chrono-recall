extends CharacterBody2D

const speed =50
var target_position: Vector2 = Vector2.ZERO
var direction = 1
const firing_range=200
var HP=2



@onready var timer: Timer = $Timer
@export var length:int
@onready var ray_cast_playerfinder: RayCast2D = $RayCastPlayerfinder
@onready var player: CharacterBody2D = $"../player"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var boltScene = preload("res://scenes/Enemies/bolt.tscn")
@export var enemy_id : String = ""
@export var scene_name : String
func _ready():
	timer.start(length)
	if enemy_id == "":
		enemy_id=name

	scene_name = get_tree().current_scene.name
	
	if GameState.dead_enemies.get(scene_name, {}).get(enemy_id,false):
		queue_free()
	
	
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if HP<=0:
		if not GameState.dead_enemies.has(scene_name):
			GameState.dead_enemies[scene_name] = {}
		GameState.dead_enemies[scene_name][enemy_id]=true
		queue_free()
		
	if animation_player.current_animation==("attack"):
		timer.paused=true
		velocity.x=0
		move_and_slide()
		return
	ray_cast_playerfinder.target_position=(player.position - (ray_cast_playerfinder.global_position)).normalized()*firing_range
	animation_player.play("Idle")

	
	


	
		
		
	if ray_cast_playerfinder.is_colliding() and animation_player.current_animation != "attack":
		
		if (ray_cast_playerfinder.get_collider().is_in_group("Player")):
			
			target_position=player.global_position
			if target_position.x<global_position.x:
				animated_sprite_2d.scale.x=-1
			elif target_position.x>global_position.x:
				animated_sprite_2d.scale.x=1
			animation_player.play("attack")
		
			
	velocity.x = speed * direction
	move_and_slide()
	
	
func shoot_bolt() -> void:
	
	var bolt = boltScene.instantiate()
	get_tree().current_scene.add_child(bolt)
	bolt.global_position = ray_cast_playerfinder.global_position
	bolt.scale=scale*5
	bolt.setup_bolt(target_position)
	

func start_Idle():
	timer.paused=false
	animated_sprite_2d.scale.x=direction
	animation_player.play("Idle")

func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player_attack"):
		
		HP-=1
		if global.direction < 0:
			velocity=Vector2(-1000,-100)
		
		else:
			velocity=Vector2(1000,-100)
		move_and_slide()
	
	
		


func _on_timer_timeout() -> void:
	direction*=-1
	ray_cast_playerfinder.position.x*=-1
	animated_sprite_2d.scale.x=-animated_sprite_2d.scale.x
	timer.start(length)
