extends RefCounted
class_name CrateLogic

const CRATE_CLOSED := preload("res://assets/generated/cat_crate_closed.png")
const CRATE_OPEN := preload("res://assets/generated/cat_crate_open.png")
const GEM_FRAME := preload("res://assets/generated/cat_gem_frame.png")
const FRAGMENTS_PER_LEVEL := 5
const MAX_GEM_LEVEL := 10
const MAX_GEM_FRAGMENTS := FRAGMENTS_PER_LEVEL * MAX_GEM_LEVEL
const MAX_WORKSHOP_LEVEL := 8

const CRATE_DATA: Array[Dictionary] = [
	{
		"id": "cozy",
		"name": "COZY CRATE",
		"tagline": "A friendly first sparkle",
		"cost": 600,
		"picks": 1,
		"fragments": 1,
		"accent": Color(0.27, 0.86, 0.95, 1.0),
		"art": "res://assets/generated/cat_crate_closed.png",
		"open_art": "res://assets/generated/cat_crate_open.png",
		"rarities": [["common", 0.82], ["rare", 0.16], ["epic", 0.02]],
	},
	{
		"id": "sparkle",
		"name": "SPARKLE CRATE",
		"tagline": "Better odds, brighter gems",
		"cost": 25000,
		"picks": 2,
		"fragments": 2,
		"accent": Color(0.72, 0.42, 1.0, 1.0),
		"art": "res://assets/generated/chests/sparkle.png",
		"open_art": "res://assets/generated/chests/sparkle_open.png",
		"rarities": [["common", 0.34], ["rare", 0.45], ["epic", 0.19], ["mythic", 0.02]],
	},
	{
		"id": "royal",
		"name": "ROYAL CRATE",
		"tagline": "Built for legendary cats",
		"cost": 750000,
		"picks": 3,
		"fragments": 4,
		"accent": Color(1.0, 0.72, 0.18, 1.0),
		"art": "res://assets/generated/chests/royal.png",
		"open_art": "res://assets/generated/chests/royal_open.png",
		"rarities": [["rare", 0.22], ["epic", 0.52], ["mythic", 0.26]],
	},
	{
		"id": "celestial",
		"name": "CELESTIAL CHEST",
		"tagline": "Moonlit treasure from the stars",
		"cost": 12000000,
		"picks": 4,
		"fragments": 7,
		"accent": Color(0.25, 0.76, 1.0, 1.0),
		"art": "res://assets/generated/chests/celestial.png",
		"open_art": "res://assets/generated/chests/celestial_open.png",
		"rarities": [["epic", 0.30], ["mythic", 0.52], ["legendary", 0.18]],
	},
	{
		"id": "void",
		"name": "VOID CHEST",
		"tagline": "The rarest gems answer its call",
		"cost": 180000000,
		"picks": 5,
		"fragments": 10,
		"accent": Color(1.0, 0.25, 0.82, 1.0),
		"art": "res://assets/generated/chests/void.png",
		"open_art": "res://assets/generated/chests/void_open.png",
		"rarities": [["mythic", 0.45], ["legendary", 0.55]],
	},
	{
		"id": "prismatic",
		"name": "PRISMATIC CRATE",
		"tagline": "Rainbow gems with endgame shine",
		"cost": 25000000000,
		"picks": 6,
		"fragments": 14,
		"accent": Color(0.3, 1.0, 0.78, 1.0),
		"art": "res://assets/generated/chests/prismatic.png",
		"open_art": "res://assets/generated/chests/prismatic_open.png",
		"rarities": [["mythic", 0.24], ["legendary", 0.76]],
	},
	{
		"id": "eternity",
		"name": "ETERNITY CRATE",
		"tagline": "The trillion-kibble treasure",
		"cost": 1000000000000,
		"picks": 8,
		"fragments": 22,
		"accent": Color(1.0, 0.84, 0.26, 1.0),
		"art": "res://assets/generated/chests/eternity.png",
		"open_art": "res://assets/generated/chests/eternity_open.png",
		"rarities": [["legendary", 0.92], ["mega", 0.08]],
	},
	{
		"id": "solar_crown",
		"name": "SOLAR CROWN CRATE",
		"tagline": "Sunlit treasure beyond eternity",
		"cost": 10000000000000,
		"picks": 9,
		"fragments": 28,
		"accent": Color(1.0, 0.68, 0.12, 1.0),
		"art": "res://assets/generated/chests/solar_crown.png",
		"open_art": "res://assets/generated/chests/solar_crown_open.png",
		"rarities": [["legendary", 0.86], ["mega", 0.14]],
	},
	{
		"id": "quantum_yarn",
		"name": "QUANTUM YARN CRATE",
		"tagline": "A tangled vault of impossible gems",
		"cost": 100000000000000,
		"picks": 10,
		"fragments": 36,
		"accent": Color(0.16, 0.92, 1.0, 1.0),
		"art": "res://assets/generated/chests/quantum_yarn.png",
		"open_art": "res://assets/generated/chests/quantum_yarn_open.png",
		"rarities": [["legendary", 0.78], ["mega", 0.22]],
	},
	{
		"id": "aurora_monarch",
		"name": "AURORA MONARCH CRATE",
		"tagline": "Regal gems under northern light",
		"cost": 1000000000000000,
		"picks": 11,
		"fragments": 46,
		"accent": Color(0.5, 1.0, 0.82, 1.0),
		"art": "res://assets/generated/chests/aurora_monarch.png",
		"open_art": "res://assets/generated/chests/aurora_monarch_open.png",
		"rarities": [["legendary", 0.68], ["mega", 0.32]],
	},
	{
		"id": "chrono_paw",
		"name": "CHRONO PAW CRATE",
		"tagline": "Clockwork treasure from every minute",
		"cost": 10000000000000000,
		"picks": 12,
		"fragments": 58,
		"accent": Color(0.34, 0.72, 1.0, 1.0),
		"art": "res://assets/generated/chests/chrono_paw.png",
		"open_art": "res://assets/generated/chests/chrono_paw_open.png",
		"rarities": [["legendary", 0.55], ["mega", 0.45]],
	},
	{
		"id": "infinity_galaxy",
		"name": "INFINITY GALAXY CRATE",
		"tagline": "The far edge of the gem vault",
		"cost": 100000000000000000,
		"picks": 14,
		"fragments": 75,
		"accent": Color(0.88, 0.4, 1.0, 1.0),
		"art": "res://assets/generated/chests/infinity_galaxy.png",
		"open_art": "res://assets/generated/chests/infinity_galaxy_open.png",
		"rarities": [["legendary", 0.35], ["mega", 0.65]],
	},
]

const WORKSHOP_DATA: Array[Dictionary] = [
	{
		"id": "treasure_sense",
		"name": "TREASURE SENSE",
		"badge": "COST",
		"description": "Reduces every crate price by 5% per level.",
		"base_cost": 10000,
		"accent": Color(0.25, 0.86, 0.95, 1.0),
	},
	{
		"id": "gem_polish",
		"name": "GEM POLISH",
		"badge": "POWER",
		"description": "Each gem level adds another 0.05% global gain.",
		"base_cost": 35000,
		"accent": Color(0.72, 0.44, 1.0, 1.0),
	},
	{
		"id": "lucky_latch",
		"name": "LUCKY LATCH",
		"badge": "DROP",
		"description": "Improves rare rolls and adds a bonus pick every 3 levels.",
		"base_cost": 125000,
		"accent": Color(1.0, 0.7, 0.2, 1.0),
	},
]

var game
var gem_fragments: Dictionary = {}
var workshop_levels := {
	"treasure_sense": 0,
	"gem_polish": 0,
	"lucky_latch": 0,
}
var total_crates_opened := 0

var button: Button
var panel: PanelContainer
var scroll: ScrollContainer
var wallet_label: Label
var summary_label: Label
var bonus_label: Label
var collection_grid: GridContainer
var crate_buttons: Dictionary = {}
var workshop_buttons: Dictionary = {}
var workshop_value_labels: Dictionary = {}
var reward_overlay: Control


func _init(game_ref) -> void:
	game = game_ref


func build_ui() -> void:
	_build_main_button()
	_build_panel()
	update_ui(true)


func merge_into_skins_ui(skins_list: VBoxContainer) -> void:
	# Chests, their upgrades, and cat gems belong to the collection screen. Keep
	# the existing controls (and their signal connections) alive by reparenting
	# them instead of building a second copy.
	if not is_instance_valid(scroll) or scroll.get_child_count() == 0:
		return
	var crate_content := scroll.get_child(0) as VBoxContainer
	if crate_content == null:
		return

	var collection_title := Label.new()
	collection_title.text = "CHESTS & CAT GEMS"
	collection_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	collection_title.add_theme_font_size_override("font_size", 22)
	collection_title.add_theme_color_override("font_color", Color(0.3, 0.88, 0.98, 1.0))
	skins_list.add_child(collection_title)
	skins_list.move_child(collection_title, 0)

	var insert_at := 1
	for child in crate_content.get_children():
		child.reparent(skins_list)
		skins_list.move_child(child, insert_at)
		insert_at += 1

	# The skins button is now the single entry point for the whole collection.
	button.hide()
	panel.hide()


func _build_main_button() -> void:
	button = Button.new()
	button.name = "CratesButton"
	button.tooltip_text = "Open crates and collect cat gems"
	button.icon = GEM_FRAME
	button.expand_icon = true
	button.add_theme_font_size_override("font_size", 17)
	button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	game.add_child(button)
	game.move_child(button, game.menu_overlay.get_index())
	game._style_upgrade_button(button, Color(0.18, 0.82, 0.9, 1.0))


func _build_panel() -> void:
	panel = PanelContainer.new()
	panel.name = "CratesPanel"
	panel.custom_minimum_size = Vector2(640.0, 1080.0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	panel.hide()
	game.menu_panel.get_parent().add_child(panel)
	panel.add_theme_stylebox_override(
		"panel",
		game._make_upgrade_style(Color(0.025, 0.055, 0.075, 0.99), Color(0.25, 0.86, 0.95, 1.0), 24, 2, -1, 18)
	)

	var outer_margin := MarginContainer.new()
	outer_margin.add_theme_constant_override("margin_left", 18)
	outer_margin.add_theme_constant_override("margin_top", 18)
	outer_margin.add_theme_constant_override("margin_right", 18)
	outer_margin.add_theme_constant_override("margin_bottom", 18)
	panel.add_child(outer_margin)

	var outer_items := VBoxContainer.new()
	outer_items.add_theme_constant_override("separation", 12)
	outer_margin.add_child(outer_items)

	var header := PanelContainer.new()
	header.add_theme_stylebox_override(
		"panel",
		game._make_upgrade_style(Color(0.04, 0.12, 0.15, 1.0), Color(0.32, 0.9, 1.0, 0.8), 18, 2, 5, 8)
	)
	outer_items.add_child(header)

	var header_margin := MarginContainer.new()
	header_margin.add_theme_constant_override("margin_left", 18)
	header_margin.add_theme_constant_override("margin_top", 12)
	header_margin.add_theme_constant_override("margin_right", 18)
	header_margin.add_theme_constant_override("margin_bottom", 12)
	header.add_child(header_margin)

	var header_items := VBoxContainer.new()
	header_items.add_theme_constant_override("separation", 3)
	header_margin.add_child(header_items)

	var title := Label.new()
	title.text = "CAT GEM VAULT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.78, 0.97, 1.0, 1.0))
	header_items.add_child(title)

	summary_label = Label.new()
	summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary_label.add_theme_font_size_override("font_size", 14)
	summary_label.add_theme_color_override("font_color", Color(0.58, 0.8, 0.86, 1.0))
	header_items.add_child(summary_label)

	bonus_label = Label.new()
	bonus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bonus_label.add_theme_font_size_override("font_size", 17)
	bonus_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.34, 1.0))
	header_items.add_child(bonus_label)

	var wallet := PanelContainer.new()
	wallet.add_theme_stylebox_override(
		"panel",
		game._make_upgrade_style(Color(0.14, 0.105, 0.035, 0.94), Color(1.0, 0.72, 0.16, 0.78), 14, 1, -1, 5)
	)
	outer_items.add_child(wallet)

	var wallet_margin := MarginContainer.new()
	wallet_margin.add_theme_constant_override("margin_left", 16)
	wallet_margin.add_theme_constant_override("margin_top", 8)
	wallet_margin.add_theme_constant_override("margin_right", 16)
	wallet_margin.add_theme_constant_override("margin_bottom", 8)
	wallet.add_child(wallet_margin)

	var wallet_row := HBoxContainer.new()
	wallet_row.alignment = BoxContainer.ALIGNMENT_CENTER
	wallet_row.add_theme_constant_override("separation", 10)
	wallet_margin.add_child(wallet_row)

	var coin_icon := TextureRect.new()
	coin_icon.texture = game.menu_coin_icon.texture
	coin_icon.custom_minimum_size = Vector2(38.0, 38.0)
	coin_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	wallet_row.add_child(coin_icon)

	wallet_label = Label.new()
	wallet_label.add_theme_font_size_override("font_size", 22)
	wallet_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46, 1.0))
	wallet_row.add_child(wallet_label)

	scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0.0, 760.0)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	game._configure_touch_scroll(scroll)
	outer_items.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 14)
	scroll.add_child(content)

	_add_section_title(content, "OPEN A CRATE", "Every crate drops permanent cat-gem fragments.", Color(0.3, 0.88, 0.98, 1.0))
	for crate_data in CRATE_DATA:
		_add_crate_card(content, crate_data)

	_add_section_title(content, "GEM WORKSHOP", "More upgrades for better drops and stronger collections.", Color(0.78, 0.55, 1.0, 1.0))
	for upgrade_data in WORKSHOP_DATA:
		_add_workshop_card(content, upgrade_data)

	_add_section_title(content, "YOUR CAT GEMS", "Find gems for every skin—even cats you do not own yet.", Color(1.0, 0.74, 0.24, 1.0))
	collection_grid = GridContainer.new()
	collection_grid.columns = 2
	collection_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	collection_grid.add_theme_constant_override("h_separation", 10)
	collection_grid.add_theme_constant_override("v_separation", 10)
	content.add_child(collection_grid)


func _add_section_title(parent: VBoxContainer, title_text: String, body_text: String, accent: Color) -> void:
	var block := VBoxContainer.new()
	block.add_theme_constant_override("separation", 2)
	parent.add_child(block)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 21)
	title.add_theme_color_override("font_color", accent)
	block.add_child(title)
	var body := Label.new()
	body.text = body_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 13)
	body.add_theme_color_override("font_color", Color(0.62, 0.69, 0.78, 1.0))
	block.add_child(body)


func _add_crate_card(parent: VBoxContainer, crate_data: Dictionary) -> void:
	var accent: Color = crate_data["accent"]
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0.0, 176.0)
	card.add_theme_stylebox_override("panel", game._make_upgrade_card_style(accent, false))
	parent.add_child(card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	margin.add_child(row)

	var art := TextureRect.new()
	art.texture = _get_crate_texture(crate_data)
	art.custom_minimum_size = Vector2(132.0, 132.0)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(art)

	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 4)
	row.add_child(details)

	var name_label := Label.new()
	name_label.text = String(crate_data["name"])
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.add_theme_color_override("font_color", accent.lightened(0.18))
	details.add_child(name_label)

	var tagline := Label.new()
	tagline.text = String(crate_data["tagline"])
	tagline.add_theme_font_size_override("font_size", 14)
	tagline.add_theme_color_override("font_color", Color(0.72, 0.76, 0.83, 1.0))
	details.add_child(tagline)

	var drop_label := Label.new()
	drop_label.text = "%d pick%s • %d fragment%s each" % [
		int(crate_data["picks"]),
		"s" if int(crate_data["picks"]) != 1 else "",
		int(crate_data["fragments"]),
		"s" if int(crate_data["fragments"]) != 1 else "",
	]
	drop_label.add_theme_font_size_override("font_size", 13)
	drop_label.add_theme_color_override("font_color", accent)
	details.add_child(drop_label)

	var open_button := Button.new()
	open_button.custom_minimum_size = Vector2(0.0, 50.0)
	open_button.add_theme_font_size_override("font_size", 16)
	game._style_upgrade_button(open_button, accent)
	open_button.pressed.connect(open_crate.bind(String(crate_data["id"])))
	details.add_child(open_button)
	crate_buttons[String(crate_data["id"])] = open_button


func _add_workshop_card(parent: VBoxContainer, upgrade_data: Dictionary) -> void:
	var accent: Color = upgrade_data["accent"]
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", game._make_upgrade_card_style(accent, false))
	parent.add_child(card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 13)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 13)
	margin.add_theme_constant_override("margin_bottom", 10)
	card.add_child(margin)

	var items := VBoxContainer.new()
	items.add_theme_constant_override("separation", 5)
	margin.add_child(items)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	items.add_child(header)
	var badge := Label.new()
	badge.text = String(upgrade_data["badge"])
	badge.add_theme_font_size_override("font_size", 12)
	badge.add_theme_color_override("font_color", accent.lightened(0.2))
	badge.add_theme_stylebox_override("normal", game._make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.14), Color(accent.r, accent.g, accent.b, 0.55), 8, 1))
	header.add_child(badge)
	var name_label := Label.new()
	name_label.text = String(upgrade_data["name"])
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.add_theme_color_override("font_color", Color(0.9, 0.93, 0.98, 1.0))
	header.add_child(name_label)
	var value_label := Label.new()
	value_label.add_theme_font_size_override("font_size", 18)
	value_label.add_theme_color_override("font_color", accent.lightened(0.15))
	header.add_child(value_label)
	workshop_value_labels[String(upgrade_data["id"])] = value_label

	var description := Label.new()
	description.text = String(upgrade_data["description"])
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_font_size_override("font_size", 13)
	description.add_theme_color_override("font_color", Color(0.66, 0.71, 0.79, 1.0))
	items.add_child(description)

	var upgrade_button := Button.new()
	upgrade_button.custom_minimum_size = Vector2(0.0, 48.0)
	upgrade_button.add_theme_font_size_override("font_size", 15)
	game._style_upgrade_button(upgrade_button, accent)
	upgrade_button.pressed.connect(upgrade_workshop.bind(String(upgrade_data["id"])))
	items.add_child(upgrade_button)
	workshop_buttons[String(upgrade_data["id"])] = upgrade_button


func update_ui(rebuild_collection: bool = false) -> void:
	if not is_instance_valid(button):
		return
	var discovered := get_discovered_count()
	button.text = "CRATES  %d/%d" % [discovered, game.SKIN_DATA.size()]
	button.tooltip_text = "Gem vault: %d/%d discovered • +%.1f%% all gain" % [discovered, game.SKIN_DATA.size(), (get_global_multiplier() - 1.0) * 100.0]
	if is_instance_valid(summary_label):
		summary_label.text = "%d / %d GEMS FOUND  •  %d CRATES OPENED" % [discovered, game.SKIN_DATA.size(), total_crates_opened]
		bonus_label.text = "COLLECTION POWER  +%.1f%% ALL KIBBLE" % ((get_global_multiplier() - 1.0) * 100.0)
	update_wallet()
	if rebuild_collection:
		rebuild_collection_grid()


func update_wallet() -> void:
	if not is_instance_valid(wallet_label):
		return
	var bowl_keys: int = game.bottomless_bowl_logic.crate_keys if game.bottomless_bowl_logic != null else 0
	var cozy_crates: int = game.bottomless_bowl_logic.cozy_crates if game.bottomless_bowl_logic != null else 0
	wallet_label.text = "%s KIBBLES  |  KEYS: %d  |  COZY CRATES: %d" % [game._format_number(game.coins), bowl_keys, cozy_crates]
	for crate_data in CRATE_DATA:
		var crate_id := String(crate_data["id"])
		var open_button := crate_buttons.get(crate_id) as Button
		if open_button == null:
			continue
		var cost := get_crate_cost(crate_data)
		var has_free_crate := bowl_keys > 0 or (crate_id == "cozy" and cozy_crates > 0)
		open_button.disabled = game.coins < cost and not has_free_crate
		open_button.text = "FREE • USE KEY" if bowl_keys > 0 else ("FREE • USE CRATE" if crate_id == "cozy" and cozy_crates > 0 else game._format_number(cost))

	for upgrade_data in WORKSHOP_DATA:
		var upgrade_id := String(upgrade_data["id"])
		var level := get_workshop_level(upgrade_id)
		var upgrade_button := workshop_buttons.get(upgrade_id) as Button
		var value_label := workshop_value_labels.get(upgrade_id) as Label
		if value_label != null:
			value_label.text = "Lv %d/%d" % [level, MAX_WORKSHOP_LEVEL]
		if upgrade_button == null:
			continue
		if level >= MAX_WORKSHOP_LEVEL:
			upgrade_button.disabled = true
			upgrade_button.text = "MAX LEVEL"
			continue
		var cost := get_workshop_cost(upgrade_data, level)
		upgrade_button.disabled = game.coins < cost
		upgrade_button.text = "UPGRADE TO LV %d  •  %s" % [level + 1, game._format_number(cost)] if game.coins >= cost else "NEED %s MORE" % game._format_number(cost - game.coins)


func rebuild_collection_grid() -> void:
	if not is_instance_valid(collection_grid):
		return
	for child in collection_grid.get_children():
		collection_grid.remove_child(child)
		child.queue_free()
	for raw_skin_data in game.SKIN_DATA:
		var skin_data: Dictionary = raw_skin_data
		collection_grid.add_child(_create_gem_card(skin_data))


func _create_gem_card(skin_data: Dictionary) -> PanelContainer:
	var skin_id := String(skin_data["id"])
	var fragments := get_fragments(skin_id)
	var discovered := fragments > 0
	var rarity := get_skin_rarity(skin_data)
	var accent := get_rarity_color(rarity)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0.0, 162.0)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", game._make_upgrade_card_style(accent, false))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	margin.add_child(row)
	row.add_child(create_gem_visual(skin_data, 112.0, discovered))

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 2)
	row.add_child(info)

	var name_label := Label.new()
	name_label.text = String(skin_data["name"]) if discovered else "MYSTERY GEM"
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 14)
	name_label.add_theme_color_override("font_color", accent.lightened(0.22) if discovered else Color(0.5, 0.55, 0.62, 1.0))
	info.add_child(name_label)

	var rarity_label := Label.new()
	rarity_label.text = rarity.to_upper()
	rarity_label.add_theme_font_size_override("font_size", 11)
	rarity_label.add_theme_color_override("font_color", accent)
	info.add_child(rarity_label)

	var level := get_gem_level(skin_id)
	var progress_label := Label.new()
	progress_label.text = "Lv %d  •  %d/%d" % [level, fragments % FRAGMENTS_PER_LEVEL, FRAGMENTS_PER_LEVEL] if discovered else "NOT FOUND"
	progress_label.add_theme_font_size_override("font_size", 12)
	progress_label.add_theme_color_override("font_color", Color(0.7, 0.74, 0.8, 1.0))
	info.add_child(progress_label)

	return card


func create_gem_visual(skin_data: Dictionary, visual_size: float, revealed: bool = true) -> Control:
	var root := Control.new()
	root.custom_minimum_size = Vector2(visual_size, visual_size)
	root.size = Vector2(visual_size, visual_size)
	root.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	root.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	root.clip_contents = true
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var frame := Sprite2D.new()
	frame.texture = GEM_FRAME
	frame.position = Vector2(visual_size * 0.5, visual_size * 0.5)
	var frame_texture_size := GEM_FRAME.get_size()
	frame.scale = Vector2(visual_size / frame_texture_size.x, visual_size / frame_texture_size.y)
	frame.modulate = Color.WHITE if revealed else Color(0.18, 0.24, 0.3, 0.9)
	root.add_child(frame)

	if revealed:
		var source_texture := load(String(skin_data["texture"])) as Texture2D
		if source_texture != null:
			var source_size := source_texture.get_size()
			var portrait := Polygon2D.new()
			portrait.texture = source_texture
			portrait.z_index = 2
			var points := PackedVector2Array()
			var uvs := PackedVector2Array()
			var circle_center := Vector2(visual_size * 0.5, visual_size * 0.60)
			var circle_radius := visual_size * 0.270
			var face_center_y := _get_skin_face_center_y(String(skin_data["id"]))
			var source_center := Vector2(source_size.x * 0.5, source_size.y * face_center_y)
			var source_radius := Vector2(source_size.x * 0.27, source_size.y * 0.23)
			for point_index in range(48):
				var angle := TAU * float(point_index) / 48.0
				var direction := Vector2(cos(angle), sin(angle))
				points.append(circle_center + direction * circle_radius)
				uvs.append(source_center + direction * source_radius)
			portrait.polygon = points
			portrait.uv = uvs
			root.add_child(portrait)

	if not revealed:
		var mystery := Label.new()
		mystery.text = "?"
		mystery.position = Vector2.ZERO
		mystery.size = Vector2(visual_size, visual_size)
		mystery.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mystery.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		mystery.add_theme_font_size_override("font_size", int(visual_size * 0.34))
		mystery.add_theme_color_override("font_color", Color(0.7, 0.78, 0.86, 0.9))
		mystery.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mystery.z_index = 3
		root.add_child(mystery)

	return root


func _get_skin_face_center_y(skin_id: String) -> float:
	if skin_id in ["banana", "burger", "cheese", "coffee", "cookie", "donut", "ice_cream", "kebab", "pizza", "popcorn", "sushi", "taco", "watermelon"]:
		return 0.48
	return 0.34


func open_crate(crate_id: String) -> void:
	if is_instance_valid(reward_overlay):
		return
	var crate_data := get_crate_data(crate_id)
	if crate_data.is_empty():
		return
	var cost := get_crate_cost(crate_data)
	if game.bottomless_bowl_logic != null and crate_id == "cozy" and game.bottomless_bowl_logic.cozy_crates > 0:
		game.bottomless_bowl_logic.cozy_crates -= 1
	elif game.bottomless_bowl_logic != null and game.bottomless_bowl_logic.crate_keys > 0:
		game.bottomless_bowl_logic.crate_keys -= 1
	else:
		if game.coins < cost or not game._spend_coins(cost):
			return

	var picks: int = int(crate_data["picks"]) + int(get_workshop_level("lucky_latch") / 3) + int(game.boost_logic.get_extra_crate_picks())
	var fragment_multiplier: int = int(game.boost_logic.get_crate_fragment_multiplier())
	var fragments_per_pick: int = int(crate_data["fragments"]) * fragment_multiplier
	var rewards: Array[Dictionary] = []
	for _index in range(picks):
		var skin_data := roll_skin(crate_data)
		var skin_id := String(skin_data["id"])
		var old_fragments := get_fragments(skin_id)
		var old_level := get_gem_level(skin_id)
		var accepted_fragments := mini(fragments_per_pick, maxi(0, MAX_GEM_FRAGMENTS - old_fragments))
		var overflow_fragments := fragments_per_pick - accepted_fragments
		var converted_kibbles := 0
		gem_fragments[skin_id] = old_fragments + accepted_fragments
		if overflow_fragments > 0:
			converted_kibbles = _get_duplicate_kibble_value(skin_data) * overflow_fragments
			game._add_score(converted_kibbles)
			game._add_coins(converted_kibbles)
		if get_fragments(skin_id) >= get_skin_unlock_cost(skin_data) and skin_id != game.DEFAULT_SKIN_ID and skin_id not in game.owned_skin_ids:
			game.owned_skin_ids.append(skin_id)
		rewards.append({
			"skin_data": skin_data,
			"fragments": accepted_fragments,
			"converted_kibbles": converted_kibbles,
			"new_discovery": old_fragments == 0,
			"level_up": get_gem_level(skin_id) > old_level,
		})

	total_crates_opened += 1
	game._update_coins(false)
	game._update_upgrade_ui()
	game._update_stats_ui()
	game._update_skins_ui()
	update_ui(true)
	game._play_ui_sound()
	game._save_game()
	game._tutorial_notify("crate_opened")
	show_reward_overlay(crate_data, rewards)


func upgrade_workshop(upgrade_id: String) -> void:
	var upgrade_data := get_workshop_data(upgrade_id)
	if upgrade_data.is_empty():
		return
	var level := get_workshop_level(upgrade_id)
	if level >= MAX_WORKSHOP_LEVEL:
		return
	var cost := get_workshop_cost(upgrade_data, level)
	if game.coins < cost or not game._spend_coins(cost):
		return
	workshop_levels[upgrade_id] = level + 1
	game._update_coins(false)
	game._update_upgrade_ui()
	game._update_stats_ui()
	update_ui(true)
	var upgrade_button := workshop_buttons.get(upgrade_id) as Control
	if upgrade_button != null:
		game._celebrate_upgrade(upgrade_button, upgrade_data["accent"] as Color)
	game._play_purchase_sound()
	game._save_game()


func show_reward_overlay(crate_data: Dictionary, rewards: Array[Dictionary]) -> void:
	if is_instance_valid(reward_overlay):
		reward_overlay.queue_free()
	reward_overlay = Control.new()
	reward_overlay.name = "CrateRewardOverlay"
	reward_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	reward_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	reward_overlay.z_index = 100
	game.menu_overlay.add_child(reward_overlay)

	var dim := ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.005, 0.012, 0.025, 0.88)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	reward_overlay.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reward_overlay.add_child(center)

	var reward_panel := PanelContainer.new()
	var viewport_size: Vector2 = game.get_viewport_rect().size
	reward_panel.custom_minimum_size = Vector2(minf(540.0, viewport_size.x - 34.0), minf(790.0, viewport_size.y - 50.0))
	var accent: Color = crate_data["accent"]
	reward_panel.add_theme_stylebox_override("panel", game._make_upgrade_style(Color(0.025, 0.045, 0.075, 0.995), accent, 26, 3, -1, 22))
	center.add_child(reward_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	reward_panel.add_child(margin)

	var items := VBoxContainer.new()
	items.alignment = BoxContainer.ALIGNMENT_CENTER
	items.add_theme_constant_override("separation", 8)
	margin.add_child(items)

	var title := Label.new()
	title.text = "CRATE OPENED!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", accent.lightened(0.22))
	items.add_child(title)

	var crate_art := TextureRect.new()
	crate_art.texture = _get_crate_texture(crate_data)
	crate_art.custom_minimum_size = Vector2(250.0, 250.0)
	crate_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	crate_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	crate_art.pivot_offset = Vector2(125.0, 125.0)
	items.add_child(crate_art)

	# Tier-colored sparks live inside the art control so the opening reads as an
	# actual burst instead of only a texture swap.
	var burst_sparks: Array[Label] = []
	for spark_index in range(12):
		var spark := Label.new()
		spark.text = "◆" if spark_index % 2 == 0 else "✦"
		spark.position = Vector2(112.0, 105.0)
		spark.size = Vector2(28.0, 28.0)
		spark.pivot_offset = Vector2(14.0, 14.0)
		spark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		spark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		spark.add_theme_font_size_override("font_size", 18 if spark_index % 2 == 0 else 24)
		spark.add_theme_color_override("font_color", accent.lightened(0.28))
		spark.modulate.a = 0.0
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		crate_art.add_child(spark)
		burst_sparks.append(spark)

	var lock_flash := Label.new()
	lock_flash.text = "✦"
	lock_flash.position = Vector2(89.0, 76.0)
	lock_flash.size = Vector2(72.0, 72.0)
	lock_flash.pivot_offset = Vector2(36.0, 36.0)
	lock_flash.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lock_flash.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lock_flash.add_theme_font_size_override("font_size", 58)
	lock_flash.add_theme_color_override("font_color", Color.WHITE)
	lock_flash.modulate.a = 0.0
	lock_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crate_art.add_child(lock_flash)

	var remaining_label := Label.new()
	remaining_label.text = "%d ITEMS REMAINING" % rewards.size()
	remaining_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	remaining_label.add_theme_font_size_override("font_size", 15)
	remaining_label.add_theme_color_override("font_color", Color(0.72, 0.82, 0.92, 1.0))
	items.add_child(remaining_label)

	var reward_stage := CenterContainer.new()
	reward_stage.custom_minimum_size = Vector2(260.0, 220.0)
	reward_stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	items.add_child(reward_stage)

	var reward_cards: Array[Control] = []
	for reward in rewards:
		var skin_data: Dictionary = reward["skin_data"]
		var rarity := get_skin_rarity(skin_data)
		var reward_accent := get_rarity_color(rarity)
		var reward_card := PanelContainer.new()
		reward_card.custom_minimum_size = Vector2(238.0, 210.0)
		reward_card.add_theme_stylebox_override("panel", game._make_upgrade_card_style(reward_accent, false))
		reward_card.visible = false
		reward_card.modulate.a = 0.0
		reward_card.scale = Vector2(0.55, 0.55)
		reward_card.pivot_offset = Vector2(119.0, 105.0)
		reward_stage.add_child(reward_card)
		reward_cards.append(reward_card)

		var reward_items := VBoxContainer.new()
		reward_items.alignment = BoxContainer.ALIGNMENT_CENTER
		reward_card.add_child(reward_items)
		reward_items.add_child(create_gem_visual(skin_data, 116.0, true))

		var reward_name := Label.new()
		reward_name.text = String(skin_data["name"])
		reward_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		reward_name.clip_text = true
		reward_name.add_theme_font_size_override("font_size", 17)
		reward_name.add_theme_color_override("font_color", reward_accent.lightened(0.22))
		reward_items.add_child(reward_name)

		var fragment_label := Label.new()
		var gained_fragments := int(reward["fragments"])
		var converted_kibbles := int(reward.get("converted_kibbles", 0))
		if gained_fragments > 0:
			fragment_label.text = "+%d FRAGMENT%s" % [gained_fragments, "S" if gained_fragments != 1 else ""]
		else:
			fragment_label.text = "MAX GEM"
		fragment_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		fragment_label.add_theme_font_size_override("font_size", 14)
		fragment_label.add_theme_color_override("font_color", Color(0.9, 0.93, 1.0, 1.0))
		reward_items.add_child(fragment_label)
		if converted_kibbles > 0:
			var conversion_label := Label.new()
			conversion_label.text = "+%s KIBBLES" % game._format_number(converted_kibbles)
			conversion_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			conversion_label.add_theme_font_size_override("font_size", 13)
			conversion_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.28, 1.0))
			reward_items.add_child(conversion_label)

		if bool(reward["new_discovery"]) or bool(reward["level_up"]):
			var status := Label.new()
			status.text = "NEW GEM!" if bool(reward["new_discovery"]) else "LEVEL UP!"
			status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			status.add_theme_font_size_override("font_size", 13)
			status.add_theme_color_override("font_color", Color(1.0, 0.82, 0.28, 1.0))
			reward_items.add_child(status)

	var bonus_text := Label.new()
	bonus_text.text = "Collection power is now +%.1f%%" % ((get_global_multiplier() - 1.0) * 100.0)
	bonus_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bonus_text.add_theme_font_size_override("font_size", 17)
	bonus_text.add_theme_color_override("font_color", Color(1.0, 0.83, 0.36, 1.0))
	items.add_child(bonus_text)

	var recap := Label.new()
	var recap_lines: PackedStringArray = []
	var total_fragments := 0
	var total_kibbles := 0
	for reward in rewards:
		var fragment_count := int(reward["fragments"])
		var converted_count := int(reward.get("converted_kibbles", 0))
		total_fragments += fragment_count
		total_kibbles += converted_count
		recap_lines.append("%s  +%d gem%s%s" % [String(reward["skin_data"]["name"]), fragment_count, "s" if fragment_count != 1 else "", "  +%s kibble" % game._format_number(converted_count) if converted_count > 0 else ""])
	recap.text = "FULL REWARD RECAP\n%s\nTOTAL: %d GEMS%s" % ["\n".join(recap_lines), total_fragments, "  +%s KIBBLES" % game._format_number(total_kibbles) if total_kibbles > 0 else ""]
	recap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	recap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	recap.add_theme_font_size_override("font_size", 13)
	recap.add_theme_color_override("font_color", Color(0.88, 0.92, 1.0, 1.0))
	recap.visible = false
	items.add_child(recap)

	var continue_button := Button.new()
	continue_button.text = "REVEALING GEMS..."
	continue_button.disabled = true
	continue_button.custom_minimum_size = Vector2(0.0, 54.0)
	continue_button.add_theme_font_size_override("font_size", 18)
	game._style_upgrade_button(continue_button, accent)
	continue_button.pressed.connect(_close_reward_overlay)
	items.add_child(continue_button)

	reward_overlay.modulate.a = 0.0
	var open_tween: Tween = game.create_tween()
	open_tween.tween_property(reward_overlay, "modulate:a", 1.0, 0.16)
	# Anticipation: squash and rattle before the lock flashes.
	open_tween.tween_property(crate_art, "scale", Vector2(1.06, 0.94), 0.13).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for shake_rotation in [-0.055, 0.055, -0.04, 0.04, 0.0]:
		open_tween.tween_property(crate_art, "rotation", shake_rotation, 0.055)
	open_tween.tween_property(crate_art, "scale", Vector2(0.86, 1.12), 0.13).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	open_tween.tween_property(lock_flash, "modulate:a", 1.0, 0.07)
	open_tween.parallel().tween_property(lock_flash, "scale", Vector2(1.8, 1.8), 0.18).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	open_tween.tween_callback(func() -> void:
		crate_art.texture = _get_crate_open_texture(crate_data)
		game._play_crate_open_sound()
	)
	open_tween.tween_property(lock_flash, "modulate:a", 0.0, 0.12)
	open_tween.tween_property(crate_art, "scale", Vector2(1.1, 1.1), 0.22).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	for spark_index in range(burst_sparks.size()):
		var spark := burst_sparks[spark_index]
		var angle := TAU * float(spark_index) / float(burst_sparks.size())
		var distance := 82.0 + float(spark_index % 3) * 18.0
		open_tween.parallel().tween_property(spark, "modulate:a", 1.0, 0.08)
		open_tween.parallel().tween_property(spark, "position", Vector2(112.0, 105.0) + Vector2(cos(angle), sin(angle)) * distance, 0.38).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		open_tween.parallel().tween_property(spark, "rotation", angle + PI, 0.38)
	open_tween.tween_interval(0.12)
	for spark in burst_sparks:
		open_tween.parallel().tween_property(spark, "modulate:a", 0.0, 0.24)
	open_tween.tween_property(crate_art, "scale", Vector2.ONE, 0.14)
	for card_index in range(reward_cards.size()):
		var reward_card := reward_cards[card_index]
		open_tween.tween_callback(func() -> void:
			remaining_label.text = "%d ITEM%s REMAINING" % [rewards.size() - card_index - 1, "" if rewards.size() - card_index - 1 == 1 else "S"]
			reward_card.visible = true
			reward_card.modulate.a = 0.0
			reward_card.scale = Vector2(0.55, 0.55)
			game._play_gem_reveal_sound(bool(rewards[card_index]["new_discovery"]))
		)
		open_tween.tween_property(reward_card, "modulate:a", 1.0, 0.18)
		open_tween.parallel().tween_property(reward_card, "scale", Vector2.ONE, 0.48).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		open_tween.tween_interval(0.72)
		if card_index < reward_cards.size() - 1:
			open_tween.tween_property(reward_card, "modulate:a", 0.0, 0.16)
			open_tween.parallel().tween_property(reward_card, "scale", Vector2(1.12, 1.12), 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
			open_tween.tween_callback(func() -> void: reward_card.visible = false)
	open_tween.tween_callback(func() -> void:
		remaining_label.text = "ALL ITEMS REVEALED"
		recap.visible = true
		continue_button.disabled = false
		continue_button.text = "KEEP COLLECTING"
	)


func _close_reward_overlay() -> void:
	if not is_instance_valid(reward_overlay):
		return
	game._play_ui_sound()
	var closing := reward_overlay
	reward_overlay = null
	var tween: Tween = game.create_tween()
	tween.tween_property(closing, "modulate:a", 0.0, 0.18)
	tween.tween_callback(Callable(closing, "queue_free"))


func roll_skin(crate_data: Dictionary) -> Dictionary:
	var rarity_roll := maxf(0.0, randf() - (0.0225 * float(get_workshop_level("lucky_latch"))))
	var chosen_rarity := "common"
	var cumulative := 0.0
	for rarity_entry in crate_data["rarities"]:
		cumulative += float(rarity_entry[1])
		if rarity_roll <= cumulative:
			chosen_rarity = String(rarity_entry[0])
			break

	var candidates: Array[Dictionary] = []
	for raw_skin_data in game.SKIN_DATA:
		var skin_data: Dictionary = raw_skin_data
		if get_skin_rarity(skin_data) == chosen_rarity:
			candidates.append(skin_data)
	if candidates.is_empty():
		return game.SKIN_DATA.pick_random()
	return candidates.pick_random()


func get_skin_rarity(skin_data: Dictionary) -> String:
	if skin_data.has("rarity"):
		return String(skin_data["rarity"])
	var cost := int(skin_data.get("cost", 0))
	if cost <= 10000:
		return "common"
	if cost <= 100000:
		return "rare"
	if cost <= 1000000:
		return "epic"
	if cost <= 25000000:
		return "mythic"
	return "legendary"


func get_skin_unlock_cost(skin_data: Dictionary) -> int:
	if skin_data.has("gem_cost"):
		return maxi(1, int(skin_data["gem_cost"]))
	var spread: int = absi(hash(String(skin_data.get("id", ""))))
	match get_skin_rarity(skin_data):
		"rare": return 1 + (spread % 3)
		"epic": return 3 + (spread % 3)
		"mythic": return 5 + (spread % 3)
		"legendary": return 7 + (spread % 4)
		"mega": return 20
	return 1


func get_rarity_color(rarity: String) -> Color:
	match rarity:
		"rare":
			return Color(0.36, 0.66, 1.0, 1.0)
		"epic":
			return Color(0.72, 0.4, 1.0, 1.0)
		"mythic":
			return Color(1.0, 0.68, 0.18, 1.0)
		"legendary":
			return Color(1.0, 0.3, 0.16, 1.0)
		"mega":
			return Color(0.95, 0.42, 1.0, 1.0)
	return Color(0.28, 0.9, 0.86, 1.0)


func get_crate_data(crate_id: String) -> Dictionary:
	for data in CRATE_DATA:
		if String(data["id"]) == crate_id:
			return data
	return {}


func _get_crate_texture(crate_data: Dictionary) -> Texture2D:
	var texture := load(String(crate_data.get("art", ""))) as Texture2D
	return texture if texture != null else CRATE_CLOSED


func _get_crate_open_texture(crate_data: Dictionary) -> Texture2D:
	var texture := load(String(crate_data.get("open_art", ""))) as Texture2D
	return texture if texture != null else CRATE_OPEN


func get_workshop_data(upgrade_id: String) -> Dictionary:
	for data in WORKSHOP_DATA:
		if String(data["id"]) == upgrade_id:
			return data
	return {}


func get_crate_cost(crate_data: Dictionary) -> int:
	var discount := 1.0 - (0.05 * float(get_workshop_level("treasure_sense")))
	var repeat_scale := minf(4.0, 1.0 + 0.12 * sqrt(float(total_crates_opened)))
	return maxi(1, roundi(float(crate_data["cost"]) * maxf(0.6, discount) * repeat_scale))


func get_workshop_cost(upgrade_data: Dictionary, current_level: int) -> int:
	return int(round(float(upgrade_data["base_cost"]) * pow(2.35, current_level)))


func get_workshop_level(upgrade_id: String) -> int:
	return int(workshop_levels.get(upgrade_id, 0))


func get_fragments(skin_id: String) -> int:
	return maxi(0, int(gem_fragments.get(skin_id, 0)))


func _get_duplicate_kibble_value(skin_data: Dictionary) -> int:
	return maxi(100, int(skin_data.get("cost", 0)) / 20)


func get_gem_level(skin_id: String) -> int:
	return mini(MAX_GEM_LEVEL, int(get_fragments(skin_id) / FRAGMENTS_PER_LEVEL))


func get_total_gem_levels() -> int:
	var total := 0
	for raw_skin_data in game.SKIN_DATA:
		total += get_gem_level(String(raw_skin_data["id"]))
	return total


func get_discovered_count() -> int:
	var total := 0
	for raw_skin_data in game.SKIN_DATA:
		if get_fragments(String(raw_skin_data["id"])) > 0:
			total += 1
	return total


func get_global_multiplier() -> float:
	var bonus_per_level := 0.005 + (0.0005 * float(get_workshop_level("gem_polish")))
	return 1.0 + (float(get_total_gem_levels()) * bonus_per_level)


func get_save_data() -> Dictionary:
	return {
		"gem_fragments": gem_fragments.duplicate(true),
		"workshop_levels": workshop_levels.duplicate(true),
		"total_crates_opened": total_crates_opened,
	}


func load_save_data(save_data: Dictionary) -> void:
	gem_fragments.clear()
	var saved_fragments: Dictionary = save_data.get("gem_fragments", {})
	for raw_skin_data in game.SKIN_DATA:
		var skin_id := String(raw_skin_data["id"])
		var amount := clampi(int(saved_fragments.get(skin_id, 0)), 0, MAX_GEM_FRAGMENTS)
		# Legacy saves bought skins with kibbles. Preserve that ownership by
		# discovering the matching gem the first time the new crate data loads.
		if amount == 0 and skin_id in game.owned_skin_ids:
			amount = 1
		if amount > 0:
			gem_fragments[skin_id] = amount
			if skin_id != game.DEFAULT_SKIN_ID and skin_id not in game.owned_skin_ids:
				game.owned_skin_ids.append(skin_id)
	var saved_levels: Dictionary = save_data.get("workshop_levels", {})
	for upgrade_data in WORKSHOP_DATA:
		var upgrade_id := String(upgrade_data["id"])
		workshop_levels[upgrade_id] = clampi(int(saved_levels.get(upgrade_id, 0)), 0, MAX_WORKSHOP_LEVEL)
	total_crates_opened = maxi(0, int(save_data.get("total_crates_opened", 0)))
