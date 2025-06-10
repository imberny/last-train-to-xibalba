class_name Game extends Node

var _level: Level

var _player: PlayerVehicle2D


func _ready() -> void:
	get_tree().node_added.connect(_on_tree_node_added)
	get_tree().node_removed.connect(_on_tree_node_removed)


func get_player() -> PlayerVehicle2D:
	return _player


func get_level() -> Level:
	return _level


func spawn(node: Node) -> void:
	get_level().add_child(node)


func spawn_player(player_vehicle_definition: PlayerVehicleDefinition) -> void:
	var player_node: PlayerVehicle2D = (
		load("res://src/entities/player_vehicle_2d/player_vehicle_2d.tscn").instantiate()
	)
	player_node.transform = get_level().get_player_spawn_point().transform
	spawn(player_node)
	player_node.equip_primary(player_vehicle_definition.primary_gun.scene.instantiate())
	player_node.equip_secondary(player_vehicle_definition.secondary_gun.scene.instantiate())
	player_node.equip_melee(player_vehicle_definition.melee.scene.instantiate())


func _on_tree_node_added(node: Node) -> void:
	if node is PlayerVehicle2D:
		_player = node
	elif node is Level:
		_level = node


func _on_tree_node_removed(node: Node) -> void:
	if node == _player:
		_player = null
	elif node == _level:
		_level = null
