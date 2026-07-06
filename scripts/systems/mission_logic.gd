extends RefCounted
class_name MissionLogic

const RESET_SECONDS := 12 * 60 * 60
const MISSION_COUNT := 250
const SLOT_COUNT := 3
const GEM_KIBBLE_VALUE := 100000

var game
var missions: Array[Dictionary] = []
var cycle_id := -1
var active_ids: Array[int] = []
var baselines: Dictionary = {}
var claimed: Dictionary = {}
var last_ui_second := -1

var button: Button
var panel: PanelContainer
var timer_label: Label
var list: VBoxContainer


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
	button.text = "Daily Missions"
	button.tooltip_text = "View your three 12-hour missions"
	button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	button.custom_minimum_size = Vector2(154, 58)
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
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	var title := Label.new()
	title.text = "DAILY MISSIONS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.86, 0.8, 1.0))
	root.add_child(title)
	timer_label = Label.new()
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 18)
	root.add_child(timer_label)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
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
	if now == last_ui_second:
		return
	last_ui_second = now
	_refresh_cycle()
	var left: int = RESET_SECONDS - (now % RESET_SECONDS)
	timer_label.text = "New missions in %02d:%02d:%02d" % [int(left / 3600), int((left % 3600) / 60), int(left % 60)]
	var ready := 0
	for id in active_ids:
		if not bool(claimed.get(str(id), false)) and _progress(id) >= int(missions[id]["target"]): ready += 1
	button.text = "Daily Missions" + ("  •  %d READY" % ready if ready > 0 else "")
	if not panel.visible and list.get_child_count() > 0:
		return
	_rebuild_cards()


func _rebuild_cards() -> void:
	for child in list.get_children(): child.queue_free()
	for id in active_ids:
		var mission := missions[id]
		var done := bool(claimed.get(str(id), false))
		var card := PanelContainer.new()
		var accent := Color(0.4, 0.85, 0.55) if mission["difficulty"] == "Easy" else (Color(0.35, 0.7, 1.0) if mission["difficulty"] == "Medium" else Color(0.85, 0.48, 1.0))
		card.add_theme_stylebox_override("panel", game._make_upgrade_style(Color(0.055, 0.06, 0.105, 0.98), accent, 16, 2, -1, 8))
		list.add_child(card)
		var margin := MarginContainer.new()
		for side in ["left", "top", "right", "bottom"]: margin.add_theme_constant_override("margin_" + side, 14)
		card.add_child(margin)
		var items := VBoxContainer.new()
		items.add_theme_constant_override("separation", 7)
		margin.add_child(items)
		var heading := Label.new()
		heading.text = "%s  •  %s" % [String(mission["difficulty"]).to_upper(), String(mission["text"])]
		heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		heading.add_theme_font_size_override("font_size", 19)
		items.add_child(heading)
		var progress := mini(_progress(id), int(mission["target"]))
		var detail := Label.new()
		detail.text = "EXPIRED — reward claimed" if done else "%s / %s  •  Reward: %s" % [game._format_number(progress), game._format_number(int(mission["target"])), _reward_text(mission["reward"])]
		detail.add_theme_color_override("font_color", Color(0.72, 0.75, 0.86))
		items.add_child(detail)
		var bar := ProgressBar.new()
		bar.max_value = int(mission["target"])
		bar.value = progress
		bar.custom_minimum_size.y = 18
		items.add_child(bar)
		var complete := Button.new()
		complete.text = "Expired" if done else ("Complete & claim" if progress >= int(mission["target"]) else "In progress")
		complete.disabled = done or progress < int(mission["target"])
		complete.pressed.connect(claim.bind(id))
		items.add_child(complete)


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
	game._play_bonus_sound()
	game._update_score()
	game._update_coins()
	game._update_skins_ui()
	if game.crate_logic != null: game.crate_logic.update_ui(true)
	game._queue_save()
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


func get_save_data() -> Dictionary:
	return {"cycle_id": cycle_id, "active_ids": active_ids.duplicate(), "baselines": baselines.duplicate(true), "claimed": claimed.duplicate(true)}


func load_save_data(data: Dictionary) -> void:
	cycle_id = int(data.get("cycle_id", -1))
	active_ids.clear()
	for value in data.get("active_ids", []): active_ids.append(clampi(int(value), 0, MISSION_COUNT - 1))
	baselines = data.get("baselines", {}).duplicate(true)
	claimed = data.get("claimed", {}).duplicate(true)
