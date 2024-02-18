extends Node

signal load_started(path)
signal load_progress_changed(value)
signal load_ended(scene)


var _scene_path : String
var _progress := []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.

func _process(_delta):
	if not _scene_path:
		set_process(false)
	var load_status = ResourceLoader.load_threaded_get_status(_scene_path, _progress)
	match load_status:
		0, 2: #? THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			push_error("Error load resource ", load_status)
			set_process(false)
			return
		1: #? THREAD_LOAD_IN_PROGRESS
			load_progress_changed.emit(_progress[0])
		3: #? THREAD_LOAD_LOADED
			var scene := ResourceLoader.load_threaded_get(_scene_path)
			load_progress_changed.emit(1.0)
			load_ended.emit(scene.instantiate())
			set_process(false)

func thread_load(path: String):
	if not path:
		push_warning("No scene to load")
		return
	_scene_path = path
	var state = ResourceLoader.load_threaded_request(_scene_path)
	if state == OK:
		load_started.emit(_scene_path)
		set_process(true)

func load(packed_scene: PackedScene):
	
	load_started.emit(packed_scene)
	
	var scene = packed_scene.instantiate()
	load_ended.emit(scene)
	pass
