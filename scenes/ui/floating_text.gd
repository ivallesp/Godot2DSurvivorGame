extends Node2D
@onready var label = $Label


func start(text: String):
	label.text = text
	scale = Vector2.ZERO
	var tween_position = create_tween()
	(
		tween_position
		. tween_property(
			self, "position", global_position + Vector2.UP * 16, .3
		)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		tween_position
		. tween_property(
			self, "position", global_position + Vector2.UP * 48, .4
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
		. set_delay(0.3)
	)
	tween_position.tween_callback(queue_free)

	var scale_tween = create_tween()
	(
		scale_tween
		. tween_property(self, "scale", Vector2.ONE * 1.5, .15)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		scale_tween
		. tween_property(self, "scale", Vector2.ONE, .15)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		scale_tween
		. tween_property(self, "scale", Vector2.ZERO, .4)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_CUBIC)
		. set_delay(0.3)
	)


func format_health():
	label.modulate = "#43e1b3"
