extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent as HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var hit_random_audio_stream_player_2d = $HitRandomAudioStreamPlayer2D
@export var arena_time_manager: Node

var floating_text = preload("res://scenes/ui/floating_text.tscn")
var num_colliding_bodies: int = 0
var base_speed = 0


func _ready():
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	health_component.health_decreased.connect(on_health_decreased)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	arena_time_manager.arena_difficulty_increased.connect(
		on_arena_difficulty_increased
	)
	update_healthbar()


func _process(delta):
	var direction = get_movement_vector().normalized() as Vector2
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	var movement_sign = sign(direction.x)
	if movement_sign != 0:
		visuals.scale.x = movement_sign
	if direction.length() > 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")


func get_movement_vector():
	var x = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	var y = (
		Input.get_action_strength("move_down")
		- Input.get_action_strength("move_up")
	)
	return Vector2(x, y)


func check_deal_damage():
	if num_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_healthbar():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	num_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	num_colliding_bodies -= 1


@export var min_pitch: float = 0.9


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_decreased():
	GameEvents.emit_player_damaged()
	hit_random_audio_stream_player_2d.play_random_stream()
	update_healthbar()


func on_ability_upgrade_added(
	ability_upgrade: AbilityUpgrade,
	current_upgrades: Dictionary,
):
	if ability_upgrade is Ability:
		abilities.add_child(
			ability_upgrade.ability_controller_scene.instantiate()
		)
	elif ability_upgrade.id == "player_speed":
		var qty = current_upgrades["player_speed"]["quantity"]
		velocity_component.max_speed = base_speed + (base_speed * qty * .1)


func on_arena_difficulty_increased(difficulty: int):
	var health_increase = MetaProgression.get_upgrade_count("health_increase")
	if health_increase > 0:
		# Arena difficulty increases every 5 seconds, hence 6 increases = 30s
		var is_30s_mark = (difficulty % 1) == 0
		if is_30s_mark:
			health_component.heal(health_increase)
			update_healthbar()
			var txt = floating_text.instantiate()
			get_tree().get_first_node_in_group("foreground_layer").add_child(
				txt
			)
			txt.format_health()
			txt.global_position = health_bar.global_position + Vector2.UP * 16
			txt.start("+" + str(round(health_increase)))
