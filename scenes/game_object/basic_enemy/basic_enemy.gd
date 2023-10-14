extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	var movement_sign = sign(velocity.x)
	if movement_sign != 0:
		visuals.scale.x = movement_sign
