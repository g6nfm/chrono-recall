extends CharacterBody2D

const speed =50
var target_position: Vector2 = Vector2.ZERO
var direction = -1
const firing_range=200


@onready var ray_cast_y: RayCast2D = $RayCastY
@onready var ray_cast_playerfinder: RayCast2D = $RayCastPlayerfinder
@onready var player: CharacterBody2D = $"../player"

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var ArrowScene = preload("res://scenes/arrow.tscn")
func _ready():
	direction = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if animation_player.current_animation==("attack"):
		velocity.x=0
		velocity+=get_gravity() * delta
		move_and_slide()
		return
	
	ray_cast_playerfinder.target_position=(player.position - (ray_cast_playerfinder.global_position)).normalized()*firing_range
	
	
	animation_player.play("walk")
	if not is_on_floor():
		velocity+=get_gravity() * delta

	if not ray_cast_y.is_colliding() and is_on_floor():
		direction*=-1
		scale.x=-scale.x

	velocity.x = speed * direction
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if ray_cast_playerfinder.is_colliding() and animation_player.current_animation != "attack":
		target_position=player.global_position
		animation_player.play("attack")
		
	
	move_and_slide()
	
func shoot_arrow() -> void:
	
	var arrow = ArrowScene.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = ray_cast_playerfinder.global_position
	target_position=player.global_position
	arrow.setup_arrow(target_position)
	

func start_walk():
	
	animation_player.play("walk")

	
	
