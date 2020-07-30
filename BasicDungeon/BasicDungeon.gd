extends Node2D

const FACTOR: float = 0.125

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
	for vector in Generator.generate(level_size, rooms_size, rooms_max):
		level.set_cellv(vector, 0)
