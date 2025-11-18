extends CharacterBody2D

const speed = 500

var direction = -1

@onready var ray_cast_x: RayCast2D = $RayCastX

@onready var ray_cast_yl: RayCast2D = $RayCastYL
@onready var ray_cast_yr: RayCast2D = $RayCastYR


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print("penits")
	
	
	if not is_on_floor():
		velocity+=get_gravity() * delta
	if direction==1:
		animated_sprite.flip_h=true
		
	if direction==-1:
		animated_sprite.flip_h=false
		
	if ray_cast_x.is_colliding():
		animated_sprite.play("stab")
	
		
	if not ray_cast_yr.is_colliding():
		direction=1
		
	if not ray_cast_yl.is_colliding():
		direction=-1
		
	velocity.x = speed * direction
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	

	
