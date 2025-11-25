extends CharacterBody2D
var HP=3
const speed =50

var direction = -1
@onready var ray_cast_y: RayCast2D = $RayCastY
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attackhitbox: Area2D = $attackhitbox
@onready var playerdetector: Area2D = $playerdetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer



@export var enemy_id : String = ""
@export var scene_name : String
func _ready():
	
	if enemy_id == "":
		enemy_id=name
		
		
	scene_name = get_tree().current_scene.name
	
	if GameState.dead_enemies.get(scene_name, {}).get(enemy_id,false):
		queue_free()
	direction = -1
	
			
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if HP<=0:
		if not GameState.dead_enemies.has(scene_name):
			GameState.dead_enemies[scene_name] = {}
		GameState.dead_enemies[scene_name][enemy_id]=true
		queue_free()
	if animation_player.current_animation==("attack"):
		velocity.x=0
		velocity+=get_gravity() * delta
		move_and_slide()
		return
		
	animation_player.play("walk")
	if not is_on_floor():
		velocity+=get_gravity() * delta

	if not ray_cast_y.is_colliding() and is_on_floor():
		direction*=-1
		scale.x=-scale.x

	velocity.x = speed * direction
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func _on_playerdetector_body_entered(_body: Node2D) -> void:
	
	animation_player.play("attack")
func hit():
	attackhitbox.monitoring = true
func end_of_hit():
	attackhitbox.monitoring = false
func start_walk():
	animation_player.play("walk")

func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player_attack"):
		
		HP-=1
		if global.direction < 0:
			velocity=Vector2(-1000,-100)
		
		else:
			velocity=Vector2(1000,-100)
		move_and_slide()
	
