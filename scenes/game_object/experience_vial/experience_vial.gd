extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D as CollisionShape2D
@onready var sprite = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(_on_area_entered)


func tween_to_player(percentage: float, origin: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	global_position = origin.lerp(player.global_position, percentage)
	var target_angle = (player.global_position - global_position).angle()
	target_angle += PI / 2  # Tap points towards player
	rotation = lerp_angle(rotation, target_angle, 2 * get_process_delta_time())


func tween_shrink(percentage: float, original: Vector2):
	var lerp_weight = 1 - exp(-percentage)
	sprite.scale = lerp(original, Vector2.ZERO, lerp_weight)


func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func _on_area_entered(other_area: Area2D):
	disable_collision.call_deferred()
	var tween = create_tween()
	tween.set_parallel()
	(
		tween
		. tween_method(tween_to_player.bind(global_position), 0.0, 1.0, 0.5)
		. set_ease(Tween.EASE_IN)
		. set_trans(Tween.TRANS_QUART)
	)
	(
		tween
		. tween_method(tween_shrink.bind(sprite.scale), 0.0, 1.0, 0.15)
		. set_delay(0.5 - 0.15)
	)
	tween.chain()  # Stop Parallel
	tween.tween_callback(collect)  # Run the collect command
