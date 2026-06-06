class_name OfflineGainPopup
extends Control


@onready var message_label: Label = %MessageLabel
@onready var close_button: Button = %CloseButton


func _ready() -> void:
	close_button.pressed.connect(queue_free)


func open(message: String, available_size: Vector2) -> void:
	message_label.text = message

	var popup_width := minf(available_size.x - 48.0, 520.0)
	size = Vector2(popup_width, 170.0)
	position = Vector2((available_size.x - popup_width) * 0.5, 150.0)
	pivot_offset = size * 0.5

	modulate.a = 0.0
	scale = Vector2(0.9, 0.9)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_interval(3.0)
	tween.chain().tween_property(self, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(queue_free)
