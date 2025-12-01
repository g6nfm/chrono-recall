extends Camera2D

var last_hp := 0        # store the previous HP
var shake_amount := 8.0
var shake_time := 0.08
var _shake_timer := 0.0


func _ready():
	
	position_smoothing_enabled = false  
	rotation_smoothing_enabled = false  
	limit_smoothed=false
	# Initialize by syncing HP
	last_hp = global.Player_HP
	position.x=0
	position.y=0
	await get_tree().create_timer(0.5).timeout
	position_smoothing_enabled = true
	rotation_smoothing_enabled = true 
	limit_smoothed=true
	
func _process(delta):
	
	
	
	
	# Detect HP change
	if global.Player_HP != last_hp:
		_on_hp_changed()
		last_hp = global.Player_HP

	# Camera shake logic
	if _shake_timer > 0:
		_shake_timer -= delta
		offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
	else:
		offset = Vector2.ZERO


func _on_hp_changed():
	# Hitstop + camera shake
   
	shake(0.06)


func shake(duration := 0.4):
	_shake_timer = duration
