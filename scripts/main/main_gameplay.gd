extends "res://scripts/main/main_data.gd"


# SCORE, COMBO, UPGRADES, REWARDS, AND AUDIO


# SCORE AND COINS


func _update_score() -> void:
	score_label.text = "Clicks: %s" % _format_number(score)


func _update_coins(animated: bool = true) -> void:
	if displayed_coins < 0:
		displayed_coins = coins
		_set_coin_display(displayed_coins)
		return

	if not animated:
		if coin_counter_tween != null and coin_counter_tween.is_valid():
			coin_counter_tween.kill()
		displayed_coins = coins
		_set_coin_display(displayed_coins)
		return

	_animate_coin_counter(displayed_coins, coins)


func _set_coin_display(value: float) -> void:
	displayed_coins = roundi(value)
	var formatted := _format_number(displayed_coins)
	coins_label.text = "Coins: %s" % formatted
	menu_wallet_coins_label.text = "%s COINS" % formatted
	menu_coins_label.text = "Coins: %s" % formatted
	upgrade_coins_label.text = formatted


func _gain_coins(amount: int, origin_global: Vector2) -> void:
	if amount <= 0:
		return
	score += amount
	coins += amount
	_update_score()
	_update_coins(true)
	_spawn_coin_stream(amount, origin_global)


# COMBO


func _increase_combo() -> void:
	combo_clicks_toward_step += 1
	var gained_step := false
	if combo_clicks_toward_step >= COMBO_CLICKS_PER_STEP:
		combo_clicks_toward_step = 0
		combo_bonus = minf(MAX_COMBO_BONUS, combo_bonus + COMBO_STEP)
		gained_step = true

	combo_drain_elapsed = 0.0
	combo_grace_left = COMBO_DRAIN_GRACE_SECONDS
	combo_timer.start(COMBO_DRAIN_GRACE_SECONDS + COMBO_RESET_SECONDS)
	_update_combo_ui(gained_step)


func _reset_combo() -> void:
	combo_bonus = 0.0
	combo_drain_elapsed = 0.0
	combo_grace_left = 0.0
	combo_clicks_toward_step = 0
	_update_combo_ui()


func _get_combo_multiplier() -> float:
	return 1.0 + combo_bonus


func _update_combo_ui(animated: bool = false) -> void:
	combo_label.text = "Combo x%.1f" % _get_combo_multiplier()
	if combo_timer != null and not combo_timer.is_stopped():
		var shown_time := minf(COMBO_RESET_SECONDS, combo_timer.time_left)
		combo_timer_label.text = "%.1fs  %d/%d" % [shown_time, combo_clicks_toward_step, COMBO_CLICKS_PER_STEP]
	else:
		combo_timer_label.text = "ready"
	var heat := clampf(combo_bonus / MAX_COMBO_BONUS, 0.0, 1.0)
	var combo_color := Color(lerpf(0.8, 1.0, heat), lerpf(0.88, 0.82, heat), lerpf(1.0, 0.1, heat), 1.0)
	combo_label.add_theme_color_override("font_color", combo_color)
	combo_timer_label.add_theme_color_override("font_color", combo_color.darkened(0.15))
	if animated:
		_pop_control(combo_label, Vector2(1.12, 1.12), 0.18)


# UPGRADE DISPLAY


func _update_upgrade_ui() -> void:
	click_value_label.text = "Click value: x%d / unlocked x%d" % [click_value, unlocked_click_value]
	click_power_label.text = "Use click value: x%d" % click_value
	click_power_slider.max_value = unlocked_click_value
	click_power_slider.value = click_value
	upgrade_value_label.text = "x%d" % unlocked_click_value
	upgrade_button.disabled = false
	offline_info_label.text = _get_offline_info_text()

	if unlocked_click_value >= MAX_CLICK_VALUE:
		upgrade_button.text = "UPGRADES"
		upgrade_cost_label.text = "Maximum click power reached"
		_set_upgrade_progress(click_progress_bar, 1, true)
		_set_upgrade_button_state(upgrade_purchase_button, "Max value x%d" % MAX_CLICK_VALUE, true)
		_update_bonus_upgrade_ui()
		return

	var next_value := unlocked_click_value + 1
	var upgrade_cost := _get_upgrade_cost(next_value)
	upgrade_button.text = "UPGRADES"
	upgrade_cost_label.text = "Next x%d  |  %s coins" % [next_value, _format_number(upgrade_cost)]
	_set_upgrade_progress(click_progress_bar, upgrade_cost)
	_set_upgrade_button_state(upgrade_purchase_button, "BUY CLICK POWER x%d" % next_value, coins < upgrade_cost, upgrade_cost)
	_update_bonus_upgrade_ui()


func _update_bonus_upgrade_ui() -> void:
	bonus_chance_label.text = "%.1f%%" % _get_bonus_chance_percent()
	if bonus_chance_level >= MAX_BONUS_CHANCE_LEVEL:
		bonus_chance_cost_label.text = "Maximum bonus chance reached"
		_set_upgrade_progress(bonus_chance_progress_bar, 1, true)
		_set_upgrade_button_state(bonus_chance_button, "Max chance 20%", true)
	else:
		var chance_cost: int = _get_bonus_chance_cost()
		var next_chance := _get_bonus_chance_percent(bonus_chance_level + 1)
		bonus_chance_cost_label.text = "Next %.1f%%  |  %s coins" % [next_chance, _format_number(chance_cost)]
		_set_upgrade_progress(bonus_chance_progress_bar, chance_cost)
		_set_upgrade_button_state(bonus_chance_button, "BOOST LUCK TO %.1f%%" % next_chance, coins < chance_cost, chance_cost)

	bonus_value_label.text = "x%d" % _get_bonus_multiplier()
	if bonus_value_index >= BONUS_MULTIPLIERS.size() - 1:
		bonus_value_cost_label.text = "Maximum bonus power reached"
		_set_upgrade_progress(bonus_value_progress_bar, 1, true)
		_set_upgrade_button_state(bonus_value_button, "Max bonus x%d" % _get_bonus_multiplier(), true)
	else:
		var next_bonus: int = int(BONUS_MULTIPLIERS[bonus_value_index + 1])
		var value_cost: int = _get_bonus_value_cost()
		bonus_value_cost_label.text = "Next x%d  |  %s coins" % [next_bonus, _format_number(value_cost)]
		_set_upgrade_progress(bonus_value_progress_bar, value_cost)
		_set_upgrade_button_state(bonus_value_button, "AMPLIFY BONUS TO x%d" % next_bonus, coins < value_cost, value_cost)

	bonus_streak_label.text = "x%d" % bonus_streak_multiplier
	if bonus_streak_multiplier >= MAX_BONUS_STREAK_MULTIPLIER:
		bonus_streak_cost_label.text = "Maximum streak boost reached"
		_set_upgrade_progress(bonus_streak_progress_bar, 1, true)
		_set_upgrade_button_state(bonus_streak_button, "Max streak x%d" % MAX_BONUS_STREAK_MULTIPLIER, true)
	else:
		var streak_cost: int = _get_bonus_streak_cost()
		var next_streak := bonus_streak_multiplier + 1
		bonus_streak_cost_label.text = "Next x%d  |  %s coins" % [next_streak, _format_number(streak_cost)]
		_set_upgrade_progress(bonus_streak_progress_bar, streak_cost)
		_set_upgrade_button_state(bonus_streak_button, "POWER STREAK TO x%d" % next_streak, coins < streak_cost, streak_cost)

	passive_gain_label.text = "%d/min" % passive_clicks_per_minute
	settings_passive_gain_label.text = "Offline gain: %d/min" % passive_clicks_per_minute
	if passive_clicks_per_minute >= MAX_PASSIVE_CLICKS_PER_MINUTE:
		passive_gain_cost_label.text = "Maximum offline income reached"
		_set_upgrade_progress(passive_gain_progress_bar, 1, true)
		_set_upgrade_button_state(passive_gain_button, "Max offline %d/min" % MAX_PASSIVE_CLICKS_PER_MINUTE, true)
		settings_passive_gain_cost_label.text = "Max offline gain reached"
		_set_upgrade_button_state(settings_passive_gain_button, "Max offline %d/min" % MAX_PASSIVE_CLICKS_PER_MINUTE, true)
	else:
		var passive_cost: int = _get_passive_upgrade_cost()
		var next_passive := passive_clicks_per_minute + 1
		passive_gain_cost_label.text = "Next %d/min  |  %s coins" % [next_passive, _format_number(passive_cost)]
		_set_upgrade_progress(passive_gain_progress_bar, passive_cost)
		_set_upgrade_button_state(passive_gain_button, "GROW INCOME TO %d/MIN" % next_passive, coins < passive_cost, passive_cost)
		settings_passive_gain_cost_label.text = "Next: %d/min for %s coins" % [passive_clicks_per_minute + 1, _format_number(passive_cost)]
		_set_upgrade_button_state(settings_passive_gain_button, "Upgrade offline", coins < passive_cost, passive_cost)
	_update_upgrade_alert()


func _set_upgrade_button_state(button: Button, ready_text: String, disabled: bool, cost: int = -1) -> void:
	button.disabled = disabled
	if disabled and cost > 0 and coins < cost:
		button.text = "Need %s more" % _format_number(cost - coins)
		return

	button.text = ready_text


func _has_affordable_upgrade() -> bool:
	if unlocked_click_value < MAX_CLICK_VALUE and coins >= _get_upgrade_cost(unlocked_click_value + 1):
		return true
	if bonus_chance_level < MAX_BONUS_CHANCE_LEVEL and coins >= _get_bonus_chance_cost():
		return true
	if bonus_value_index < BONUS_MULTIPLIERS.size() - 1 and coins >= _get_bonus_value_cost():
		return true
	if bonus_streak_multiplier < MAX_BONUS_STREAK_MULTIPLIER and coins >= _get_bonus_streak_cost():
		return true
	if passive_clicks_per_minute < MAX_PASSIVE_CLICKS_PER_MINUTE and coins >= _get_passive_upgrade_cost():
		return true
	return false


func _update_upgrade_alert() -> void:
	var affordable := _has_affordable_upgrade()
	if affordable == upgrade_alert_active:
		return

	upgrade_alert_active = affordable
	upgrade_alert_elapsed = 0.0
	upgrade_alert_badge.visible = affordable
	if affordable:
		upgrade_alert_badge.pivot_offset = upgrade_alert_badge.size * 0.5
		upgrade_alert_badge.scale = Vector2.ZERO
		var badge_tween := create_tween()
		badge_tween.tween_property(upgrade_alert_badge, "scale", Vector2(1.18, 1.18), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		badge_tween.tween_property(upgrade_alert_badge, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		if not menu_overlay.visible:
			_shake_upgrade_button()


func _set_upgrade_progress(progress_bar: ProgressBar, cost: int, maxed: bool = false) -> void:
	progress_bar.max_value = 100.0
	var target_value := 100.0 if maxed else clampf((float(coins) / maxf(float(cost), 1.0)) * 100.0, 0.0, 100.0)
	var old_tween: Tween
	if progress_bar.has_meta("value_tween"):
		old_tween = progress_bar.get_meta("value_tween") as Tween
	if old_tween != null and old_tween.is_valid():
		old_tween.kill()
	var value_tween := create_tween()
	value_tween.tween_property(progress_bar, "value", target_value, 0.28).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	progress_bar.set_meta("value_tween", value_tween)

	var was_ready := false
	if progress_bar.has_meta("was_ready"):
		was_ready = bool(progress_bar.get_meta("was_ready"))
	var is_ready := target_value >= 100.0
	if is_ready and not was_ready and upgrades_panel.visible:
		_pop_control(progress_bar, Vector2(1.0, 1.45), 0.24)
	progress_bar.set_meta("was_ready", is_ready)
	progress_bar.tooltip_text = "Complete" if maxed else "%s / %s coins" % [_format_number(coins), _format_number(cost)]


# STATS, REWARDS, AND ACHIEVEMENTS


func _update_volume_ui() -> void:
	click_volume_slider.value = round(click_volume * 100.0)
	ui_volume_slider.value = round(ui_volume * 100.0)
	click_volume_label.text = "Click sound: %d%%" % int(click_volume_slider.value)
	ui_volume_label.text = "UI sound: %d%%" % int(ui_volume_slider.value)


func _update_achievements_ui() -> void:
	var achievements := _get_achievements()
	var unlocked_count: int = 0
	var lines: Array[String] = []
	for achievement in achievements:
		var unlocked: bool = bool(achievement["unlocked"])
		if unlocked:
			unlocked_count += 1

		var marker := "X" if unlocked else " "
		lines.append("[%s] %s" % [marker, achievement["text"]])

	var percent: int = int(round((float(unlocked_count) / float(achievements.size())) * 100.0))
	achievements_button.text = "Achievements %d%%" % percent
	achievements_list_label.text = "\n".join(lines)


func _update_stats_ui() -> void:
	var bonus_rate := 0.0
	if total_taps > 0:
		bonus_rate = (float(total_bonus_clicks) / float(total_taps)) * 100.0

	var sections := [
		{
			"title": "OVERVIEW",
			"color": Color(0.42, 0.86, 1.0, 1.0),
			"entries": [
				["TOTAL TAPS", _format_number(total_taps)],
				["TOTAL SCORE", _format_number(score)],
				["COINS SAVED", _format_number(coins)],
				["BEST CLICK", _format_number(best_single_click)],
				["COMBO", "x%.1f" % _get_combo_multiplier()],
				["DAILY STREAK", str(daily_reward_streak)],
			],
		},
		{
			"title": "POWER",
			"color": Color(1.0, 0.66, 0.2, 1.0),
			"entries": [
				["CLICK VALUE", "x%d / x%d" % [click_value, unlocked_click_value]],
				["BONUS CHANCE", "%.1f%%" % _get_bonus_chance_percent()],
				["BONUS VALUE", "x%d" % _get_bonus_multiplier()],
				["STREAK BOOST", "x%d" % bonus_streak_multiplier],
				["OFFLINE GAIN", "%d/min" % passive_clicks_per_minute],
				["OFFLINE CAP", "%dh" % int(OFFLINE_GAIN_MAX_SECONDS / 3600)],
			],
		},
		{
			"title": "ACTIVITY",
			"color": Color(0.62, 0.48, 1.0, 1.0),
			"entries": [
				["BONUS CLICKS", _format_number(total_bonus_clicks)],
				["BONUS RATE", "%.1f%%" % bonus_rate],
				["STREAK ACTIVATIONS", _format_number(bonus_streak_activations)],
				["RECENT BONUSES", "%d / 5" % _get_recent_bonus_count()],
			],
		},
	]
	_rebuild_stats_cards(sections)


func _update_daily_reward_ui() -> void:
	var reward := _get_daily_reward_amount(_get_next_daily_reward_streak())
	var available := _can_claim_daily_reward()
	daily_reward_label.text = "Daily reward streak: %d" % daily_reward_streak
	daily_reward_alert_label.hide()
	if available:
		menu_button.modulate = Color(1.0, 0.82, 0.22, 1.0)
		daily_reward_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.22, 1.0))
		daily_reward_button.disabled = false
		daily_reward_button.text = "Claim %s coins" % _format_number(reward)
		daily_reward_timer_label.text = "Available now"
		daily_reward_timer_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.22, 1.0))
	else:
		menu_button.modulate = Color.WHITE
		daily_reward_label.add_theme_color_override("font_color", Color.WHITE)
		daily_reward_button.disabled = true
		daily_reward_button.text = "Claimed today"
		daily_reward_timer_label.text = "Next reward in %s" % _format_time_until_next_day()
		daily_reward_timer_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.68, 1.0))


func _show_startup_popups() -> void:
	_show_offline_gain_message()


func _can_claim_daily_reward() -> bool:
	return _get_current_day_number() > last_daily_reward_day


func _get_next_daily_reward_streak() -> int:
	var today := _get_current_day_number()
	if last_daily_reward_day == today - 1:
		return daily_reward_streak + 1

	return 1


func _get_daily_reward_amount(streak: int = -1) -> int:
	if streak < 0:
		streak = daily_reward_streak

	return DAILY_REWARD_BASE_COINS + (streak * DAILY_REWARD_STREAK_BONUS) + (click_value * 10) + (passive_clicks_per_minute * 5)


func _format_time_until_next_day() -> String:
	var seconds_per_day := 86400
	var now := _get_unix_time()
	var seconds_left := seconds_per_day - (now % seconds_per_day)
	var hours := int(seconds_left / 3600)
	var minutes := int((seconds_left % 3600) / 60)
	var seconds := int(seconds_left % 60)
	return "%02d:%02d:%02d" % [hours, minutes, seconds]


func _claim_daily_reward() -> void:
	if not _can_claim_daily_reward():
		return

	var today := _get_current_day_number()
	if last_daily_reward_day == today - 1:
		daily_reward_streak += 1
	else:
		daily_reward_streak = 1

	last_daily_reward_day = today
	var reward := _get_daily_reward_amount()
	_gain_coins(reward, daily_reward_button.get_global_rect().get_center())
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_daily_reward_ui()
	_spawn_click_popup(reward, 1)
	_play_bonus_sound()
	_save_game()


func _get_achievements() -> Array[Dictionary]:
	return [
		{"text": "First click", "unlocked": score >= 1},
		{"text": "100 clicks", "unlocked": score >= 100},
		{"text": "500 clicks", "unlocked": score >= 500},
		{"text": "1,000 clicks", "unlocked": score >= 1000},
		{"text": "5,000 clicks", "unlocked": score >= 5000},
		{"text": "10,000 clicks", "unlocked": score >= 10000},
		{"text": "50,000 clicks", "unlocked": score >= 50000},
		{"text": "100,000 clicks", "unlocked": score >= 100000},
		{"text": "500,000 clicks", "unlocked": score >= 500000},
		{"text": "1,000,000 clicks", "unlocked": score >= 1000000},
		{"text": "10,000 coins saved", "unlocked": coins >= 10000},
		{"text": "100,000 coins saved", "unlocked": coins >= 100000},
		{"text": "1,000,000 coins saved", "unlocked": coins >= 1000000},
		{"text": "Click value x5", "unlocked": unlocked_click_value >= 5},
		{"text": "Click value x10", "unlocked": unlocked_click_value >= 10},
		{"text": "Click value x15", "unlocked": unlocked_click_value >= 15},
		{"text": "Click value x20", "unlocked": unlocked_click_value >= 20},
		{"text": "Bonus chance 1%", "unlocked": bonus_chance_level >= 10},
		{"text": "Bonus chance 5%", "unlocked": bonus_chance_level >= 50},
		{"text": "Bonus chance 10%", "unlocked": bonus_chance_level >= 100},
		{"text": "Bonus chance 20%", "unlocked": bonus_chance_level >= 200},
		{"text": "Bonus value x5", "unlocked": _get_bonus_multiplier() >= 5},
		{"text": "Bonus value x25", "unlocked": _get_bonus_multiplier() >= 25},
		{"text": "Bonus value x100", "unlocked": _get_bonus_multiplier() >= 100},
		{"text": "Bonus streak x5", "unlocked": bonus_streak_multiplier >= 5},
		{"text": "Bonus streak x10", "unlocked": bonus_streak_multiplier >= 10},
		{"text": "10 streak activations", "unlocked": bonus_streak_activations >= 10},
		{"text": "Offline gain 5/min", "unlocked": passive_clicks_per_minute >= 5},
		{"text": "Offline gain 10/min", "unlocked": passive_clicks_per_minute >= 10},
		{"text": "Offline gain 20/min", "unlocked": passive_clicks_per_minute >= 20},
		{"text": "Offline gain 30/min", "unlocked": passive_clicks_per_minute >= 30},
	]


# SETTINGS


func _on_click_power_changed(value: float) -> void:
	click_value = clampi(int(value), 1, unlocked_click_value)
	click_power_label.text = "Use click value: x%d" % click_value
	click_value_label.text = "Click value: x%d / unlocked x%d" % [click_value, unlocked_click_value]
	_queue_save()


func _on_click_volume_changed(value: float) -> void:
	click_volume = clamp(value / 100.0, 0.0, 1.0)
	click_volume_label.text = "Click sound: %d%%" % int(value)
	_apply_volume()
	_queue_save()


func _on_ui_volume_changed(value: float) -> void:
	ui_volume = clamp(value / 100.0, 0.0, 1.0)
	ui_volume_label.text = "UI sound: %d%%" % int(value)
	_apply_volume()
	_play_ui_sound()
	_queue_save()


func _apply_volume() -> void:
	cat_click_sound.volume_db = _linear_volume_to_db(click_volume)
	cat_meow_sound.volume_db = _linear_volume_to_db(click_volume)
	bonus_sound.volume_db = _linear_volume_to_db(click_volume)
	special_milestone_sound.volume_db = _linear_volume_to_db(click_volume)
	ui_sound.volume_db = _linear_volume_to_db(ui_volume)


func _linear_volume_to_db(volume: float) -> float:
	if volume <= 0.0:
		return -80.0

	return linear_to_db(volume)


# UPGRADE RULES AND PURCHASES


func _get_upgrade_cost(next_value: int) -> int:
	if next_value <= 10:
		return next_value * next_value * 25

	var cost := _get_upgrade_cost(10)
	for value in range(11, next_value + 1):
		cost *= 2

	return cost


func _get_bonus_chance_percent(level: int = -1) -> float:
	if level < 0:
		level = bonus_chance_level

	return float(level) * 0.1


func _get_bonus_multiplier() -> int:
	return int(BONUS_MULTIPLIERS[bonus_value_index])


func _get_bonus_chance_cost() -> int:
	return 50 + (bonus_chance_level * 25)


func _get_bonus_value_cost() -> int:
	var next_index: int = bonus_value_index + 1
	return int(BONUS_VALUE_COSTS[next_index - 1])


func _get_bonus_streak_cost() -> int:
	var next_multiplier := bonus_streak_multiplier + 1
	return BASE_BONUS_STREAK_COST * next_multiplier * next_multiplier


func _get_passive_upgrade_cost() -> int:
	return BASE_PASSIVE_UPGRADE_COST * int(pow(2.0, float(passive_clicks_per_minute - 1)))


func _roll_bonus_multiplier() -> int:
	if randf() > _get_bonus_chance_percent() / 100.0:
		return 1

	return _get_bonus_multiplier()


func _record_bonus_click(was_bonus: bool) -> void:
	recent_bonus_clicks.append(was_bonus)
	while recent_bonus_clicks.size() > 5:
		recent_bonus_clicks.pop_front()


func _get_recent_bonus_count() -> int:
	var count := 0
	for was_bonus in recent_bonus_clicks:
		if was_bonus:
			count += 1

	return count


func _upgrade_click_value() -> void:
	if unlocked_click_value >= MAX_CLICK_VALUE:
		return

	var next_value := unlocked_click_value + 1
	var upgrade_cost := _get_upgrade_cost(next_value)
	if coins < upgrade_cost:
		return

	coins -= upgrade_cost
	unlocked_click_value = next_value
	click_value = next_value
	_update_score()
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_celebrate_upgrade(click_upgrade_card, CLICK_UPGRADE_COLOR)
	_play_ui_sound()
	_save_game()


func _upgrade_passive_gain() -> void:
	if passive_clicks_per_minute >= MAX_PASSIVE_CLICKS_PER_MINUTE:
		return

	var cost: int = _get_passive_upgrade_cost()
	if coins < cost:
		return

	coins -= cost
	passive_clicks_per_minute += 1
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_celebrate_upgrade(passive_gain_card, PASSIVE_UPGRADE_COLOR)
	_play_ui_sound()
	_save_game()


func _upgrade_bonus_chance() -> void:
	if bonus_chance_level >= MAX_BONUS_CHANCE_LEVEL:
		return

	var cost: int = _get_bonus_chance_cost()
	if coins < cost:
		return

	coins -= cost
	bonus_chance_level += 1
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_celebrate_upgrade(bonus_chance_card, CHANCE_UPGRADE_COLOR)
	_play_ui_sound()
	_save_game()


func _upgrade_bonus_value() -> void:
	if bonus_value_index >= BONUS_MULTIPLIERS.size() - 1:
		return

	var cost: int = _get_bonus_value_cost()
	if coins < cost:
		return

	coins -= cost
	bonus_value_index += 1
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_celebrate_upgrade(bonus_value_card, VALUE_UPGRADE_COLOR)
	_play_ui_sound()
	_save_game()


func _upgrade_bonus_streak() -> void:
	if bonus_streak_multiplier >= MAX_BONUS_STREAK_MULTIPLIER:
		return

	var cost: int = _get_bonus_streak_cost()
	if coins < cost:
		return

	coins -= cost
	bonus_streak_multiplier += 1
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_celebrate_upgrade(bonus_streak_card, STREAK_UPGRADE_COLOR)
	_play_ui_sound()
	_save_game()


# AUDIO


func _play_cat_sound() -> void:
	cat_click_sound.stop()
	cat_click_sound.play()


func _play_bonus_sound() -> void:
	bonus_sound.stop()
	bonus_sound.play()


func _play_milestone_sound_if_needed(previous_score: int) -> void:
	var meow_interval: int = _get_scaled_meow_interval(score)
	var special_interval: int = meow_interval * 10
	var previous_special: int = floori(float(previous_score) / float(special_interval))
	var current_special: int = floori(float(score) / float(special_interval))
	if previous_special < current_special:
		special_milestone_sound.stop()
		special_milestone_sound.play()
		return

	var previous_meow: int = floori(float(previous_score) / float(meow_interval))
	var current_meow: int = floori(float(score) / float(meow_interval))
	if previous_meow >= current_meow:
		return

	cat_meow_sound.stop()
	cat_meow_sound.play()


func _get_scaled_meow_interval(current_score: int) -> int:
	var interval: int = BASE_MEOW_CLICK_INTERVAL
	var threshold: int = MILESTONE_SCALE_START
	while current_score >= threshold:
		interval *= 10
		threshold *= 10

	return interval


func _play_ui_sound() -> void:
	ui_sound.stop()
	ui_sound.play()
