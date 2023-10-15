extends CanvasLayer
@onready var panel_container = %PanelContainer
@onready var restart_button = %RestartButton
@onready var quit_button = %QuitButton
@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel


func _ready():
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	# Tween animation for panel container
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.0)
	(
		tween
		. tween_property(panel_container, "scale", Vector2.ONE, 0.3)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)


func on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	get_tree().quit()


func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lose!"
