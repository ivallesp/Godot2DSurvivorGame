extends CanvasLayer

@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var window_button = %WindowButton as Button
@onready var back_button = %BackButton as Button


func _ready():
	update_screen()
	window_button.pressed.connect(on_window_button_pressed)
	music_slider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("Sfx"))
	back_button.pressed.connect(on_back_button_pressed)


func update_screen():
	var current_mode = get_window_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Switch to Windowed mode"
	else:
		window_button.text = "Switch to Fullscreen mode"
	sfx_slider.value = get_volume_percent("Sfx")
	music_slider.value = get_volume_percent("Music")


func get_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_volume_percent(bus_name: String, volume_percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percent))


func get_window_mode():
	return DisplayServer.window_get_mode()


func set_window_mode(mode):
	DisplayServer.window_set_mode(mode)


func toggle_window_mode():
	var current_mode = get_window_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		set_window_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		set_window_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func on_window_button_pressed():
	toggle_window_mode()
	update_screen()


func on_audio_slider_changed(value: float, bus_name: String):
	print(bus_name, value)
	set_volume_percent(bus_name, value)


func on_back_button_pressed():
	queue_free()
