extends Node

@export var sword_ability: PackedScene
var MAX_RANGE = 150
var damage = 5
var damage_percent = 1.0
@onready var original_wait_time = %Timer.wait_time


# Called when the node enters the scene tree for the first time.
func _ready():
	%Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(e: Node2D): 
		return (e.global_position.distance_squared_to(player.global_position) 
		< pow(MAX_RANGE, 2))
	)
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_d = a.global_position.distance_squared_to(player.global_position)
		var b_d = b.global_position.distance_squared_to(player.global_position)
		return a_d < b_d
	)
	if enemies.size() == 0:
		return
	var target_enemy = enemies[0]
	
	# Instantiate sword
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var fg_layer = get_tree().get_first_node_in_group("foreground_layer")
	fg_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage * damage_percent
	
	sword_instance.global_position = target_enemy.global_position
	# Jitter
	sword_instance.global_position += Vector2.RIGHT.rotated(randf()*2*PI) * 4
	# Angle sword towards target
	var direct = target_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = direct.angle()


func on_ability_upgrade_added(
	upgrade: AbilityUpgrade, 
	current_upgrades: Dictionary
	):
	if upgrade.id == "sword_rate":
		var qty = current_upgrades["sword_rate"].quantity
		var pct_reduction = qty * 0.1
		%Timer.wait_time = original_wait_time * (1-pct_reduction)
		%Timer.start()
	elif upgrade.id == "sword_damage":
		damage_percent = 1.0 + .15 * current_upgrades["sword_damage"].quantity
