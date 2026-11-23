class_name DrawTex
extends Node3D

@onready var depth_camera: SyncCamera = $AccumulateViewport/PaintViewport/DepthViewport/DepthCamera
@onready var depth_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/DepthViewport/DepthMesh
@onready var unwrap_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/UnwrapMesh
@onready var accumulate_viewport: SubViewport = $AccumulateViewport

@export var screen_material: ShaderMaterial
@export var painted_mesh_base_material: ShaderMaterial
@export var painted_mesh_outline_material: ShaderMaterial
@export var unwrap_material: ShaderMaterial

func _deferred_set_cameras(value: Camera3D):
    depth_camera.copy = value

@export var camera: Camera3D:
    set(value):
        camera = value
        _deferred_set_cameras.call_deferred(value)
        
func _override_materials(target: MeshInstance3D):
    var paint_tex := accumulate_viewport.get_texture()

    for i in target.mesh.get_surface_count():
        var old_mat := target.mesh.surface_get_material(i)

        var new_material: ShaderMaterial
        
        var surface_name = target.mesh.surface_get_name(i)
        
        if surface_name.to_lower().contains("outline"):
            new_material = painted_mesh_outline_material.duplicate()
        else:
            new_material = painted_mesh_base_material.duplicate()
            
        new_material.set_shader_parameter("paint_albedo", paint_tex)
        
        print("Surface ", i, " name: ", target.mesh.surface_get_name(i))
        
        if old_mat is BaseMaterial3D:
            new_material.set_shader_parameter("base_albedo", old_mat.albedo_texture)

        target.set_surface_override_material(i, new_material)
        
func _deferred_set_mesh(value: MeshInstance3D):
    if value == null or value.mesh == null:
        return

    depth_mesh.copy = value
    unwrap_mesh.copy = value

    _override_materials(value)
    
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
