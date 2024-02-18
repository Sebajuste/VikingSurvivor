extends Node

@export var init_scene_path : String
@export var minimum_loading := 2.0
@export var _faded : bool


@onready var level = $Level
@onready var animation_player = $AnimationPlayer


var loading := false
var _scene = null
var _scene_loaded := false
var _loading_time := 0.0





# Called when the node enters the scene tree for the first time.
func _ready():
	_faded = true
	LevelLoader.load_started.connect(_on_level_load_started)
	LevelLoader.load_ended.connect(_on_level_load_ended)
	await get_tree().process_frame
	if init_scene_path:
		LevelLoader.thread_load(init_scene_path)
		#var scene = init_scene.instantiate()
		#level.add_child(scene)
		#animation_player.play("fade_out")
		#animation_player.play("fade_in")
	pass # Replace with function body.

func _process(delta: float):
	if loading:
		_loading_time += delta
	if _loading_time >= minimum_loading and _scene_loaded:
		loading = false
		_scene_loaded = false
		clean()
		level.add_child(_scene)
		_scene = null
		if _faded:
			animation_player.play("fade_out")

func clean():
	for child in level.get_children():
		child.queue_free()

func _on_level_load_started(_path):
	loading = true
	_scene_loaded = false
	_loading_time = 0.0
	if not _faded:
		animation_player.play("fade_in")
	pass

func _on_level_load_ended(scene):
	_scene_loaded = true
	if scene:
		_scene = scene
	pass

