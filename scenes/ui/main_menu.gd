extends CanvasLayer

@onready var play_button = %PlayButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton
@onready var meta_button = %MetaButton
var options_menu = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	play_button.pressed.connect(on_play_button_pressed)
	meta_button.pressed.connect(on_meta_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func on_play_button_pressed():
	ScreeenTransition.transition_to_scene("res://scenes/main/main.tscn")


func on_meta_button_pressed():
	ScreeenTransition.transition_to_scene("res://scenes/ui/meta_menu.tscn")


func on_options_button_pressed():
	var options_menu_instance = options_menu.instantiate()
	add_child(options_menu_instance)  # Display over main menu


func on_quit_button_pressed():
	ScreeenTransition.transition()
	await ScreeenTransition.transition_halfway
	get_tree().quit()
