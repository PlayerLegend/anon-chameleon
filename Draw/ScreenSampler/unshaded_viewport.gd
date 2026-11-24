extends ResolutionScaleViewport

func _set_unshaded(mesh_inst: MeshInstance3D) -> void:
    for i in mesh_inst.get_surface_override_material_count():
        var original := mesh_inst.get_active_material(i)
        if original is BaseMaterial3D:
            var mat: BaseMaterial3D = original.duplicate()
            mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
            mesh_inst.set_surface_override_material(i, mat)
            
func add_meshinstance(target: MeshInstance3D):
    var sync_mesh = MeshInstanceSync.new()
    add_child(sync_mesh)
    sync_mesh.copy = target
    _set_unshaded(sync_mesh)
    
func _ready():
    transparent_bg = true
    msaa_3d = Viewport.MSAA_DISABLED
