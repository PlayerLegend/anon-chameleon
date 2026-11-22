extends SubViewport

@onready var unwrap_viewport: SubViewport = $UnwrapViewport

func _process(_delta: float):
    unwrap_viewport.size = size

func _ready():
    transparent_bg = true
    disable_3d = true
    render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE  # clears the first frame, then never
