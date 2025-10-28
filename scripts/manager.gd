extends Node

var score = 0
var paused = false

@onready var scorelabel: Label = $scorelabel
@onready var timeshift: Control = $"../player/timeshift"


func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("timeshift_menu"):
		display()
	

func display():
	
	paused=!paused
	if paused==false:
		timeshift.hide()
		Engine.time_scale=1.0
	elif paused==true:
		timeshift.show()
		Engine.time_scale=0.0
	
	
