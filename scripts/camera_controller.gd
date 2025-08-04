extends Camera2D

@export var zoom_speed : float = 10

var zoom_target : Vector2
var drag_start_mouse_pos = Vector2.ZERO
var drag_start_camera_pos = Vector2.ZERO
var is_dragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom_target = zoom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	zoom_camera(delta)
	pan_camera(delta)
	click_and_drag()
	
func zoom_camera(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_target *= 0.9
	
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)
	
func pan_camera(delta):
	var pan_amount = Vector2.ZERO
	if Input.is_action_pressed("camera_move_right"):
		pan_amount.x += 1
	if Input.is_action_pressed("camera_move_left"):
		pan_amount.x -= 1
	if Input.is_action_pressed("camera_move_down"):
		pan_amount.y += 1
	if Input.is_action_pressed("camera_move_up"):
		pan_amount.y -= 1
	
	pan_amount = pan_amount.normalized()
	position += pan_amount * delta * 1000 * (1/zoom.x)

func click_and_drag():
	if not is_dragging and Input.is_action_just_pressed("camera_pan"):
		drag_start_mouse_pos = get_viewport().get_mouse_position()
		drag_start_camera_pos = position
		is_dragging = true
	if is_dragging and Input.is_action_just_released("camera_pan"):
		is_dragging = false
	
	if is_dragging:
		var move_vector = get_viewport().get_mouse_position() - drag_start_mouse_pos
		position = drag_start_camera_pos - move_vector * 1/zoom.x
