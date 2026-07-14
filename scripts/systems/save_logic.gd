extends RefCounted
class_name SaveLogic

var game


func _init(game_ref) -> void:
	game = game_ref


func queue_save() -> void:
	if game.save_timer == null:
		save_game()
		return
	if game.save_timer.is_stopped():
		game.save_timer.start()


func save_game() -> void:
	var save_file = ConfigFile.new()
	save_file.set_value(game.SAVE_SECTION, game.SAVE_SCORE_KEY, game.score)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_COINS_KEY, game.coins)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_CLICK_VALUE_KEY, game.click_value)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_UNLOCKED_CLICK_VALUE_KEY, game.unlocked_click_value)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BONUS_CHANCE_LEVEL_KEY, game.bonus_chance_level)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BONUS_VALUE_INDEX_KEY, game.bonus_value_index)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BONUS_STREAK_MULTIPLIER_KEY, game.bonus_streak_multiplier)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_TOTAL_TAPS_KEY, game.total_taps)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_TOTAL_BONUS_CLICKS_KEY, game.total_bonus_clicks)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BONUS_STREAK_ACTIVATIONS_KEY, game.bonus_streak_activations)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BEST_SINGLE_CLICK_KEY, game.best_single_click)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY, game.passive_clicks_per_minute)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BEST_COIN_BALANCE_KEY, game.best_coin_balance)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_LAST_SEEN_UNIX_KEY, get_unix_time())
	save_file.set_value(game.SAVE_SECTION, game.SAVE_LAST_DAILY_REWARD_DAY_KEY, game.last_daily_reward_day)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_DAILY_REWARD_STREAK_KEY, game.daily_reward_streak)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_BEST_DAILY_REWARD_STREAK_KEY, game.best_daily_reward_streak)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_CLICK_VOLUME_KEY, game.click_volume)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_UI_VOLUME_KEY, game.ui_volume)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_LOW_QUALITY_ENABLED_KEY, game.low_quality_enabled)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_OPTIMIZED_TAP_EFFECTS_KEY, game.optimized_tap_effects)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_PARTICLE_LIMIT_KEY, game.particle_limit)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_HAPTICS_ENABLED_KEY, game.haptics_enabled)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_EVENTS_ENABLED_KEY, game.events_enabled)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_SLIDER_SOUND_STYLE_KEY, game.slider_sound_style)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_OWNED_SKINS_KEY, PackedStringArray(game.owned_skin_ids))
	save_file.set_value(game.SAVE_SECTION, game.SAVE_EQUIPPED_SKIN_KEY, game.equipped_skin_id)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_EQUIPPED_ROOM_SKIN_KEY, game.equipped_room_skin_id)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_EXTENDED_UPGRADES_KEY, game.extended_upgrade_levels)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_FOOD_INVENTORY_KEY, game.food_inventory)
	save_file.set_value(game.SAVE_SECTION, game.SAVE_TUTORIAL_COMPLETED_KEY, game.tutorial_completed)
	save_file.set_value(game.SAVE_SECTION, "active_boost_end_times", game.active_boost_end_times)
	save_file.set_value(game.SAVE_SECTION, "boost_recharge_end_times", game.boost_recharge_end_times)
	save_file.set_value(game.SAVE_SECTION, "active_food_boosts", game.active_food_boosts)
	save_file.set_value(game.SAVE_SECTION, "nine_lives_taps_left", game.nine_lives_taps_left)
	save_file.set_value(game.SAVE_SECTION, "nine_lives_recharge_duration", game.nine_lives_recharge_duration)
	if game.crate_logic != null:
		save_file.set_value(game.SAVE_SECTION, "crate_collection", game.crate_logic.get_save_data())
	if game.mission_logic != null:
		save_file.set_value(game.SAVE_SECTION, "daily_missions", game.mission_logic.get_save_data())
	if game.bottomless_bowl_logic != null:
		save_file.set_value(game.SAVE_SECTION, "bottomless_bowl", game.bottomless_bowl_logic.get_save_data())
	save_file.set_value(game.SAVE_SECTION, game.SAVE_095_BALANCE_MIGRATION_KEY, game.update_095_balance_migration_applied)
	var err = save_file.save(game.SAVE_PATH)
	if err != OK:
		game.push_warning("Could not save clicker progress: %s" % error_string(err))


func load_game() -> void:
	if not FileAccess.file_exists(game.SAVE_PATH):
		game.update_095_balance_migration_applied = true
		return
	var save_file = ConfigFile.new()
	var err = save_file.load(game.SAVE_PATH)
	if err != OK:
		game.push_warning("Could not load clicker progress: %s" % error_string(err))
		return

	game.score = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_SCORE_KEY, 0))
	game.coins = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_COINS_KEY, game.score))
	game.unlocked_click_value = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_UNLOCKED_CLICK_VALUE_KEY, save_file.get_value(game.SAVE_SECTION, game.SAVE_CLICK_VALUE_KEY, 1)))
	game.unlocked_click_value = clampi(game.unlocked_click_value, 1, game.MAX_CLICK_VALUE)
	game.click_value = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_CLICK_VALUE_KEY, game.unlocked_click_value))
	game.click_value = clampi(game.click_value, 1, game.unlocked_click_value)
	game.bonus_chance_level = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BONUS_CHANCE_LEVEL_KEY, 1))
	game.bonus_chance_level = clampi(game.bonus_chance_level, 1, game.MAX_BONUS_CHANCE_LEVEL)
	game.bonus_value_index = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BONUS_VALUE_INDEX_KEY, 0))
	game.bonus_value_index = clampi(game.bonus_value_index, 0, game.BONUS_MULTIPLIERS.size() - 1)
	game.bonus_streak_multiplier = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BONUS_STREAK_MULTIPLIER_KEY, game.MIN_BONUS_STREAK_MULTIPLIER))
	game.bonus_streak_multiplier = clampi(game.bonus_streak_multiplier, game.MIN_BONUS_STREAK_MULTIPLIER, game.MAX_BONUS_STREAK_MULTIPLIER)
	game.total_taps = maxi(0, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_TOTAL_TAPS_KEY, 0)))
	game.total_bonus_clicks = maxi(0, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_TOTAL_BONUS_CLICKS_KEY, 0)))
	game.bonus_streak_activations = maxi(0, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BONUS_STREAK_ACTIVATIONS_KEY, 0)))
	game.best_single_click = maxi(0, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BEST_SINGLE_CLICK_KEY, 0)))
	game.passive_clicks_per_minute = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY, 1))
	game.passive_clicks_per_minute = clampi(game.passive_clicks_per_minute, 1, game.MAX_PASSIVE_CLICKS_PER_MINUTE)
	game.last_daily_reward_day = int(save_file.get_value(game.SAVE_SECTION, game.SAVE_LAST_DAILY_REWARD_DAY_KEY, -1))
	game.daily_reward_streak = maxi(0, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_DAILY_REWARD_STREAK_KEY, 0)))
	game.best_coin_balance = maxi(0, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BEST_COIN_BALANCE_KEY, game.coins)))
	game.best_daily_reward_streak = maxi(game.daily_reward_streak, int(save_file.get_value(game.SAVE_SECTION, game.SAVE_BEST_DAILY_REWARD_STREAK_KEY, game.daily_reward_streak)))
	game.click_volume = clamp(float(save_file.get_value(game.SAVE_SECTION, game.SAVE_CLICK_VOLUME_KEY, 1.0)), 0.0, 1.0)
	game.ui_volume = clamp(float(save_file.get_value(game.SAVE_SECTION, game.SAVE_UI_VOLUME_KEY, 1.0)), 0.0, 1.0)
	game.low_quality_enabled = bool(save_file.get_value(game.SAVE_SECTION, game.SAVE_LOW_QUALITY_ENABLED_KEY, false))
	game.optimized_tap_effects = bool(save_file.get_value(game.SAVE_SECTION, game.SAVE_OPTIMIZED_TAP_EFFECTS_KEY, false))
	game.particle_limit = clampi(int(save_file.get_value(game.SAVE_SECTION, game.SAVE_PARTICLE_LIMIT_KEY, game.PARTICLE_LIMIT_INFINITE)), 1, game.PARTICLE_LIMIT_INFINITE)
	game.haptics_enabled = bool(save_file.get_value(game.SAVE_SECTION, game.SAVE_HAPTICS_ENABLED_KEY, true))
	game.events_enabled = bool(save_file.get_value(game.SAVE_SECTION, game.SAVE_EVENTS_ENABLED_KEY, true))
	game.slider_sound_style = clampi(int(save_file.get_value(game.SAVE_SECTION, game.SAVE_SLIDER_SOUND_STYLE_KEY, 0)), 0, game.UI_SOUND_VARIANTS.size() - 1)
	game.tutorial_completed = bool(save_file.get_value(game.SAVE_SECTION, game.SAVE_TUTORIAL_COMPLETED_KEY, false))
	game.owned_skin_ids.clear()
	var saved_owned_skins: PackedStringArray = save_file.get_value(game.SAVE_SECTION, game.SAVE_OWNED_SKINS_KEY, PackedStringArray())
	for skin_id in saved_owned_skins:
		var saved_skin_id = String(skin_id)
		if saved_skin_id != game.DEFAULT_SKIN_ID and game._is_valid_skin_id(saved_skin_id) and saved_skin_id not in game.owned_skin_ids:
			game.owned_skin_ids.append(saved_skin_id)
	game.equipped_skin_id = String(save_file.get_value(game.SAVE_SECTION, game.SAVE_EQUIPPED_SKIN_KEY, game.DEFAULT_SKIN_ID))
	if not game._is_valid_skin_id(game.equipped_skin_id) or not game._owns_skin(game.equipped_skin_id):
		game.equipped_skin_id = game.DEFAULT_SKIN_ID
	game.equipped_room_skin_id = String(save_file.get_value(game.SAVE_SECTION, game.SAVE_EQUIPPED_ROOM_SKIN_KEY, game.DEFAULT_ROOM_SKIN_ID))
	if game._get_room_skin_data(game.equipped_room_skin_id).is_empty():
		game.equipped_room_skin_id = game.DEFAULT_ROOM_SKIN_ID
	game.ui_tint = game.DEFAULT_UI_TINT
	var saved_extended_upgrades: Dictionary = save_file.get_value(game.SAVE_SECTION, game.SAVE_EXTENDED_UPGRADES_KEY, {})
	for raw_upgrade_data in game.EXTENDED_UPGRADE_DATA:
		var upgrade_data: Dictionary = raw_upgrade_data
		var upgrade_id: String = String(upgrade_data["id"])
		var max_level: int = int(upgrade_data["max_level"])
		game.extended_upgrade_levels[upgrade_id] = clampi(int(saved_extended_upgrades.get(upgrade_id, 0)), 0, max_level)
	game.active_boost_end_times = save_file.get_value(game.SAVE_SECTION, "active_boost_end_times", {})
	game.boost_recharge_end_times = save_file.get_value(game.SAVE_SECTION, "boost_recharge_end_times", {})
	game.active_food_boosts = save_file.get_value(game.SAVE_SECTION, "active_food_boosts", {})
	var saved_food_inventory: Dictionary = save_file.get_value(game.SAVE_SECTION, game.SAVE_FOOD_INVENTORY_KEY, {})
	game.food_inventory.clear()
	for index in range(game.FOOD_NAMES.size()):
		var food_id: String = game._get_food_id(index)
		game.food_inventory[food_id] = maxi(0, int(saved_food_inventory.get(food_id, 0)))
	game.nine_lives_taps_left = maxi(0, int(save_file.get_value(game.SAVE_SECTION, "nine_lives_taps_left", 0)))
	game.nine_lives_recharge_duration = maxf(0.0, float(save_file.get_value(game.SAVE_SECTION, "nine_lives_recharge_duration", 0.0)))
	if game.crate_logic != null:
		var crate_save_data: Dictionary = save_file.get_value(game.SAVE_SECTION, "crate_collection", {})
		game.crate_logic.load_save_data(crate_save_data)
	if game.mission_logic != null:
		var mission_save_data: Dictionary = save_file.get_value(game.SAVE_SECTION, "daily_missions", {})
		game.mission_logic.load_save_data(mission_save_data)
	if game.bottomless_bowl_logic != null:
		game.bottomless_bowl_logic.load_save_data(save_file.get_value(game.SAVE_SECTION, "bottomless_bowl", {}))
	game.update_095_balance_migration_applied = bool(save_file.get_value(game.SAVE_SECTION, game.SAVE_095_BALANCE_MIGRATION_KEY, false))
	apply_offline_gain(int(save_file.get_value(game.SAVE_SECTION, game.SAVE_LAST_SEEN_UNIX_KEY, get_unix_time())))
	if not game.update_095_balance_migration_applied:
		game.score = mini(game.score, game.UPDATE_095_RESOURCE_CAP)
		game.coins = mini(game.coins, game.UPDATE_095_RESOURCE_CAP)
		game.best_coin_balance = mini(game.best_coin_balance, game.UPDATE_095_RESOURCE_CAP)
		game.update_095_balance_migration_applied = true
		save_game()
	game._sync_resource_bounds()


func apply_offline_gain(last_seen_unix: int) -> void:
	var elapsed_seconds: int = maxi(0, get_unix_time() - last_seen_unix)
	var offline_cap_seconds: int = int(game.get_offline_gain_max_seconds())
	var capped_seconds: int = mini(elapsed_seconds, offline_cap_seconds)
	game.last_offline_was_capped = elapsed_seconds > offline_cap_seconds
	game.last_offline_minutes = floori(float(capped_seconds) / 60.0)
	game.last_offline_gain = 0
	if game.last_offline_minutes <= 0:
		return
	var base_offline_gain = game.last_offline_minutes * game._get_effective_passive_gain()
	game.last_offline_gain = maxi(0, roundi(float(base_offline_gain) * game._get_global_gain_multiplier()))
	game.last_offline_gain = mini(game.last_offline_gain, game.MAX_RESOURCE_VALUE)
	var applied_gain: int = mini(game._add_score(game.last_offline_gain), game._add_coins(game.last_offline_gain))
	game.last_offline_gain = applied_gain


func apply_resumed_offline_gain() -> void:
	if game.app_backgrounded_at_unix <= 0:
		return
	apply_offline_gain(game.app_backgrounded_at_unix)
	game.app_backgrounded_at_unix = 0
	if game.last_offline_gain <= 0:
		return
	game._update_score()
	game._update_upgrade_ui()
	game._update_achievements_ui()
	game._update_stats_ui()
	show_offline_gain_message()
	queue_save()


func show_offline_gain_message() -> void:
	if game.last_offline_gain <= 0:
		return
	var cap_text = " (max time reached)" if game.last_offline_was_capped else ""
	var popup = Control.new()
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.z_index = 30
	game.click_popup_layer.add_child(popup)

	var popup_width = minf(game.size.x - 48.0, 520.0)
	popup.size = Vector2(popup_width, 170.0)
	popup.position = Vector2((game.size.x - popup_width) * 0.5, 150.0)
	popup.modulate.a = 0.0
	popup.scale = Vector2(0.9, 0.9)
	popup.pivot_offset = popup.size * 0.5

	var background = Panel.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	var box = StyleBoxFlat.new()
	box.bg_color = Color(0.045, 0.055, 0.07, 0.96)
	box.border_color = Color(1.0, 0.84, 0.28, 0.95)
	box.set_border_width_all(3)
	box.set_corner_radius_all(8)
	box.shadow_color = Color(0.0, 0.0, 0.0, 0.45)
	box.shadow_size = 12
	background.add_theme_stylebox_override("panel", box)
	popup.add_child(background)

	var message = Label.new()
	message.text = "Welcome back!\nOffline gain: +%s kibbles\n%d min counted%s" % [game._format_number(game.last_offline_gain), game.last_offline_minutes, cap_text]
	message.position = Vector2(24.0, 28.0)
	message.size = Vector2(popup.size.x - 48.0, 104.0)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_font_size_override("font_size", 28)
	message.add_theme_color_override("font_color", Color(1.0, 0.95, 0.62, 1.0))
	message.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.75))
	message.add_theme_constant_override("shadow_offset_x", 2)
	message.add_theme_constant_override("shadow_offset_y", 2)
	popup.add_child(message)
	game._animate_coin_counter(maxi(0, game.coins - game.last_offline_gain), game.coins, 0.9)
	game._spawn_coin_stream(game.last_offline_gain, popup.get_global_rect().get_center())

	var close_button = Button.new()
	close_button.text = "X"
	close_button.tooltip_text = "Close"
	close_button.position = Vector2(popup.size.x - 58.0, 12.0)
	close_button.size = Vector2(42.0, 42.0)
	close_button.add_theme_font_size_override("font_size", 20)
	popup.add_child(close_button)
	close_button.pressed.connect(func() -> void:
		if is_instance_valid(popup):
			popup.queue_free()
	)

	var tween = game.create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_interval(3.0)
	tween.chain().tween_property(popup, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func() -> void:
		if is_instance_valid(popup):
			popup.queue_free()
	)


func get_offline_info_text() -> String:
	var offline_cap_seconds: int = int(game.get_offline_gain_max_seconds())
	var max_minutes: int = int(offline_cap_seconds / 60)
	var max_gain: int = maxi(0, roundi(float(game._get_effective_passive_gain() * max_minutes) * game._get_global_gain_multiplier()))
	return "Offline gain is capped at %d hours: up to %s kibbles." % [int(offline_cap_seconds / 3600), game._format_number(max_gain)]


func get_unix_time() -> int:
	return int(Time.get_unix_time_from_system())


func get_current_day_number() -> int:
	return floori(float(get_unix_time()) / 86400.0)
