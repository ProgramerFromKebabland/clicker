extends Control

@onready var score_label: Label = %ScoreLabel
@onready var combo_label: Label = %ComboLabel
@onready var combo_timer_label: Label = %ComboTimerLabel
@onready var hint_label: Label = %HintLabel
@onready var coins_label: Label = %CoinsLabel
@onready var hud_wallet: PanelContainer = %HudWallet
@onready var hud_coin_icon: TextureRect = %HudCoinIcon
@onready var cat_button: TextureButton = %CatButton
@onready var menu_button: TextureButton = %MenuButton
@onready var menu_overlay: ColorRect = %MenuOverlay
@onready var menu_panel: PanelContainer = %MenuPanel
@onready var menu_header: PanelContainer = %MenuHeader
@onready var menu_wallet: PanelContainer = %MenuWallet
@onready var menu_coin_icon: TextureRect = %MenuCoinIcon
@onready var menu_wallet_coins_label: Label = %MenuWalletCoinsLabel
@onready var daily_reward_card: PanelContainer = %DailyRewardCard
@onready var settings_panel: PanelContainer = %SettingsPanel
@onready var upgrades_panel: PanelContainer = %UpgradesPanel
@onready var upgrade_hero: PanelContainer = %UpgradeHero
@onready var wallet_chip: PanelContainer = %WalletChip
@onready var upgrade_wallet_coin_icon: TextureRect = %WalletCoinIcon
@onready var click_upgrade_card: PanelContainer = %ClickUpgradeCard
@onready var bonus_chance_card: PanelContainer = %BonusChanceCard
@onready var bonus_value_card: PanelContainer = %BonusValueCard
@onready var bonus_streak_card: PanelContainer = %BonusStreakCard
@onready var passive_gain_card: PanelContainer = %PassiveGainCard
@onready var achievements_panel: PanelContainer = %AchievementsPanel
@onready var stats_panel: PanelContainer = %StatsPanel
@onready var menu_coins_label: Label = %MenuCoinsLabel
@onready var click_value_label: Label = %ClickValueLabel
@onready var click_power_label: Label = %ClickPowerLabel
@onready var click_power_slider: HSlider = %ClickPowerSlider
@onready var click_volume_label: Label = %ClickVolumeLabel
@onready var click_volume_slider: HSlider = %ClickVolumeSlider
@onready var ui_volume_label: Label = %UiVolumeLabel
@onready var ui_volume_slider: HSlider = %UiVolumeSlider
@onready var settings_passive_gain_label: Label = %SettingsPassiveGainLabel
@onready var settings_passive_gain_cost_label: Label = %SettingsPassiveGainCostLabel
@onready var settings_passive_gain_button: Button = %SettingsPassiveGainButton
@onready var upgrade_button: Button = %UpgradeButton
@onready var settings_button: Button = %SettingsButton
@onready var open_upgrades_button: Button = %OpenUpgradesButton
@onready var settings_back_button: Button = %SettingsBackButton
@onready var upgrade_coins_label: Label = %UpgradeCoinsLabel
@onready var upgrade_value_label: Label = %UpgradeValueLabel
@onready var upgrade_cost_label: Label = %UpgradeCostLabel
@onready var upgrade_purchase_button: Button = %UpgradePurchaseButton
@onready var click_progress_bar: ProgressBar = %ClickProgressBar
@onready var bonus_chance_label: Label = %BonusChanceLabel
@onready var bonus_chance_cost_label: Label = %BonusChanceCostLabel
@onready var bonus_chance_button: Button = %BonusChanceButton
@onready var bonus_chance_progress_bar: ProgressBar = %BonusChanceProgressBar
@onready var bonus_value_label: Label = %BonusValueLabel
@onready var bonus_value_cost_label: Label = %BonusValueCostLabel
@onready var bonus_value_button: Button = %BonusValueButton
@onready var bonus_value_progress_bar: ProgressBar = %BonusValueProgressBar
@onready var bonus_streak_label: Label = %BonusStreakLabel
@onready var bonus_streak_cost_label: Label = %BonusStreakCostLabel
@onready var bonus_streak_button: Button = %BonusStreakButton
@onready var bonus_streak_progress_bar: ProgressBar = %BonusStreakProgressBar
@onready var passive_gain_label: Label = %PassiveGainLabel
@onready var passive_gain_cost_label: Label = %PassiveGainCostLabel
@onready var passive_gain_button: Button = %PassiveGainButton
@onready var passive_gain_progress_bar: ProgressBar = %PassiveGainProgressBar
@onready var upgrades_back_button: Button = %UpgradesBackButton
@onready var upgrade_alert_badge: PanelContainer = %UpgradeAlertBadge
@onready var achievements_button: Button = %AchievementsButton
@onready var achievements_list_label: Label = %AchievementsListLabel
@onready var achievements_back_button: Button = %AchievementsBackButton
@onready var stats_button: Button = %StatsButton
@onready var settings_header: PanelContainer = %SettingsHeader
@onready var settings_wallet: PanelContainer = %SettingsWallet
@onready var click_settings_card: PanelContainer = %ClickSettingsCard
@onready var audio_settings_card: PanelContainer = %AudioSettingsCard
@onready var offline_settings_card: PanelContainer = %OfflineSettingsCard
@onready var stats_header: PanelContainer = %StatsHeader
@onready var stats_cards: VBoxContainer = %StatsCards
@onready var stats_back_button: Button = %StatsBackButton
@onready var daily_reward_label: Label = %DailyRewardLabel
@onready var daily_reward_button: Button = %DailyRewardButton
@onready var daily_reward_alert_label: Label = %DailyRewardAlertLabel
@onready var daily_reward_timer_label: Label = %DailyRewardTimerLabel
@onready var offline_info_label: Label = %OfflineInfoLabel
@onready var resume_button: Button = %ResumeButton
@onready var exit_button: Button = %ExitButton
@onready var click_popup_layer: Control = %ClickPopupLayer
@onready var cat_click_sound: AudioStreamPlayer = %CatClickSound
@onready var ui_sound: AudioStreamPlayer = %UiSound
@onready var cat_meow_sound: AudioStreamPlayer = %CatMeowSound
@onready var bonus_sound: AudioStreamPlayer = %BonusSound
@onready var special_milestone_sound: AudioStreamPlayer = %SpecialMilestoneSound

const SAVE_PATH := "user://clicker_progress.cfg"
const SAVE_SECTION := "progress"
const SAVE_SCORE_KEY := "score"
const SAVE_COINS_KEY := "coins"
const SAVE_CLICK_VALUE_KEY := "click_value"
const SAVE_UNLOCKED_CLICK_VALUE_KEY := "unlocked_click_value"
const SAVE_BONUS_CHANCE_LEVEL_KEY := "bonus_chance_level"
const SAVE_BONUS_VALUE_INDEX_KEY := "bonus_value_index"
const SAVE_BONUS_STREAK_MULTIPLIER_KEY := "bonus_streak_multiplier"
const SAVE_TOTAL_TAPS_KEY := "total_taps"
const SAVE_TOTAL_BONUS_CLICKS_KEY := "total_bonus_clicks"
const SAVE_BONUS_STREAK_ACTIVATIONS_KEY := "bonus_streak_activations"
const SAVE_BEST_SINGLE_CLICK_KEY := "best_single_click"
const SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY := "passive_clicks_per_minute"
const SAVE_BEST_COIN_BALANCE_KEY := "best_coin_balance"
const SAVE_LAST_SEEN_UNIX_KEY := "last_seen_unix"
const SAVE_LAST_DAILY_REWARD_DAY_KEY := "last_daily_reward_day"
const SAVE_DAILY_REWARD_STREAK_KEY := "daily_reward_streak"
const SAVE_BEST_DAILY_REWARD_STREAK_KEY := "best_daily_reward_streak"
const SAVE_CLICK_VOLUME_KEY := "click_volume"
const SAVE_UI_VOLUME_KEY := "ui_volume"
const SAVE_OWNED_SKINS_KEY := "owned_skins"
const SAVE_EQUIPPED_SKIN_KEY := "equipped_skin"
const ADMIN_MIN_AMOUNT := 1
const ADMIN_MAX_AMOUNT := 1000000000
const SAVE_DELAY_SECONDS := 0.8
const COMBO_STEP := 0.1
const COMBO_CLICKS_PER_STEP := 10
const MAX_COMBO_BONUS := 1.5
const COMBO_DRAIN_GRACE_SECONDS := 1.0
const COMBO_RESET_SECONDS := 2.5
const COMBO_DRAIN_INTERVAL := 0.1
const MAX_CLICK_VALUE := 20
const MAX_BONUS_CHANCE_LEVEL := 200
const MIN_BONUS_STREAK_MULTIPLIER := 2
const MAX_BONUS_STREAK_MULTIPLIER := 10
const BASE_BONUS_STREAK_COST := 1200
const BASE_MEOW_CLICK_INTERVAL := 1000
const MILESTONE_SCALE_START := 100000
const MAX_PASSIVE_CLICKS_PER_MINUTE := 30
const MIN_PASSIVE_UPGRADE_COST := 1000
const MAX_PASSIVE_UPGRADE_COST := 10000000
const OFFLINE_GAIN_MAX_SECONDS := 3 * 60 * 60
const DAILY_REWARD_BASE_COINS := 100
const DAILY_REWARD_STREAK_BONUS := 25
const BONUS_MULTIPLIERS := [2, 3, 5, 25, 100]
const BONUS_VALUE_COSTS := [500, 2500, 15000, 100000]
const CAT_PRESS_SCALE := Vector2(0.955, 0.955)
const CAT_POP_SCALE := Vector2(1.035, 1.035)
const CLICK_UPGRADE_COLOR := Color(0.25, 0.78, 1.0, 1.0)
const CHANCE_UPGRADE_COLOR := Color(1.0, 0.66, 0.2, 1.0)
const VALUE_UPGRADE_COLOR := Color(1.0, 0.32, 0.48, 1.0)
const STREAK_UPGRADE_COLOR := Color(0.98, 0.86, 0.16, 1.0)
const PASSIVE_UPGRADE_COLOR := Color(0.3, 0.9, 0.5, 1.0)
const MAX_COIN_PARTICLES := 40
const UPGRADE_ALERT_SHAKE_INTERVAL := 3.0
const TAP_BURST_COLORS := [
	Color(1.0, 0.88, 0.33, 0.95),
	Color(1.0, 1.0, 1.0, 0.9),
	Color(0.42, 0.86, 1.0, 0.9),
]
const DEFAULT_SKIN_ID := "classic"
const SKIN_ACCENT := Color(0.36, 0.82, 1.0, 1.0)
const SKIN_DATA := [
	{"id": DEFAULT_SKIN_ID, "name": "Classic Cat", "cost": 0, "texture": "res://assets/cat1.png"},
	{"id": "ai", "name": "AI Cat", "cost": 10, "texture": "res://assets/skins/ai_cat.png"},
	{"id": "military", "name": "Military Cat", "cost": 1000, "texture": "res://assets/skins/military_cat.png"},
	{"id": "commando", "name": "Commando Cat", "cost": 1500, "texture": "res://assets/skins/commando_cat.png"},
	{"id": "commando_hacker", "name": "Commando Hacker Cat", "cost": 3000, "texture": "res://assets/skins/commando_hacker_cat.png"},
	{"id": "glitch", "name": "Glitch Cat", "cost": 6666, "texture": "res://assets/skins/glitch_cat.png"},
	{"id": "alien", "name": "Alien Cat", "cost": 8000, "texture": "res://assets/skins/alien_cat.png"},
	{"id": "galaxy", "name": "Galaxy Cat", "cost": 10000, "texture": "res://assets/skins/galaxy_cat.png"},
	{"id": "void", "name": "Void Cat", "cost": 20000, "texture": "res://assets/skins/void_cat.png"},
]

var score: int = 0
var coins: int = 0
var click_value: int = 1
var unlocked_click_value: int = 1
var bonus_chance_level: int = 1
var bonus_value_index: int = 0
var bonus_streak_multiplier: int = MIN_BONUS_STREAK_MULTIPLIER
var passive_clicks_per_minute: int = 1
var total_taps: int = 0
var total_bonus_clicks: int = 0
var bonus_streak_activations: int = 0
var best_single_click: int = 0
var best_coin_balance: int = 0
var recent_bonus_clicks: Array[bool] = []
var combo_bonus: float = 0.0
var combo_drain_elapsed: float = 0.0
var combo_grace_left: float = 0.0
var combo_clicks_toward_step: int = 0
var last_daily_reward_day: int = -1
var daily_reward_streak: int = 0
var best_daily_reward_streak: int = 0
var last_offline_gain: int = 0
var last_offline_minutes: int = 0
var last_offline_was_capped := false
var click_volume: float = 1.0
var ui_volume: float = 1.0
var owned_skin_ids: Array[String] = []
var equipped_skin_id := DEFAULT_SKIN_ID
var cat_base_scale := Vector2.ONE
var last_cat_press_global_position := Vector2.ZERO
var save_timer: Timer
var daily_reward_timer: Timer
var combo_timer: Timer
var cat_tween: Tween
var score_tween: Tween
var coins_tween: Tween
var hud_coin_tween: Tween
var hud_coin_text_tween: Tween
var upgrade_ambient_tween: Tween
var coin_counter_tween: Tween
var displayed_coins: int = -1
var upgrade_alert_active := false
var upgrade_alert_elapsed := 0.0
var upgrade_alert_shake_tween: Tween
var stats_card_controls: Array[Control] = []
var known_achievement_ids: Dictionary = {}
var achievement_tracking_ready := false
var mobile_panels_wrapped := false
var touch_scroll_index := -1
var touch_scroll_dragging := false
var touch_scroll_distance := 0.0
var app_backgrounded_at_unix := 0
var app_was_backgrounded := false
var skins_button: Button
var skins_panel: PanelContainer
var skins_wallet_label: Label
var skins_status_label: Label
var skins_list: VBoxContainer
var skins_scroll: ScrollContainer
var skins_back_button: Button
var skin_action_buttons: Dictionary = {}
var admin_panel: PanelContainer
var admin_click_spinbox: SpinBox
var admin_coin_spinbox: SpinBox
var admin_status_label: Label
var is_editor_build := OS.has_feature("editor")


func _ready() -> void:
	get_tree().auto_accept_quit = false
	randomize()
	_load_game()
	_build_skins_ui()
	_apply_equipped_skin()
	get_viewport().size_changed.connect(_apply_mobile_layout)

	cat_base_scale = cat_button.scale
	cat_button.resized.connect(_update_cat_pivot)
	call_deferred("_update_cat_pivot")

	save_timer = Timer.new()
	save_timer.one_shot = true
	save_timer.wait_time = SAVE_DELAY_SECONDS
	save_timer.timeout.connect(_save_game)
	add_child(save_timer)

	daily_reward_timer = Timer.new()
	daily_reward_timer.wait_time = 1.0
	daily_reward_timer.timeout.connect(_update_daily_reward_ui)
	add_child(daily_reward_timer)
	daily_reward_timer.start()

	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.wait_time = COMBO_RESET_SECONDS
	combo_timer.timeout.connect(_reset_combo)
	add_child(combo_timer)

	_setup_main_ui_visuals()
	_setup_pause_menu_visuals()
	_setup_settings_stats_visuals()
	_setup_upgrade_visuals()
	_update_score()
	_update_coins(false)
	_update_combo_ui()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_update_volume_ui()
	_update_skins_ui()
	achievement_tracking_ready = true
	_apply_volume()
	call_deferred("_show_startup_popups")
	last_cat_press_global_position = cat_button.get_global_rect().get_center()
	cat_button.button_down.connect(_on_cat_pressed)
	menu_button.pressed.connect(_show_menu)
	skins_button.pressed.connect(_show_skins)
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
	achievements_button.pressed.connect(_show_achievements)
	achievements_back_button.pressed.connect(_show_menu)
	stats_button.pressed.connect(_show_stats)
	stats_back_button.pressed.connect(_show_menu)
	daily_reward_button.pressed.connect(_claim_daily_reward)
	click_power_slider.value_changed.connect(_on_click_power_changed)
	click_volume_slider.value_changed.connect(_on_click_volume_changed)
	ui_volume_slider.value_changed.connect(_on_ui_volume_changed)
	resume_button.pressed.connect(_hide_menu)
	exit_button.pressed.connect(_exit_game)
	skins_back_button.pressed.connect(_hide_menu)
	_setup_ui_animations(self)
	_build_admin_panel()
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


func _input(event: InputEvent) -> void:
	if is_editor_build and event is InputEventKey and event.pressed and not event.echo:
		if event.ctrl_pressed and event.alt_pressed and event.keycode == KEY_1:
			_toggle_admin_panel()
			get_viewport().set_input_as_handled()
			return

	if not menu_overlay.visible:
		touch_scroll_index = -1
		touch_scroll_dragging = false
		touch_scroll_distance = 0.0
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			touch_scroll_index = event.index
			touch_scroll_dragging = false
			touch_scroll_distance = 0.0
		elif event.index == touch_scroll_index:
			if touch_scroll_dragging:
				get_viewport().set_input_as_handled()
			touch_scroll_index = -1
			touch_scroll_dragging = false
			touch_scroll_distance = 0.0
		return

	if event is InputEventScreenDrag and event.index == touch_scroll_index:
		var scroll := _get_visible_menu_scroll()
		if scroll == null:
			return
		touch_scroll_distance += absf(event.relative.y)
		if touch_scroll_distance >= 8.0:
			touch_scroll_dragging = true
		if touch_scroll_dragging:
			scroll.scroll_vertical -= roundi(event.relative.y)
			get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			_exit_game()
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_FOCUS_OUT:
			if not app_was_backgrounded:
				app_backgrounded_at_unix = _get_unix_time()
				app_was_backgrounded = true
			_save_game()
		NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_IN:
			if app_was_backgrounded:
				app_was_backgrounded = false
				_apply_resumed_offline_gain()


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
	coins_label.text = formatted
	coins_label.tooltip_text = formatted
	call_deferred("_animate_hud_coin_text")
	menu_wallet_coins_label.text = "%s COINS" % formatted
	menu_coins_label.text = formatted
	upgrade_coins_label.text = formatted
	if is_instance_valid(skins_wallet_label):
		skins_wallet_label.text = "%s COINS" % formatted


func _animate_coin_counter(from_value: int, to_value: int, duration: float = 0.32) -> void:
	if coin_counter_tween != null and coin_counter_tween.is_valid():
		coin_counter_tween.kill()
	coin_counter_tween = create_tween()
	coin_counter_tween.tween_method(_set_coin_display, float(from_value), float(to_value), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _gain_coins(amount: int, origin_global: Vector2) -> void:
	if amount <= 0:
		return
	score += amount
	coins += amount
	best_coin_balance = maxi(best_coin_balance, coins)
	_update_score()
	_update_coins(true)
	_spawn_coin_stream(amount, origin_global)


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
	_style_upgrade_button(achievements_button, Color(0.82, 0.66, 0.22, 1.0))
	_style_upgrade_button(stats_button, Color(0.56, 0.48, 1.0, 1.0))
	_style_upgrade_button(resume_button, PASSIVE_UPGRADE_COLOR)
	_style_upgrade_button(exit_button, VALUE_UPGRADE_COLOR)


func _build_skins_ui() -> void:
	skins_button = Button.new()
	skins_button.name = "SkinsButton"
	skins_button.text = "SKINS"
	skins_button.tooltip_text = "Open cat skins"
	skins_button.custom_minimum_size = Vector2(144.0, 58.0)
	skins_button.add_theme_font_size_override("font_size", 20)
	add_child(skins_button)
	move_child(skins_button, menu_overlay.get_index())
	_style_upgrade_button(skins_button, SKIN_ACCENT)

	skins_panel = PanelContainer.new()
	skins_panel.name = "SkinsPanel"
	skins_panel.custom_minimum_size = Vector2(640.0, 1080.0)
	skins_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	skins_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	skins_panel.hide()
	menu_panel.get_parent().add_child(skins_panel)
	skins_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.22, 0.58, 0.82, 1.0), 24, 2, -1, 18)
	)

	var outer_margin := MarginContainer.new()
	outer_margin.add_theme_constant_override("margin_left", 18)
	outer_margin.add_theme_constant_override("margin_top", 18)
	outer_margin.add_theme_constant_override("margin_right", 18)
	outer_margin.add_theme_constant_override("margin_bottom", 18)
	skins_panel.add_child(outer_margin)

	var items := VBoxContainer.new()
	items.add_theme_constant_override("separation", 12)
	outer_margin.add_child(items)

	var header := PanelContainer.new()
	header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.045, 0.105, 0.16, 1.0), Color(0.32, 0.82, 1.0, 0.75), 18, 2, 5, 8)
	)
	items.add_child(header)

	var header_margin := MarginContainer.new()
	header_margin.add_theme_constant_override("margin_left", 18)
	header_margin.add_theme_constant_override("margin_top", 13)
	header_margin.add_theme_constant_override("margin_right", 18)
	header_margin.add_theme_constant_override("margin_bottom", 13)
	header.add_child(header_margin)

	var header_items := VBoxContainer.new()
	header_items.add_theme_constant_override("separation", 3)
	header_margin.add_child(header_items)

	var title := Label.new()
	title.text = "CAT SKINS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.78, 0.93, 1.0, 1.0))
	header_items.add_child(title)

	skins_status_label = Label.new()
	skins_status_label.text = "Purchase a skin, then equip it."
	skins_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	skins_status_label.add_theme_font_size_override("font_size", 14)
	skins_status_label.add_theme_color_override("font_color", Color(0.58, 0.72, 0.82, 1.0))
	header_items.add_child(skins_status_label)

	var wallet := PanelContainer.new()
	wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.14, 0.105, 0.035, 0.92), Color(1.0, 0.72, 0.16, 0.75), 14, 1, -1, 5)
	)
	items.add_child(wallet)

	var wallet_margin := MarginContainer.new()
	wallet_margin.add_theme_constant_override("margin_left", 16)
	wallet_margin.add_theme_constant_override("margin_top", 8)
	wallet_margin.add_theme_constant_override("margin_right", 16)
	wallet_margin.add_theme_constant_override("margin_bottom", 8)
	wallet.add_child(wallet_margin)

	var wallet_row := HBoxContainer.new()
	wallet_row.alignment = BoxContainer.ALIGNMENT_CENTER
	wallet_row.add_theme_constant_override("separation", 10)
	wallet_margin.add_child(wallet_row)

	var coin_icon := TextureRect.new()
	coin_icon.texture = menu_coin_icon.texture
	coin_icon.custom_minimum_size = Vector2(38.0, 38.0)
	coin_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	wallet_row.add_child(coin_icon)

	skins_wallet_label = Label.new()
	skins_wallet_label.add_theme_font_size_override("font_size", 22)
	skins_wallet_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46, 1.0))
	wallet_row.add_child(skins_wallet_label)

	skins_scroll = ScrollContainer.new()
	skins_scroll.custom_minimum_size = Vector2(0.0, 720.0)
	skins_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skins_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(skins_scroll)
	items.add_child(skins_scroll)

	skins_list = VBoxContainer.new()
	skins_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skins_list.add_theme_constant_override("separation", 12)
	skins_scroll.add_child(skins_list)

	for skin_data in SKIN_DATA:
		_add_skin_card(skin_data)

	skins_back_button = Button.new()
	skins_back_button.text = "BACK TO GAME"
	skins_back_button.custom_minimum_size = Vector2(0.0, 56.0)
	skins_back_button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(skins_back_button, Color(0.42, 0.5, 0.66, 1.0))
	items.add_child(skins_back_button)


func _add_skin_card(skin_data: Dictionary) -> void:
	var skin_id := String(skin_data["id"])
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0.0, 176.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(SKIN_ACCENT, false))
	card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, SKIN_ACCENT, true))
	card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, SKIN_ACCENT, false))
	skins_list.add_child(card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	margin.add_child(row)

	var preview := TextureRect.new()
	preview.custom_minimum_size = Vector2(150.0, 150.0)
	preview.texture = load(String(skin_data["texture"])) as Texture2D
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(preview)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 8)
	row.add_child(info)

	var name_label := Label.new()
	name_label.text = String(skin_data["name"]).to_upper()
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.add_theme_color_override("font_color", Color(0.82, 0.94, 1.0, 1.0))
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_child(name_label)

	var price_label := Label.new()
	var cost := int(skin_data["cost"])
	price_label.text = "FREE STARTER SKIN" if cost == 0 else "%s COINS" % _format_number(cost)
	price_label.add_theme_font_size_override("font_size", 16)
	price_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.42, 1.0))
	info.add_child(price_label)

	var action_button := Button.new()
	action_button.custom_minimum_size = Vector2(0.0, 52.0)
	action_button.add_theme_font_size_override("font_size", 18)
	action_button.pressed.connect(_on_skin_action_pressed.bind(skin_id))
	_style_upgrade_button(action_button, SKIN_ACCENT)
	info.add_child(action_button)
	skin_action_buttons[skin_id] = action_button


func _update_skins_ui() -> void:
	if not is_instance_valid(skins_wallet_label):
		return

	skins_wallet_label.text = "%s COINS" % _format_number(coins)
	for skin_data in SKIN_DATA:
		var skin_id := String(skin_data["id"])
		var action_button := skin_action_buttons.get(skin_id) as Button
		if action_button == null:
			continue
		if skin_id == equipped_skin_id:
			action_button.text = "EQUIPPED"
			action_button.disabled = true
		elif _owns_skin(skin_id):
			action_button.text = "EQUIP"
			action_button.disabled = false
		else:
			var cost := int(skin_data["cost"])
			action_button.disabled = coins < cost
			action_button.text = "BUY FOR %s" % _format_number(cost) if coins >= cost else "NEED %s MORE" % _format_number(cost - coins)


func _on_skin_action_pressed(skin_id: String) -> void:
	var skin_data := _get_skin_data(skin_id)
	if skin_data.is_empty():
		return

	if _owns_skin(skin_id):
		equipped_skin_id = skin_id
		_apply_equipped_skin()
		skins_status_label.text = "%s equipped." % String(skin_data["name"])
		_update_skins_ui()
		_play_ui_sound()
		_save_game()
		return

	var cost := int(skin_data["cost"])
	if coins < cost:
		return

	coins -= cost
	owned_skin_ids.append(skin_id)
	skins_status_label.text = "%s purchased. Tap EQUIP to wear it." % String(skin_data["name"])
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_skins_ui()
	_play_ui_sound()
	_save_game()


func _owns_skin(skin_id: String) -> bool:
	return skin_id == DEFAULT_SKIN_ID or skin_id in owned_skin_ids


func _get_skin_data(skin_id: String) -> Dictionary:
	for skin_data in SKIN_DATA:
		if String(skin_data["id"]) == skin_id:
			return skin_data
	return {}


func _is_valid_skin_id(skin_id: String) -> bool:
	return not _get_skin_data(skin_id).is_empty()


func _apply_equipped_skin() -> void:
	var skin_data := _get_skin_data(equipped_skin_id)
	if skin_data.is_empty() or not _owns_skin(equipped_skin_id):
		equipped_skin_id = DEFAULT_SKIN_ID
		skin_data = _get_skin_data(DEFAULT_SKIN_ID)

	var texture := load(String(skin_data["texture"])) as Texture2D
	if texture == null:
		return
	cat_button.texture_normal = texture
	cat_button.texture_pressed = texture
	cat_button.texture_hover = texture


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

	achievements_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.76, 0.6, 0.18, 0.92), 24, 2, -1, 18)
	)
	achievements_list_label.add_theme_font_size_override("font_size", 19)
	achievements_list_label.add_theme_color_override("font_color", Color(0.96, 0.97, 1.0, 0.96))
	achievements_list_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.72))
	achievements_list_label.add_theme_constant_override("shadow_offset_x", 1)
	achievements_list_label.add_theme_constant_override("shadow_offset_y", 1)
	_style_upgrade_button(achievements_back_button, Color(0.76, 0.6, 0.18, 1.0))

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
		[click_upgrade_card, upgrade_purchase_button, click_progress_bar, CLICK_UPGRADE_COLOR],
		[bonus_chance_card, bonus_chance_button, bonus_chance_progress_bar, CHANCE_UPGRADE_COLOR],
		[bonus_value_card, bonus_value_button, bonus_value_progress_bar, VALUE_UPGRADE_COLOR],
		[bonus_streak_card, bonus_streak_button, bonus_streak_progress_bar, STREAK_UPGRADE_COLOR],
		[passive_gain_card, passive_gain_button, passive_gain_progress_bar, PASSIVE_UPGRADE_COLOR],
	]
	for data in card_data:
		var card := data[0] as PanelContainer
		var button := data[1] as Button
		var progress_bar := data[2] as ProgressBar
		var accent := data[3] as Color
		card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
		card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, accent, true))
		card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, accent, false))
		_style_upgrade_button(button, accent)
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


func _style_upgrade_progress(progress_bar: ProgressBar, accent: Color) -> void:
	progress_bar.add_theme_stylebox_override(
		"background",
		_make_upgrade_style(Color(0.025, 0.03, 0.045, 1.0), Color(0.14, 0.16, 0.22, 1.0), 5, 1)
	)
	progress_bar.add_theme_stylebox_override(
		"fill",
		_make_upgrade_style(accent.darkened(0.12), accent.lightened(0.18), 5, 1)
	)


func _format_number(value: int) -> String:
	var text := str(value)
	var result := ""
	var digits := 0
	for index in range(text.length() - 1, -1, -1):
		if digits > 0 and digits % 3 == 0:
			result = "," + result
		result = text.substr(index, 1) + result
		digits += 1

	return result


func _animate_hud_coin_text() -> void:
	if not is_instance_valid(coins_label) or not coins_label.is_inside_tree():
		return
	if hud_coin_text_tween != null and hud_coin_text_tween.is_valid():
		hud_coin_text_tween.kill()

	coins_label.add_theme_font_size_override("font_size", 28)
	coins_label.position.x = 0.0
	var clip := coins_label.get_parent() as Control
	var font := coins_label.get_theme_font("font")
	var font_size := coins_label.get_theme_font_size("font_size")
	var text_width := font.get_string_size(coins_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
	coins_label.size = Vector2(text_width + 4.0, clip.size.y)
	var overflow := maxf(0.0, text_width - clip.size.x + 4.0)
	if overflow <= 0.0:
		return

	var travel_time := clampf(overflow / 45.0, 1.2, 4.5)
	hud_coin_text_tween = create_tween().set_loops()
	hud_coin_text_tween.tween_interval(1.2)
	hud_coin_text_tween.tween_property(coins_label, "position:x", -overflow, travel_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	hud_coin_text_tween.tween_interval(1.4)
	hud_coin_text_tween.tween_property(coins_label, "position:x", 0.0, travel_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


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
	achievements_button.text = "Achievements %d/%d" % [unlocked_count, achievements.size()]
	lines.insert(0, "Unlocked %d of %d achievements (%d%%)" % [unlocked_count, achievements.size(), percent])
	lines.insert(1, "")
	achievements_list_label.text = "\n".join(lines)
	_sync_achievement_unlocks(achievements, achievement_tracking_ready)


func _sync_achievement_unlocks(achievements: Array[Dictionary], show_popups: bool) -> void:
	var unlocked_now: Dictionary = {}
	for achievement in achievements:
		if not bool(achievement["unlocked"]):
			continue

		var achievement_id := String(achievement["text"])
		unlocked_now[achievement_id] = true
		if show_popups and not known_achievement_ids.has(achievement_id):
			_show_achievement_popup(achievement_id)

	known_achievement_ids = unlocked_now.duplicate()


func _show_achievement_popup(achievement_text: String) -> void:
	if not is_inside_tree():
		return

	var width := minf(size.x - 48.0, 360.0)
	var popup := Control.new()
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.z_index = 55
	popup.size = Vector2(width, 92.0)
	popup.set_meta("achievement_popup", true)
	click_popup_layer.add_child(popup)

	var stack_index := _get_active_achievement_popup_count() - 1
	popup.position = Vector2(size.x - width - 24.0, 24.0 + float(maxi(stack_index, 0)) * 100.0)
	popup.modulate.a = 0.0
	popup.scale = Vector2(0.92, 0.92)
	popup.pivot_offset = popup.size * 0.5

	var background := Panel.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.055, 0.07, 0.11, 0.97), Color(1.0, 0.76, 0.22, 0.95), 16, 2, -1, 10)
	)
	popup.add_child(background)

	var icon := TextureRect.new()
	icon.texture = menu_coin_icon.texture
	icon.position = Vector2(14.0, 18.0)
	icon.custom_minimum_size = Vector2(42.0, 42.0)
	icon.size = Vector2(42.0, 42.0)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.modulate = Color(1.0, 0.9, 0.46, 1.0)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.add_child(icon)

	var title := Label.new()
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

	var message := Label.new()
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

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position:x", popup.position.x - 18.0, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_interval(2.2)
	tween.tween_property(popup, "position:x", popup.position.x + 28.0, 0.28).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(popup, "modulate:a", 0.0, 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(Callable(popup, "queue_free"))


func _get_active_achievement_popup_count() -> int:
	var count := 0
	for child in click_popup_layer.get_children():
		if child.has_meta("achievement_popup"):
			count += 1
	return count


func _achievement(text: String, unlocked: bool) -> Dictionary:
	return {"text": text, "unlocked": unlocked}


func _append_threshold_achievements(achievements: Array[Dictionary], current_value: int, thresholds: Array[int], template: String) -> void:
	for threshold in thresholds:
		achievements.append(_achievement(template % _format_number(threshold), current_value >= threshold))


func _append_skin_achievements(achievements: Array[Dictionary]) -> void:
	var unlocked_skins := _get_unlocked_skin_count()
	for threshold in [2, 3, 4, 5, 6, 7, 8, 9]:
		achievements.append(_achievement("%d skins unlocked" % threshold, unlocked_skins >= threshold))


func _append_click_power_achievements(achievements: Array[Dictionary]) -> void:
	for threshold in range(2, MAX_CLICK_VALUE + 1):
		achievements.append(_achievement("Click value x%d" % threshold, unlocked_click_value >= threshold))


func _append_bonus_chance_achievements(achievements: Array[Dictionary]) -> void:
	for level in [5, 10, 20, 30, 40, 50, 75, 100, 125, 150, 175, 200]:
		achievements.append(_achievement("Bonus chance %.1f%%" % _get_bonus_chance_percent(level), bonus_chance_level >= level))


func _append_bonus_value_achievements(achievements: Array[Dictionary]) -> void:
	for multiplier in BONUS_MULTIPLIERS:
		achievements.append(_achievement("Bonus value x%d" % int(multiplier), _get_bonus_multiplier() >= int(multiplier)))


func _append_bonus_streak_achievements(achievements: Array[Dictionary]) -> void:
	for threshold in range(MIN_BONUS_STREAK_MULTIPLIER, MAX_BONUS_STREAK_MULTIPLIER + 1):
		achievements.append(_achievement("Bonus streak x%d" % threshold, bonus_streak_multiplier >= threshold))


func _get_unlocked_skin_count() -> int:
	return owned_skin_ids.size() + 1


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


func _rebuild_stats_cards(sections: Array) -> void:
	for child in stats_cards.get_children():
		stats_cards.remove_child(child)
		child.queue_free()
	stats_card_controls.clear()

	for section in sections:
		var section_box := VBoxContainer.new()
		section_box.add_theme_constant_override("separation", 7)
		section_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		stats_cards.add_child(section_box)

		var accent: Color = section["color"]
		var heading := Label.new()
		heading.text = str(section["title"])
		heading.add_theme_font_size_override("font_size", 17)
		heading.add_theme_color_override("font_color", accent.lightened(0.15))
		section_box.add_child(heading)

		var grid := GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 10)
		grid.add_theme_constant_override("v_separation", 10)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		section_box.add_child(grid)

		for entry in section["entries"]:
			var card := PanelContainer.new()
			card.custom_minimum_size = Vector2(245.0, 86.0)
			card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
			grid.add_child(card)
			stats_card_controls.append(card)

			var margin := MarginContainer.new()
			margin.add_theme_constant_override("margin_left", 13)
			margin.add_theme_constant_override("margin_top", 10)
			margin.add_theme_constant_override("margin_right", 13)
			margin.add_theme_constant_override("margin_bottom", 10)
			card.add_child(margin)

			var content := VBoxContainer.new()
			content.add_theme_constant_override("separation", 2)
			margin.add_child(content)

			var value_label := Label.new()
			value_label.text = str(entry[1])
			value_label.add_theme_font_size_override("font_size", 23)
			value_label.add_theme_color_override("font_color", accent.lightened(0.25))
			value_label.clip_text = true
			content.add_child(value_label)

			var name_label := Label.new()
			name_label.text = str(entry[0])
			name_label.add_theme_font_size_override("font_size", 12)
			name_label.add_theme_color_override("font_color", Color(0.62, 0.68, 0.78, 1.0))
			content.add_child(name_label)


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
	best_daily_reward_streak = maxi(best_daily_reward_streak, daily_reward_streak)
	var reward := _get_daily_reward_amount()
	_gain_coins(reward, daily_reward_button.get_global_rect().get_center())
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_daily_reward_ui()
	_spawn_click_popup(reward, 1)
	_play_bonus_sound()
	_save_game()


func _get_achievements() -> Array[Dictionary]:
	var achievements: Array[Dictionary] = []
	_append_threshold_achievements(achievements, score, [1, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000, 2500000, 5000000, 10000000], "%s total score")
	_append_threshold_achievements(achievements, total_taps, [1, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000, 1000000], "%s total taps")
	_append_threshold_achievements(achievements, total_bonus_clicks, [1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000], "%s bonus hits")
	_append_threshold_achievements(achievements, best_single_click, [2, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000], "Best click %s")
	_append_threshold_achievements(achievements, best_coin_balance, [10, 25, 50, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000, 100000, 250000, 500000], "%s coins banked at once")
	_append_threshold_achievements(achievements, bonus_streak_activations, [1, 5, 10, 25, 50, 100, 250, 500, 1000, 2500], "%s streak activations")
	_append_threshold_achievements(achievements, passive_clicks_per_minute, [1, 2, 3, 5, 7, 10, 12, 15, 20, 25, 30], "Offline gain %s/min")
	_append_threshold_achievements(achievements, best_daily_reward_streak, [1, 2, 3, 5, 7, 14, 30, 60, 100], "%s-day reward streak")
	_append_click_power_achievements(achievements)
	_append_bonus_chance_achievements(achievements)
	_append_bonus_value_achievements(achievements)
	_append_bonus_streak_achievements(achievements)
	_append_skin_achievements(achievements)
	return achievements


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
	var purchase_index := passive_clicks_per_minute - 1
	var final_purchase_index := MAX_PASSIVE_CLICKS_PER_MINUTE - 2
	if purchase_index <= 0:
		return MIN_PASSIVE_UPGRADE_COST
	if purchase_index >= final_purchase_index:
		return MAX_PASSIVE_UPGRADE_COST

	var progress := float(purchase_index) / float(final_purchase_index)
	var cost_ratio := float(MAX_PASSIVE_UPGRADE_COST) / float(MIN_PASSIVE_UPGRADE_COST)
	var raw_cost := float(MIN_PASSIVE_UPGRADE_COST) * pow(cost_ratio, progress)
	return int(round(raw_cost / 100.0)) * 100


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


func _prepare_mobile_panels() -> void:
	if mobile_panels_wrapped:
		return

	mobile_panels_wrapped = true
	for panel in [menu_panel, settings_panel, upgrades_panel, achievements_panel]:
		_wrap_panel_content_in_scroll(panel)
	_configure_touch_scroll(stats_cards.get_parent() as ScrollContainer)
	_configure_touch_scroll(skins_scroll)


func _wrap_panel_content_in_scroll(panel: PanelContainer) -> void:
	if panel.get_child_count() == 0:
		return

	var content := panel.get_child(0)
	if content is ScrollContainer:
		return

	panel.remove_child(content)
	var scroll := ScrollContainer.new()
	scroll.name = "%sScroll" % panel.name
	_configure_touch_scroll(scroll)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)
	scroll.add_child(content)
	if content is Control:
		var control := content as Control
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.size_flags_vertical = Control.SIZE_SHRINK_BEGIN


func _configure_touch_scroll(scroll: ScrollContainer) -> void:
	if scroll == null:
		return
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.scroll_deadzone = 8
	scroll.scroll_vertical_custom_step = 96.0
	scroll.follow_focus = true


func _get_visible_menu_scroll() -> ScrollContainer:
	if stats_panel.visible:
		return stats_cards.get_parent() as ScrollContainer
	if skins_panel.visible:
		return skins_scroll
	for panel in [menu_panel, settings_panel, upgrades_panel, achievements_panel]:
		if panel.visible and panel.get_child_count() > 0:
			return panel.get_child(0) as ScrollContainer
	return null


func _apply_mobile_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var content_width := minf(viewport_size.x, 720.0)
	var content_left := (viewport_size.x - content_width) * 0.5
	var content_right := viewport_size.x - content_left
	var side_margin := clampf(content_width * 0.045, 18.0, 32.0)
	var panel_width := maxf(280.0, content_width - side_margin * 2.0)
	var panel_height := maxf(400.0, viewport_size.y - 96.0)
	_set_responsive_panel_size(menu_panel, Vector2(510.0, 760.0), panel_width, panel_height)
	_set_responsive_panel_size(settings_panel, Vector2(560.0, 920.0), panel_width, panel_height)
	_set_responsive_panel_size(upgrades_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(achievements_panel, Vector2(520.0, 620.0), panel_width, panel_height)
	_set_responsive_panel_size(stats_panel, Vector2(610.0, 900.0), panel_width, panel_height)
	_set_responsive_panel_size(skins_panel, Vector2(640.0, 1080.0), panel_width, panel_height)

	var short_phone := viewport_size.y < 1080.0
	var game_margin := 18 if short_phone else 24
	var bottom_reserved := 104 if short_phone else 120
	var game_separation := 12 if short_phone else 22
	var tap_width := minf(560.0, content_width - side_margin * 2.0)
	var tap_height_limit := maxf(300.0, viewport_size.y - bottom_reserved - 260.0)
	var tap_height := minf(tap_width * 1.05, tap_height_limit)
	cat_button.custom_minimum_size = Vector2(maxf(260.0, tap_width), maxf(300.0, tap_height))

	var game_layer := get_node("GameLayer") as MarginContainer
	var game_box := get_node("GameLayer/GameBox") as VBoxContainer
	game_layer.add_theme_constant_override("margin_left", game_margin)
	game_layer.add_theme_constant_override("margin_top", 30 if short_phone else 48)
	game_layer.add_theme_constant_override("margin_right", game_margin)
	game_layer.add_theme_constant_override("margin_bottom", bottom_reserved)
	game_box.add_theme_constant_override("separation", game_separation)

	var phone_layout := content_width < 700.0 or DisplayServer.get_name() in ["Android", "iOS"]
	var hud_gap := 28.0 if phone_layout else 22.0
	var available_hud_width := content_width - side_margin * 2.0 - hud_gap
	var hud_width := minf(300.0, available_hud_width * 0.52) if phone_layout else available_hud_width * 0.43
	var upgrade_width := minf(250.0, available_hud_width - hud_width) if phone_layout else available_hud_width - hud_width
	var hud_row_width := hud_width + hud_gap + upgrade_width
	var hud_row_left := content_left + (content_width - hud_row_width) * 0.5
	var hud_row_right := hud_row_left + hud_row_width
	var hud_height := 62.0 if short_phone else 68.0
	hud_wallet.offset_left = hud_row_left
	hud_wallet.offset_top = -hud_height - side_margin
	hud_wallet.offset_right = hud_row_left + hud_width
	hud_wallet.offset_bottom = -side_margin
	upgrade_button.offset_left = -(viewport_size.x - hud_row_right + upgrade_width)
	upgrade_button.offset_top = -hud_height - side_margin
	upgrade_button.offset_right = -(viewport_size.x - hud_row_right)
	upgrade_button.offset_bottom = -side_margin
	upgrade_button.custom_minimum_size = Vector2(upgrade_width, hud_height)
	hud_coin_icon.custom_minimum_size = Vector2(48.0, 48.0)
	call_deferred("_animate_hud_coin_text")
	upgrade_button.add_theme_font_size_override("font_size", 18 if phone_layout else 21)

	var menu_size := 78.0 if short_phone else 92.0
	menu_button.custom_minimum_size = Vector2(menu_size, menu_size)
	menu_button.offset_left = -(viewport_size.x - content_right + side_margin + menu_size)
	menu_button.offset_top = side_margin
	menu_button.offset_right = -(viewport_size.x - content_right + side_margin)
	menu_button.offset_bottom = side_margin + menu_size

	var skins_width := 142.0 if short_phone else 154.0
	var skins_height := 56.0 if short_phone else 62.0
	skins_button.custom_minimum_size = Vector2(skins_width, skins_height)
	skins_button.offset_left = content_left + side_margin
	skins_button.offset_top = side_margin
	skins_button.offset_right = content_left + side_margin + skins_width
	skins_button.offset_bottom = side_margin + skins_height

	upgrade_alert_badge.offset_left = -(viewport_size.x - hud_row_right + 46.0)
	upgrade_alert_badge.offset_top = -hud_height - side_margin - 24.0
	upgrade_alert_badge.offset_right = -(viewport_size.x - hud_row_right) + 2.0
	upgrade_alert_badge.offset_bottom = -hud_height - side_margin + 24.0


func _set_responsive_panel_size(panel: Control, preferred_size: Vector2, max_width: float, max_height: float) -> void:
	panel.custom_minimum_size = Vector2(minf(preferred_size.x, max_width), minf(preferred_size.y, max_height))


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


func _show_skins() -> void:
	_play_ui_sound()
	skins_status_label.text = "Purchase a skin, then equip it."
	_update_skins_ui()
	_show_overlay_panel(skins_panel)


func _show_overlay_panel(panel: Control) -> void:
	upgrade_alert_elapsed = 0.0
	if panel != upgrades_panel:
		_stop_upgrade_ambient_animation()
	menu_panel.hide()
	settings_panel.hide()
	upgrades_panel.hide()
	achievements_panel.hide()
	stats_panel.hide()
	skins_panel.hide()
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


func _queue_save() -> void:
	if save_timer == null:
		_save_game()
		return

	if save_timer.is_stopped():
		save_timer.start()


func _save_game() -> void:
	var save_file := ConfigFile.new()
	save_file.set_value(SAVE_SECTION, SAVE_SCORE_KEY, score)
	save_file.set_value(SAVE_SECTION, SAVE_COINS_KEY, coins)
	save_file.set_value(SAVE_SECTION, SAVE_CLICK_VALUE_KEY, click_value)
	save_file.set_value(SAVE_SECTION, SAVE_UNLOCKED_CLICK_VALUE_KEY, unlocked_click_value)
	save_file.set_value(SAVE_SECTION, SAVE_BONUS_CHANCE_LEVEL_KEY, bonus_chance_level)
	save_file.set_value(SAVE_SECTION, SAVE_BONUS_VALUE_INDEX_KEY, bonus_value_index)
	save_file.set_value(SAVE_SECTION, SAVE_BONUS_STREAK_MULTIPLIER_KEY, bonus_streak_multiplier)
	save_file.set_value(SAVE_SECTION, SAVE_TOTAL_TAPS_KEY, total_taps)
	save_file.set_value(SAVE_SECTION, SAVE_TOTAL_BONUS_CLICKS_KEY, total_bonus_clicks)
	save_file.set_value(SAVE_SECTION, SAVE_BONUS_STREAK_ACTIVATIONS_KEY, bonus_streak_activations)
	save_file.set_value(SAVE_SECTION, SAVE_BEST_SINGLE_CLICK_KEY, best_single_click)
	save_file.set_value(SAVE_SECTION, SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY, passive_clicks_per_minute)
	save_file.set_value(SAVE_SECTION, SAVE_BEST_COIN_BALANCE_KEY, best_coin_balance)
	save_file.set_value(SAVE_SECTION, SAVE_LAST_SEEN_UNIX_KEY, _get_unix_time())
	save_file.set_value(SAVE_SECTION, SAVE_LAST_DAILY_REWARD_DAY_KEY, last_daily_reward_day)
	save_file.set_value(SAVE_SECTION, SAVE_DAILY_REWARD_STREAK_KEY, daily_reward_streak)
	save_file.set_value(SAVE_SECTION, SAVE_BEST_DAILY_REWARD_STREAK_KEY, best_daily_reward_streak)
	save_file.set_value(SAVE_SECTION, SAVE_CLICK_VOLUME_KEY, click_volume)
	save_file.set_value(SAVE_SECTION, SAVE_UI_VOLUME_KEY, ui_volume)
	save_file.set_value(SAVE_SECTION, SAVE_OWNED_SKINS_KEY, PackedStringArray(owned_skin_ids))
	save_file.set_value(SAVE_SECTION, SAVE_EQUIPPED_SKIN_KEY, equipped_skin_id)

	var err := save_file.save(SAVE_PATH)
	if err != OK:
		push_warning("Could not save clicker progress: %s" % error_string(err))


func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var save_file := ConfigFile.new()
	var err := save_file.load(SAVE_PATH)
	if err != OK:
		push_warning("Could not load clicker progress: %s" % error_string(err))
		return

	score = int(save_file.get_value(SAVE_SECTION, SAVE_SCORE_KEY, 0))
	coins = int(save_file.get_value(SAVE_SECTION, SAVE_COINS_KEY, score))
	unlocked_click_value = int(save_file.get_value(SAVE_SECTION, SAVE_UNLOCKED_CLICK_VALUE_KEY, save_file.get_value(SAVE_SECTION, SAVE_CLICK_VALUE_KEY, 1)))
	unlocked_click_value = clampi(unlocked_click_value, 1, MAX_CLICK_VALUE)
	click_value = int(save_file.get_value(SAVE_SECTION, SAVE_CLICK_VALUE_KEY, unlocked_click_value))
	click_value = clampi(click_value, 1, unlocked_click_value)
	bonus_chance_level = int(save_file.get_value(SAVE_SECTION, SAVE_BONUS_CHANCE_LEVEL_KEY, 1))
	bonus_chance_level = clampi(bonus_chance_level, 1, MAX_BONUS_CHANCE_LEVEL)
	bonus_value_index = int(save_file.get_value(SAVE_SECTION, SAVE_BONUS_VALUE_INDEX_KEY, 0))
	bonus_value_index = clampi(bonus_value_index, 0, BONUS_MULTIPLIERS.size() - 1)
	bonus_streak_multiplier = int(save_file.get_value(SAVE_SECTION, SAVE_BONUS_STREAK_MULTIPLIER_KEY, MIN_BONUS_STREAK_MULTIPLIER))
	bonus_streak_multiplier = clampi(bonus_streak_multiplier, MIN_BONUS_STREAK_MULTIPLIER, MAX_BONUS_STREAK_MULTIPLIER)
	total_taps = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_TOTAL_TAPS_KEY, 0)))
	total_bonus_clicks = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_TOTAL_BONUS_CLICKS_KEY, 0)))
	bonus_streak_activations = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_BONUS_STREAK_ACTIVATIONS_KEY, 0)))
	best_single_click = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_BEST_SINGLE_CLICK_KEY, 0)))
	passive_clicks_per_minute = int(save_file.get_value(SAVE_SECTION, SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY, 1))
	passive_clicks_per_minute = clampi(passive_clicks_per_minute, 1, MAX_PASSIVE_CLICKS_PER_MINUTE)
	last_daily_reward_day = int(save_file.get_value(SAVE_SECTION, SAVE_LAST_DAILY_REWARD_DAY_KEY, -1))
	daily_reward_streak = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_DAILY_REWARD_STREAK_KEY, 0)))
	best_coin_balance = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_BEST_COIN_BALANCE_KEY, coins)))
	best_daily_reward_streak = maxi(daily_reward_streak, int(save_file.get_value(SAVE_SECTION, SAVE_BEST_DAILY_REWARD_STREAK_KEY, daily_reward_streak)))
	_apply_offline_gain(int(save_file.get_value(SAVE_SECTION, SAVE_LAST_SEEN_UNIX_KEY, _get_unix_time())))
	click_volume = clamp(float(save_file.get_value(SAVE_SECTION, SAVE_CLICK_VOLUME_KEY, 1.0)), 0.0, 1.0)
	ui_volume = clamp(float(save_file.get_value(SAVE_SECTION, SAVE_UI_VOLUME_KEY, 1.0)), 0.0, 1.0)
	owned_skin_ids.clear()
	var saved_owned_skins: PackedStringArray = save_file.get_value(SAVE_SECTION, SAVE_OWNED_SKINS_KEY, PackedStringArray())
	for skin_id in saved_owned_skins:
		var saved_skin_id := String(skin_id)
		if saved_skin_id != DEFAULT_SKIN_ID and _is_valid_skin_id(saved_skin_id) and saved_skin_id not in owned_skin_ids:
			owned_skin_ids.append(saved_skin_id)
	equipped_skin_id = String(save_file.get_value(SAVE_SECTION, SAVE_EQUIPPED_SKIN_KEY, DEFAULT_SKIN_ID))
	if not _is_valid_skin_id(equipped_skin_id) or not _owns_skin(equipped_skin_id):
		equipped_skin_id = DEFAULT_SKIN_ID
	best_coin_balance = maxi(best_coin_balance, coins)


func _apply_offline_gain(last_seen_unix: int) -> void:
	var elapsed_seconds: int = maxi(0, _get_unix_time() - last_seen_unix)
	var capped_seconds: int = mini(elapsed_seconds, OFFLINE_GAIN_MAX_SECONDS)
	last_offline_was_capped = elapsed_seconds > OFFLINE_GAIN_MAX_SECONDS
	last_offline_minutes = floori(float(capped_seconds) / 60.0)
	last_offline_gain = 0
	if last_offline_minutes <= 0:
		return

	last_offline_gain = last_offline_minutes * passive_clicks_per_minute
	score += last_offline_gain
	coins += last_offline_gain
	best_coin_balance = maxi(best_coin_balance, coins)


func _apply_resumed_offline_gain() -> void:
	if app_backgrounded_at_unix <= 0:
		return

	_apply_offline_gain(app_backgrounded_at_unix)
	app_backgrounded_at_unix = 0
	if last_offline_gain <= 0:
		return

	_update_score()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_show_offline_gain_message()
	_queue_save()


func _show_offline_gain_message() -> void:
	if last_offline_gain <= 0:
		return

	var cap_text := " (max time reached)" if last_offline_was_capped else ""
	var popup := Control.new()
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.z_index = 30
	click_popup_layer.add_child(popup)

	var popup_width := minf(size.x - 48.0, 520.0)
	popup.size = Vector2(popup_width, 170.0)
	popup.position = Vector2((size.x - popup_width) * 0.5, 150.0)
	popup.modulate.a = 0.0
	popup.scale = Vector2(0.9, 0.9)
	popup.pivot_offset = popup.size * 0.5

	var background := Panel.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.045, 0.055, 0.07, 0.96)
	box.border_color = Color(1.0, 0.84, 0.28, 0.95)
	box.set_border_width_all(3)
	box.set_corner_radius_all(8)
	box.shadow_color = Color(0.0, 0.0, 0.0, 0.45)
	box.shadow_size = 12
	background.add_theme_stylebox_override("panel", box)
	popup.add_child(background)

	var message := Label.new()
	message.text = "Welcome back!\nOffline gain: +%s coins\n%d min counted%s" % [_format_number(last_offline_gain), last_offline_minutes, cap_text]
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
	_animate_coin_counter(maxi(0, coins - last_offline_gain), coins, 0.9)
	_spawn_coin_stream(last_offline_gain, popup.get_global_rect().get_center())

	var close_button := Button.new()
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

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "modulate:a", 1.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_interval(3.0)
	tween.chain().tween_property(popup, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func() -> void:
		if is_instance_valid(popup):
			popup.queue_free()
	)


func _get_offline_info_text() -> String:
	var max_minutes := int(OFFLINE_GAIN_MAX_SECONDS / 60)
	var max_gain := passive_clicks_per_minute * max_minutes
	return "Offline gain is capped at %d hours: up to %s coins." % [int(OFFLINE_GAIN_MAX_SECONDS / 3600), _format_number(max_gain)]


func _get_unix_time() -> int:
	return int(Time.get_unix_time_from_system())


func _get_current_day_number() -> int:
	return floori(float(_get_unix_time()) / 86400.0)


func _build_admin_panel() -> void:
	if not is_editor_build:
		return

	admin_panel = PanelContainer.new()
	admin_panel.name = "AdminPanel"
	admin_panel.visible = false
	admin_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	admin_panel.custom_minimum_size = Vector2(320.0, 0.0)
	admin_panel.anchor_left = 0.0
	admin_panel.anchor_top = 0.0
	admin_panel.anchor_right = 0.0
	admin_panel.anchor_bottom = 0.0
	admin_panel.offset_left = 20.0
	admin_panel.offset_top = 20.0
	admin_panel.offset_right = 340.0
	admin_panel.offset_bottom = 250.0
	admin_panel.z_index = 50
	add_child(admin_panel)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.06, 0.08, 0.11, 0.96)
	panel_style.border_color = Color(1.0, 0.83, 0.28, 0.95)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(12)
	panel_style.shadow_color = Color(0.0, 0.0, 0.0, 0.45)
	panel_style.shadow_size = 14
	admin_panel.add_theme_stylebox_override("panel", panel_style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	admin_panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)

	var title := Label.new()
	title.text = "EDITOR ADMIN"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5, 1.0))
	column.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Ctrl+Alt+1 toggles this panel"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.77, 0.82, 0.91, 1.0))
	column.add_child(subtitle)

	column.add_child(_build_admin_row("Add clicks", true))
	column.add_child(_build_admin_row("Add coins", false))

	admin_status_label = Label.new()
	admin_status_label.text = "Enter a value from 1 to 1,000,000,000."
	admin_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	admin_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	admin_status_label.add_theme_font_size_override("font_size", 13)
	admin_status_label.add_theme_color_override("font_color", Color(0.73, 0.8, 0.88, 1.0))
	column.add_child(admin_status_label)


func _build_admin_row(label_text: String, adds_clicks: bool) -> VBoxContainer:
	var wrapper := VBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 6)

	var label := Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size", 16)
	wrapper.add_child(label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	wrapper.add_child(row)

	var spinbox := SpinBox.new()
	spinbox.min_value = ADMIN_MIN_AMOUNT
	spinbox.max_value = ADMIN_MAX_AMOUNT
	spinbox.step = 1.0
	spinbox.allow_greater = false
	spinbox.allow_lesser = false
	spinbox.value = ADMIN_MIN_AMOUNT
	spinbox.rounded = true
	spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spinbox)

	var button := Button.new()
	button.text = label_text.to_upper()
	button.custom_minimum_size = Vector2(126.0, 40.0)
	row.add_child(button)

	if adds_clicks:
		admin_click_spinbox = spinbox
		button.pressed.connect(_on_admin_add_clicks_pressed)
	else:
		admin_coin_spinbox = spinbox
		button.pressed.connect(_on_admin_add_coins_pressed)

	return wrapper


func _toggle_admin_panel() -> void:
	if not is_instance_valid(admin_panel):
		return

	admin_panel.visible = not admin_panel.visible
	if admin_panel.visible:
		admin_status_label.text = "Enter a value from 1 to 1,000,000,000."
		admin_click_spinbox.get_line_edit().grab_focus()


func _get_admin_amount(spinbox: SpinBox) -> int:
	return clampi(int(round(spinbox.value)), ADMIN_MIN_AMOUNT, ADMIN_MAX_AMOUNT)


func _on_admin_add_clicks_pressed() -> void:
	var amount := _get_admin_amount(admin_click_spinbox)
	score += amount
	_update_score()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Added %s clicks." % _format_number(amount)


func _on_admin_add_coins_pressed() -> void:
	var amount := _get_admin_amount(admin_coin_spinbox)
	coins += amount
	best_coin_balance = maxi(best_coin_balance, coins)
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Added %s coins." % _format_number(amount)
