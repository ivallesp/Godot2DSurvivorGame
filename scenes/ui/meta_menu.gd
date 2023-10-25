extends CanvasLayer

var meta_upgrade_card = preload("res://scenes/ui/meta_upgrade_card.tscn")
@onready var grid_container = %GridContainer
@export var upgrades: Array[MetaUpgrade]
@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	for child in grid_container.get_children():
		child.queue_free()

	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_button_pressed():
	ScreeenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
