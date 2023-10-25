extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var purchase_button = %PurchaseButton
@onready var progress_bar = %ProgressBar
@onready var experience_label = %ExperienceLabel
@onready var count_label = %CountLabel

var upgrade = null


func _ready():
	purchase_button.button_up.connect(on_button_click)


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = (upgrade.name)
	description_label.text = (upgrade.description)
	update_progress()


func update_progress():
	var exp = MetaProgression.save_data["meta_upgrade_currency"]
	var cost = upgrade.experience_cost
	var count = 0
	var upgrades_dict = MetaProgression.save_data["meta_upgrades"]
	if upgrades_dict.has(upgrade.id):
		count = upgrades_dict[upgrade.id]["quantity"]
	var is_maxed = count >= upgrade.max_quantity
	var progress = min(exp / cost, 1)
	progress_bar.value = progress
	experience_label.text = str(exp) + "/" + str(cost)
	count_label.text = "x" + str(count)
	purchase_button.disabled = exp < cost || is_maxed
	if is_maxed:
		purchase_button.text = "Max"


func select_card():
	animation_player.play("selected")


func on_button_click():
	select_card()
	var cost = upgrade.experience_cost
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
