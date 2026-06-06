class_name InfoPopup
extends Panel


@onready var title_label: Label = %TitleLabel
@onready var body_label: RichTextLabel = %BodyLabel
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	close_button.pressed.connect(queue_free)


func open(title: String, description: String, accent: Color, available_width: float) -> void:
	title_label.text = title
	title_label.add_theme_color_override("font_color", accent.lightened(0.18))
	body_label.text = description

	var popup_width := minf(available_width - 64.0, 460.0)
	size = Vector2(popup_width, 240.0)
	position = Vector2((available_width - popup_width) * 0.5, 270.0)
	pivot_offset = size * 0.5

	var style := get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style.border_color = accent
	add_theme_stylebox_override("panel", style)

	modulate.a = 0.0
	scale = Vector2(0.92, 0.92)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
