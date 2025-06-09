extends Node

var _pairs_2d_to_3d: Dictionary[Node2D, Node3D]


func _ready() -> void:
	get_tree().node_added.connect(_on_tree_node_added)
	get_tree().node_removed.connect(_on_tree_node_removed)


func _process(_delta: float) -> void:
	for node2d in _pairs_2d_to_3d.keys():
		var node3d = _pairs_2d_to_3d[node2d]
		node3d.global_position = Vector3(
			node2d.global_position.x / 400.0 - 0.5, 0.0, node2d.global_position.y / 200.0 - 0.5
		)


func _instantiate(path: StringName) -> Node:
	var node: Node = load(path).instantiate()
	add_child(node)
	return node


func _on_tree_node_added(node: Node) -> void:
	if node is PlayerVehicle2D:
		_pairs_2d_to_3d[node as Node2D] = _instantiate(
			&"res://src/visuals/player_3d/player_3d.tscn"
		)


func _on_tree_node_removed(node: Node) -> void:
	if _pairs_2d_to_3d.has(node as Node2D):
		_pairs_2d_to_3d[node as Node2D].queue_free()
		_pairs_2d_to_3d.erase(node)
