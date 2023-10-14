extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

signal selected


func _ready():
	gui_input.connect(on_card_selected)


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = (upgrade.name)
	description_label.text = (upgrade.description)


func on_card_selected(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
