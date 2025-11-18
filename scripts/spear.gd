extends CharacterBody2D

const speed = 50
var direction = -1
@onready var ray_cast_y: RayCast2D = $RayCastY
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attackhitbox: Area2D = $attackhitbox
@onready var playerdetector: Area2D = $playerdetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	direction = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if animation_player.current_animation==("attack"):
		velocity.x=0
		velocity+=get_gravity() * delta
		move_and_slide()
		
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
	
func hit():
	attackhitbox.monitoring = true
func end_of_hit():
	attackhitbox.monitoring = false
func start_walk():
	animation_player.play("Walk")
func _on_playerdetector_body_entered(body: Node2D) -> void:
	animation_player.play("attack")
	
	
