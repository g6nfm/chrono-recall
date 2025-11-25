extends Node
var hitx=0
var changed=false
var x = 0
var y = 0
var direction = 0
var double_jump = false
var can_dash = false
var Base_HP=10
var Player_HP = Base_HP

var velocity

func start_over():
	GameState.dead_enemies.clear()
	Engine.time_scale=1
	Player_HP=Base_HP
	get_tree().reload_current_scene()
