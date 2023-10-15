extends CanvasLayer

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player = $AnimationPlayer
signal upgrade_selected(upgrade: AbilityUpgrade)


func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card = upgrade_card_scene.instantiate()
		card_container.add_child(card)
		card.set_ability_upgrade(upgrade)
		card.play_in(delay)
		card.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += .3


func on_upgrade_selected(upgrade):
	upgrade_selected.emit(upgrade)
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false  # Unpause
	queue_free()  # Destroy
