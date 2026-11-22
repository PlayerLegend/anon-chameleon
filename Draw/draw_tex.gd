class_name DrawTex
extends Node3D

@onready var accumulate_viewport: SubViewport = $AccumulateViewport
@onready var paint_viewport: SubViewport = $AccumulateViewport/PaintViewport
@onready var unwrap_camera: Camera3D = $AccumulateViewport/PaintViewport/UnwrapCamera
@onready var unwrap_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/UnwrapMesh
@onready var depth_viewport: SubViewport = $AccumulateViewport/PaintViewport/DepthViewport
@onready var depth_camera: SyncCamera = $AccumulateViewport/PaintViewport/DepthViewport/DepthCamera
@onready var depth_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/DepthViewport/DepthMesh
@onready var stamp_rect: TextureRect = $AccumulateViewport/StampRect

@onready var debug_screen: ColorRect = $DebugScreen

@export var screen_material: ShaderMaterial
@export var painted_mesh_material: ShaderMaterial
@export var unwrap_material: ShaderMaterial

func _deferred_set_cameras(value: Camera3D):
    depth_camera.copy = value

@export var camera: Camera3D:
    set(value):
        camera = value
        _deferred_set_cameras.call_deferred(value)

func _deferred_set_mesh(value: MeshInstance3D):
    depth_mesh.copy = value
    unwrap_mesh.copy = value
    var old_mat = value.mesh.surface_get_material(0)

    if old_mat is StandardMaterial3D:
        var new_material: ShaderMaterial = painted_mesh_material.duplicate()
        new_material.set_shader_parameter("base_albedo", old_mat.albedo_texture)
        new_material.set_shader_parameter("paint_albedo", accumulate_viewport.get_texture())
        value.material_override = new_material
    else:
        assert(false)

@export var paint_mesh: MeshInstance3D:
    set(value):
        paint_mesh = value
        _deferred_set_mesh.call_deferred(value)
        
func _get_cursor_uv() -> Vector2:
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    var viewport_size: Vector2 = get_viewport().get_visible_rect().size
    var cursor_uv: Vector2 = mouse_pos / viewport_size
    return cursor_uv

func _process(_delta: float) -> void:
    paint_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

    var uv := _get_cursor_uv()
    unwrap_material.set_shader_parameter("cursor_uv", uv)

    # Feed the MAIN camera's data into the unwrap shader so it can unproject
    # the cursor ray in the same space the depth texture was rendered from.
    if camera:
        var xform := camera.global_transform
        unwrap_material.set_shader_parameter("main_cam_inv_view", xform.affine_inverse())
        unwrap_material.set_shader_parameter("main_cam_inv_proj", camera.get_camera_projection().inverse())
        unwrap_material.set_shader_parameter("main_cam_pos", xform.origin)
        unwrap_material.set_shader_parameter("main_cam_far", camera.far)
        
func _ready():
    paint_viewport.size = accumulate_viewport.size
    unwrap_material.set_shader_parameter("depth_texture", depth_viewport.get_texture())
    screen_material.set_shader_parameter("screen_render", paint_viewport.get_texture())
    
    stamp_rect.texture = paint_viewport.get_texture()
    stamp_rect.size = Vector2(accumulate_viewport.size)

var painting: bool

func start_painting():
    if not painting:
        paint_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
        accumulate_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
        painting = true

func stop_painting():
    if painting:
        paint_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
        accumulate_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
        painting = false
