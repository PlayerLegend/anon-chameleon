class_name ScreenSampler
extends Node

@onready var position_viewport: ResolutionScaleViewport = $PositionViewport
@onready var unshaded_viewport: SubViewport = $UnshadedViewport
@onready var unshaded_camera: SyncCamera = $UnshadedViewport/UnshadedCamera
@onready var position_camera: SyncCamera = $PositionViewport/PositionCamera
@export var unwrap_material: ShaderMaterial

func _deferred_set_cameras():
    unshaded_camera.copy = camera
    position_camera.copy = camera

@export var camera: Camera3D:
    set(value):
        assert(value)
        camera = value
        _deferred_set_cameras.call_deferred()

var unshaded_texture: ViewportTexture:
    get():
        return unshaded_viewport.get_texture()

var position_texture: ViewportTexture:
    get():
        return position_viewport.get_texture()
        
func add_visible(node: Node):
    if node is MeshInstance3D:
        unshaded_viewport.add_meshinstance(node)
        position_viewport.add_meshinstance(node)
    for child in node.get_children():
        add_visible(child)

func _process(_delta: float):
    unwrap_material.set_shader_parameter("cursor_uv", _get_cursor_uv())
    
func _get_cursor_uv() -> Vector2:
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    var viewport_size: Vector2 = get_viewport().get_visible_rect().size
    var cursor_uv: Vector2 = mouse_pos / viewport_size
    return cursor_uv
 
