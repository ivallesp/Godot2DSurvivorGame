extends Node
class_name HealthComponent

@export var max_health: float = 10
var current_health: float

signal died
signal health_changed
signal health_decreased


func _ready():
	current_health = max_health


func damage(amount: float):
	current_health = max(current_health - amount, 0)
	health_changed.emit()
	health_decreased.emit()
	check_death.call_deferred()


func heal(amount: float):
	current_health = min(current_health + amount, max_health)
	health_changed.emit()


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()


func get_health_percent():
	return min(max(current_health / max_health, 0), 1)
