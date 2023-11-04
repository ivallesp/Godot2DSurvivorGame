extends Node

@export var anvil_scene: PackedScene
@onready var timer = $Timer
var damage = 15
var max_radius = 100
var n_anvils = 1


func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func check_ray_collision(pos1, pos2, collision_mask):
	var params = PhysicsRayQueryParameters2D.create(pos1, pos2, collision_mask)
	var res = get_tree().root.world_2d.direct_space_state.intersect_ray(params)
	return !res.is_empty()


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")

	var radius = randf() * max_radius
	var direction = Vector2.RIGHT.rotated(randf() * 2 * PI)

	for i in range(n_anvils):
		var anvil = anvil_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil)

		var offset = radius * direction
		var spawn_position = (
			player.global_position + offset.rotated(2 * PI * i / n_anvils)
		)

		for j in range(4):
			if check_ray_collision(player.global_position, spawn_position, 1):
				direction = direction.rotated(deg_to_rad(90))
				spawn_position = player.global_position + radius * direction
			else:
				break
		anvil.global_position = spawn_position
		anvil.hitbox_component.damage = damage


func on_ability_upgrade_added(
	upgrade: AbilityUpgrade, current_upgrades: Dictionary
):
	if upgrade.id == "anvil_count":
		# Initial one + upgrade
		n_anvils = current_upgrades["anvil_count"]["quantity"] + 1
