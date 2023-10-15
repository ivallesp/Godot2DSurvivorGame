extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var hover_animation_player = $HoverAnimationPlayer

signal selected

var disabled: bool = false


func _ready():
	gui_input.connect(on_card_selected)
	mouse_entered.connect(on_mouse_entered)


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = (upgrade.name)
	description_label.text = (upgrade.description)


func on_card_selected(event: InputEvent):
	if event.is_action_pressed("left_click") and not disabled:
		animation_player.play("selected")
		for card in get_tree().get_nodes_in_group("upgrade_card"):
			card.disabled = true
			if card != self:
				card.animation_player.play("discard")
		await animation_player.animation_finished
		selected.emit()


func on_mouse_entered():
	hover_animation_player.play("hover")
