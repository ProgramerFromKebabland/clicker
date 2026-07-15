extends RefCounted
class_name BottomlessBowlLogic

const BOWL_TEXTURE := preload("res://assets/generated/bottomless_cat_bowl.png")
const BASE_COST := 1000
const WEEK_SECONDS := 604800

var game
var level := 0
var progress := 0
var rewards_earned := 0
var crate_keys := 0
var cozy_crates := 0
var week_id := 0
var boost_end_time := 0

var panel: PanelContainer
var scroll: ScrollContainer
var level_label: Label
var progress_bar: ProgressBar
var progress_label: Label
var wallet_label: Label
var reward_label: Label
var milestone_label: Label
var donate_edit: LineEdit
var donate_button: Button

func _init(game_ref) -> void:
	game = game_ref

func build_ui() -> void:
	_check_week()
	panel = PanelContainer.new()
	panel.name = "BottomlessBowlPanel"
	panel.custom_minimum_size = Vector2(640, 1080)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	panel.hide()
	game.menu_panel.get_parent().add_child(panel)
	panel.add_theme_stylebox_override("panel", game._make_upgrade_style(Color(0.055, 0.035, 0.075, 0.99), Color(1.0, 0.66, 0.2), 24, 2, -1, 18))
	var margin := MarginContainer.new()
	margin.name = "BowlRootMargin"
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]: margin.add_theme_constant_override(side, 18)
	panel.add_child(margin)
	var root := VBoxContainer.new()
	root.name = "BowlRoot"
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)
	var title := Label.new()
	title.name = "BowlTitle"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.text = "THE BOTTOMLESS CAT BOWL"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 29)
	title.add_theme_color_override("font_color", Color(1.0, 0.84, 0.46))
	root.add_child(title)
	var subtitle := Label.new()
	subtitle.name = "BowlSubtitle"
	subtitle.text = "Donate any amount. Fill forever. Weekly progress resets; permanent milestones remain."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 14)
	root.add_child(subtitle)
	scroll = ScrollContainer.new()
	scroll.name = "BowlScroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	game._configure_touch_scroll(scroll)
	root.add_child(scroll)
	var content := VBoxContainer.new()
	content.name = "BowlContent"
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	scroll.add_child(content)
	var bowl := TextureRect.new()
	bowl.name = "BowlArt"
	bowl.texture = BOWL_TEXTURE
	bowl.custom_minimum_size = Vector2(0, 310)
	bowl.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bowl.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	content.add_child(bowl)
	level_label = Label.new(); level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; level_label.add_theme_font_size_override("font_size", 24); content.add_child(level_label)
	progress_bar = ProgressBar.new(); progress_bar.custom_minimum_size = Vector2(0, 38); progress_bar.show_percentage = false; content.add_child(progress_bar)
	progress_label = Label.new(); progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; content.add_child(progress_label)
	wallet_label = Label.new(); wallet_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; wallet_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46)); content.add_child(wallet_label)
	var row := HBoxContainer.new(); row.name = "DonateRow"; row.add_theme_constant_override("separation", 10); content.add_child(row)
	donate_edit = LineEdit.new(); donate_edit.placeholder_text = "Amount of kibble"; donate_edit.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER; donate_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(donate_edit)
	donate_button = Button.new(); donate_button.text = "DONATE"; donate_button.custom_minimum_size = Vector2(170, 54); game._style_upgrade_button(donate_button, Color(0.94, 0.55, 0.16)); row.add_child(donate_button)
	donate_button.pressed.connect(_donate)
	var all_button := Button.new(); all_button.text = "DONATE ALL KIBBLE"; all_button.custom_minimum_size = Vector2(0, 50); game._style_upgrade_button(all_button, Color(0.65, 0.35, 0.75)); content.add_child(all_button); all_button.pressed.connect(func(): donate_edit.text = str(game.coins); _donate())
	reward_label = Label.new(); reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; reward_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; reward_label.add_theme_font_size_override("font_size", 16); content.add_child(reward_label)
	milestone_label = Label.new(); milestone_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; milestone_label.add_theme_color_override("font_color", Color(0.82, 0.72, 1.0)); content.add_child(milestone_label)
	var back := Button.new(); back.text = "BACK TO MUSEUM"; back.custom_minimum_size = Vector2(0, 56); game._style_upgrade_button(back, Color(0.65, 0.4, 0.18)); root.add_child(back); back.pressed.connect(game._show_museum)
	update_ui()
	apply_responsive_layout()


func apply_responsive_layout(viewport_width: float = -1.0) -> void:
	if panel == null or not is_instance_valid(panel):
		return
	if viewport_width <= 0.0:
		viewport_width = game.get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	var root_margin := panel.find_child("BowlRootMargin", true, false) as MarginContainer
	if root_margin != null:
		game._set_telegram_margins(root_margin, 8 if compact else 12, 8 if compact else 10, 8 if compact else 12, 12 if compact else 14)
	var title := panel.find_child("BowlTitle", true, false) as Label
	if title != null:
		title.custom_minimum_size = Vector2(0.0, 62.0 if compact else 0.0)
		title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title.add_theme_font_size_override("font_size", 23 if compact else 29)
	var subtitle := panel.find_child("BowlSubtitle", true, false) as Label
	if subtitle != null:
		subtitle.custom_minimum_size.x = 0.0
		subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		subtitle.add_theme_font_size_override("font_size", 16 if compact else 18)
	if is_instance_valid(scroll):
		scroll.custom_minimum_size = Vector2.ZERO
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var content := panel.find_child("BowlContent", true, false) as VBoxContainer
	if content != null:
		content.custom_minimum_size.x = 0.0
	var bowl := panel.find_child("BowlArt", true, false) as TextureRect
	if bowl != null:
		bowl.custom_minimum_size = Vector2(0.0, 250.0 if compact else 310.0)
	var donate_row := panel.find_child("DonateRow", true, false) as HBoxContainer
	if donate_row != null:
		donate_row.custom_minimum_size.x = 0.0
		donate_row.add_theme_constant_override("separation", 8 if compact else 10)
	if is_instance_valid(donate_edit):
		donate_edit.custom_minimum_size.x = 0.0
		donate_edit.add_theme_font_size_override("font_size", 16 if compact else 20)
	if is_instance_valid(donate_button):
		donate_button.custom_minimum_size = Vector2(112.0 if compact else 170.0, 52.0 if compact else 54.0)
	for label_node in panel.find_children("*", "Label", true, false):
		var label := label_node as Label
		if label == null or label == title or label == subtitle:
			continue
		label.custom_minimum_size.x = 0.0
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_font_size_override("font_size", 16 if compact else maxi(18, label.get_theme_font_size("font_size")))
	for button_node in panel.find_children("*", "Button", true, false):
		var action := button_node as Button
		if action == null:
			continue
		action.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		action.add_theme_font_size_override("font_size", 16 if compact else 20)

func get_cost(for_level: int = level) -> int:
	return mini(game.MAX_RESOURCE_VALUE, int(round(BASE_COST * pow(2.35, for_level))))

func _donate() -> void:
	_check_week()
	var amount: int = mini(game.coins, maxi(0, int(donate_edit.text)))
	if amount <= 0 or not game._spend_coins(amount): return
	progress += amount
	while progress >= get_cost():
		progress -= get_cost(); level += 1; _grant_reward()
	donate_edit.clear(); game._update_coins(false); game._update_score(); update_ui(); game._queue_save()

func _grant_reward() -> void:
	rewards_earned += 1
	match (rewards_earned - 1) % 6:
		0: _grant_gem()
		1: cozy_crates += 1
		2: boost_end_time = maxi(boost_end_time, int(game._get_unix_time())) + 600
		3: _grant_food()
		4:
			var kibble_reward: int = maxi(1000, get_cost(maxi(0, level - 1)) / 4)
			game._add_score(kibble_reward); game._add_coins(kibble_reward)
		5: crate_keys += 1
	if game.special_milestone_sound != null: game.special_milestone_sound.play()

func _grant_gem() -> void:
	if game.crate_logic == null: return
	var candidates: Array[Dictionary] = []
	for skin: Dictionary in game.SKIN_DATA:
		var skin_id: String = String(skin["id"])
		if game.crate_logic.get_fragments(skin_id) < game.crate_logic.MAX_GEM_FRAGMENTS: candidates.append(skin)
	if candidates.is_empty(): return
	var skin_data: Dictionary = candidates.pick_random()
	var skin_id: String = String(skin_data["id"])
	game.crate_logic.gem_fragments[skin_id] = game.crate_logic.get_fragments(skin_id) + 1
	if game.crate_logic.get_fragments(skin_id) >= game.crate_logic.get_skin_unlock_cost(skin_data) and skin_id != game.DEFAULT_SKIN_ID and skin_id not in game.owned_skin_ids:
		game.owned_skin_ids.append(skin_id)
		game._update_skins_ui()
	game.crate_logic.update_ui(true)

func _grant_food() -> void:
	var food_id: String = "food_%02d" % randi_range(0, game.FOOD_NAMES.size() - 1)
	game.food_inventory[food_id] = int(game.food_inventory.get(food_id, 0)) + 1

func get_gain_multiplier() -> float:
	return 1.5 if int(game._get_unix_time()) < boost_end_time else 1.0

func _check_week() -> void:
	var current: int = int(game._get_unix_time()) / WEEK_SECONDS
	if week_id == 0: week_id = current
	elif week_id != current: week_id = current; level = 0; progress = 0

func update_ui() -> void:
	if not is_instance_valid(level_label): return
	_check_week()
	var cost: int = get_cost()
	level_label.text = "WEEKLY BOWL  •  LEVEL %d" % level
	progress_bar.max_value = cost; progress_bar.value = progress
	progress_label.text = "%s / %s KIBBLE" % [game._format_number(progress), game._format_number(cost)]
	wallet_label.text = "WALLET: %s KIBBLE" % game._format_number(game.coins)
	var reward_names: Array[String] = ["CAT GEM", "COZY CRATE", "10 MIN +50% BOOST", "FOOD", "KIBBLES", "UNIVERSAL CRATE KEY"]
	reward_label.text = "NEXT REWARD: %s\nLevels become substantially more expensive (×2.35 each)." % reward_names[rewards_earned % reward_names.size()]
	milestone_label.text = "BOWL REWARDS\n%d earned  •  %d Cozy Crates  •  %d universal keys\nKeys make any crate free. Cozy Crates make a Cozy Crate free." % [rewards_earned, cozy_crates, crate_keys]

func get_save_data() -> Dictionary:
	return {"level": level, "progress": progress, "rewards_earned": rewards_earned, "crate_keys": crate_keys, "cozy_crates": cozy_crates, "week_id": week_id, "boost_end_time": boost_end_time}

func load_save_data(data: Dictionary) -> void:
	level = maxi(0, int(data.get("level", 0))); progress = maxi(0, int(data.get("progress", 0))); rewards_earned = maxi(0, int(data.get("rewards_earned", data.get("lifetime_levels", 0)))); crate_keys = maxi(0, int(data.get("crate_keys", 0))); cozy_crates = maxi(0, int(data.get("cozy_crates", 0))); week_id = int(data.get("week_id", 0)); boost_end_time = int(data.get("boost_end_time", 0)); _check_week()
