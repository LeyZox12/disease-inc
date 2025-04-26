extends Node

const PLAYER_SPEED = 1000.0
var SENS = 0.005
@onready var CAMERA = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var move = Input.get_vector("left", "right", "forward", "backward").normalized()
	var angle = CAMERA.global_rotation.y
	var vel = Vector3(move.y * PLAYER_SPEED * delta, 0.0, move.y * PLAYER_SPEED * delta) * CAMERA.global_basis.z
	vel += Vector3(move.x * PLAYER_SPEED * delta, 0.0, move.x * PLAYER_SPEED * delta) * CAMERA.global_basis.x
	$".".apply_force(vel)


func _input(event: InputEvent) -> void:
	#Camera rotation handling
	if event is InputEventMouseMotion and not CAMERA.get_node("GUI").inventory_out:
		CAMERA.global_rotation.y -= event.relative.x * SENS
		CAMERA.global_rotation.x -= event.relative.y * SENS
		CAMERA.global_rotation.x = clamp(CAMERA.global_rotation.x, -0.90, 0.90)
	if event.is_action_pressed("toggle_inventory"):
		CAMERA.get_node("GUI").toggle_inventory()
	for i in range(CAMERA.get_node("GUI").HOTBAR_MAX):
		if event.is_action_pressed(str(i+1)):
			CAMERA.get_node("GUI/Hotbar").get_child(i).grab_focus()
			break
