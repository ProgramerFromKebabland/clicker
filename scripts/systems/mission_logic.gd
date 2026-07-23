extends RefCounted
class_name MissionLogic

# Mission board revision 2: adventure cards, rerolls, and board-clear celebration.

const RESET_SECONDS := 12 * 60 * 60
const MISSION_COUNT := 250
const SLOT_COUNT := 3
const GEM_KIBBLE_VALUE := 100000
const BOARD_CLEAR_BONUS_MULTIPLIER := 0.25
const BASE_REROLL_COST := 100
const MISSIONS_UI_ICON = preload("res://assets/ui/daily_missions.png")

var game
var missions: Array[Dictionary] = []
var cycle_id := -1
var active_ids: Array[int] = []
var baselines: Dictionary = {}
var claimed: Dictionary = {}
var board_bonus_claimed := false
var reroll_count := 0
var last_ui_second := -1
var last_cards_signature := ""

var button: Button
var panel: PanelContainer
var timer_label: Label
var list: VBoxContainer
var completion_label: Label
var cycle_progress: ProgressBar
var board_bonus_label: Label
var reroll_button: Button


func _init(game_ref) -> void:
	game = game_ref
	_build_prelist()


func _build_prelist() -> void:
	var types := ["taps", "kibbles", "bonus", "streaks", "crates"]
	var verbs := {
		"taps": "Tap the cat %s times",
		"kibbles": "Earn %s kibbles",
		"bonus": "Land %s bonus clicks",
		"streaks": "Activate %s bonus streaks",
		"crates": "Open %s crates",
	}
	for tier in range(1, 51):
		for kind in types:
			var difficulty := "Easy" if tier <= 17 else ("Medium" if tier <= 34 else "Hard")
			var target := _target_for(kind, tier)
			var id := missions.size()
			missions.append({
				"id": id, "kind": kind, "target": target, "difficulty": difficulty,
				"title": _mission_title(kind, tier),
				"text": String(verbs[kind]) % game._format_number(target),
				"reward": _reward_for(id, difficulty, tier),
			})
	assert(missions.size() == MISSION_COUNT)


func _target_for(kind: String, tier: int) -> int:
	match kind:
		"taps": return 20 + tier * tier * 4
		"kibbles": return 250 * tier * tier
		"bonus": return 2 + tier * 3
		"streaks": return 1 + int(tier / 3.0)
		"crates": return 1 + int(tier / 8.0)
	return tier


func _mission_title(kind: String, tier: int) -> String:
	var titles := {
		"taps": ["PAW-SPEED TRIAL", "TEMPLE TAPSTORM", "FURY OF THE PAWS", "THE THOUSAND-PAW TEST"],
		"kibbles": ["THE KIBBLE CACHE", "FEAST FUND", "FORTUNE OF THE FELINE", "THE GOLDEN BOWL"],
		"bonus": ["LUCKY WHISKERS", "FORTUNE FAVORS THE CAT", "CRITICAL CATITUDE", "TOUCH OF DESTINY"],
		"streaks": ["KEEP THE FIRE ALIVE", "UNBROKEN PAW", "COMBO CONQUEROR", "LEGENDARY MOMENTUM"],
		"crates": ["WHAT'S IN THE BOX?", "CRATE ESCAPADE", "TREASURE CLAWS", "RAID THE ROYAL VAULT"],
	}
	var rank := clampi(int((tier - 1) / 13.0), 0, 3)
	return String(titles[kind][rank])


func _reward_for(id: int, difficulty: String, tier: int) -> Dictionary:
	if difficulty == "Easy":
		return {"type": "kibbles", "amount": 500 + tier * 250}
	if difficulty == "Medium":
		if id % 3 == 0:
			return {"type": "gems", "amount": 1 + int(tier / 12.0)}
		return {"type": "kibbles", "amount": 10000 + tier * 2500}
	if id % 5 == 0:
		return {"type": "skin", "amount": 1}
	if id % 2 == 0:
		return {"type": "gems", "amount": 4 + int(tier / 10.0)}
	return {"type": "kibbles", "amount": 150000 + tier * 15000}


func build_ui() -> void:
	button = Button.new()
	button.name = "MissionsButton"
	button.text = "MISSIONS"
	button.icon = MISSIONS_UI_ICON
	button.expand_icon = true
	button.add_theme_constant_override("icon_max_width", 42)
	button.tooltip_text = "View your three 12-hour missions"
	button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	button.custom_minimum_size = Vector2(154, 68)
	button.add_theme_font_size_override("font_size", 17)
	game._style_upgrade_button(button, Color(0.56, 0.38, 1.0, 1.0))
	game.add_child(button)
	game.move_child(button, game.menu_overlay.get_index())
	button.pressed.connect(game._show_missions)

	panel = PanelContainer.new()
	panel.name = "MissionsPanel"
	panel.custom_minimum_size = Vector2(640, 920)
	panel.hide()
	game.menu_panel.get_parent().add_child(panel)
	panel.add_theme_stylebox_override("panel", game._make_upgrade_style(Color(0.04, 0.035, 0.085, 0.99), Color(0.65, 0.48, 1.0), 24, 2, -1, 16))
	var margin := MarginContainer.new()
	margin.name = "MissionRootMargin"
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)
	var root := VBoxContainer.new()
	root.name = "MissionRoot"
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	var title := Label.new()
	title.name = "MissionTitle"
	title.text = "MISSION BOARD"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.86, 0.8, 1.0))
	root.add_child(title)
	var subtitle := Label.new()
	subtitle.name = "MissionSubtitle"
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.text = "Three challenges. One glorious haul."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color(0.68, 0.66, 0.82))
	root.add_child(subtitle)
	var status_card := PanelContainer.new()
	status_card.name = "MissionStatusCard"
	status_card.add_theme_stylebox_override("panel", game._make_upgrade_style(Color(0.08, 0.065, 0.14, 0.98), Color(0.47, 0.34, 0.82), 14, 1, -1, 6))
	root.add_child(status_card)
	var status_margin := MarginContainer.new()
	status_margin.name = "MissionStatusMargin"
	for side in ["left", "top", "right", "bottom"]: status_margin.add_theme_constant_override("margin_" + side, 10)
	status_card.add_child(status_margin)
	var status_items := VBoxContainer.new()
	status_items.add_theme_constant_override("separation", 6)
	status_margin.add_child(status_items)
	completion_label = Label.new()
	completion_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	completion_label.add_theme_font_size_override("font_size", 18)
	status_items.add_child(completion_label)
	cycle_progress = ProgressBar.new()
	cycle_progress.max_value = SLOT_COUNT
	cycle_progress.custom_minimum_size.y = 14
	cycle_progress.show_percentage = false
	status_items.add_child(cycle_progress)
	board_bonus_label = Label.new()
	board_bonus_label.text = "CLEAR BONUS  +25% of all mission prizes"
	board_bonus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	board_bonus_label.add_theme_font_size_override("font_size", 14)
	board_bonus_label.add_theme_color_override("font_color", Color(1.0, 0.78, 0.3))
	status_items.add_child(board_bonus_label)
	reroll_button = Button.new()
	reroll_button.text = "REROLL BOARD  -  100 KIBBLES"
	reroll_button.tooltip_text = "Replace unfinished missions. The price doubles after every reroll."
	game._style_upgrade_button(reroll_button, Color(0.55, 0.42, 0.95))
	reroll_button.pressed.connect(_reroll_board)
	status_items.add_child(reroll_button)
	timer_label = Label.new()
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 15)
	timer_label.add_theme_color_override("font_color", Color(0.78, 0.75, 0.9))
	status_items.add_child(timer_label)
	var scroll := ScrollContainer.new()
	scroll.name = "MissionScroll"
	game._configure_touch_scroll(scroll)
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.scroll_vertical_custom_step = 140.0
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.clip_contents = true
	root.add_child(scroll)
	list = VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 14)
	scroll.add_child(list)
	_refresh_cycle()
	update_ui()


func _refresh_cycle() -> void:
	var now_cycle := int(game._get_unix_time() / RESET_SECONDS)
	if now_cycle == cycle_id and active_ids.size() == SLOT_COUNT:
		return
	cycle_id = now_cycle
	active_ids.clear()
	baselines.clear()
	claimed.clear()
	board_bonus_claimed = false
	var rng := RandomNumberGenerator.new()
	rng.seed = cycle_id * 7919 + 104729
	var buckets := [[0, 85], [85, 170], [170, 250]]
	for bucket in buckets:
		var id := rng.randi_range(int(bucket[0]), int(bucket[1]) - 1)
		while id in active_ids:
			id = rng.randi_range(int(bucket[0]), int(bucket[1]) - 1)
		active_ids.append(id)
		baselines[str(id)] = _counter(String(missions[id]["kind"]))
	game._queue_save()


func update_ui() -> void:
	if panel == null:
		return
	var now: int = int(game._get_unix_time())
	if now == last_ui_second and not panel.visible:
		return
	last_ui_second = now
	_refresh_cycle()
	var left: int = RESET_SECONDS - (now % RESET_SECONDS)
	timer_label.text = "New missions in %02d:%02d:%02d" % [int(left / 3600), int((left % 3600) / 60), int(left % 60)]
	var ready := 0
	var completed := 0
	for id in active_ids:
		if bool(claimed.get(str(id), false)): completed += 1
		elif _progress(id) >= int(missions[id]["target"]): ready += 1
	button.text = "%d/%d" % [mini(SLOT_COUNT, completed + ready), SLOT_COUNT]
	button.add_theme_color_override("font_color", Color(1.0, 0.86, 0.38) if ready > 0 else Color.WHITE)
	completion_label.text = _cycle_status_text(completed, ready)
	cycle_progress.value = completed
	board_bonus_label.text = "CLEAR BONUS CLAIMED!" if board_bonus_claimed else "CLEAR BONUS  +25% of all mission prizes"
	board_bonus_label.add_theme_color_override("font_color", Color(0.55, 1.0, 0.64) if board_bonus_claimed else Color(1.0, 0.78, 0.3))
	var reroll_cost := _get_reroll_cost()
	reroll_button.text = "REROLL BOARD  -  %s KIBBLES" % game._format_number(reroll_cost)
	reroll_button.disabled = completed > 0 or game.coins < reroll_cost
	if not panel.visible and list.get_child_count() > 0:
		return
	var card_signature := _get_cards_signature()
	if card_signature == last_cards_signature and list.get_child_count() > 0:
		return
	last_cards_signature = card_signature
	_rebuild_cards()


func _rebuild_cards() -> void:
	for child in list.get_children(): child.queue_free()
	for slot in range(active_ids.size()):
		var id := active_ids[slot]
		var mission := missions[id]
		var done := bool(claimed.get(str(id), false))
		var progress := mini(_progress(id), int(mission["target"]))
		var is_ready := not done and progress >= int(mission["target"])
		var card := PanelContainer.new()
		card.set_meta("mission_card", true)
		var accent := Color(0.4, 0.85, 0.55) if mission["difficulty"] == "Easy" else (Color(0.35, 0.7, 1.0) if mission["difficulty"] == "Medium" else Color(0.85, 0.48, 1.0))
		var card_fill := Color(0.075, 0.11, 0.09, 0.99) if is_ready else Color(0.055, 0.06, 0.105, 0.98)
		card.add_theme_stylebox_override("panel", game._make_upgrade_style(card_fill, accent, 18, 3 if is_ready else 2, -1, 10 if is_ready else 8))
		list.add_child(card)
		var margin := MarginContainer.new()
		margin.name = "MissionCardMargin"
		for side in ["left", "top", "right", "bottom"]: margin.add_theme_constant_override("margin_" + side, 14)
		card.add_child(margin)
		var items := VBoxContainer.new()
		items.add_theme_constant_override("separation", 9)
		margin.add_child(items)
		var eyebrow := Label.new()
		eyebrow.set_meta("mission_role", "eyebrow")
		eyebrow.text = "MISSION %d OF %d   /   %s   /   %s" % [slot + 1, SLOT_COUNT, String(mission["difficulty"]).to_upper(), _kind_name(String(mission["kind"]))]
		eyebrow.add_theme_font_size_override("font_size", 13)
		eyebrow.add_theme_color_override("font_color", accent)
		items.add_child(eyebrow)
		var heading := Label.new()
		heading.set_meta("mission_role", "heading")
		heading.text = String(mission["title"])
		heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		heading.add_theme_font_size_override("font_size", 21)
		items.add_child(heading)
		var objective := Label.new()
		objective.set_meta("mission_role", "objective")
		objective.text = String(mission["text"])
		objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		objective.add_theme_font_size_override("font_size", 16)
		objective.add_theme_color_override("font_color", Color(0.82, 0.83, 0.9))
		items.add_child(objective)
		var percent := int(round(100.0 * float(progress) / float(maxi(1, int(mission["target"])))))
		var detail := Label.new()
		detail.set_meta("mission_role", "detail")
		detail.text = "REWARD CLAIMED - nicely done!" if done else "%s / %s  (%d%%)" % [game._format_number(progress), game._format_number(int(mission["target"])), percent]
		detail.add_theme_color_override("font_color", Color(0.72, 0.75, 0.86))
		items.add_child(detail)
		var bar := ProgressBar.new()
		bar.max_value = int(mission["target"])
		bar.value = progress
		bar.custom_minimum_size.y = 20
		bar.show_percentage = false
		items.add_child(bar)
		var reward := Label.new()
		reward.set_meta("mission_role", "reward")
		reward.text = "TREASURE  >>  %s" % _reward_text(mission["reward"])
		reward.add_theme_font_size_override("font_size", 16)
		reward.add_theme_color_override("font_color", Color(1.0, 0.82, 0.34) if not done else Color(0.55, 0.7, 0.58))
		items.add_child(reward)
		var complete := Button.new()
		complete.text = "CLAIMED" if done else ("CLAIM REWARD!" if progress >= int(mission["target"]) else _encouragement(percent))
		complete.disabled = done or progress < int(mission["target"])
		game._style_upgrade_button(complete, accent)
		complete.pressed.connect(claim.bind(id))
		items.add_child(complete)
	apply_responsive_layout()


func apply_responsive_layout(viewport_width: float = -1.0) -> void:
	if panel == null or not is_instance_valid(panel):
		return
	if viewport_width <= 0.0:
		viewport_width = game.get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	var root_margin := panel.find_child("MissionRootMargin", true, false) as MarginContainer
	if root_margin != null:
		game._set_telegram_margins(root_margin, 8 if compact else 12, 8 if compact else 10, 8 if compact else 12, 12 if compact else 14)
	var title := panel.find_child("MissionTitle", true, false) as Label
	if title != null:
		title.custom_minimum_size.x = 0.0
		title.clip_text = true
		title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		title.add_theme_font_size_override("font_size", 27 if compact else 30)
	var subtitle := panel.find_child("MissionSubtitle", true, false) as Label
	if subtitle != null:
		subtitle.custom_minimum_size.x = 0.0
		subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		subtitle.add_theme_font_size_override("font_size", 16 if compact else 18)
	var status_margin := panel.find_child("MissionStatusMargin", true, false) as MarginContainer
	if status_margin != null:
		game._set_telegram_margins(status_margin, 9 if compact else 10, 8 if compact else 10, 9 if compact else 10, 8 if compact else 10)
	for status_label in [completion_label, board_bonus_label, timer_label]:
		if status_label == null:
			continue
		status_label.custom_minimum_size.x = 0.0
		status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		status_label.add_theme_font_size_override("font_size", 16 if compact else 20)
	if reroll_button != null:
		reroll_button.custom_minimum_size.x = 0.0
		reroll_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		reroll_button.add_theme_font_size_override("font_size", 17 if compact else 20)
	var scroll := panel.find_child("MissionScroll", true, false) as ScrollContainer
	if scroll != null:
		scroll.custom_minimum_size = Vector2.ZERO
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	list.custom_minimum_size.x = 0.0
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for card_node in list.get_children():
		var card := card_node as PanelContainer
		if card == null:
			continue
		card.custom_minimum_size.x = 0.0
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var card_margin := card.find_child("MissionCardMargin", true, false) as MarginContainer
		if card_margin != null:
			game._set_telegram_margins(card_margin, 10 if compact else 14, 10 if compact else 14, 10 if compact else 14, 10 if compact else 14)
		for label_node in card.find_children("*", "Label", true, false):
			var label := label_node as Label
			if label == null:
				continue
			label.custom_minimum_size.x = 0.0
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			var role := String(label.get_meta("mission_role", ""))
			if role == "heading":
				label.add_theme_font_size_override("font_size", 22 if compact else 24)
			elif role in ["objective", "detail", "reward"]:
				label.add_theme_font_size_override("font_size", 17 if compact else 20)
			else:
				label.add_theme_font_size_override("font_size", 15 if compact else 18)
		for button_node in card.find_children("*", "Button", true, false):
			var action := button_node as Button
			if action == null:
				continue
			action.custom_minimum_size.x = 0.0
			action.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			action.add_theme_font_size_override("font_size", 17 if compact else 20)


func _get_cards_signature() -> String:
	var parts: Array[String] = []
	for id in active_ids:
		var mission := missions[id]
		var progress := mini(_progress(id), int(mission["target"]))
		parts.append("%d:%d:%s" % [id, progress, str(claimed.get(str(id), false))])
	parts.append("bonus:%s" % str(board_bonus_claimed))
	parts.append("rerolls:%d" % reroll_count)
	return "|".join(parts)


func _kind_name(kind: String) -> String:
	match kind:
		"taps": return "TAP FRENZY"
		"kibbles": return "KIBBLE HUNT"
		"bonus": return "LUCKY HITS"
		"streaks": return "STREAK CHASER"
		"crates": return "CRATE RAID"
	return "CHALLENGE"


func _encouragement(percent: int) -> String:
	if percent >= 75: return "SO CLOSE - KEEP GOING!"
	if percent >= 40: return "HALFWAY TO GLORY"
	if percent > 0: return "NICE START - KEEP PUSHING"
	return "START MISSION"


func _cycle_status_text(completed: int, ready: int) -> String:
	if completed == SLOT_COUNT: return "BOARD CLEARED!  3 / 3"
	if ready > 0: return "%d reward%s ready to claim!" % [ready, "" if ready == 1 else "s"]
	return "%d / %d missions conquered" % [completed, SLOT_COUNT]


func _reroll_board() -> void:
	for id in active_ids:
		if bool(claimed.get(str(id), false)):
			return
	var reroll_cost := _get_reroll_cost()
	if not game._spend_coins(reroll_cost):
		return
	reroll_count += 1
	var rng := RandomNumberGenerator.new()
	rng.seed = cycle_id * 15485863 + int(game._get_unix_time()) + 32452843
	var buckets := [[0, 85], [85, 170], [170, 250]]
	var replacements: Array[int] = []
	for index in range(SLOT_COUNT):
		var bucket: Array = buckets[index]
		var candidate := rng.randi_range(int(bucket[0]), int(bucket[1]) - 1)
		while candidate in active_ids or candidate in replacements:
			candidate = rng.randi_range(int(bucket[0]), int(bucket[1]) - 1)
		replacements.append(candidate)
	active_ids = replacements
	baselines.clear()
	claimed.clear()
	for id in active_ids:
		baselines[str(id)] = _counter(String(missions[id]["kind"]))
	game._queue_save()
	game._update_coins(false)
	last_ui_second = -1
	_rebuild_cards()
	update_ui()
	if game.has_method("_show_admin_status"):
		game._show_admin_status("Fresh missions! Next reroll: %s kibbles." % game._format_number(_get_reroll_cost()), Color(0.72, 0.62, 1.0))
	else:
		_spawn_board_notice("FRESH MISSIONS!", Color(0.72, 0.62, 1.0))


func _spawn_board_notice(text: String, color: Color) -> void:
	if panel == null or not is_instance_valid(panel):
		return
	var notice := Label.new()
	notice.text = text
	notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice.add_theme_font_size_override("font_size", 26)
	notice.add_theme_color_override("font_color", color)
	notice.position = Vector2(60, panel.size.y * 0.45)
	notice.size = Vector2(maxf(220.0, panel.size.x - 120.0), 48)
	notice.z_index = 25
	notice.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(notice)
	notice.pivot_offset = notice.size * 0.5
	notice.scale = Vector2(0.35, 0.35)
	var notice_tween: Tween = game.create_tween()
	notice_tween.tween_property(notice, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	notice_tween.tween_interval(0.45)
	notice_tween.tween_property(notice, "modulate:a", 0.0, 0.25)
	notice_tween.tween_callback(notice.queue_free)


func _reward_text(reward: Dictionary) -> String:
	match String(reward["type"]):
		"gems": return "%d gem%s" % [int(reward["amount"]), "" if int(reward["amount"]) == 1 else "s"]
		"skin": return "1 unowned skin"
	return "%s kibbles" % game._format_number(int(reward["amount"]))


func _counter(kind: String) -> int:
	match kind:
		"taps": return game.total_taps
		"kibbles": return game.score
		"bonus": return game.total_bonus_clicks
		"streaks": return game.bonus_streak_activations
		"crates": return game.crate_logic.total_crates_opened if game.crate_logic != null else 0
	return 0


func _progress(id: int) -> int:
	return maxi(0, _counter(String(missions[id]["kind"])) - int(baselines.get(str(id), 0)))


func claim(id: int) -> void:
	if id not in active_ids or bool(claimed.get(str(id), false)) or _progress(id) < int(missions[id]["target"]): return
	claimed[str(id)] = true
	var message := _grant_reward(missions[id]["reward"])
	var all_done := true
	for active_id in active_ids:
		if not bool(claimed.get(str(active_id), false)):
			all_done = false
			break
	if all_done and not board_bonus_claimed:
		board_bonus_claimed = true
		var bonus := _board_clear_bonus()
		_add_kibbles(bonus)
		message += "  +  BOARD CLEAR BONUS: %s kibbles!" % game._format_number(bonus)
	game._play_bonus_sound()
	game._update_score()
	game._update_coins()
	game._update_skins_ui()
	if game.crate_logic != null: game.crate_logic.update_ui(true)
	game._queue_save()
	_celebrate_claim(all_done)
	_rebuild_cards()
	game._show_admin_status(message, Color(0.7, 1.0, 0.65)) if game.has_method("_show_admin_status") else game._spawn_click_popup(1, 1)


func _grant_reward(reward: Dictionary) -> String:
	var reward_type := String(reward["type"])
	var amount := int(reward["amount"])
	if reward_type == "kibbles":
		_add_kibbles(amount)
		return "+%s kibbles" % game._format_number(amount)
	if reward_type == "gems":
		var candidates: Array[String] = []
		for skin in game.SKIN_DATA:
			var skin_id := String(skin["id"])
			if game.crate_logic.get_fragments(skin_id) < game.crate_logic.MAX_GEM_FRAGMENTS: candidates.append(skin_id)
		if candidates.is_empty():
			_add_kibbles(amount * GEM_KIBBLE_VALUE)
			return "All gems complete: +%s kibbles" % game._format_number(amount * GEM_KIBBLE_VALUE)
		for index in range(amount):
			if candidates.is_empty(): _add_kibbles(GEM_KIBBLE_VALUE); continue
			var skin_id := candidates[index % candidates.size()]
			game.crate_logic.gem_fragments[skin_id] = mini(game.crate_logic.MAX_GEM_FRAGMENTS, game.crate_logic.get_fragments(skin_id) + 1)
			if game.crate_logic.get_fragments(skin_id) > 0 and skin_id != game.DEFAULT_SKIN_ID and skin_id not in game.owned_skin_ids: game.owned_skin_ids.append(skin_id)
		return "+%d gem%s" % [amount, "" if amount == 1 else "s"]
	var missing: Array[Dictionary] = []
	for skin in game.SKIN_DATA:
		if not game._owns_skin(String(skin["id"])): missing.append(skin)
	if missing.is_empty():
		var fallback := int(game.SKIN_DATA[-1]["cost"])
		_add_kibbles(fallback)
		return "All skins owned: +%s kibbles" % game._format_number(fallback)
	var skin: Dictionary = missing[randi() % missing.size()]
	game.owned_skin_ids.append(String(skin["id"]))
	game.crate_logic.gem_fragments[String(skin["id"])] = maxi(1, game.crate_logic.get_fragments(String(skin["id"])))
	return "Unlocked %s" % String(skin["name"])


func _add_kibbles(amount: int) -> void:
	game._add_score(amount)
	game._add_coins(amount)


func _board_clear_bonus() -> int:
	var total := 0
	for id in active_ids:
		var reward: Dictionary = missions[id]["reward"]
		match String(reward["type"]):
			"kibbles": total += int(reward["amount"])
			"gems": total += int(reward["amount"]) * GEM_KIBBLE_VALUE
			"skin": total += maxi(10000, int(game.click_value) * 100)
	return maxi(500, int(round(total * BOARD_CLEAR_BONUS_MULTIPLIER)))


func _celebrate_claim(board_cleared: bool) -> void:
	var cheer := Label.new()
	cheer.text = "BOARD CLEARED!" if board_cleared else "MISSION COMPLETE!"
	cheer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cheer.add_theme_font_size_override("font_size", 30 if board_cleared else 24)
	cheer.add_theme_color_override("font_color", Color(1.0, 0.78, 0.22) if board_cleared else Color(0.55, 1.0, 0.66))
	cheer.position = Vector2(70, panel.size.y * 0.42)
	cheer.size = Vector2(maxf(200.0, panel.size.x - 140.0), 54)
	cheer.z_index = 20
	panel.add_child(cheer)
	cheer.pivot_offset = cheer.size * 0.5
	cheer.scale = Vector2(0.2, 0.2)
	var tween: Tween = game.create_tween()
	tween.tween_property(cheer, "scale", Vector2(1.15, 1.15), 0.28).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(cheer, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.45 if board_cleared else 0.2)
	tween.tween_property(cheer, "modulate:a", 0.0, 0.3)
	tween.tween_callback(cheer.queue_free)
	for index in range(18 if board_cleared else 8):
		var spark := ColorRect.new()
		spark.color = [Color(1.0, 0.72, 0.16), Color(0.58, 0.38, 1.0), Color(0.35, 0.9, 0.62)][index % 3]
		spark.size = Vector2(7, 12)
		spark.position = Vector2(panel.size.x * 0.5, panel.size.y * 0.48)
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		spark.z_index = 19
		panel.add_child(spark)
		var angle := TAU * float(index) / float(18 if board_cleared else 8)
		var distance := randf_range(90.0, 230.0 if board_cleared else 140.0)
		var destination := spark.position + Vector2(cos(angle), sin(angle)) * distance + Vector2(0, 45)
		var spark_tween: Tween = game.create_tween().set_parallel(true)
		spark_tween.tween_property(spark, "position", destination, 0.62).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		spark_tween.tween_property(spark, "rotation", randf_range(-4.0, 4.0), 0.62)
		spark_tween.tween_property(spark, "modulate:a", 0.0, 0.62).set_delay(0.22)
		spark_tween.chain().tween_callback(spark.queue_free)


func _get_reroll_cost() -> int:
	# Cap the exponent so corrupted or very old saves cannot overflow an int.
	return BASE_REROLL_COST * (1 << mini(reroll_count, 50))


func get_save_data() -> Dictionary:
	return {"cycle_id": cycle_id, "active_ids": active_ids.duplicate(), "baselines": baselines.duplicate(true), "claimed": claimed.duplicate(true), "board_bonus_claimed": board_bonus_claimed, "reroll_count": reroll_count}


func load_save_data(data: Dictionary) -> void:
	cycle_id = int(data.get("cycle_id", -1))
	active_ids.clear()
	for value in data.get("active_ids", []): active_ids.append(clampi(int(value), 0, MISSION_COUNT - 1))
	baselines = data.get("baselines", {}).duplicate(true)
	claimed = data.get("claimed", {}).duplicate(true)
	board_bonus_claimed = bool(data.get("board_bonus_claimed", false))
	reroll_count = maxi(0, int(data.get("reroll_count", 1 if bool(data.get("reroll_used", false)) else 0)))
