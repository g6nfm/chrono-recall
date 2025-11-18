extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	global.Player_HP+=-1
	print(global.Player_HP)
	

func _on_timer_timeout() -> void:
	
	global.start_over()
