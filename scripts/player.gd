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
		
		#flip the guy based on direction
		if global.direction==false:
			animated_sprite.flip_h=false
		elif global.direction==true:
			animated_sprite.flip_h=true
		
		has_double_jumped = global.double_jump
		
		global.changed=false
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# should be changed, how timeshift is done
	if Input.is_action_just_pressed("timeshift_menu"):  
		global.x = position.x
		global.y = position.y
		global.changed=true
	
	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")
	
	#flip the guy based on direction
	if direction > 0:
		global.direction=false
		animated_sprite.flip_h=false
	elif direction < 0:
		animated_sprite.flip_h=true
		global.direction=true
	
	# Start timer for the dash state
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
			
	
	#play dash animation if in dash state(dash timer running) and moving
	if !dash_timer.is_stopped() and direction:
		animated_sprite.play("dash")
		
	#handle other animations and player state.
	elif is_on_floor():
		has_double_jumped = false
		global.double_jump = false
		can_dash=true
	#if no input, play idle
		if direction == 0:
			animated_sprite.play("idle")
		else :
	#else the player is moving so play run
			animated_sprite.play("run")
	
	#since the player state updates prior to this, double jump does not need to check is_on_floor
	elif has_double_jumped :
		animated_sprite.play("speen")
	#currently the only other animation so play by default
	else:
		animated_sprite.play("jump")
	
	#if direction has a direction! and magnatude!
	if !dash_timer.is_stopped() and direction:
		velocity.x=DASHSPEED*direction
		velocity.y=0
	#need to to tweak but it works
	elif dash_timer.is_stopped():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#coyote time 
	var was_on_floor=is_on_floor()
	move_and_slide()
	
	#
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
 
