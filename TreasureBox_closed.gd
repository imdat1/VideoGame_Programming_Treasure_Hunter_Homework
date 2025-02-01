extends Node3D

@onready var area = $Area3D  # Reference to Area3D" 
const TREASURE_OPENED = preload("res://treasure_box_open.tscn")  # Changed from closed to opened
var player_near = false  # Track if the player is close

func _ready() -> void:
	area.connect("body_entered", _on_area_3d_body_entered)  # Removed Callable() as it's not needed in newer Godot versions
	area.connect("body_exited", _on_area_3d_body_exited)

# Check if the player is near and presses 'F'
func _process(_delta: float) -> void:  # Added underscore since delta isn't used
	if player_near and Input.is_action_just_pressed("open_chest"):  # Default is 'F' key
		open_chest()

func _on_area_3d_body_entered(body: Node3D) -> void:  # Fixed function name format
	if body.name == "Rogue_Hooded":  # Adjust name based on your player node
		player_near = true

func _on_area_3d_body_exited(body: Node3D) -> void:  # Fixed function name format
	if body.name == "Rogue_Hooded":
		player_near = false

# Call this method when the player presses 'F' and opens the chest
func open_chest() -> void:  # Added return type
	if player_near:
		if GameManager.has_method("open_chest"):  # Added safety check
			GameManager.open_chest()  # Increment the chest counter in GameManager
		
		var opened_chest = TREASURE_OPENED.instantiate()
		opened_chest.global_position = global_position  # Changed to global_position
		
		if get_parent():  # Added safety check
			get_parent().add_child(opened_chest)
			queue_free()  # Remove the old closed chest from the scene
