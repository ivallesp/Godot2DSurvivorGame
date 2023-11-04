extends Node

const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node
@onready var timer = $Timer

var enemy_table = WeightedTable.new()
var enemies_to_spawn = 1


func _ready():
	timer.timeout.connect(on_timer_timeout)
	(
		arena_time_manager
		. arena_difficulty_increased
		. connect(
			on_arena_difficulty_increased,
		)
	)
	enemy_table.add_item(basic_enemy_scene, 10)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var random_dir = Vector2.RIGHT.rotated(randf() * 2 * PI)
	var spawn_position = player.global_position + random_dir * SPAWN_RADIUS

	for i in range(4):
		if check_ray_collision(player.global_position, spawn_position, 1):
			random_dir = random_dir.rotated(deg_to_rad(90))
			spawn_position = player.global_position + random_dir * SPAWN_RADIUS
		else:
			break
	return spawn_position


func check_ray_collision(pos1, pos2, collision_mask):
	var params = PhysicsRayQueryParameters2D.create(pos1, pos2, collision_mask)
	var res = get_tree().root.world_2d.direct_space_state.intersect_ray(params)
	return !res.is_empty()


func on_timer_timeout():
	timer.start()  # We use this instead of autostart to update the config

	var entities_layer = get_tree().get_first_node_in_group("entities_layer")

	for i in enemies_to_spawn:
		var spawn_position = get_spawn_position()
		if spawn_position == null:
			return
		var enemy_scene = enemy_table.pick_item()
		var enemy_instance = enemy_scene.instantiate() as Node2D
		entities_layer.add_child(enemy_instance)
		enemy_instance.global_position = spawn_position


func on_arena_difficulty_increased(arena_difficulty):
	var time_off = min(0.1 / 12, 0.7)
	var next_wait_time = timer.wait_time - time_off
	timer.wait_time = next_wait_time
	if arena_difficulty == 6:  # At 30s
		enemy_table.add_item(wizard_enemy_scene, 20)
	elif arena_difficulty == 18:  # At 1'30s
		enemy_table.add_item(bat_enemy_scene, 8)
	if (arena_difficulty % 12) == 0:  # Every 60s, increase the spawn
		enemies_to_spawn = int(arena_difficulty / 6) + 1
