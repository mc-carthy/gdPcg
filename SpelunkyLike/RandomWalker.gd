extends Node2D

signal path_completed

const STEP := [Vector2.LEFT, Vector2.LEFT, Vector2.RIGHT, Vector2.RIGHT, Vector2.DOWN]

export (PackedScene) var Rooms := preload("Rooms.tscn")
export var grid_size := Vector2(8, 6)

var _rooms: Node2D = null
var _rng := RandomNumberGenerator.new()
var _state: Dictionary = {}
var _horizontal_chance: float = 0.0

onready var camera: Camera2D = $Camera2D
onready var timer: Timer = $Timer
onready var level: TileMap = $Level

func _ready() -> void:
	_rng.randomize()
	
	_rooms = Rooms.instance()
	_horizontal_chance = 1.0 - STEP.count(Vector2.DOWN) / float(STEP.size())
	
	_setup_camera()
	_generate_level()

func _setup_camera():
	var world_size := _grid_to_world(grid_size)
	camera.position =  world_size / 2
	
	var ratio := world_size / OS.window_size
	var zoom_max := max(ratio.x, ratio.y) + 1
	camera.zoom = Vector2(zoom_max, zoom_max)

func _generate_level() -> void:
	_reset()
	_update_start_position()
	while _state.offset.y < grid_size.y:
		_update_room_type()
		_update_next_position()
		_update_down_counter()

	_place_walls()
	_place_path_rooms()
	_place_side_rooms()

func _grid_to_world(grid_size) -> Vector2:
	return Vector2()

func _reset() -> void:
	pass

func _update_start_position() -> void:
	pass

func _update_room_type() -> void:
	pass

func _update_next_position() -> void:
	pass

func _update_down_counter() -> void:
	pass

func _place_walls() -> void:
	pass

func _place_path_rooms() -> void:
	pass

func _place_side_rooms() -> void:
	pass
