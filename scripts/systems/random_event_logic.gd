extends RefCounted
class_name RandomEventLogic

const FIRST_EVENT_MIN := 12.0
const FIRST_EVENT_MAX := 20.0
const EVENT_DELAY_MIN := 45.0
const EVENT_DELAY_MAX := 85.0

var game
var layer: Control
var banner: PanelContainer
var title_label: Label
var detail_label: Label
var timer_label: Label
var action_button: Button
var event_icon: TextureRect
var progress_bar: ProgressBar
var sparkle_label: Label
var live_badge: Label
var active_boosts_panel: PanelContainer
var active_boosts_list: VBoxContainer
var active_boosts_empty_label: Label
var event_audio: AudioStreamPlayer
var interaction_audio: AudioStreamPlayer
var active_event := ""
var event_time_left := 0.0
var next_event_time := 0.0
var storm_tick := 0.0
var merchant_cost := 0
var interaction_count := 0
var icon_tween: Tween
var sparkle_tween: Tween
var button_tween: Tween
var card_tween: Tween

const EVENT_IMAGES := {
	"golden_mouse": preload("res://assets/events/golden_mouse.png"),
	"kibble_storm": preload("res://assets/events/kibble_storm.png"),
	"sleepy_time": preload("res://assets/events/sleepy_time.png"),
	"merchant": preload("res://assets/events/merchant.png"),
}
const EVENT_SOUNDS := {
	"golden_mouse": preload("res://assets/events/sounds/golden_mouse.wav"),
	"kibble_storm": preload("res://assets/events/sounds/kibble_storm.wav"),
	"sleepy_time": preload("res://assets/events/sounds/sleepy_time.wav"),
	"merchant": preload("res://assets/events/sounds/merchant.wav"),
}
const INTERACTION_SOUNDS := {
	"golden_mouse": preload("res://assets/events/sounds/golden_mouse_tap.wav"),
	"kibble_storm": preload("res://assets/events/sounds/kibble_storm_tap.wav"),
	"sleepy_time": preload("res://assets/events/sounds/sleepy_time_tap.wav"),
	"merchant": preload("res://assets/events/sounds/merchant_tap.wav"),
}

func _init(game_ref) -> void:
	game = game_ref
	next_event_time = randf_range(FIRST_EVENT_MIN, FIRST_EVENT_MAX)

func build_ui() -> void:
	layer = Control.new()
	layer.name = "RandomEventLayer"
	layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.z_index = 4
	game.add_child(layer)
	event_audio = AudioStreamPlayer.new()
	event_audio.name = "EventAudio"
	event_audio.volume_db = -5.0
	layer.add_child(event_audio)
	interaction_audio = AudioStreamPlayer.new()
	interaction_audio.name = "EventInteractionAudio"
	interaction_audio.volume_db = -7.0
	layer.add_child(interaction_audio)
	banner = PanelContainer.new()
	banner.set_anchors_preset(Control.PRESET_CENTER_TOP)
	banner.position = Vector2(-92, 6)
	banner.size = Vector2(184, 160)
	banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(banner)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.075, 0.12, 0.96)
	style.border_color = Color(1.0, 0.72, 0.12, 1.0)
	style.set_border_width_all(3)
	style.set_corner_radius_all(18)
	style.shadow_color = Color(1.0, 0.48, 0.05, 0.55)
	style.shadow_size = 18
	banner.add_theme_stylebox_override("panel", style)
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["margin_left", "margin_right"]:
		margin.add_theme_constant_override(side, 12)
	for side in ["margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(side, 8)
	banner.add_child(margin)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 3)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(column)
	live_badge = Label.new()
	live_badge.text = "✦  LIMITED EVENT  ✦"
	live_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	live_badge.add_theme_font_size_override("font_size", 9)
	live_badge.add_theme_color_override("font_color", Color(1.0, 0.92, 0.58))
	live_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(live_badge)
	event_icon = TextureRect.new()
	event_icon.custom_minimum_size = Vector2(44, 44)
	event_icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	event_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	event_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	event_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(event_icon)
	sparkle_label = Label.new()
	sparkle_label.text = "✦  ✧  ✦"
	sparkle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sparkle_label.add_theme_font_size_override("font_size", 12)
	sparkle_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.25))
	sparkle_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(sparkle_label)
	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(copy)
	title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 15)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.38))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(title_label)
	detail_label = Label.new()
	detail_label.add_theme_font_size_override("font_size", 9)
	detail_label.add_theme_color_override("font_color", Color(0.9, 0.93, 1.0))
	detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(detail_label)
	timer_label = Label.new()
	progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size.y = 6
	progress_bar.show_percentage = false
	progress_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var progress_bg := StyleBoxFlat.new()
	progress_bg.bg_color = Color(0.02, 0.025, 0.06, 0.9)
	progress_bg.set_corner_radius_all(5)
	progress_bar.add_theme_stylebox_override("background", progress_bg)
	var progress_fill := StyleBoxFlat.new()
	progress_fill.bg_color = Color(1.0, 0.58, 0.08)
	progress_fill.set_corner_radius_all(5)
	progress_fill.shadow_color = Color(1.0, 0.7, 0.1, 0.65)
	progress_fill.shadow_size = 5
	progress_bar.add_theme_stylebox_override("fill", progress_fill)
	copy.add_child(progress_bar)
	timer_label.add_theme_font_size_override("font_size", 10)
	timer_label.add_theme_color_override("font_color", Color(0.7, 0.78, 0.9))
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(timer_label)
	action_button = Button.new()
	action_button.custom_minimum_size = Vector2(132, 30)
	action_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	action_button.mouse_filter = Control.MOUSE_FILTER_STOP
	action_button.add_theme_font_size_override("font_size", 10)
	action_button.add_theme_color_override("font_color", Color.WHITE)
	action_button.add_theme_color_override("font_hover_color", Color.WHITE)
	var button_normal := StyleBoxFlat.new()
	button_normal.bg_color = Color(0.96, 0.32, 0.06)
	button_normal.border_color = Color(1.0, 0.82, 0.28)
	button_normal.set_border_width_all(2)
	button_normal.set_corner_radius_all(18)
	button_normal.shadow_color = Color(1.0, 0.55, 0.08, 0.35)
	button_normal.shadow_size = 11
	action_button.add_theme_stylebox_override("normal", button_normal)
	var button_hover := button_normal.duplicate() as StyleBoxFlat
	button_hover.bg_color = Color(1.0, 0.64, 0.12)
	button_hover.shadow_size = 10
	action_button.add_theme_stylebox_override("hover", button_hover)
	var button_pressed := button_normal.duplicate() as StyleBoxFlat
	button_pressed.bg_color = Color(0.72, 0.28, 0.04)
	button_pressed.set_content_margin_all(3)
	action_button.add_theme_stylebox_override("pressed", button_pressed)
	action_button.pressed.connect(_on_action_pressed)
	column.add_child(action_button)
	banner.hide()
	_build_active_boosts_panel()

func process(delta: float) -> void:
	if game.menu_overlay.visible or game.tutorial_active or game.tutorial_prompt_visible:
		_update_active_boosts_panel()
		return
	_update_active_boosts_panel()
	if active_event.is_empty():
		next_event_time -= delta
		if next_event_time <= 0.0:
			_start_random_event()
		return
	event_time_left -= delta
	timer_label.text = "%ds remaining" % ceili(event_time_left)
	progress_bar.value = event_time_left
	if active_event == "merchant":
		action_button.disabled = game.coins < merchant_cost
	if active_event == "kibble_storm":
		storm_tick += delta
		while storm_tick >= 0.55:
			storm_tick -= 0.55
			_storm_payout()
	if event_time_left <= 0.0:
		_end_event()

func get_global_gain_multiplier() -> float:
	return 3.0 if active_event == "sleepy_time" else 1.0

func _start_random_event() -> void:
	active_event = ["golden_mouse", "kibble_storm", "sleepy_time", "merchant"].pick_random()
	event_time_left = {"golden_mouse": 12.0, "kibble_storm": 16.0, "sleepy_time": 20.0, "merchant": 18.0}[active_event]
	progress_bar.max_value = event_time_left
	progress_bar.value = event_time_left
	interaction_count = 0
	event_icon.texture = EVENT_IMAGES[active_event]
	event_audio.stream = EVENT_SOUNDS[active_event]
	interaction_audio.stream = INTERACTION_SOUNDS[active_event]
	event_audio.pitch_scale = 1.0
	event_audio.play()
	storm_tick = 0.0
	action_button.show()
	match active_event:
		"golden_mouse":
			live_badge.text = "✦  LEGENDARY CHASE  ✦"
			live_badge.add_theme_color_override("font_color", Color(1.0, 0.83, 0.22))
			title_label.text = "GOLDEN MOUSE!"
			detail_label.text = "Catch it 3 times. Your tap power sets the prize!"
			action_button.text = "✦  CATCH  •  0/3  ✦"
		"kibble_storm":
			live_badge.text = "◆  BONUS WEATHER  ◆"
			live_badge.add_theme_color_override("font_color", Color(0.35, 0.9, 1.0))
			title_label.text = "KIBBLE STORM"
			detail_label.text = "Tap SCOOP for bonus drops scaled to your clicks."
			action_button.text = "◆  SCOOP KIBBLE  ◆"
		"sleepy_time":
			live_badge.text = "✧  DREAM RUSH  ✧"
			live_badge.add_theme_color_override("font_color", Color(0.78, 0.58, 1.0))
			title_label.text = "SLEEPY TIME  x3"
			detail_label.text = "x3 gains. Pet the moon for a click-scaled bonus."
			action_button.text = "✧  PET THE MOON  ✧"
		"merchant":
			live_badge.text = "★  RARE MERCHANT  ★"
			live_badge.add_theme_color_override("font_color", Color(1.0, 0.55, 0.28))
			merchant_cost = maxi(25, game.click_value * 30)
			title_label.text = "TRAVELING CAT MERCHANT"
			detail_label.text = "Mystery sack: guaranteed double value."
			action_button.text = "★  BUY  •  %s  ★" % game._format_number(merchant_cost)
			action_button.disabled = game.coins < merchant_cost
	timer_label.text = "%ds remaining" % ceili(event_time_left)
	banner.show()
	_update_active_boosts_panel()
	_start_icon_animation()
	_start_sparkle_animation()
	_start_button_animation()
	_start_card_animation()
	banner.modulate = Color(1, 1, 1, 0)
	banner.scale = Vector2(0.92, 0.92)
	banner.pivot_offset = banner.size * 0.5
	var tween: Tween = game.create_tween().set_parallel(true)
	tween.tween_property(banner, "modulate", Color.WHITE, 0.2)
	tween.tween_property(banner, "scale", Vector2.ONE, 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	game._play_bonus_sound()

func _on_action_pressed() -> void:
	_flash_interaction()
	match active_event:
		"golden_mouse":
			interaction_count += 1
			action_button.text = "✦  CATCH  •  %d/3  ✦" % interaction_count
			_bounce_icon()
			if interaction_count >= 3:
				var reward := _click_scaled_reward(90)
				game._gain_coins(reward, action_button.get_global_rect().get_center())
				game._play_bonus_sound()
				_end_event("Mouse caught! +%s kibbles" % game._format_number(reward))
		"kibble_storm":
			interaction_count += 1
			var reward := _click_scaled_reward(3)
			game._gain_coins(reward, action_button.get_global_rect().get_center())
			action_button.text = "◆  SCOOPED  •  %d  ◆" % interaction_count
			_bounce_icon()
		"sleepy_time":
			interaction_count += 1
			var reward := _click_scaled_reward(5)
			game._gain_coins(reward, action_button.get_global_rect().get_center())
			action_button.text = "✧  DREAMS  •  %d  ✧" % interaction_count
			_bounce_icon()
		"merchant":
			if not game._spend_coins(merchant_cost):
				return
			game._gain_coins(merchant_cost * 2, action_button.get_global_rect().get_center())
			game._update_coins()
			game._queue_save()
			game._play_bonus_sound()
			_end_event("A fine bargain! +%s net kibbles" % game._format_number(merchant_cost))

func _storm_payout() -> void:
	var reward := _click_scaled_reward(1)
	var origin := Vector2(randf_range(80.0, game.size.x - 80.0), randf_range(260.0, game.size.y * 0.68))
	game._gain_coins(reward, origin)
	game._spawn_click_popup(reward, 1, 1, 0.0)
	game._queue_save()

func _click_scaled_reward(multiplier: int) -> int:
	# Tap value drives progression; lifetime taps add a gentle mastery bonus.
	var mastery := 1.0 + minf(2.0, sqrt(float(maxi(0, game.total_taps))) / 100.0)
	var active_bonus := 1.0 + minf(1.5, float(interaction_count) * 0.08)
	return maxi(1, roundi((game.click_value + game._get_effective_passive_gain()) * multiplier * mastery * active_bonus))

func _start_icon_animation() -> void:
	if icon_tween != null:
		icon_tween.kill()
	event_icon.rotation = -0.04
	event_icon.pivot_offset = event_icon.size * 0.5
	icon_tween = game.create_tween().set_loops()
	icon_tween.tween_property(event_icon, "rotation", 0.04, 0.65).set_trans(Tween.TRANS_SINE)
	icon_tween.tween_property(event_icon, "rotation", -0.04, 0.65).set_trans(Tween.TRANS_SINE)

func _bounce_icon() -> void:
	var tween: Tween = game.create_tween()
	tween.tween_property(event_icon, "scale", Vector2(1.16, 0.86), 0.08)
	tween.tween_property(event_icon, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK)

func _start_sparkle_animation() -> void:
	if sparkle_tween != null:
		sparkle_tween.kill()
	sparkle_label.modulate = Color(1, 1, 1, 0.35)
	sparkle_label.scale = Vector2(0.85, 0.85)
	sparkle_label.pivot_offset = sparkle_label.size * 0.5
	sparkle_tween = game.create_tween().set_loops()
	sparkle_tween.set_parallel(true)
	sparkle_tween.tween_property(sparkle_label, "modulate", Color.WHITE, 0.7).set_trans(Tween.TRANS_SINE)
	sparkle_tween.tween_property(sparkle_label, "scale", Vector2(1.12, 1.12), 0.7).set_trans(Tween.TRANS_SINE)
	sparkle_tween.chain().set_parallel(true)
	sparkle_tween.tween_property(sparkle_label, "modulate", Color(1, 1, 1, 0.35), 0.7).set_trans(Tween.TRANS_SINE)
	sparkle_tween.tween_property(sparkle_label, "scale", Vector2(0.85, 0.85), 0.7).set_trans(Tween.TRANS_SINE)

func _start_button_animation() -> void:
	if button_tween != null:
		button_tween.kill()
	action_button.pivot_offset = action_button.size * 0.5
	button_tween = game.create_tween().set_loops()
	button_tween.tween_property(action_button, "scale", Vector2(1.075, 1.075), 0.65).set_trans(Tween.TRANS_SINE)
	button_tween.tween_property(action_button, "scale", Vector2.ONE, 0.65).set_trans(Tween.TRANS_SINE)

func _start_card_animation() -> void:
	if card_tween != null:
		card_tween.kill()
	live_badge.modulate = Color(1, 0.65, 0.2, 0.65)
	card_tween = game.create_tween().set_loops()
	card_tween.set_parallel(true)
	card_tween.tween_property(live_badge, "modulate", Color(1, 1, 1, 1), 0.8).set_trans(Tween.TRANS_SINE)
	card_tween.tween_property(title_label, "modulate", Color(1.0, 0.72, 0.22), 0.8).set_trans(Tween.TRANS_SINE)
	card_tween.chain().set_parallel(true)
	card_tween.tween_property(live_badge, "modulate", Color(1, 0.65, 0.2, 0.65), 0.8).set_trans(Tween.TRANS_SINE)
	card_tween.tween_property(title_label, "modulate", Color(1.0, 0.95, 0.62), 0.8).set_trans(Tween.TRANS_SINE)

func _flash_interaction() -> void:
	if interaction_audio.stream != null:
		interaction_audio.pitch_scale = 1.0 + minf(0.08, float(interaction_count) * 0.012)
		interaction_audio.play()
	title_label.modulate = Color(1.0, 1.0, 0.55)
	var tween: Tween = game.create_tween()
	tween.tween_property(title_label, "modulate", Color.WHITE, 0.32)
	var old_text := sparkle_label.text
	sparkle_label.text = "✦ ✦ ✦ ✦ ✦"
	tween.tween_interval(0.22)
	tween.tween_callback(func(): sparkle_label.text = old_text)
	_spawn_confetti_burst()

func _spawn_confetti_burst() -> void:
	var center := action_button.get_global_rect().get_center() - layer.global_position
	var glyphs := ["✦", "★", "◆", "+", "✧"]
	var colors := [Color(1.0, 0.78, 0.1), Color(1.0, 0.3, 0.2), Color(0.35, 0.9, 1.0), Color(0.85, 0.45, 1.0)]
	for index in range(12):
		var particle := Label.new()
		particle.text = glyphs[index % glyphs.size()]
		particle.add_theme_font_size_override("font_size", 16 + index % 3 * 3)
		particle.add_theme_color_override("font_color", colors[index % colors.size()])
		particle.position = center
		particle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer.add_child(particle)
		var angle := TAU * float(index) / 12.0
		var target := center + Vector2(cos(angle), sin(angle)) * (55.0 + float(index % 3) * 15.0)
		var burst: Tween = game.create_tween().set_parallel(true)
		burst.tween_property(particle, "position", target, 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		burst.tween_property(particle, "rotation", angle + PI, 0.55)
		burst.tween_property(particle, "modulate:a", 0.0, 0.55).set_delay(0.18)
		burst.chain().tween_callback(particle.queue_free)

func _end_event(message := "") -> void:
	active_event = ""
	event_time_left = 0.0
	next_event_time = randf_range(EVENT_DELAY_MIN, EVENT_DELAY_MAX)
	if icon_tween != null:
		icon_tween.kill()
	if sparkle_tween != null:
		sparkle_tween.kill()
	if button_tween != null:
		button_tween.kill()
	if card_tween != null:
		card_tween.kill()
	if not message.is_empty():
		game.hint_label.text = message
		var tween: Tween = game.create_tween()
		tween.tween_interval(2.5)
		tween.tween_callback(func(): game.hint_label.text = "Tap the cat")
	banner.hide()
	_update_active_boosts_panel()

func _build_active_boosts_panel() -> void:
	active_boosts_panel = PanelContainer.new()
	active_boosts_panel.name = "ActiveBoostsPanel"
	active_boosts_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	active_boosts_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	active_boosts_panel.position = Vector2(-238, 126)
	active_boosts_panel.size = Vector2(218, 0)
	active_boosts_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(active_boosts_panel)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.045, 0.08, 0.88)
	style.border_color = Color(0.72, 0.5, 1.0, 0.72)
	style.set_border_width_all(2)
	style.set_corner_radius_all(15)
	style.shadow_color = Color(0.35, 0.2, 0.8, 0.35)
	style.shadow_size = 10
	active_boosts_panel.add_theme_stylebox_override("panel", style)
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	active_boosts_panel.add_child(margin)
	active_boosts_list = VBoxContainer.new()
	active_boosts_list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	active_boosts_list.add_theme_constant_override("separation", 4)
	margin.add_child(active_boosts_list)
	var title := Label.new()
	title.text = "ACTIVE BOOSTS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 10)
	title.add_theme_color_override("font_color", Color(0.93, 0.86, 1.0, 1.0))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	active_boosts_list.add_child(title)
	active_boosts_empty_label = Label.new()
	active_boosts_empty_label.text = "None active"
	active_boosts_empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	active_boosts_empty_label.add_theme_font_size_override("font_size", 10)
	active_boosts_empty_label.add_theme_color_override("font_color", Color(0.6, 0.66, 0.76, 1.0))
	active_boosts_empty_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	active_boosts_list.add_child(active_boosts_empty_label)
	active_boosts_panel.hide()

func _update_active_boosts_panel() -> void:
	if not is_instance_valid(active_boosts_panel) or game.boost_logic == null:
		return
	for index in range(active_boosts_list.get_child_count() - 1, 1, -1):
		active_boosts_list.get_child(index).free()
	var has_active_boost := false
	for data in BoostLogic.BOOST_DATA:
		var boost_id := String(data["id"])
		var remaining: float = game.boost_logic.get_remaining_seconds(boost_id)
		var is_tap_boost: bool = boost_id == "nine_lives" and game.nine_lives_taps_left > 0
		if remaining <= 0.0 and not is_tap_boost:
			continue
		has_active_boost = true
		var row := HBoxContainer.new()
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_theme_constant_override("separation", 5)
		active_boosts_list.add_child(row)
		var dot := Label.new()
		dot.text = "•"
		dot.add_theme_font_size_override("font_size", 14)
		dot.add_theme_color_override("font_color", data["accent"] as Color)
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(dot)
		var name := Label.new()
		name.text = String(data["name"]).capitalize()
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name.add_theme_font_size_override("font_size", 11)
		name.add_theme_color_override("font_color", Color.WHITE)
		name.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(name)
		var time := Label.new()
		time.text = "%d taps" % game.nine_lives_taps_left if is_tap_boost else game.boost_logic.format_seconds(remaining)
		time.add_theme_font_size_override("font_size", 11)
		time.add_theme_color_override("font_color", Color(1.0, 0.86, 0.34, 1.0))
		time.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(time)
	game._cleanup_food_boosts()
	for data in game.FOOD_BOOSTS:
		var boost_id := String(data["id"])
		var remaining := float(game.active_food_boosts.get(boost_id, 0.0)) - Time.get_unix_time_from_system()
		if remaining <= 0.0:
			continue
		has_active_boost = true
		var row := HBoxContainer.new()
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_theme_constant_override("separation", 5)
		active_boosts_list.add_child(row)
		var dot := Label.new()
		dot.text = "•"
		dot.add_theme_color_override("font_color", Color(1.0, 0.68, 0.26, 1.0))
		row.add_child(dot)
		var name := Label.new()
		name.text = String(data["name"])
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name.add_theme_font_size_override("font_size", 11)
		name.add_theme_color_override("font_color", Color.WHITE)
		row.add_child(name)
		var time := Label.new()
		time.text = game.boost_logic.format_seconds(remaining)
		time.add_theme_font_size_override("font_size", 11)
		time.add_theme_color_override("font_color", Color(1.0, 0.86, 0.34, 1.0))
		row.add_child(time)
	active_boosts_empty_label.visible = not has_active_boost
	active_boosts_panel.visible = has_active_boost or not active_event.is_empty()
