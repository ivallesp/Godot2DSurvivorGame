extends CanvasLayer

@export var upgrade_card_scene: PackedScene
@onready var card_container: HBoxContainer = %CardContainer
signal upgrade_selected(upgrade: AbilityUpgrade)


func _ready():
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card = upgrade_card_scene.instantiate()
		card_container.add_child(card)
		card.set_ability_upgrade(upgrade)
		card.selected.connect(on_upgrade_selected.bind(upgrade))


func on_upgrade_selected(upgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false  # Unpause
	queue_free()  # Destroy
