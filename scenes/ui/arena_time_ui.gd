extends CanvasLayer

@export var arena_time_manager: Node
@onready var timer_label = %Label


func _process(delta):
	if (arena_time_manager == null) or (timer_label == null):
		return
	var seconds = arena_time_manager.get_time_elapsed()
	timer_label.text = format_time(seconds)


func format_time(seconds):
	var minutes = floor(seconds / 60)
	var remaining_seconds = floor(seconds - (60 * minutes))
	var time_f = str(minutes) + ":" + ("%02d" % remaining_seconds)
	return time_f
