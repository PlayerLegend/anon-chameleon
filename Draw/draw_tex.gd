class_name DrawTex
extends Node3D

@onready var depth_camera: SyncCamera = $AccumulateViewport/PaintViewport/DepthViewport/DepthCamera
@onready var depth_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/DepthViewport/DepthMesh
@onready var unwrap_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/UnwrapMesh
@onready var accumulate_viewport: SubViewport = $AccumulateViewport

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
    if value == null or value.mesh == null:
        return

    depth_mesh.copy = value
    unwrap_mesh.copy = value

    var paint_tex := accumulate_viewport.get_texture()

    for i in value.mesh.get_surface_count():
        var old_mat := value.mesh.surface_get_material(i)

        var new_material: ShaderMaterial = painted_mesh_material.duplicate()
        new_material.set_shader_parameter("paint_albedo", paint_tex)

        if old_mat is BaseMaterial3D:
            new_material.set_shader_parameter("base_albedo", old_mat.albedo_texture)

        value.set_surface_override_material(i, new_material)
        
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
        
func start_painting():
    accumulate_viewport.start_painting()

func stop_painting():
    accumulate_viewport.stop_painting()
