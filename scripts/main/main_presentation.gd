extends "res://scripts/main/main_gameplay.gd"


const INFO_POPUP_SCENE := preload("res://scenes/ui/info_popup.tscn")
const OFFLINE_GAIN_POPUP_SCENE := preload("res://scenes/ui/offline_gain_popup.tscn")
const STATS_SECTION_SCENE := preload("res://scenes/ui/stats_section.tscn")


# VISUAL SETUP, EFFECTS, ANIMATION, AND RESPONSIVE LAYOUT


# COIN FEEDBACK


func _animate_coin_counter(from_value: int, to_value: int, duration: float = 0.32) -> void:
	if coin_counter_tween != null and coin_counter_tween.is_valid():
		coin_counter_tween.kill()
	coin_counter_tween = create_tween()
	coin_counter_tween.tween_method(_set_coin_display, float(from_value), float(to_value), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _spawn_coin_stream(amount: int, origin_global: Vector2) -> void:
	if amount <= 0 or not is_inside_tree():
		return

	var particle_count := mini(amount, MAX_COIN_PARTICLES)
	var destination := hud_coin_icon.get_global_rect().get_center() - click_popup_layer.global_position
	var start := origin_global - click_popup_layer.global_position
	for index in range(particle_count):
		var particle := TextureRect.new()
		particle.texture = hud_coin_icon.texture
		particle.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		particle.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		particle.custom_minimum_size = Vector2(14.0, 14.0)
		particle.size = Vector2(14.0, 14.0)
		particle.pivot_offset = particle.size * 0.5
		particle.position = start - particle.pivot_offset + Vector2(randf_range(-12.0, 12.0), randf_range(-10.0, 10.0))
		particle.scale = Vector2(0.45, 0.45)
		particle.rotation = randf_range(-0.4, 0.4)
		particle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		particle.z_index = 60
		click_popup_layer.add_child(particle)

		var delay := float(index) * 0.018
		var midpoint := (particle.position + destination) * 0.5 + Vector2(randf_range(-55.0, 55.0), randf_range(-120.0, -65.0))
		var flight := create_tween()
		flight.tween_interval(delay)
		flight.tween_property(particle, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		flight.parallel().tween_property(particle, "position", midpoint, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		flight.parallel().tween_property(particle, "rotation", particle.rotation + randf_range(1.2, 2.8), 0.28)
		flight.tween_property(particle, "position", destination - particle.pivot_offset, 0.34).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		flight.parallel().tween_property(particle, "scale", Vector2(0.55, 0.55), 0.34)
		flight.parallel().tween_property(particle, "modulate", Color(1.0, 0.9, 0.45, 0.75), 0.34)
		flight.tween_callback(_coin_particle_arrived.bind(particle))


func _coin_particle_arrived(particle: TextureRect) -> void:
	if is_instance_valid(particle):
		particle.queue_free()
	_animate_hud_coin()


func _animate_hud_coin() -> void:
	if not is_inside_tree():
		return
	if hud_coin_tween != null and hud_coin_tween.is_valid():
		hud_coin_tween.kill()
	hud_coin_icon.pivot_offset = hud_coin_icon.size * 0.5
	hud_coin_icon.scale = Vector2.ONE
	hud_coin_icon.rotation = 0.0
	hud_coin_tween = create_tween()
	hud_coin_tween.set_parallel(true)
	hud_coin_tween.tween_property(hud_coin_icon, "scale", Vector2(1.18, 1.18), 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	hud_coin_tween.tween_property(hud_coin_icon, "rotation", 0.12, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	hud_coin_tween.chain().tween_property(hud_coin_icon, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	hud_coin_tween.parallel().tween_property(hud_coin_icon, "rotation", 0.0, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _shake_upgrade_button() -> void:
	if menu_overlay.visible or not upgrade_alert_active:
		return
	if upgrade_alert_shake_tween != null and upgrade_alert_shake_tween.is_valid():
		upgrade_alert_shake_tween.kill()

	upgrade_button.pivot_offset = upgrade_button.size * 0.5
	upgrade_button.rotation = 0.0
	upgrade_alert_shake_tween = create_tween()
	for angle in [0.055, -0.065, 0.05, -0.04, 0.025, 0.0]:
		upgrade_alert_shake_tween.tween_property(upgrade_button, "rotation", angle, 0.055).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


# THEME SETUP


func _setup_main_ui_visuals() -> void:
	hud_wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.075, 0.06, 0.025, 0.96), Color(1.0, 0.72, 0.18, 0.82), 18, 2, -1, 10)
	)
	coins_label.add_theme_color_override("font_shadow_color", Color(0.2, 0.08, 0.0, 0.8))
	coins_label.add_theme_constant_override("shadow_offset_x", 2)
	coins_label.add_theme_constant_override("shadow_offset_y", 2)
	_style_upgrade_button(upgrade_button, CHANCE_UPGRADE_COLOR)
	upgrade_button.add_theme_color_override("font_color", Color(1.0, 0.94, 0.72, 1.0))
	upgrade_button.add_theme_color_override("icon_normal_color", Color.WHITE)
	upgrade_button.add_theme_color_override("icon_hover_color", Color(1.0, 0.94, 0.65, 1.0))
	upgrade_alert_badge.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(1.0, 1.0, 1.0, 1.0), Color(0.92, 0.05, 0.1, 1.0), 23, 4, -1, 8)
	)


func _setup_pause_menu_visuals() -> void:
	menu_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.32, 0.5, 1.0), 24, 2, -1, 18)
	)
	menu_header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.055, 0.085, 0.14, 1.0), Color(0.3, 0.7, 1.0, 0.7), 18, 2, 5, 8)
	)
	menu_wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.14, 0.105, 0.035, 0.92), Color(1.0, 0.72, 0.16, 0.75), 14, 1, -1, 5)
	)
	daily_reward_card.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.105, 0.08, 0.035, 0.95), Color(1.0, 0.66, 0.18, 0.58), 16, 1, 4, 6)
	)
	_style_upgrade_button(daily_reward_button, CHANCE_UPGRADE_COLOR)
	_style_upgrade_button(settings_button, CLICK_UPGRADE_COLOR)
	_style_upgrade_button(stats_button, Color(0.56, 0.48, 1.0, 1.0))
	_style_upgrade_button(resume_button, PASSIVE_UPGRADE_COLOR)
	_style_upgrade_button(exit_button, VALUE_UPGRADE_COLOR)


func _setup_settings_stats_visuals() -> void:
	settings_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.32, 0.5, 1.0), 24, 2, -1, 18)
	)
	settings_header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.055, 0.085, 0.14, 1.0), Color(0.3, 0.7, 1.0, 0.7), 18, 2, 5, 8)
	)
	settings_wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.14, 0.105, 0.035, 0.92), Color(1.0, 0.72, 0.16, 0.75), 14, 1, -1, 5)
	)
	click_settings_card.add_theme_stylebox_override("panel", _make_upgrade_card_style(CLICK_UPGRADE_COLOR, false))
	audio_settings_card.add_theme_stylebox_override("panel", _make_upgrade_card_style(Color(0.62, 0.48, 1.0, 1.0), false))
	offline_settings_card.add_theme_stylebox_override("panel", _make_upgrade_card_style(PASSIVE_UPGRADE_COLOR, false))
	_style_settings_slider(click_power_slider, CLICK_UPGRADE_COLOR)
	_style_settings_slider(click_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	_style_settings_slider(ui_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	_style_upgrade_button(settings_passive_gain_button, PASSIVE_UPGRADE_COLOR)
	_style_upgrade_button(open_upgrades_button, CHANCE_UPGRADE_COLOR)
	_style_upgrade_button(settings_back_button, Color(0.42, 0.5, 0.66, 1.0))

	stats_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.32, 0.26, 0.58, 1.0), 24, 2, -1, 18)
	)
	stats_header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.075, 0.06, 0.14, 1.0), Color(0.62, 0.48, 1.0, 0.72), 18, 2, 5, 8)
	)
	_style_upgrade_button(stats_back_button, Color(0.5, 0.42, 0.78, 1.0))


func _style_settings_slider(slider: HSlider, accent: Color) -> void:
	slider.add_theme_stylebox_override(
		"slider",
		_make_upgrade_style(Color(0.025, 0.03, 0.045, 1.0), Color(0.14, 0.16, 0.22, 1.0), 6, 1)
	)
	slider.add_theme_stylebox_override(
		"grabber_area",
		_make_upgrade_style(accent.darkened(0.18), accent.lightened(0.12), 6, 1)
	)
	slider.add_theme_stylebox_override(
		"grabber_area_highlight",
		_make_upgrade_style(accent, Color.WHITE, 6, 1)
	)


func _setup_upgrade_visuals() -> void:
	upgrades_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.25, 0.36, 1.0), 24, 2, 2, 18)
	)
	upgrade_hero.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.065, 0.09, 0.14, 1.0), Color(0.25, 0.7, 1.0, 0.72), 20, 2, 2, 10)
	)
	wallet_chip.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.14, 0.105, 0.035, 0.92), Color(1.0, 0.72, 0.16, 0.78), 14, 1, -1, 6)
	)

	var card_data := [
		[click_upgrade_card, upgrade_purchase_button, click_progress_bar, upgrade_info_button, CLICK_UPGRADE_COLOR],
		[bonus_chance_card, bonus_chance_button, bonus_chance_progress_bar, bonus_chance_info_button, CHANCE_UPGRADE_COLOR],
		[bonus_value_card, bonus_value_button, bonus_value_progress_bar, bonus_value_info_button, VALUE_UPGRADE_COLOR],
		[bonus_streak_card, bonus_streak_button, bonus_streak_progress_bar, bonus_streak_info_button, STREAK_UPGRADE_COLOR],
		[passive_gain_card, passive_gain_button, passive_gain_progress_bar, passive_gain_info_button, PASSIVE_UPGRADE_COLOR],
	]
	for data in card_data:
		var card := data[0] as PanelContainer
		var button := data[1] as Button
		var progress_bar := data[2] as ProgressBar
		var info_button := data[3] as Button
		var accent := data[4] as Color
		card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
		card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, accent, true))
		card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, accent, false))
		_style_upgrade_button(button, accent)
		_style_info_button(info_button, accent)
		_style_upgrade_progress(progress_bar, accent)

		var badge := card.get_node("CardMargin/CardItems/Header/Badge") as Label
		badge.add_theme_color_override("font_color", accent.lightened(0.18))
		badge.add_theme_stylebox_override(
			"normal",
			_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.14), Color(accent.r, accent.g, accent.b, 0.55), 8, 1)
		)

	_style_upgrade_button(upgrades_back_button, Color(0.42, 0.5, 0.66, 1.0))


func _make_upgrade_style(
	background: Color,
	border: Color,
	radius: int,
	border_width: int = 1,
	left_border_width: int = -1,
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(border_width)
	if left_border_width >= 0:
		style.border_width_left = left_border_width
	style.set_corner_radius_all(radius)
	if shadow_size > 0:
		style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
		style.shadow_size = shadow_size
		style.shadow_offset = Vector2(0.0, 5.0)
	return style


func _make_upgrade_card_style(accent: Color, hovered: bool) -> StyleBoxFlat:
	var background := Color(0.075, 0.085, 0.12, 0.99)
	if hovered:
		background = Color(0.095, 0.11, 0.16, 1.0)
	var border := Color(accent.r, accent.g, accent.b, 0.82 if hovered else 0.42)
	return _make_upgrade_style(background, border, 16, 1, 5, 8 if hovered else 4)


func _set_upgrade_card_hover(card: PanelContainer, accent: Color, hovered: bool) -> void:
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, hovered))


func _style_upgrade_button(button: Button, accent: Color) -> void:
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_color_override("font_color", Color(0.98, 0.99, 1.0, 1.0))
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color(0.48, 0.52, 0.61, 1.0))
	button.add_theme_color_override("icon_disabled_color", Color(0.68, 0.58, 0.32, 0.72))
	button.add_theme_stylebox_override(
		"normal",
		_make_upgrade_style(accent.darkened(0.48), Color(accent.r, accent.g, accent.b, 0.72), 12, 2)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_upgrade_style(accent.darkened(0.28), accent.lightened(0.12), 12, 2, -1, 8)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_upgrade_style(accent.darkened(0.12), Color.WHITE, 12, 2)
	)
	button.add_theme_stylebox_override(
		"disabled",
		_make_upgrade_style(Color(0.09, 0.1, 0.13, 0.9), Color(0.22, 0.24, 0.3, 1.0), 12, 1)
	)


func _style_info_button(button: Button, accent: Color) -> void:
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_stylebox_override(
		"normal",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.08), Color(accent.r, accent.g, accent.b, 0.45), 17, 1)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.28), accent, 17, 1)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.42), Color.WHITE, 17, 1)
	)


func _style_upgrade_progress(progress_bar: ProgressBar, accent: Color) -> void:
	progress_bar.add_theme_stylebox_override(
		"background",
		_make_upgrade_style(Color(0.025, 0.03, 0.045, 1.0), Color(0.14, 0.16, 0.22, 1.0), 5, 1)
	)
	progress_bar.add_theme_stylebox_override(
		"fill",
		_make_upgrade_style(accent.darkened(0.12), accent.lightened(0.18), 5, 1)
	)


# EDITOR-BACKED POPUPS AND STATS


func _setup_upgrade_info_popups() -> void:
	upgrade_info_button.pressed.connect(func() -> void:
		_show_info_popup("Click power", "Raises the value of every normal tap. Buying a level also equips the newly unlocked click value.", CLICK_UPGRADE_COLOR)
	)
	bonus_chance_info_button.pressed.connect(func() -> void:
		_show_info_popup("Bonus chance", "Raises the chance that any tap becomes a bonus hit. Each level adds 0.1 percentage points.", CHANCE_UPGRADE_COLOR)
	)
	bonus_value_info_button.pressed.connect(func() -> void:
		_show_info_popup("Bonus power", "Makes every bonus hit multiply your tap by more. Later levels jump dramatically in power.", VALUE_UPGRADE_COLOR)
	)
	bonus_streak_info_button.pressed.connect(func() -> void:
		_show_info_popup("Streak boost", "When at least 2 of your last 5 taps are bonuses, the next bonus receives this extra multiplier.", STREAK_UPGRADE_COLOR)
	)
	passive_gain_info_button.pressed.connect(func() -> void:
		_show_info_popup("Offline income", "Earns coins while the game is closed. Offline time is counted for up to 3 hours.", PASSIVE_UPGRADE_COLOR)
	)


func _show_info_popup(title: String, description: String, accent: Color = CLICK_UPGRADE_COLOR) -> void:
	var popup := INFO_POPUP_SCENE.instantiate() as InfoPopup
	click_popup_layer.add_child(popup)
	popup.open(title, description, accent, size.x)


func _rebuild_stats_cards(sections: Array) -> void:
	for child in stats_cards.get_children():
		child.queue_free()
	stats_card_controls.clear()

	for section_data in sections:
		var accent: Color = section_data["color"]
		var section := STATS_SECTION_SCENE.instantiate() as StatsSection
		stats_cards.add_child(section)
		section.setup(str(section_data["title"]), accent)

		for entry in section_data["entries"]:
			var card := section.add_entry(str(entry[0]), str(entry[1]), accent)
			stats_card_controls.append(card)


# CAT AND CONTROL FEEDBACK


func _update_cat_pivot() -> void:
	cat_button.pivot_offset = cat_button.size * 0.5


func _press_cat_down(local_position: Vector2) -> void:
	if cat_tween != null and cat_tween.is_valid():
		cat_tween.kill()

	var center_offset := (local_position - cat_button.size * 0.5) / maxf(cat_button.size.x, 1.0)
	cat_tween = create_tween()
	cat_tween.set_parallel(true)
	cat_tween.tween_property(cat_button, "scale", cat_base_scale * CAT_PRESS_SCALE, 0.035).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	cat_tween.tween_property(cat_button, "rotation", clampf(center_offset.x, -0.5, 0.5) * 0.08, 0.035).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _release_cat_pop(is_bonus: bool = false) -> void:
	if cat_tween != null and cat_tween.is_valid():
		cat_tween.kill()

	cat_tween = create_tween()
	cat_tween.tween_property(cat_button, "scale", cat_base_scale * CAT_POP_SCALE, 0.06).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	cat_tween.tween_property(cat_button, "scale", cat_base_scale, 0.11).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	cat_button.rotation = 0.0


func _pulse_label(label: Label, is_bonus: bool) -> void:
	var tween_ref := score_tween if label == score_label else coins_tween
	if tween_ref != null and tween_ref.is_valid():
		tween_ref.kill()

	label.pivot_offset = label.size * 0.5
	label.scale = Vector2.ONE
	label.modulate = Color.WHITE
	var pulse_tween := create_tween()
	pulse_tween.set_parallel(true)
	var pulse_scale := Vector2(1.16, 1.16) if is_bonus else Vector2(1.08, 1.08)
	var pulse_color := Color(1.0, 0.32, 0.32, 1.0) if is_bonus else Color(1.0, 0.93, 0.58, 1.0)
	pulse_tween.tween_property(label, "scale", pulse_scale, 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	pulse_tween.tween_property(label, "modulate", pulse_color, 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	pulse_tween.chain().tween_property(label, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pulse_tween.parallel().tween_property(label, "modulate", Color.WHITE, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	if label == score_label:
		score_tween = pulse_tween
	else:
		coins_tween = pulse_tween


func _setup_ui_animations(node: Node) -> void:
	for child in node.get_children():
		_setup_ui_animations(child)

	if node is Button:
		var button := node as Button
		button.pivot_offset = button.size * 0.5
		button.mouse_entered.connect(func() -> void:
			_tween_control_scale(button, Vector2(1.035, 1.035), 0.09)
		)
		button.mouse_exited.connect(func() -> void:
			_tween_control_scale(button, Vector2.ONE, 0.12)
		)
		button.button_down.connect(func() -> void:
			_tween_control_scale(button, Vector2(0.97, 0.97), 0.045)
		)
		button.button_up.connect(func() -> void:
			_tween_control_scale(button, Vector2(1.035, 1.035), 0.09)
		)
	elif node is TextureButton and node != cat_button:
		var texture_button := node as TextureButton
		texture_button.pivot_offset = texture_button.size * 0.5
		texture_button.mouse_entered.connect(func() -> void:
			_tween_control_scale(texture_button, Vector2(1.045, 1.045), 0.09)
		)
		texture_button.mouse_exited.connect(func() -> void:
			_tween_control_scale(texture_button, Vector2.ONE, 0.12)
		)


func _tween_control_scale(control: Control, target_scale: Vector2, duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(control, "scale", target_scale, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _pop_control(control: Control, target_scale: Vector2, duration: float) -> void:
	control.pivot_offset = control.size * 0.5
	var tween := create_tween()
	tween.tween_property(control, "scale", target_scale, duration * 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(control, "scale", Vector2.ONE, duration * 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _celebrate_upgrade(card: Control, accent: Color) -> void:
	_pop_control(card, Vector2(1.025, 1.025), 0.24)
	card.modulate = accent.lightened(0.45)
	var tween := create_tween()
	tween.tween_property(card, "modulate", Color.WHITE, 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_pulse_label(upgrade_coins_label, false)
	_spawn_upgrade_burst(card, accent)


func _spawn_upgrade_burst(card: Control, accent: Color) -> void:
	var card_rect := card.get_global_rect()
	var center := card_rect.get_center() - click_popup_layer.global_position
	for index in range(14):
		var spark := Panel.new()
		var spark_size := randf_range(5.0, 10.0)
		spark.size = Vector2(spark_size, spark_size)
		spark.pivot_offset = spark.size * 0.5
		spark.position = center - spark.pivot_offset
		spark.rotation = randf_range(-PI, PI)
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		spark.z_index = 50
		var spark_color := accent.lightened(randf_range(0.0, 0.4))
		spark.add_theme_stylebox_override(
			"panel",
			_make_upgrade_style(spark_color, Color.TRANSPARENT, int(spark_size * 0.5), 0)
		)
		click_popup_layer.add_child(spark)

		var angle := (TAU / 14.0) * float(index) + randf_range(-0.16, 0.16)
		var distance := randf_range(70.0, 135.0)
		var destination := spark.position + Vector2(cos(angle), sin(angle)) * distance
		var spark_tween := create_tween()
		spark_tween.set_parallel(true)
		spark_tween.tween_property(spark, "position", destination, 0.48).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		spark_tween.tween_property(spark, "rotation", spark.rotation + randf_range(-2.4, 2.4), 0.48)
		spark_tween.tween_property(spark, "scale", Vector2.ZERO, 0.48).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		spark_tween.tween_property(spark, "modulate:a", 0.0, 0.48).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		spark_tween.chain().tween_callback(Callable(spark, "queue_free"))

	var success_label := Label.new()
	success_label.text = "UPGRADED!"
	success_label.position = center - Vector2(92.0, 30.0)
	success_label.size = Vector2(184.0, 48.0)
	success_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	success_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	success_label.z_index = 51
	success_label.scale = Vector2(0.72, 0.72)
	success_label.pivot_offset = success_label.size * 0.5
	success_label.add_theme_font_size_override("font_size", 24)
	success_label.add_theme_color_override("font_color", accent.lightened(0.25))
	success_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	success_label.add_theme_constant_override("shadow_offset_x", 2)
	success_label.add_theme_constant_override("shadow_offset_y", 2)
	click_popup_layer.add_child(success_label)
	var label_tween := create_tween()
	label_tween.set_parallel(true)
	label_tween.tween_property(success_label, "position:y", success_label.position.y - 74.0, 0.72).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	label_tween.tween_property(success_label, "scale", Vector2(1.05, 1.05), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.tween_property(success_label, "modulate:a", 0.0, 0.72).set_delay(0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	label_tween.chain().tween_callback(Callable(success_label, "queue_free"))


# SCREEN ENTRANCE ANIMATIONS


func _animate_upgrade_screen() -> void:
	if not upgrades_panel.visible:
		return

	var entrance_nodes: Array[Control] = [
		upgrade_hero,
		click_upgrade_card,
		bonus_chance_card,
		bonus_value_card,
		bonus_streak_card,
		passive_gain_card,
		upgrades_back_button,
	]
	for index in range(entrance_nodes.size()):
		var control := entrance_nodes[index]
		control.pivot_offset = control.size * 0.5
		control.scale = Vector2(0.94, 0.94)
		control.modulate = Color(1.0, 1.0, 1.0, 0.0)
		var entrance_tween := create_tween()
		entrance_tween.tween_interval(float(index) * 0.055)
		entrance_tween.tween_property(control, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		entrance_tween.parallel().tween_property(control, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	_start_upgrade_ambient_animation()


func _animate_pause_menu() -> void:
	if not menu_panel.visible:
		return

	var entrance_nodes: Array[Control] = [
		menu_header,
		menu_wallet,
		daily_reward_card,
		settings_button,
		stats_button,
		resume_button,
		exit_button,
	]
	for index in range(entrance_nodes.size()):
		var control := entrance_nodes[index]
		control.pivot_offset = control.size * 0.5
		control.scale = Vector2(0.94, 0.94)
		control.modulate = Color(1.0, 1.0, 1.0, 0.0)
		var entrance_tween := create_tween()
		entrance_tween.tween_interval(float(index) * 0.045)
		entrance_tween.tween_property(control, "modulate:a", 1.0, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		entrance_tween.parallel().tween_property(control, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	menu_coin_icon.pivot_offset = menu_coin_icon.size * 0.5
	var coin_tween := create_tween()
	coin_tween.tween_property(menu_coin_icon, "rotation", TAU, 0.52).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	coin_tween.tween_callback(func() -> void:
		menu_coin_icon.rotation = 0.0
	)


func _animate_settings_screen() -> void:
	if not settings_panel.visible:
		return
	_animate_control_sequence([
		settings_header,
		settings_wallet,
		click_settings_card,
		audio_settings_card,
		offline_settings_card,
		open_upgrades_button,
		settings_back_button,
	])


func _animate_stats_screen() -> void:
	if not stats_panel.visible:
		return
	var controls: Array[Control] = [stats_header]
	controls.append_array(stats_card_controls)
	controls.append(stats_back_button)
	_animate_control_sequence(controls, 0.035)


func _animate_control_sequence(controls: Array[Control], delay_step: float = 0.045) -> void:
	for index in range(controls.size()):
		var control := controls[index]
		if not is_instance_valid(control):
			continue
		control.pivot_offset = control.size * 0.5
		control.scale = Vector2(0.94, 0.94)
		control.modulate = Color(1.0, 1.0, 1.0, 0.0)
		var entrance_tween := create_tween()
		entrance_tween.tween_interval(float(index) * delay_step)
		entrance_tween.tween_property(control, "modulate:a", 1.0, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		entrance_tween.parallel().tween_property(control, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _start_upgrade_ambient_animation() -> void:
	if upgrade_ambient_tween != null and upgrade_ambient_tween.is_valid():
		upgrade_ambient_tween.kill()

	upgrade_wallet_coin_icon.pivot_offset = upgrade_wallet_coin_icon.size * 0.5
	upgrade_wallet_coin_icon.scale = Vector2.ONE
	upgrade_wallet_coin_icon.modulate = Color.WHITE
	upgrade_ambient_tween = create_tween().set_loops()
	upgrade_ambient_tween.tween_property(upgrade_wallet_coin_icon, "scale", Vector2(1.12, 1.12), 0.72).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	upgrade_ambient_tween.parallel().tween_property(upgrade_wallet_coin_icon, "rotation", 0.08, 0.72).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	upgrade_ambient_tween.tween_property(upgrade_wallet_coin_icon, "scale", Vector2.ONE, 0.72).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	upgrade_ambient_tween.parallel().tween_property(upgrade_wallet_coin_icon, "rotation", -0.08, 0.72).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _stop_upgrade_ambient_animation() -> void:
	if upgrade_ambient_tween != null and upgrade_ambient_tween.is_valid():
		upgrade_ambient_tween.kill()
	upgrade_wallet_coin_icon.scale = Vector2.ONE
	upgrade_wallet_coin_icon.rotation = 0.0
	upgrade_wallet_coin_icon.modulate = Color.WHITE


# RESPONSIVE LAYOUT


func _hide_removed_ui() -> void:
	achievements_button.hide()
	achievements_panel.hide()
	achievements_back_button.hide()
	achievements_list_label.hide()


func _prepare_mobile_panels() -> void:
	if mobile_panels_wrapped:
		return

	mobile_panels_wrapped = true
	for panel in [menu_panel, settings_panel, upgrades_panel, achievements_panel, stats_panel]:
		_wrap_panel_content_in_scroll(panel)


func _wrap_panel_content_in_scroll(panel: PanelContainer) -> void:
	if panel.get_child_count() == 0:
		return

	var content := panel.get_child(0)
	if content is ScrollContainer:
		return

	panel.remove_child(content)
	var scroll := ScrollContainer.new()
	scroll.name = "%sScroll" % panel.name
	scroll.horizontal_scroll_mode = 0
	scroll.vertical_scroll_mode = 1
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)
	scroll.add_child(content)
	if content is Control:
		var control := content as Control
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.size_flags_vertical = Control.SIZE_SHRINK_BEGIN


func _apply_mobile_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var panel_width := maxf(320.0, viewport_size.x - 40.0)
	var panel_height := maxf(420.0, viewport_size.y - 120.0)
	_set_responsive_panel_size(menu_panel, Vector2(510.0, 760.0), panel_width, panel_height)
	_set_responsive_panel_size(settings_panel, Vector2(560.0, 920.0), panel_width, panel_height)
	_set_responsive_panel_size(upgrades_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(achievements_panel, Vector2(520.0, 620.0), panel_width, panel_height)
	_set_responsive_panel_size(stats_panel, Vector2(610.0, 900.0), panel_width, panel_height)

	var tap_width := minf(600.0, viewport_size.x - 64.0)
	cat_button.custom_minimum_size = Vector2(maxf(300.0, tap_width), maxf(360.0, tap_width * 1.08))
	menu_button.custom_minimum_size = Vector2(96.0, 96.0)
	upgrade_button.custom_minimum_size = Vector2(330.0, 68.0)


func _set_responsive_panel_size(panel: Control, preferred_size: Vector2, max_width: float, max_height: float) -> void:
	panel.custom_minimum_size = Vector2(minf(preferred_size.x, max_width), minf(preferred_size.y, max_height))


# TRANSIENT CLICK EFFECTS


func _spawn_click_popup(amount: int, bonus_multiplier: int = 1, streak_multiplier: int = 1, current_combo_bonus: float = 0.0) -> void:
	var popup := Label.new()
	popup.text = "+%s" % _format_number(amount)
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.z_index = 20
	var font_size := 42
	if streak_multiplier > 1:
		font_size = 40 + ((streak_multiplier - 1) * 2)
	popup.add_theme_font_size_override("font_size", font_size)
	var popup_color := Color(1.0, 1.0, 1.0, 0.92)
	var shadow_color := Color(1.0, 1.0, 1.0, 0.22)
	var combo_heat := clampf(current_combo_bonus / MAX_COMBO_BONUS, 0.0, 1.0)
	if current_combo_bonus > 0.0:
		popup_color = Color(1.0, lerpf(1.0, 0.86, combo_heat), lerpf(1.0, 0.08, combo_heat), 0.96)
		shadow_color = Color(0.5, 0.28, 0.0, 0.4)
	if bonus_multiplier > 1:
		popup_color = Color(1.0, lerpf(0.28, 0.72, combo_heat), lerpf(0.08, 0.04, combo_heat), 0.96)
		shadow_color = Color(0.55, 0.0, 0.0, 0.45)
	if streak_multiplier > 1:
		var heat := clampf(float(streak_multiplier - MIN_BONUS_STREAK_MULTIPLIER) / float(MAX_BONUS_STREAK_MULTIPLIER - MIN_BONUS_STREAK_MULTIPLIER), 0.0, 1.0)
		popup_color = Color(1.0, lerpf(0.62, 0.08, heat), lerpf(0.08, 0.95, heat), 1.0)
		shadow_color = Color(1.0, 0.0, 0.0, 0.5)

	popup.add_theme_color_override("font_color", popup_color)
	popup.add_theme_color_override("font_shadow_color", shadow_color)
	popup.add_theme_constant_override("shadow_offset_x", 0)
	popup.add_theme_constant_override("shadow_offset_y", 0)
	click_popup_layer.add_child(popup)

	var cat_rect: Rect2 = cat_button.get_global_rect()
	var angle: float = randf_range(-PI, PI)
	var radius: float = minf(cat_rect.size.x, cat_rect.size.y) * randf_range(0.18, 0.35)
	var origin := last_cat_press_global_position
	if not cat_rect.has_point(origin):
		origin = cat_rect.position + cat_rect.size * 0.5

	var popup_global_position: Vector2 = origin + Vector2(cos(angle), sin(angle)) * radius * 0.35
	popup.position = popup_global_position - click_popup_layer.global_position - Vector2(34.0, 24.0)
	var start_scale := 0.78 + (float(streak_multiplier - 1) * 0.025) + combo_heat * 0.06
	popup.scale = Vector2(start_scale, start_scale)

	var drift: Vector2 = Vector2(randf_range(-24.0, 24.0), randf_range(-130.0, -92.0))
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position", popup.position + drift, 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var end_scale := 1.02 + (float(streak_multiplier - 1) * 0.04) + combo_heat * 0.08
	tween.tween_property(popup, "scale", Vector2(end_scale, end_scale), 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 0.0, 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(Callable(popup, "queue_free"))


func _spawn_tap_burst(is_bonus: bool) -> void:
	var cat_rect: Rect2 = cat_button.get_global_rect()
	var origin := last_cat_press_global_position
	if not cat_rect.has_point(origin):
		origin = cat_rect.get_center()

	var particle_count := 10 if is_bonus else 6
	for index in range(particle_count):
		var spark := ColorRect.new()
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		spark.z_index = 19
		var spark_size := randf_range(8.0, 15.0) if is_bonus else randf_range(5.0, 10.0)
		spark.size = Vector2(spark_size, spark_size)
		spark.pivot_offset = spark.size * 0.5
		spark.color = TAP_BURST_COLORS[index % TAP_BURST_COLORS.size()]
		click_popup_layer.add_child(spark)

		var start_position := origin - click_popup_layer.global_position - spark.pivot_offset
		var angle := (TAU / float(particle_count)) * float(index) + randf_range(-0.28, 0.28)
		var distance := randf_range(42.0, 78.0) if is_bonus else randf_range(24.0, 48.0)
		var end_position := start_position + Vector2(cos(angle), sin(angle)) * distance
		spark.position = start_position
		spark.scale = Vector2(0.45, 0.45)

		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(spark, "position", end_position, 0.34).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(spark, "scale", Vector2.ZERO, 0.34).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(spark, "modulate:a", 0.0, 0.34).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.chain().tween_callback(Callable(spark, "queue_free"))


# STARTUP MESSAGE


func _show_offline_gain_message() -> void:
	if last_offline_gain <= 0:
		return

	var cap_text := " (max time reached)" if last_offline_was_capped else ""
	var message := "Welcome back!\nOffline gain: +%s coins\n%d min counted%s" % [
		_format_number(last_offline_gain),
		last_offline_minutes,
		cap_text,
	]

	var popup := OFFLINE_GAIN_POPUP_SCENE.instantiate() as OfflineGainPopup
	click_popup_layer.add_child(popup)
	popup.open(message, size)

	_animate_coin_counter(maxi(0, coins - last_offline_gain), coins, 0.9)
	_spawn_coin_stream(last_offline_gain, popup.get_global_rect().get_center())

