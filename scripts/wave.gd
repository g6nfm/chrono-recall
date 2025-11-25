extends Area2D

@export var speed: float = -50
var velocity: Vector2 = Vector2(speed,0)

@onready var timer: Timer = $Timer



# Call this function immediately after instancing the arrow to set its trajectory!
func _ready() -> void:

	timer.start()
	
func _physics_process(delta):
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	
	if body is TileMap:
		queue_free()
	 


func _on_timer_timeout() -> void:
	queue_free()
