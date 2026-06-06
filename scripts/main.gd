extends "res://scripts/main/main_presentation.gd"


# APPLICATION FLOW AND INPUT


# STARTUP AND LIFECYCLE


func _ready() -> void:
	get_tree().auto_accept_quit = false
	randomize()
	_load_game()
	get_viewport().size_changed.connect(_apply_mobile_layout)

	cat_base_scale = cat_button.scale
	cat_button.resized.connect(_update_cat_pivot)
	call_deferred("_update_cat_pivot")

	save_timer.timeout.connect(_save_game)

	daily_reward_timer.timeout.connect(_update_daily_reward_ui)
	daily_reward_timer.start()

	combo_timer.timeout.connect(_reset_combo)

	_setup_main_ui_visuals()
	_setup_pause_menu_visuals()
	_setup_settings_stats_visuals()
	_setup_upgrade_visuals()
	_setup_upgrade_info_popups()
	_update_score()
	_update_coins(false)
	_update_combo_ui()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_update_volume_ui()
	_apply_volume()
	call_deferred("_show_startup_popups")
	last_cat_press_global_position = cat_button.get_global_rect().get_center()
	cat_button.button_down.connect(_on_cat_pressed)
	menu_button.pressed.connect(_show_menu)
	upgrade_button.pressed.connect(_show_upgrades)
	settings_button.pressed.connect(_show_settings)
	open_upgrades_button.pressed.connect(_show_upgrades)
	settings_back_button.pressed.connect(_show_menu)
	upgrade_purchase_button.pressed.connect(_upgrade_click_value)
	bonus_chance_button.pressed.connect(_upgrade_bonus_chance)
	bonus_value_button.pressed.connect(_upgrade_bonus_value)
	bonus_streak_button.pressed.connect(_upgrade_bonus_streak)
	passive_gain_button.pressed.connect(_upgrade_passive_gain)
	settings_passive_gain_button.pressed.connect(_upgrade_passive_gain)
	upgrades_back_button.pressed.connect(_hide_menu)
	stats_button.pressed.connect(_show_stats)
	stats_back_button.pressed.connect(_show_menu)
	daily_reward_button.pressed.connect(_claim_daily_reward)
	click_power_slider.value_changed.connect(_on_click_power_changed)
	click_volume_slider.value_changed.connect(_on_click_volume_changed)
	ui_volume_slider.value_changed.connect(_on_ui_volume_changed)
	resume_button.pressed.connect(_hide_menu)
	exit_button.pressed.connect(_exit_game)
	_setup_ui_animations(self)
	_hide_removed_ui()
	_prepare_mobile_panels()
	_apply_mobile_layout()
	menu_overlay.hide()


func _process(delta: float) -> void:
	if upgrade_alert_active and not menu_overlay.visible:
		upgrade_alert_elapsed += delta
		if upgrade_alert_elapsed >= UPGRADE_ALERT_SHAKE_INTERVAL:
			upgrade_alert_elapsed = 0.0
			_shake_upgrade_button()

	if combo_timer != null and not combo_timer.is_stopped():
		if combo_grace_left > 0.0:
			combo_grace_left = maxf(0.0, combo_grace_left - delta)
			_update_combo_ui()
			return

		combo_drain_elapsed += delta
		while combo_drain_elapsed >= COMBO_DRAIN_INTERVAL and combo_bonus > 0.0:
			combo_drain_elapsed -= COMBO_DRAIN_INTERVAL
			combo_bonus = maxf(0.0, combo_bonus - COMBO_STEP)
		_update_combo_ui()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			_exit_game()
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_FOCUS_OUT:
			_save_game()


# MAIN CLICK INPUT


func _on_cat_pressed() -> void:
	if menu_overlay.visible:
		return

	var previous_score: int = score
	_increase_combo()
	var combo_multiplier := _get_combo_multiplier()
	var click_amount: int = maxi(1, roundi(float(click_value) * combo_multiplier))
	var bonus_multiplier: int = _roll_bonus_multiplier()
	var bonus_hit := bonus_multiplier > 1
	var streak_multiplier := 1
	_record_bonus_click(bonus_hit)
	if bonus_hit and _get_recent_bonus_count() >= 2:
		streak_multiplier = bonus_streak_multiplier
		bonus_multiplier *= streak_multiplier
		bonus_streak_activations += 1

	if bonus_hit:
		click_amount *= bonus_multiplier

	total_taps += 1
	if bonus_hit:
		total_bonus_clicks += 1
	best_single_click = maxi(best_single_click, click_amount)
	_gain_coins(click_amount, hint_label.get_global_rect().get_center())
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	_release_cat_pop(bonus_hit)
	_pulse_label(score_label, bonus_hit)
	_pulse_label(coins_label, false)
	_spawn_click_popup(click_amount, bonus_multiplier, streak_multiplier, combo_bonus)
	_spawn_tap_burst(bonus_hit)
	_play_cat_sound()
	if bonus_hit:
		_play_bonus_sound()
	_play_milestone_sound_if_needed(previous_score)


func _on_cat_gui_input(event: InputEvent) -> void:
	if menu_overlay.visible:
		return

	var pressed := false
	var local_position := Vector2.ZERO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		local_position = event.position
	elif event is InputEventScreenTouch:
		pressed = event.pressed
		local_position = event.position
	else:
		return

	if pressed:
		last_cat_press_global_position = cat_button.global_position + local_position
		_press_cat_down(local_position)


# MENU NAVIGATION


func _show_menu() -> void:
	_play_ui_sound()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(menu_panel)
	call_deferred("_animate_pause_menu")


func _show_settings() -> void:
	_play_ui_sound()
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(settings_panel)
	call_deferred("_animate_settings_screen")


func _show_upgrades() -> void:
	_play_ui_sound()
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(upgrades_panel)
	call_deferred("_animate_upgrade_screen")


func _show_achievements() -> void:
	_play_ui_sound()
	_update_achievements_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(achievements_panel)


func _show_stats() -> void:
	_play_ui_sound()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(stats_panel)
	call_deferred("_animate_stats_screen")


func _show_overlay_panel(panel: Control) -> void:
	upgrade_alert_elapsed = 0.0
	if panel != upgrades_panel:
		_stop_upgrade_ambient_animation()
	menu_panel.hide()
	settings_panel.hide()
	upgrades_panel.hide()
	achievements_panel.hide()
	stats_panel.hide()
	panel.show()
	panel.modulate.a = 0.0
	panel.scale = Vector2(0.94, 0.94)
	panel.pivot_offset = panel.size * 0.5
	menu_overlay.show()
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _hide_menu() -> void:
	_play_ui_sound()
	_stop_upgrade_ambient_animation()
	menu_overlay.hide()
	upgrade_alert_elapsed = 0.0


func _exit_game() -> void:
	_play_ui_sound()
	_save_game()
	get_tree().quit()
