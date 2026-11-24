extends Node3D
@onready var screen_sampler: ScreenSampler = $ScreenSampler
@onready var pinkie_pie: Node3D = $PinkiePie

@export var pan_center: Node3D
@export var pan_camera: Camera3D

@export var orbit_sensitivity := 0.005   # radians per pixel
@export var min_pitch_deg := -85.0
@export var max_pitch_deg := 85.0
var _orbit_last_mouse := Vector2.ZERO
var _was_orbiting := false
@onready var paint_canvas: PaintCanvas = $PaintCanvas
@onready var debug_stamp: TextureRect = $DebugStamp

func _process_painting():
    paint_canvas.painting = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

func _ready():
    screen_sampler.add_visible(pinkie_pie)
    debug_stamp.texture = paint_canvas.paint_texture

func _process_orbit():
    var orbiting := Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)
    var mouse := get_viewport().get_mouse_position()

    if orbiting and _was_orbiting:
        var delta := mouse - _orbit_last_mouse
        var center := pan_center.global_position
        var t := pan_camera.global_transform

        # One rotation, built from the camera's own axes
        var rot := Basis.IDENTITY
        rot = rot.rotated(t.basis.y, -delta.x * orbit_sensitivity)  # yaw about camera up
        rot = rot.rotated(t.basis.x, -delta.y * orbit_sensitivity)  # pitch about camera right

        # Apply it to the orientation and to the offset from the center
        t.basis = (rot * t.basis).orthonormalized()
        t.origin = center + rot * (t.origin - center)
        pan_camera.global_transform = t

    _orbit_last_mouse = mouse
    _was_orbiting = orbiting
    
func _process(_delta: float) -> void:
    _process_painting()
    _process_orbit()
