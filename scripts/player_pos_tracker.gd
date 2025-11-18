extends Node

var changed=false
var x = 0
var y = 0
var direction = false
var double_jump = false
var can_dash = false
var Player_HP = 10

func start_over():
	
	Engine.time_scale=1
	get_tree().reload_current_scene()
