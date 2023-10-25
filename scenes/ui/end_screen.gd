extends CanvasLayer
@onready var panel_container = %PanelContainer
@onready var continue_button = %ContinueButton
@onready var quit_button = %QuitButton
@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var defeat_audio_stream_player = %DefeatAudioStreamPlayer
@onready var victory_audio_stream_player = %VictoryAudioStreamPlayer


func _ready():
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
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


func play_jingles(defeat: bool = false):
	if defeat:
		defeat_audio_stream_player.play()
	else:
		victory_audio_stream_player.play()


func on_continue_button_pressed():
	get_tree().paused = false
	ScreeenTransition.transition_to_scene("res://scenes/ui/meta_menu.tscn")


func on_quit_button_pressed():
	get_tree().paused = false
	ScreeenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")


func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lose!"
