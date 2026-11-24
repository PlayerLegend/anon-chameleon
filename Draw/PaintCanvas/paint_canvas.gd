class_name PaintCanvas
extends Node

@onready var accumulate_viewport: SubViewport = $AccumulateViewport
@onready var unwrap_mesh: MeshInstanceSync = $AccumulateViewport/PaintViewport/UnwrapMesh
@export var base_material: ShaderMaterial
@export var outline_material: ShaderMaterial

func _assign_paint_materials(target: MeshInstance3D):
    var paint_tex := accumulate_viewport.get_texture()

    for i in target.mesh.get_surface_count():
        var old_mat := target.mesh.surface_get_material(i)

        var new_material: ShaderMaterial
        
        var surface_name = target.mesh.surface_get_name(i)
        
        if surface_name.to_lower().contains("outline"):
            new_material = outline_material.duplicate()
        else:
            new_material = base_material.duplicate()
            
        new_material.set_shader_parameter("paint_albedo", paint_tex)
        
        if old_mat is BaseMaterial3D:
            new_material.set_shader_parameter("base_albedo", old_mat.albedo_texture)

        target.set_surface_override_material(i, new_material)
        
func _deferred_set_mesh_instance():
    unwrap_mesh.copy =  mesh_instance
    _assign_paint_materials(mesh_instance)
    
@export var mesh_instance: MeshInstance3D:
    set(value):
        assert(!mesh_instance)
        assert(value)
        mesh_instance = value
        _deferred_set_mesh_instance.call_deferred()

var paint_texture: ViewportTexture:
    get():
        return accumulate_viewport.get_texture()

var painting: bool:
    set(value):
        if painting == value:
            return
        print("Painting ", value)
        painting = value
        accumulate_viewport.painting = value
