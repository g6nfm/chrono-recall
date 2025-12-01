extends Area2D

@export var speed: float = 100
var velocity: Vector2 = Vector2.ZERO
@onready var timer: Timer = $Timer



# Call this function immediately after instancing the arrow to set its trajectory!
func setup_bolt(target_position: Vector2):
	
	velocity = (target_position - global_position).normalized() * speed
	rotation = velocity.angle()
	timer.start()
	
func _physics_process(delta):
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	
	if body is TileMapLayer:
		queue_free()
	 


func _on_timer_timeout() -> void:
	queue_free()
