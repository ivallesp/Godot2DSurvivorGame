extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hurt_box_component = $HurtBoxComponent
@onready var hit_random_audio_stream_player_2d = $HitRandomAudioStreamPlayer2D

var is_moving = true


func _ready():
	hurt_box_component.hit.connect(on_hit)


func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	velocity_component.move(self)

	var movement_sign = sign(velocity.x)
	if movement_sign != 0:
		visuals.scale.x = movement_sign


func set_is_moving(value: bool):
	is_moving = value


func on_hit():
	hit_random_audio_stream_player_2d.play_random_stream()
