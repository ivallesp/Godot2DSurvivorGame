extends Node2D

const MAX_RADIUS = 100

var random_dir: Vector2
@onready var hitbox_component = $HitBoxComponent


func _ready():
	random_dir = (Vector2.RIGHT.rotated(randf() * 2 * PI))
	var tween = create_tween()
	tween.tween_method(f_tween, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)


func f_tween(spin: float):
	var player = get_tree().get_first_node_in_group("player")
	var dir = random_dir.rotated(2 * PI * spin)
	var modulus = MAX_RADIUS * spin / 2.0
	global_position = ((player.global_position) + (dir * modulus))
