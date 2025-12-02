extends Node


var paused = false
var scene_name = ""

@onready var timeshift: Control = $"../player/timeshift"
@onready var shiftmenu: MarginContainer = $"../player/timeshift/CanvasLayer/shiftmenu"



func _ready():
# Get the name of the root node
	scene_name = get_tree().current_scene.get_name()
	if scene_name=="gameF":
		Atlantis.stream=load("res://assets/music/Wacky Workbench B mix - Sonic the Hedgehog CD [OST] - DeoxysPrime (youtube).mp3")
		Atlantis.play()
	elif !Atlantis.stream==load("res://assets/music/atlantis.mp3"):
		Atlantis.stream=load("res://assets/music/atlantis.mp3")
		Atlantis.play()
	

# Get the file path of the current scene




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
	if scene_name=="gameF":
		return
	paused=!paused
	if paused==false:
		timeshift.shifthide()
		get_tree().paused = false
	elif paused==true:
		timeshift.shifthide()
		get_tree().paused = true
	
	
