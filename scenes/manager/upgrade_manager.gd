extends Node

@export var experience_manager: Node
@export var upgrade_screen_scn: PackedScene

var upgrade_pool: WeightedTable = WeightedTable.new()
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_damage = preload(
	"res://resources/upgrades/sword_damage.tres"
)
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_player_speed = preload(
	"res://resources/upgrades/player_speed.tres"
)
var upgrade_anvil = preload("res://resources/upgrades/anvil.tres")
var upgrade_anvil_count = preload("res://resources/upgrades/anvil_count.tres")

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)
	initialize_upgrade_pool()


func initialize_upgrade_pool():
	var initial_pool = [
		[upgrade_sword_rate, 10],
		[upgrade_sword_damage, 10],
		[upgrade_axe, 10],
		[upgrade_player_speed, 5],
		[upgrade_anvil, 5]
	]
	for item in initial_pool:
		upgrade_pool.add_item(item[0], item[1])


func apply_upgrade(upgrade: AbilityUpgrade):
	if current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id]["quantity"] += 1
	else:
		current_upgrades[upgrade.id] = {"upgrade": upgrade, "quantity": 1}

	if upgrade.max_quantity > 0:
		var curr_quantity = current_upgrades[upgrade.id]["quantity"]
		if curr_quantity >= upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)

	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
	elif chosen_upgrade.id == upgrade_anvil.id:
		upgrade_pool.add_item(upgrade_anvil_count, 5)


func pick_upgrades():
	var chosen_upgrades = [] as Array[AbilityUpgrade]
	for i in range(2):
		if chosen_upgrades.size() == upgrade_pool.table.size():
			# All upgrades are already chosen
			break
		var chosen = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen)
	return chosen_upgrades


func on_level_up(new_level: int):
	var upgrade_screen_instance = upgrade_screen_scn.instantiate()
	add_child(upgrade_screen_instance)

	var upgrades = pick_upgrades() as Array[AbilityUpgrade]
	upgrade_screen_instance.set_ability_upgrades(upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
