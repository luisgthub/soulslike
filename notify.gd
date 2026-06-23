extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var alt = position.y +80
	text = "100"
	var duration = 1
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position:y",alt,duration)
	tween.tween_property(self,"scale",Vector2.ZERO,duration)
	tween.tween_property(self,"modulate:a",0.2,duration)
	await tween.finished 
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
