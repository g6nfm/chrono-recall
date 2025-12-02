extends CharacterBody2D


const SPEED = 130.0 #move speed
const JUMP_VELOCITY = -300.0 #jump height
var has_double_jumped=false #boolean so player can only double jump
const DASHSPEED = 300 #how fast the dash is 
var can_dash =true #same as has_double_jumped but for air dashes
var HP=global.Base_HP #HP, made the same as a varible in Player_pos_tracker 
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 

@onready var coyote_timer: Timer = $Coyote_timer #for better/smoother jumping
@onready var dash_timer: Timer = $Dash_timer #dash length
@onready var invuln_timer: Timer = $invuln_timer #how long player is invinceible when hit
@onready var camera_2d: Camera2D = $Camera2D 
@onready var player: CharacterBody2D = $"."


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var attack: Area2D = $attack #attack used to be seperate scene, merged as this caused a desync 



@onready var bar: Control = $timeshift/CanvasLayer/HP



func _ready() -> void:
	animation_tree.active=true
	camera_2d.position.x=250
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
		camera_2d.position.x=250
		global.direction=1
		animated_sprite.flip_h=false
		attack.position.x=200
		
	elif direction < 0:
		camera_2d.position.x=-250
		global.direction=-1
		animated_sprite.flip_h=true
		attack.position.x=-200
		
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
			animation_tree.get("parameters/playback").travel("Double-jump")

	elif is_on_floor():
		has_double_jumped=false
		global.double_jump = false
		can_dash=true
		
	if Input.is_action_just_pressed("Attack"):
		animation_tree.get("parameters/playback").travel("attack")
		
		
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
	if HP>global.Player_HP:
		
			animation_tree.get("parameters/playback").travel("Hurt")
			has_double_jumped=false
			
			bar.damage(HP-1)
			HP=global.Player_HP
			
	elif HP<global.Player_HP:
		
			if global.Player_HP>7:
				bar.set_health(10)
				global.Player_HP=10
				HP=global.Player_HP
				
			else:
				
				bar.heal(HP+3)
			HP=global.Player_HP
			
	global.velocity=velocity
	move_and_slide()
	
	
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
func knockback():
	
	invuln_timer.start()
	
	if global.hitx>position.x:
		velocity=Vector2(-5000*global.boss,-100)
	else:
		velocity=Vector2(5000*global.boss,-100)
	
		
	move_and_slide()
func died():
	global.start_over()
	
func hit():
	
	attack.set_collision_layer_value(1,1)
	attack.set_collision_layer_value(2,1)
	attack.set_collision_mask_value(1,1)
	attack.set_collision_mask_value(2,1)
	attack.monitorable = true
	
func end_of_hit():
	attack.monitorable = false
	attack.set_collision_layer_value(1,0)
	attack.set_collision_layer_value(2,0)
	attack.set_collision_mask_value(1,0)
	attack.set_collision_mask_value(2,0)
