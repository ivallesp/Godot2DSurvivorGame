extends Node

@onready var timer = $Timer
@export var end_screen_scene: PackedScene

signal arena_difficulty_increased(arena_difficulty)

const DIFFICULTY_INTERVAL = 5  # Frequency of arena difficuly increase
var arena_difficulty: int = 0
var previous_time = 0  # Variable for storing the original Timer's wait time


func _ready():
	timer.timeout.connect(on_timer_timeout)
	previous_time = timer.wait_time


func _process(delta):
	var wait_time = timer.wait_time
	var next_time = wait_time - (arena_difficulty + 1) * DIFFICULTY_INTERVAL
	if timer.time_left <= next_time:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	var time_elapsed = timer.wait_time - timer.time_left
	return time_elapsed


func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	MetaProgression.save()  # Save the game
	add_child(end_screen_instance)
	end_screen_instance.play_jingles(false)
