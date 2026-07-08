extends RefCounted
class_name UiLogic

const KIBBLE_PARTICLE_TEXTURE := preload("res://assets/kibble.svg")

var game
var last_bowl_impact_msec := 0


func _init(game_ref) -> void:
	game = game_ref


func update_score() -> void:
	game.score_label.text = game._format_number(game.score)


func update_coins(animated: bool = true) -> void:
	if game.displayed_coins < 0:
		game.displayed_coins = game.coins
		set_coin_display(game.displayed_coins)
		return

	if not animated:
		if game.coin_counter_tween != null and game.coin_counter_tween.is_valid():
			game.coin_counter_tween.kill()
		game.displayed_coins = game.coins
		set_coin_display(game.displayed_coins)
		return

	animate_coin_counter(game.displayed_coins, game.coins)


func set_coin_display(value: float) -> void:
	game.displayed_coins = roundi(value)
	var formatted = game._format_number(game.displayed_coins)
	game.coins_label.text = formatted
	game.coins_label.tooltip_text = formatted
	game.call_deferred("_animate_hud_coin_text")
	game.menu_wallet_coins_label.text = "%s KIBBLES" % formatted
	game.menu_coins_label.text = formatted
	game.upgrade_coins_label.text = formatted
	if is_instance_valid(game.skins_wallet_label):
		game.skins_wallet_label.text = "%s KIBBLES" % formatted
	if is_instance_valid(game.boost_wallet_label):
		game.boost_wallet_label.text = "%s KIBBLES" % formatted
	if is_instance_valid(game.food_wallet_label):
		game.food_wallet_label.text = "%s KIBBLES" % formatted
		game._update_food_ui()
	if game.crate_logic != null:
		game.crate_logic.update_wallet()


func animate_coin_counter(from_value: int, to_value: int, duration: float = 0.32) -> void:
	if game.coin_counter_tween != null and game.coin_counter_tween.is_valid():
		game.coin_counter_tween.kill()
	game.coin_counter_tween = game.create_tween()
	game.coin_counter_tween.tween_method(game._set_coin_display, float(from_value), float(to_value), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func gain_coins(amount: int, origin_global: Vector2) -> void:
	if amount <= 0:
		return
	var added_score: int = game._add_score(amount)
	var added_coins: int = game._add_coins(amount)
	update_score()
	update_coins(true)
	spawn_coin_stream(mini(added_score, added_coins), origin_global)


func spawn_coin_stream(amount: int, origin_global: Vector2) -> void:
	if amount <= 0 or not game.is_inside_tree():
		return

	var particle_count := mini(game.MAX_COIN_PARTICLES, maxi(1, ceili(sqrt(float(amount)))))
	var layer_inverse: Transform2D = game.click_popup_layer.get_global_transform().affine_inverse()
	var destination: Vector2 = layer_inverse * game.hud_coin_icon.get_global_rect().get_center()
	var start: Vector2 = layer_inverse * origin_global
	for index in range(particle_count):
		var particle = TextureRect.new()
		particle.texture = KIBBLE_PARTICLE_TEXTURE
		particle.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		particle.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		particle.custom_minimum_size = Vector2(32.0, 32.0)
		particle.size = Vector2(32.0, 32.0)
		particle.pivot_offset = particle.size * 0.5
		particle.position = start - particle.pivot_offset + Vector2(randf_range(-12.0, 12.0), randf_range(-10.0, 10.0))
		particle.scale = Vector2(0.58, 0.58)
		particle.rotation = randf_range(-0.4, 0.4)
		particle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		particle.z_index = 60
		game.click_popup_layer.add_child(particle)

		var delay = float(index) * 0.018
		var midpoint = (particle.position + destination) * 0.5 + Vector2(randf_range(-55.0, 55.0), randf_range(-120.0, -65.0))
		var flight = game.create_tween()
		flight.tween_interval(delay)
		flight.tween_property(particle, "scale", Vector2(1.08, 1.08), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		flight.parallel().tween_property(particle, "position", midpoint, 0.28).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		flight.parallel().tween_property(particle, "rotation", particle.rotation + randf_range(1.2, 2.8), 0.28)
		flight.tween_property(particle, "position", destination - particle.pivot_offset, 0.34).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		flight.parallel().tween_property(particle, "scale", Vector2(0.72, 0.72), 0.34)
		flight.parallel().tween_property(particle, "modulate", Color(1.0, 0.95, 0.88, 0.82), 0.34)
		flight.tween_callback(game._coin_particle_arrived.bind(particle))


func coin_particle_arrived(particle: TextureRect) -> void:
	if is_instance_valid(particle):
		particle.queue_free()
	animate_hud_coin()
	animate_hud_wallet()
	var now := Time.get_ticks_msec()
	if now - last_bowl_impact_msec >= 45:
		last_bowl_impact_msec = now
		spawn_bowl_impact()


func spawn_bowl_impact() -> void:
	if not game.is_inside_tree():
		return
	var center: Vector2 = game.hud_coin_icon.get_global_rect().get_center() - game.click_popup_layer.global_position

	var ring := Panel.new()
	ring.size = Vector2(24.0, 24.0)
	ring.pivot_offset = ring.size * 0.5
	ring.position = center - ring.pivot_offset
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ring.z_index = 59
	ring.add_theme_stylebox_override(
		"panel",
		game._make_upgrade_style(Color.TRANSPARENT, Color(1.0, 0.82, 0.3, 0.9), 12, 2)
	)
	game.click_popup_layer.add_child(ring)
	var ring_tween: Tween = game.create_tween().set_parallel(true)
	ring_tween.tween_property(ring, "scale", Vector2(3.0, 3.0), 0.28).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	ring_tween.tween_property(ring, "modulate:a", 0.0, 0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	ring_tween.chain().tween_callback(Callable(ring, "queue_free"))

	for index in range(5):
		var spark := ColorRect.new()
		var spark_size := randf_range(4.0, 7.0)
		spark.size = Vector2(spark_size, spark_size)
		spark.pivot_offset = spark.size * 0.5
		spark.position = center - spark.pivot_offset
		spark.rotation = randf_range(-PI, PI)
		spark.color = [
			Color(1.0, 0.88, 0.36, 1.0),
			Color(1.0, 0.62, 0.22, 1.0),
			Color(0.52, 0.88, 1.0, 1.0),
		][index % 3]
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		spark.z_index = 61
		game.click_popup_layer.add_child(spark)
		var angle := (TAU / 5.0) * float(index) + randf_range(-0.25, 0.25)
		var destination := spark.position + Vector2(cos(angle), sin(angle)) * randf_range(24.0, 46.0)
		var spark_tween: Tween = game.create_tween().set_parallel(true)
		spark_tween.tween_property(spark, "position", destination, 0.32).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		spark_tween.tween_property(spark, "scale", Vector2.ZERO, 0.32).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		spark_tween.tween_property(spark, "rotation", spark.rotation + randf_range(-2.0, 2.0), 0.32)
		spark_tween.tween_property(spark, "modulate:a", 0.0, 0.32).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		spark_tween.chain().tween_callback(Callable(spark, "queue_free"))


func animate_hud_wallet() -> void:
	if game.hud_wallet_tween != null and game.hud_wallet_tween.is_valid():
		game.hud_wallet_tween.kill()
	game.hud_wallet.pivot_offset = game.hud_wallet.size * 0.5
	game.hud_wallet.scale = Vector2.ONE
	game.hud_wallet.modulate = Color.WHITE
	game.hud_wallet_tween = game.create_tween().set_parallel(true)
	game.hud_wallet_tween.tween_property(game.hud_wallet, "scale", Vector2(1.035, 1.035), 0.09).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	game.hud_wallet_tween.tween_property(game.hud_wallet, "modulate", Color(1.0, 0.9, 0.68, 1.0), 0.09).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	game.hud_wallet_tween.chain().tween_property(game.hud_wallet, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	game.hud_wallet_tween.parallel().tween_property(game.hud_wallet, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func animate_hud_coin() -> void:
	if not game.is_inside_tree():
		return
	if game.hud_icon_idle_tween != null and game.hud_icon_idle_tween.is_valid():
		game.hud_icon_idle_tween.kill()
	if game.hud_coin_tween != null and game.hud_coin_tween.is_valid():
		game.hud_coin_tween.kill()
	game.hud_coin_icon.pivot_offset = game.hud_coin_icon.size * 0.5
	game.hud_coin_icon.scale = Vector2.ONE
	game.hud_coin_icon.rotation = 0.0
	game.hud_coin_icon.modulate = Color(1.0, 0.97, 0.9, 1.0)
	game.hud_coin_tween = game.create_tween()
	game.hud_coin_tween.set_parallel(true)
	game.hud_coin_tween.tween_property(game.hud_coin_icon, "scale", Vector2(1.2, 1.2), 0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	game.hud_coin_tween.parallel().tween_property(game.hud_coin_icon, "rotation", 0.1, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	game.hud_coin_tween.parallel().tween_property(game.hud_coin_icon, "modulate", Color(1.0, 0.9, 0.72, 1.0), 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	game.hud_coin_tween.chain().tween_property(game.hud_coin_icon, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	game.hud_coin_tween.parallel().tween_property(game.hud_coin_icon, "rotation", 0.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	game.hud_coin_tween.parallel().tween_property(game.hud_coin_icon, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	game.hud_coin_tween.chain().tween_callback(start_hud_icon_idle_effect)


func start_hud_icon_idle_effect() -> void:
	if not game.is_inside_tree():
		return
	if game.hud_icon_idle_tween != null and game.hud_icon_idle_tween.is_valid():
		game.hud_icon_idle_tween.kill()
	game.hud_coin_icon.pivot_offset = game.hud_coin_icon.size * 0.5
	game.hud_coin_icon.modulate = Color.WHITE
	game.hud_icon_idle_tween = game.create_tween().set_loops()
	game.hud_icon_idle_tween.tween_property(game.hud_coin_icon, "scale", Vector2(1.04, 1.04), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	game.hud_icon_idle_tween.parallel().tween_property(game.hud_coin_icon, "rotation", 0.03, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	game.hud_icon_idle_tween.parallel().tween_property(game.hud_coin_icon, "modulate", Color(1.0, 0.97, 0.93, 1.0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	game.hud_icon_idle_tween.tween_property(game.hud_coin_icon, "scale", Vector2.ONE, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	game.hud_icon_idle_tween.parallel().tween_property(game.hud_coin_icon, "rotation", -0.03, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	game.hud_icon_idle_tween.parallel().tween_property(game.hud_coin_icon, "modulate", Color.WHITE, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func update_volume_ui() -> void:
	game.click_power_slider.value = game.click_value
	game.click_volume_slider.value = round(game.click_volume * 100.0)
	game.ui_volume_slider.value = round(game.ui_volume * 100.0)
	game.click_volume_label.text = "Click sound: %d%%" % int(game.click_volume_slider.value)
	game.ui_volume_label.text = "UI sound: %d%%" % int(game.ui_volume_slider.value)


func update_stats_ui() -> void:
	var bonus_rate = 0.0
	if game.total_taps > 0:
		bonus_rate = (float(game.total_bonus_clicks) / float(game.total_taps)) * 100.0

	var sections = [
		{
			"title": "OVERVIEW",
			"color": Color(0.42, 0.86, 1.0, 1.0),
			"entries": [
				["TOTAL TAPS", game._format_number(game.total_taps)],
				["TOTAL SCORE", game._format_number(game.score)],
				["KIBBLES SAVED", game._format_number(game.coins)],
				["BEST CLICK", game._format_number(game.best_single_click)],
				["COMBO", "x%.1f" % game._get_combo_multiplier()],
				["DAILY STREAK", str(game.daily_reward_streak)],
			],
		},
		{
			"title": "POWER",
			"color": Color(1.0, 0.66, 0.2, 1.0),
			"entries": [
				["CLICK VALUE", "x%d / x%d" % [game.click_value, game.unlocked_click_value]],
				["BONUS CHANCE", "%.1f%%" % game._get_bonus_chance_percent()],
				["BONUS VALUE", "x%d" % game._get_bonus_multiplier()],
				["STREAK BOOST", "x%d" % (game.bonus_streak_multiplier + game._get_streak_bonus())],
				["OFFLINE GAIN", "%d/min" % game._get_effective_passive_gain()],
				["OFFLINE CAP", "%dh" % int(game.get_offline_gain_max_seconds() / 3600)],
			],
		},
		{
			"title": "SKIN",
			"color": Color(0.32, 0.78, 0.92, 1.0),
			"entries": [
				["EQUIPPED", game._get_equipped_skin_name()],
				["POWER", game._get_skin_bonus_text(game._get_skin_data(game.equipped_skin_id))],
			],
		},
		{
			"title": "ACTIVITY",
			"color": Color(0.62, 0.48, 1.0, 1.0),
			"entries": [
				["BONUS CLICKS", game._format_number(game.total_bonus_clicks)],
				["BONUS RATE", "%.1f%%" % bonus_rate],
				["STREAK ACTIVATIONS", game._format_number(game.bonus_streak_activations)],
				["RECENT BONUSES", "%d / 5" % game._get_recent_bonus_count()],
			],
		},
	]
	if game.crate_logic != null:
		sections.append({
			"title": "GEM VAULT",
			"color": Color(0.3, 0.88, 0.98, 1.0),
			"entries": [
				["GEMS FOUND", "%d / %d" % [game.crate_logic.get_discovered_count(), game.SKIN_DATA.size()]],
				["GEM LEVELS", str(game.crate_logic.get_total_gem_levels())],
				["COLLECTION POWER", "+%.1f%%" % ((game.crate_logic.get_global_multiplier() - 1.0) * 100.0)],
				["CRATES OPENED", game._format_number(game.crate_logic.total_crates_opened)],
			],
		})
	rebuild_stats_cards(sections)


func rebuild_stats_cards(sections: Array) -> void:
	for child in game.stats_cards.get_children():
		game.stats_cards.remove_child(child)
		child.queue_free()
	game.stats_card_controls.clear()

	for section in sections:
		var section_box = VBoxContainer.new()
		section_box.add_theme_constant_override("separation", 7)
		section_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		game.stats_cards.add_child(section_box)

		var accent: Color = section["color"]
		var heading = Label.new()
		heading.text = str(section["title"])
		heading.add_theme_font_size_override("font_size", 17)
		heading.add_theme_color_override("font_color", accent.lightened(0.15))
		section_box.add_child(heading)

		var grid = GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 10)
		grid.add_theme_constant_override("v_separation", 10)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		section_box.add_child(grid)

		for entry in section["entries"]:
			var card = PanelContainer.new()
			card.custom_minimum_size = Vector2(245.0, 86.0)
			card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			card.add_theme_stylebox_override("panel", game._make_upgrade_card_style(accent, false))
			grid.add_child(card)
			game.stats_card_controls.append(card)

			var margin = MarginContainer.new()
			margin.add_theme_constant_override("margin_left", 13)
			margin.add_theme_constant_override("margin_top", 10)
			margin.add_theme_constant_override("margin_right", 13)
			margin.add_theme_constant_override("margin_bottom", 10)
			card.add_child(margin)

			var content = VBoxContainer.new()
			content.add_theme_constant_override("separation", 2)
			margin.add_child(content)

			var value_label = Label.new()
			value_label.text = str(entry[1])
			value_label.add_theme_font_size_override("font_size", 23)
			value_label.add_theme_color_override("font_color", accent.lightened(0.25))
			value_label.clip_text = true
			content.add_child(value_label)

			var name_label = Label.new()
			name_label.text = str(entry[0])
			name_label.add_theme_font_size_override("font_size", 12)
			name_label.add_theme_color_override("font_color", Color(0.62, 0.68, 0.78, 1.0))
			content.add_child(name_label)
