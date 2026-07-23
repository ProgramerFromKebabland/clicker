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
var active_boosts_refresh_elapsed := 0.0
var active_boosts_signature := ""
var event_timer_display := -1

const EVENT_IMAGES := {
	"golden_mouse": preload("res://assets/events/golden_mouse.png"),
	"kibble_storm": preload("res://assets/events/kibble_storm.png"),
	"sleepy_time": preload("res://assets/events/sleepy_time.png"),
	"merchant": preload("res://assets/events/merchant.png"),
	"yarn_comet": preload("res://assets/events/yarn_comet.png"),
	"tuna_jackpot": preload("res://assets/events/tuna_jackpot.png"),
	"crystal_paw": preload("res://assets/events/crystal_paw.png"),
	"moon_milk": preload("res://assets/events/moon_milk.png"),
	"laser_dot": preload("res://assets/events/laser_dot.png"),
	"royal_cushion": preload("res://assets/events/royal_cushion.png"),
	"fish_fountain": preload("res://assets/events/fish_fountain.png"),
	"star_nap": preload("res://assets/events/star_nap.png"),
	"biscuit_meteor": preload("res://assets/events/biscuit_meteor.png"),
	"toy_rocket": preload("res://assets/events/toy_rocket.png"),
	"collar_bell": preload("res://assets/events/collar_bell.png"),
	"sugar_cloud": preload("res://assets/events/sugar_cloud.png"),
	"treasure_whiskers": preload("res://assets/events/treasure_whiskers.png"),
	"time_hourglass": preload("res://assets/events/time_hourglass.png"),
	"magic_box": preload("res://assets/events/magic_box.png"),
	"neon_scratch": preload("res://assets/events/neon_scratch.png"),
	"sunbeam_window": preload("res://assets/events/sunbeam_window.png"),
	"frosty_treat": preload("res://assets/events/frosty_treat.png"),
	"lucky_pawprint": preload("res://assets/events/lucky_pawprint.png"),
	"cosmic_yarn": preload("res://assets/events/cosmic_yarn.png"),
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

const EVENT_DATA := [
	{"id": "golden_mouse", "kind": "collect", "duration": 12.0, "goal": 3, "reward_mult": 90.0, "badge": "LEGENDARY CHASE", "badge_color": Color(1.0, 0.83, 0.22), "title": "GOLDEN MOUSE!", "detail": "Catch it 3 times. Prize scales with your level.", "button": "CATCH"},
	{"id": "kibble_storm", "kind": "storm", "duration": 16.0, "tick": 0.55, "reward_mult": 1.0, "tap_mult": 3.0, "badge": "BONUS WEATHER", "badge_color": Color(0.35, 0.9, 1.0), "title": "KIBBLE STORM", "detail": "Scoop level-scaled drops before the clouds clear.", "button": "SCOOP"},
	{"id": "sleepy_time", "kind": "multiplier", "duration": 20.0, "gain_mult": 3.0, "tap_mult": 5.0, "badge": "DREAM RUSH", "badge_color": Color(0.78, 0.58, 1.0), "title": "SLEEPY TIME x3", "detail": "x3 gains. Pet the moon for level-scaled bonuses.", "button": "DREAM"},
	{"id": "merchant", "kind": "merchant", "duration": 18.0, "cost_mult": 28.0, "reward_mult": 2.15, "badge": "RARE MERCHANT", "badge_color": Color(1.0, 0.55, 0.28), "title": "TRAVELING CAT MERCHANT", "detail": "Mystery sack: value rises with your level.", "button": "BUY"},
	{"id": "yarn_comet", "kind": "collect", "duration": 14.0, "goal": 4, "reward_mult": 72.0, "badge": "SKY TREASURE", "badge_color": Color(1.0, 0.48, 0.82), "title": "YARN COMET", "detail": "Catch the comet before it burns out.", "button": "CATCH"},
	{"id": "tuna_jackpot", "kind": "instant", "duration": 10.0, "reward_mult": 62.0, "badge": "TIN LUCK", "badge_color": Color(0.45, 0.9, 1.0), "title": "TUNA JACKPOT", "detail": "Pop the can for a level-scaled jackpot.", "button": "OPEN"},
	{"id": "crystal_paw", "kind": "collect", "duration": 15.0, "goal": 5, "reward_mult": 84.0, "badge": "GEM PAWS", "badge_color": Color(0.55, 0.95, 1.0), "title": "CRYSTAL PAW", "detail": "Charge each toe bean for a bigger payout.", "button": "CHARGE"},
	{"id": "moon_milk", "kind": "multiplier", "duration": 18.0, "gain_mult": 2.25, "tap_mult": 4.0, "badge": "LUNAR BOWL", "badge_color": Color(0.92, 0.78, 1.0), "title": "MOON MILK", "detail": "Soft moonlight boosts every kibble source.", "button": "SIP"},
	{"id": "laser_dot", "kind": "collect", "duration": 11.0, "goal": 6, "reward_mult": 68.0, "badge": "FAST PAWS", "badge_color": Color(1.0, 0.32, 0.5), "title": "LASER DOT", "detail": "Pounce quickly for a level-scaled prize.", "button": "POUNCE"},
	{"id": "royal_cushion", "kind": "instant", "duration": 12.0, "reward_mult": 95.0, "badge": "ROYAL REST", "badge_color": Color(1.0, 0.76, 0.22), "title": "ROYAL CUSHION", "detail": "Claim a regal pile of kibbles.", "button": "CLAIM"},
	{"id": "fish_fountain", "kind": "storm", "duration": 14.0, "tick": 0.5, "reward_mult": 1.35, "tap_mult": 3.5, "badge": "SPLASH BONUS", "badge_color": Color(0.35, 0.85, 1.0), "title": "FISH FOUNTAIN", "detail": "Fountain drops scale with your level.", "button": "SPLASH"},
	{"id": "star_nap", "kind": "multiplier", "duration": 16.0, "gain_mult": 2.0, "tap_mult": 4.5, "badge": "NAP POWER", "badge_color": Color(0.95, 0.72, 1.0), "title": "STAR NAP", "detail": "Dreamy gains and bonus sleepy taps.", "button": "NUDGE"},
	{"id": "biscuit_meteor", "kind": "collect", "duration": 13.0, "goal": 4, "reward_mult": 88.0, "badge": "CRUNCH IMPACT", "badge_color": Color(1.0, 0.54, 0.18), "title": "BISCUIT METEOR", "detail": "Break the meteor into tasty rewards.", "button": "CRACK"},
	{"id": "toy_rocket", "kind": "instant", "duration": 9.0, "reward_mult": 74.0, "badge": "BOOST LAUNCH", "badge_color": Color(0.55, 0.7, 1.0), "title": "TOY ROCKET", "detail": "Launch it for a fast kibble burst.", "button": "LAUNCH"},
	{"id": "collar_bell", "kind": "collect", "duration": 14.0, "goal": 5, "reward_mult": 76.0, "badge": "LUCKY RING", "badge_color": Color(0.35, 1.0, 0.48), "title": "COLLAR BELL", "detail": "Ring up level-scaled bonus kibbles.", "button": "RING"},
	{"id": "sugar_cloud", "kind": "storm", "duration": 15.0, "tick": 0.6, "reward_mult": 1.55, "tap_mult": 4.0, "badge": "SWEET WEATHER", "badge_color": Color(1.0, 0.62, 0.82), "title": "SUGAR CLOUD", "detail": "Sweet drops rain from the sky.", "button": "PUFF"},
	{"id": "treasure_whiskers", "kind": "collect", "duration": 16.0, "goal": 4, "reward_mult": 105.0, "badge": "HIDDEN LOOT", "badge_color": Color(1.0, 0.66, 0.2), "title": "TREASURE WHISKERS", "detail": "Tug the whiskers to reveal the stash.", "button": "TUG"},
	{"id": "time_hourglass", "kind": "multiplier", "duration": 22.0, "gain_mult": 1.75, "tap_mult": 6.0, "badge": "TIME BONUS", "badge_color": Color(0.42, 0.82, 1.0), "title": "TIME HOURGLASS", "detail": "Slow time and gather extra kibbles.", "button": "FLIP"},
	{"id": "magic_box", "kind": "instant", "duration": 13.0, "reward_mult": 82.0, "badge": "BOX MAGIC", "badge_color": Color(0.86, 0.58, 1.0), "title": "MAGIC BOX", "detail": "Open the box. It probably contains kibbles.", "button": "OPEN"},
	{"id": "neon_scratch", "kind": "collect", "duration": 15.0, "goal": 7, "reward_mult": 70.0, "badge": "NEON CLAWS", "badge_color": Color(0.82, 0.42, 1.0), "title": "NEON SCRATCH", "detail": "Scratch fast for an electric payout.", "button": "SCRATCH"},
	{"id": "sunbeam_window", "kind": "multiplier", "duration": 18.0, "gain_mult": 2.5, "tap_mult": 3.5, "badge": "SUNBEAM", "badge_color": Color(1.0, 0.72, 0.24), "title": "SUNBEAM WINDOW", "detail": "Warm light boosts your kibble gain.", "button": "BASK"},
	{"id": "frosty_treat", "kind": "instant", "duration": 12.0, "reward_mult": 78.0, "badge": "COOL TREAT", "badge_color": Color(0.55, 0.95, 1.0), "title": "FROSTY TREAT", "detail": "Grab a chilly level-scaled snack.", "button": "LICK"},
	{"id": "lucky_pawprint", "kind": "collect", "duration": 13.0, "goal": 3, "reward_mult": 112.0, "badge": "LUCKY PRINT", "badge_color": Color(0.72, 1.0, 0.28), "title": "LUCKY PAWPRINT", "detail": "Tap the lucky print for a big prize.", "button": "PRESS"},
	{"id": "cosmic_yarn", "kind": "storm", "duration": 17.0, "tick": 0.48, "reward_mult": 1.8, "tap_mult": 5.0, "badge": "COSMIC THREAD", "badge_color": Color(0.58, 0.78, 1.0), "title": "COSMIC YARN", "detail": "Unwind space itself into kibbles.", "button": "UNWIND"},
]

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
	var style: StyleBoxFlat = game._make_upgrade_style(Color(0.055, 0.075, 0.12, 0.96), Color(1.0, 0.72, 0.12, 1.0), 7, 3, 5, 14)
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
	game._style_arcade_label_plate(live_badge, Color(1.0, 0.72, 0.12, 1.0), true)
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
	game._style_upgrade_button(action_button, Color(1.0, 0.58, 0.08, 1.0))
	action_button.pressed.connect(_on_action_pressed)
	column.add_child(action_button)
	banner.hide()
	_build_active_boosts_panel()

func process(delta: float) -> void:
	active_boosts_refresh_elapsed += delta
	if not game.events_enabled:
		if not active_event.is_empty() or (is_instance_valid(banner) and banner.visible):
			set_events_enabled(false)
		if active_boosts_refresh_elapsed >= 1.0:
			active_boosts_refresh_elapsed = 0.0
			_update_active_boosts_panel()
		return
	if game.menu_overlay.visible or game.tutorial_active or game.tutorial_prompt_visible:
		if active_boosts_refresh_elapsed >= 1.0:
			active_boosts_refresh_elapsed = 0.0
			_update_active_boosts_panel()
		return
	if active_boosts_refresh_elapsed >= 0.5:
		active_boosts_refresh_elapsed = 0.0
		_update_active_boosts_panel()
	if active_event.is_empty():
		next_event_time -= delta
		if next_event_time <= 0.0:
			_start_random_event()
		return
	event_time_left -= delta
	var shown_seconds := ceili(event_time_left)
	if shown_seconds != event_timer_display:
		event_timer_display = shown_seconds
		timer_label.text = "%ds remaining" % shown_seconds
	progress_bar.value = event_time_left
	var data := _get_active_event_data()
	if String(data.get("kind", "")) == "merchant":
		action_button.disabled = game.coins < merchant_cost
	if String(data.get("kind", "")) == "storm":
		storm_tick += delta
		var tick_seconds := float(data.get("tick", 0.55))
		while storm_tick >= tick_seconds:
			storm_tick -= tick_seconds
			_storm_payout()
	if event_time_left <= 0.0:
		_end_event()

func get_global_gain_multiplier() -> float:
	if not game.events_enabled:
		return 1.0
	if active_event.is_empty():
		return 1.0
	var data := _get_active_event_data()
	return float(data.get("gain_mult", 1.0)) if String(data.get("kind", "")) == "multiplier" else 1.0


func set_events_enabled(enabled: bool) -> void:
	if enabled:
		if next_event_time <= 0.0:
			next_event_time = randf_range(FIRST_EVENT_MIN, FIRST_EVENT_MAX)
		return
	_cancel_active_event()

func _start_random_event() -> void:
	if not game.events_enabled:
		next_event_time = randf_range(EVENT_DELAY_MIN, EVENT_DELAY_MAX)
		return
	var data := EVENT_DATA.pick_random() as Dictionary
	active_event = String(data["id"])
	event_timer_display = -1
	event_time_left = float(data.get("duration", 14.0))
	progress_bar.max_value = event_time_left
	progress_bar.value = event_time_left
	interaction_count = 0
	event_icon.texture = EVENT_IMAGES[active_event]
	event_audio.stream = EVENT_SOUNDS.get(active_event, EVENT_SOUNDS["golden_mouse"])
	interaction_audio.stream = INTERACTION_SOUNDS.get(active_event, INTERACTION_SOUNDS["golden_mouse"])
	event_audio.pitch_scale = 1.0
	event_audio.play()
	storm_tick = 0.0
	action_button.show()
	action_button.disabled = false
	live_badge.text = "*  %s  *" % String(data.get("badge", "LIMITED EVENT"))
	live_badge.add_theme_color_override("font_color", data.get("badge_color", Color(1.0, 0.83, 0.22)) as Color)
	title_label.text = String(data.get("title", active_event)).to_upper()
	detail_label.text = String(data.get("detail", "Earn a level-scaled kibble reward."))
	if String(data.get("kind", "")) == "merchant":
		merchant_cost = _level_scaled_reward(float(data.get("cost_mult", 28.0)))
		action_button.disabled = game.coins < merchant_cost
	_update_action_button_text(data)
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
	var data := _get_active_event_data()
	match String(data.get("kind", "")):
		"collect":
			interaction_count += 1
			_update_action_button_text(data)
			_bounce_icon()
			if interaction_count >= int(data.get("goal", 3)):
				var reward := _level_scaled_reward(float(data.get("reward_mult", 80.0)))
				game._gain_coins(reward, action_button.get_global_rect().get_center())
				game._play_bonus_sound()
				_end_event("%s complete! +%s kibbles" % [String(data.get("title", "Event")).capitalize(), game._format_number(reward)])
		"storm":
			interaction_count += 1
			var reward := _level_scaled_reward(float(data.get("tap_mult", 3.0)))
			game._gain_coins(reward, action_button.get_global_rect().get_center())
			_update_action_button_text(data)
			_bounce_icon()
		"multiplier":
			interaction_count += 1
			var reward := _level_scaled_reward(float(data.get("tap_mult", 4.0)))
			game._gain_coins(reward, action_button.get_global_rect().get_center())
			_update_action_button_text(data)
			_bounce_icon()
		"instant":
			var reward := _level_scaled_reward(float(data.get("reward_mult", 75.0)))
			game._gain_coins(reward, action_button.get_global_rect().get_center())
			game._play_bonus_sound()
			_end_event("%s! +%s kibbles" % [String(data.get("title", "Bonus")).capitalize(), game._format_number(reward)])
		"merchant":
			if not game._spend_coins(merchant_cost):
				return
			var minimum_reward: int = game._add_resource_value(merchant_cost, 1)
			var merchant_reward: int = maxi(minimum_reward, game._safe_resource_round(float(merchant_cost) * float(data.get("reward_mult", 2.0))))
			game._gain_coins(merchant_reward, action_button.get_global_rect().get_center())
			game._update_coins()
			game._queue_save()
			game._play_bonus_sound()
			_end_event("A fine bargain! +%s net kibbles" % game._format_number(merchant_reward - merchant_cost))
func _storm_payout() -> void:
	var data := _get_active_event_data()
	var reward := _level_scaled_reward(float(data.get("reward_mult", 1.0)))
	var origin := Vector2(randf_range(80.0, game.size.x - 80.0), randf_range(260.0, game.size.y * 0.68))
	game._gain_coins(reward, origin)
	game._spawn_click_popup(reward, 1, 1, 0.0)
	game._queue_save()

func _level_scaled_reward(multiplier: float) -> int:
	var player_level := _get_player_level()
	var level_bonus := 1.0 + (pow(float(player_level), 0.72) * 0.055)
	var mastery := 1.0 + minf(2.0, sqrt(float(maxi(0, game.total_taps))) / 100.0)
	var active_bonus := 1.0 + minf(1.5, float(interaction_count) * 0.08)
	var income_power := float(game.click_value + game._get_effective_passive_gain())
	return game._safe_resource_round(income_power * multiplier * level_bonus * mastery * active_bonus, 1)

func _get_player_level() -> int:
	var upgrade_total := maxi(1, game.click_value)
	upgrade_total += game.bonus_chance_level
	upgrade_total += game.bonus_value_index + 1
	upgrade_total += game.bonus_streak_multiplier
	upgrade_total += game.passive_clicks_per_minute
	for upgrade_data in game.EXTENDED_UPGRADE_DATA:
		upgrade_total += game.get_extended_upgrade_level(String(upgrade_data["id"]))
	return maxi(1, upgrade_total + int(sqrt(float(maxi(0, game.total_taps))) / 6.0))

func _get_active_event_data() -> Dictionary:
	for data in EVENT_DATA:
		if String(data["id"]) == active_event:
			return data
	return {}

func _update_action_button_text(data: Dictionary) -> void:
	var verb := String(data.get("button", "GO"))
	match String(data.get("kind", "")):
		"collect":
			action_button.text = "*  %s  %d/%d  *" % [verb, interaction_count, int(data.get("goal", 3))]
		"merchant":
			action_button.text = "*  %s  %s  *" % [verb, game._format_number(merchant_cost)]
		"storm", "multiplier":
			action_button.text = "*  %s  %d  *" % [verb, interaction_count]
		_:
			action_button.text = "*  %s  *" % verb

func _start_icon_animation() -> void:
	if game.low_quality_mode:
		return
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
	if game.low_quality_mode:
		return
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
	if game.low_quality_mode:
		return
	if button_tween != null:
		button_tween.kill()
	action_button.pivot_offset = action_button.size * 0.5
	button_tween = game.create_tween().set_loops()
	button_tween.tween_property(action_button, "scale", Vector2(1.075, 1.075), 0.65).set_trans(Tween.TRANS_SINE)
	button_tween.tween_property(action_button, "scale", Vector2.ONE, 0.65).set_trans(Tween.TRANS_SINE)

func _start_card_animation() -> void:
	if game.low_quality_mode:
		return
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
	if game.low_quality_mode:
		return
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


func _cancel_active_event() -> void:
	active_event = ""
	event_time_left = 0.0
	event_timer_display = -1
	next_event_time = randf_range(EVENT_DELAY_MIN, EVENT_DELAY_MAX)
	if icon_tween != null:
		icon_tween.kill()
	if sparkle_tween != null:
		sparkle_tween.kill()
	if button_tween != null:
		button_tween.kill()
	if card_tween != null:
		card_tween.kill()
	if is_instance_valid(event_audio):
		event_audio.stop()
	if is_instance_valid(interaction_audio):
		interaction_audio.stop()
	if is_instance_valid(banner):
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
	var style: StyleBoxFlat = game._make_upgrade_style(Color(0.035, 0.045, 0.08, 0.88), Color(0.72, 0.5, 1.0, 0.72), 7, 2, 4, 8)
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
	var signature_parts: Array[String] = [active_event]
	for data in BoostLogic.BOOST_DATA:
		var boost_id_for_signature := String(data["id"])
		var remaining_for_signature: float = game.boost_logic.get_remaining_seconds(boost_id_for_signature)
		var is_tap_boost_for_signature: bool = boost_id_for_signature == "nine_lives" and game.nine_lives_taps_left > 0
		if remaining_for_signature > 0.0 or is_tap_boost_for_signature:
			signature_parts.append("%s:%d" % [boost_id_for_signature, game.nine_lives_taps_left if is_tap_boost_for_signature else ceili(remaining_for_signature)])
	game._cleanup_food_boosts()
	for data in game.FOOD_BOOSTS:
		var food_boost_id_for_signature := String(data["id"])
		var food_remaining_for_signature: float = float(game.active_food_boosts.get(food_boost_id_for_signature, 0.0)) - float(game._get_unix_time())
		if food_remaining_for_signature > 0.0:
			signature_parts.append("%s:%d" % [food_boost_id_for_signature, ceili(food_remaining_for_signature)])
	var new_signature := "|".join(signature_parts)
	if new_signature == active_boosts_signature:
		return
	active_boosts_signature = new_signature
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
		var remaining: float = float(game.active_food_boosts.get(boost_id, 0.0)) - float(game._get_unix_time())
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
