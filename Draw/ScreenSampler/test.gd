extends Node3D

@onready var screen_sampler: ScreenSampler = $ScreenSampler
@onready var camera_3d: Camera3D = $Camera3D
@onready var pinkie_pie: Node3D = $PinkiePie
@onready var unshaded_screen: TextureRect = $HBoxContainer/UnshadedScreen
@onready var position_screen: TextureRect = $HBoxContainer/PositionScreen

func _ready():
    screen_sampler.camera = camera_3d
    position_screen.texture = screen_sampler.position_texture
    unshaded_screen.texture = screen_sampler.unshaded_texture
    
    screen_sampler.add_visible(pinkie_pie)
