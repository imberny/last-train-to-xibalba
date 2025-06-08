class_name AutoLabel extends Label

@export var _target: Node
@export var _property_path: StringName


func _process(_delta: float) -> void:
	text = str(_target[_property_path])
