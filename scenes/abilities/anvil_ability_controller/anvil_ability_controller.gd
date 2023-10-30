extends Node

@export var anvil_scene: PackedScene
@onready var timer = $Timer
var damage = 15
var max_radius = 100


func _ready():
	timer.timeout.connect(on_timer_timeout)


func check_ray_collision(pos1, pos2, collision_mask):
	var params = PhysicsRayQueryParameters2D.create(pos1, pos2, collision_mask)
	var res = get_tree().root.world_2d.direct_space_state.intersect_ray(params)
	return !res.is_empty()


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	var anvil = anvil_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil)

	var random_dir = Vector2.RIGHT.rotated(randf() * 2 * PI)
	var radius = randf() * max_radius
	var spawn_position = player.global_position + radius * random_dir

	for i in range(4):
		if check_ray_collision(player.global_position, spawn_position, 1):
			random_dir = random_dir.rotated(deg_to_rad(90))
			spawn_position = player.global_position + radius * random_dir
		else:
			break
	anvil.global_position = spawn_position
	anvil.hitbox_component.damage = damage
