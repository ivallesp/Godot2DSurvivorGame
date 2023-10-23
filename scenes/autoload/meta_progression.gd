extends Node

const SAVE_FILE_PATH: String = "user://game.save"
var save_data: Dictionary = {"meta_upgrade_currency": 0, "meta_upgrades": {}}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func load_save_file():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var f = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = f.get_var()


func save():
	var f = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	f.store_var(save_data)


func add_meta_upgrade(meta_upgrade: MetaUpgrade):
	if not save_data["meta_upgrades"].has(meta_upgrade.id):
		save_data["meta_upgrades"][meta_upgrade.id] = {"quantity": 0}
	save_data["meta_upgrades"][meta_upgrade.id]["quantity"] += 1


func on_experience_vial_collected(number: float):
	save_data["meta_upgrade_currency"] += number
