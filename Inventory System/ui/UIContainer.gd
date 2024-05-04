extends Control


func _input(event):
	if event.is_action_pressed("inventory"):
		%PlayerInventory.visible = not %PlayerInventory.visible


func _on_settings_button_pressed() -> void:
	%Settings.visible = !%Settings.visible
	%Settings.move_to_front()


func _on_quit_pressed():
	get_tree().quit()


func _on_save_pressed():
	# SaveManager.save_game()
	pass


func _on_load_pressed():
	# SaveManager.load_game()
	pass
