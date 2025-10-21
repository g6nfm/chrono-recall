extends CharacterBody2D


const SPEED = 130.0 
const JUMP_VELOCITY = -300.0
var has_double_jumped = false #global boolean for double jump check

const DASHSPEED = 300
var can_dash =true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 
@onready var coyote_timer: Timer = $Coyote_timer #for better/smoother jumpingd
@onready var dash_timer: Timer = $Dash_timer

func _physics_process(delta: float) -> void:
	#handle charaecter state after shift
	if global.changed==true:
	
		position.x = global.x
		position.y = global.y
		#flip the guy
		if global.direction==false:
			animated_sprite.flip_h=false
		elif global.direction==true:
			animated_sprite.flip_h=true
		global.changed=false
		has_double_jumped = global.double_jump
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("timeshift_menu"):  
		global.x = position.x
		global.y = position.y
		global.changed=true
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	#flip the guy
	if direction > 0:
		global.direction=false
		animated_sprite.flip_h=false
	elif direction < 0:
		animated_sprite.flip_h=true
		global.direction=true
	
	if Input.is_action_just_pressed("dash"):
		if can_dash:
			can_dash=false
			
			dash_timer.start()
	
	# Handle jumping,double jumping, and coyote time.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
	elif !has_double_jumped and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY #can be changed via -/+ 
			has_double_jumped = true
			global.double_jump = true
			
	
	#play animationselif !dash_timer.is_stopped():
	if !dash_timer.is_stopped():
		animated_sprite.play("dash")
	elif is_on_floor():
		
		has_double_jumped = false
		global.double_jump = false
		can_dash=true
		if direction == 0:
			animated_sprite.play("idle")
		else :
			animated_sprite.play("run")
		
	elif has_double_jumped :
		animated_sprite.play("speen")
	
	else:
		animated_sprite.play("jump")
	if direction:
		if !dash_timer.is_stopped():
			velocity.x=DASHSPEED*direction
			velocity.y=0
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var was_on_floor=is_on_floor()
	move_and_slide()
	
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
 
