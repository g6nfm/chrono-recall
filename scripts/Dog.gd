extends CharacterBody2D
var HP=1
const speed =125
var flashing = false
var direction = -1

@onready var contacthitbox: Area2D = $contacthitbox
@onready var hitbox: Area2D = $hitbox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_y: RayCast2D = $RayCastY



@export var enemy_id : String = ""
@export var scene_name : String
func _ready():
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
	direction = -1
	
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if HP<=0:
		animated_sprite_2d.play("Reset")
		contacthitbox.monitoring=false
		if animated_sprite_2d.material.get_shader_parameter("Dissolvevalue")<=0.0:
			if not GameState.dead_enemies.has(scene_name):
				GameState.dead_enemies[scene_name] = {}
			GameState.dead_enemies[scene_name][enemy_id]=true
			queue_free()
		animated_sprite_2d.material.set_shader_parameter("Dissolvevalue",animated_sprite_2d.material.get_shader_parameter("Dissolvevalue")-0.02)
		return
	

	if not is_on_floor():
		velocity+=get_gravity() * delta

	if not ray_cast_y.is_colliding() and is_on_floor():
		direction*=-1
		scale.x=-scale.x

	velocity.x = speed * direction
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	



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
	
