class_name StatsCard
extends PanelContainer


@onready var value_label: Label = %ValueLabel
@onready var name_label: Label = %NameLabel


func setup(label_text: String, value_text: String, accent: Color) -> void:
	name_label.text = label_text
	value_label.text = value_text
	value_label.add_theme_color_override("font_color", accent.lightened(0.25))

	var style := get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style.border_color = Color(accent.r, accent.g, accent.b, 0.42)
	style.border_width_left = 5
	add_theme_stylebox_override("panel", style)
