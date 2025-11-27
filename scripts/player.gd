extends CharacterBody2D


const SPEED = 130.0 
const JUMP_VELOCITY = -300.0

var has_double_jumped=false
const DASHSPEED = 300
var can_dash =true
var HP=global.Base_HP
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 

@onready var coyote_timer: Timer = $Coyote_timer #for better/smoother jumpingd
@onready var dash_timer: Timer = $Dash_timer
@onready var invuln_timer: Timer = $invuln_timer

@onready var player: CharacterBody2D = $"."


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack: Node2D = $attack

@onready var bar: Control = $timeshift/CanvasLayer/HP


func _ready() -> void:
	
	animation_tree.active=true
	global.Player_HP=global.Player_HP
	
	
func _physics_process(delta: float) -> void:
	if global.Player_HP<=0:
		bar.damage(HP-1)
		Engine.time_scale=0.5
		player.set_collision_layer_value(2,false)
		animation_tree.get("parameters/playback").travel("death")
		return
	
	if invuln_timer.is_stopped():
		player.set_collision_layer_value(2,true)
	else:
		player.set_collision_layer_value(2,false)
	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")
	

	#handle character state after shift
	if global.changed==true:
		HP=global.Player_HP
		bar.set_health(HP)
		position.x = global.x
		position.y = global.y
		#flip the guy based on direction
		direction=global.direction
		velocity=global.velocity
		move_and_slide()
		has_double_jumped=global.double_jump
		global.changed=false
	# Add the gravity.
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# should be changed, how timeshift is done
	if Input.is_action_just_pressed("timeshift_menu"):  
		global.x = position.x
		global.y = position.y
		global.changed=true

	#flip the guy based on direction
	if direction > 0:
		global.direction=1
		animated_sprite.flip_h=false
		attack.scale.x=1
		attack.position.x=19*global.direction
	elif direction < 0:
		global.direction=-1
		animated_sprite.flip_h=true
		attack.scale.x=-1
		attack.position.x=19*global.direction
	# Start timer for the dash state
	if Input.is_action_just_pressed("dash"):
		if can_dash:
			can_dash=false
			dash_timer.start()
	
	# Handle jumping,double jumping, and coyote time.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
	elif has_double_jumped==false and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY #can be changed via -/+ 
			has_double_jumped=true
			global.double_jump = true
			
	
	

	elif is_on_floor():
		has_double_jumped=false
		global.double_jump = false
		can_dash=true
		
		
	
		
		
		
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
	#connect direction to movement animation tree
	animation_tree.set("parameters/Move/blend_position",direction)
	if HP!=global.Player_HP:
		
			animation_tree.get("parameters/playback").travel("Hurt")
			has_double_jumped=false
			
			bar.damage(HP-1)
			HP=global.Player_HP
			
	global.velocity=velocity
	move_and_slide()
	
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
func knockback():
	
	invuln_timer.start()
	
	if global.hitx>position.x:
		velocity=Vector2(-500,-100)
		
	else:
		velocity=Vector2(500,-100)
		
	move_and_slide()
func died():
	global.start_over()
	
