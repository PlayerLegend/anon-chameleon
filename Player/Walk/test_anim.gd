extends Node3D

@export var player_model_scene: PackedScene
@onready var player_walk_controller: PlayerWalkController = $PlayerWalkController

func _ready():
    var pmodel = player_model_scene.instantiate()
    player_walk_controller.visual_model = pmodel
    player_walk_controller.walk_anim()
