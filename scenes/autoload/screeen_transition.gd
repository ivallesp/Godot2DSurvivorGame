extends CanvasLayer

@onready var animation_player = $AnimationPlayer
signal transition_halfway

var skip_next_emit = false


func transition():
	animation_player.play("default")
	await animation_player.animation_finished
	animation_player.play_backwards("default")


func emit_transition_halfway():
	if skip_next_emit:
		skip_next_emit = false
		return
	transition_halfway.emit()
