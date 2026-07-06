extends RefCounted
class_name ClickLogic

var game


func _init(game_ref) -> void:
	game = game_ref


func on_cat_pressed() -> void:
	if game.menu_overlay.visible:
		return

	var previous_score: int = game.score
	var bonus_hit := perform_tap(false)
	for _ghost_index in range(game.boost_logic.get_extra_ghost_taps()):
		bonus_hit = perform_tap(true) or bonus_hit

	game._update_upgrade_alert()
	game._queue_achievement_refresh()
	game._queue_save()
	game._release_cat_pop(bonus_hit)
	game._pulse_label(game.score_label, bonus_hit)
	game._pulse_label(game.coins_label, false)
	game._play_tap_haptic(bonus_hit)
	game._play_cat_sound()
	if bonus_hit:
		game._play_bonus_sound()
	play_milestone_sound_if_needed(previous_score)


func perform_tap(is_ghost: bool) -> bool:
	if not is_ghost:
		increase_combo()
	var base_combo_multiplier: float = 1.0 + game.combo_bonus
	var combo_multiplier: float = get_combo_multiplier()
	var unboosted_click_amount: int = maxi(1, roundi(float(game.click_value) * base_combo_multiplier))
	unboosted_click_amount = game._apply_skin_gain_bonus(unboosted_click_amount, "click")
	var click_amount: int = maxi(1, roundi(float(game.click_value) * combo_multiplier))
	click_amount = game._apply_skin_gain_bonus(click_amount, "click")
	click_amount = maxi(1, roundi(float(click_amount) * game.boost_logic.get_tap_multiplier()))
	click_amount += game.boost_logic.get_flat_tap_bonus()
	var bonus_multiplier: int = game._roll_bonus_multiplier()
	var unboosted_bonus_multiplier: int = bonus_multiplier
	bonus_multiplier = game.boost_logic.transform_bonus_multiplier(bonus_multiplier)
	var bonus_hit = bonus_multiplier > 1
	var streak_multiplier = 1
	var unboosted_streak_multiplier := 1
	record_bonus_click(bonus_hit)
	if bonus_hit and get_recent_bonus_count() >= 2:
		unboosted_streak_multiplier = game.bonus_streak_multiplier + game._get_streak_bonus()
		streak_multiplier = unboosted_streak_multiplier
		streak_multiplier = maxi(1, roundi(float(streak_multiplier) * game.boost_logic.get_streak_multiplier()))
		bonus_multiplier *= streak_multiplier
		game.bonus_streak_activations += 1

	if bonus_hit:
		unboosted_click_amount *= unboosted_bonus_multiplier * unboosted_streak_multiplier
		click_amount *= bonus_multiplier
		click_amount = maxi(1, roundi(float(click_amount) * game.boost_logic.get_bonus_payout_multiplier()))
	click_amount = game.boost_logic.cap_boosted_click(click_amount, unboosted_click_amount)
	if is_ghost:
		click_amount = maxi(1, roundi(float(click_amount) * 0.5))

	game.total_taps += 1
	if bonus_hit:
		game.total_bonus_clicks += 1
	game.best_single_click = maxi(game.best_single_click, click_amount)
	var cat_rect: Rect2 = game.cat_button.get_global_rect()
	var kibble_origin := Vector2(cat_rect.get_center().x, cat_rect.end.y)
	game._gain_coins(click_amount, kibble_origin)
	game._spawn_click_popup(click_amount, bonus_multiplier, streak_multiplier, game.combo_bonus)
	game._spawn_tap_burst(bonus_hit)
	if not is_ghost:
		game.boost_logic.consume_protected_tap()
	return bonus_hit


func on_cat_gui_input(event: InputEvent) -> void:
	if game.menu_overlay.visible:
		return

	var pressed = false
	var local_position = Vector2.ZERO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		local_position = event.position
	elif event is InputEventScreenTouch:
		pressed = event.pressed
		local_position = event.position
	else:
		return

	if pressed:
		game.last_cat_press_global_position = game.cat_button.global_position + local_position
		game._press_cat_down(local_position)


func increase_combo() -> void:
	game.combo_clicks_toward_step += 1
	var gained_step = false
	var taps_per_step: int = game.boost_logic.get_combo_taps_per_step()
	if game.combo_clicks_toward_step >= taps_per_step:
		game.combo_clicks_toward_step = 0
		game.combo_bonus = minf(game.get_effective_combo_cap(), game.combo_bonus + game.boost_logic.get_combo_step())
		gained_step = true

	game.combo_drain_elapsed = 0.0
	game.combo_grace_left = game.COMBO_DRAIN_GRACE_SECONDS
	game.combo_timer.start(game.COMBO_DRAIN_GRACE_SECONDS + game.COMBO_RESET_SECONDS)
	update_combo_ui(gained_step)


func reset_combo() -> void:
	game.combo_bonus = 0.0
	game.combo_drain_elapsed = 0.0
	game.combo_grace_left = 0.0
	game.combo_clicks_toward_step = 0
	update_combo_ui()


func get_combo_multiplier() -> float:
	return 1.0 + (game.combo_bonus * game.boost_logic.get_combo_power_multiplier())


func update_combo_ui(animated: bool = false) -> void:
	var taps_per_step: int = game.boost_logic.get_combo_taps_per_step()
	game.combo_label.text = "COMBO x%.1f" % get_combo_multiplier()
	game.combo_progress_bar.max_value = taps_per_step
	game.combo_progress_bar.value = game.combo_clicks_toward_step
	game.combo_label.hide()
	game.combo_progress_bar.hide()
	game.combo_timer_label.hide()
	if game.combo_timer != null and not game.combo_timer.is_stopped():
		var shown_time = minf(game.COMBO_RESET_SECONDS, game.combo_timer.time_left)
		var state := "FLOW" if game.combo_grace_left > 0.0 else "DECAY"
		game.combo_timer_label.text = "%s %.1fs  |  %d/%d" % [state, shown_time, game.combo_clicks_toward_step, taps_per_step]
	else:
		game.combo_timer_label.text = "READY  |  0/%d" % taps_per_step
	var heat = clampf(game.combo_bonus / game.get_effective_combo_cap(), 0.0, 1.0)
	var combo_color = Color(lerpf(0.8, 1.0, heat), lerpf(0.88, 0.82, heat), lerpf(1.0, 0.1, heat), 1.0)
	game.combo_label.add_theme_color_override("font_color", combo_color)
	game.combo_timer_label.add_theme_color_override("font_color", combo_color.darkened(0.15))
	game.combo_progress_bar.modulate = combo_color


func record_bonus_click(was_bonus: bool) -> void:
	game.recent_bonus_clicks.append(was_bonus)
	while game.recent_bonus_clicks.size() > 5:
		game.recent_bonus_clicks.pop_front()


func get_recent_bonus_count() -> int:
	var count = 0
	for was_bonus in game.recent_bonus_clicks:
		if was_bonus:
			count += 1
	return count


func play_milestone_sound_if_needed(previous_score: int) -> void:
	var meow_interval: int = get_scaled_meow_interval(game.score)
	var special_interval: int = meow_interval * 10
	var previous_special: int = floori(float(previous_score) / float(special_interval))
	var current_special: int = floori(float(game.score) / float(special_interval))
	if previous_special < current_special:
		game.special_milestone_sound.stop()
		game.special_milestone_sound.play()
		return

	var previous_meow: int = floori(float(previous_score) / float(meow_interval))
	var current_meow: int = floori(float(game.score) / float(meow_interval))
	if previous_meow >= current_meow:
		return

	game.cat_meow_sound.stop()
	game.cat_meow_sound.play()


func get_scaled_meow_interval(current_score: int) -> int:
	var interval: int = game.BASE_MEOW_CLICK_INTERVAL
	var threshold: int = game.MILESTONE_SCALE_START
	while current_score >= threshold:
		interval *= 10
		threshold *= 10
	return interval
