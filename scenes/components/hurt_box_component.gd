extends Area2D
class_name HurtBoxComponent

@export var health_component: Node
var floating_text = preload("res://scenes/ui/floating_text.tscn")
signal hit


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if not other_area is HitBoxComponent:
		return
	if health_component == null:
		return
	health_component.damage(other_area.damage)

	var txt = floating_text.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(txt)
	txt.global_position = global_position + Vector2.UP * 16
	txt.start(str(round(other_area.damage)))
	hit.emit()
