extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@onready var particles = $GPUParticles2D as GPUParticles2D
@onready var death_animation = $AnimationPlayer as AnimationPlayer
@onready var hit_random_audio_stream_player_2d = $HitRandomAudioStreamPlayer2D


func _ready():
	particles.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if not owner is Node2D:
		return
	MetaProgression.save()
	var spawn_position = owner.global_position
	var entities = get_tree().get_first_node_in_group("entities_layer")
	hit_random_audio_stream_player_2d.play_random_stream()
	get_parent().remove_child(self)

	entities.add_child(self)
	global_position = spawn_position
	death_animation.play("default")
