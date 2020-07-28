extends Node2D

export var level_size: Vector2 = Vector2(100, 80)
export var rooms_size: Vector2 = Vector2(10, 14)
export var rooms_max: int = 15

onready var level: TileMap = $Level
onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	_setup_camera()
	_generate()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		_generate()
	if Input.is_action_just_pressed('ui_cancel'):
		get_tree().quit()

func _setup_camera() -> void:
	camera.position = level.map_to_world(level_size / 2)
	
	# TODO: Get rid of magic number '8'
	var z: float = max(level_size.x, level_size.y) / 8
	camera.zoom = Vector2(z, z)

func _generate() -> void:
	level.clear()
	for vector in _generate_data():
		level.set_cellv(vector, 0)

func _generate_data() -> Array:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	var data := {}
	var rooms := []
	for _r in range(rooms_max):
		var room = _get_random_room(rng)
		if _intersects(room, rooms):
			continue
		
		_add_room(data, rooms, room)
		if rooms.size() > 1:
			var room_previous: Rect2 = rooms[-2]
			_add_connection(rng, data, room_previous, room)
	
	return data.keys()

func _get_random_room(rng: RandomNumberGenerator) -> Rect2:
	var width: int = rng.randi_range(rooms_size.x, rooms_size.y)
	var height: int = rng.randi_range(rooms_size.x, rooms_size.y)
	var x: int = rng.randi_range(0, level_size.x - width - 1)
	var y: int = rng.randi_range(0, level_size.y - height - 1)
	return Rect2(x, y, width, height)

func _add_room(data: Dictionary, rooms: Array, room: Rect2) -> void:
	rooms.push_back(room)
	for x in range(room.position.x, room.end.x):
		for y in range(room.position.y, room.end.y):
			data[Vector2(x, y)] = null

func _intersects(room: Rect2, rooms: Array) -> bool:
	var intersecting: bool = false
	for other_room in rooms:
		if room.intersects(other_room):
			intersecting = true
			break
	return intersecting

func _add_connection(rng: RandomNumberGenerator, data: Dictionary, room1: Rect2, room2: Rect2) -> void:
	var room_center1 := (room1.position + room1.end) / 2
	var room_center2 := (room2.position + room2.end) / 2
	if rng.randi_range(0, 1) == 0:
		_add_corridor(data, room_center1.x, room_center2.x, room_center1.y, Vector2.AXIS_X)
		_add_corridor(data, room_center1.y, room_center2.y, room_center2.x, Vector2.AXIS_Y)
	else:
		_add_corridor(data, room_center1.y, room_center2.y, room_center1.x, Vector2.AXIS_Y)
		_add_corridor(data, room_center1.x, room_center2.x, room_center2.y, Vector2.AXIS_X)

func _add_corridor(data: Dictionary, start: int, end: int, constant: int, axis: int) -> void:
	for t in range(min(start, end), max(start, end) + 1):
		var point := Vector2.ZERO
		match axis:
			Vector2.AXIS_X: point = Vector2(t, constant)
			Vector2.AXIS_Y: point = Vector2(constant, t)
		data[point] = null
