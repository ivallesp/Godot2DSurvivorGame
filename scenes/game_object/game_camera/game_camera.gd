extends Camera2D

const SMTH = 10


func _ready():
	# Godot renders the "current" camera only.
	# This line makes this camera current.
	make_current()


func _process(delta):
	var target_pos = acquire_target()
	if target_pos == null:
		return
	global_position = global_position.lerp(target_pos, 1 - exp(-delta * SMTH))


func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")

	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		return player.global_position
