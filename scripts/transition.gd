extends CanvasLayer


@onready var color_rect: ColorRect = $ColorRect
@onready var color_rectflash: ColorRect = $ColorRectflash
@onready var texture_rectdistortion: TextureRect = $TextureRectdistortion
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var next_scene_path: String
var duration := 0.6

func _ready():
	# Start hidden
	color_rect.modulate.a = 0
	color_rectflash.modulate.a = 0
	texture_rectdistortion.modulate.a = 0
	
	visible = true

func change_level(path: String):
	next_scene_path = path
	_begin_time_warp()

func _begin_time_warp():
	get_tree().paused = true
	var t = create_tween()
	# Step 1: Distortion grows in
	audio_stream_player.play()
	
	t.tween_property(texture_rectdistortion, "modulate:a", 1.0, duration * 0.5)
	

	# Step 2: Quick white flash
	t.tween_property(color_rectflash, "modulate:a", 0.5, duration * 0.3)
   
	t.tween_property(color_rectflash, "modulate:a", 0.0, duration * 0.3)

	# Step 3: Darken to hide old scene
	
	t.tween_property(color_rect, "modulate:a", 1.0, duration * 0.4)

	# When done → load new scene
	t.tween_callback(Callable(self, "_finish_time_warp"))

func _finish_time_warp():
	get_tree().change_scene_to_file(next_scene_path)
	call_deferred("_time_warp_arrival")

func _time_warp_arrival():
	# Reverse effect
	color_rect.modulate.a = 1
	texture_rectdistortion.modulate.a = 1

	var t = create_tween()

	# Fade darken out
	t.tween_property(color_rect, "modulate:a", 0.0, duration * 0.4)

	# Shrink distortion out
	t.tween_property(texture_rectdistortion, "modulate:a", 0.0, duration * 1)
	get_tree().paused = false
