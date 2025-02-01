extends VBoxContainer
const WORLD = preload("res://main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func _on_new_game_button_pressed():
	var world_scene = WORLD.instantiate()
	get_tree().root.add_child(world_scene)  # Add the new scene
	get_tree().current_scene.queue_free()  # Remove the old scene
	get_tree().current_scene = world_scene  # Manually update current_scene
