extends RefCounted
class_name AchievementLogic

const TARGET_ACHIEVEMENT_COUNT := 1000
const MASTERY_TIERS_PER_CATEGORY := 120
const MASTERY_SERIES: Array[Dictionary] = [
	{"name": "Score Mastery", "property": "score", "maximum": 1000000000000000},
	{"name": "Tap Mastery", "property": "total_taps", "maximum": 1000000000},
	{"name": "Bonus Mastery", "property": "total_bonus_clicks", "maximum": 100000000},
	{"name": "Click Mastery", "property": "best_single_click", "maximum": 1000000000000000},
	{"name": "Bank Mastery", "property": "best_coin_balance", "maximum": 1000000000000000},
	{"name": "Streak Mastery", "property": "bonus_streak_activations", "maximum": 100000000},
	{"name": "Daily Mastery", "property": "best_daily_reward_streak", "maximum": 10000},
]

var game


func _init(game_ref) -> void:
	game = game_ref


func update_achievements_ui() -> void:
	var achievements: Array[Dictionary] = get_achievements()
	var unlocked_count: int = 0
	for achievement: Dictionary in achievements:
		var unlocked: bool = bool(achievement["unlocked"])
		if unlocked:
			unlocked_count += 1

	var percent: int = int(round((float(unlocked_count) / float(achievements.size())) * 100.0))
	game.achievements_button.text = "Achievements %d/%d" % [unlocked_count, achievements.size()]
	game.achievements_progress_label.text = "%d / %d UNLOCKED  -  %d%%" % [unlocked_count, achievements.size(), percent]
	game.achievements_progress_bar.max_value = achievements.size()
	game.achievements_progress_bar.value = unlocked_count
	game.achievements_filter.set_item_text(0, "ALL %d" % achievements.size())
	game.achievements_filter.set_item_text(1, "UNLOCKED %d" % unlocked_count)
	game.achievements_filter.set_item_text(2, "LOCKED %d" % (achievements.size() - unlocked_count))
	if game.achievements_panel.visible:
		rebuild_achievement_list(achievements)
	# Keep unlock tracking current without interrupting play with achievement toasts.
	sync_achievement_unlocks(achievements, false)


func rebuild_achievement_list(achievements: Array[Dictionary]) -> void:
	var selected_filter: int = clampi(int(game.achievements_filter.selected), 0, 2)
	game.achievements_list.clear()
	var visible_index: int = 0
	for index in range(achievements.size()):
		var achievement: Dictionary = achievements[index]
		var unlocked: bool = bool(achievement["unlocked"])
		if selected_filter == 1 and not unlocked:
			continue
		if selected_filter == 2 and unlocked:
			continue

		var marker: String = "DONE" if unlocked else "%04d" % (index + 1)
		var text: String = "%s   %s" % [marker, String(achievement["text"])]
		game.achievements_list.add_item(text)
		game.achievements_list.set_item_tooltip(visible_index, String(achievement["text"]))
		game.achievements_list.set_item_custom_fg_color(
			visible_index,
			Color(1.0, 0.84, 0.34, 1.0) if unlocked else Color(0.64, 0.68, 0.76, 1.0)
		)
		visible_index += 1

	var filter_names: Array[String] = ["ALL", "UNLOCKED", "LOCKED"]
	var filter_name: String = filter_names[selected_filter]
	game.achievements_filter.tooltip_text = "%s: %d achievements shown" % [filter_name, visible_index]


func sync_achievement_unlocks(achievements: Array[Dictionary], show_popups: bool) -> void:
	var unlocked_now: Dictionary = {}
	for achievement in achievements:
		if not bool(achievement["unlocked"]):
			continue
		var achievement_id = String(achievement["text"])
		unlocked_now[achievement_id] = true
		if show_popups and not game.known_achievement_ids.has(achievement_id):
			show_achievement_popup(achievement_id)
	game.known_achievement_ids = unlocked_now.duplicate()


func show_achievement_popup(achievement_text: String) -> void:
	if not game.is_inside_tree():
		return

	var width = minf(game.size.x - 48.0, 360.0)
	var popup = Control.new()
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.z_index = 55
	popup.size = Vector2(width, 92.0)
	popup.set_meta("achievement_popup", true)
	game.click_popup_layer.add_child(popup)

	var stack_index = get_active_achievement_popup_count() - 1
	popup.position = Vector2(game.size.x - width - 24.0, 24.0 + float(maxi(stack_index, 0)) * 100.0)
	popup.modulate.a = 0.0
	popup.scale = Vector2(0.92, 0.92)
	popup.pivot_offset = popup.size * 0.5

	var background = Panel.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.add_theme_stylebox_override(
		"panel",
		game._make_upgrade_style(Color(0.055, 0.07, 0.11, 0.97), Color(1.0, 0.76, 0.22, 0.95), 16, 2, -1, 10)
	)
	popup.add_child(background)

	var icon = TextureRect.new()
	icon.texture = game.menu_coin_icon.texture
	icon.position = Vector2(14.0, 18.0)
	icon.custom_minimum_size = Vector2(42.0, 42.0)
	icon.size = Vector2(42.0, 42.0)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.modulate = Color(1.0, 0.9, 0.46, 1.0)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.add_child(icon)

	var title = Label.new()
	title.text = "ACHIEVEMENT UNLOCKED"
	title.position = Vector2(68.0, 13.0)
	title.size = Vector2(width - 82.0, 24.0)
	title.add_theme_font_size_override("font_size", 15)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4, 1.0))
	title.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.72))
	title.add_theme_constant_override("shadow_offset_x", 1)
	title.add_theme_constant_override("shadow_offset_y", 1)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.add_child(title)

	var message = Label.new()
	message.text = achievement_text
	message.position = Vector2(68.0, 37.0)
	message.size = Vector2(width - 86.0, 42.0)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message.add_theme_font_size_override("font_size", 18)
	message.add_theme_color_override("font_color", Color(0.97, 0.98, 1.0, 1.0))
	message.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	message.add_theme_constant_override("shadow_offset_x", 1)
	message.add_theme_constant_override("shadow_offset_y", 1)
	message.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.add_child(message)

	var tween = game.create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position:x", popup.position.x - 18.0, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_interval(2.2)
	tween.tween_property(popup, "position:x", popup.position.x + 28.0, 0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(popup, "modulate:a", 0.0, 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(Callable(popup, "queue_free"))


func get_active_achievement_popup_count() -> int:
	var count = 0
	for child in game.click_popup_layer.get_children():
		if child.has_meta("achievement_popup"):
			count += 1
	return count


func achievement(text: String, unlocked: bool) -> Dictionary:
	return {"text": text, "unlocked": unlocked}


func append_threshold_achievements(achievements: Array[Dictionary], current_value: int, thresholds: Array[int], template: String) -> void:
	for threshold in thresholds:
		achievements.append(achievement(template % game._format_number(threshold), current_value >= threshold))


func append_skin_achievements(achievements: Array[Dictionary]) -> void:
	var unlocked_skins = get_unlocked_skin_count()
	for threshold in [2, 3, 4, 5, 6, 7, 8, 9]:
		achievements.append(achievement("%d skins unlocked" % threshold, unlocked_skins >= threshold))


func append_click_power_achievements(achievements: Array[Dictionary]) -> void:
	for threshold in range(2, game.MAX_CLICK_VALUE + 1):
		achievements.append(achievement("Click value x%d" % threshold, game.unlocked_click_value >= threshold))


func append_bonus_chance_achievements(achievements: Array[Dictionary]) -> void:
	for level in [5, 10, 20, 30, 40, 50, 75, 100, 125, 150, 175, 200]:
		achievements.append(achievement("Bonus chance %.1f%%" % game._get_bonus_chance_percent(level), game.bonus_chance_level >= level))


func append_bonus_value_achievements(achievements: Array[Dictionary]) -> void:
	for multiplier in game.BONUS_MULTIPLIERS:
		achievements.append(achievement("Bonus value x%d" % int(multiplier), game._get_bonus_multiplier() >= int(multiplier)))


func append_bonus_streak_achievements(achievements: Array[Dictionary]) -> void:
	for threshold in range(game.MIN_BONUS_STREAK_MULTIPLIER, game.MAX_BONUS_STREAK_MULTIPLIER + 1):
		achievements.append(achievement("Bonus streak x%d" % threshold, game.bonus_streak_multiplier >= threshold))


func append_mastery_achievements(achievements: Array[Dictionary]) -> void:
	for series_data: Dictionary in MASTERY_SERIES:
		var series_name: String = String(series_data["name"])
		var property_name: StringName = StringName(series_data["property"])
		var current_value: int = int(game.get(property_name))
		var maximum: int = int(series_data["maximum"])
		var previous_threshold := 0
		for tier in range(1, MASTERY_TIERS_PER_CATEGORY + 1):
			var progress: float = float(tier - 1) / float(MASTERY_TIERS_PER_CATEGORY - 1)
			var threshold: int = maxi(previous_threshold + 1, roundi(pow(float(maximum), progress)))
			previous_threshold = threshold
			var text := "%s %03d: reach %s" % [series_name, tier, game._format_number(threshold)]
			achievements.append(achievement(text, current_value >= threshold))


func get_unlocked_skin_count() -> int:
	return game.owned_skin_ids.size() + 1


func get_achievements() -> Array[Dictionary]:
	var achievements: Array[Dictionary] = []
	append_threshold_achievements(achievements, game.score, [1, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000, 2500000, 5000000, 10000000], "%s total score")
	append_threshold_achievements(achievements, game.total_taps, [1, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000], "%s total taps")
	append_threshold_achievements(achievements, game.total_bonus_clicks, [1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000], "%s bonus hits")
	append_threshold_achievements(achievements, game.best_single_click, [2, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000], "Best click %s")
	append_threshold_achievements(achievements, game.best_coin_balance, [10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000], "%s kibbles banked at once")
	append_threshold_achievements(achievements, game.bonus_streak_activations, [1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500], "%s streak activations")
	append_threshold_achievements(achievements, game.passive_clicks_per_minute, [1, 2, 3, 5, 7, 10, 12, 15, 20, 25, 30], "Offline gain %s/min")
	append_threshold_achievements(achievements, game.best_daily_reward_streak, [1, 2, 3, 5, 7, 14, 30, 60, 100], "%s-day reward streak")
	append_click_power_achievements(achievements)
	append_bonus_chance_achievements(achievements)
	append_bonus_value_achievements(achievements)
	append_bonus_streak_achievements(achievements)
	append_skin_achievements(achievements)
	append_mastery_achievements(achievements)
	achievements.append(achievement("Cat Collector Supreme: unlock every skin", get_unlocked_skin_count() >= game.SKIN_DATA.size()))
	assert(achievements.size() == TARGET_ACHIEVEMENT_COUNT)
	return achievements
