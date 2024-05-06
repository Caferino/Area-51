class_name ItemInfoLine extends Label

func _init(value, color):
	text = value
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	set("theme_override_fonts/font", AlcarodianResourceManager.fonts["Arcadepix"])
	set("theme_override_font_size/font_size", 8)
	set("theme_override_colors/font_color", AlcarodianResourceManager.colors[color])
