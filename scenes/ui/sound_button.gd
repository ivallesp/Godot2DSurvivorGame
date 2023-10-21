extends Button

@onready var audio_player = $RandomAudioStreamPlayerComponent


func _ready():
	pressed.connect(on_button_pressed)


func on_button_pressed():
	audio_player.play_random_stream()
