extends Node
signal experience_upgraded(current_experience: float, target_experience: float)
signal level_up(new_level: int)

var current_experience: float = 0
var target_experience: float = 5
var current_level: int = 1
const TARGET_EXPERIENCE_GROWTH = 1


func _ready():
	GameEvents.experience_vial_collected.connect(_on_experience_vial_collected)


func increase_experience(number: float):
	current_experience = min(current_experience + number, target_experience)
	experience_upgraded.emit(current_experience, target_experience)
	if current_experience >= target_experience:
		current_level += 1
		current_experience = 0
		target_experience += TARGET_EXPERIENCE_GROWTH
		experience_upgraded.emit(current_experience, target_experience)
		level_up.emit(current_level)


func _on_experience_vial_collected(number: float):
	increase_experience(number)
