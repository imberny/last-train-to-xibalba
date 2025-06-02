class_name Util


static func disable(node: Node) -> void:
	_set_enabled(node, false)


static func enable(node: Node) -> void:
	_set_enabled(node, true)


static func exit_tree(node: Node) -> void:
	if node.is_inside_tree():
		node.get_parent().remove_child(node)


static func _set_enabled(node: Node, is_enabled: bool) -> void:
	node.set_process(is_enabled)
	node.set_physics_process(is_enabled)
	node.set_process_input(is_enabled)
	node.set_process_shortcut_input(is_enabled)
	node.set_process_unhandled_input(is_enabled)
	node.set_process_unhandled_key_input(is_enabled)
