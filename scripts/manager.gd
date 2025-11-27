extends Node


var paused = false


@onready var timeshift: Control = $"../player/timeshift"
@onready var shiftmenu: MarginContainer = $"../player/timeshift/shiftmenu"



func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("QuickShift_past"):
		display()
		timeshift._on_past_pressed()
	if Input.is_action_just_pressed("QuickShift_present"):
		display()
		timeshift._on_present_pressed()
	if Input.is_action_just_pressed("QuickShift_future"):
		display()
		timeshift._on_future_pressed()
		
	if Input.is_action_just_pressed("timeshift_menu"):
		
		display()
		

func display():
	
	paused=!paused
	if paused==false:
		timeshift.shifthide()
		get_tree().paused = false
	elif paused==true:
		timeshift.shifthide()
		get_tree().paused = true
	
	
