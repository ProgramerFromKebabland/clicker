class_name StatsSection
extends VBoxContainer


const STATS_CARD_SCENE := preload("res://scenes/ui/stats_card.tscn")


@onready var heading_label: Label = %HeadingLabel
@onready var cards_grid: GridContainer = %CardsGrid


func setup(title: String, accent: Color) -> void:
	heading_label.text = title
	heading_label.add_theme_color_override("font_color", accent.lightened(0.15))


func add_entry(label_text: String, value_text: String, accent: Color) -> StatsCard:
	var card := STATS_CARD_SCENE.instantiate() as StatsCard
	cards_grid.add_child(card)
	card.setup(label_text, value_text, accent)
	return card
