extends ResolutionScaleViewport

@export var position_material: ShaderMaterial
@export var unwrap_material: ShaderMaterial
@onready var position_camera: SyncCamera = $PositionCamera

func add_meshinstance(target: MeshInstance3D):
    var sync_mesh = MeshInstanceSync.new()
    add_child(sync_mesh)
    sync_mesh.copy = target
    sync_mesh.material_override = position_material
    
func _ready():
    assert(position_material)
    transparent_bg = true
    use_hdr_2d = true
    msaa_3d = Viewport.MSAA_DISABLED
    unwrap_material.set_shader_parameter("world_position_texture", get_texture())
