extends CanvasLayer

@onready var animation_player = $AnimationPlayer
signal transition_halfway

var skip_next_emit = false


func transition():
	animation_player.play("default")
	await animation_player.animation_finished
	animation_player.play_backwards("default")


func transition_to_scene(scene_path: String):
	ScreeenTransition.transition()
	await transition_halfway
	get_tree().change_scene_to_file(scene_path)


func emit_transition_halfway():
	if skip_next_emit:
		skip_next_emit = false
		return
	transition_halfway.emit()
