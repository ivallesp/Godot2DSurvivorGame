extends AudioStreamPlayer
@onready var timer = $Timer


func _ready():
	finished.connect(on_music_finished)
	timer.timeout.connect(on_timer_timeout)


func on_music_finished():
	timer.start()


func on_timer_timeout():
	play()
