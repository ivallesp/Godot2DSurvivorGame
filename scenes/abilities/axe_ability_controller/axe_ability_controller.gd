extends Node

@onready var timer = $Timer
@export var axe_scene: PackedScene
var damage = 10
var damage_percent = 1.0


func _ready():
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	var foreground = get_tree().get_first_node_in_group("foreground_layer")
	var axe_instance = axe_scene.instantiate()

	foreground.add_child(axe_instance)
	axe_instance.hitbox_component.damage = damage * damage_percent

	axe_instance.global_position = (player.global_position)


func on_ability_upgrade_added(
	upgrade: AbilityUpgrade, current_upgrades: Dictionary
):
	if upgrade.id == "axe_damage":
		damage_percent = 1.0 + .15 * current_upgrades["axe_damage"].quantity
