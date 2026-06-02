extends Control

@onready var score_label: Label = %ScoreLabel
@onready var combo_label: Label = %ComboLabel
@onready var combo_timer_label: Label = %ComboTimerLabel
@onready var coins_label: Label = %CoinsLabel
@onready var cat_button: TextureButton = %CatButton
@onready var menu_button: TextureButton = %MenuButton
@onready var menu_overlay: ColorRect = %MenuOverlay
@onready var menu_panel: PanelContainer = %MenuPanel
@onready var settings_panel: PanelContainer = %SettingsPanel
@onready var upgrades_panel: PanelContainer = %UpgradesPanel
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
@onready var upgrade_info_button: Button = %UpgradeInfoButton
@onready var upgrade_cost_label: Label = %UpgradeCostLabel
@onready var upgrade_purchase_button: Button = %UpgradePurchaseButton
@onready var bonus_chance_label: Label = %BonusChanceLabel
@onready var bonus_chance_info_button: Button = %BonusChanceInfoButton
@onready var bonus_chance_cost_label: Label = %BonusChanceCostLabel
@onready var bonus_chance_button: Button = %BonusChanceButton
@onready var bonus_value_label: Label = %BonusValueLabel
@onready var bonus_value_info_button: Button = %BonusValueInfoButton
@onready var bonus_value_cost_label: Label = %BonusValueCostLabel
@onready var bonus_value_button: Button = %BonusValueButton
@onready var bonus_streak_label: Label = %BonusStreakLabel
@onready var bonus_streak_info_button: Button = %BonusStreakInfoButton
@onready var bonus_streak_cost_label: Label = %BonusStreakCostLabel
@onready var bonus_streak_button: Button = %BonusStreakButton
@onready var passive_gain_label: Label = %PassiveGainLabel
@onready var passive_gain_info_button: Button = %PassiveGainInfoButton
@onready var passive_gain_cost_label: Label = %PassiveGainCostLabel
@onready var passive_gain_button: Button = %PassiveGainButton
@onready var upgrades_back_button: Button = %UpgradesBackButton
@onready var achievements_button: Button = %AchievementsButton
@onready var achievements_list_label: Label = %AchievementsListLabel
@onready var achievements_back_button: Button = %AchievementsBackButton
@onready var stats_button: Button = %StatsButton
@onready var stats_list_label: Label = %StatsListLabel
@onready var stats_back_button: Button = %StatsBackButton
@onready var tutorial_button: Button = %TutorialButton
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
const SAVE_SEEN_TUTORIAL_VERSION_KEY := "seen_tutorial_version"
const SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY := "passive_clicks_per_minute"
const SAVE_LAST_SEEN_UNIX_KEY := "last_seen_unix"
const SAVE_LAST_DAILY_REWARD_DAY_KEY := "last_daily_reward_day"
const SAVE_DAILY_REWARD_STREAK_KEY := "daily_reward_streak"
const SAVE_CLICK_VOLUME_KEY := "click_volume"
const SAVE_UI_VOLUME_KEY := "ui_volume"
const SAVE_DELAY_SECONDS := 0.8
const TUTORIAL_VERSION := 1
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
const BASE_PASSIVE_UPGRADE_COST := 1000
const OFFLINE_GAIN_MAX_SECONDS := 3 * 60 * 60
const DAILY_REWARD_BASE_COINS := 100
const DAILY_REWARD_STREAK_BONUS := 25
const BONUS_MULTIPLIERS := [2, 3, 5, 25, 100]
const BONUS_VALUE_COSTS := [500, 2500, 15000, 100000]
const CAT_PRESS_SCALE := Vector2(0.955, 0.955)
const CAT_POP_SCALE := Vector2(1.08, 1.08)
const TAP_BURST_COLORS := [
	Color(1.0, 0.88, 0.33, 0.95),
	Color(1.0, 1.0, 1.0, 0.9),
	Color(0.42, 0.86, 1.0, 0.9),
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
var seen_tutorial_version: int = 0
var recent_bonus_clicks: Array[bool] = []
var combo_bonus: float = 0.0
var combo_drain_elapsed: float = 0.0
var combo_grace_left: float = 0.0
var combo_clicks_toward_step: int = 0
var last_daily_reward_day: int = -1
var daily_reward_streak: int = 0
var last_offline_gain: int = 0
var last_offline_minutes: int = 0
var last_offline_was_capped := false
var click_volume: float = 1.0
var ui_volume: float = 1.0
var cat_base_scale := Vector2.ONE
var last_cat_press_global_position := Vector2.ZERO
var save_timer: Timer
var daily_reward_timer: Timer
var combo_timer: Timer
var cat_tween: Tween
var score_tween: Tween
var coins_tween: Tween
var mobile_panels_wrapped := false
var tutorial_popup: Control
var tutorial_page_index := 0
var tutorial_quest_completed: Dictionary = {}


func _ready() -> void:
	get_tree().auto_accept_quit = false
	randomize()
	_load_game()
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

	_update_score()
	_update_coins()
	_update_combo_ui()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_update_volume_ui()
	_apply_volume()
	call_deferred("_show_startup_popups")
	last_cat_press_global_position = cat_button.get_global_rect().get_center()
	cat_button.gui_input.connect(_on_cat_gui_input)
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
	upgrades_back_button.pressed.connect(_show_settings)
	achievements_button.pressed.connect(_show_achievements)
	achievements_back_button.pressed.connect(_show_menu)
	stats_button.pressed.connect(_show_stats)
	stats_back_button.pressed.connect(_show_menu)
	tutorial_button.pressed.connect(_show_tutorial_from_menu)
	daily_reward_button.pressed.connect(_claim_daily_reward)
	_setup_upgrade_info_popups()
	click_power_slider.value_changed.connect(_on_click_power_changed)
	click_volume_slider.value_changed.connect(_on_click_volume_changed)
	ui_volume_slider.value_changed.connect(_on_ui_volume_changed)
	resume_button.pressed.connect(_hide_menu)
	exit_button.pressed.connect(_exit_game)
	_setup_ui_animations(self)
	_prepare_mobile_panels()
	_apply_mobile_layout()
	menu_overlay.hide()


func _process(delta: float) -> void:
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
	score += click_amount
	coins += click_amount
	_update_score()
	_update_coins()
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


func _update_coins() -> void:
	coins_label.text = "Coins: %s" % _format_number(coins)


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
	menu_coins_label.text = "Coins: %s" % _format_number(coins)
	click_value_label.text = "Click value: x%d / unlocked x%d" % [click_value, unlocked_click_value]
	click_power_label.text = "Use click value: x%d" % click_value
	click_power_slider.max_value = unlocked_click_value
	click_power_slider.value = click_value
	upgrade_coins_label.text = "Coins: %s" % _format_number(coins)
	upgrade_value_label.text = "Click value: x%d" % unlocked_click_value
	upgrade_button.disabled = false
	offline_info_label.text = _get_offline_info_text()

	if unlocked_click_value >= MAX_CLICK_VALUE:
		upgrade_button.text = "Upgrades"
		upgrade_cost_label.text = "Max upgrade reached"
		_set_upgrade_button_state(upgrade_purchase_button, "Max value x%d" % MAX_CLICK_VALUE, true)
		_update_bonus_upgrade_ui()
		return

	var next_value := unlocked_click_value + 1
	var upgrade_cost := _get_upgrade_cost(next_value)
	upgrade_button.text = "Upgrades"
	upgrade_cost_label.text = "Next click value: %s coins" % _format_number(upgrade_cost)
	_set_upgrade_button_state(upgrade_purchase_button, "Buy x%d" % next_value, coins < upgrade_cost, upgrade_cost)
	_update_bonus_upgrade_ui()


func _update_bonus_upgrade_ui() -> void:
	bonus_chance_label.text = "Bonus chance: %.1f%%" % _get_bonus_chance_percent()
	if bonus_chance_level >= MAX_BONUS_CHANCE_LEVEL:
		bonus_chance_cost_label.text = "Max bonus chance reached"
		_set_upgrade_button_state(bonus_chance_button, "Max chance 20%", true)
	else:
		var chance_cost: int = _get_bonus_chance_cost()
		bonus_chance_cost_label.text = "Next: %.1f%% for %s coins" % [_get_bonus_chance_percent(bonus_chance_level + 1), _format_number(chance_cost)]
		_set_upgrade_button_state(bonus_chance_button, "Upgrade chance", coins < chance_cost, chance_cost)

	bonus_value_label.text = "Bonus value: x%d" % _get_bonus_multiplier()
	if bonus_value_index >= BONUS_MULTIPLIERS.size() - 1:
		bonus_value_cost_label.text = "Max bonus value reached"
		_set_upgrade_button_state(bonus_value_button, "Max bonus x%d" % _get_bonus_multiplier(), true)
	else:
		var next_bonus: int = int(BONUS_MULTIPLIERS[bonus_value_index + 1])
		var value_cost: int = _get_bonus_value_cost()
		bonus_value_cost_label.text = "Next: x%d for %s coins" % [next_bonus, _format_number(value_cost)]
		_set_upgrade_button_state(bonus_value_button, "Upgrade bonus", coins < value_cost, value_cost)

	bonus_streak_label.text = "Bonus streak: x%d" % bonus_streak_multiplier
	if bonus_streak_multiplier >= MAX_BONUS_STREAK_MULTIPLIER:
		bonus_streak_cost_label.text = "Max streak bonus reached"
		_set_upgrade_button_state(bonus_streak_button, "Max streak x%d" % MAX_BONUS_STREAK_MULTIPLIER, true)
	else:
		var streak_cost: int = _get_bonus_streak_cost()
		bonus_streak_cost_label.text = "Next: x%d for %s coins" % [bonus_streak_multiplier + 1, _format_number(streak_cost)]
		_set_upgrade_button_state(bonus_streak_button, "Upgrade streak", coins < streak_cost, streak_cost)

	passive_gain_label.text = "Offline gain: %d/min" % passive_clicks_per_minute
	settings_passive_gain_label.text = "Offline gain: %d/min" % passive_clicks_per_minute
	if passive_clicks_per_minute >= MAX_PASSIVE_CLICKS_PER_MINUTE:
		passive_gain_cost_label.text = "Max offline gain reached"
		_set_upgrade_button_state(passive_gain_button, "Max offline %d/min" % MAX_PASSIVE_CLICKS_PER_MINUTE, true)
		settings_passive_gain_cost_label.text = "Max offline gain reached"
		_set_upgrade_button_state(settings_passive_gain_button, "Max offline %d/min" % MAX_PASSIVE_CLICKS_PER_MINUTE, true)
	else:
		var passive_cost: int = _get_passive_upgrade_cost()
		passive_gain_cost_label.text = "Next: %d/min for %s coins" % [passive_clicks_per_minute + 1, _format_number(passive_cost)]
		_set_upgrade_button_state(passive_gain_button, "Upgrade offline", coins < passive_cost, passive_cost)
		settings_passive_gain_cost_label.text = "Next: %d/min for %s coins" % [passive_clicks_per_minute + 1, _format_number(passive_cost)]
		_set_upgrade_button_state(settings_passive_gain_button, "Upgrade offline", coins < passive_cost, passive_cost)


func _set_upgrade_button_state(button: Button, ready_text: String, disabled: bool, cost: int = -1) -> void:
	button.disabled = disabled
	if disabled and cost > 0 and coins < cost:
		button.text = "Need %s more" % _format_number(cost - coins)
		return

	button.text = ready_text


func _setup_upgrade_info_popups() -> void:
	upgrade_info_button.pressed.connect(func() -> void:
		_show_info_popup("Click value", "Raises how many clicks every tap is worth.")
	)
	bonus_chance_info_button.pressed.connect(func() -> void:
		_show_info_popup("Bonus chance", "Raises the chance that a tap becomes a bonus.")
	)
	bonus_value_info_button.pressed.connect(func() -> void:
		_show_info_popup("Bonus value", "Makes each bonus click multiply your tap by more.")
	)
	bonus_streak_info_button.pressed.connect(func() -> void:
		_show_info_popup("Bonus streak", "If 2 of your last 5 taps are bonuses, the next bonus gets this extra multiplier.")
	)
	passive_gain_info_button.pressed.connect(func() -> void:
		_show_info_popup("Offline gain", "Earns coins while away, with a low capped time limit.")
	)


func _show_info_popup(title: String, description: String) -> void:
	var popup := Panel.new()
	popup.z_index = 40
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	click_popup_layer.add_child(popup)
	var popup_width := minf(size.x - 64.0, 460.0)
	popup.size = Vector2(popup_width, 240.0)
	popup.position = Vector2((size.x - popup_width) * 0.5, 270.0)
	popup.scale = Vector2(0.92, 0.92)
	popup.modulate.a = 0.0
	popup.pivot_offset = popup.size * 0.5

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.06, 0.08, 0.96)
	style.border_color = Color(0.42, 0.86, 1.0, 0.92)
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.45)
	style.shadow_size = 10
	popup.add_theme_stylebox_override("panel", style)

	var title_label := Label.new()
	title_label.text = title
	title_label.position = Vector2(18.0, 14.0)
	title_label.size = Vector2(popup.size.x - 86.0, 34.0)
	title_label.clip_text = true
	title_label.add_theme_font_size_override("font_size", 22)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.45, 1.0))
	popup.add_child(title_label)

	var body_label := RichTextLabel.new()
	body_label.text = description
	body_label.position = Vector2(22.0, 58.0)
	body_label.size = Vector2(popup.size.x - 44.0, 158.0)
	body_label.bbcode_enabled = false
	body_label.scroll_active = false
	body_label.fit_content = false
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_label.add_theme_font_size_override("normal_font_size", 19)
	body_label.add_theme_color_override("default_color", Color(0.9, 0.94, 1.0, 1.0))
	popup.add_child(body_label)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.position = Vector2(popup.size.x - 52.0, 12.0)
	close_button.size = Vector2(38.0, 38.0)
	popup.add_child(close_button)
	close_button.pressed.connect(func() -> void:
		if is_instance_valid(popup):
			popup.queue_free()
	)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "modulate:a", 1.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


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

	var lines: Array[String] = [
		"Total clicks: %s" % _format_number(total_taps),
		"Total score: %s" % _format_number(score),
		"Coins saved: %s" % _format_number(coins),
		"Best single click: %s" % _format_number(best_single_click),
		"Combo: x%.1f, resets after %.0fs" % [_get_combo_multiplier(), COMBO_RESET_SECONDS],
		"Click value: x%d / unlocked x%d" % [click_value, unlocked_click_value],
		"Bonus chance: %.1f%%" % _get_bonus_chance_percent(),
		"Bonus value: x%d" % _get_bonus_multiplier(),
		"Bonus clicks: %s (%.1f%%)" % [_format_number(total_bonus_clicks), bonus_rate],
		"Bonus streak boost: x%d" % bonus_streak_multiplier,
		"Bonus streak activations: %s" % _format_number(bonus_streak_activations),
		"Bonuses in last 5 clicks: %d" % _get_recent_bonus_count(),
		"Offline gain: %d/min, capped at %d hours" % [passive_clicks_per_minute, int(OFFLINE_GAIN_MAX_SECONDS / 3600)],
		"Daily reward streak: %d" % daily_reward_streak,
	]
	stats_list_label.text = "\n".join(lines)


func _update_daily_reward_ui() -> void:
	var reward := _get_daily_reward_amount(_get_next_daily_reward_streak())
	var available := _can_claim_daily_reward()
	daily_reward_label.text = "Daily reward streak: %d" % daily_reward_streak
	daily_reward_alert_label.visible = available
	if available:
		daily_reward_label.add_theme_color_override("font_color", Color(1.0, 0.16, 0.16, 1.0))
		daily_reward_alert_label.add_theme_color_override("font_color", Color(1.0, 0.05, 0.05, 1.0))
		daily_reward_button.disabled = false
		daily_reward_button.text = "! Claim %s coins" % _format_number(reward)
		daily_reward_timer_label.text = "Available now"
		daily_reward_timer_label.add_theme_color_override("font_color", Color(1.0, 0.16, 0.16, 1.0))
	else:
		daily_reward_label.add_theme_color_override("font_color", Color.WHITE)
		daily_reward_button.disabled = true
		daily_reward_button.text = "Claimed today"
		daily_reward_timer_label.text = "Next reward in %s" % _format_time_until_next_day()
		daily_reward_timer_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.68, 1.0))


func _show_startup_popups() -> void:
	if seen_tutorial_version < TUTORIAL_VERSION:
		_show_tutorial_popup(true)
		return

	_show_offline_gain_message()


func _show_tutorial_from_menu() -> void:
	_play_ui_sound()
	_show_tutorial_popup(false)


func _show_tutorial_popup(show_offline_after_close: bool) -> void:
	if tutorial_popup != null and is_instance_valid(tutorial_popup):
		tutorial_popup.queue_free()

	tutorial_page_index = 0
	tutorial_popup = Control.new()
	tutorial_popup.name = "TutorialPopup"
	tutorial_popup.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_popup.z_index = 100
	tutorial_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	click_popup_layer.add_child(tutorial_popup)

	var dim := ColorRect.new()
	dim.color = Color(0.0, 0.0, 0.0, 0.78)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	tutorial_popup.add_child(dim)

	var viewport_size := get_viewport_rect().size
	var panel := Panel.new()
	panel.name = "TutorialPanel"
	panel.size = Vector2(minf(viewport_size.x - 40.0, 560.0), minf(viewport_size.y - 120.0, 680.0))
	panel.position = (viewport_size - panel.size) * 0.5
	panel.pivot_offset = panel.size * 0.5
	panel.scale = Vector2(0.94, 0.94)
	panel.modulate.a = 0.0
	tutorial_popup.add_child(panel)

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.052, 0.065, 0.98)
	style.border_color = Color(0.42, 0.86, 1.0, 0.95)
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.5)
	style.shadow_size = 14
	panel.add_theme_stylebox_override("panel", style)

	var close_button := Button.new()
	close_button.name = "CloseButton"
	close_button.text = "X"
	close_button.size = Vector2(44.0, 44.0)
	close_button.position = Vector2(panel.size.x - 58.0, 14.0)
	close_button.add_theme_font_size_override("font_size", 20)
	panel.add_child(close_button)
	close_button.pressed.connect(func() -> void:
		_close_tutorial_popup(show_offline_after_close)
	)

	var title_label := Label.new()
	title_label.name = "TutorialTitle"
	title_label.position = Vector2(24.0, 24.0)
	title_label.size = Vector2(panel.size.x - 96.0, 50.0)
	title_label.clip_text = true
	title_label.add_theme_font_size_override("font_size", 30)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.94, 0.58, 1.0))
	panel.add_child(title_label)

	var body_label := RichTextLabel.new()
	body_label.name = "TutorialBody"
	body_label.position = Vector2(24.0, 88.0)
	body_label.size = Vector2(panel.size.x - 48.0, panel.size.y - 340.0)
	body_label.bbcode_enabled = false
	body_label.scroll_active = false
	body_label.fit_content = false
	body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_label.add_theme_font_size_override("normal_font_size", 21)
	body_label.add_theme_color_override("default_color", Color(0.92, 0.95, 1.0, 1.0))
	panel.add_child(body_label)

	var arrow_label := Label.new()
	arrow_label.name = "TutorialArrow"
	arrow_label.position = Vector2(24.0, panel.size.y - 268.0)
	arrow_label.size = Vector2(panel.size.x - 48.0, 34.0)
	arrow_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	arrow_label.add_theme_font_size_override("font_size", 24)
	arrow_label.add_theme_color_override("font_color", Color(0.42, 0.86, 1.0, 1.0))
	panel.add_child(arrow_label)

	var quest_label := RichTextLabel.new()
	quest_label.name = "TutorialQuest"
	quest_label.position = Vector2(24.0, panel.size.y - 228.0)
	quest_label.size = Vector2(panel.size.x - 48.0, 76.0)
	quest_label.bbcode_enabled = false
	quest_label.scroll_active = false
	quest_label.fit_content = false
	quest_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	quest_label.add_theme_font_size_override("normal_font_size", 18)
	quest_label.add_theme_color_override("default_color", Color(1.0, 0.9, 0.48, 1.0))
	panel.add_child(quest_label)

	var action_button := Button.new()
	action_button.name = "TutorialActionButton"
	action_button.size = Vector2(minf(panel.size.x - 48.0, 260.0), 46.0)
	action_button.position = Vector2((panel.size.x - action_button.size.x) * 0.5, panel.size.y - 116.0)
	action_button.add_theme_font_size_override("font_size", 19)
	panel.add_child(action_button)
	action_button.pressed.connect(_run_tutorial_action)

	var page_label := Label.new()
	page_label.name = "TutorialPage"
	page_label.position = Vector2(24.0, panel.size.y - 150.0)
	page_label.size = Vector2(panel.size.x - 48.0, 28.0)
	page_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	page_label.add_theme_font_size_override("font_size", 16)
	page_label.add_theme_color_override("font_color", Color(0.72, 0.78, 0.9, 1.0))
	panel.add_child(page_label)

	var back_button := Button.new()
	back_button.name = "BackButton"
	back_button.text = "Back"
	back_button.size = Vector2(132.0, 52.0)
	back_button.position = Vector2(24.0, panel.size.y - 70.0)
	back_button.add_theme_font_size_override("font_size", 20)
	panel.add_child(back_button)
	back_button.pressed.connect(func() -> void:
		tutorial_page_index = maxi(0, tutorial_page_index - 1)
		_refresh_tutorial_popup()
	)

	var next_button := Button.new()
	next_button.name = "NextButton"
	next_button.size = Vector2(156.0, 52.0)
	next_button.position = Vector2(panel.size.x - 180.0, panel.size.y - 70.0)
	next_button.add_theme_font_size_override("font_size", 20)
	panel.add_child(next_button)
	next_button.pressed.connect(func() -> void:
		var pages := _get_tutorial_pages()
		if tutorial_page_index >= pages.size() - 1:
			_close_tutorial_popup(show_offline_after_close)
			return

		tutorial_page_index += 1
		_refresh_tutorial_popup()
	)

	_refresh_tutorial_popup()
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _refresh_tutorial_popup() -> void:
	if tutorial_popup == null or not is_instance_valid(tutorial_popup):
		return

	var pages := _get_tutorial_pages()
	tutorial_page_index = clampi(tutorial_page_index, 0, pages.size() - 1)
	var panel := tutorial_popup.get_node("TutorialPanel") as Panel
	var title_label := panel.get_node("TutorialTitle") as Label
	var body_label := panel.get_node("TutorialBody") as RichTextLabel
	var arrow_label := panel.get_node("TutorialArrow") as Label
	var quest_label := panel.get_node("TutorialQuest") as RichTextLabel
	var action_button := panel.get_node("TutorialActionButton") as Button
	var page_label := panel.get_node("TutorialPage") as Label
	var back_button := panel.get_node("BackButton") as Button
	var next_button := panel.get_node("NextButton") as Button
	var page: Dictionary = pages[tutorial_page_index]

	title_label.text = str(page["title"])
	body_label.text = str(page["body"])
	arrow_label.text = str(page.get("arrow", ""))
	var page_id := str(page.get("id", tutorial_page_index))
	var quest_done := bool(tutorial_quest_completed.get(page_id, false))
	var quest_prefix := "Quest complete: " if quest_done else "Quest: "
	quest_label.text = quest_prefix + str(page.get("quest", "Read this page."))
	action_button.text = str(page.get("action", "Try it"))
	action_button.visible = str(page.get("action", "")) != ""
	page_label.text = "%d / %d" % [tutorial_page_index + 1, pages.size()]
	back_button.disabled = tutorial_page_index <= 0
	next_button.text = "Finish" if tutorial_page_index >= pages.size() - 1 else "Next"
	_pop_control(title_label, Vector2(1.035, 1.035), 0.12)


func _run_tutorial_action() -> void:
	if tutorial_popup == null or not is_instance_valid(tutorial_popup):
		return

	var pages := _get_tutorial_pages()
	if tutorial_page_index < 0 or tutorial_page_index >= pages.size():
		return

	var page: Dictionary = pages[tutorial_page_index]
	var page_id := str(page.get("id", tutorial_page_index))
	tutorial_quest_completed[page_id] = true
	match page_id:
		"tap":
			_release_cat_pop(false)
			_spawn_tutorial_feedback("+1 click")
			_play_cat_sound()
		"upgrades":
			_spawn_tutorial_feedback("Open Upgrades from pause")
		"combo":
			for _i in range(COMBO_CLICKS_PER_STEP):
				_increase_combo()
			_spawn_tutorial_feedback("Combo step gained")
		"bonus":
			_spawn_tutorial_feedback("Bonus numbers pop bigger")
			_play_bonus_sound()
		"streak":
			_spawn_tutorial_feedback("2 bonuses in 5 taps = streak")
		"daily":
			_spawn_tutorial_feedback("Look for the red !")
		"offline":
			_spawn_tutorial_feedback("Return later for offline coins")
		"pause":
			_spawn_tutorial_feedback("Tutorial can be replayed")
		_:
			_spawn_tutorial_feedback("Quest complete")

	_refresh_tutorial_popup()


func _spawn_tutorial_feedback(text: String) -> void:
	if tutorial_popup == null or not is_instance_valid(tutorial_popup):
		return

	var panel := tutorial_popup.get_node("TutorialPanel") as Panel
	var feedback := Label.new()
	feedback.text = text
	feedback.z_index = 110
	feedback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	feedback.add_theme_font_size_override("font_size", 24)
	feedback.add_theme_color_override("font_color", Color(1.0, 0.9, 0.2, 1.0))
	feedback.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	feedback.add_theme_constant_override("shadow_offset_x", 2)
	feedback.add_theme_constant_override("shadow_offset_y", 2)
	feedback.size = Vector2(panel.size.x - 48.0, 40.0)
	feedback.position = Vector2(24.0, panel.size.y * 0.48)
	panel.add_child(feedback)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(feedback, "position:y", feedback.position.y - 42.0, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(feedback, "modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(Callable(feedback, "queue_free"))


func _close_tutorial_popup(show_offline_after_close: bool) -> void:
	if tutorial_popup != null and is_instance_valid(tutorial_popup):
		tutorial_popup.queue_free()

	tutorial_popup = null
	if seen_tutorial_version < TUTORIAL_VERSION:
		seen_tutorial_version = TUTORIAL_VERSION
		_save_game()

	if show_offline_after_close:
		_show_offline_gain_message()


func _get_tutorial_pages() -> Array[Dictionary]:
	return [
		{
			"id": "tap",
			"title": "Welcome to Clicker",
			"body": "Tap the cat to earn clicks and coins. The big cat is the main button, so tap fast and keep the rhythm going.",
			"arrow": ">>> Main target: the cat",
			"quest": "Press Try Tap to feel one practice tap.",
			"action": "Try Tap"
		},
		{
			"id": "upgrades",
			"title": "Coins and Upgrades",
			"body": "Coins are used in Upgrades. Buy click value to make every tap stronger. Use Settings to choose how much unlocked click power you want active.",
			"arrow": ">>> Pause menu -> Upgrades",
			"quest": "Remember where the Upgrades button is.",
			"action": "Mark Found"
		},
		{
			"id": "combo",
			"title": "Combo Meter",
			"body": "Every 10 taps adds +0.1x combo, up to +1.5x. After you stop tapping, the combo waits 1 second, then drains until it reaches x1.0.",
			"arrow": ">>> Watch the combo under Clicks",
			"quest": "Try a demo combo step.",
			"action": "Demo Combo"
		},
		{
			"id": "bonus",
			"title": "Bonus Clicks",
			"body": "Bonus chance decides how often a tap becomes a bonus. Bonus value decides how strong that bonus is. Bigger bonuses make bigger, brighter numbers.",
			"arrow": ">>> Upgrade chance and value",
			"quest": "Preview the bonus feedback.",
			"action": "Show Bonus"
		},
		{
			"id": "streak",
			"title": "Bonus Streak",
			"body": "If at least 2 of your last 5 taps are bonuses, the next bonus gets the Bonus Streak multiplier. Upgrade it from x2 up to x10.",
			"arrow": ">>> Bonus streak watches last 5 taps",
			"quest": "Learn the streak rule.",
			"action": "Got It"
		},
		{
			"id": "daily",
			"title": "Daily Rewards",
			"body": "Open the pause menu to claim your daily reward. A red ! means it is ready. The timer shows when the next one unlocks.",
			"arrow": ">>> Red ! means reward ready",
			"quest": "Find the daily reward area in pause.",
			"action": "I See It"
		},
		{
			"id": "offline",
			"title": "Offline Gain",
			"body": "Offline gain earns coins while you are away, but only up to the time cap. When you return, a popup shows exactly how much you gained.",
			"arrow": ">>> Upgrade offline gain in the shop",
			"quest": "Remember: offline gain is capped.",
			"action": "Remember"
		},
		{
			"id": "pause",
			"title": "Pause Menu",
			"body": "Use Pause for Settings, Upgrades, Achievements, Stats, and this Tutorial. You can replay this tutorial anytime from the pause menu.",
			"arrow": ">>> Pause button opens everything",
			"quest": "Replay this tutorial whenever you need it.",
			"action": "All Set"
		}
	]


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
	coins += reward
	score += reward
	_update_score()
	_update_coins()
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
	_update_coins()
	_update_upgrade_ui()
	_update_achievements_ui()
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
	_update_coins()
	_update_upgrade_ui()
	_update_achievements_ui()
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
	_update_coins()
	_update_upgrade_ui()
	_update_achievements_ui()
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
	_update_coins()
	_update_upgrade_ui()
	_update_achievements_ui()
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
	_update_coins()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
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

	var pop_scale := CAT_POP_SCALE if is_bonus else Vector2(1.055, 1.055)
	cat_tween = create_tween()
	cat_tween.set_parallel(true)
	cat_tween.set_trans(Tween.TRANS_BACK)
	cat_tween.set_ease(Tween.EASE_OUT)
	cat_tween.tween_property(cat_button, "scale", cat_base_scale * pop_scale, 0.075)
	cat_tween.tween_property(cat_button, "rotation", 0.0, 0.13)
	cat_tween.chain().tween_property(cat_button, "scale", cat_base_scale, 0.13).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


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
	_set_responsive_panel_size(menu_panel, Vector2(440.0, 660.0), panel_width, panel_height)
	_set_responsive_panel_size(settings_panel, Vector2(470.0, 800.0), panel_width, panel_height)
	_set_responsive_panel_size(upgrades_panel, Vector2(560.0, 980.0), panel_width, panel_height)
	_set_responsive_panel_size(achievements_panel, Vector2(520.0, 620.0), panel_width, panel_height)
	_set_responsive_panel_size(stats_panel, Vector2(520.0, 620.0), panel_width, panel_height)

	var tap_width := minf(600.0, viewport_size.x - 64.0)
	cat_button.custom_minimum_size = Vector2(maxf(300.0, tap_width), maxf(360.0, tap_width * 1.08))
	menu_button.custom_minimum_size = Vector2(96.0, 96.0)
	upgrade_button.custom_minimum_size = Vector2(300.0, 64.0)


func _set_responsive_panel_size(panel: Control, preferred_size: Vector2, max_width: float, max_height: float) -> void:
	panel.custom_minimum_size = Vector2(minf(preferred_size.x, max_width), minf(preferred_size.y, max_height))


func _spawn_click_popup(amount: int, bonus_multiplier: int = 1, streak_multiplier: int = 1, current_combo_bonus: float = 0.0) -> void:
	var popup := Label.new()
	popup.text = "+%s" % _format_number(amount)
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.z_index = 20
	var font_size := 42
	if streak_multiplier > 1:
		font_size = 42 + ((streak_multiplier - 1) * 4)
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
		popup.text = "+%s  STREAK x%d" % [_format_number(amount), streak_multiplier]

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
	var start_scale := 0.82 + (float(streak_multiplier - 1) * 0.04) + combo_heat * 0.08
	popup.scale = Vector2(start_scale, start_scale)

	var drift: Vector2 = Vector2(randf_range(-24.0, 24.0), randf_range(-130.0, -92.0))
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position", popup.position + drift, 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var end_scale := 1.12 + (float(streak_multiplier - 1) * 0.08) + combo_heat * 0.12
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


func _show_settings() -> void:
	_play_ui_sound()
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(settings_panel)


func _show_upgrades() -> void:
	_play_ui_sound()
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(upgrades_panel)


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


func _show_overlay_panel(panel: Control) -> void:
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
	menu_overlay.hide()


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
	save_file.set_value(SAVE_SECTION, SAVE_SEEN_TUTORIAL_VERSION_KEY, seen_tutorial_version)
	save_file.set_value(SAVE_SECTION, SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY, passive_clicks_per_minute)
	save_file.set_value(SAVE_SECTION, SAVE_LAST_SEEN_UNIX_KEY, _get_unix_time())
	save_file.set_value(SAVE_SECTION, SAVE_LAST_DAILY_REWARD_DAY_KEY, last_daily_reward_day)
	save_file.set_value(SAVE_SECTION, SAVE_DAILY_REWARD_STREAK_KEY, daily_reward_streak)
	save_file.set_value(SAVE_SECTION, SAVE_CLICK_VOLUME_KEY, click_volume)
	save_file.set_value(SAVE_SECTION, SAVE_UI_VOLUME_KEY, ui_volume)

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
	seen_tutorial_version = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_SEEN_TUTORIAL_VERSION_KEY, 0)))
	passive_clicks_per_minute = int(save_file.get_value(SAVE_SECTION, SAVE_PASSIVE_CLICKS_PER_MINUTE_KEY, 1))
	passive_clicks_per_minute = clampi(passive_clicks_per_minute, 1, MAX_PASSIVE_CLICKS_PER_MINUTE)
	last_daily_reward_day = int(save_file.get_value(SAVE_SECTION, SAVE_LAST_DAILY_REWARD_DAY_KEY, -1))
	daily_reward_streak = maxi(0, int(save_file.get_value(SAVE_SECTION, SAVE_DAILY_REWARD_STREAK_KEY, 0)))
	_apply_offline_gain(int(save_file.get_value(SAVE_SECTION, SAVE_LAST_SEEN_UNIX_KEY, _get_unix_time())))
	click_volume = clamp(float(save_file.get_value(SAVE_SECTION, SAVE_CLICK_VOLUME_KEY, 1.0)), 0.0, 1.0)
	ui_volume = clamp(float(save_file.get_value(SAVE_SECTION, SAVE_UI_VOLUME_KEY, 1.0)), 0.0, 1.0)


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
