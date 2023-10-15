extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = %ProgressBar


func _ready():
	experience_manager.experience_upgraded.connect(on_experience_upgrade)
	progress_bar.value = 0.0


func on_experience_upgrade(current, target):
	if target == 0:
		return
	progress_bar.value = (current / target)
