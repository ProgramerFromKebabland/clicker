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
@onready var upgrade_info_button: Button = %UpgradeInfoButton
@onready var upgrade_cost_label: Label = %UpgradeCostLabel
@onready var upgrade_purchase_button: Button = %UpgradePurchaseButton
@onready var click_progress_bar: ProgressBar = %ClickProgressBar
@onready var bonus_chance_label: Label = %BonusChanceLabel
@onready var bonus_chance_info_button: Button = %BonusChanceInfoButton
@onready var bonus_chance_cost_label: Label = %BonusChanceCostLabel
@onready var bonus_chance_button: Button = %BonusChanceButton
@onready var bonus_chance_progress_bar: ProgressBar = %BonusChanceProgressBar
@onready var bonus_value_label: Label = %BonusValueLabel
@onready var bonus_value_info_button: Button = %BonusValueInfoButton
@onready var bonus_value_cost_label: Label = %BonusValueCostLabel
@onready var bonus_value_button: Button = %BonusValueButton
@onready var bonus_value_progress_bar: ProgressBar = %BonusValueProgressBar
@onready var bonus_streak_label: Label = %BonusStreakLabel
@onready var bonus_streak_info_button: Button = %BonusStreakInfoButton
@onready var bonus_streak_cost_label: Label = %BonusStreakCostLabel
@onready var bonus_streak_button: Button = %BonusStreakButton
@onready var bonus_streak_progress_bar: ProgressBar = %BonusStreakProgressBar
@onready var passive_gain_label: Label = %PassiveGainLabel
@onready var passive_gain_info_button: Button = %PassiveGainInfoButton
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
const SAVE_LAST_SEEN_UNIX_KEY := "last_seen_unix"
const SAVE_LAST_DAILY_REWARD_DAY_KEY := "last_daily_reward_day"
const SAVE_DAILY_REWARD_STREAK_KEY := "daily_reward_streak"
const SAVE_CLICK_VOLUME_KEY := "click_volume"
const SAVE_UI_VOLUME_KEY := "ui_volume"
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
const BASE_PASSIVE_UPGRADE_COST := 250
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
@onready var save_timer: Timer = %SaveTimer
@onready var daily_reward_timer: Timer = %DailyRewardTimer
@onready var combo_timer: Timer = %ComboTimer
var cat_tween: Tween
var score_tween: Tween
var coins_tween: Tween
var hud_coin_tween: Tween
var upgrade_ambient_tween: Tween
var coin_counter_tween: Tween
var displayed_coins: int = -1
var upgrade_alert_active := false
var upgrade_alert_elapsed := 0.0
var upgrade_alert_shake_tween: Tween
var stats_card_controls: Array[Control] = []
var mobile_panels_wrapped := false


# SAVE DATA AND SMALL SHARED HELPERS


# NUMBER FORMATTING


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


# SAVE AND LOAD


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


# TIME AND OFFLINE HELPERS


func _get_offline_info_text() -> String:
	var max_minutes := int(OFFLINE_GAIN_MAX_SECONDS / 60)
	var max_gain := passive_clicks_per_minute * max_minutes
	return "Offline gain is capped at %d hours: up to %s coins." % [int(OFFLINE_GAIN_MAX_SECONDS / 3600), _format_number(max_gain)]


func _get_unix_time() -> int:
	return int(Time.get_unix_time_from_system())


func _get_current_day_number() -> int:
	return floori(float(_get_unix_time()) / 86400.0)
