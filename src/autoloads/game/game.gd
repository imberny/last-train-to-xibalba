class_name Game extends Node

var level: Level

var _player: PlayerVehicle2D


func _ready() -> void:
	get_tree().node_added.connect(_on_tree_node_added)
	get_tree().node_removed.connect(_on_tree_node_removed)


func get_player() -> PlayerVehicle2D:
	return _player


func _on_tree_node_added(node: Node) -> void:
	if node is PlayerVehicle2D:
		_player = node


func _on_tree_node_removed(node: Node) -> void:
	if node is PlayerVehicle2D:
		_player = null
