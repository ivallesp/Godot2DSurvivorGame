extends Node
class_name VialDropComponent

@export var vial_scene: PackedScene
@export var health_component_node: HealthComponent
@export_range(0, 1) var drop_proba: float = 0.5


func _ready():
	health_component_node.died.connect(on_dead)


func on_dead():
	if not owner is Node2D:
		return
	if randf() < drop_proba:
		var death_location = (owner as Node2D).global_position
		var vial_instance = vial_scene.instantiate() as Node2D
		var ents_layer = get_tree().get_first_node_in_group("entities_layer")
		ents_layer.add_child(vial_instance)
		vial_instance.global_position = death_location
