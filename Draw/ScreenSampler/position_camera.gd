extends SyncCamera

@export var position_material: ShaderMaterial
@export var unwrap_material: ShaderMaterial

func _process(_delta: float):
    super(_delta)
    var width: float = 25.0
    var forward = -global_basis.z
    var origin = global_position + 0.25 * width * forward
    position_material.set_shader_parameter("world_position_width", width)
    position_material.set_shader_parameter("world_position_origin", origin)
    
    unwrap_material.set_shader_parameter("world_position_width", width)
    unwrap_material.set_shader_parameter("world_position_origin", origin)

func _ready():
    assert(position_material)
