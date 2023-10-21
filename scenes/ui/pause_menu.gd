extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var panel_container = %PanelContainer
@onready var resume_button = %ResumeButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton
var options_menu = preload("res://scenes/ui/options_menu.tscn")
var is_closing = false


func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	get_tree().paused = true
	animation_player.play("in")
	animate_scale_menu()
	resume_button.pressed.connect(on_resume_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func animate_scale_menu(reverse = false):
	var tween = create_tween()
	if reverse:
		tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
		(
			tween
			. tween_property(panel_container, "scale", Vector2.ZERO, .3)
			. set_ease(Tween.EASE_IN)
			. set_trans(Tween.TRANS_BACK)
		)
	else:
		tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
		(
			tween
			. tween_property(panel_container, "scale", Vector2.ONE, .3)
			. set_ease(Tween.EASE_OUT)
			. set_trans(Tween.TRANS_BACK)
		)
	await tween.finished


func close():
	if is_closing:
		return
	is_closing = true
	animation_player.play("out")
	animate_scale_menu(true)
	await animation_player.animation_finished
	get_tree().paused = false
	queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func on_resume_button_pressed():
	close()


func on_options_button_pressed():
	var options_menu_instance = options_menu.instantiate()
	add_child(options_menu_instance)  # Display over main menu
	# options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))


func on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

# func on_options_back_pressed(options_menu: Node):
# 	options_menu.queue_free()
