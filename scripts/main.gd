extends Control

const ClickLogic = preload("res://scripts/systems/click_logic.gd")
const UpgradeLogic = preload("res://scripts/systems/upgrade_logic.gd")
const AchievementLogic = preload("res://scripts/systems/achievement_logic.gd")
const SaveLogic = preload("res://scripts/systems/save_logic.gd")
const BigCounter = preload("res://scripts/systems/big_counter.gd")
const RewardLogic = preload("res://scripts/systems/reward_logic.gd")
const UI_SOUND_VARIANTS: Array[AudioStream] = [
	preload("res://assets/ui_soft.wav"),
	preload("res://assets/ui_confirm.wav"),
	preload("res://assets/ui_panel.wav"),
]
const UiLogic = preload("res://scripts/systems/ui_logic.gd")
const BoostLogic = preload("res://scripts/systems/boost_logic.gd")
const CrateLogic = preload("res://scripts/systems/crate_logic.gd")
const MissionLogic = preload("res://scripts/systems/mission_logic.gd")
const RandomEventLogic = preload("res://scripts/systems/random_event_logic.gd")
const BottomlessBowlLogic = preload("res://scripts/systems/bottomless_bowl_logic.gd")
const TelegramNavigation = preload("res://scripts/telegram_navigation.gd")
const BOOSTS_UI_ICON = preload("res://assets/ui/boosts.png")
const MUSEUM_UI_ICON = preload("res://assets/ui/museum.png")
const BACKPACK_UI_ICON = preload("res://assets/ui/navigation/backpack.svg")
const BOOST_TIER_ICONS := {
	"classical": preload("res://assets/boosts/boost_classical.png"),
	"advanced": preload("res://assets/boosts/boost_advanced.png"),
	"legendary": preload("res://assets/boosts/boost_legendary.png"),
	"mythic": preload("res://assets/boosts/boost_mythic.png"),
	"ascendant": preload("res://assets/boosts/boost_mythic.png"),
}
const UPGRADE_CATEGORIES: Array[String] = [
	"classical", "advanced", "legendary", "mythic", "ascendant",
	"divine", "cosmic", "eternal", "transcendent", "omega",
]
const BOOST_CATEGORIES: Array[String] = ["classical", "advanced", "legendary", "mythic", "ascendant"]
const BOOST_ICONS := {
	"cat_frenzy": preload("res://assets/boosts/custom/cat_frenzy.png"),
	"lucky_paws": preload("res://assets/boosts/custom/lucky_paws.png"),
	"time_freeze": preload("res://assets/boosts/custom/time_freeze.png"),
	"purrstorm": preload("res://assets/boosts/custom/purrstorm.png"),
	"golden_meow": preload("res://assets/boosts/custom/golden_meow.png"),
	"whisker_rush": preload("res://assets/boosts/custom/whisker_rush.png"),
	"nine_lives": preload("res://assets/boosts/custom/nine_lives.png"),
	"kibble_storm": preload("res://assets/boosts/custom/kibble_storm.png"),
	"combo_nova": preload("res://assets/boosts/custom/combo_nova.png"),
	"streak_surge": preload("res://assets/boosts/custom/streak_surge.png"),
	"jackpot_engine": preload("res://assets/boosts/custom/jackpot_engine.png"),
	"combo_overclock": preload("res://assets/boosts/custom/combo_overclock.png"),
	"payday_pulse": preload("res://assets/boosts/custom/payday_pulse.png"),
	"meteor_paws": preload("res://assets/boosts/custom/meteor_paws.png"),
	"gem_magnet": preload("res://assets/boosts/custom/gem_magnet.png"),
	"lucky_lock": preload("res://assets/boosts/custom/lucky_lock.png"),
	"royal_treat": preload("res://assets/boosts/custom/royal_treat.png"),
	"supernova_paws": preload("res://assets/boosts/custom/supernova_paws.png"),
	"fortune_orbit": preload("res://assets/boosts/custom/fortune_orbit.png"),
	"royal_banquet": preload("res://assets/boosts/custom/royal_banquet.png"),
	"quantum_frenzy": preload("res://assets/boosts/custom/quantum_frenzy.png"),
	"infinite_fortune": preload("res://assets/boosts/custom/infinite_fortune.png"),
	"celestial_rain": preload("res://assets/boosts/custom/celestial_rain.png"),
	"ghost_army": preload("res://assets/boosts/custom/ghost_army.png"),
	"jackpot_overdrive": preload("res://assets/boosts/custom/jackpot_overdrive.png"),
	"combo_singularity": preload("res://assets/boosts/custom/combo_singularity.png"),
	"time_emperor": preload("res://assets/boosts/custom/time_emperor.png"),
	"prismatic_frenzy": preload("res://assets/boosts/custom/prismatic_frenzy.png"),
	"solar_fortune": preload("res://assets/boosts/custom/solar_fortune.png"),
	"nebula_rain": preload("res://assets/boosts/custom/nebula_rain.png"),
	"citadel_jackpot": preload("res://assets/boosts/custom/citadel_jackpot.png"),
	"gravity_surge": preload("res://assets/boosts/custom/gravity_surge.png"),
	"starlight_army": preload("res://assets/boosts/custom/starlight_army.png"),
	"galaxy_frenzy": preload("res://assets/boosts/custom/galaxy_frenzy.png"),
	"miracle_fortune": preload("res://assets/boosts/custom/miracle_fortune.png"),
	"infinity_rain": preload("res://assets/boosts/custom/infinity_rain.png"),
	"crown_overdrive": preload("res://assets/boosts/custom/crown_overdrive.png"),
	"singularity_surge": preload("res://assets/boosts/custom/singularity_surge.png"),
	"eternity_army": preload("res://assets/boosts/custom/eternity_army.png"),
}
const SKINS_UI_ICON = preload("res://assets/ui/skins.png")
const SETTINGS_ICON_SHEET_PATH := "res://assets/ui/settings_icons.png"
const SETTINGS_PAGE_LABELS: Array[String] = ["General", "Performance", "Audio", "Controls"]
const NORMAL_SHELL_BACKGROUND := Color(0.018, 0.021, 0.028, 1.0)
const NORMAL_SHELL_SURFACE := Color(0.035, 0.038, 0.045, 0.98)
const NORMAL_SHELL_RAISED := Color(0.06, 0.066, 0.078, 0.98)
const NORMAL_SHELL_TEXT := Color(0.94, 0.97, 1.0, 1.0)
const NORMAL_SHELL_MUTED := Color(0.64, 0.68, 0.75, 1.0)
const NORMAL_SHELL_GOLD := Color(0.95, 0.72, 0.3, 1.0)

var telegram_navigation: Control
var telegram_page_transition: Tween
var telegram_pager_host: Control
var telegram_current_panel: Control
var telegram_pending_direction := 0
var telegram_transition_serial := 0
var telegram_main_transition_nodes: Array[Control] = []
var telegram_main_base_positions: Dictionary = {}
var telegram_swipe_dragging := false
var telegram_swipe_direction := 0
var telegram_swipe_neighbor_destination := ""
var telegram_swipe_outgoing_panel: Control
var telegram_swipe_incoming_panel: Control
var telegram_swipe_drag_x := 0.0
var telegram_swipe_velocity_x := 0.0
var telegram_top_height := 132.0
var telegram_bottom_height := 78.0
var pause_dim: ColorRect
var pause_popup_open := false
var pause_opened_over_page := false
var settings_shell: ColorRect
var settings_action_bar: PanelContainer
var settings_action_safe_margin: MarginContainer
var settings_tabs_bar: PanelContainer
var settings_tabs_scroll: ScrollContainer
var settings_tabs_row: HBoxContainer
var settings_tab_indicator: PanelContainer
var settings_tab_buttons: Array[Button] = []
var settings_pager_host: Control
var settings_pages: Array[Control] = []
var settings_page_contents: Array[VBoxContainer] = []
var settings_page_margins: Array[MarginContainer] = []
var settings_general_group: PanelContainer
var settings_current_page := 0
var settings_page_tween: Tween
var settings_shell_tween: Tween
var settings_swipe_start := Vector2.ZERO
var settings_swipe_tracking := false
var settings_swipe_dragging := false
var settings_swipe_direction := 0
var settings_swipe_neighbor := -1
var settings_swipe_drag_x := 0.0
var settings_swipe_velocity_x := 0.0
var settings_back_to_pause := false
var pause_detail_shell: ColorRect
var pause_detail_action_bar: PanelContainer
var pause_detail_action_safe_margin: MarginContainer
var pause_detail_title: Label
var pause_detail_host: Control
var pause_detail_current: Control
var pause_detail_tween: Tween
var pause_detail_back_to_pause := false
var upgrade_category_buttons: Dictionary = {}
var boost_category_buttons: Dictionary = {}
var upgrade_active_category := "classical"
var boost_active_category := "classical"

@onready var score_label: Label = %ScoreLabel
@onready var room_background: TextureRect = %RoomBackground
@onready var combo_label: Label = %ComboLabel
@onready var combo_timer_label: Label = %ComboTimerLabel
@onready var combo_progress_bar: ProgressBar = %ComboProgressBar
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
@onready var upgrades_items: VBoxContainer = $MenuOverlay/MenuCenter/UpgradesPanel/UpgradesMargin/UpgradesItems
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
@onready var achievements_summary: PanelContainer = %AchievementsSummary
@onready var achievements_list: ItemList = %AchievementsList
@onready var achievements_progress_label: Label = %AchievementsProgressLabel
@onready var achievements_progress_bar: ProgressBar = %AchievementsProgressBar
@onready var achievements_filter: OptionButton = %AchievementsFilter
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
@onready var reward_redeem_sound: AudioStreamPlayer = %RewardRedeemSound
@onready var purchase_sound: AudioStreamPlayer = %PurchaseSound
@onready var crate_open_sound: AudioStreamPlayer = %CrateOpenSound
@onready var gem_reveal_sound: AudioStreamPlayer = %GemRevealSound
@onready var gem_discovery_sound: AudioStreamPlayer = %GemDiscoverySound

const SAVE_PATH := "user://clicker_progress.cfg"
const SAVE_SECTION := "progress"
const SAVE_SCORE_KEY := "score"
const SAVE_COINS_KEY := "coins"
const SAVE_SCORE_BIG_KEY := "score_big"
const SAVE_COINS_BIG_KEY := "coins_big"
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
const SAVE_BEST_COIN_BALANCE_BIG_KEY := "best_coin_balance_big"
const SAVE_LAST_SEEN_UNIX_KEY := "last_seen_unix"
const SAVE_LAST_DAILY_REWARD_DAY_KEY := "last_daily_reward_day"
const SAVE_DAILY_REWARD_STREAK_KEY := "daily_reward_streak"
const SAVE_BEST_DAILY_REWARD_STREAK_KEY := "best_daily_reward_streak"
const SAVE_CLICK_VOLUME_KEY := "click_volume"
const SAVE_UI_VOLUME_KEY := "ui_volume"
const SAVE_MASTER_VOLUME_KEY := "master_volume"
const SAVE_CLICK_SOUNDS_ENABLED_KEY := "click_sounds_enabled"
const SAVE_UI_SOUNDS_ENABLED_KEY := "ui_sounds_enabled"
const SAVE_MUTE_UNFOCUSED_KEY := "mute_unfocused"
const SAVE_LOW_QUALITY_ENABLED_KEY := "low_quality_enabled"
const SAVE_BATTERY_SAVER_ENABLED_KEY := "battery_saver_enabled"
const SAVE_OPTIMIZED_TAP_EFFECTS_KEY := "optimized_tap_effects"
const SAVE_REDUCE_MOTION_ENABLED_KEY := "reduce_motion_enabled"
const SAVE_BACKGROUND_EFFECTS_ENABLED_KEY := "background_effects_enabled"
const SAVE_LOW_POWER_UNFOCUSED_KEY := "low_power_unfocused"
const SAVE_PARTICLE_LIMIT_KEY := "particle_limit"
const SAVE_HAPTICS_ENABLED_KEY := "haptics_enabled"
const SAVE_HAPTIC_STRENGTH_KEY := "haptic_strength"
const SAVE_EVENTS_ENABLED_KEY := "events_enabled"
const SAVE_FLOATING_NUMBERS_ENABLED_KEY := "floating_numbers_enabled"
const SAVE_COIN_TRAILS_ENABLED_KEY := "coin_trails_enabled"
const SAVE_MENU_SWIPE_ENABLED_KEY := "menu_swipe_enabled"
const SAVE_REVERSE_SLIDERS_ENABLED_KEY := "reverse_sliders_enabled"
const SAVE_SLIDER_SOUND_STYLE_KEY := "slider_sound_style"
const SAVE_ABBREVIATE_NUMBERS_KEY := "abbreviate_numbers"
const SAVE_NUMBER_DETAIL_DIGITS_KEY := "number_detail_digits"
const SAVE_EXACT_NUMBER_TOOLTIPS_KEY := "exact_number_tooltips"
const SAVE_GROUP_FULL_NUMBERS_KEY := "group_full_numbers"
const SAVE_OWNED_SKINS_KEY := "owned_skins"
const SAVE_EQUIPPED_SKIN_KEY := "equipped_skin"
const SAVE_EQUIPPED_ROOM_SKIN_KEY := "equipped_room_skin"
const SAVE_EXTENDED_UPGRADES_KEY := "extended_upgrades"
const SAVE_FOOD_INVENTORY_KEY := "food_inventory"
const SAVE_TUTORIAL_COMPLETED_KEY := "tutorial_completed"
const SAVE_095_BALANCE_MIGRATION_KEY := "migration_095_balance_applied"
const UPDATE_095_RESOURCE_CAP := 100000000
const ADMIN_MIN_AMOUNT := 1
const ADMIN_CLICK_SOFT_MAX := 1000000000000
const MAX_RESOURCE_VALUE := 9223372036854775807
const MAX_FULL_NUMBER_DIGITS := 21
const MIN_NUMBER_DETAIL_DIGITS := 3
const MAX_NUMBER_DETAIL_DIGITS := 9
const DEFAULT_NUMBER_DETAIL_DIGITS := 7
# Familiar suffixes stay readable through trillions. Larger magnitudes use a
# steadily rising exponent (e15, e16, ...) instead of increasingly obscure names.
const NUMBER_SUFFIXES: Array[String] = ["", "K", "M", "B", "T"]
const SAVE_DELAY_SECONDS := 0.8
const COMBO_STEP := 0.1
const COMBO_CLICKS_PER_STEP := 8
const MAX_COMBO_BONUS := 1.5
const COMBO_DRAIN_GRACE_SECONDS := 1.35
const COMBO_RESET_SECONDS := 3.0
const COMBO_DRAIN_INTERVAL := 0.18
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
const MAX_EXTENDED_UPGRADE_LEVEL := 10
const MAX_COMBO_MOMENTUM_LEVEL := MAX_EXTENDED_UPGRADE_LEVEL
const MAX_OFFLINE_STORAGE_LEVEL := MAX_EXTENDED_UPGRADE_LEVEL
const DAILY_REWARD_BASE_COINS := 100
const DAILY_REWARD_STREAK_BONUS := 25
const BONUS_MULTIPLIERS := [2, 3, 5, 25, 100]
const BONUS_VALUE_COSTS := [500, 2500, 15000, 100000]
const CAT_PRESS_SCALE := Vector2(0.955, 0.955)
const CAT_POP_SCALE := Vector2(1.035, 1.035)
const CAT_BONUS_POP_SCALE := Vector2(1.07, 1.07)
const CLICK_UPGRADE_COLOR := Color(0.25, 0.78, 1.0, 1.0)
const CHANCE_UPGRADE_COLOR := Color(1.0, 0.66, 0.2, 1.0)
const VALUE_UPGRADE_COLOR := Color(1.0, 0.32, 0.48, 1.0)
const STREAK_UPGRADE_COLOR := Color(0.98, 0.86, 0.16, 1.0)
const PASSIVE_UPGRADE_COLOR := Color(0.3, 0.9, 0.5, 1.0)
const FOOD_NAMES := [
	"Tuna Bite", "Salmon Roll", "Chicken Cube", "Turkey Snack", "Beef Nibble",
	"Sardine Star", "Shrimp Puff", "Cream Spoon", "Cheese Dot", "Egg Flake",
	"Pumpkin Mash", "Carrot Crunch", "Apple Slice", "Berry Pop", "Honey Drop",
	"Rice Ball", "Noodle Curl", "Seaweed Chip", "Mackerel Moon", "Cod Coin",
	"Trout Toast", "Duck Strip", "Lamb Crumb", "Bacon Bit", "Ham Heart",
	"Yogurt Swirl", "Milk Pearl", "Butter Toast", "Cookie Crumb", "Donut Dot",
	"Pizza Pocket", "Burger Button", "Taco Treat", "Sushi Square", "Kebab Cube",
	"Ice Cream Bean", "Watermelon Wedge", "Banana Button", "Popcorn Puff", "Coffee Bean",
	"Royal Jelly", "Golden Kibble", "Lucky Biscuit", "Meteor Meatball", "Nova Nugget",
	"Dream Dumpling", "Orbit Orange", "Galaxy Gel", "Void Velvet", "Celestial Cake",
	"Moonlight Morsel", "Starlight Salmon", "Comet Cookie", "Asteroid Anchovy", "Rocket Ravioli",
	"Planetary Pudding", "Nebula Noodle", "Cosmic Croissant", "Solar Sardine", "Lunar Lasagna",
	"Rainbow Ration", "Prism Pretzel", "Crystal Cupcake", "Diamond Dumpling", "Ruby Roll",
	"Sapphire Snack", "Emerald Egg", "Amethyst Apple", "Topaz Toast", "Pearl Pastry",
	"King's Kibble", "Queen's Quiche", "Prince's Pizza", "Duchess Donut", "Baron's Biscuit",
	"Knight's Nibble", "Wizard Waffle", "Dragon Drumstick", "Phoenix Fillet", "Unicorn Udon",
	"Mermaid Mackerel", "Kraken Kebab", "Goblin Gumdrop", "Fairy Flan", "Golem Granola",
	"Ninja Nacho", "Samurai Sushi", "Pirate Pancake", "Viking Veggie", "Astronaut Almond",
	"Cyber Cheese", "Neon Nugget", "Quantum Quesadilla", "Pixel Pudding", "Turbo Tuna",
	"Inferno Ice Cream", "Frostbite Fish", "Thunder Tart", "Eclipse Eclair", "Infinity Souffle",
]
const FOOD_BOOSTS := [
	{"id": "snack_click", "name": "Tap boost", "text": "+35% taps", "duration": 18.0},
	{"id": "snack_luck", "name": "Luck boost", "text": "+12% bonus luck", "duration": 18.0},
	{"id": "snack_combo", "name": "Combo boost", "text": "+25% combo power", "duration": 18.0},
	{"id": "snack_kibble", "name": "Kibble boost", "text": "+30% all kibbles", "duration": 18.0},
	{"id": "snack_bonus", "name": "Bonus boost", "text": "+20% bonus payout", "duration": 18.0},
]
const FOOD_COST := 5000
const EXTENDED_UPGRADE_DATA: Array[Dictionary] = [
	{"id": "tap_mastery", "badge": "TAP+", "name": "TAP MASTERY", "accent": Color(0.22, 0.86, 0.92, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 2500},
	{"id": "combo_capacity", "badge": "CAP", "name": "COMBO CAPACITY", "accent": Color(0.72, 0.46, 1.0, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 4000},
	{"id": "combo_momentum", "badge": "FLOW", "name": "COMBO MOMENTUM", "accent": Color(1.0, 0.48, 0.72, 1.0), "max_level": MAX_COMBO_MOMENTUM_LEVEL, "base_cost": 6500},
	{"id": "daily_feast", "badge": "DAY", "name": "DAILY FEAST", "accent": Color(1.0, 0.58, 0.22, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 5000},
	{"id": "offline_storage", "badge": "TIME", "name": "OFFLINE STORAGE", "accent": Color(0.38, 0.72, 1.0, 1.0), "max_level": MAX_OFFLINE_STORAGE_LEVEL, "base_cost": 10000},
	{"id": "kibble_alchemy", "badge": "ALL+", "name": "KIBBLE ALCHEMY", "accent": Color(0.35, 1.0, 0.68, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 18000},
	{"id": "lucky_whiskers", "badge": "LUCK+", "name": "LUCKY WHISKERS", "accent": Color(1.0, 0.75, 0.22, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 22000},
	{"id": "dream_engine", "badge": "IDLE+", "name": "DREAM ENGINE", "accent": Color(0.42, 0.68, 1.0, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 30000},
	{"id": "quantum_paws", "category": "advanced", "badge": "Q-TAP", "name": "QUANTUM PAWS", "description": "Permanently increases all tap earnings by 15% per level.", "accent": Color(0.25, 0.95, 1.0), "max_level": 5, "base_cost": 2500000, "effect": "tap", "amount": 0.15},
	{"id": "cosmic_vault", "category": "advanced", "badge": "VAULT", "name": "COSMIC VAULT", "description": "Permanently increases every kibble source by 8% per level.", "accent": Color(0.48, 0.68, 1.0), "max_level": 5, "base_cost": 4000000, "effect": "all", "amount": 0.08},
	{"id": "nova_luck", "category": "advanced", "badge": "NOVA", "name": "NOVA LUCK", "description": "Adds 1.5 percentage points to bonus chance per level.", "accent": Color(1.0, 0.78, 0.2), "max_level": 5, "base_cost": 6000000, "effect": "luck", "amount": 1.5},
	{"id": "eternal_combo", "category": "advanced", "badge": "∞", "name": "ETERNAL COMBO", "description": "Raises maximum combo power by x0.25 per level.", "accent": Color(0.75, 0.42, 1.0), "max_level": 5, "base_cost": 9000000, "effect": "combo", "amount": 0.25},
	{"id": "dream_reactor", "category": "advanced", "badge": "CORE", "name": "DREAM REACTOR", "description": "Increases offline income by 25% per level.", "accent": Color(0.35, 0.8, 1.0), "max_level": 5, "base_cost": 12000000, "effect": "idle", "amount": 0.25},
	{"id": "royal_jackpot", "category": "advanced", "badge": "ROYAL", "name": "ROYAL JACKPOT", "description": "Increases successful bonus payouts by 20% per level.", "accent": Color(1.0, 0.58, 0.16), "max_level": 5, "base_cost": 18000000, "effect": "bonus", "amount": 0.20},
	{"id": "time_singularity", "category": "advanced", "badge": "TIME+", "name": "TIME SINGULARITY", "description": "Extends offline storage capacity by 6 hours per level.", "accent": Color(0.35, 0.72, 1.0), "max_level": 5, "base_cost": 24000000, "effect": "storage", "amount": 6.0},
	{"id": "streak_crown", "category": "advanced", "badge": "CROWN", "name": "STREAK CROWN", "description": "Adds one permanent multiplier to bonus streaks per level.", "accent": Color(1.0, 0.38, 0.65), "max_level": 4, "base_cost": 32000000, "effect": "streak", "amount": 1.0},
	{"id": "feast_dimension", "category": "advanced", "badge": "FEAST", "name": "FEAST DIMENSION", "description": "Increases daily rewards by 30% per level.", "accent": Color(0.45, 1.0, 0.55), "max_level": 5, "base_cost": 45000000, "effect": "daily", "amount": 0.30},
	{"id": "celestial_engine", "category": "advanced", "badge": "STAR", "name": "CELESTIAL ENGINE", "description": "Permanently increases all kibble income by 20% per level.", "accent": Color(1.0, 0.85, 0.35), "max_level": 5, "base_cost": 75000000, "effect": "all", "amount": 0.20},
	{"id": "prismatic_paws", "category": "legendary", "badge": "PRISM", "name": "PRISMATIC PAWS", "description": "Permanently increases all tap earnings by 35% per level.", "accent": Color(0.25, 1.0, 0.78), "max_level": 5, "base_cost": 1000000000, "effect": "tap", "amount": 0.35},
	{"id": "nebula_vault", "category": "legendary", "badge": "VAULT+", "name": "NEBULA VAULT", "description": "Permanently increases every kibble source by 25% per level.", "accent": Color(0.45, 0.78, 1.0), "max_level": 5, "base_cost": 1500000000, "effect": "all", "amount": 0.25},
	{"id": "solar_luck", "category": "legendary", "badge": "SOLAR", "name": "SOLAR LUCK", "description": "Adds 3 percentage points to bonus chance per level.", "accent": Color(1.0, 0.84, 0.28), "max_level": 5, "base_cost": 2250000000, "effect": "luck", "amount": 3.0},
	{"id": "jackpot_citadel", "category": "legendary", "badge": "CITADEL", "name": "JACKPOT CITADEL", "description": "Increases successful bonus payouts by 40% per level.", "accent": Color(1.0, 0.48, 0.28), "max_level": 5, "base_cost": 3400000000, "effect": "bonus", "amount": 0.40},
	{"id": "gravity_combo", "category": "legendary", "badge": "GRAV", "name": "GRAVITY COMBO", "description": "Raises maximum combo power by x0.5 per level.", "accent": Color(0.78, 0.52, 1.0), "max_level": 5, "base_cost": 5100000000, "effect": "combo", "amount": 0.5},
	{"id": "starlight_reactor", "category": "legendary", "badge": "LIGHT", "name": "STARLIGHT REACTOR", "description": "Increases offline income by 60% per level.", "accent": Color(0.38, 0.92, 1.0), "max_level": 5, "base_cost": 7600000000, "effect": "idle", "amount": 0.60},
	{"id": "galaxy_paws", "category": "mythic", "badge": "GALAXY", "name": "GALAXY PAWS", "description": "Permanently increases all tap earnings by 90% per level.", "accent": Color(0.52, 1.0, 0.72), "max_level": 5, "base_cost": 1000000000000, "effect": "tap", "amount": 0.90},
	{"id": "infinity_vault", "category": "mythic", "badge": "INFINITY", "name": "INFINITY VAULT", "description": "Permanently increases every kibble source by 70% per level.", "accent": Color(0.52, 0.84, 1.0), "max_level": 5, "base_cost": 1500000000000, "effect": "all", "amount": 0.70},
	{"id": "miracle_luck", "category": "mythic", "badge": "MIRACLE", "name": "MIRACLE LUCK", "description": "Adds 7 percentage points to bonus chance per level.", "accent": Color(1.0, 0.9, 0.34), "max_level": 5, "base_cost": 2250000000000, "effect": "luck", "amount": 7.0},
	{"id": "crown_jackpot", "category": "mythic", "badge": "CROWN+", "name": "CROWN JACKPOT", "description": "Increases successful bonus payouts by 100% per level.", "accent": Color(1.0, 0.54, 0.3), "max_level": 5, "base_cost": 3400000000000, "effect": "bonus", "amount": 1.0},
	{"id": "singularity_combo", "category": "mythic", "badge": "SING", "name": "SINGULARITY COMBO", "description": "Raises maximum combo power by x1 per level.", "accent": Color(0.82, 0.6, 1.0), "max_level": 5, "base_cost": 5100000000000, "effect": "combo", "amount": 1.0},
	{"id": "eternity_reactor", "category": "mythic", "badge": "ETERN", "name": "ETERNITY REACTOR", "description": "Increases offline income by 150% per level.", "accent": Color(0.42, 0.96, 1.0), "max_level": 5, "base_cost": 7600000000000, "effect": "idle", "amount": 1.50},
	{"id": "ascendant_paws", "category": "ascendant", "badge": "ASC", "name": "ASCENDANT PAWS", "description": "Increases tap earnings by 140% per level.", "accent": Color(1.0, 0.48, 0.82), "max_level": 10, "base_cost": 10000000000000, "effect": "tap", "amount": 1.40},
	{"id": "ascendant_vault", "category": "ascendant", "badge": "VAULT V", "name": "ASCENDANT VAULT", "description": "Increases all kibble income by 110% per level.", "accent": Color(0.48, 0.9, 1.0), "max_level": 10, "base_cost": 15000000000000, "effect": "all", "amount": 1.10},
	{"id": "ascendant_crown", "category": "ascendant", "badge": "CROWN V", "name": "ASCENDANT CROWN", "description": "Increases bonus payouts by 160% per level.", "accent": Color(1.0, 0.72, 0.26), "max_level": 10, "base_cost": 22500000000000, "effect": "bonus", "amount": 1.60},
	{"id": "divine_paws", "category": "divine", "badge": "DIVINE", "name": "DIVINE PAWS", "description": "Increases tap earnings by 200% per level.", "accent": Color(1.0, 0.88, 0.42), "max_level": 10, "base_cost": 50000000000000, "effect": "tap", "amount": 2.0},
	{"id": "divine_fortune", "category": "divine", "badge": "LUCK VI", "name": "DIVINE FORTUNE", "description": "Adds 12 percentage points of bonus chance per level.", "accent": Color(1.0, 0.66, 0.28), "max_level": 10, "base_cost": 75000000000000, "effect": "luck", "amount": 12.0},
	{"id": "divine_reactor", "category": "divine", "badge": "CORE VI", "name": "DIVINE REACTOR", "description": "Increases offline income by 240% per level.", "accent": Color(0.52, 0.86, 1.0), "max_level": 10, "base_cost": 110000000000000, "effect": "idle", "amount": 2.40},
	{"id": "cosmic_paws", "category": "cosmic", "badge": "COSMIC", "name": "COSMIC PAWS", "description": "Increases tap earnings by 300% per level.", "accent": Color(0.52, 1.0, 0.88), "max_level": 10, "base_cost": 200000000000000, "effect": "tap", "amount": 3.0},
	{"id": "cosmic_vault_x", "category": "cosmic", "badge": "VAULT VII", "name": "COSMIC VAULT", "description": "Increases all kibble income by 250% per level.", "accent": Color(0.42, 0.76, 1.0), "max_level": 10, "base_cost": 300000000000000, "effect": "all", "amount": 2.50},
	{"id": "cosmic_combo", "category": "cosmic", "badge": "COMBO VII", "name": "COSMIC COMBO", "description": "Raises maximum combo power by x3 per level.", "accent": Color(0.78, 0.52, 1.0), "max_level": 10, "base_cost": 450000000000000, "effect": "combo", "amount": 3.0},
	{"id": "eternal_paws", "category": "eternal", "badge": "ETERNAL", "name": "ETERNAL PAWS", "description": "Increases tap earnings by 450% per level.", "accent": Color(0.5, 1.0, 0.68), "max_level": 10, "base_cost": 800000000000000, "effect": "tap", "amount": 4.50},
	{"id": "eternal_jackpot", "category": "eternal", "badge": "JACK VIII", "name": "ETERNAL JACKPOT", "description": "Increases bonus payouts by 500% per level.", "accent": Color(1.0, 0.52, 0.3), "max_level": 10, "base_cost": 1200000000000000, "effect": "bonus", "amount": 5.0},
	{"id": "eternal_storage", "category": "eternal", "badge": "TIME VIII", "name": "ETERNAL STORAGE", "description": "Adds 48 hours of offline storage per level.", "accent": Color(0.38, 0.82, 1.0), "max_level": 10, "base_cost": 1800000000000000, "effect": "storage", "amount": 48.0},
	{"id": "transcendent_paws", "category": "transcendent", "badge": "TRANS", "name": "TRANSCENDENT PAWS", "description": "Increases tap earnings by 700% per level.", "accent": Color(1.0, 0.45, 0.72), "max_level": 10, "base_cost": 3000000000000000, "effect": "tap", "amount": 7.0},
	{"id": "transcendent_vault", "category": "transcendent", "badge": "VAULT IX", "name": "TRANSCENDENT VAULT", "description": "Increases all kibble income by 600% per level.", "accent": Color(0.4, 0.92, 1.0), "max_level": 10, "base_cost": 4500000000000000, "effect": "all", "amount": 6.0},
	{"id": "transcendent_streak", "category": "transcendent", "badge": "STREAK IX", "name": "TRANSCENDENT STREAK", "description": "Adds eight permanent streak multipliers per level.", "accent": Color(1.0, 0.72, 0.2), "max_level": 10, "base_cost": 6500000000000000, "effect": "streak", "amount": 8.0},
	{"id": "omega_paws", "category": "omega", "badge": "OMEGA", "name": "OMEGA PAWS", "description": "Increases tap earnings by 1000% per level.", "accent": Color(0.72, 1.0, 0.48), "max_level": 10, "base_cost": 10000000000000000, "effect": "tap", "amount": 10.0},
	{"id": "omega_vault", "category": "omega", "badge": "VAULT X", "name": "OMEGA VAULT", "description": "Increases all kibble income by 900% per level.", "accent": Color(0.38, 0.8, 1.0), "max_level": 10, "base_cost": 14000000000000000, "effect": "all", "amount": 9.0},
	{"id": "omega_crown", "category": "omega", "badge": "CROWN X", "name": "OMEGA CROWN", "description": "Increases bonus payouts by 1200% per level.", "accent": Color(1.0, 0.5, 0.3), "max_level": 10, "base_cost": 17500000000000000, "effect": "bonus", "amount": 12.0},
]
const MAX_COIN_PARTICLES := 18
const PARTICLE_LIMIT_INFINITE := 1000
const UPGRADE_ALERT_SHAKE_INTERVAL := 3.0
const ACHIEVEMENT_REFRESH_INTERVAL := 0.75
const TUTORIAL_STARTER_GOAL := 10
const TUTORIAL_STARTER_REWARD := 90
const TUTORIAL_CARD_MAX_WIDTH := 520.0
const TUTORIAL_STEPS: Array[Dictionary] = [
	{"title": "Click", "body": "Tap the cat 3 times.", "target": "cat", "wait_for": "cat_clicks", "count": 3, "destination": "main"},
	{"title": "Your kibbles", "body": "This counter shows the kibbles you can spend.", "target": "wallet", "wait_for": "continue", "reward": TUTORIAL_STARTER_REWARD},
	{"title": "Open Shop", "body": "Tap Shop in the bottom bar.", "target": "shop_button", "wait_for": "shop_opened"},
	{"title": "Upgrades", "body": "Upgrades permanently improve tapping, luck, combos, and idle income.", "target": "upgrades_panel", "wait_for": "continue", "destination": "shop", "shop_section": "upgrades"},
	{"title": "Boosts", "body": "Every boost now has unique artwork. Buy boosts here; owned boosts go to Inventory.", "target": "boosts_panel", "wait_for": "continue", "destination": "shop", "shop_section": "boosts"},
	{"title": "Food", "body": "Food is another temporary boost. Buy it here, then use it from Inventory.", "target": "shop_panel", "wait_for": "continue", "destination": "shop", "shop_section": "food"},
	{"title": "Open Inventory", "body": "Tap Inventory in the upper tab list.", "target": "inventory_button", "wait_for": "inventory_opened"},
	{"title": "Inventory", "body": "Tap USE NOW for instant activation, or drag an item onto the cat.", "target": "inventory_panel", "wait_for": "continue", "destination": "inventory"},
	{"title": "Open Skins", "body": "Tap Skins in the upper tab list.", "target": "skins_button", "wait_for": "skins_opened"},
	{"title": "Skins and crates", "body": "Collect cat skins, open crates, and equip room backgrounds here.", "target": "skins_panel", "wait_for": "continue", "destination": "skins"},
	{"title": "Open Missions", "body": "Tap Missions in the upper tab list.", "target": "missions_button", "wait_for": "missions_opened"},
	{"title": "Missions", "body": "Complete mission goals and claim their rewards.", "target": "missions_panel", "wait_for": "continue", "destination": "missions"},
	{"title": "Open Pause", "body": "Tap Pause in the bottom bar.", "target": "pause_button", "wait_for": "menu_opened"},
	{"title": "Pause menu", "body": "Settings, achievements, statistics, and tutorial replay live here. Tap outside to close it.", "target": "pause_panel", "wait_for": "continue"},
	{"title": "Ready", "body": "Tap, upgrade, use boosts, collect skins, and finish missions.", "target": "cat", "wait_for": "continue", "destination": "main"},
]
const TAP_BURST_COLORS := [
	Color(1.0, 0.88, 0.33, 0.95),
	Color(1.0, 1.0, 1.0, 0.9),
	Color(0.42, 0.86, 1.0, 0.9),
]
const DEFAULT_SKIN_ID := "classic"
const SKIN_ACCENT := Color(0.36, 0.82, 1.0, 1.0)
const DEFAULT_UI_TINT := Color.WHITE
const DEFAULT_ROOM_SKIN_ID := "moon_conservatory"
const ROOM_SKIN_DATA: Array[Dictionary] = [
	{"id": "moon_conservatory", "name": "Moon Conservatory", "texture": "res://assets/backgrounds/moon_conservatory.png", "accent": Color(0.3, 0.78, 1.0, 1.0)},
	{"id": "sunrise_greenhouse", "name": "Sunrise Garden", "texture": "res://assets/backgrounds/sunrise_greenhouse.png", "accent": Color(0.48, 0.9, 0.5, 1.0)},
	{"id": "celestial_palace", "name": "Celestial Palace", "texture": "res://assets/backgrounds/celestial_palace.png", "accent": Color(0.76, 0.58, 1.0, 1.0)},
	{"id": "neon_loft", "name": "Neon Loft", "texture": "res://assets/backgrounds/neon_loft.png", "accent": Color(0.2, 0.9, 1.0, 1.0)},
	{"id": "desert_palace", "name": "Desert Palace", "texture": "res://assets/backgrounds/desert_palace.png", "accent": Color(1.0, 0.62, 0.2, 1.0)},
]
const SKIN_DATA := [
	{"id": DEFAULT_SKIN_ID, "name": "Classic Cat", "cost": 0, "texture": "res://assets/cat1.png", "bonus_text": "+5% all kibble gain", "bonus": {"all_gain_mult": 1.05}},
	{"id": "ai", "name": "AI Cat", "cost": 10, "texture": "res://assets/skins/ai_cat.png", "bonus_text": "+0.7% bonus luck", "bonus": {"bonus_chance_bonus": 0.7}},
	{"id": "military", "name": "Military Cat", "cost": 1000, "texture": "res://assets/skins/military_cat.png", "bonus_text": "+1 offline gain per min", "bonus": {"passive_gain_bonus": 1}},
	{"id": "commando", "name": "Commando Cat", "cost": 1500, "texture": "res://assets/skins/commando_cat.png", "bonus_text": "+10% tap gain", "bonus": {"click_gain_mult": 1.10}},
	{"id": "commando_hacker", "name": "Commando Hacker Cat", "cost": 3000, "texture": "res://assets/skins/commando_hacker_cat.png", "bonus_text": "+20% daily reward", "bonus": {"daily_reward_mult": 1.20}},
	{"id": "donut", "name": "Donut Cat", "cost": 5000, "texture": "res://assets/skins/donut_cat.png", "bonus_text": "+8% tap gain", "bonus": {"click_gain_mult": 1.08}},
	{"id": "glitch", "name": "Glitch Cat", "cost": 6666, "texture": "res://assets/skins/glitch_cat.png", "bonus_text": "+35% bonus payout", "bonus": {"bonus_value_mult": 1.35}},
	{"id": "pizza", "name": "Pizza Cat", "cost": 7500, "texture": "res://assets/skins/pizza_cat.png", "bonus_text": "+15% daily reward", "bonus": {"daily_reward_mult": 1.15}},
	{"id": "kebab", "name": "Kebab Cat", "cost": 7500, "texture": "res://assets/skins/kebab_cat.png", "bonus_text": "+2 offline gain per min", "bonus": {"passive_gain_bonus": 2}},
	{"id": "alien", "name": "Alien Cat", "cost": 8000, "texture": "res://assets/skins/alien_cat.png", "bonus_text": "+1 streak multiplier", "bonus": {"streak_bonus": 1}},
	{"id": "ice_cream", "name": "Ice Cream Cat", "cost": 9000, "texture": "res://assets/skins/ice_cream_cat.png", "bonus_text": "+20% bonus payout", "bonus": {"bonus_value_mult": 1.20}},
	{"id": "cookie", "name": "Cookie Cat", "cost": 9999, "texture": "res://assets/skins/cookie_cat.png", "bonus_text": "+12% tap gain", "bonus": {"click_gain_mult": 1.12}},
	{"id": "galaxy", "name": "Galaxy Cat", "cost": 10000, "texture": "res://assets/skins/galaxy_cat.png", "bonus_text": "+1.2% bonus luck", "bonus": {"bonus_chance_bonus": 1.2}},
	{"id": "watermelon", "name": "Watermelon Cat", "cost": 10000, "texture": "res://assets/skins/watermelon_cat.png", "bonus_text": "+10% all kibble gain", "bonus": {"all_gain_mult": 1.10}},
	{"id": "burger", "name": "Burger Cat", "cost": 10000, "texture": "res://assets/skins/burger_cat.png", "bonus_text": "+15% tap gain", "bonus": {"click_gain_mult": 1.15}},
	{"id": "coffee", "name": "Coffee Cat", "cost": 10005, "texture": "res://assets/skins/coffee_cat.png", "bonus_text": "+3 offline gain per min", "bonus": {"passive_gain_bonus": 3}},
	{"id": "void", "name": "Void Cat", "cost": 20000, "texture": "res://assets/skins/void_cat.png", "bonus_text": "+18% all kibble gain", "bonus": {"all_gain_mult": 1.18}},
	{"id": "cheese", "name": "Cheese Cat", "cost": 20000, "texture": "res://assets/skins/cheese_cat.png", "bonus_text": "+25% bonus payout", "bonus": {"bonus_value_mult": 1.25}},
	{"id": "popcorn", "name": "Popcorn Cat", "cost": 23000, "texture": "res://assets/skins/popcorn_cat.png", "bonus_text": "+1.5% bonus luck", "bonus": {"bonus_chance_bonus": 1.5}},
	{"id": "detective", "name": "Detective Cat", "cost": 35000, "texture": "res://assets/skins/detective_cat.png", "bonus_text": "+2% bonus luck, +15% bonus payout", "bonus": {"bonus_chance_bonus": 2.0, "bonus_value_mult": 1.15}},
	{"id": "sushi_chef", "name": "Sushi Chef Cat", "cost": 50000, "texture": "res://assets/skins/sushi_chef_cat.png", "bonus_text": "+30% daily reward, +2 offline/min", "bonus": {"daily_reward_mult": 1.30, "passive_gain_bonus": 2}},
	{"id": "sunflower", "name": "Sunflower Cat", "cost": 75000, "texture": "res://assets/skins/sunflower_cat.png", "bonus_text": "+28% all gain, +2% bonus luck", "bonus": {"all_gain_mult": 1.28, "bonus_chance_bonus": 2.0}},
	{"id": "winter_explorer", "name": "Winter Explorer Cat", "cost": 95000, "texture": "res://assets/skins/winter_explorer_cat.png", "bonus_text": "+35% tap gain, +3 offline/min", "bonus": {"click_gain_mult": 1.35, "passive_gain_bonus": 3}},
	{"id": "angelic", "name": "Angelic Cat", "cost": 100000, "texture": "res://assets/skins/angelic_cat.png", "bonus_text": "+35% daily reward", "bonus": {"daily_reward_mult": 1.35}},
	{"id": "banana", "name": "Banana Cat", "cost": 123456, "texture": "res://assets/skins/banana_cat.png", "bonus_text": "+35% all kibble gain", "bonus": {"all_gain_mult": 1.35}},
	{"id": "demoniac", "name": "Demoniac Cat", "cost": 125000, "texture": "res://assets/skins/demoniac_cat.png", "bonus_text": "+2.0% bonus luck", "bonus": {"bonus_chance_bonus": 2.0}},
	{"id": "sushi", "name": "Sushi Cat", "cost": 195000, "texture": "res://assets/skins/sushi_cat.png", "bonus_text": "+45% daily reward, +2 offline/min", "bonus": {"daily_reward_mult": 1.45, "passive_gain_bonus": 2}},
	{"id": "astronaut", "name": "Astronaut Cat", "cost": 250000, "texture": "res://assets/skins/astronaut_cat.png", "bonus_text": "+45% all gain, +4 offline/min", "bonus": {"all_gain_mult": 1.45, "passive_gain_bonus": 4}},
	{"id": "taco", "name": "Taco Cat", "cost": 444444, "texture": "res://assets/skins/taco_cat.png", "bonus_text": "+50% tap gain, +40% bonus payout", "bonus": {"click_gain_mult": 1.50, "bonus_value_mult": 1.40}},
	{"id": "steampunk", "name": "Steampunk Cat", "cost": 500000, "texture": "res://assets/skins/steampunk_cat.png", "bonus_text": "+60% tap gain, +45% bonus payout", "bonus": {"click_gain_mult": 1.60, "bonus_value_mult": 1.45}},
	{"id": "silver_knight", "name": "Silver Knight Cat", "cost": 850000, "texture": "res://assets/skins/silver_knight_cat.png", "bonus_text": "+70% all gain, +3% bonus luck", "bonus": {"all_gain_mult": 1.70, "bonus_chance_bonus": 3.0}},
	{"id": "sushi_master", "name": "Sushi Master Cat", "cost": 950000, "texture": "res://assets/skins/sushi_master_cat.png", "bonus_text": "+85% daily reward, +5 offline/min", "bonus": {"daily_reward_mult": 1.85, "passive_gain_bonus": 5}},
	{"id": "businessman", "name": "Businessman Cat", "cost": 1000000, "texture": "res://assets/skins/businessman_cat.png", "bonus_text": "+30% all kibble gain", "bonus": {"all_gain_mult": 1.30}},
	{"id": "star_wizard", "name": "Star Wizard Cat", "cost": 5000000, "texture": "res://assets/skins/star_wizard_cat.png", "bonus_text": "+115% all gain, +4% bonus luck", "bonus": {"all_gain_mult": 2.15, "bonus_chance_bonus": 4.0}},
	{"id": "samurai_lord", "name": "Samurai Lord Cat", "cost": 12000000, "texture": "res://assets/skins/samurai_lord_cat.png", "bonus_text": "+150% tap gain, +1 streak", "bonus": {"click_gain_mult": 2.50, "streak_bonus": 1}},
	{"id": "vampire_lord", "name": "Vampire Lord Cat", "cost": 20000000, "texture": "res://assets/skins/vampire_lord_cat.png", "bonus_text": "+140% all gain, +100% bonus payout", "bonus": {"all_gain_mult": 2.40, "bonus_value_mult": 2.00}},
	{"id": "bronze", "name": "Bronze Cat", "cost": 25000000, "texture": "res://assets/skins/bronze_cat.png", "bonus_text": "+80% all gain, +2.5% bonus luck", "bonus": {"all_gain_mult": 1.80, "bonus_chance_bonus": 2.5}},
	{"id": "silver", "name": "Silver Cat", "cost": 50000000, "texture": "res://assets/skins/silver_cat.png", "bonus_text": "+120% all gain, +6 offline/min", "bonus": {"all_gain_mult": 2.20, "passive_gain_bonus": 6}},
	{"id": "royal_king", "name": "Royal King Cat", "cost": 75000000, "texture": "res://assets/skins/royal_king_cat.png", "bonus_text": "+160% all gain, +70% daily reward", "bonus": {"all_gain_mult": 2.60, "daily_reward_mult": 1.70}},
	{"id": "gold", "name": "Gold Cat", "cost": 100000000, "texture": "res://assets/skins/gold_cat.png", "bonus_text": "+180% all gain, +60% bonus payout", "bonus": {"all_gain_mult": 2.80, "bonus_value_mult": 1.60}},
	{"id": "ocean_admiral", "name": "Ocean Admiral Cat", "cost": 150000000, "texture": "res://assets/skins/ocean_admiral_cat.png", "bonus_text": "+220% all gain, +8 offline/min", "bonus": {"all_gain_mult": 3.20, "passive_gain_bonus": 8}},
	{"id": "jester", "name": "Jester Cat", "cost": 300000000, "texture": "res://assets/skins/jester_cat.png", "bonus_text": "+250% all gain, +6% bonus luck", "bonus": {"all_gain_mult": 3.50, "bonus_chance_bonus": 6.0}},
	{"id": "rainbow", "name": "Rainbow Cat", "cost": 500000000, "texture": "res://assets/skins/rainbow_cat.png", "bonus_text": "+300% all gain, +5% luck, +1 streak, +75% daily reward", "bonus": {"all_gain_mult": 4.00, "bonus_chance_bonus": 5.0, "streak_bonus": 1, "daily_reward_mult": 1.75}},
	{"id": "dragon_lord", "name": "Dragon Lord Cat", "cost": 1000000000, "texture": "res://assets/skins/dragon_lord_cat.png", "bonus_text": "+400% all gain, +2 streak, +150% bonus payout", "bonus": {"all_gain_mult": 5.00, "streak_bonus": 2, "bonus_value_mult": 2.50}},
	{"id": "cyber_ninja", "name": "Cyber Ninja Cat", "cost": 2000000000, "rarity": "legendary", "gem_cost": 20, "texture": "res://assets/skins/cyber_ninja_cat.png", "bonus_text": "+420% all gain, +8% bonus luck", "bonus": {"all_gain_mult": 5.20, "bonus_chance_bonus": 8.0}},
	{"id": "pharaoh", "name": "Pharaoh Cat", "cost": 2500000000, "rarity": "legendary", "gem_cost": 20, "texture": "res://assets/skins/pharaoh_cat.png", "bonus_text": "+440% all gain, +120% daily reward", "bonus": {"all_gain_mult": 5.40, "daily_reward_mult": 2.20}},
	{"id": "forest_guardian", "name": "Forest Guardian Cat", "cost": 3000000000, "rarity": "legendary", "gem_cost": 20, "texture": "res://assets/skins/forest_guardian_cat.png", "bonus_text": "+460% all gain, +12 offline/min", "bonus": {"all_gain_mult": 5.60, "passive_gain_bonus": 12}},
	{"id": "shadow_ninja", "name": "Shadow Ninja Cat", "cost": 3500000000, "rarity": "legendary", "gem_cost": 20, "texture": "res://assets/skins/shadow_ninja_cat.png", "bonus_text": "+480% tap gain, +3 streak", "bonus": {"click_gain_mult": 5.80, "streak_bonus": 3}},
	{"id": "viking_chief", "name": "Viking Chief Cat", "cost": 4000000000, "rarity": "legendary", "gem_cost": 20, "texture": "res://assets/skins/viking_chief_cat.png", "bonus_text": "+500% all gain, +180% bonus payout", "bonus": {"all_gain_mult": 6.00, "bonus_value_mult": 2.80}},
	{"id": "emperor", "name": "Emperor Cat", "cost": 6000000000, "rarity": "mega", "gem_cost": 20, "texture": "res://assets/skins/emperor_cat.png", "bonus_text": "+650% all gain, +4 streak", "bonus": {"all_gain_mult": 7.50, "streak_bonus": 4}},
	{"id": "herbalist", "name": "Herbalist Cat", "cost": 7000000000, "rarity": "mega", "gem_cost": 20, "texture": "res://assets/skins/herbalist_cat.png", "bonus_text": "+700% all gain, +10% bonus luck", "bonus": {"all_gain_mult": 8.00, "bonus_chance_bonus": 10.0}},
	{"id": "star_commander", "name": "Star Commander Cat", "cost": 8000000000, "rarity": "mega", "gem_cost": 20, "texture": "res://assets/skins/star_commander_cat.png", "bonus_text": "+750% all gain, +16 offline/min", "bonus": {"all_gain_mult": 8.50, "passive_gain_bonus": 16}},
	{"id": "sultan", "name": "Sultan Cat", "cost": 9000000000, "rarity": "mega", "gem_cost": 20, "texture": "res://assets/skins/sultan_cat.png", "bonus_text": "+800% all gain, +160% daily reward", "bonus": {"all_gain_mult": 9.00, "daily_reward_mult": 2.60}},
	{"id": "relic_explorer", "name": "Relic Explorer Cat", "cost": 10000000000, "rarity": "mega", "gem_cost": 20, "texture": "res://assets/skins/relic_explorer_cat.png", "bonus_text": "+850% all gain, +220% bonus payout", "bonus": {"all_gain_mult": 9.50, "bonus_value_mult": 3.20}},
]
const SPECIAL_SPARKLE_SKIN_IDS := ["bronze", "silver", "gold", "royal_king", "ocean_admiral", "jester", "rainbow", "dragon_lord", "cyber_ninja", "pharaoh", "forest_guardian", "shadow_ninja", "viking_chief", "emperor", "herbalist", "star_commander", "sultan", "relic_explorer"]
const SKIN_SET_DATA: Array[Dictionary] = [
	{"id": "food", "name": "Food Cats", "icon": "🍔", "members": ["banana", "burger", "cheese", "coffee", "cookie", "donut", "ice_cream", "kebab", "pizza", "popcorn", "sushi", "taco", "watermelon"], "bonus_text": "+25% all kibble gain", "bonus": {"all_gain_mult": 1.25}, "accent": Color(1.0, 0.62, 0.24, 1.0)},
	{"id": "cosmic", "name": "Cosmic Cats", "icon": "✦", "members": ["alien", "galaxy", "void"], "bonus_text": "+3% bonus luck", "bonus": {"bonus_chance_bonus": 3.0}, "accent": Color(0.58, 0.45, 1.0, 1.0)},
	{"id": "military", "name": "Military Cats", "icon": "★", "members": ["military", "commando", "commando_hacker"], "bonus_text": "+35% tap gain", "bonus": {"click_gain_mult": 1.35}, "accent": Color(0.42, 0.72, 0.38, 1.0)},
]

var score: int = 0
var coins: int = 0
var score_counter: BigCounter = BigCounter.new()
var coins_counter: BigCounter = BigCounter.new()
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
var best_coin_balance_counter: BigCounter = BigCounter.new()
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
var master_volume: float = 1.0
var click_sounds_enabled := false
var ui_sounds_enabled := false
var mute_unfocused := false
var low_quality_enabled := false
var battery_saver_enabled := false
var optimized_tap_effects := false
var reduce_motion_enabled := false
var background_effects_enabled := false
var low_power_unfocused := false
var particle_limit := PARTICLE_LIMIT_INFINITE
var haptics_enabled := false
var haptic_strength := 50
var events_enabled := false
var floating_numbers_enabled := false
var coin_trails_enabled := false
var menu_swipe_enabled := false
var reverse_sliders_enabled := false
var slider_sound_style := 0
var abbreviate_numbers := false
var number_detail_digits := DEFAULT_NUMBER_DETAIL_DIGITS
var exact_number_tooltips := false
var group_full_numbers := false
var app_has_focus := true
var owned_skin_ids: Array[String] = []
var equipped_skin_id := DEFAULT_SKIN_ID
var equipped_room_skin_id := DEFAULT_ROOM_SKIN_ID
var ui_tint := DEFAULT_UI_TINT
var extended_upgrade_levels := {
	"tap_mastery": 0,
	"combo_capacity": 0,
	"combo_momentum": 0,
	"daily_feast": 0,
	"offline_storage": 0,
	"kibble_alchemy": 0,
	"lucky_whiskers": 0,
	"dream_engine": 0,
}
var cat_base_scale := Vector2.ONE
var last_cat_press_global_position := Vector2.ZERO
var save_timer: Timer
var daily_reward_timer: Timer
var combo_timer: Timer
var cat_tween: Tween
var score_tween: Tween
var coins_tween: Tween
var hud_coin_tween: Tween
var hud_wallet_tween: Tween
var hud_icon_idle_tween: Tween
var hud_coin_text_tween: Tween
var upgrade_ambient_tween: Tween
var coin_counter_tween: Tween
var modal_transition_tween: Tween
var modal_decoration_tween: Tween
var entrance_tweens: Array[Tween] = []
var entrance_controls: Array[Control] = []
var displayed_coins: int = -1
var upgrade_alert_active := false
var upgrade_alert_elapsed := 0.0
var upgrade_alert_shake_tween: Tween
var stats_card_controls: Array[Control] = []
var known_achievement_ids: Dictionary = {}
var achievement_tracking_ready := false
var ui_sound_variant_index := 0
var mobile_panels_wrapped := false
var touch_scroll_index := -1
var touch_scroll_dragging := false
var touch_scroll_distance := 0.0
var touch_scroll: ScrollContainer
var touch_slider_index := -1
var touch_slider: Slider
var mouse_slider_dragging := false
var app_backgrounded_at_unix := 0
var app_was_backgrounded := false
var skins_button: Button
var skins_panel: PanelContainer
var skins_wallet_label: Label
var skins_status_label: Label
var skins_tab_buttons: Dictionary = {}
var skins_section_panels: Dictionary = {}
var skins_tabs_row: HBoxContainer
var skins_active_section := "skins"
var crates_scroll: ScrollContainer
var crates_list: VBoxContainer
var skins_list: VBoxContainer
var skins_scroll: ScrollContainer
var room_skins_scroll: ScrollContainer
var room_skins_list: VBoxContainer
var skins_back_button: Button
var skin_action_buttons: Dictionary = {}
var skin_previews: Dictionary = {}
var skin_set_progress_labels: Dictionary = {}
var skin_set_bonus_labels: Dictionary = {}
var room_skin_action_buttons: Dictionary = {}
var boosts_button: Button
var boosts_panel: PanelContainer
var boost_wallet_label: Label
var boosts_list: VBoxContainer
var boosts_scroll: ScrollContainer
var boosts_back_button: Button
var boost_action_buttons: Dictionary = {}
var boost_status_labels: Dictionary = {}
var boost_cards: Dictionary = {}
var inventory_button: Button
var compact_inventory_panel: PanelContainer
var compact_inventory_list: VBoxContainer
var compact_inventory_scroll: ScrollContainer
var shop_button: Button
var inventory_shop_bar: HBoxContainer
var food_panel: PanelContainer
var food_panel_title: Label
var food_wallet_label: Label
var food_status_label: Label
var food_empty_state: PanelContainer
var food_list: GridContainer
var food_scroll_content: VBoxContainer
var inventory_tabs_bar: HBoxContainer
var inventory_tab_buttons: Dictionary = {}
var inventory_active_tab := "food"
var boost_inventory_grid: GridContainer
var boost_inventory_empty: PanelContainer
var boost_inventory: Dictionary = {}
var boost_inventory_cards: Dictionary = {}
var food_scroll: ScrollContainer
var food_back_button: Button
var food_inventory: Dictionary = {}
var food_cards: Dictionary = {}
var food_card_counts: Dictionary = {}
var food_icon_cache: Dictionary = {}
var food_panel_mode := "inventory"
var active_food_boosts: Dictionary = {}
var dragged_food_id := ""
var dragged_food_preview: TextureRect
var dragged_food_touch_index := -1
var food_drag_drop_target: Label
var food_drag_return_to_inventory := false
var food_drag_candidate_id := ""
var food_drag_candidate_start := Vector2.ZERO
var food_drag_candidate_touch_index := -1
var food_drag_candidate_started_msec := 0
var dragged_boost_key := ""
var boost_drag_candidate_key := ""
var shop_section_bars: Array[HBoxContainer] = []
var shop_section_buttons: Array[Dictionary] = []
var active_shop_section := "upgrades"
var modal_close_button: Button
var modal_decorations: Array[Control] = []
var combo_was_running_before_overlay := false
var combo_time_left_before_overlay := 0.0
var menu_time_pause_started := 0.0
var modal_closing := false
var extended_upgrade_controls: Dictionary = {}
var extended_upgrade_cards: Array[Control] = []
var active_boost_end_times: Dictionary = {}
var boost_recharge_end_times: Dictionary = {}
var nine_lives_taps_left := 0
var nine_lives_recharge_duration := 0.0
var update_095_balance_migration_applied := false
var admin_panel: PanelContainer
var admin_header: PanelContainer
var admin_click_spinbox: SpinBox
var admin_coin_spinbox: SpinBox
var admin_text_edit: LineEdit
var admin_text_size_spinbox: SpinBox
var admin_text_rotation_spinbox: SpinBox
var admin_text_color_picker: ColorPickerButton
var admin_status_label: Label
var admin_overlay_text_label: Label
var admin_overlay_text_outline: Panel
var admin_overlay_text_resize_handle: Panel
var admin_overlay_text_rotate_handle: Panel
var admin_overlay_text_rotate_stem: ColorRect
var is_editor_build := OS.has_feature("editor")
var admin_dragging := false
var admin_drag_offset := Vector2.ZERO
var admin_overlay_text_dragging := false
var admin_overlay_text_drag_offset := Vector2.ZERO
var admin_overlay_text_resizing := false
var admin_overlay_text_rotating := false
var admin_overlay_text_selected := false
var admin_overlay_text_resize_start_mouse := Vector2.ZERO
var admin_overlay_text_resize_start_font_size := 34
var admin_overlay_text_rotate_offset := 0.0
var special_skin_sparkle_elapsed := 0.0
var special_skin_sparkle_layer: Control
var tutorial_completed := false
var tutorial_active := false
var tutorial_prompt_visible := false
var tutorial_prompt_replay := false
var tutorial_step_index := -1
var tutorial_clicks_this_step := 0
var tutorial_reward_given := false
var tutorial_step_completing := false
var tutorial_step_generation := 0
var tutorial_target: Control
var tutorial_overlay: Control
var tutorial_dim: ColorRect
var tutorial_highlight: Panel
var tutorial_arrow: Label
var tutorial_card: PanelContainer
var tutorial_title_label: Label
var tutorial_body_label: Label
var tutorial_progress_label: Label
var tutorial_next_button: Button
var tutorial_skip_button: Button
var tutorial_close_button: Button
var tutorial_replay_button: Button
var tutorial_menu_replay_button: Button
var tutorial_pulse_tween: Tween
var tutorial_transition_tween: Tween
var click_logic
var upgrade_logic
var achievement_logic
var save_logic
var reward_logic
var ui_logic
var boost_logic
var crate_logic
var mission_logic
var random_event_logic
var bottomless_bowl_logic
var achievement_refresh_pending := false
var achievement_refresh_elapsed := 0.0
var museum_button: Button
var museum_panel: PanelContainer
var museum_scroll: ScrollContainer
var museum_content: VBoxContainer
var museum_back_button: Button
var bottomless_bowl_button: Button
var low_quality_mode := false
var auto_low_quality_detected := false
var effects_scale := 1.0
var mission_update_elapsed := 0.0
var runtime_quality_reason := ""
var performance_settings_card: PanelContainer
var touch_settings_card: PanelContainer
var low_quality_check_box: CheckButton
var battery_saver_check_box: CheckButton
var optimized_tap_check_box: CheckButton
var reduce_motion_check_box: CheckButton
var background_effects_check_box: CheckButton
var low_power_unfocused_check_box: CheckButton
var particle_limit_slider: HSlider
var particle_limit_value_label: Label
var haptics_check_box: CheckButton
var haptic_strength_slider: HSlider
var haptic_strength_value_label: Label
var events_check_box: CheckButton
var floating_numbers_check_box: CheckButton
var coin_trails_check_box: CheckButton
var menu_swipe_check_box: CheckButton
var reverse_sliders_check_box: CheckButton
var slider_sound_option: OptionButton
var master_volume_slider: HSlider
var master_volume_value_label: Label
var click_sounds_check_box: CheckButton
var ui_sounds_check_box: CheckButton
var mute_unfocused_check_box: CheckButton
var abbreviate_numbers_check_box: CheckButton
var number_detail_slider: HSlider
var number_detail_value_label: Label
var exact_number_tooltips_check_box: CheckButton
var group_full_numbers_check_box: CheckButton
var last_slider_sound_msec := 0
var settings_icon_sheet_texture: Texture2D


func _configure_runtime_quality() -> void:
	var reasons: Array[String] = []
	var cpu_count := OS.get_processor_count()
	var display_name := DisplayServer.get_name()
	var screen_size := DisplayServer.screen_get_size()
	var is_mobile := OS.has_feature("mobile") or display_name in ["Android", "iOS"]
	if is_mobile:
		reasons.append("mobile")
	if cpu_count > 0 and cpu_count <= 4:
		reasons.append("low_cpu")
	if mini(screen_size.x, screen_size.y) > 0 and mini(screen_size.x, screen_size.y) <= 768:
		reasons.append("small_screen")

	auto_low_quality_detected = not reasons.is_empty()
	low_quality_mode = low_quality_enabled
	effects_scale = 0.45 if low_quality_mode else 1.0
	runtime_quality_reason = ",".join(reasons)
	_apply_runtime_quality()


func _apply_runtime_quality() -> void:
	low_quality_mode = low_quality_enabled
	effects_scale = 0.45 if low_quality_mode else 1.0
	if not app_has_focus and low_power_unfocused:
		Engine.max_fps = 15
		ProjectSettings.set_setting("application/run/low_processor_mode", true)
		ProjectSettings.set_setting("application/run/low_processor_mode_sleep_usec", 16000)
	elif battery_saver_enabled:
		Engine.max_fps = 30
		ProjectSettings.set_setting("application/run/low_processor_mode", true)
		ProjectSettings.set_setting("application/run/low_processor_mode_sleep_usec", 10000)
	elif low_quality_mode:
		Engine.max_fps = 45
		ProjectSettings.set_setting("application/run/low_processor_mode", true)
		ProjectSettings.set_setting("application/run/low_processor_mode_sleep_usec", 6900)
	else:
		Engine.max_fps = 60
		ProjectSettings.set_setting("application/run/low_processor_mode", false)


func _ready() -> void:
	set_process(false)
	get_tree().auto_accept_quit = false
	randomize()
	_configure_runtime_quality()
	click_logic = ClickLogic.new(self)
	upgrade_logic = UpgradeLogic.new(self)
	achievement_logic = AchievementLogic.new(self)
	save_logic = SaveLogic.new(self)
	reward_logic = RewardLogic.new(self)
	ui_logic = UiLogic.new(self)
	boost_logic = BoostLogic.new(self)
	crate_logic = CrateLogic.new(self)
	mission_logic = MissionLogic.new(self)
	random_event_logic = RandomEventLogic.new(self)
	bottomless_bowl_logic = BottomlessBowlLogic.new(self)
	_load_game()
	_apply_runtime_quality()
	_build_extended_upgrades_ui()
	_build_skins_ui()
	_build_boosts_ui()
	_build_food_ui()
	_build_museum_ui()
	bottomless_bowl_logic.build_ui()
	_build_bottomless_bowl_button()
	_build_inventory_shop_buttons()
	_build_shop_section_navigation()
	# Still available inside the museum, without a second main-HUD button.
	bottomless_bowl_button.hide()
	crate_logic.build_ui()
	crate_logic.merge_into_skins_ui(crates_list)
	mission_logic.build_ui()
	random_event_logic.build_ui()
	_apply_equipped_skin()
	_apply_equipped_room_skin()
	_apply_ui_tint()
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
	_build_runtime_settings_ui()
	_setup_upgrade_visuals()
	_build_tutorial_ui()
	ui_logic.start_hud_icon_idle_effect()
	_update_score()
	_update_coins(false)
	_update_combo_ui()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_update_volume_ui()
	_update_skins_ui()
	_update_food_ui()
	achievement_tracking_ready = true
	_apply_volume()
	last_cat_press_global_position = cat_button.get_global_rect().get_center()
	cat_button.pressed.connect(_on_cat_pressed)
	menu_button.pressed.connect(_show_menu)
	skins_button.pressed.connect(_show_skins)
	boosts_button.pressed.connect(_show_boosts)
	inventory_button.pressed.connect(_show_inventory)
	shop_button.pressed.connect(_show_shop)
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
	achievements_filter.item_selected.connect(_on_achievements_filter_selected)
	achievements_back_button.pressed.connect(_show_menu)
	stats_button.pressed.connect(_show_stats)
	stats_back_button.pressed.connect(_show_menu)
	museum_button.pressed.connect(_show_museum)
	museum_back_button.pressed.connect(_show_menu)
	daily_reward_button.pressed.connect(_claim_daily_reward)
	click_power_slider.value_changed.connect(_on_click_power_changed)
	click_volume_slider.value_changed.connect(_on_click_volume_changed)
	ui_volume_slider.value_changed.connect(_on_ui_volume_changed)
	resume_button.pressed.connect(_hide_pause_popup)
	exit_button.pressed.connect(_exit_game)
	skins_back_button.pressed.connect(_hide_menu)
	boosts_back_button.pressed.connect(_hide_menu)
	food_back_button.pressed.connect(_hide_menu)
	_setup_ui_animations(self)
	_build_admin_panel()
	_prepare_mobile_panels()
	_setup_modal_navigation()
	_apply_normal_button_style_tree(self)
	_build_telegram_navigation()
	_apply_mobile_layout()
	# Several setup passes above replace styleboxes. Reapply the loaded preference
	# last so a restarted game looks exactly like the selected UI style.
	_apply_ui_tint()
	menu_overlay.hide()
	call_deferred("_show_startup_popups")
	call_deferred("_maybe_start_first_time_tutorial")
	set_process(true)


func _process(delta: float) -> void:
	# Screen-drag events own the preview position on touch devices. Polling the
	# emulated mouse at the same time makes the food snap back under the finger.
	if (not dragged_food_id.is_empty() or not dragged_boost_key.is_empty()) and dragged_food_touch_index < 0:
		_update_food_drag_preview(get_viewport().get_mouse_position())
	if boost_logic != null:
		boost_logic.process(delta)
	if mission_logic != null:
		mission_update_elapsed += delta
		var mission_interval := 0.5 if low_quality_mode else 0.25
		if mission_update_elapsed >= mission_interval:
			mission_update_elapsed = 0.0
			mission_logic.update_ui()
	if random_event_logic != null:
		random_event_logic.process(delta)
	if tutorial_active or tutorial_prompt_visible:
		_update_tutorial_layout()
	if achievement_refresh_pending:
		achievement_refresh_elapsed += delta
		if achievement_refresh_elapsed >= ACHIEVEMENT_REFRESH_INTERVAL:
			achievement_refresh_pending = false
			achievement_refresh_elapsed = 0.0
			_update_achievements_ui()
	if menu_overlay.visible:
		var visible_panel := _get_visible_overlay_panel()
		if visible_panel != null:
			_position_modal_close_button(visible_panel)
	if upgrade_alert_active and not menu_overlay.visible:
		upgrade_alert_elapsed += delta
		if upgrade_alert_elapsed >= UPGRADE_ALERT_SHAKE_INTERVAL:
			upgrade_alert_elapsed = 0.0
			_shake_upgrade_button()
	_process_special_skin_sparkles(delta)

	if combo_timer != null and not combo_timer.is_stopped() and not combo_timer.paused:
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
	if _handle_slider_touch(event):
		get_viewport().set_input_as_handled()
		return
	if is_instance_valid(settings_shell) and settings_shell.visible:
		if event.is_action_pressed("ui_cancel"):
			_close_settings_shell()
			get_viewport().set_input_as_handled()
			return
		if _handle_settings_shell_swipe(event):
			get_viewport().set_input_as_handled()
		return
	if is_instance_valid(pause_detail_shell) and pause_detail_shell.visible:
		if event.is_action_pressed("ui_cancel"):
			_close_pause_detail_shell()
			get_viewport().set_input_as_handled()
			return
	if not food_drag_candidate_id.is_empty() and dragged_food_id.is_empty():
		if event is InputEventMouseMotion and event.global_position.distance_to(food_drag_candidate_start) >= 10.0:
			_start_food_drag(food_drag_candidate_id, event.global_position)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventScreenDrag and event.index == food_drag_candidate_touch_index and event.position.distance_to(food_drag_candidate_start) >= 18.0:
			dragged_food_touch_index = event.index
			_start_food_drag(food_drag_candidate_id, event.position)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_clear_food_drag_candidate()
		if event is InputEventScreenTouch and event.index == food_drag_candidate_touch_index and not event.pressed:
			_clear_food_drag_candidate()
	if not boost_drag_candidate_key.is_empty() and dragged_boost_key.is_empty():
		if event is InputEventMouseMotion and event.global_position.distance_to(food_drag_candidate_start) >= 10.0:
			_start_boost_drag(boost_drag_candidate_key, event.global_position)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventScreenDrag and event.index == food_drag_candidate_touch_index and event.position.distance_to(food_drag_candidate_start) >= 18.0:
			dragged_food_touch_index = event.index
			_start_boost_drag(boost_drag_candidate_key, event.position)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			boost_drag_candidate_key = ""
		if event is InputEventScreenTouch and event.index == food_drag_candidate_touch_index and not event.pressed:
			boost_drag_candidate_key = ""

	if event is InputEventScreenDrag and event.index == dragged_food_touch_index and (not dragged_food_id.is_empty() or not dragged_boost_key.is_empty()):
		_update_food_drag_preview(event.position)
		get_viewport().set_input_as_handled()
		return

	if event is InputEventScreenTouch and event.index == dragged_food_touch_index and not event.pressed and (not dragged_food_id.is_empty() or not dragged_boost_key.is_empty()):
		if not dragged_food_id.is_empty():
			_finish_food_drag(event.position)
		else:
			_finish_boost_drag(event.position)
		dragged_food_touch_index = -1
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseMotion and (not dragged_food_id.is_empty() or not dragged_boost_key.is_empty()):
		_update_food_drag_preview(event.global_position)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and (not dragged_food_id.is_empty() or not dragged_boost_key.is_empty()):
		if not dragged_food_id.is_empty():
			_finish_food_drag(event.global_position)
		else:
			_finish_boost_drag(event.global_position)
		get_viewport().set_input_as_handled()
		return

	if is_editor_build and event is InputEventKey and event.pressed and not event.echo:
		if event.ctrl_pressed and event.alt_pressed and event.keycode == KEY_1:
			_toggle_admin_panel()
			get_viewport().set_input_as_handled()
			return

	if is_instance_valid(admin_text_edit) and admin_text_edit.has_focus():
		if event is InputEventKey and event.pressed and not event.echo:
			return

	if not menu_overlay.visible and event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			last_cat_press_global_position = cat_button.get_global_rect().get_center()
			_press_cat_down(cat_button.size * 0.5)
			_on_cat_pressed()
			get_viewport().set_input_as_handled()
			return

	if admin_dragging and event is InputEventMouseMotion:
		_move_admin_panel(event.global_position)
		get_viewport().set_input_as_handled()
		return

	if admin_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		admin_dragging = false
		get_viewport().set_input_as_handled()
		return

	if admin_overlay_text_resizing and event is InputEventMouseMotion:
		_resize_admin_overlay_text(event.global_position)
		get_viewport().set_input_as_handled()
		return

	if admin_overlay_text_rotating and event is InputEventMouseMotion:
		_rotate_admin_overlay_text(event.global_position)
		get_viewport().set_input_as_handled()
		return

	if admin_overlay_text_dragging and event is InputEventMouseMotion:
		_move_admin_overlay_text(event.global_position)
		get_viewport().set_input_as_handled()
		return

	if (admin_overlay_text_resizing or admin_overlay_text_rotating) and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		admin_overlay_text_resizing = false
		admin_overlay_text_rotating = false
		get_viewport().set_input_as_handled()
		return

	if admin_overlay_text_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		admin_overlay_text_dragging = false
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_instance_valid(admin_overlay_text_label) and not _admin_overlay_text_hit_test(event.global_position):
			_set_admin_overlay_text_selected(false)

	if not menu_overlay.visible:
		touch_scroll_index = -1
		touch_scroll_dragging = false
		touch_scroll_distance = 0.0
		touch_scroll = null
		return

	if event.is_action_pressed("ui_cancel"):
		_hide_menu()
		get_viewport().set_input_as_handled()
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			touch_scroll_index = event.index
			touch_scroll_dragging = false
			touch_scroll_distance = 0.0
			touch_scroll = _get_scroll_at_position(event.position)
		elif event.index == touch_scroll_index:
			if touch_scroll_dragging:
				get_viewport().set_input_as_handled()
			touch_scroll_index = -1
			touch_scroll_dragging = false
			touch_scroll_distance = 0.0
			touch_scroll = null
		return

	if event is InputEventScreenDrag and event.index == touch_scroll_index:
		var scroll := touch_scroll if is_instance_valid(touch_scroll) else _get_visible_menu_scroll()
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
			app_has_focus = false
			_apply_volume()
			_apply_runtime_quality()
			if not app_was_backgrounded:
				app_backgrounded_at_unix = _get_unix_time()
				app_was_backgrounded = true
			_save_game()
		NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_IN:
			app_has_focus = true
			_apply_volume()
			_apply_runtime_quality()
			if app_was_backgrounded:
				app_was_backgrounded = false
				_apply_resumed_offline_gain()


func _on_cat_pressed() -> void:
	click_logic.on_cat_pressed()
	_tutorial_notify("cat_clicked")


func _on_cat_gui_input(event: InputEvent) -> void:
	click_logic.on_cat_gui_input(event)


func _update_score() -> void:
	ui_logic.update_score()


func _update_tap_hint() -> void:
	pass


func _update_coins(animated: bool = true) -> void:
	ui_logic.update_coins(animated)


func _set_coin_display(value: float) -> void:
	ui_logic.set_coin_display(value)


func _animate_coin_counter(from_value: int, to_value: int, duration: float = 0.32) -> void:
	ui_logic.animate_coin_counter(from_value, to_value, duration)


func _gain_coins(amount: int, origin_global: Vector2) -> void:
	ui_logic.gain_coins(amount, origin_global)


func _spawn_coin_stream(amount: int, origin_global: Vector2) -> void:
	ui_logic.spawn_coin_stream(amount, origin_global)


func _coin_particle_arrived(particle: TextureRect) -> void:
	ui_logic.coin_particle_arrived(particle)


func _animate_hud_coin() -> void:
	ui_logic.animate_hud_coin()


func _increase_combo() -> void:
	click_logic.increase_combo()


func _reset_combo() -> void:
	click_logic.reset_combo()


func _get_combo_multiplier() -> float:
	return click_logic.get_combo_multiplier()


func _update_combo_ui(animated: bool = false) -> void:
	click_logic.update_combo_ui(animated)


func _update_upgrade_ui() -> void:
	upgrade_logic.update_upgrade_ui()
	_update_tap_hint()


func _update_bonus_upgrade_ui() -> void:
	upgrade_logic.update_bonus_upgrade_ui()


func _set_upgrade_button_state(button: Button, ready_text: String, disabled: bool, cost: int = -1) -> void:
	upgrade_logic.set_upgrade_button_state(button, ready_text, disabled, cost)


func _has_affordable_upgrade() -> bool:
	return upgrade_logic.has_affordable_upgrade()


func _update_upgrade_alert() -> void:
	var affordable := _has_affordable_upgrade()
	if is_instance_valid(telegram_navigation):
		upgrade_alert_active = affordable
		upgrade_alert_elapsed = 0.0
		upgrade_alert_badge.hide()
		return
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
	if is_instance_valid(telegram_navigation) or menu_overlay.visible or not upgrade_alert_active:
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
	progress_bar.tooltip_text = "Complete" if maxed else "%s / %s kibbles" % [_format_coins(), _format_number(cost)]


func _setup_main_ui_visuals() -> void:
	room_background.tooltip_text = "Your cat's gem lounge"
	score_label.add_theme_color_override("font_color", Color(0.94, 0.98, 1.0, 1.0))
	score_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.32))
	score_label.add_theme_constant_override("shadow_offset_x", 0)
	score_label.add_theme_constant_override("shadow_offset_y", 2)
	score_label.add_theme_stylebox_override(
		"normal",
		_make_upgrade_style(Color(0.02, 0.025, 0.03, 0.42), Color(1.0, 1.0, 1.0, 0.08), 24, 1, -1, 3)
	)
	hint_label.hide()
	cat_button.tooltip_text = "Tap the cat (Space or Enter)"
	var cat_shadow := Panel.new()
	cat_shadow.name = "CatGroundShadow"
	cat_shadow.show_behind_parent = true
	cat_shadow.z_index = -1
	cat_shadow.anchor_left = 0.16
	cat_shadow.anchor_top = 0.88
	cat_shadow.anchor_right = 0.84
	cat_shadow.anchor_bottom = 0.985
	cat_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cat_shadow.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.0, 0.0, 0.0, 0.42), Color(0.08, 0.2, 0.24, 0.24), 96, 1, -1, 18)
	)
	cat_button.add_child(cat_shadow)
	cat_button.move_child(cat_shadow, 0)
	hud_wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.035, 0.035, 0.72), Color(1.0, 0.9, 0.62, 0.18), 22, 1, -1, 4)
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
		_make_upgrade_style(Color(1.0, 1.0, 1.0, 1.0), Color(0.92, 0.08, 0.14, 1.0), 18, 3, -1, 5)
	)


func _setup_pause_menu_visuals() -> void:
	menu_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.025, 0.032, 0.052, 0.98), Color(0.96, 0.72, 0.3, 0.38), 30, 2, -1, 14)
	)
	menu_header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.075, 0.09, 0.14, 0.94), Color(0.42, 0.86, 1.0, 0.28), 22, 1, -1, 6)
	)
	menu_wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.09, 0.08, 0.055, 0.62), Color(1.0, 0.86, 0.5, 0.16), 18, 1, -1, 2)
	)
	daily_reward_card.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.075, 0.065, 0.045, 0.68), Color(1.0, 0.84, 0.48, 0.14), 20, 1, -1, 3)
	)
	_style_upgrade_button(daily_reward_button, CHANCE_UPGRADE_COLOR)
	_style_upgrade_button(settings_button, CLICK_UPGRADE_COLOR)
	_style_upgrade_button(achievements_button, Color(0.82, 0.66, 0.22, 1.0))
	_style_upgrade_button(stats_button, Color(0.56, 0.48, 1.0, 1.0))
	resume_button.hide()
	exit_button.hide()


func _build_skins_ui() -> void:
	skins_button = Button.new()
	skins_button.name = "SkinsButton"
	skins_button.text = "SKINS"
	skins_button.icon = SKINS_UI_ICON
	skins_button.expand_icon = true
	skins_button.add_theme_constant_override("icon_max_width", 42)
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
	outer_margin.name = "SkinsOuterMargin"
	outer_margin.add_theme_constant_override("margin_left", 18)
	outer_margin.add_theme_constant_override("margin_top", 18)
	outer_margin.add_theme_constant_override("margin_right", 18)
	outer_margin.add_theme_constant_override("margin_bottom", 18)
	skins_panel.add_child(outer_margin)

	var items := VBoxContainer.new()
	items.name = "SkinsItems"
	items.add_theme_constant_override("separation", 12)
	outer_margin.add_child(items)

	var header := PanelContainer.new()
	header.name = "SkinsHero"
	header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.045, 0.105, 0.16, 1.0), Color(0.32, 0.82, 1.0, 0.75), 18, 2, 5, 8)
	)
	items.add_child(header)

	var header_margin := MarginContainer.new()
	header_margin.name = "SkinsHeroMargin"
	header_margin.add_theme_constant_override("margin_left", 18)
	header_margin.add_theme_constant_override("margin_top", 13)
	header_margin.add_theme_constant_override("margin_right", 18)
	header_margin.add_theme_constant_override("margin_bottom", 13)
	header.add_child(header_margin)

	var header_items := VBoxContainer.new()
	header_items.add_theme_constant_override("separation", 3)
	header_margin.add_child(header_items)

	var title := Label.new()
	title.name = "SkinsTitle"
	title.text = "CAT SKINS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.78, 0.93, 1.0, 1.0))
	header_items.add_child(title)

	skins_status_label = Label.new()
	skins_status_label.name = "SkinsStatus"
	skins_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	skins_status_label.text = "Find a cat's gem in crates, then equip the skin."
	skins_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	skins_status_label.add_theme_font_size_override("font_size", 14)
	skins_status_label.add_theme_color_override("font_color", Color(0.58, 0.72, 0.82, 1.0))
	header_items.add_child(skins_status_label)

	var wallet := PanelContainer.new()
	wallet.name = "SkinsWallet"
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
	coin_icon.texture = CrateLogic.GEM_FRAME
	coin_icon.custom_minimum_size = Vector2(38.0, 38.0)
	coin_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	coin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	wallet_row.add_child(coin_icon)

	skins_wallet_label = Label.new()
	skins_wallet_label.add_theme_font_size_override("font_size", 22)
	skins_wallet_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46, 1.0))
	wallet_row.add_child(skins_wallet_label)

	skins_tabs_row = HBoxContainer.new()
	skins_tabs_row.add_theme_constant_override("separation", 8)
	items.add_child(skins_tabs_row)

	for tab_data in [
		{"id": "crates", "text": "CRATES", "accent": Color(0.24, 0.82, 0.95, 1.0)},
		{"id": "skins", "text": "SKINS", "accent": SKIN_ACCENT},
		{"id": "background", "text": "BACKGROUND", "accent": Color(0.7, 0.58, 1.0, 1.0)},
	]:
		var tab_button := Button.new()
		tab_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab_button.custom_minimum_size = Vector2(0.0, 46.0)
		tab_button.text = String(tab_data["text"])
		tab_button.add_theme_font_size_override("font_size", 13)
		_style_upgrade_button(tab_button, tab_data["accent"] as Color)
		tab_button.set_meta("telegram_segment_accent", tab_data["accent"] as Color)
		tab_button.pressed.connect(_set_skins_section.bind(String(tab_data["id"])))
		skins_tabs_row.add_child(tab_button)
		skins_tab_buttons[String(tab_data["id"])] = tab_button

	var sections_root := VBoxContainer.new()
	sections_root.name = "SkinsSections"
	sections_root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	items.add_child(sections_root)

	var crates_panel := VBoxContainer.new()
	crates_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crates_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sections_root.add_child(crates_panel)
	skins_section_panels["crates"] = crates_panel

	crates_scroll = ScrollContainer.new()
	crates_scroll.custom_minimum_size = Vector2(0.0, 720.0)
	crates_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crates_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(crates_scroll)
	crates_panel.add_child(crates_scroll)

	crates_list = VBoxContainer.new()
	crates_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	crates_list.add_theme_constant_override("separation", 12)
	crates_scroll.add_child(crates_list)

	var skins_section := VBoxContainer.new()
	skins_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skins_section.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sections_root.add_child(skins_section)
	skins_section_panels["skins"] = skins_section

	skins_scroll = ScrollContainer.new()
	skins_scroll.custom_minimum_size = Vector2(0.0, 720.0)
	skins_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skins_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(skins_scroll)
	skins_section.add_child(skins_scroll)

	skins_list = VBoxContainer.new()
	skins_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skins_list.add_theme_constant_override("separation", 12)
	skins_scroll.add_child(skins_list)

	var sets_title := Label.new()
	sets_title.text = "COLLECTION SETS"
	sets_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sets_title.add_theme_font_size_override("font_size", 19)
	sets_title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.48, 1.0))
	skins_list.add_child(sets_title)
	for set_data in SKIN_SET_DATA:
		_add_skin_set_card(set_data)

	var catalog_title := Label.new()
	catalog_title.text = "CAT GEM CATALOG"
	catalog_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	catalog_title.add_theme_font_size_override("font_size", 19)
	catalog_title.add_theme_color_override("font_color", Color(0.78, 0.93, 1.0, 1.0))
	skins_list.add_child(catalog_title)

	for skin_data in SKIN_DATA:
		_add_skin_card(skin_data)

	var background_section := VBoxContainer.new()
	background_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background_section.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sections_root.add_child(background_section)
	skins_section_panels["background"] = background_section

	room_skins_scroll = ScrollContainer.new()
	room_skins_scroll.custom_minimum_size = Vector2(0.0, 720.0)
	room_skins_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	room_skins_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(room_skins_scroll)
	background_section.add_child(room_skins_scroll)

	room_skins_list = VBoxContainer.new()
	room_skins_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	room_skins_list.add_theme_constant_override("separation", 10)
	room_skins_scroll.add_child(room_skins_list)

	var rooms_title := Label.new()
	rooms_title.text = "ROOM SKINS"
	rooms_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rooms_title.add_theme_font_size_override("font_size", 17)
	rooms_title.add_theme_color_override("font_color", Color(0.82, 0.94, 1.0, 1.0))
	room_skins_list.add_child(rooms_title)
	for room_skin_data in ROOM_SKIN_DATA:
		_add_room_skin_card(room_skin_data)

	skins_back_button = Button.new()
	skins_back_button.text = "BACK TO GAME"
	skins_back_button.custom_minimum_size = Vector2(0.0, 56.0)
	skins_back_button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(skins_back_button, Color(0.42, 0.5, 0.66, 1.0))
	items.add_child(skins_back_button)
	_set_skins_section("skins")


func _set_skins_section(section_id: String) -> void:
	skins_active_section = section_id if skins_section_panels.has(section_id) else "skins"
	for entry_id in skins_section_panels.keys():
		var panel := skins_section_panels[entry_id] as Control
		if panel != null:
			panel.visible = entry_id == skins_active_section
	for entry_id in skins_tab_buttons.keys():
		var button := skins_tab_buttons[entry_id] as Button
		if button == null:
			continue
		button.disabled = false
		button.modulate = Color.WHITE
	_refresh_telegram_segment_buttons(skins_tab_buttons, skins_active_section)
	match skins_active_section:
		"crates":
			_tutorial_notify("crates_opened")
		"background":
			_tutorial_notify("background_opened")


func _apply_ui_tint() -> void:
	ui_tint = DEFAULT_UI_TINT
	_apply_ui_tint_to_branch(self)


func _apply_ui_tint_to_branch(node: Node) -> void:
	for child in node.get_children():
		_apply_ui_tint_to_branch(child)
	if node is CanvasItem:
		(node as CanvasItem).self_modulate = Color.WHITE
	if node is Control:
		_apply_ui_tint_to_control(node as Control)


func _build_museum_ui() -> void:
	museum_button = Button.new()
	museum_button.name = "MuseumButton"
	museum_button.text = "MUSEUM"
	museum_button.icon = MUSEUM_UI_ICON
	museum_button.expand_icon = true
	museum_button.add_theme_constant_override("icon_max_width", 42)
	museum_button.tooltip_text = "Visit your evolving collection museum"
	museum_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	museum_button.custom_minimum_size = Vector2(154.0, 62.0)
	museum_button.add_theme_font_size_override("font_size", 18)
	add_child(museum_button)
	move_child(museum_button, menu_overlay.get_index())
	_style_upgrade_button(museum_button, Color(0.92, 0.58, 0.22, 1.0))

	museum_panel = PanelContainer.new()
	museum_panel.name = "MuseumPanel"
	museum_panel.custom_minimum_size = Vector2(640.0, 1080.0)
	museum_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	museum_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	museum_panel.hide()
	menu_panel.get_parent().add_child(museum_panel)
	museum_panel.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.055, 0.042, 0.03, 0.99), Color(0.92, 0.62, 0.28, 1.0), 24, 2, -1, 18))

	var margin := MarginContainer.new()
	margin.name = "MuseumRootMargin"
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 18)
	museum_panel.add_child(margin)
	var root := VBoxContainer.new()
	root.name = "MuseumRoot"
	root.add_theme_constant_override("separation", 12)
	margin.add_child(root)
	museum_scroll = ScrollContainer.new()
	museum_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(museum_scroll)
	root.add_child(museum_scroll)
	museum_content = VBoxContainer.new()
	museum_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	museum_content.add_theme_constant_override("separation", 14)
	museum_scroll.add_child(museum_content)
	museum_back_button = Button.new()
	museum_back_button.text = "BACK TO GAME"
	museum_back_button.custom_minimum_size = Vector2(0.0, 56.0)
	museum_back_button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(museum_back_button, Color(0.72, 0.46, 0.22, 1.0))
	root.add_child(museum_back_button)
	_rebuild_museum()


func _build_bottomless_bowl_button() -> void:
	bottomless_bowl_button = Button.new()
	bottomless_bowl_button.name = "BottomlessBowlButton"
	bottomless_bowl_button.text = "CAT BOWL"
	bottomless_bowl_button.tooltip_text = "Donate kibble to the Bottomless Cat Bowl"
	bottomless_bowl_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	bottomless_bowl_button.custom_minimum_size = Vector2(154.0, 62.0)
	bottomless_bowl_button.add_theme_font_size_override("font_size", 17)
	add_child(bottomless_bowl_button)
	move_child(bottomless_bowl_button, menu_overlay.get_index())
	_style_upgrade_button(bottomless_bowl_button, Color(0.82, 0.38, 0.72, 1.0))
	bottomless_bowl_button.pressed.connect(_show_bottomless_bowl)


func _add_museum_title(text: String, subtitle: String, accent: Color) -> VBoxContainer:
	var section := VBoxContainer.new()
	section.add_theme_constant_override("separation", 7)
	museum_content.add_child(section)
	var title := Label.new()
	title.set_meta("museum_role", "section_title")
	title.text = text
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", accent)
	section.add_child(title)
	var detail := Label.new()
	detail.set_meta("museum_role", "section_detail")
	detail.text = subtitle
	detail.add_theme_font_size_override("font_size", 18)
	detail.add_theme_color_override("font_color", Color(0.72, 0.72, 0.7, 1.0))
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	section.add_child(detail)
	return section


func _museum_plaque(text: String, accent: Color, locked: bool = false) -> PanelContainer:
	var plaque := PanelContainer.new()
	plaque.custom_minimum_size = Vector2(0.0, 82.0)
	plaque.set_meta("museum_role", "plaque")
	plaque.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	plaque.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent if not locked else Color(0.28, 0.29, 0.32, 1.0), false))
	var label := Label.new()
	label.set_meta("museum_role", "plaque_label")
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.92, 0.9, 0.84, 1.0) if not locked else Color(0.5, 0.52, 0.55, 1.0))
	plaque.add_child(label)
	return plaque


func _rebuild_museum() -> void:
	if not is_instance_valid(museum_content):
		return
	for child in museum_content.get_children():
		museum_content.remove_child(child)
		child.queue_free()

	var achievements := _get_achievements()
	var unlocked_achievements: Array[Dictionary] = []
	for achievement in achievements:
		if bool(achievement["unlocked"]):
			unlocked_achievements.append(achievement)
	var complete_sets := 0
	for set_data in SKIN_SET_DATA:
		if _is_skin_set_complete(set_data):
			complete_sets += 1
	var found_cats := _get_unlocked_skin_count()
	var treasures := 0
	for threshold in [1, 10, 50, 200]:
		if crate_logic.total_crates_opened >= threshold:
			treasures += 1
	var completion := float(found_cats + unlocked_achievements.size() + complete_sets + treasures) / float(SKIN_DATA.size() + achievements.size() + SKIN_SET_DATA.size() + 4)
	var room_tier := mini(4, 1 + int(completion * 4.0))
	var room_names := ["", "Cozy Gallery", "Curator's Hall", "Grand Cat Museum", "Legendary Collection"]

	var hero := PanelContainer.new()
	hero.name = "MuseumHero"
	hero.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.12 + room_tier * 0.025, 0.075, 0.035, 1.0), Color(0.78 + room_tier * 0.05, 0.48 + room_tier * 0.06, 0.2, 1.0), 18, 2, 4, 8))
	museum_content.add_child(hero)
	var hero_label := Label.new()
	hero_label.name = "MuseumHeroLabel"
	hero_label.set_meta("museum_role", "hero")
	hero_label.text = "THE CAT MUSEUM\n%s  •  ROOM LEVEL %d\n%d%% COMPLETE" % [room_names[room_tier], room_tier, int(round(completion * 100.0))]
	hero_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hero_label.add_theme_font_size_override("font_size", 25)
	hero_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.52, 1.0))
	hero_label.custom_minimum_size = Vector2(0.0, 126.0)
	hero_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hero.add_child(hero_label)

	var bowl_button := Button.new()
	bowl_button.name = "MuseumBowlButton"
	bowl_button.text = "VISIT THE BOTTOMLESS CAT BOWL"
	bowl_button.custom_minimum_size = Vector2(0.0, 64.0)
	bowl_button.add_theme_font_size_override("font_size", 18)
	_style_upgrade_button(bowl_button, Color(0.82, 0.38, 0.72, 1.0))
	museum_content.add_child(bowl_button)
	bowl_button.pressed.connect(_show_bottomless_bowl)

	var cat_section := _add_museum_title("CAT GALLERY", "%d / %d portraits on display" % [found_cats, SKIN_DATA.size()], Color(0.4, 0.84, 1.0, 1.0))
	var cat_grid := GridContainer.new()
	cat_grid.name = "MuseumCatGrid"
	var viewport_width := get_viewport_rect().size.x
	cat_grid.columns = 2 if viewport_width < 520.0 else (3 if viewport_width < 900.0 else 4)
	cat_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cat_grid.add_theme_constant_override("h_separation", 10)
	cat_grid.add_theme_constant_override("v_separation", 10)
	cat_section.add_child(cat_grid)
	for skin_data in SKIN_DATA:
		var owned := _owns_skin(String(skin_data["id"]))
		var portrait := PanelContainer.new()
		portrait.set_meta("museum_role", "portrait")
		portrait.custom_minimum_size = Vector2(0.0, 172.0)
		portrait.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		portrait.add_theme_stylebox_override("panel", _make_upgrade_card_style(SKIN_ACCENT if owned else Color(0.22, 0.23, 0.26, 1.0), false))
		var portrait_margin := MarginContainer.new()
		_set_telegram_margins(portrait_margin, 8, 8, 8, 8)
		portrait.add_child(portrait_margin)
		var stack := VBoxContainer.new()
		stack.add_theme_constant_override("separation", 4)
		portrait_margin.add_child(stack)
		var image := TextureRect.new()
		image.custom_minimum_size = Vector2(0.0, 126.0)
		image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		image.texture = load(String(skin_data["texture"])) as Texture2D if owned else null
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		stack.add_child(image)
		var cat_name := Label.new()
		cat_name.set_meta("museum_role", "portrait_name")
		cat_name.text = String(skin_data["name"]) if owned else "Locked"
		cat_name.custom_minimum_size.y = 28.0
		cat_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cat_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		cat_name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		cat_name.add_theme_font_size_override("font_size", 18)
		cat_name.add_theme_color_override("font_color", Color(0.92, 0.95, 1.0, 1.0) if owned else Color(0.48, 0.52, 0.61, 1.0))
		stack.add_child(cat_name)
		cat_grid.add_child(portrait)

	var treasure_section := _add_museum_title("TREASURE VAULT", "%d / 4 crate relics recovered" % treasures, Color(1.0, 0.72, 0.24, 1.0))
	var treasure_grid := GridContainer.new()
	treasure_grid.name = "MuseumTreasureGrid"
	treasure_grid.columns = 2
	treasure_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	treasure_grid.add_theme_constant_override("h_separation", 10)
	treasure_grid.add_theme_constant_override("v_separation", 10)
	treasure_section.add_child(treasure_grid)
	var treasure_data := [[1, "FIRST KEY", "A tiny brass key"], [10, "GEM COMPASS", "Still points toward cats"], [50, "GOLDEN LATCH", "Opened fifty mysteries"], [200, "CROWNED CRATE", "The curator's masterpiece"]]
	for treasure in treasure_data:
		var unlocked: bool = crate_logic.total_crates_opened >= int(treasure[0])
		treasure_grid.add_child(_museum_plaque(("◆ " + String(treasure[1]) + "\n" + String(treasure[2])) if unlocked else "? LOCKED\nOpen %d crates" % int(treasure[0]), Color(1.0, 0.66, 0.18, 1.0), not unlocked))

	var achievement_section := _add_museum_title("ACHIEVEMENT WALL", "%d / %d medals earned" % [unlocked_achievements.size(), achievements.size()], Color(0.92, 0.72, 0.3, 1.0))
	var achievement_grid := GridContainer.new()
	achievement_grid.name = "MuseumAchievementGrid"
	achievement_grid.columns = 2
	achievement_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	achievement_grid.add_theme_constant_override("h_separation", 10)
	achievement_grid.add_theme_constant_override("v_separation", 10)
	achievement_section.add_child(achievement_grid)
	for index in range(maxi(0, unlocked_achievements.size() - 12), unlocked_achievements.size()):
		achievement_grid.add_child(_museum_plaque("★ " + String(unlocked_achievements[index]["text"]), Color(0.78, 0.58, 0.18, 1.0)))
	if unlocked_achievements.is_empty():
		achievement_grid.add_child(_museum_plaque("Earn an achievement to hang your first medal.", Color(0.3, 0.3, 0.34, 1.0), true))

	var set_section := _add_museum_title("SET TROPHIES", "%d / %d themed collections complete" % [complete_sets, SKIN_SET_DATA.size()], Color(0.72, 0.56, 1.0, 1.0))
	for set_data in SKIN_SET_DATA:
		var complete := _is_skin_set_complete(set_data)
		set_section.add_child(_museum_plaque((String(set_data["icon"]) + "  " + String(set_data["name"]).to_upper() + "\n" + String(set_data["bonus_text"])) if complete else "LOCKED TROPHY  •  %d / %d cats" % [_get_owned_set_member_count(set_data), (set_data["members"] as Array).size()], set_data["accent"] as Color, not complete))
	_apply_museum_responsive_layout()


func _build_boosts_ui() -> void:
	boosts_button = Button.new()
	boosts_button.name = "BoostsButton"
	boosts_button.text = "BOOSTS"
	boosts_button.icon = BOOSTS_UI_ICON
	boosts_button.expand_icon = true
	boosts_button.add_theme_constant_override("icon_max_width", 42)
	boosts_button.tooltip_text = "Open temporary boosts"
	boosts_button.add_theme_font_size_override("font_size", 19)
	boosts_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	boosts_button.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	boosts_button.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(boosts_button)
	move_child(boosts_button, menu_overlay.get_index())
	_style_upgrade_button(boosts_button, Color(0.68, 0.42, 1.0, 1.0))

	boosts_panel = PanelContainer.new()
	boosts_panel.name = "BoostsPanel"
	boosts_panel.custom_minimum_size = Vector2(640.0, 1080.0)
	boosts_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	boosts_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	boosts_panel.hide()
	menu_panel.get_parent().add_child(boosts_panel)
	boosts_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.58, 0.34, 0.9, 1.0), 8, 3, 5, 18)
	)

	var outer_margin := MarginContainer.new()
	outer_margin.name = "BoostsOuterMargin"
	outer_margin.add_theme_constant_override("margin_left", 18)
	outer_margin.add_theme_constant_override("margin_top", 18)
	outer_margin.add_theme_constant_override("margin_right", 18)
	outer_margin.add_theme_constant_override("margin_bottom", 18)
	boosts_panel.add_child(outer_margin)

	var items := VBoxContainer.new()
	items.name = "BoostsItems"
	items.add_theme_constant_override("separation", 12)
	outer_margin.add_child(items)

	var header := PanelContainer.new()
	header.name = "BoostsHero"
	header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.09, 0.055, 0.16, 1.0), Color(0.72, 0.48, 1.0, 0.78), 7, 2, 5, 8)
	)
	items.add_child(header)

	var header_margin := MarginContainer.new()
	header_margin.name = "BoostsHeroMargin"
	header_margin.add_theme_constant_override("margin_left", 18)
	header_margin.add_theme_constant_override("margin_top", 12)
	header_margin.add_theme_constant_override("margin_right", 18)
	header_margin.add_theme_constant_override("margin_bottom", 12)
	header.add_child(header_margin)

	var header_items := VBoxContainer.new()
	header_items.add_theme_constant_override("separation", 3)
	header_margin.add_child(header_items)

	var title := Label.new()
	title.name = "BoostsTitle"
	title.text = "BOOSTS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 1.0, 1.0))
	_style_arcade_heading(title)
	header_items.add_child(title)

	var subtitle := Label.new()
	subtitle.name = "BoostsSubtitle"
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.text = "Five tiers: each higher tier adds 50% of the base price"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.68, 0.6, 0.82, 1.0))
	header_items.add_child(subtitle)

	var wallet := PanelContainer.new()
	wallet.name = "BoostsWallet"
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

	boost_wallet_label = Label.new()
	boost_wallet_label.add_theme_font_size_override("font_size", 22)
	boost_wallet_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46, 1.0))
	_style_arcade_label_plate(boost_wallet_label, Color(1.0, 0.72, 0.16, 1.0), true)
	wallet_row.add_child(boost_wallet_label)

	var boost_tabs := GridContainer.new()
	boost_tabs.name = "BoostCategoryTabs"
	boost_tabs.columns = BOOST_CATEGORIES.size()
	boost_tabs.add_theme_constant_override("h_separation", 10)
	boost_tabs.add_theme_constant_override("v_separation", 8)
	items.add_child(boost_tabs)
	for category in BOOST_CATEGORIES:
		var tab := Button.new()
		tab.text = _get_upgrade_category_label(category)
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab.custom_minimum_size = Vector2(0, 52)
		var accent := Color(0.55, 0.45, 1.0)
		if category == "advanced":
			accent = Color(1.0, 0.45, 0.72)
		elif category == "legendary":
			accent = Color(1.0, 0.72, 0.24)
		elif category == "mythic":
			accent = Color(0.45, 0.95, 0.82)
		elif category == "ascendant":
			accent = Color(1.0, 0.48, 0.82)
		_style_upgrade_button(tab, accent)
		tab.set_meta("telegram_segment_accent", accent)
		tab.pressed.connect(_show_boost_category.bind(category))
		boost_tabs.add_child(tab)
		boost_category_buttons[category] = tab

	boosts_scroll = ScrollContainer.new()
	boosts_scroll.custom_minimum_size = Vector2(0.0, 360.0)
	boosts_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boosts_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(boosts_scroll)
	items.add_child(boosts_scroll)

	boosts_list = VBoxContainer.new()
	boosts_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boosts_list.add_theme_constant_override("separation", 12)
	boosts_scroll.add_child(boosts_list)

	for boost_data in BoostLogic.BOOST_DATA:
		_add_boost_card(boost_data)
	_show_boost_category("classical")

	boosts_back_button = Button.new()
	boosts_back_button.text = "BACK TO GAME"
	boosts_back_button.custom_minimum_size = Vector2(0.0, 56.0)
	boosts_back_button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(boosts_back_button, Color(0.42, 0.5, 0.66, 1.0))
	items.add_child(boosts_back_button)
	boost_logic.update_ui()


func _show_boost_category(category: String) -> void:
	boost_active_category = category
	for data in BoostLogic.BOOST_DATA:
		var card := boost_cards.get(String(data["id"])) as Control
		if card != null:
			card.visible = String(data.get("category", "classical")) == category
	if is_instance_valid(boosts_scroll):
		boosts_scroll.scroll_vertical = 0
	_refresh_telegram_segment_buttons(boost_category_buttons, boost_active_category)


func _get_upgrade_category_label(category: String) -> String:
	match category:
		"classical":
			return "I"
		"advanced":
			return "II"
		"legendary":
			return "III"
		"mythic":
			return "IV"
		"ascendant":
			return "V"
		"divine":
			return "VI"
		"cosmic":
			return "VII"
		"eternal":
			return "VIII"
		"transcendent":
			return "IX"
		"omega":
			return "X"
	return String(category).to_upper()


func _build_food_ui() -> void:
	food_panel = PanelContainer.new()
	food_panel.name = "FoodPanel"
	food_panel.custom_minimum_size = Vector2(640.0, 760.0)
	food_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	food_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	food_panel.hide()
	menu_panel.get_parent().add_child(food_panel)
	food_panel.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.055, 0.08, 0.095, 0.98), Color(0.96, 0.68, 0.26, 0.95), 8, 3, 5, 12))

	var outer_margin := MarginContainer.new()
	outer_margin.add_theme_constant_override("margin_left", 18)
	outer_margin.add_theme_constant_override("margin_top", 18)
	outer_margin.add_theme_constant_override("margin_right", 18)
	outer_margin.add_theme_constant_override("margin_bottom", 18)
	food_panel.add_child(outer_margin)

	var content := VBoxContainer.new()
	content.name = "FoodItems"
	content.add_theme_constant_override("separation", 12)
	outer_margin.add_child(content)

	food_panel_title = Label.new()
	food_panel_title.text = "INVENTORY"
	food_panel_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	food_panel_title.add_theme_font_size_override("font_size", 34)
	food_panel_title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.54, 1.0))
	_style_arcade_heading(food_panel_title)
	content.add_child(food_panel_title)

	food_wallet_label = Label.new()
	food_wallet_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	food_wallet_label.add_theme_font_size_override("font_size", 18)
	food_wallet_label.add_theme_color_override("font_color", Color(0.72, 0.82, 0.9, 1.0))
	_style_arcade_label_plate(food_wallet_label, Color(0.96, 0.68, 0.26, 1.0), true)
	food_status_label = Label.new()
	food_status_label.text = "Use an owned snack to start its boost."
	food_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	food_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	food_status_label.add_theme_font_size_override("font_size", 16)
	food_status_label.add_theme_color_override("font_color", Color(0.9, 0.78, 0.58, 1.0))
	content.add_child(food_status_label)

	inventory_tabs_bar = HBoxContainer.new()
	inventory_tabs_bar.name = "InventoryTabs"
	inventory_tabs_bar.add_theme_constant_override("separation", 10)
	content.add_child(inventory_tabs_bar)
	for tab_id in ["food", "boosts"]:
		var tab := Button.new()
		tab.text = tab_id.to_upper()
		tab.custom_minimum_size.y = 52.0
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab.pressed.connect(_show_inventory_tab.bind(tab_id))
		_style_upgrade_button(tab, Color(0.96, 0.68, 0.26) if tab_id == "food" else Color(0.48, 0.76, 1.0))
		inventory_tabs_bar.add_child(tab)
		inventory_tab_buttons[tab_id] = tab

	food_scroll = ScrollContainer.new()
	_configure_touch_scroll(food_scroll)
	food_scroll.custom_minimum_size = Vector2(0.0, 470.0)
	food_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(food_scroll)
	food_scroll_content = VBoxContainer.new()
	food_scroll_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	food_scroll_content.add_theme_constant_override("separation", 12)
	food_scroll.add_child(food_scroll_content)

	food_empty_state = PanelContainer.new()
	food_empty_state.name = "FoodEmptyState"
	food_empty_state.custom_minimum_size.y = 260.0
	food_empty_state.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.075, 0.06, 0.035, 0.92), Color(0.96, 0.68, 0.26, 0.42), 18, 1, -1, 3)
	)
	food_scroll_content.add_child(food_empty_state)
	var empty_margin := MarginContainer.new()
	_set_telegram_margins(empty_margin, 24, 28, 24, 28)
	food_empty_state.add_child(empty_margin)
	var empty_content := VBoxContainer.new()
	empty_content.alignment = BoxContainer.ALIGNMENT_CENTER
	empty_content.add_theme_constant_override("separation", 12)
	empty_margin.add_child(empty_content)
	var empty_icon := Label.new()
	empty_icon.text = "◇"
	empty_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_icon.add_theme_font_size_override("font_size", 38)
	empty_icon.add_theme_color_override("font_color", Color(1.0, 0.76, 0.32, 1.0))
	empty_content.add_child(empty_icon)
	var empty_title := Label.new()
	empty_title.text = "NO BOOSTS YET"
	empty_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_title.add_theme_font_size_override("font_size", 24)
	empty_title.add_theme_color_override("font_color", Color(1.0, 0.9, 0.62, 1.0))
	empty_content.add_child(empty_title)
	var empty_caption := Label.new()
	empty_caption.text = "Buy a snack in Shop. It will appear here when it is ready to use."
	empty_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	empty_caption.add_theme_font_size_override("font_size", 18)
	empty_caption.add_theme_color_override("font_color", Color(0.68, 0.72, 0.8, 1.0))
	empty_content.add_child(empty_caption)
	var empty_shop_button := Button.new()
	empty_shop_button.name = "EmptyInventoryShopButton"
	empty_shop_button.text = "OPEN SHOP"
	empty_shop_button.custom_minimum_size.y = 60.0
	_style_upgrade_button(empty_shop_button, Color(0.96, 0.68, 0.26, 1.0))
	empty_shop_button.pressed.connect(_open_shop_from_inventory)
	empty_content.add_child(empty_shop_button)

	food_list = GridContainer.new()
	food_list.columns = 3
	food_list.add_theme_constant_override("h_separation", 10)
	food_list.add_theme_constant_override("v_separation", 10)
	food_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	food_scroll_content.add_child(food_list)

	for index in range(FOOD_NAMES.size()):
		var food_id := _get_food_id(index)
		food_inventory[food_id] = int(food_inventory.get(food_id, 0))
		food_list.add_child(_create_food_card(index))

	boost_inventory_empty = PanelContainer.new()
	boost_inventory_empty.custom_minimum_size.y = 240.0
	boost_inventory_empty.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.04, 0.055, 0.09, 0.94), Color(0.48, 0.76, 1.0, 0.55), 18, 1, -1, 3))
	food_scroll_content.add_child(boost_inventory_empty)
	var boost_empty_label := Label.new()
	boost_empty_label.text = "NO BOOSTS YET\nBuy one in Shop. Then use it instantly or drag it onto the cat."
	boost_empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boost_empty_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	boost_empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	boost_empty_label.add_theme_font_size_override("font_size", 18)
	boost_empty_label.add_theme_color_override("font_color", Color(0.72, 0.82, 0.96))
	boost_inventory_empty.add_child(boost_empty_label)

	boost_inventory_grid = GridContainer.new()
	boost_inventory_grid.name = "BoostInventoryGrid"
	boost_inventory_grid.columns = 3
	boost_inventory_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boost_inventory_grid.add_theme_constant_override("h_separation", 10)
	boost_inventory_grid.add_theme_constant_override("v_separation", 10)
	food_scroll_content.add_child(boost_inventory_grid)

	# Keep the useful inventory content above the currency readout.
	content.add_child(food_wallet_label)

	food_back_button = Button.new()
	food_back_button.text = "BACK"
	food_back_button.custom_minimum_size = Vector2(0.0, 56.0)
	food_back_button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(food_back_button, Color(0.42, 0.5, 0.66, 1.0))
	content.add_child(food_back_button)


func _show_inventory_tab(tab_id: String) -> void:
	inventory_active_tab = tab_id if tab_id in ["food", "boosts"] else "food"
	if food_panel_mode != "inventory":
		inventory_active_tab = "food"
	var showing_food := inventory_active_tab == "food"
	food_list.visible = showing_food
	food_empty_state.visible = showing_food and _get_owned_food_type_count() == 0
	boost_inventory_grid.visible = not showing_food
	boost_inventory_empty.visible = not showing_food and _get_owned_boost_count() == 0
	food_status_label.text = "Use instantly, or drag food onto the cat." if showing_food else "Use instantly, or drag a boost onto the cat."
	for key in inventory_tab_buttons:
		var button := inventory_tab_buttons[key] as Button
		button.disabled = String(key) == inventory_active_tab
	if is_instance_valid(food_scroll):
		food_scroll.scroll_vertical = 0


func _get_owned_food_type_count() -> int:
	var total := 0
	for count in food_inventory.values():
		if int(count) > 0:
			total += 1
	return total


func _get_owned_boost_count() -> int:
	var total := 0
	for count in boost_inventory.values():
		total += maxi(0, int(count))
	return total


func _get_boost_inventory_key(boost_id: String, tier: int) -> String:
	return "%s:%d" % [boost_id, clampi(tier, 1, BoostLogic.MAX_BOOST_TIER)]


func _get_boost_icon(boost_data: Dictionary) -> Texture2D:
	var boost_id := String(boost_data.get("id", ""))
	if BOOST_ICONS.has(boost_id):
		return BOOST_ICONS[boost_id] as Texture2D
	return BOOST_TIER_ICONS.get(String(boost_data.get("category", "classical")), BOOST_TIER_ICONS["classical"]) as Texture2D


func _refresh_boost_inventory_ui() -> void:
	if not is_instance_valid(boost_inventory_grid):
		return
	for child in boost_inventory_grid.get_children():
		boost_inventory_grid.remove_child(child)
		child.queue_free()
	boost_inventory_cards.clear()
	for data in BoostLogic.BOOST_DATA:
		var boost_id := String(data["id"])
		for tier in range(1, BoostLogic.MAX_BOOST_TIER + 1):
			var key := _get_boost_inventory_key(boost_id, tier)
			var count := int(boost_inventory.get(key, 0))
			if count <= 0:
				continue
			var card := PanelContainer.new()
			card.custom_minimum_size = Vector2(0.0, 230.0)
			card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			card.mouse_filter = Control.MOUSE_FILTER_STOP
			card.mouse_default_cursor_shape = Control.CURSOR_DRAG
			card.tooltip_text = "Use instantly, or drag onto the cat"
			card.add_theme_stylebox_override("panel", _make_upgrade_card_style(data["accent"] as Color, false))
			card.gui_input.connect(_on_boost_icon_gui_input.bind(key))
			boost_inventory_grid.add_child(card)
			boost_inventory_cards[key] = card
			var margin := MarginContainer.new()
			margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_set_telegram_margins(margin, 8, 8, 8, 8)
			card.add_child(margin)
			var items := VBoxContainer.new()
			items.mouse_filter = Control.MOUSE_FILTER_IGNORE
			items.add_theme_constant_override("separation", 4)
			margin.add_child(items)
			var icon := TextureRect.new()
			icon.texture = _get_boost_icon(data)
			icon.custom_minimum_size = Vector2(0.0, 104.0)
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			items.add_child(icon)
			var name := Label.new()
			name.text = String(data["name"])
			name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			name.clip_text = true
			name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			name.add_theme_font_size_override("font_size", 12)
			name.mouse_filter = Control.MOUSE_FILTER_IGNORE
			items.add_child(name)
			var count_label := Label.new()
			count_label.text = "TIER %d  x%d" % [tier, count]
			count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			count_label.add_theme_font_size_override("font_size", 13)
			count_label.add_theme_color_override("font_color", data["accent"] as Color)
			count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			items.add_child(count_label)
			var use_button := Button.new()
			var is_active: bool = bool(boost_logic.is_active(boost_id))
			var is_recharging: bool = bool(boost_logic.is_recharging(boost_id))
			use_button.text = "ACTIVE" if is_active else ("RECHARGING" if is_recharging else "USE NOW")
			use_button.custom_minimum_size.y = 38.0
			use_button.mouse_filter = Control.MOUSE_FILTER_STOP
			use_button.disabled = is_active or is_recharging
			use_button.pressed.connect(_use_owned_boost.bind(key))
			_style_upgrade_button(use_button, data["accent"] as Color)
			items.add_child(use_button)
	boost_inventory_empty.visible = inventory_active_tab == "boosts" and _get_owned_boost_count() == 0


func _build_inventory_shop_buttons() -> void:
	inventory_shop_bar = HBoxContainer.new()
	inventory_shop_bar.name = "InventoryShopBar"
	inventory_shop_bar.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	inventory_shop_bar.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	inventory_shop_bar.grow_vertical = Control.GROW_DIRECTION_BEGIN
	inventory_shop_bar.add_theme_constant_override("separation", 10)
	add_child(inventory_shop_bar)
	move_child(inventory_shop_bar, menu_overlay.get_index())
	inventory_button = _make_bottom_nav_button("")
	inventory_button.name = "BackpackButton"
	inventory_button.icon = BACKPACK_UI_ICON
	inventory_button.expand_icon = true
	inventory_button.add_theme_constant_override("icon_max_width", 48)
	inventory_button.tooltip_text = "Open backpack"
	shop_button = _make_bottom_nav_button("SHOP")
	inventory_shop_bar.add_child(inventory_button)
	inventory_shop_bar.add_child(shop_button)
	_build_compact_inventory_ui()


func _build_shop_section_navigation() -> void:
	var hosts: Array[VBoxContainer] = [
		upgrades_items,
		boosts_panel.find_child("BoostsItems", true, false) as VBoxContainer,
		food_panel.find_child("FoodItems", true, false) as VBoxContainer,
	]
	var current_sections := ["upgrades", "boosts", "food"]
	for host_index in range(hosts.size()):
		var host := hosts[host_index]
		if host == null:
			continue
		var bar := HBoxContainer.new()
		bar.name = "ShopSectionTabs"
		bar.set_meta("shop_section_host", current_sections[host_index])
		bar.add_theme_constant_override("separation", 8)
		host.add_child(bar)
		host.move_child(bar, mini(1, host.get_child_count() - 1))
		var buttons := {}
		for section in ["upgrades", "boosts", "food"]:
			var tab := Button.new()
			tab.text = String(section).to_upper()
			tab.custom_minimum_size.y = 48.0
			tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			tab.pressed.connect(_show_shop_section.bind(section))
			var accent := Color(0.25, 0.78, 1.0) if section == "upgrades" else (Color(0.68, 0.42, 1.0) if section == "boosts" else Color(0.96, 0.68, 0.26))
			_style_upgrade_button(tab, accent)
			bar.add_child(tab)
			buttons[section] = tab
		shop_section_bars.append(bar)
		shop_section_buttons.append(buttons)
		bar.visible = current_sections[host_index] != "food" or food_panel_mode == "shop"
	_refresh_shop_section_tabs()


func _refresh_shop_section_tabs() -> void:
	for buttons in shop_section_buttons:
		for raw_section in buttons:
			var section := String(raw_section)
			var tab := buttons[raw_section] as Button
			if tab != null:
				tab.disabled = section == active_shop_section


func _prepare_shop_section(section: String) -> Control:
	active_shop_section = section if section in ["upgrades", "boosts", "food"] else "upgrades"
	_refresh_shop_section_tabs()
	match active_shop_section:
		"boosts":
			boost_logic.update_ui()
			_apply_telegram_page_style(boosts_panel)
			_apply_boosts_responsive_layout()
			return boosts_panel
		"food":
			food_panel_mode = "shop"
			food_status_label.text = "Buy food here, then use it from the backpack."
			_update_food_ui()
			for bar in shop_section_bars:
				if String(bar.get_meta("shop_section_host", "")) == "food":
					bar.show()
			_apply_telegram_page_style(food_panel)
			_apply_food_grid_responsive_style()
			return food_panel
		_:
			_update_upgrade_ui()
			_update_stats_ui()
			_update_daily_reward_ui()
			_apply_telegram_page_style(upgrades_panel)
			_apply_upgrades_responsive_layout()
			return upgrades_panel


func _show_shop_section(section: String) -> void:
	_play_ui_sound()
	var panel := _prepare_shop_section(section)
	_show_overlay_panel(panel)
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_destination("shop")
	if section == "boosts":
		_tutorial_notify("boosts_opened")
	elif section == "food":
		_tutorial_notify("shop_opened")
	else:
		_tutorial_notify("upgrades_opened")


func _build_compact_inventory_ui() -> void:
	compact_inventory_panel = PanelContainer.new()
	compact_inventory_panel.name = "CompactInventoryPanel"
	compact_inventory_panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	compact_inventory_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	compact_inventory_panel.custom_minimum_size = Vector2(0.0, 0.0)
	compact_inventory_panel.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.035, 0.045, 0.08, 0.94), Color(0.96, 0.68, 0.26, 0.9), 8, 3, 5, 10))
	add_child(compact_inventory_panel)
	move_child(compact_inventory_panel, menu_overlay.get_index())
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 8)
	compact_inventory_panel.add_child(margin)
	compact_inventory_scroll = ScrollContainer.new()
	compact_inventory_scroll.custom_minimum_size = Vector2(0.0, 190.0)
	compact_inventory_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_configure_touch_scroll(compact_inventory_scroll)
	margin.add_child(compact_inventory_scroll)
	compact_inventory_list = VBoxContainer.new()
	compact_inventory_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	compact_inventory_list.add_theme_constant_override("separation", 5)
	compact_inventory_scroll.add_child(compact_inventory_list)
	compact_inventory_panel.hide()


func _refresh_compact_inventory() -> void:
	if not is_instance_valid(compact_inventory_list):
		return
	for child in compact_inventory_list.get_children():
		compact_inventory_list.remove_child(child)
		child.queue_free()
	var title := Label.new()
	title.text = "INVENTORY  /  DRAG FOOD TO THE CAT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(1.0, 0.88, 0.54, 1.0))
	_style_arcade_label_plate(title, Color(0.96, 0.68, 0.26, 1.0), true)
	compact_inventory_list.add_child(title)
	var found := false
	for index in range(FOOD_NAMES.size()):
		var food_id := _get_food_id(index)
		var count := int(food_inventory.get(food_id, 0))
		if count <= 0:
			continue
		found = true
		var data := _get_food_data(index)
		var boost := _get_food_boost(index)
		var card := PanelContainer.new()
		card.custom_minimum_size = Vector2(0.0, 82.0)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.tooltip_text = "Drag onto the cat for %d seconds" % int(boost["duration"])
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		card.mouse_default_cursor_shape = Control.CURSOR_DRAG
		card.add_theme_stylebox_override("panel", _make_upgrade_card_style(data["accent"] as Color, false))
		card.gui_input.connect(_on_food_icon_gui_input.bind(food_id))
		compact_inventory_list.add_child(card)
		var card_margin := MarginContainer.new()
		card_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card_margin.add_theme_constant_override("margin_left", 8)
		card_margin.add_theme_constant_override("margin_top", 7)
		card_margin.add_theme_constant_override("margin_right", 8)
		card_margin.add_theme_constant_override("margin_bottom", 7)
		card.add_child(card_margin)
		var row := HBoxContainer.new()
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_theme_constant_override("separation", 9)
		card_margin.add_child(row)
		var icon := TextureRect.new()
		icon.texture = _get_food_icon(index)
		icon.custom_minimum_size = Vector2(58.0, 58.0)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var icon_plate := PanelContainer.new()
		icon_plate.custom_minimum_size = Vector2(64.0, 64.0)
		icon_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_plate.add_theme_stylebox_override("panel", _make_arcade_compartment_style(data["accent"] as Color))
		icon_plate.add_child(icon)
		row.add_child(icon_plate)
		var text_column := VBoxContainer.new()
		text_column.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(text_column)
		var name_label := Label.new()
		name_label.text = "%s  x%d" % [String(data["name"]), count]
		name_label.add_theme_font_size_override("font_size", 15)
		name_label.add_theme_color_override("font_color", Color.WHITE)
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		name_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
		name_label.add_theme_constant_override("shadow_offset_y", 2)
		text_column.add_child(name_label)
		var effect_label := Label.new()
		effect_label.text = String(boost["text"])
		effect_label.add_theme_font_size_override("font_size", 14)
		effect_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.54, 1.0))
		effect_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text_column.add_child(effect_label)
	if not found:
		var empty := Label.new()
		empty.text = "No snack boosts owned"
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty.add_theme_font_size_override("font_size", 11)
		empty.add_theme_color_override("font_color", Color(0.65, 0.7, 0.8, 1.0))
		compact_inventory_list.add_child(empty)


func _make_bottom_nav_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(154.0, 58.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(button, Color(0.96, 0.68, 0.26, 1.0))
	return button


func _create_food_card(index: int) -> PanelContainer:
	var food_id := _get_food_id(index)
	var data := _get_food_data(index)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0.0, 174.0)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	card.gui_input.connect(_on_food_icon_gui_input.bind(food_id))
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(data["accent"] as Color, false))
	food_cards[food_id] = card
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	card.add_child(margin)
	var content := VBoxContainer.new()
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_theme_constant_override("separation", 5)
	margin.add_child(content)
	var icon_plate := PanelContainer.new()
	icon_plate.custom_minimum_size = Vector2(0.0, 58.0)
	icon_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_plate.add_theme_stylebox_override("panel", _make_arcade_compartment_style(data["accent"] as Color))
	content.add_child(icon_plate)
	var icon := TextureRect.new()
	icon.texture = _get_food_icon(index)
	icon.custom_minimum_size = Vector2(48.0, 48.0)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_plate.add_child(icon)
	var name_label := Label.new()
	name_label.text = String(data["name"]).to_upper()
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.clip_text = true
	name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	name_label.custom_minimum_size.x = 0.0
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 13)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(name_label)
	var boost: Dictionary = _get_food_boost(index)
	var boost_label := Label.new()
	boost_label.text = String(boost["text"])
	boost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	boost_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	boost_label.custom_minimum_size.x = 0.0
	boost_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	boost_label.add_theme_font_size_override("font_size", 12)
	boost_label.add_theme_color_override("font_color", Color(0.72, 0.9, 1.0, 1.0))
	boost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(boost_label)
	var count_label := Label.new()
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	count_label.clip_text = true
	count_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	count_label.custom_minimum_size.x = 0.0
	count_label.add_theme_font_size_override("font_size", 14)
	count_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.55, 1.0))
	count_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_style_arcade_label_plate(count_label, data["accent"] as Color)
	content.add_child(count_label)
	food_card_counts[food_id] = count_label
	var action := Button.new()
	action.custom_minimum_size = Vector2(0.0, 42.0)
	action.clip_text = true
	action.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	action.add_theme_font_size_override("font_size", 14)
	action.pressed.connect(_on_food_card_action_pressed.bind(food_id))
	_style_upgrade_button(action, data["accent"] as Color)
	content.add_child(action)
	card.set_meta("action_button", action)
	return card


func _get_food_id(index: int) -> String:
	return "food_%02d" % index


func _get_food_data(index: int) -> Dictionary:
	var hue := fmod(float(index) * 0.137, 1.0)
	return {"id": _get_food_id(index), "name": FOOD_NAMES[index], "cost": FOOD_COST, "accent": Color.from_hsv(hue, 0.62, 0.95)}


func _get_food_index(food_id: String) -> int:
	return clampi(int(food_id.get_slice("_", 1)), 0, FOOD_NAMES.size() - 1)


func _get_food_boost(index: int) -> Dictionary:
	# Every snack has a stable effect, so inventory choices are meaningful.
	return FOOD_BOOSTS[index % FOOD_BOOSTS.size()]


func _get_food_icon(index: int) -> Texture2D:
	var food_id := _get_food_id(index)
	if food_icon_cache.has(food_id):
		return food_icon_cache[food_id]
	var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	var accent: Color = _get_food_data(index)["accent"]
	_draw_food_icon(image, index, accent)
	var texture := ImageTexture.create_from_image(image)
	food_icon_cache[food_id] = texture
	return texture


func _draw_food_icon(image: Image, index: int, accent: Color) -> void:
	var style := index % 10
	match style:
		0:
			_draw_ellipse(image, Vector2(32, 33), Vector2(24, 16), Color(0.97, 0.93, 0.82, 1.0))
			_draw_ellipse(image, Vector2(32, 31), Vector2(18, 11), accent)
			_draw_ellipse(image, Vector2(25, 29), Vector2(3, 3), Color(1.0, 0.96, 0.76, 1.0))
		1:
			_draw_ellipse(image, Vector2(32, 32), Vector2(24, 21), Color(0.08, 0.12, 0.09, 1.0))
			_draw_ellipse(image, Vector2(32, 32), Vector2(18, 15), Color(0.98, 0.96, 0.86, 1.0))
			_draw_ellipse(image, Vector2(32, 32), Vector2(8, 7), accent)
		2:
			_draw_round_rect(image, Rect2(15, 19, 34, 28), 8.0, Color(0.96, 0.72, 0.42, 1.0))
			_draw_round_rect(image, Rect2(19, 23, 26, 20), 6.0, accent.lightened(0.08))
			_draw_rect(image, Rect2(22, 20, 20, 4), Color(1.0, 0.9, 0.66, 1.0))
		3:
			_draw_triangle(image, Vector2(15, 44), Vector2(49, 44), Vector2(33, 14), accent)
			_draw_triangle(image, Vector2(19, 41), Vector2(45, 41), Vector2(33, 20), Color(1.0, 0.86, 0.58, 1.0))
			_draw_ellipse(image, Vector2(33, 32), Vector2(4, 3), Color(0.55, 0.12, 0.08, 1.0))
		4:
			_draw_ellipse(image, Vector2(32, 34), Vector2(21, 16), Color(0.78, 0.42, 0.2, 1.0))
			_draw_ellipse(image, Vector2(32, 29), Vector2(19, 11), accent.lightened(0.08))
			_draw_rect(image, Rect2(18, 31, 28, 4), Color(1.0, 0.92, 0.62, 1.0))
		5:
			_draw_ellipse(image, Vector2(31, 35), Vector2(19, 14), Color(0.98, 0.92, 0.78, 1.0))
			_draw_ellipse(image, Vector2(34, 28), Vector2(15, 12), accent)
			_draw_rect(image, Rect2(29, 17, 6, 16), Color(0.32, 0.18, 0.08, 1.0))
		6:
			_draw_triangle(image, Vector2(17, 42), Vector2(50, 38), Vector2(24, 18), Color(0.12, 0.38, 0.14, 1.0))
			_draw_triangle(image, Vector2(20, 39), Vector2(44, 36), Vector2(25, 21), accent)
			_draw_ellipse(image, Vector2(29, 32), Vector2(3, 3), Color(0.98, 0.9, 0.62, 1.0))
		7:
			_draw_round_rect(image, Rect2(18, 17, 28, 34), 7.0, Color(0.9, 0.7, 0.42, 1.0))
			_draw_rect(image, Rect2(19, 18, 26, 12), accent.lightened(0.1))
			_draw_ellipse(image, Vector2(26, 24), Vector2(2, 2), Color(1.0, 0.96, 0.76, 1.0))
			_draw_ellipse(image, Vector2(37, 24), Vector2(2, 2), Color(1.0, 0.96, 0.76, 1.0))
		8:
			_draw_ellipse(image, Vector2(25, 34), Vector2(9, 16), accent)
			_draw_ellipse(image, Vector2(39, 31), Vector2(9, 16), accent.darkened(0.08))
			_draw_ellipse(image, Vector2(32, 31), Vector2(3, 4), Color(1.0, 0.94, 0.72, 1.0))
		_:
			_draw_round_rect(image, Rect2(17, 18, 30, 28), 5.0, Color(0.94, 0.78, 0.55, 1.0))
			_draw_round_rect(image, Rect2(18, 17, 28, 11), 5.0, accent)
			_draw_rect(image, Rect2(21, 33, 22, 4), Color(1.0, 0.94, 0.72, 1.0))
	_draw_icon_shadow(image)


func _draw_icon_shadow(image: Image) -> void:
	for y in range(50, 56):
		for x in range(18, 47):
			var dx := (float(x) - 32.0) / 18.0
			var dy := (float(y) - 53.0) / 4.0
			if dx * dx + dy * dy <= 1.0 and image.get_pixel(x, y).a < 0.1:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.18))


func _draw_rect(image: Image, rect: Rect2, color: Color) -> void:
	for y in range(maxi(0, int(rect.position.y)), mini(64, int(rect.end.y))):
		for x in range(maxi(0, int(rect.position.x)), mini(64, int(rect.end.x))):
			image.set_pixel(x, y, color)


func _draw_round_rect(image: Image, rect: Rect2, radius: float, color: Color) -> void:
	for y in range(maxi(0, int(rect.position.y)), mini(64, int(rect.end.y))):
		for x in range(maxi(0, int(rect.position.x)), mini(64, int(rect.end.x))):
			var px := clampf(float(x), rect.position.x + radius, rect.end.x - radius)
			var py := clampf(float(y), rect.position.y + radius, rect.end.y - radius)
			if Vector2(float(x), float(y)).distance_to(Vector2(px, py)) <= radius:
				image.set_pixel(x, y, color)


func _draw_ellipse(image: Image, center: Vector2, radius: Vector2, color: Color) -> void:
	for y in range(64):
		for x in range(64):
			var dx := (float(x) - center.x) / maxf(1.0, radius.x)
			var dy := (float(y) - center.y) / maxf(1.0, radius.y)
			if dx * dx + dy * dy <= 1.0:
				image.set_pixel(x, y, color)


func _draw_triangle(image: Image, a: Vector2, b: Vector2, c: Vector2, color: Color) -> void:
	var min_x := maxi(0, floori(minf(a.x, minf(b.x, c.x))))
	var max_x := mini(63, ceili(maxf(a.x, maxf(b.x, c.x))))
	var min_y := maxi(0, floori(minf(a.y, minf(b.y, c.y))))
	var max_y := mini(63, ceili(maxf(a.y, maxf(b.y, c.y))))
	var area := _edge(a, b, c)
	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var p := Vector2(float(x), float(y))
			var w0 := _edge(b, c, p)
			var w1 := _edge(c, a, p)
			var w2 := _edge(a, b, p)
			if (w0 >= 0 and w1 >= 0 and w2 >= 0 and area >= 0) or (w0 <= 0 and w1 <= 0 and w2 <= 0 and area <= 0):
				image.set_pixel(x, y, color)


func _edge(a: Vector2, b: Vector2, c: Vector2) -> float:
	return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x)


func _on_food_card_action_pressed(food_id: String) -> void:
	if food_panel_mode == "shop":
		_buy_food(food_id)
	else:
		_feed_cat(food_id)


func _on_food_icon_gui_input(event: InputEvent, food_id: String) -> void:
	if food_panel_mode != "inventory":
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			boost_drag_candidate_key = ""
			food_drag_candidate_id = food_id
			food_drag_candidate_start = event.global_position
			food_drag_candidate_touch_index = -1
			food_drag_candidate_started_msec = Time.get_ticks_msec()
		elif dragged_food_id == food_id:
			_finish_food_drag(event.global_position)
			get_viewport().set_input_as_handled()
		else:
			_clear_food_drag_candidate()
	elif event is InputEventMouseMotion:
		if dragged_food_id == food_id:
			_update_food_drag_preview(event.global_position)
		elif food_drag_candidate_id == food_id and event.global_position.distance_to(food_drag_candidate_start) >= 10.0:
			_start_food_drag(food_id, event.global_position)
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenTouch:
		if event.pressed:
			boost_drag_candidate_key = ""
			food_drag_candidate_id = food_id
			food_drag_candidate_start = event.position
			food_drag_candidate_touch_index = event.index
			food_drag_candidate_started_msec = Time.get_ticks_msec()
		elif dragged_food_id == food_id and event.index == dragged_food_touch_index:
			_finish_food_drag(event.position)
			dragged_food_touch_index = -1
			get_viewport().set_input_as_handled()
		elif event.index == food_drag_candidate_touch_index:
			_clear_food_drag_candidate()
	elif event is InputEventScreenDrag:
		if dragged_food_id == food_id and event.index == dragged_food_touch_index:
			_update_food_drag_preview(event.position)
			get_viewport().set_input_as_handled()
		elif food_drag_candidate_id == food_id and event.index == food_drag_candidate_touch_index and event.position.distance_to(food_drag_candidate_start) >= 18.0:
			dragged_food_touch_index = event.index
			_start_food_drag(food_id, event.position)
			get_viewport().set_input_as_handled()


func _on_boost_icon_gui_input(event: InputEvent, boost_key: String) -> void:
	if food_panel_mode != "inventory" or inventory_active_tab != "boosts":
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_clear_food_drag_candidate()
			boost_drag_candidate_key = boost_key
			food_drag_candidate_start = event.global_position
		else:
			if dragged_boost_key == boost_key:
				_finish_boost_drag(event.global_position)
				get_viewport().set_input_as_handled()
			boost_drag_candidate_key = ""
	elif event is InputEventMouseMotion:
		if dragged_boost_key == boost_key:
			_update_food_drag_preview(event.global_position)
		elif boost_drag_candidate_key == boost_key and event.global_position.distance_to(food_drag_candidate_start) >= 10.0:
			_start_boost_drag(boost_key, event.global_position)
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_clear_food_drag_candidate()
			boost_drag_candidate_key = boost_key
			food_drag_candidate_start = event.position
			food_drag_candidate_touch_index = event.index
		elif event.index == food_drag_candidate_touch_index:
			if dragged_boost_key == boost_key:
				_finish_boost_drag(event.position)
				get_viewport().set_input_as_handled()
			boost_drag_candidate_key = ""
	elif event is InputEventScreenDrag and event.index == food_drag_candidate_touch_index:
		if dragged_boost_key == boost_key:
			_update_food_drag_preview(event.position)
		elif boost_drag_candidate_key == boost_key and event.position.distance_to(food_drag_candidate_start) >= 18.0:
			_start_boost_drag(boost_key, event.position)
			get_viewport().set_input_as_handled()


func _start_boost_drag(boost_key: String, start_position: Vector2) -> void:
	if int(boost_inventory.get(boost_key, 0)) <= 0:
		return
	dragged_boost_key = boost_key
	boost_drag_candidate_key = ""
	dragged_food_touch_index = food_drag_candidate_touch_index
	var boost_data: Dictionary = boost_logic.get_data(boost_key.get_slice(":", 0))
	if boost_data.is_empty():
		dragged_boost_key = ""
		return
	if not is_instance_valid(dragged_food_preview):
		dragged_food_preview = TextureRect.new()
		dragged_food_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dragged_food_preview.z_index = 80
		click_popup_layer.add_child(dragged_food_preview)
	dragged_food_preview.size = Vector2(92.0, 92.0)
	dragged_food_preview.pivot_offset = dragged_food_preview.size * 0.5
	dragged_food_preview.texture = _get_boost_icon(boost_data)
	dragged_food_preview.modulate = Color.WHITE
	dragged_food_preview.show()
	_show_food_drop_target()
	_update_food_drag_preview(start_position)
	food_status_label.text = "Drop the boost on the cat."
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_destination("main", false)
		telegram_navigation.set_interaction_enabled(false)
	telegram_current_panel = null
	menu_overlay.hide()
	_resume_combo_after_menu()
	_resume_gameplay_time_after_menu()


func _finish_boost_drag(global_position: Vector2) -> void:
	if dragged_boost_key.is_empty():
		return
	var boost_key := dragged_boost_key
	dragged_boost_key = ""
	boost_drag_candidate_key = ""
	dragged_food_touch_index = -1
	if is_instance_valid(dragged_food_preview):
		dragged_food_preview.hide()
	if is_instance_valid(food_drag_drop_target):
		food_drag_drop_target.hide()
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_interaction_enabled(true)
	if not _is_cat_drop_position(global_position):
		food_status_label.text = "Boost returned to your backpack."
		_on_telegram_destination_requested("inventory", 0)
		return
	if not _use_owned_boost(boost_key):
		food_status_label.text = "That boost is already active or recharging."
		_on_telegram_destination_requested("inventory", 0)


func _use_owned_boost(boost_key: String) -> bool:
	if int(boost_inventory.get(boost_key, 0)) <= 0:
		food_status_label.text = "That boost is no longer in your inventory."
		return false
	var boost_id := boost_key.get_slice(":", 0)
	var tier := clampi(int(boost_key.get_slice(":", 1)), 1, BoostLogic.MAX_BOOST_TIER)
	if not boost_logic.activate_owned(boost_id, tier):
		food_status_label.text = "That boost is already active or recharging."
		return false
	boost_inventory[boost_key] = maxi(0, int(boost_inventory.get(boost_key, 0)) - 1)
	_refresh_boost_inventory_ui()
	_update_food_ui()
	_queue_save()
	var data: Dictionary = boost_logic.get_data(boost_id)
	food_status_label.text = "%s activated." % String(data.get("name", "Boost"))
	_animate_cat_feed()
	_spawn_floating_text(cat_button.get_global_rect().get_center(), String(data.get("name", "BOOST")), data.get("accent", Color.CYAN) as Color)
	return true


func _clear_food_drag_candidate() -> void:
	food_drag_candidate_id = ""
	food_drag_candidate_start = Vector2.ZERO
	food_drag_candidate_touch_index = -1
	food_drag_candidate_started_msec = 0


func _buy_food(food_id: String) -> void:
	var data := _get_food_data(_get_food_index(food_id))
	if not _spend_coins(int(data["cost"])):
		food_status_label.text = "Need %s kibbles for this food." % _format_number(int(data["cost"]))
		return
	food_inventory[food_id] = int(food_inventory.get(food_id, 0)) + 1
	_update_coins(false)
	_update_food_ui()
	_refresh_compact_inventory()
	_play_purchase_sound()
	_queue_save()
	food_status_label.text = "Bought %s." % String(data["name"])
	_tutorial_notify("food_bought")


func _start_food_drag(food_id: String, start_position := Vector2.INF) -> void:
	if int(food_inventory.get(food_id, 0)) <= 0:
		food_status_label.text = "Buy this food in the shop first."
		return
	var drag_touch_index := food_drag_candidate_touch_index
	_clear_food_drag_candidate()
	boost_drag_candidate_key = ""
	dragged_food_id = food_id
	dragged_food_touch_index = drag_touch_index
	food_drag_return_to_inventory = food_panel_mode == "inventory" and menu_overlay.visible
	if not is_instance_valid(dragged_food_preview):
		dragged_food_preview = TextureRect.new()
		dragged_food_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dragged_food_preview.z_index = 80
		click_popup_layer.add_child(dragged_food_preview)
	dragged_food_preview.size = Vector2(78.0, 78.0)
	dragged_food_preview.pivot_offset = dragged_food_preview.size * 0.5
	dragged_food_preview.texture = _get_food_icon(_get_food_index(food_id))
	dragged_food_preview.modulate = Color(1.0, 1.0, 1.0, 0.92)
	dragged_food_preview.show()
	_show_food_drop_target()
	_update_food_drag_preview(get_viewport().get_mouse_position() if start_position == Vector2.INF else start_position)
	food_status_label.text = "Drop it on the cat."
	# The drag leaves the inventory page immediately so the cat becomes the drop
	# target. Lock the pager until release so the same phone gesture cannot also
	# navigate to another page.
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_destination("main", false)
		telegram_navigation.set_interaction_enabled(false)
	telegram_current_panel = null
	menu_overlay.hide()
	_sync_main_pause_button("main")
	_resume_combo_after_menu()
	_resume_gameplay_time_after_menu()


func _update_food_drag_preview(global_position: Vector2) -> void:
	if is_instance_valid(dragged_food_preview):
		var preview_offset := Vector2(dragged_food_preview.pivot_offset.x, dragged_food_preview.size.y + 16.0)
		dragged_food_preview.global_position = global_position - preview_offset
	if is_instance_valid(food_drag_drop_target):
		var cat_rect := cat_button.get_global_rect()
		food_drag_drop_target.global_position = Vector2(cat_rect.get_center().x - food_drag_drop_target.size.x * 0.5, cat_rect.position.y - food_drag_drop_target.size.y - 12.0)
		food_drag_drop_target.text = "RELEASE TO USE" if _is_cat_drop_position(global_position) else "DROP ITEM HERE"


func _is_cat_drop_position(global_position: Vector2) -> bool:
	return cat_button.get_global_rect().grow(42.0).has_point(global_position)


func _show_food_drop_target() -> void:
	if not is_instance_valid(food_drag_drop_target):
		food_drag_drop_target = Label.new()
		food_drag_drop_target.custom_minimum_size = Vector2(220.0, 48.0)
		food_drag_drop_target.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		food_drag_drop_target.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		food_drag_drop_target.mouse_filter = Control.MOUSE_FILTER_IGNORE
		food_drag_drop_target.z_index = 79
		food_drag_drop_target.add_theme_font_size_override("font_size", 16)
		food_drag_drop_target.add_theme_color_override("font_color", Color.WHITE)
		food_drag_drop_target.add_theme_stylebox_override("normal", _make_arcade_compartment_style(Color(0.96, 0.68, 0.26, 1.0), true))
		click_popup_layer.add_child(food_drag_drop_target)
	food_drag_drop_target.text = "DROP FOOD HERE"
	food_drag_drop_target.show()


func _finish_food_drag(global_position: Vector2) -> void:
	if dragged_food_id.is_empty():
		return
	var food_id := dragged_food_id
	dragged_food_id = ""
	boost_drag_candidate_key = ""
	dragged_food_touch_index = -1
	if is_instance_valid(dragged_food_preview):
		dragged_food_preview.hide()
	if is_instance_valid(food_drag_drop_target):
		food_drag_drop_target.hide()
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_interaction_enabled(true)
	if _is_cat_drop_position(global_position):
		food_drag_return_to_inventory = false
		_feed_cat(food_id)
	else:
		food_status_label.text = "Dropped outside the cat. Food returned to Inventory."
		if food_drag_return_to_inventory and is_instance_valid(telegram_navigation):
			_on_telegram_destination_requested("inventory", 0)
	food_drag_return_to_inventory = false


func _feed_cat(food_id: String) -> void:
	if int(food_inventory.get(food_id, 0)) <= 0:
		return
	food_inventory[food_id] = int(food_inventory.get(food_id, 0)) - 1
	var food_data := _get_food_data(_get_food_index(food_id))
	var boost: Dictionary = _get_food_boost(_get_food_index(food_id))
	active_food_boosts[String(boost["id"])] = _get_unix_time() + float(boost["duration"])
	_update_food_ui()
	_refresh_compact_inventory()
	_update_upgrade_ui()
	_update_stats_ui()
	_queue_save()
	_play_bonus_sound()
	_animate_cat_feed()
	_spawn_floating_text(cat_button.get_global_rect().get_center(), "%s\n%s" % [String(food_data["name"]), String(boost["text"])], food_data["accent"] as Color)
	_tutorial_notify("food_used")


func _animate_cat_feed() -> void:
	if cat_tween != null and cat_tween.is_valid():
		cat_tween.kill()
	cat_button.pivot_offset = cat_button.size * 0.5
	cat_tween = create_tween()
	cat_tween.tween_property(cat_button, "scale", CAT_BONUS_POP_SCALE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	cat_tween.tween_property(cat_button, "scale", cat_base_scale, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _spawn_floating_text(origin: Vector2, text: String, accent: Color) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", accent.lightened(0.2))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.82))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.position = click_popup_layer.get_global_transform().affine_inverse() * origin - Vector2(130.0, 40.0)
	label.size = Vector2(260.0, 80.0)
	label.z_index = 72
	click_popup_layer.add_child(label)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 70.0, 0.9).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(Callable(label, "queue_free"))


func _is_food_boost_active(boost_id: String) -> bool:
	return float(active_food_boosts.get(boost_id, 0.0)) > _get_unix_time()


func _update_food_ui() -> void:
	if not is_instance_valid(food_panel):
		return
	food_panel_title.text = "SHOP / FOOD" if food_panel_mode == "shop" else "BACKPACK"
	inventory_tabs_bar.visible = food_panel_mode == "inventory"
	for bar in shop_section_bars:
		if String(bar.get_meta("shop_section_host", "")) == "food":
			bar.visible = food_panel_mode == "shop"
	var owned_types := 0
	var owned_items := 0
	for index in range(FOOD_NAMES.size()):
		var food_id := _get_food_id(index)
		var data := _get_food_data(index)
		var count := int(food_inventory.get(food_id, 0))
		if count > 0:
			owned_types += 1
			owned_items += count
		var count_label := food_card_counts.get(food_id) as Label
		if count_label != null:
			count_label.text = "OWNED x%d" % count if food_panel_mode == "shop" else "x%d" % count
		var card := food_cards.get(food_id) as PanelContainer
		if card == null:
			continue
		# The shop remains a catalogue; inventory is only what the player owns.
		card.visible = food_panel_mode == "shop" or count > 0
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		card.mouse_default_cursor_shape = Control.CURSOR_DRAG if food_panel_mode == "inventory" else Control.CURSOR_ARROW
		card.tooltip_text = "Drag onto the cat, or use instantly" if food_panel_mode == "inventory" else "Buy this food boost"
		var button := card.get_meta("action_button") as Button
		if button == null:
			continue
		if food_panel_mode == "shop":
			button.text = "BUY  -  %s" % _format_number(int(data["cost"]))
			button.disabled = coins < int(data["cost"])
		else:
			var boost: Dictionary = _get_food_boost(index)
			button.text = "USE NOW"
			button.disabled = count <= 0
	if food_panel_mode == "inventory":
		food_wallet_label.text = "%d FOOD  /  %d BOOSTS" % [owned_items, _get_owned_boost_count()]
		_refresh_boost_inventory_ui()
		_show_inventory_tab(inventory_active_tab)
	else:
		food_wallet_label.text = "%s KIBBLES AVAILABLE" % _format_coins()
		food_list.show()
		food_empty_state.hide()
		boost_inventory_grid.hide()
		boost_inventory_empty.hide()


func _open_shop_from_inventory() -> void:
	_on_telegram_destination_requested("shop", 0)


func _cleanup_food_boosts() -> void:
	var now := _get_unix_time()
	for boost_id in active_food_boosts.keys():
		if float(active_food_boosts[boost_id]) <= now:
			active_food_boosts.erase(boost_id)


func get_food_tap_multiplier() -> float:
	_cleanup_food_boosts()
	return 1.35 if _is_food_boost_active("snack_click") else 1.0


func get_food_bonus_chance_bonus() -> float:
	_cleanup_food_boosts()
	return 12.0 if _is_food_boost_active("snack_luck") else 0.0


func get_food_combo_multiplier() -> float:
	_cleanup_food_boosts()
	return 1.25 if _is_food_boost_active("snack_combo") else 1.0


func get_food_global_gain_multiplier() -> float:
	_cleanup_food_boosts()
	return 1.3 if _is_food_boost_active("snack_kibble") else 1.0


func get_food_bonus_payout_multiplier() -> float:
	_cleanup_food_boosts()
	return 1.2 if _is_food_boost_active("snack_bonus") else 1.0


func _add_boost_card(boost_data: Dictionary) -> void:
	var boost_id := String(boost_data["id"])
	var accent := boost_data["accent"] as Color
	var card := PanelContainer.new()
	card.name = "%sCard" % boost_id.to_pascal_case()
	card.custom_minimum_size = Vector2(0.0, 218.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
	card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, accent, true))
	card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, accent, false))
	boosts_list.add_child(card)
	boost_cards[boost_id] = card

	var margin := MarginContainer.new()
	margin.name = "CardMargin"
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var card_items := VBoxContainer.new()
	card_items.name = "CardItems"
	card_items.add_theme_constant_override("separation", 7)
	margin.add_child(card_items)

	var header := HBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 10)
	card_items.add_child(header)

	var badge := TextureRect.new()
	badge.name = "Badge"
	badge.texture = _get_boost_icon(boost_data)
	badge.custom_minimum_size = Vector2(58.0, 58.0)
	badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	badge.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	badge.tooltip_text = String(boost_data["badge"])
	header.add_child(badge)

	var name_label := Label.new()
	name_label.name = "Name"
	name_label.text = String(boost_data["name"])
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 19)
	name_label.add_theme_color_override("font_color", accent.lightened(0.25))
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(name_label)

	var status_label := Label.new()
	status_label.name = "Status"
	status_label.text = "READY TO ACTIVATE"
	status_label.add_theme_font_size_override("font_size", 13)
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(status_label)
	boost_status_labels[boost_id] = status_label

	var description := Label.new()
	description.name = "Description"
	description.text = String(boost_data["description"])
	description.add_theme_font_size_override("font_size", 15)
	description.add_theme_color_override("font_color", Color(0.78, 0.83, 0.91, 1.0))
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_items.add_child(description)

	var duration := float(boost_data["duration"])
	var tier_info := Label.new()
	tier_info.name = "TierInfo"
	var tier_values: PackedStringArray = []
	if duration > 0.0:
		for tier in range(1, BoostLogic.MAX_BOOST_TIER + 1):
			tier_values.append("%ds" % roundi(duration * tier))
		tier_info.text = "TIME: %s" % "  |  ".join(tier_values)
	elif boost_id == "nine_lives":
		for tier in range(1, BoostLogic.MAX_BOOST_TIER + 1):
			tier_values.append(str(3 * tier))
		tier_info.text = "TAPS: %s" % "  |  ".join(tier_values)
	else:
		for tier in range(1, BoostLogic.MAX_BOOST_TIER + 1):
			tier_values.append(boost_logic.get_tier_name(tier))
		tier_info.text = "  |  ".join(tier_values)
	tier_info.add_theme_font_size_override("font_size", 13)
	tier_info.add_theme_color_override("font_color", Color(0.58, 0.64, 0.74, 1.0))
	card_items.add_child(tier_info)

	var actions := HBoxContainer.new()
	actions.name = "Actions"
	actions.add_theme_constant_override("separation", 8)
	card_items.add_child(actions)

	var buttons: Array[Button] = []
	for tier in range(1, BoostLogic.MAX_BOOST_TIER + 1):
		var action := Button.new()
		action.custom_minimum_size = Vector2(0.0, 58.0)
		action.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		action.add_theme_font_size_override("font_size", 14)
		action.pressed.connect(boost_logic.purchase.bind(boost_id, tier))
		_style_upgrade_button(action, accent)
		actions.add_child(action)
		buttons.append(action)
	boost_action_buttons[boost_id] = buttons
	card.set_meta("margin", margin)
	card.set_meta("header", header)
	card.set_meta("badge", badge)
	card.set_meta("name_label", name_label)
	card.set_meta("status_label", status_label)
	card.set_meta("description", description)
	card.set_meta("tier_info", tier_info)
	card.set_meta("actions", actions)
	_style_arcade_label_plate(status_label, accent)
	_style_arcade_label_plate(tier_info, accent)
	_style_arcade_card_content(card, accent)


func _add_skin_card(skin_data: Dictionary) -> void:
	var skin_id := String(skin_data["id"])
	var card := PanelContainer.new()
	card.set_meta("skins_role", "skin_card")
	card.custom_minimum_size = Vector2(0.0, 214.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(SKIN_ACCENT, false))
	card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, SKIN_ACCENT, true))
	card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, SKIN_ACCENT, false))
	skins_list.add_child(card)

	var margin := MarginContainer.new()
	margin.name = "SkinCardMargin"
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.name = "SkinCardRow"
	row.add_theme_constant_override("separation", 14)
	margin.add_child(row)

	var preview := TextureRect.new()
	preview.name = "SkinPreview"
	preview.custom_minimum_size = Vector2(150.0, 150.0)
	preview.texture = load(String(skin_data["texture"])) as Texture2D
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(preview)
	skin_previews[skin_id] = preview
	var lock_label := Label.new()
	lock_label.name = "LockOverlay"
	lock_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	lock_label.text = "LOCKED\n🔒"
	lock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lock_label.add_theme_font_size_override("font_size", 24)
	lock_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.3, 1.0))
	lock_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.95))
	lock_label.add_theme_constant_override("shadow_offset_x", 2)
	lock_label.add_theme_constant_override("shadow_offset_y", 3)
	lock_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.add_child(lock_label)

	var info := VBoxContainer.new()
	info.name = "SkinInfo"
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
	price_label.text = "STARTER SKIN" if cost == 0 else "UNLOCK FROM CAT CRATES"
	price_label.add_theme_font_size_override("font_size", 16)
	price_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.42, 1.0))
	info.add_child(price_label)

	var bonus_label := Label.new()
	bonus_label.text = String(skin_data.get("bonus_text", "No skin power"))
	bonus_label.add_theme_font_size_override("font_size", 15)
	bonus_label.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0, 1.0))
	bonus_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_child(bonus_label)

	var action_button := Button.new()
	action_button.custom_minimum_size = Vector2(0.0, 52.0)
	action_button.add_theme_font_size_override("font_size", 18)
	action_button.pressed.connect(_on_skin_action_pressed.bind(skin_id))
	_style_upgrade_button(action_button, SKIN_ACCENT)
	info.add_child(action_button)
	skin_action_buttons[skin_id] = action_button


func _add_skin_set_card(set_data: Dictionary) -> void:
	var set_id := String(set_data["id"])
	var accent := set_data["accent"] as Color
	var card := PanelContainer.new()
	card.set_meta("skins_role", "set_card")
	card.custom_minimum_size = Vector2(0.0, 116.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
	skins_list.add_child(card)

	var margin := MarginContainer.new()
	margin.name = "SkinSetMargin"
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 12)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.name = "SkinSetRow"
	row.add_theme_constant_override("separation", 14)
	margin.add_child(row)
	var icon := Label.new()
	icon.text = String(set_data["icon"])
	icon.custom_minimum_size = Vector2(54.0, 0.0)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon.add_theme_font_size_override("font_size", 34)
	icon.add_theme_color_override("font_color", accent)
	row.add_child(icon)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(info)
	var name_label := Label.new()
	name_label.text = String(set_data["name"]).to_upper()
	name_label.add_theme_font_size_override("font_size", 19)
	info.add_child(name_label)
	var progress_label := Label.new()
	progress_label.add_theme_font_size_override("font_size", 14)
	progress_label.add_theme_color_override("font_color", Color(0.72, 0.8, 0.88, 1.0))
	info.add_child(progress_label)
	skin_set_progress_labels[set_id] = progress_label
	var bonus_label := Label.new()
	bonus_label.add_theme_font_size_override("font_size", 15)
	info.add_child(bonus_label)
	skin_set_bonus_labels[set_id] = bonus_label


func _add_room_skin_card(room_skin_data: Dictionary) -> void:
	var room_skin_id := String(room_skin_data["id"])
	var accent := room_skin_data["accent"] as Color
	var card := PanelContainer.new()
	card.set_meta("skins_role", "room_card")
	card.custom_minimum_size = Vector2(152.0, 184.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
	room_skins_list.add_child(card)
	var margin := MarginContainer.new()
	margin.name = "RoomSkinMargin"
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 7)
	card.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 5)
	margin.add_child(content)
	var preview := TextureRect.new()
	preview.name = "RoomSkinPreview"
	preview.custom_minimum_size = Vector2(138.0, 110.0)
	preview.texture = load(String(room_skin_data["texture"])) as Texture2D
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	content.add_child(preview)
	var name_label := Label.new()
	name_label.text = String(room_skin_data["name"]).to_upper()
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_label.add_theme_font_size_override("font_size", 12)
	content.add_child(name_label)
	var action := Button.new()
	action.custom_minimum_size = Vector2(0.0, 40.0)
	action.pressed.connect(_on_room_skin_pressed.bind(room_skin_id))
	_style_upgrade_button(action, accent)
	content.add_child(action)
	room_skin_action_buttons[room_skin_id] = action


func _on_room_skin_pressed(room_skin_id: String) -> void:
	if _get_room_skin_data(room_skin_id).is_empty():
		return
	equipped_room_skin_id = room_skin_id
	_apply_equipped_room_skin()
	_update_skins_ui()
	_play_ui_sound()
	_save_game()
	_tutorial_notify("background_changed")


func _update_skins_ui() -> void:
	if not is_instance_valid(skins_wallet_label):
		return

	var unlocked_count := _get_unlocked_skin_count()
	skins_wallet_label.text = "%d / %d GEM SKINS UNLOCKED" % [unlocked_count, SKIN_DATA.size()]
	for set_data in SKIN_SET_DATA:
		var set_id := String(set_data["id"])
		var owned_count := _get_owned_set_member_count(set_data)
		var member_count: int = (set_data["members"] as Array).size()
		var complete := owned_count >= member_count
		var progress_label := skin_set_progress_labels.get(set_id) as Label
		var bonus_label := skin_set_bonus_labels.get(set_id) as Label
		if progress_label != null:
			progress_label.text = "%d / %d cats owned" % [owned_count, member_count]
		if bonus_label != null:
			bonus_label.text = ("ACTIVE  •  " if complete else "LOCKED  •  ") + String(set_data["bonus_text"])
			bonus_label.add_theme_color_override("font_color", Color(0.58, 1.0, 0.62, 1.0) if complete else Color(0.6, 0.66, 0.72, 1.0))
	for skin_data in SKIN_DATA:
		var skin_id := String(skin_data["id"])
		var owned := _owns_skin(skin_id)
		var preview := skin_previews.get(skin_id) as TextureRect
		if preview != null:
			preview.texture = load(String(skin_data["texture"])) as Texture2D if owned else null
			var lock_overlay := preview.get_node_or_null("LockOverlay") as Label
			if lock_overlay != null:
				lock_overlay.visible = not owned
		var action_button := skin_action_buttons.get(skin_id) as Button
		if action_button == null:
			continue
		if skin_id == equipped_skin_id:
			action_button.text = "EQUIPPED"
			action_button.disabled = true
		elif owned:
			action_button.text = "EQUIP"
			action_button.disabled = false
		else:
			action_button.disabled = true
			action_button.text = "LOCKED: %d / %d GEMS" % [crate_logic.get_fragments(skin_id), crate_logic.get_skin_unlock_cost(skin_data)]
			action_button.text = "LOCKED • FIND THIS GEM IN CRATES"
		if not owned:
			action_button.text = "LOCKED: %d / %d GEMS" % [crate_logic.get_fragments(skin_id), crate_logic.get_skin_unlock_cost(skin_data)]

	for room_skin_data in ROOM_SKIN_DATA:
		var room_skin_id := String(room_skin_data["id"])
		var room_action := room_skin_action_buttons.get(room_skin_id) as Button
		if room_action != null:
			room_action.text = "EQUIPPED" if room_skin_id == equipped_room_skin_id else "EQUIP"
			room_action.disabled = room_skin_id == equipped_room_skin_id


func _on_skin_action_pressed(skin_id: String) -> void:
	var skin_data := _get_skin_data(skin_id)
	if skin_data.is_empty():
		return

	if _owns_skin(skin_id):
		equipped_skin_id = skin_id
		_apply_equipped_skin()
		skins_status_label.text = "%s equipped. %s" % [String(skin_data["name"]), _get_skin_bonus_text(skin_data)]
		_update_daily_reward_ui()
		_update_upgrade_ui()
		_update_stats_ui()
		_update_skins_ui()
		_play_ui_sound()
		_save_game()
		return

	skins_status_label.text = "Find the %s gem inside a crate to unlock this skin." % String(skin_data["name"])


func _owns_skin(skin_id: String) -> bool:
	return skin_id == DEFAULT_SKIN_ID or skin_id in owned_skin_ids


func _get_skin_data(skin_id: String) -> Dictionary:
	for skin_data in SKIN_DATA:
		if String(skin_data["id"]) == skin_id:
			return skin_data
	return {}


func _is_valid_skin_id(skin_id: String) -> bool:
	return not _get_skin_data(skin_id).is_empty()


func _get_skin_bonus_text(skin_data: Dictionary) -> String:
	return String(skin_data.get("bonus_text", "No skin power"))


func _get_equipped_skin_bonus_data() -> Dictionary:
	var skin_data := _get_skin_data(equipped_skin_id)
	if skin_data.is_empty():
		return {}
	return skin_data.get("bonus", {})


func _get_owned_set_member_count(set_data: Dictionary) -> int:
	var count := 0
	for member_id in set_data.get("members", []):
		if _owns_skin(String(member_id)):
			count += 1
	return count


func _is_skin_set_complete(set_data: Dictionary) -> bool:
	var members: Array = set_data.get("members", [])
	return not members.is_empty() and _get_owned_set_member_count(set_data) == members.size()


func _get_skin_set_bonus_value(bonus_key: String, default_value: float) -> float:
	var result := default_value
	for set_data in SKIN_SET_DATA:
		if not _is_skin_set_complete(set_data):
			continue
		var bonus: Dictionary = set_data.get("bonus", {})
		if bonus.has(bonus_key):
			if default_value == 1.0:
				result *= float(bonus[bonus_key])
			else:
				result += float(bonus[bonus_key])
	return result


func _get_equipped_skin_name() -> String:
	var skin_data := _get_skin_data(equipped_skin_id)
	if skin_data.is_empty():
		return "Classic Cat"
	return String(skin_data.get("name", "Classic Cat"))


func _get_room_skin_data(room_skin_id: String) -> Dictionary:
	for room_skin_data in ROOM_SKIN_DATA:
		if String(room_skin_data["id"]) == room_skin_id:
			return room_skin_data
	return {}


func _apply_equipped_room_skin() -> void:
	var room_skin_data := _get_room_skin_data(equipped_room_skin_id)
	if room_skin_data.is_empty():
		equipped_room_skin_id = DEFAULT_ROOM_SKIN_ID
		room_skin_data = _get_room_skin_data(equipped_room_skin_id)
	var texture := load(String(room_skin_data.get("texture", ""))) as Texture2D
	if texture != null:
		room_background.texture = texture


func _get_global_gain_multiplier() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	var gem_multiplier: float = crate_logic.get_global_multiplier() if crate_logic != null else 1.0
	var boost_multiplier: float = boost_logic.get_global_gain_multiplier() if boost_logic != null else 1.0
	var event_multiplier: float = random_event_logic.get_global_gain_multiplier() if random_event_logic != null else 1.0
	var food_multiplier := get_food_global_gain_multiplier()
	var upgrade_multiplier := 1.0 + (0.03 * get_extended_upgrade_level("kibble_alchemy")) + get_advanced_upgrade_bonus("all")
	var bowl_multiplier: float = bottomless_bowl_logic.get_gain_multiplier() if bottomless_bowl_logic != null else 1.0
	return float(bonus_data.get("all_gain_mult", 1.0)) * _get_skin_set_bonus_value("all_gain_mult", 1.0) * gem_multiplier * boost_multiplier * event_multiplier * food_multiplier * upgrade_multiplier * bowl_multiplier


func _get_click_gain_multiplier() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("click_gain_mult", 1.0)) * _get_skin_set_bonus_value("click_gain_mult", 1.0) * (1.0 + (0.05 * get_extended_upgrade_level("tap_mastery")) + get_advanced_upgrade_bonus("tap"))


func _get_daily_reward_multiplier() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("daily_reward_mult", 1.0)) * (1.0 + (0.10 * get_extended_upgrade_level("daily_feast")) + get_advanced_upgrade_bonus("daily"))


func _get_bonus_chance_bonus_percent() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("bonus_chance_bonus", 0.0)) + _get_skin_set_bonus_value("bonus_chance_bonus", 0.0) + (0.5 * get_extended_upgrade_level("lucky_whiskers")) + get_advanced_upgrade_bonus("luck")


func _get_bonus_value_multiplier_bonus() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("bonus_value_mult", 1.0)) * (1.0 + get_advanced_upgrade_bonus("bonus"))


func _get_streak_bonus() -> int:
	var bonus_data := _get_equipped_skin_bonus_data()
	return int(bonus_data.get("streak_bonus", 0)) + roundi(get_advanced_upgrade_bonus("streak"))


func _get_passive_gain_bonus() -> int:
	var bonus_data := _get_equipped_skin_bonus_data()
	return int(bonus_data.get("passive_gain_bonus", 0))


func _get_effective_passive_gain() -> int:
	var base_gain := passive_clicks_per_minute + _get_passive_gain_bonus()
	return _safe_resource_round(float(base_gain) * (1.0 + 0.1 * get_extended_upgrade_level("dream_engine") + get_advanced_upgrade_bonus("idle")), 1)


func get_extended_upgrade_level(upgrade_id: String) -> int:
	return int(extended_upgrade_levels.get(upgrade_id, 0))


func get_advanced_upgrade_bonus(effect: String) -> float:
	var total := 0.0
	for data in EXTENDED_UPGRADE_DATA:
		if String(data.get("category", "classical")) != "classical" and String(data.get("effect", "")) == effect:
			total += float(data.get("amount", 0.0)) * get_extended_upgrade_level(String(data["id"]))
	return total


func get_effective_combo_cap() -> float:
	return MAX_COMBO_BONUS + (0.1 * get_extended_upgrade_level("combo_capacity")) + get_advanced_upgrade_bonus("combo")


func get_effective_combo_taps_per_step(base_taps: int) -> int:
	return maxi(1, base_taps - get_extended_upgrade_level("combo_momentum"))


func get_offline_gain_max_seconds() -> int:
	return OFFLINE_GAIN_MAX_SECONDS + (get_extended_upgrade_level("offline_storage") * 60 * 60) + roundi(get_advanced_upgrade_bonus("storage") * 3600.0)


func _apply_skin_gain_bonus(amount: int, gain_type: String) -> int:
	if amount <= 0:
		return 0
	var total := float(amount) * _get_global_gain_multiplier()
	match gain_type:
		"click":
			total *= _get_click_gain_multiplier()
		"daily_reward":
			total *= _get_daily_reward_multiplier()
	return _safe_resource_round(total, 1)


func _has_special_skin_sparkles() -> bool:
	return equipped_skin_id in SPECIAL_SPARKLE_SKIN_IDS


func _get_special_skin_sparkle_colors() -> Array[Color]:
	match equipped_skin_id:
		"bronze":
			return [
				Color(0.62, 0.28, 0.08, 1.0),
				Color(0.82, 0.43, 0.12, 1.0),
				Color(0.48, 0.2, 0.05, 1.0),
			]
		"silver":
			return [
				Color(0.92, 0.94, 0.98, 1.0),
				Color(0.62, 0.68, 0.76, 1.0),
				Color(0.42, 0.48, 0.58, 1.0),
			]
		"gold":
			return [
				Color(1.0, 0.9, 0.12, 1.0),
				Color(1.0, 0.66, 0.0, 1.0),
				Color(1.0, 0.98, 0.48, 1.0),
			]
		"rainbow":
			return [
				Color(1.0, 0.36, 0.54, 0.98),
				Color(1.0, 0.78, 0.22, 0.98),
				Color(0.42, 0.95, 0.58, 0.98),
				Color(0.34, 0.76, 1.0, 0.98),
				Color(0.7, 0.5, 1.0, 0.98),
			]
	return [
		Color(1.0, 0.9, 0.5, 0.96),
		Color(1.0, 1.0, 1.0, 0.92),
	]


func _process_special_skin_sparkles(delta: float) -> void:
	if not background_effects_enabled or menu_overlay.visible or not _has_special_skin_sparkles():
		special_skin_sparkle_elapsed = 0.0
		return

	special_skin_sparkle_elapsed += delta
	var spawn_interval := 0.7 if low_quality_mode else (0.28 if equipped_skin_id == "rainbow" else 0.34)
	while special_skin_sparkle_elapsed >= spawn_interval:
		special_skin_sparkle_elapsed -= spawn_interval
		_spawn_special_skin_sparkles()


func _spawn_special_skin_sparkles() -> void:
	if not _has_special_skin_sparkles():
		return

	var cat_rect: Rect2 = cat_button.get_global_rect()
	var local_cat_rect := Rect2(
		cat_rect.position - click_popup_layer.global_position,
		cat_rect.size
	)
	var colors := _get_special_skin_sparkle_colors()
	var sparkle_count := 1 if low_quality_mode else 2

	for index in range(sparkle_count):
		var root := Control.new()
		root.name = "SkinSparkle"
		root.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.z_index = 70
		var sparkle_width := randf_range(13.0, 24.0)
		var sparkle_height := sparkle_width * randf_range(1.45, 1.8)
		root.size = Vector2(sparkle_width, sparkle_height)
		root.pivot_offset = root.size * 0.5

		var diamond := Line2D.new()
		diamond.width = randf_range(1.5, 2.6)
		diamond.default_color = colors.pick_random()
		diamond.antialiased = true
		diamond.joint_mode = Line2D.LINE_JOINT_ROUND
		diamond.begin_cap_mode = Line2D.LINE_CAP_ROUND
		diamond.end_cap_mode = Line2D.LINE_CAP_ROUND
		diamond.points = PackedVector2Array([
			Vector2(root.size.x * 0.5, 0.0),
			Vector2(root.size.x, root.size.y * 0.5),
			Vector2(root.size.x * 0.5, root.size.y),
			Vector2(0.0, root.size.y * 0.5),
			Vector2(root.size.x * 0.5, 0.0),
		])
		root.add_child(diamond)

		var x_margin := local_cat_rect.size.x * 0.08
		var y_margin := local_cat_rect.size.y * 0.06
		root.position = Vector2(
			randf_range(local_cat_rect.position.x + x_margin, local_cat_rect.end.x - x_margin),
			randf_range(local_cat_rect.position.y + y_margin, local_cat_rect.end.y - y_margin)
		) - root.pivot_offset
		root.scale = Vector2(0.35, 0.35)
		root.modulate.a = 0.0
		click_popup_layer.add_child(root)

		var drift := Vector2(randf_range(-8.0, 8.0), randf_range(-28.0, -10.0))
		var hold_time := randf_range(0.65, 1.0)
		var tween := create_tween()
		tween.tween_interval(float(index) * 0.1)
		tween.set_parallel(true)
		tween.tween_property(root, "scale", Vector2.ONE * randf_range(0.82, 1.08), 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(root, "modulate:a", randf_range(0.38, 0.58), 0.38).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.chain().tween_interval(hold_time)
		tween.chain().set_parallel(true)
		tween.tween_property(root, "position", root.position + drift, 1.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(root, "scale", Vector2(0.55, 0.55), 1.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(root, "modulate:a", 0.0, 1.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.chain().tween_callback(Callable(root, "queue_free"))


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
	for child in click_popup_layer.get_children():
		if child.name == "SkinSparkle":
			child.queue_free()
	special_skin_sparkle_elapsed = 0.0


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
	_style_arcade_label_plate(settings_passive_gain_cost_label, PASSIVE_UPGRADE_COLOR)
	_style_arcade_label_plate(offline_info_label, PASSIVE_UPGRADE_COLOR)
	_style_settings_slider(click_power_slider, CLICK_UPGRADE_COLOR)
	_style_settings_slider(click_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	_style_settings_slider(ui_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	_style_upgrade_button(settings_passive_gain_button, PASSIVE_UPGRADE_COLOR)
	_style_upgrade_button(open_upgrades_button, CHANCE_UPGRADE_COLOR)
	_style_upgrade_button(settings_back_button, Color(0.42, 0.5, 0.66, 1.0))
	click_settings_card.hide()
	offline_settings_card.hide()

	achievements_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.76, 0.6, 0.18, 0.92), 24, 2, -1, 18)
	)
	achievements_summary.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.12, 0.09, 0.025, 0.95), Color(1.0, 0.74, 0.2, 0.75), 16, 2, -1, 7)
	)
	achievements_progress_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.42, 1.0))
	_style_upgrade_progress(achievements_progress_bar, Color(1.0, 0.72, 0.2, 1.0))
	_style_upgrade_button(achievements_filter, Color(0.76, 0.6, 0.18, 1.0))
	achievements_list.add_theme_color_override("font_color", Color(0.76, 0.8, 0.88, 1.0))
	achievements_list.add_theme_color_override("font_selected_color", Color.WHITE)
	achievements_list.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.025, 0.03, 0.045, 0.98), Color(0.28, 0.3, 0.38, 1.0), 14, 1)
	)
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
	# Slider touches are captured in _input so decorative/overlapping UI cannot
	# intercept them before the slider receives the drag.
	slider.custom_minimum_size.y = 48.0
	slider.mouse_filter = Control.MOUSE_FILTER_STOP
	# Gameplay/settings values always grow from left to right. Text locale must
	# not silently flip slider geometry; the explicit accessibility option below
	# is the only setting allowed to reverse it.
	slider.layout_direction = Control.LAYOUT_DIRECTION_LTR
	slider.focus_mode = Control.FOCUS_NONE
	slider.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	slider.tick_count = 5
	slider.ticks_on_borders = true
	var track := StyleBoxFlat.new()
	track.bg_color = Color(0.25, 0.29, 0.35, 0.72)
	track.corner_radius_top_left = 4
	track.corner_radius_top_right = 4
	track.corner_radius_bottom_left = 4
	track.corner_radius_bottom_right = 4
	track.content_margin_top = 3.0
	track.content_margin_bottom = 3.0
	var fill := track.duplicate() as StyleBoxFlat
	fill.bg_color = accent
	var fill_highlight := fill.duplicate() as StyleBoxFlat
	fill_highlight.bg_color = accent.lightened(0.12)
	slider.add_theme_stylebox_override("slider", track)
	slider.add_theme_stylebox_override("grabber_area", fill)
	slider.add_theme_stylebox_override("grabber_area_highlight", fill_highlight)
	slider.add_theme_icon_override("grabber", load("res://assets/ui/navigation/slider_grabber.svg") as Texture2D)
	slider.add_theme_icon_override("grabber_highlight", load("res://assets/ui/navigation/slider_grabber_highlight.svg") as Texture2D)
	slider.add_theme_icon_override("tick", load("res://assets/ui/navigation/slider_tick.svg") as Texture2D)
	slider.add_theme_constant_override("center_grabber", 1)


func _build_runtime_settings_ui() -> void:
	var settings_items := $MenuOverlay/MenuCenter/SettingsPanel/SettingsMargin/SettingsItems as VBoxContainer
	var insert_index := audio_settings_card.get_index()
	performance_settings_card = _create_settings_card("Performance", Color(0.26, 0.86, 0.82), 0)
	settings_items.add_child(performance_settings_card)
	settings_items.move_child(performance_settings_card, insert_index)
	insert_index += 1
	touch_settings_card = _create_settings_card("Touch & Feedback", Color(1.0, 0.58, 0.34), 3)
	settings_items.add_child(touch_settings_card)
	settings_items.move_child(touch_settings_card, insert_index)
	_build_slider_sound_setting()
	_refresh_runtime_settings_ui()


func _create_settings_card(title_text: String, accent: Color, icon_index: int) -> PanelContainer:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.055, 0.062, 0.078, 0.96), Color(accent.r, accent.g, accent.b, 0.16), 22, 1, -1, 2)
	)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 0)
	margin.add_child(content)
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	header.custom_minimum_size.y = 56.0
	content.add_child(header)
	header.add_child(_create_settings_icon(icon_index))
	var title := Label.new()
	title.text = title_text
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", accent.lightened(0.18))
	header.add_child(title)
	if title_text == "Performance":
		low_quality_check_box = _create_settings_check("Low quality mode", accent)
		low_quality_check_box.toggled.connect(_on_low_quality_toggled)
		content.add_child(low_quality_check_box)
		content.add_child(_create_settings_row_separator(0))
		battery_saver_check_box = _create_settings_check("Battery saver (30 FPS)", accent)
		battery_saver_check_box.toggled.connect(_on_battery_saver_toggled)
		content.add_child(battery_saver_check_box)
		content.add_child(_create_settings_row_separator(0))
		optimized_tap_check_box = _create_settings_check("Optimized tap effects", accent)
		optimized_tap_check_box.toggled.connect(_on_optimized_tap_toggled)
		content.add_child(optimized_tap_check_box)
		content.add_child(_create_settings_row_separator(0))
		reduce_motion_check_box = _create_settings_check("Reduce motion", accent)
		reduce_motion_check_box.toggled.connect(_on_reduce_motion_toggled)
		content.add_child(reduce_motion_check_box)
		content.add_child(_create_settings_row_separator(0))
		background_effects_check_box = _create_settings_check("Background sparkles", accent)
		background_effects_check_box.toggled.connect(_on_background_effects_toggled)
		content.add_child(background_effects_check_box)
		content.add_child(_create_settings_row_separator(0))
		low_power_unfocused_check_box = _create_settings_check("Save power when unfocused", accent)
		low_power_unfocused_check_box.toggled.connect(_on_low_power_unfocused_toggled)
		content.add_child(low_power_unfocused_check_box)
		content.add_child(_create_settings_row_separator(0))
		var particle_row := HBoxContainer.new()
		particle_row.add_theme_constant_override("separation", 10)
		particle_row.custom_minimum_size.y = 54.0
		particle_row.add_child(_create_settings_icon(2))
		var particle_label := Label.new()
		particle_label.text = "Particle limit"
		particle_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		particle_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		particle_row.add_child(particle_label)
		content.add_child(particle_row)
		particle_limit_value_label = Label.new()
		particle_limit_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		particle_limit_value_label.add_theme_color_override("font_color", accent.lightened(0.18))
		particle_row.add_child(particle_limit_value_label)
		particle_limit_slider = HSlider.new()
		particle_limit_slider.min_value = 1
		particle_limit_slider.max_value = PARTICLE_LIMIT_INFINITE
		particle_limit_slider.step = 1
		particle_limit_slider.value_changed.connect(_on_particle_limit_changed)
		_style_settings_slider(particle_limit_slider, accent)
		content.add_child(particle_limit_slider)
	else:
		haptics_check_box = _create_settings_check("Vibration", accent)
		haptics_check_box.toggled.connect(_on_haptics_toggled)
		content.add_child(haptics_check_box)
		content.add_child(_create_settings_row_separator(0))
		var haptic_row := HBoxContainer.new()
		haptic_row.custom_minimum_size.y = 48.0
		var haptic_label := Label.new()
		haptic_label.text = "Vibration strength"
		haptic_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		haptic_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		haptic_row.add_child(haptic_label)
		haptic_strength_value_label = Label.new()
		haptic_strength_value_label.text = "%d%%" % haptic_strength
		haptic_strength_value_label.add_theme_color_override("font_color", accent.lightened(0.18))
		haptic_row.add_child(haptic_strength_value_label)
		content.add_child(haptic_row)
		haptic_strength_slider = HSlider.new()
		haptic_strength_slider.min_value = 0
		haptic_strength_slider.max_value = 100
		haptic_strength_slider.step = 5
		haptic_strength_slider.value_changed.connect(_on_haptic_strength_changed)
		_style_settings_slider(haptic_strength_slider, accent)
		content.add_child(haptic_strength_slider)
		content.add_child(_create_settings_row_separator(0))
		events_check_box = _create_settings_check("Events", accent)
		events_check_box.toggled.connect(_on_events_toggled)
		content.add_child(events_check_box)
		content.add_child(_create_settings_row_separator(0))
		floating_numbers_check_box = _create_settings_check("Floating tap numbers", accent)
		floating_numbers_check_box.toggled.connect(_on_floating_numbers_toggled)
		content.add_child(floating_numbers_check_box)
		content.add_child(_create_settings_row_separator(0))
		coin_trails_check_box = _create_settings_check("Kibble trails", accent)
		coin_trails_check_box.toggled.connect(_on_coin_trails_toggled)
		content.add_child(coin_trails_check_box)
		content.add_child(_create_settings_row_separator(0))
		menu_swipe_check_box = _create_settings_check("Swipe between settings tabs", accent)
		menu_swipe_check_box.toggled.connect(_on_menu_swipe_toggled)
		content.add_child(menu_swipe_check_box)
		content.add_child(_create_settings_row_separator(0))
		reverse_sliders_check_box = _create_settings_check("Reverse slider direction", accent)
		reverse_sliders_check_box.toggled.connect(_on_reverse_sliders_toggled)
		content.add_child(reverse_sliders_check_box)
	return card


func _build_slider_sound_setting() -> void:
	var audio_items := audio_settings_card.get_node_or_null("CardMargin/CardItems") as VBoxContainer
	if audio_items == null:
		return
	var master_block := VBoxContainer.new()
	master_block.add_theme_constant_override("separation", 0)
	var master_row := HBoxContainer.new()
	master_row.custom_minimum_size.y = 46.0
	var master_label := Label.new()
	master_label.text = "Master volume"
	master_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	master_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	master_row.add_child(master_label)
	master_volume_value_label = Label.new()
	master_volume_value_label.text = "%d%%" % roundi(master_volume * 100.0)
	master_volume_value_label.add_theme_color_override("font_color", Color(0.72, 0.62, 1.0))
	master_row.add_child(master_volume_value_label)
	master_block.add_child(master_row)
	master_volume_slider = HSlider.new()
	master_volume_slider.min_value = 0
	master_volume_slider.max_value = 100
	master_volume_slider.step = 1
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	_style_settings_slider(master_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	master_block.add_child(master_volume_slider)
	audio_items.add_child(master_block)
	audio_items.move_child(master_block, 1)

	audio_items.add_child(_create_settings_row_separator(0))
	click_sounds_check_box = _create_settings_check("Click sounds", Color(0.62, 0.48, 1.0, 1.0))
	click_sounds_check_box.toggled.connect(_on_click_sounds_toggled)
	audio_items.add_child(click_sounds_check_box)
	audio_items.add_child(_create_settings_row_separator(0))
	ui_sounds_check_box = _create_settings_check("Interface sounds", Color(0.62, 0.48, 1.0, 1.0))
	ui_sounds_check_box.toggled.connect(_on_ui_sounds_toggled)
	audio_items.add_child(ui_sounds_check_box)
	audio_items.add_child(_create_settings_row_separator(0))
	mute_unfocused_check_box = _create_settings_check("Mute when unfocused", Color(0.62, 0.48, 1.0, 1.0))
	mute_unfocused_check_box.toggled.connect(_on_mute_unfocused_toggled)
	audio_items.add_child(mute_unfocused_check_box)
	audio_items.add_child(_create_settings_row_separator(0))
	var sound_row := HBoxContainer.new()
	sound_row.custom_minimum_size.y = 58.0
	sound_row.add_theme_constant_override("separation", 10)
	sound_row.add_child(_create_settings_icon(5))
	var sound_label := Label.new()
	sound_label.text = "Slider sound"
	sound_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sound_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sound_row.add_child(sound_label)
	slider_sound_option = OptionButton.new()
	for name in ["Soft", "Confirm", "Panel"]:
		slider_sound_option.add_item(name)
	slider_sound_option.item_selected.connect(_on_slider_sound_selected)
	sound_row.add_child(slider_sound_option)
	audio_items.add_child(sound_row)


func _create_settings_check(text: String, accent: Color) -> CheckButton:
	var check := CheckButton.new()
	check.text = text
	check.custom_minimum_size.y = 60.0
	check.focus_mode = Control.FOCUS_NONE
	check.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	check.add_theme_font_size_override("font_size", 18)
	check.add_theme_color_override("font_color", Color(0.88, 0.92, 1.0))
	check.add_theme_color_override("font_pressed_color", Color(0.96, 0.98, 1.0))
	var switch_off := load("res://assets/ui/navigation/switch_off.svg") as Texture2D
	var switch_on := load("res://assets/ui/navigation/switch_on.svg") as Texture2D
	for state in ["unchecked", "unchecked_hover", "unchecked_pressed", "unchecked_disabled"]:
		check.add_theme_icon_override(state, switch_off)
	for state in ["checked", "checked_hover", "checked_pressed", "checked_disabled"]:
		check.add_theme_icon_override(state, switch_on)
	check.toggled.connect(_animate_settings_toggle.bind(check, accent))
	return check


func _animate_settings_toggle(_enabled: bool, check: CheckButton, _accent: Color) -> void:
	# Let the setting's own handler run first. This makes Reduce motion take
	# effect on the same interaction that enables it.
	await get_tree().process_frame
	if reduce_motion_enabled or not is_instance_valid(check):
		check.scale = Vector2.ONE
		check.modulate = Color.WHITE
		return
	var old_tween: Tween
	if check.has_meta("settings_toggle_tween"):
		old_tween = check.get_meta("settings_toggle_tween") as Tween
	if old_tween != null and old_tween.is_valid():
		old_tween.kill()
	check.pivot_offset = Vector2(check.size.x, check.size.y * 0.5)
	check.scale = Vector2.ONE
	check.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(check, "scale", Vector2(1.012, 1.012), 0.09).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(check, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	check.set_meta("settings_toggle_tween", tween)


func _animate_settings_value(label: Label, _accent: Color) -> void:
	if reduce_motion_enabled or not is_instance_valid(label):
		return
	var old_tween: Tween
	if label.has_meta("settings_value_tween"):
		old_tween = label.get_meta("settings_value_tween") as Tween
	if old_tween != null and old_tween.is_valid():
		old_tween.kill()
	label.pivot_offset = label.size * 0.5
	label.scale = Vector2.ONE
	label.modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(label, "scale", Vector2(1.075, 1.075), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label.set_meta("settings_value_tween", tween)


func _create_settings_icon(index: int) -> TextureRect:
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(42, 42)
	icon.texture = _get_settings_icon_texture(index)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon


func _get_settings_icon_texture(index: int) -> Texture2D:
	var atlas := AtlasTexture.new()
	if settings_icon_sheet_texture == null:
		# Resource loading respects imported textures in desktop, mobile, and web
		# exports; direct filesystem Image.load() does not survive packed builds.
		settings_icon_sheet_texture = load(SETTINGS_ICON_SHEET_PATH) as Texture2D
	if settings_icon_sheet_texture == null:
		return null
	atlas.atlas = settings_icon_sheet_texture
	var columns := 2
	var cell_size := Vector2(512, 512)
	atlas.region = Rect2(Vector2(index % columns, int(index / columns)) * cell_size, cell_size)
	return atlas


func _refresh_runtime_settings_ui() -> void:
	if is_instance_valid(low_quality_check_box):
		low_quality_check_box.set_pressed_no_signal(low_quality_enabled)
	if is_instance_valid(battery_saver_check_box):
		battery_saver_check_box.set_pressed_no_signal(battery_saver_enabled)
	if is_instance_valid(optimized_tap_check_box):
		optimized_tap_check_box.set_pressed_no_signal(optimized_tap_effects)
	if is_instance_valid(reduce_motion_check_box):
		reduce_motion_check_box.set_pressed_no_signal(reduce_motion_enabled)
	if is_instance_valid(background_effects_check_box):
		background_effects_check_box.set_pressed_no_signal(background_effects_enabled)
	if is_instance_valid(low_power_unfocused_check_box):
		low_power_unfocused_check_box.set_pressed_no_signal(low_power_unfocused)
	if is_instance_valid(particle_limit_slider):
		particle_limit_slider.set_value_no_signal(particle_limit)
	if is_instance_valid(particle_limit_value_label):
		particle_limit_value_label.text = _get_particle_limit_text()
	if is_instance_valid(haptics_check_box):
		haptics_check_box.set_pressed_no_signal(haptics_enabled)
	if is_instance_valid(haptic_strength_slider):
		haptic_strength_slider.set_value_no_signal(haptic_strength)
	if is_instance_valid(haptic_strength_value_label):
		haptic_strength_value_label.text = "%d%%" % haptic_strength
	if is_instance_valid(events_check_box):
		events_check_box.set_pressed_no_signal(events_enabled)
	if is_instance_valid(floating_numbers_check_box):
		floating_numbers_check_box.set_pressed_no_signal(floating_numbers_enabled)
	if is_instance_valid(coin_trails_check_box):
		coin_trails_check_box.set_pressed_no_signal(coin_trails_enabled)
	if is_instance_valid(menu_swipe_check_box):
		menu_swipe_check_box.set_pressed_no_signal(menu_swipe_enabled)
	if is_instance_valid(reverse_sliders_check_box):
		reverse_sliders_check_box.set_pressed_no_signal(reverse_sliders_enabled)
	if is_instance_valid(master_volume_slider):
		master_volume_slider.set_value_no_signal(master_volume * 100.0)
	if is_instance_valid(master_volume_value_label):
		master_volume_value_label.text = "%d%%" % roundi(master_volume * 100.0)
	if is_instance_valid(click_sounds_check_box):
		click_sounds_check_box.set_pressed_no_signal(click_sounds_enabled)
	if is_instance_valid(ui_sounds_check_box):
		ui_sounds_check_box.set_pressed_no_signal(ui_sounds_enabled)
	if is_instance_valid(mute_unfocused_check_box):
		mute_unfocused_check_box.set_pressed_no_signal(mute_unfocused)
	if is_instance_valid(slider_sound_option):
		slider_sound_option.select(clampi(slider_sound_style, 0, UI_SOUND_VARIANTS.size() - 1))
	if is_instance_valid(abbreviate_numbers_check_box):
		abbreviate_numbers_check_box.set_pressed_no_signal(abbreviate_numbers)
	if is_instance_valid(number_detail_slider):
		number_detail_slider.set_value_no_signal(number_detail_digits)
	if is_instance_valid(number_detail_value_label):
		number_detail_value_label.text = "%d digits" % number_detail_digits
	if is_instance_valid(exact_number_tooltips_check_box):
		exact_number_tooltips_check_box.set_pressed_no_signal(exact_number_tooltips)
	if is_instance_valid(group_full_numbers_check_box):
		group_full_numbers_check_box.set_pressed_no_signal(group_full_numbers)


func _handle_slider_touch(event: InputEvent) -> bool:
	if event is InputEventScreenTouch:
		if event.pressed:
			var slider := _get_slider_at_position(event.position)
			if slider != null:
				touch_slider = slider
				touch_slider_index = event.index
				_set_slider_from_touch(slider, event.position)
				return true
		elif event.index == touch_slider_index:
			_complete_slider_motion(touch_slider)
			touch_slider_index = -1
			touch_slider = null
			return true
	elif event is InputEventScreenDrag and event.index == touch_slider_index:
		if is_instance_valid(touch_slider):
			_set_slider_from_touch(touch_slider, event.position)
		return true
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var slider := _get_slider_at_position(event.position)
			if slider != null:
				touch_slider = slider
				mouse_slider_dragging = true
				_set_slider_from_touch(slider, event.position)
				return true
		elif mouse_slider_dragging:
			_complete_slider_motion(touch_slider)
			mouse_slider_dragging = false
			touch_slider = null
			return true
	elif event is InputEventMouseMotion and mouse_slider_dragging:
		if is_instance_valid(touch_slider) and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_set_slider_from_touch(touch_slider, event.position)
			return true
		mouse_slider_dragging = false
		_complete_slider_motion(touch_slider)
		touch_slider = null
	return false


func _get_slider_at_position(global_position: Vector2) -> Slider:
	# Reverse tree order mirrors Control hit testing, so the topmost slider wins.
	var sliders := find_children("*", "Slider", true, false)
	for index in range(sliders.size() - 1, -1, -1):
		var slider := sliders[index] as Slider
		if slider != null and slider.is_visible_in_tree() and slider.get_global_rect().has_point(global_position):
			return slider
	return null


func _set_slider_from_touch(slider: Slider, global_position: Vector2) -> void:
	var rect := slider.get_global_rect()
	var is_vertical := slider is VSlider
	var length := rect.size.y if is_vertical else rect.size.x
	if length <= 0.0:
		return
	var ratio := 1.0 - ((global_position.y - rect.position.y) / length) if is_vertical else (global_position.x - rect.position.x) / length
	ratio = clampf(ratio, 0.0, 1.0)
	var reverse_horizontal := reverse_sliders_enabled
	if not is_vertical and reverse_horizontal:
		ratio = 1.0 - ratio
	var target_value := lerpf(slider.min_value, slider.max_value, ratio)
	if slider.step > 0.0:
		target_value = snappedf(target_value, slider.step)
	target_value = clampf(target_value, slider.min_value, slider.max_value)
	var old_tween: Tween
	if slider.has_meta("smooth_value_tween"):
		old_tween = slider.get_meta("smooth_value_tween") as Tween
	if old_tween != null and old_tween.is_valid():
		old_tween.kill()
	slider.set_meta("smooth_target_value", target_value)
	var value_range := maxf(1.0, slider.max_value - slider.min_value)
	var distance_ratio := absf(target_value - slider.value) / value_range
	var duration := lerpf(0.045, 0.09, clampf(distance_ratio * 4.0, 0.0, 1.0))
	var tween := create_tween()
	tween.tween_property(slider, "value", target_value, duration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	slider.set_meta("smooth_value_tween", tween)


func _complete_slider_motion(slider: Slider) -> void:
	if not is_instance_valid(slider):
		return
	if slider.has_meta("smooth_value_tween"):
		var tween := slider.get_meta("smooth_value_tween") as Tween
		if tween != null and tween.is_valid():
			tween.kill()
	if slider.has_meta("smooth_target_value"):
		slider.value = float(slider.get_meta("smooth_target_value"))


func _build_extended_upgrades_ui() -> void:
	var back_index := upgrades_back_button.get_index()
	var tabs := GridContainer.new()
	tabs.name = "UpgradeCategoryTabs"
	tabs.columns = 5
	tabs.add_theme_constant_override("h_separation", 10)
	tabs.add_theme_constant_override("v_separation", 8)
	upgrades_items.add_child(tabs)
	upgrades_items.move_child(tabs, 1)
	for category in UPGRADE_CATEGORIES:
		var tab := Button.new()
		tab.text = _get_upgrade_category_label(category)
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab.custom_minimum_size = Vector2(0, 52)
		var accent := Color(0.3, 0.72, 1.0)
		if category == "advanced":
			accent = Color(0.82, 0.42, 1.0)
		elif category == "legendary":
			accent = Color(1.0, 0.72, 0.24)
		elif category == "mythic":
			accent = Color(0.45, 0.95, 0.82)
		elif category == "ascendant":
			accent = Color(1.0, 0.48, 0.82)
		elif category == "divine":
			accent = Color(1.0, 0.88, 0.42)
		elif category == "cosmic":
			accent = Color(0.48, 0.86, 1.0)
		elif category == "eternal":
			accent = Color(0.55, 1.0, 0.68)
		elif category == "transcendent":
			accent = Color(1.0, 0.45, 0.7)
		elif category == "omega":
			accent = Color(0.72, 1.0, 0.42)
		_style_upgrade_button(tab, accent)
		tab.set_meta("telegram_segment_accent", accent)
		tab.pressed.connect(_show_upgrade_category.bind(category))
		tabs.add_child(tab)
		upgrade_category_buttons[category] = tab
	back_index = upgrades_back_button.get_index()
	for upgrade_data in EXTENDED_UPGRADE_DATA:
		var card := _create_extended_upgrade_card(upgrade_data)
		upgrades_items.add_child(card)
		upgrades_items.move_child(card, back_index)
		back_index += 1
	_show_upgrade_category("classical")


func _show_upgrade_category(category: String) -> void:
	upgrade_active_category = category
	for card in [click_upgrade_card, bonus_chance_card, bonus_value_card, bonus_streak_card, passive_gain_card]:
		card.visible = category == "classical"
	for data in EXTENDED_UPGRADE_DATA:
		var controls: Dictionary = extended_upgrade_controls.get(String(data["id"]), {})
		if not controls.is_empty():
			(controls["card"] as Control).visible = String(data.get("category", "classical")) == category
	_refresh_telegram_segment_buttons(upgrade_category_buttons, upgrade_active_category)


func _create_extended_upgrade_card(upgrade_data: Dictionary) -> PanelContainer:
	var upgrade_id := String(upgrade_data["id"])
	var accent := upgrade_data["accent"] as Color
	var card := PanelContainer.new()
	card.name = "%sCard" % upgrade_id.to_pascal_case()

	var margin := MarginContainer.new()
	margin.name = "CardMargin"
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 11)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var items := VBoxContainer.new()
	items.name = "CardItems"
	items.add_theme_constant_override("separation", 5)
	margin.add_child(items)

	var header := HBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 10)
	items.add_child(header)

	var badge := Label.new()
	badge.name = "Badge"
	badge.custom_minimum_size = Vector2(94, 40)
	badge.text = String(upgrade_data["badge"])
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 17)
	header.add_child(badge)

	var title := Label.new()
	title.name = "Name"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.text = String(upgrade_data["name"])
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 17)
	header.add_child(title)

	var value_label := Label.new()
	value_label.text = "Lv. 0"
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.add_theme_font_size_override("font_size", 22)
	value_label.add_theme_color_override("font_color", accent.lightened(0.18))
	header.add_child(value_label)

	var progress_bar := ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(0, 10)
	progress_bar.show_percentage = false
	items.add_child(progress_bar)

	if upgrade_data.has("description"):
		var description := Label.new()
		description.text = String(upgrade_data["description"])
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.add_theme_font_size_override("font_size", 14)
		description.add_theme_color_override("font_color", Color(0.68, 0.73, 0.82, 1.0))
		items.add_child(description)

	var cost_label := Label.new()
	cost_label.text = "Loading upgrade..."
	cost_label.add_theme_font_size_override("font_size", 15)
	cost_label.add_theme_color_override("font_color", Color(0.78, 0.83, 0.91, 1.0))
	items.add_child(cost_label)

	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 50)
	button.add_theme_font_size_override("font_size", 19)
	button.text = "UPGRADE"
	button.pressed.connect(upgrade_logic.upgrade_extended.bind(upgrade_id))
	items.add_child(button)

	extended_upgrade_controls[upgrade_id] = {
		"card": card,
		"badge": badge,
		"value": value_label,
		"progress": progress_bar,
		"cost": cost_label,
		"button": button,
		"accent": accent,
	}
	extended_upgrade_cards.append(card)
	return card


func _setup_upgrade_visuals() -> void:
	upgrades_panel.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.25, 0.36, 1.0), 8, 3, 5, 18)
	)
	upgrade_hero.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.065, 0.09, 0.14, 1.0), Color(0.25, 0.7, 1.0, 0.72), 7, 2, 5, 10)
	)
	wallet_chip.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.14, 0.105, 0.035, 0.92), Color(1.0, 0.72, 0.16, 0.78), 6, 2, 3, 6)
	)
	var upgrades_title := upgrade_hero.find_child("UpgradesTitle", true, false) as Label
	if upgrades_title != null:
		upgrades_title.text = "UPGRADES"
		_style_arcade_heading(upgrades_title)

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
		_style_arcade_card_content(card, accent)

	for upgrade_id in extended_upgrade_controls:
		var controls: Dictionary = extended_upgrade_controls[upgrade_id]
		var card := controls["card"] as PanelContainer
		var button := controls["button"] as Button
		var progress_bar := controls["progress"] as ProgressBar
		var badge := controls["badge"] as Label
		var accent := controls["accent"] as Color
		card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
		card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, accent, true))
		card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, accent, false))
		_style_upgrade_button(button, accent)
		_style_upgrade_progress(progress_bar, accent)
		_style_arcade_card_content(card, accent)

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
	style.set_meta("base_bg_color", background)
	style.set_meta("base_border_color", border)
	style.set_border_width_all(border_width)
	if left_border_width >= 0:
		style.border_width_left = left_border_width
	style.set_corner_radius_all(radius)
	if shadow_size > 0:
		style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
		style.shadow_size = shadow_size
		style.shadow_offset = Vector2(0.0, 5.0)
	_apply_ui_tint_to_style(style)
	return style


func _is_default_ui_tint() -> bool:
	return (
		is_equal_approx(ui_tint.r, DEFAULT_UI_TINT.r)
		and is_equal_approx(ui_tint.g, DEFAULT_UI_TINT.g)
		and is_equal_approx(ui_tint.b, DEFAULT_UI_TINT.b)
	)


func _apply_ui_tint_to_control(control: Control) -> void:
	for style_name in [
		"panel",
		"normal",
		"hover",
		"pressed",
		"disabled",
		"focus",
		"background",
		"fill",
		"grabber_area",
		"grabber_area_highlight",
	]:
		var stylebox := control.get_theme_stylebox(style_name)
		if stylebox is StyleBoxFlat:
			_apply_ui_tint_to_style(stylebox as StyleBoxFlat)
	if control is Button:
		_apply_ui_tint_to_button_text(control as Button)
	elif control is Label or control is ProgressBar:
		_apply_ui_tint_to_control_text(control)


func _contrasting_ui_text_color(background: Color) -> Color:
	var luminance := 0.2126 * background.r + 0.7152 * background.g + 0.0722 * background.b
	return Color(0.055, 0.065, 0.085, 1.0) if luminance > 0.5 else Color(0.98, 0.99, 1.0, 1.0)


func _apply_ui_tint_to_control_text(control: Control) -> void:
	if not control.has_meta("base_font_color"):
		control.set_meta("base_font_color", control.get_theme_color("font_color"))
	control.add_theme_color_override("font_color", control.get_meta("base_font_color") as Color)


func _apply_ui_tint_to_button_text(button: Button) -> void:
	var color_names := ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color"]
	for color_name in color_names:
		var meta_name := "base_%s" % color_name
		if not button.has_meta(meta_name):
			button.set_meta(meta_name, button.get_theme_color(color_name))
		button.add_theme_color_override(color_name, button.get_meta(meta_name) as Color)


func _apply_ui_tint_to_style(style: StyleBoxFlat) -> void:
	if not style.has_meta("base_bg_color") or not style.has_meta("base_border_color"):
		return
	var base_bg := style.get_meta("base_bg_color") as Color
	var base_border := style.get_meta("base_border_color") as Color
	if _is_default_ui_tint():
		style.bg_color = base_bg
		style.border_color = base_border
		return
	if base_bg.a > 0.01:
		var tinted_bg := base_bg.lerp(ui_tint.darkened(0.42), 0.68)
		tinted_bg.a = maxf(base_bg.a, 0.96)
		style.bg_color = tinted_bg
	else:
		style.bg_color = base_bg
	if base_border.a > 0.01:
		var tinted_border := base_border.lerp(ui_tint.lightened(0.12), 0.72)
		tinted_border.a = maxf(base_border.a, 0.92)
		style.border_color = tinted_border
	else:
		style.border_color = base_border


func _make_upgrade_card_style(accent: Color, hovered: bool) -> StyleBoxFlat:
	var background := Color(0.055, 0.06, 0.07, 0.82)
	if hovered:
		background = Color(0.075, 0.08, 0.09, 0.94)
	var border := Color(accent.r, accent.g, accent.b, 0.52 if hovered else 0.28)
	var style := _make_upgrade_style(background, border, 7, 2, 4, 5 if hovered else 3)
	style.border_width_bottom = 3
	return style


func _make_arcade_compartment_style(accent: Color, strong := false) -> StyleBoxFlat:
	var background := Color(0.035, 0.043, 0.065, 0.96 if strong else 0.82)
	var border := Color(accent.r, accent.g, accent.b, 0.68 if strong else 0.38)
	var style := _make_upgrade_style(background, border, 6, 2, 3, 4 if strong else 2)
	style.border_width_bottom = 3
	style.content_margin_left = 8.0
	style.content_margin_right = 8.0
	style.content_margin_top = 4.0
	style.content_margin_bottom = 5.0
	return style


func _style_arcade_label_plate(label: Label, accent: Color, strong := false) -> void:
	label.add_theme_stylebox_override("normal", _make_arcade_compartment_style(accent, strong))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.88))
	label.add_theme_constant_override("shadow_offset_y", 2)


func _style_arcade_heading(label: Label) -> void:
	label.text = label.text.to_upper()
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.92))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 3)
	label.add_theme_constant_override("outline_size", 2)


func _style_arcade_card_content(card: PanelContainer, accent: Color) -> void:
	var header := card.find_child("Header", true, false) as HBoxContainer
	if header != null:
		header.add_theme_constant_override("separation", 8)
	var badge := card.find_child("Badge", true, false) as Label
	if badge != null:
		badge.add_theme_color_override("font_color", accent.lightened(0.18))
		_style_arcade_label_plate(badge, accent, true)
	var name_label := card.find_child("Name", true, false) as Label
	if name_label != null:
		name_label.text = name_label.text.to_upper()
		name_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
		name_label.add_theme_constant_override("shadow_offset_y", 2)
	var items := card.find_child("CardItems", true, false) as VBoxContainer
	if items != null:
		items.add_theme_constant_override("separation", 6)
	for child in card.find_children("*CostLabel", "Label", true, false):
		_style_arcade_label_plate(child as Label, accent)


func _set_upgrade_card_hover(card: PanelContainer, accent: Color, hovered: bool) -> void:
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, hovered))


func _style_upgrade_button(button: Button, accent: Color) -> void:
	button.set_meta("normal_style_accent", accent)
	button.flat = false
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_color_override("font_color", Color(0.98, 0.99, 1.0, 1.0))
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_color_override("font_disabled_color", Color(0.48, 0.52, 0.61, 1.0))
	button.add_theme_color_override("icon_disabled_color", Color(0.68, 0.58, 0.32, 0.72))
	button.add_theme_stylebox_override(
		"normal",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.18), Color(accent.r, accent.g, accent.b, 0.48), 7, 2, 3, 5)
	)
	button.add_theme_stylebox_override(
		"hover",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.3), Color(accent.r, accent.g, accent.b, 0.72), 7, 2, 4, 7)
	)
	button.add_theme_stylebox_override(
		"pressed",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.42), Color(1.0, 1.0, 1.0, 0.42), 7, 2, 3, 2)
	)
	button.add_theme_stylebox_override(
		"disabled",
		_make_upgrade_style(Color(0.07, 0.075, 0.085, 0.56), Color(1.0, 1.0, 1.0, 0.12), 7, 2)
	)


func _apply_normal_button_style_tree(node: Node) -> void:
	for child in node.get_children():
		_apply_normal_button_style_tree(child)
	if not (node is Button):
		return
	var button := node as Button
	if button is CheckButton:
		return
	if button.has_meta("normal_style_accent"):
		button.flat = false
		return
	if button.has_theme_stylebox_override("normal"):
		return
	_style_upgrade_button(button, _get_normal_button_accent(button))


func _get_normal_button_accent(button: Button) -> Color:
	var identity := (button.name + " " + button.text).to_lower()
	if "exit" in identity or "delete" in identity or "reset" in identity:
		return VALUE_UPGRADE_COLOR
	if "boost" in identity or "stats" in identity:
		return Color(0.68, 0.42, 1.0, 1.0)
	if "skin" in identity:
		return SKIN_ACCENT
	if "achievement" in identity or "daily" in identity or "reward" in identity or "luck" in identity:
		return Color(0.82, 0.66, 0.22, 1.0)
	if "shop" in identity or "food" in identity or "inventory" in identity or "museum" in identity:
		return Color(0.96, 0.68, 0.26, 1.0)
	if "mission" in identity or "passive" in identity or "resume" in identity:
		return PASSIVE_UPGRADE_COLOR
	if "upgrade" in identity or "click" in identity or "settings" in identity or "tutorial" in identity:
		return CLICK_UPGRADE_COLOR
	return Color(0.42, 0.5, 0.66, 1.0)


func _apply_minimal_ui_system(node: Node) -> void:
	# A final, quiet visual pass keeps static and runtime-built interfaces cohesive.
	for child in node.get_children():
		_apply_minimal_ui_system(child)
	if node is PanelContainer:
		var panel := node as PanelContainer
		if panel == upgrade_alert_badge:
			return
		panel.add_theme_stylebox_override(
			"panel",
			_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.72, 0.95, 0.92), 22, 2, -1, 12)
		)
	elif node is Button:
		var button := node as Button
		if button.icon != null:
			button.add_theme_constant_override("icon_max_width", 38)
		_style_upgrade_button(button, Color(0.78, 0.62, 0.3, 1.0))
	elif node is ItemList:
		var list := node as ItemList
		list.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.72, 0.95, 0.65), 18, 1))
	elif node is LineEdit:
		var edit := node as LineEdit
		edit.add_theme_stylebox_override("normal", _make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.2, 0.72, 0.95, 0.65), 14, 1))
		edit.add_theme_stylebox_override("focus", _make_upgrade_style(Color(0.055, 0.085, 0.14, 1.0), Color(1.0, 0.82, 0.48, 0.82), 14, 2))


func _apply_touch_target_hierarchy(node: Node) -> void:
	for child in node.get_children():
		_apply_touch_target_hierarchy(child)
	if node is Button:
		var button := node as Button
		var action_text := button.text.to_lower()
		var is_key_action := (
			"upgrade" in action_text
			or "claim" in action_text
			or "complete" in action_text
			or "resume" in action_text
			or "open" in action_text
			or "buy" in action_text
			or "equip" in action_text
			or "activate" in action_text
		)
		var target_height := 64.0 if is_key_action else 56.0
		button.custom_minimum_size.y = maxf(button.custom_minimum_size.y, target_height)
		button.add_theme_constant_override("h_separation", 12)
	elif node is TextureButton:
		var texture_button := node as TextureButton
		texture_button.custom_minimum_size.x = maxf(texture_button.custom_minimum_size.x, 64.0)
		texture_button.custom_minimum_size.y = maxf(texture_button.custom_minimum_size.y, 64.0)
	elif node is Slider:
		var slider := node as Slider
		slider.custom_minimum_size.y = maxf(slider.custom_minimum_size.y, 48.0)
	elif node is VBoxContainer:
		var column := node as VBoxContainer
		column.add_theme_constant_override("separation", maxi(column.get_theme_constant("separation"), 10))


func _style_upgrade_progress(progress_bar: ProgressBar, accent: Color) -> void:
	progress_bar.custom_minimum_size.y = maxf(progress_bar.custom_minimum_size.y, 14.0)
	progress_bar.add_theme_stylebox_override(
		"background",
		_make_upgrade_style(Color(0.025, 0.03, 0.045, 1.0), Color(0.14, 0.16, 0.22, 1.0), 3, 2)
	)
	progress_bar.add_theme_stylebox_override(
		"fill",
		_make_upgrade_style(accent.darkened(0.12), accent.lightened(0.18), 3, 1)
	)
	if progress_bar.has_meta("arcade_segments_added"):
		return
	progress_bar.set_meta("arcade_segments_added", true)
	for segment in range(1, 5):
		var divider := ColorRect.new()
		divider.name = "SegmentDivider%d" % segment
		divider.color = Color(0.025, 0.03, 0.045, 0.72)
		divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
		divider.set_anchor(SIDE_LEFT, float(segment) / 5.0)
		divider.set_anchor(SIDE_RIGHT, float(segment) / 5.0)
		divider.set_anchor(SIDE_TOP, 0.0)
		divider.set_anchor(SIDE_BOTTOM, 1.0)
		divider.offset_left = -1.0
		divider.offset_right = 1.0
		divider.offset_top = 2.0
		divider.offset_bottom = -2.0
		progress_bar.add_child(divider)


func _format_number(value: int) -> String:
	var negative := value < 0
	var counter := BigCounter.new()
	if value == -MAX_RESOURCE_VALUE - 1:
		counter.set_from_decimal_string("9223372036854775808")
	else:
		counter.set_from_int(-value if negative else value)
	var full_number := counter.to_grouped_string() if group_full_numbers else counter.to_decimal_string()
	var formatted := counter.to_abbreviated_string(NUMBER_SUFFIXES, number_detail_digits) if abbreviate_numbers else full_number
	return "-" + formatted if negative else formatted


func _format_counter(counter: BigCounter) -> String:
	if abbreviate_numbers:
		return counter.to_abbreviated_string(NUMBER_SUFFIXES, number_detail_digits)
	# An unbounded full decimal string can eventually stretch or stall a UI.
	# Preserve exact display while it fits, then compact it automatically.
	if counter.digit_count() > MAX_FULL_NUMBER_DIGITS:
		return counter.to_scientific_string(number_detail_digits)
	return counter.to_grouped_string() if group_full_numbers else counter.to_decimal_string()


func _get_counter_tooltip(counter: BigCounter) -> String:
	if exact_number_tooltips:
		return counter.to_grouped_string()
	return _format_counter(counter)


func _format_score() -> String:
	return _format_counter(score_counter)


func _format_coins() -> String:
	return _format_counter(coins_counter)


func _format_best_coin_balance() -> String:
	return _format_counter(best_coin_balance_counter)


func _build_tutorial_ui() -> void:
	tutorial_overlay = Control.new()
	tutorial_overlay.name = "TutorialOverlay"
	tutorial_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	tutorial_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_overlay.z_index = 90
	tutorial_overlay.hide()
	add_child(tutorial_overlay)

	tutorial_dim = ColorRect.new()
	tutorial_dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	tutorial_dim.color = Color(0.0, 0.0, 0.0, 0.34)
	tutorial_dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_overlay.add_child(tutorial_dim)

	tutorial_highlight = Panel.new()
	tutorial_highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_highlight.z_index = 92
	tutorial_highlight.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.42, 0.86, 1.0, 0.08), Color(1.0, 0.9, 0.36, 1.0), 16, 4, -1, 12)
	)
	tutorial_overlay.add_child(tutorial_highlight)

	tutorial_arrow = Label.new()
	tutorial_arrow.text = ">"
	tutorial_arrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tutorial_arrow.z_index = 93
	tutorial_arrow.add_theme_font_size_override("font_size", 52)
	tutorial_arrow.add_theme_color_override("font_color", Color(1.0, 0.9, 0.32, 1.0))
	tutorial_arrow.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	tutorial_arrow.add_theme_constant_override("shadow_offset_x", 2)
	tutorial_arrow.add_theme_constant_override("shadow_offset_y", 2)
	tutorial_overlay.add_child(tutorial_arrow)

	tutorial_card = PanelContainer.new()
	tutorial_card.set_anchors_preset(Control.PRESET_TOP_LEFT)
	tutorial_card.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_card.z_index = 94
	tutorial_card.custom_minimum_size = Vector2(360.0, 0.0)
	tutorial_card.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.035, 0.045, 0.065, 0.98), Color(0.42, 0.86, 1.0, 0.9), 16, 2, -1, 16)
	)
	tutorial_overlay.add_child(tutorial_card)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	tutorial_card.add_child(margin)

	var items := VBoxContainer.new()
	items.add_theme_constant_override("separation", 10)
	margin.add_child(items)

	var tutorial_header := HBoxContainer.new()
	tutorial_header.add_theme_constant_override("separation", 10)
	items.add_child(tutorial_header)

	tutorial_progress_label = Label.new()
	tutorial_progress_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tutorial_progress_label.add_theme_font_size_override("font_size", 12)
	tutorial_progress_label.add_theme_color_override("font_color", Color(0.58, 0.68, 0.8, 1.0))
	tutorial_header.add_child(tutorial_progress_label)

	tutorial_close_button = Button.new()
	tutorial_close_button.text = "X"
	tutorial_close_button.tooltip_text = "Close tutorial"
	tutorial_close_button.custom_minimum_size = Vector2(38.0, 38.0)
	tutorial_close_button.pressed.connect(_skip_tutorial)
	tutorial_header.add_child(tutorial_close_button)

	tutorial_title_label = Label.new()
	tutorial_title_label.add_theme_font_size_override("font_size", 24)
	tutorial_title_label.add_theme_color_override("font_color", Color(0.88, 0.97, 1.0, 1.0))
	items.add_child(tutorial_title_label)

	tutorial_body_label = Label.new()
	tutorial_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_body_label.add_theme_font_size_override("font_size", 17)
	tutorial_body_label.add_theme_color_override("font_color", Color(0.78, 0.84, 0.92, 1.0))
	items.add_child(tutorial_body_label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	items.add_child(row)

	tutorial_skip_button = Button.new()
	tutorial_skip_button.text = "Skip"
	tutorial_skip_button.custom_minimum_size = Vector2(96.0, 44.0)
	tutorial_skip_button.pressed.connect(_skip_tutorial)
	row.add_child(tutorial_skip_button)

	tutorial_next_button = Button.new()
	tutorial_next_button.text = "Got it"
	tutorial_next_button.custom_minimum_size = Vector2(132.0, 44.0)
	tutorial_next_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tutorial_next_button.pressed.connect(_on_tutorial_next_pressed)
	row.add_child(tutorial_next_button)

	_style_upgrade_button(tutorial_skip_button, Color(0.46, 0.5, 0.62, 1.0))
	_style_upgrade_button(tutorial_next_button, Color(0.42, 0.86, 1.0, 1.0))
	_style_upgrade_button(tutorial_close_button, Color(0.46, 0.5, 0.62, 1.0))

	tutorial_replay_button = Button.new()
	tutorial_replay_button.name = "ReplayTutorialButton"
	tutorial_replay_button.text = "REPLAY TUTORIAL"
	tutorial_replay_button.custom_minimum_size = Vector2(0.0, 56.0)
	tutorial_replay_button.add_theme_font_size_override("font_size", 20)
	tutorial_replay_button.pressed.connect(_replay_tutorial_from_settings)
	var settings_items := $MenuOverlay/MenuCenter/SettingsPanel/SettingsMargin/SettingsItems as VBoxContainer
	settings_items.add_child(tutorial_replay_button)
	settings_items.move_child(tutorial_replay_button, maxi(0, settings_back_button.get_index()))
	_style_upgrade_button(tutorial_replay_button, Color(0.42, 0.86, 1.0, 1.0))

	tutorial_menu_replay_button = Button.new()
	tutorial_menu_replay_button.name = "PauseReplayTutorialButton"
	tutorial_menu_replay_button.text = "REPLAY TUTORIAL"
	tutorial_menu_replay_button.custom_minimum_size = Vector2(0.0, 56.0)
	tutorial_menu_replay_button.add_theme_font_size_override("font_size", 20)
	tutorial_menu_replay_button.pressed.connect(_replay_tutorial_from_settings)
	var menu_items := $MenuOverlay/MenuCenter/MenuPanel/MenuMargin/MenuItems as VBoxContainer
	menu_items.add_child(tutorial_menu_replay_button)
	menu_items.move_child(tutorial_menu_replay_button, maxi(0, settings_button.get_index() + 1))
	_style_upgrade_button(tutorial_menu_replay_button, Color(0.42, 0.86, 1.0, 1.0))


func _maybe_start_first_time_tutorial() -> void:
	if tutorial_completed:
		return
	_show_tutorial_prompt(false)


func _show_tutorial_prompt(force_replay: bool = false) -> void:
	if menu_overlay.visible:
		_hide_menu()
	tutorial_prompt_visible = true
	tutorial_prompt_replay = force_replay
	tutorial_active = false
	tutorial_step_index = -1
	tutorial_step_completing = false
	tutorial_step_generation += 1
	tutorial_target = null
	tutorial_overlay.show()
	tutorial_highlight.hide()
	tutorial_arrow.hide()
	tutorial_progress_label.text = "WELCOME"
	tutorial_title_label.text = "Do you want to pass the tutorial?"
	tutorial_body_label.text = "Start it to learn tapping, kibbles, upgrades, and goals. Skip it if you already know what to do."
	tutorial_skip_button.text = "Skip"
	tutorial_next_button.text = "Start tutorial"
	tutorial_next_button.show()
	tutorial_close_button.show()
	_update_tutorial_layout()
	_animate_tutorial_card()


func _start_tutorial(force_replay: bool) -> void:
	if tutorial_active:
		return
	if menu_overlay.visible:
		_hide_menu()
	tutorial_prompt_visible = false
	tutorial_active = true
	tutorial_step_index = -1
	tutorial_clicks_this_step = 0
	tutorial_step_completing = true
	tutorial_highlight.show()
	tutorial_arrow.show()
	tutorial_reward_given = tutorial_completed and force_replay
	tutorial_overlay.show()
	_advance_tutorial()


func _skip_tutorial() -> void:
	_finish_tutorial(true)


func _replay_tutorial_from_settings() -> void:
	_play_ui_sound()
	if is_instance_valid(settings_shell) and settings_shell.visible:
		settings_back_to_pause = false
		_hide_settings_shell_immediate()
	else:
		_hide_menu()
	call_deferred("_show_tutorial_prompt", true)


func _on_tutorial_next_pressed() -> void:
	if tutorial_prompt_visible:
		_start_tutorial(tutorial_prompt_replay)
		return
	if tutorial_step_completing:
		return
	var step := _get_tutorial_step(tutorial_step_index)
	var wait_for := String(step.get("wait_for", ""))
	if _perform_tutorial_action(step):
		return
	if wait_for == "continue" or wait_for.ends_with("_or_continue"):
		_complete_tutorial_step()


func _tutorial_notify(event_name: String) -> void:
	if not tutorial_active or tutorial_step_completing:
		return
	var step := _get_tutorial_step(tutorial_step_index)
	var wait_for := String(step.get("wait_for", ""))
	match wait_for:
		"cat_clicks":
			if event_name == "cat_clicked":
				tutorial_clicks_this_step += 1
				_show_tutorial_feedback("Good tap!")
				_update_tutorial_text()
				if tutorial_clicks_this_step >= int(step.get("count", 1)):
					_complete_tutorial_step()
		"coins_goal":
			if event_name == "cat_clicked" and coins >= int(step.get("amount", 0)):
				_complete_tutorial_step()
		"upgrades_opened":
			if event_name == "upgrades_opened":
				_complete_tutorial_step()
		"menu_opened":
			if event_name == "menu_opened":
				_complete_tutorial_step()
		"boosts_opened":
			if event_name == "boosts_opened":
				_complete_tutorial_step()
		"shop_opened":
			if event_name == "shop_opened":
				_complete_tutorial_step()
		"inventory_opened":
			if event_name == "inventory_opened":
				_complete_tutorial_step()
		"skins_opened":
			if event_name == "skins_opened":
				_complete_tutorial_step()
		"crates_opened":
			if event_name == "crates_opened":
				_complete_tutorial_step()
		"background_opened":
			if event_name == "background_opened":
				_complete_tutorial_step()
		"missions_opened":
			if event_name == "missions_opened":
				_complete_tutorial_step()
		"upgrade_bought":
			if event_name == "upgrade_bought":
				_complete_tutorial_step()
		"upgrade_or_continue":
			if event_name == "upgrade_bought":
				_complete_tutorial_step()
		"boost_or_continue":
			if event_name == "boost_used":
				_complete_tutorial_step()
		"food_buy_or_continue":
			if event_name == "food_bought":
				_complete_tutorial_step()
		"food_use_or_continue":
			if event_name == "food_used":
				_complete_tutorial_step()
		"crate_or_continue":
			if event_name == "crate_opened":
				_complete_tutorial_step()
		"background_or_continue":
			if event_name == "background_changed":
				_complete_tutorial_step()
		"powered_click":
			if event_name == "cat_clicked":
				_complete_tutorial_step()


func _advance_tutorial() -> void:
	tutorial_step_index += 1
	tutorial_clicks_this_step = 0
	tutorial_step_completing = true
	tutorial_step_generation += 1
	if tutorial_step_index >= _get_tutorial_step_count():
		_finish_tutorial(false)
		return
	call_deferred("_enter_tutorial_step", tutorial_step_index, tutorial_step_generation)


func _complete_tutorial_step() -> void:
	if tutorial_step_completing or not tutorial_active:
		return
	tutorial_step_completing = true
	var step := _get_tutorial_step(tutorial_step_index)
	if step.has("reward") and not tutorial_reward_given:
		tutorial_reward_given = true
		var added := _add_coins(int(step["reward"]))
		_update_coins(true)
		_update_upgrade_ui()
		_show_tutorial_feedback("+%s starter kibbles" % _format_number(added))
		_play_bonus_sound()
	else:
		_play_ui_sound()
	_advance_tutorial()


func _finish_tutorial(skipped: bool) -> void:
	tutorial_prompt_visible = false
	tutorial_prompt_replay = false
	tutorial_active = false
	tutorial_step_index = -1
	tutorial_step_completing = false
	tutorial_step_generation += 1
	tutorial_target = null
	tutorial_overlay.hide()
	tutorial_highlight.show()
	tutorial_arrow.show()
	if tutorial_pulse_tween != null and tutorial_pulse_tween.is_valid():
		tutorial_pulse_tween.kill()
	tutorial_completed = true
	hint_label.text = "Tap the cat"
	_queue_save()
	_show_tutorial_feedback("Tutorial skipped" if skipped else "Tutorial complete")


func _enter_tutorial_step(expected_step: int, expected_generation: int) -> void:
	if not tutorial_active or tutorial_step_index != expected_step or tutorial_step_generation != expected_generation:
		return
	var step := _get_tutorial_step(tutorial_step_index)
	tutorial_next_button.disabled = true
	var destination := String(step.get("destination", ""))
	var shop_section := String(step.get("shop_section", ""))
	var transition_delay := 0.0
	if not destination.is_empty():
		transition_delay = _prepare_tutorial_destination(destination, shop_section)
	elif String(step.get("target", "")) in ["shop_button", "inventory_button", "skins_button", "missions_button"]:
		if pause_popup_open:
			_hide_pause_popup(false, true)
	if transition_delay > 0.0:
		get_tree().create_timer(transition_delay).timeout.connect(
			_finish_tutorial_step_entry.bind(expected_step, expected_generation),
			CONNECT_ONE_SHOT
		)
	else:
		call_deferred("_finish_tutorial_step_entry", expected_step, expected_generation)


func _prepare_tutorial_destination(destination: String, shop_section: String) -> float:
	if pause_popup_open:
		_hide_pause_popup(false, true)
	if not is_instance_valid(telegram_navigation):
		return 0.0
	if destination == "main":
		if telegram_navigation.current_destination != "main" or menu_overlay.visible:
			_on_telegram_destination_requested("main", 0)
			return 0.34
		return 0.0
	if destination == "shop" and not shop_section.is_empty():
		if telegram_navigation.current_destination != "shop" or active_shop_section != shop_section:
			_show_shop_section(shop_section)
			return 0.34
	elif telegram_navigation.current_destination != destination:
		_on_telegram_destination_requested(destination, 0)
		return 0.34
	# A user-triggered page transition can already be moving when its completion
	# advances the tutorial. Wait before measuring the new target.
	return 0.34


func _finish_tutorial_step_entry(expected_step: int, expected_generation: int) -> void:
	if not tutorial_active or tutorial_step_index != expected_step or tutorial_step_generation != expected_generation:
		return
	var step := _get_tutorial_step(tutorial_step_index)
	tutorial_target = _get_tutorial_target(String(step.get("target", "")))
	_update_tutorial_text()
	_update_tutorial_layout()
	_animate_tutorial_card()
	_pulse_tutorial_highlight()
	tutorial_step_completing = false
	tutorial_next_button.disabled = false


func _update_tutorial_text() -> void:
	if not tutorial_active:
		return
	var step := _get_tutorial_step(tutorial_step_index)
	var body := String(step.get("body", ""))
	if String(step.get("wait_for", "")) == "cat_clicks":
		body = "%s\n%d/%d taps" % [body, tutorial_clicks_this_step, int(step.get("count", 1))]
	elif String(step.get("wait_for", "")) == "coins_goal":
		var amount := int(step.get("amount", TUTORIAL_STARTER_GOAL))
		body = "%s\n%s/%s kibbles" % [body, _format_number(mini(coins, amount)), _format_number(amount)]
	elif String(step.get("wait_for", "")) == "upgrade_or_continue":
		body = _get_tutorial_upgrade_body(step)
	elif String(step.get("wait_for", "")).ends_with("_or_continue"):
		body = _get_tutorial_action_body(step)
	tutorial_progress_label.text = "STEP %d OF %d" % [tutorial_step_index + 1, _get_tutorial_step_count()]
	tutorial_title_label.text = String(step.get("title", ""))
	tutorial_body_label.text = body
	var wait_for := String(step.get("wait_for", ""))
	tutorial_next_button.visible = wait_for == "continue" or wait_for.ends_with("_or_continue")
	tutorial_next_button.text = _get_tutorial_primary_button_text(step)
	if String(step.get("wait_for", "")) == "coins_goal" and coins >= int(step.get("amount", 0)):
		call_deferred("_complete_tutorial_step_if_current", tutorial_step_index)


func _complete_tutorial_step_if_current(expected_step_index: int) -> void:
	if tutorial_step_index == expected_step_index:
		_complete_tutorial_step()


func _get_tutorial_upgrade_body(step: Dictionary) -> String:
	if unlocked_click_value >= MAX_CLICK_VALUE:
		return String(step.get("maxed_body", "This upgrade is maxed."))
	var next_value := unlocked_click_value + 1
	var upgrade_cost := _get_upgrade_cost(next_value)
	if coins >= upgrade_cost:
		return String(step.get("affordable_body", "You can afford this upgrade.")).replace("%d", str(next_value)).replace("%s", _format_number(upgrade_cost))
	return String(step.get("unaffordable_body", "Not enough kibbles yet.")).replace("%d", str(next_value)).replace("%s", _format_number(upgrade_cost))


func _get_tutorial_primary_button_text(step: Dictionary) -> String:
	if tutorial_step_index == _get_tutorial_step_count() - 1:
		return "Finish"
	match String(step.get("wait_for", "")):
		"upgrade_or_continue":
			return "Buy Click Power" if _can_buy_tutorial_click_power() else "Next"
		"boost_or_continue":
			var boost := _get_tutorial_affordable_boost()
			return "Activate %s" % String(boost["name"]).capitalize() if not boost.is_empty() else "Next"
		"food_buy_or_continue":
			return "Buy Food" if _can_buy_tutorial_food() else "Next"
		"food_use_or_continue":
			return "Use Food" if not _get_tutorial_owned_food_id().is_empty() else "Next"
		"crate_or_continue":
			var crate := _get_tutorial_openable_crate()
			return "Open %s" % String(crate["name"]).capitalize() if not crate.is_empty() else "Next"
		"background_or_continue":
			return "Equip Background" if not _get_tutorial_next_room_skin_id().is_empty() else "Next"
	return "Next"


func _perform_tutorial_action(step: Dictionary) -> bool:
	match String(step.get("wait_for", "")):
		"upgrade_or_continue":
			if _can_buy_tutorial_click_power():
				_upgrade_click_value()
				return true
		"boost_or_continue":
			var boost := _get_tutorial_affordable_boost()
			if not boost.is_empty():
				boost_logic.purchase(String(boost["id"]), 1)
				return true
		"food_buy_or_continue":
			if _can_buy_tutorial_food():
				_buy_food(_get_food_id(0))
				return true
		"food_use_or_continue":
			var food_id := _get_tutorial_owned_food_id()
			if not food_id.is_empty():
				_feed_cat(food_id)
				return true
		"crate_or_continue":
			var crate := _get_tutorial_openable_crate()
			if not crate.is_empty():
				crate_logic.open_crate(String(crate["id"]))
				return true
		"background_or_continue":
			var room_skin_id := _get_tutorial_next_room_skin_id()
			if not room_skin_id.is_empty():
				_on_room_skin_pressed(room_skin_id)
				return true
	return false


func _can_buy_tutorial_click_power() -> bool:
	if unlocked_click_value >= MAX_CLICK_VALUE:
		return false
	return coins >= _get_upgrade_cost(unlocked_click_value + 1)


func _get_tutorial_affordable_boost() -> Dictionary:
	for data in BoostLogic.BOOST_DATA:
		var boost_id := String(data["id"])
		if boost_logic.is_active(boost_id) or boost_logic.is_recharging(boost_id):
			continue
		var cost: int = boost_logic.get_tier_cost(int(data["cost"]), 1)
		if coins >= cost:
			return data
	return {}


func _can_buy_tutorial_food() -> bool:
	return coins >= FOOD_COST


func _get_tutorial_owned_food_id() -> String:
	for food_id in food_inventory.keys():
		if int(food_inventory.get(food_id, 0)) > 0:
			return String(food_id)
	return ""


func _get_tutorial_openable_crate() -> Dictionary:
	for data in CrateLogic.CRATE_DATA:
		var cost: int = crate_logic.get_crate_cost(data)
		var has_key: bool = bottomless_bowl_logic != null and (bottomless_bowl_logic.crate_keys > 0 or (String(data["id"]) == "cozy" and bottomless_bowl_logic.cozy_crates > 0))
		if coins >= cost or has_key:
			return data
	return {}


func _get_tutorial_next_room_skin_id() -> String:
	for room_skin_data in ROOM_SKIN_DATA:
		var room_skin_id := String(room_skin_data["id"])
		if room_skin_id != equipped_room_skin_id:
			return room_skin_id
	return ""


func _get_tutorial_action_body(step: Dictionary) -> String:
	match String(step.get("wait_for", "")):
		"boost_or_continue":
			return _get_tutorial_boost_body(step)
		"food_buy_or_continue":
			return _get_tutorial_shop_body(step)
		"food_use_or_continue":
			return _get_tutorial_inventory_body(step)
		"crate_or_continue":
			return _get_tutorial_crate_body(step)
		"background_or_continue":
			return _get_tutorial_background_body(step)
	return String(step.get("body", ""))


func _get_tutorial_boost_body(step: Dictionary) -> String:
	for boost_id in active_boost_end_times.keys():
		if boost_logic.get_remaining_seconds(String(boost_id)) > 0.0:
			return String(step.get("active_body", "Boost is active."))
	if nine_lives_taps_left > 0:
		return String(step.get("active_body", "Boost is active."))
	var cheapest_cost: float = INF
	var affordable_name := ""
	for data in BoostLogic.BOOST_DATA:
		var boost_id := String(data["id"])
		if boost_logic.is_active(boost_id) or boost_logic.is_recharging(boost_id):
			continue
		var cost: int = boost_logic.get_tier_cost(int(data["cost"]), 1)
		cheapest_cost = minf(cheapest_cost, float(cost))
		if affordable_name.is_empty() and coins >= cost:
			affordable_name = String(data["name"])
	if not affordable_name.is_empty():
		return String(step.get("affordable_body", "You can activate %s.")).replace("%s", affordable_name)
	if is_inf(cheapest_cost):
		cheapest_cost = 0.0
	return String(step.get("unaffordable_body", "Need more kibbles.")).replace("%s", _format_number(int(cheapest_cost)))


func _get_tutorial_shop_body(step: Dictionary) -> String:
	if _get_owned_food_count() > 0:
		return String(step.get("owned_body", "You own food already."))
	if coins >= FOOD_COST:
		return String(step.get("affordable_body", "You can buy food now."))
	return String(step.get("unaffordable_body", "Food costs %s kibbles.")).replace("%s", _format_number(FOOD_COST))


func _get_tutorial_inventory_body(step: Dictionary) -> String:
	if not active_food_boosts.is_empty():
		return String(step.get("active_body", "Food boost active."))
	if _get_owned_food_count() > 0:
		return String(step.get("owned_body", "Use owned food here."))
	return String(step.get("empty_body", "No food owned yet."))


func _get_tutorial_crate_body(step: Dictionary) -> String:
	if crate_logic.total_crates_opened > 0:
		return String(step.get("opened_body", "Crates drop gems."))
	var cheapest_cost: float = INF
	var affordable_name := ""
	for data in CrateLogic.CRATE_DATA:
		var cost: int = crate_logic.get_crate_cost(data)
		cheapest_cost = minf(cheapest_cost, float(cost))
		var has_key: bool = bottomless_bowl_logic != null and (bottomless_bowl_logic.crate_keys > 0 or (String(data["id"]) == "cozy" and bottomless_bowl_logic.cozy_crates > 0))
		if affordable_name.is_empty() and (coins >= cost or has_key):
			affordable_name = String(data["name"])
	if not affordable_name.is_empty():
		return String(step.get("affordable_body", "You can open %s.")).replace("%s", affordable_name)
	if is_inf(cheapest_cost):
		cheapest_cost = 0.0
	return String(step.get("unaffordable_body", "Crates cost %s kibbles.")).replace("%s", _format_number(int(cheapest_cost)))


func _get_tutorial_background_body(step: Dictionary) -> String:
	var equipped_name := "current room"
	var data := _get_room_skin_data(equipped_room_skin_id)
	if not data.is_empty():
		equipped_name = String(data["name"])
	return "%s\nEquipped: %s." % [String(step.get("body", "Equip room backgrounds here.")), equipped_name]


func _get_owned_food_count() -> int:
	var total := 0
	for food_id in food_inventory.keys():
		total += int(food_inventory.get(food_id, 0))
	return total


func _get_tutorial_step_count() -> int:
	return TUTORIAL_STEPS.size()


func _get_tutorial_step(index: int) -> Dictionary:
	return TUTORIAL_STEPS[clampi(index, 0, TUTORIAL_STEPS.size() - 1)]


func _get_tutorial_target(target_id: String) -> Control:
	match target_id:
		"cat":
			return cat_button
		"wallet":
			return hud_wallet
		"upgrade_button":
			return upgrade_button
		"buy_click_power":
			return upgrade_purchase_button
		"bonus_chance":
			return bonus_chance_card
		"boosts_button":
			return boosts_button
		"boosts_panel":
			return boosts_panel
		"upgrades_panel":
			return upgrades_panel
		"shop_button":
			return telegram_navigation.call("get_destination_button", "shop") as Control if is_instance_valid(telegram_navigation) else shop_button
		"shop_panel":
			return food_panel
		"inventory_button":
			return telegram_navigation.call("get_destination_button", "inventory") as Control if is_instance_valid(telegram_navigation) else inventory_button
		"inventory_panel":
			return food_panel
		"menu_button":
			return menu_button
		"skins_button":
			return telegram_navigation.call("get_destination_button", "skins") as Control if is_instance_valid(telegram_navigation) else skins_button
		"skins_panel":
			return skins_panel
		"crates_tab":
			return skins_tab_buttons.get("crates") as Control
		"crates_panel":
			return skins_section_panels.get("crates") as Control
		"background_tab":
			return skins_tab_buttons.get("background") as Control
		"background_panel":
			return skins_section_panels.get("background") as Control
		"missions_button":
			return telegram_navigation.call("get_destination_button", "missions") as Control if is_instance_valid(telegram_navigation) else (mission_logic.button if mission_logic != null else null)
		"missions_panel":
			return mission_logic.panel if mission_logic != null else null
		"pause_button":
			return telegram_navigation.call("get_destination_button", "pause") as Control if is_instance_valid(telegram_navigation) else menu_button
		"pause_panel":
			return menu_panel
		"event_banner":
			return random_event_logic.banner if random_event_logic != null else null
		"pause_replay":
			return tutorial_menu_replay_button
	return null


func _update_tutorial_layout() -> void:
	if (not tutorial_active and not tutorial_prompt_visible) or not is_instance_valid(tutorial_overlay):
		return
	var viewport_size := get_viewport_rect().size
	tutorial_overlay.size = viewport_size
	tutorial_dim.size = viewport_size
	tutorial_card.set_anchors_preset(Control.PRESET_TOP_LEFT)

	var target_rect := Rect2(viewport_size * 0.5 - Vector2(80.0, 60.0), Vector2(160.0, 120.0))
	if is_instance_valid(tutorial_target) and tutorial_target.is_visible_in_tree():
		target_rect = tutorial_target.get_global_rect()
		if target_rect.size.x * target_rect.size.y > viewport_size.x * viewport_size.y * 0.42:
			target_rect = Rect2(
				Vector2(maxf(12.0, target_rect.position.x + 12.0), maxf(12.0, target_rect.position.y + 12.0)),
				Vector2(maxf(120.0, target_rect.size.x - 24.0), minf(92.0, target_rect.size.y))
			)
	var padding := 12.0
	var highlight_rect := target_rect.grow(padding)
	tutorial_highlight.position = highlight_rect.position
	tutorial_highlight.size = highlight_rect.size
	tutorial_highlight.pivot_offset = highlight_rect.size * 0.5

	var card_width := minf(TUTORIAL_CARD_MAX_WIDTH, viewport_size.x - 32.0)
	tutorial_card.custom_minimum_size.x = card_width
	tutorial_title_label.custom_minimum_size.x = card_width - 36.0
	tutorial_body_label.custom_minimum_size.x = card_width - 36.0
	tutorial_card.reset_size()
	var card_height := clampf(tutorial_card.get_combined_minimum_size().y, 178.0, viewport_size.y - 32.0)
	tutorial_card.size = Vector2(card_width, card_height)
	if tutorial_prompt_visible:
		tutorial_card.position = Vector2((viewport_size.x - card_width) * 0.5, (viewport_size.y - card_height) * 0.5)
		return
	var place_below := target_rect.get_center().y < viewport_size.y * 0.54
	var card_x := clampf(target_rect.get_center().x - card_width * 0.5, 16.0, maxf(16.0, viewport_size.x - card_width - 16.0))
	var card_y := target_rect.end.y + 22.0 if place_below else target_rect.position.y - card_height - 22.0
	card_y = clampf(card_y, 16.0, maxf(16.0, viewport_size.y - card_height - 16.0))
	tutorial_card.position = Vector2(card_x, card_y)

	var arrow_size := Vector2(64.0, 64.0)
	tutorial_arrow.size = arrow_size
	if place_below:
		tutorial_arrow.rotation = PI * 0.5
		tutorial_arrow.position = Vector2(target_rect.get_center().x - 24.0, target_rect.end.y - 4.0)
	else:
		tutorial_arrow.rotation = -PI * 0.5
		tutorial_arrow.position = Vector2(target_rect.get_center().x - 36.0, target_rect.position.y - 60.0)


func _animate_tutorial_card() -> void:
	if tutorial_transition_tween != null and tutorial_transition_tween.is_valid():
		tutorial_transition_tween.kill()
	_update_tutorial_layout()
	tutorial_card.pivot_offset = tutorial_card.size * 0.5
	tutorial_card.scale = Vector2(0.92, 0.92)
	tutorial_card.modulate.a = 0.0
	tutorial_transition_tween = create_tween().set_parallel(true)
	tutorial_transition_tween.tween_property(tutorial_card, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tutorial_transition_tween.tween_property(tutorial_card, "modulate:a", 1.0, 0.16).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _pulse_tutorial_highlight() -> void:
	if tutorial_pulse_tween != null and tutorial_pulse_tween.is_valid():
		tutorial_pulse_tween.kill()
	tutorial_highlight.scale = Vector2.ONE
	tutorial_arrow.scale = Vector2.ONE
	tutorial_arrow.modulate.a = 1.0
	tutorial_pulse_tween = create_tween().set_loops()
	tutorial_pulse_tween.set_parallel(true)
	tutorial_pulse_tween.tween_property(tutorial_highlight, "scale", Vector2(1.035, 1.035), 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tutorial_pulse_tween.tween_property(tutorial_arrow, "scale", Vector2(1.12, 1.12), 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tutorial_pulse_tween.tween_property(tutorial_arrow, "modulate:a", 0.72, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tutorial_pulse_tween.chain().set_parallel(true)
	tutorial_pulse_tween.tween_property(tutorial_highlight, "scale", Vector2.ONE, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tutorial_pulse_tween.tween_property(tutorial_arrow, "scale", Vector2.ONE, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tutorial_pulse_tween.tween_property(tutorial_arrow, "modulate:a", 1.0, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _show_tutorial_feedback(message: String) -> void:
	if not is_inside_tree():
		return
	var label := Label.new()
	label.text = message
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.z_index = 95
	label.size = Vector2(300.0, 42.0)
	label.position = Vector2((get_viewport_rect().size.x - label.size.x) * 0.5, 118.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.36, 1.0))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.82))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	click_popup_layer.add_child(label)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 52.0, 0.72).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.08, 1.08), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.72).set_delay(0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(Callable(label, "queue_free"))


func _animate_hud_coin_text() -> void:
	if not is_instance_valid(coins_label) or not coins_label.is_inside_tree():
		return
	if hud_coin_text_tween != null and hud_coin_text_tween.is_valid():
		hud_coin_text_tween.kill()

	var clip := coins_label.get_parent() as Control
	if not is_instance_valid(clip) or clip.size.x <= 1.0:
		return
	var font := coins_label.get_theme_font("font")
	var font_size := 28
	var available_width := maxf(1.0, clip.size.x - 4.0)
	var text_width := font.get_string_size(coins_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
	while text_width > available_width and font_size > 14:
		font_size -= 1
		text_width = font.get_string_size(coins_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
	coins_label.add_theme_font_size_override("font_size", font_size)
	coins_label.position.x = 0.0
	coins_label.size = Vector2(text_width + 4.0, clip.size.y)


func _update_volume_ui() -> void:
	ui_logic.update_volume_ui()


func _update_achievements_ui() -> void:
	achievement_logic.update_achievements_ui()


func _queue_achievement_refresh() -> void:
	achievement_refresh_pending = true


func _sync_achievement_unlocks(achievements: Array[Dictionary], show_popups: bool) -> void:
	achievement_logic.sync_achievement_unlocks(achievements, show_popups)


func _show_achievement_popup(achievement_text: String) -> void:
	achievement_logic.show_achievement_popup(achievement_text)


func _get_active_achievement_popup_count() -> int:
	return achievement_logic.get_active_achievement_popup_count()


func _achievement(text: String, unlocked: bool) -> Dictionary:
	return achievement_logic.achievement(text, unlocked)


func _append_threshold_achievements(achievements: Array[Dictionary], current_value: int, thresholds: Array[int], template: String) -> void:
	achievement_logic.append_threshold_achievements(achievements, current_value, thresholds, template)


func _append_skin_achievements(achievements: Array[Dictionary]) -> void:
	achievement_logic.append_skin_achievements(achievements)


func _append_click_power_achievements(achievements: Array[Dictionary]) -> void:
	achievement_logic.append_click_power_achievements(achievements)


func _append_bonus_chance_achievements(achievements: Array[Dictionary]) -> void:
	achievement_logic.append_bonus_chance_achievements(achievements)


func _append_bonus_value_achievements(achievements: Array[Dictionary]) -> void:
	achievement_logic.append_bonus_value_achievements(achievements)


func _append_bonus_streak_achievements(achievements: Array[Dictionary]) -> void:
	achievement_logic.append_bonus_streak_achievements(achievements)


func _get_unlocked_skin_count() -> int:
	return achievement_logic.get_unlocked_skin_count()


func _update_stats_ui() -> void:
	ui_logic.update_stats_ui()


func _rebuild_stats_cards(sections: Array) -> void:
	ui_logic.rebuild_stats_cards(sections)


func _update_daily_reward_ui() -> void:
	reward_logic.update_daily_reward_ui()


func _show_startup_popups() -> void:
	reward_logic.show_startup_popups()


func _can_claim_daily_reward() -> bool:
	return reward_logic.can_claim_daily_reward()


func _get_next_daily_reward_streak() -> int:
	return reward_logic.get_next_daily_reward_streak()


func _get_daily_reward_amount(streak: int = -1) -> int:
	return reward_logic.get_daily_reward_amount(streak)


func _format_time_until_next_day() -> String:
	return reward_logic.format_time_until_next_day()


func _claim_daily_reward() -> void:
	reward_logic.claim_daily_reward()


func _get_achievements() -> Array[Dictionary]:
	return achievement_logic.get_achievements()


func _on_click_power_changed(value: float) -> void:
	click_value = clampi(int(value), 1, unlocked_click_value)
	click_power_label.text = "Use click value: x%d" % click_value
	click_value_label.text = "Click value: x%d / unlocked x%d" % [click_value, unlocked_click_value]
	_animate_settings_value(click_power_label, CLICK_UPGRADE_COLOR)
	_queue_save()


func _on_click_volume_changed(value: float) -> void:
	click_volume = clamp(value / 100.0, 0.0, 1.0)
	click_volume_label.text = "Click sound: %d%%" % int(value)
	_animate_settings_value(click_volume_label, Color(0.62, 0.48, 1.0, 1.0))
	_apply_volume()
	_play_slider_sound()
	_queue_save()


func _on_ui_volume_changed(value: float) -> void:
	ui_volume = clamp(value / 100.0, 0.0, 1.0)
	ui_volume_label.text = "UI sound: %d%%" % int(value)
	_animate_settings_value(ui_volume_label, Color(0.62, 0.48, 1.0, 1.0))
	_apply_volume()
	_play_slider_sound()
	_queue_save()


func _on_master_volume_changed(value: float) -> void:
	master_volume = clampf(value / 100.0, 0.0, 1.0)
	if is_instance_valid(master_volume_value_label):
		master_volume_value_label.text = "%d%%" % roundi(value)
		_animate_settings_value(master_volume_value_label, Color(0.62, 0.48, 1.0, 1.0))
	_apply_volume()
	_play_slider_sound()
	_queue_save()


func _on_click_sounds_toggled(enabled: bool) -> void:
	click_sounds_enabled = enabled
	_apply_volume()
	_queue_save()


func _on_ui_sounds_toggled(enabled: bool) -> void:
	ui_sounds_enabled = enabled
	_apply_volume()
	if enabled:
		_play_ui_sound()
	_queue_save()


func _on_mute_unfocused_toggled(enabled: bool) -> void:
	mute_unfocused = enabled
	_apply_volume()
	_queue_save()


func _on_low_quality_toggled(enabled: bool) -> void:
	low_quality_enabled = enabled
	_apply_runtime_quality()
	_queue_save()


func _on_battery_saver_toggled(enabled: bool) -> void:
	battery_saver_enabled = enabled
	_apply_runtime_quality()
	_queue_save()


func _on_optimized_tap_toggled(enabled: bool) -> void:
	optimized_tap_effects = enabled
	_queue_save()


func _on_reduce_motion_toggled(enabled: bool) -> void:
	reduce_motion_enabled = enabled
	_queue_save()


func _on_background_effects_toggled(enabled: bool) -> void:
	background_effects_enabled = enabled
	_queue_save()


func _on_low_power_unfocused_toggled(enabled: bool) -> void:
	low_power_unfocused = enabled
	_apply_runtime_quality()
	_queue_save()


func _on_abbreviate_numbers_toggled(enabled: bool) -> void:
	abbreviate_numbers = enabled
	_refresh_number_format_ui()
	_queue_save()


func _on_number_detail_changed(value: float) -> void:
	number_detail_digits = clampi(roundi(value), MIN_NUMBER_DETAIL_DIGITS, MAX_NUMBER_DETAIL_DIGITS)
	if is_instance_valid(number_detail_value_label):
		number_detail_value_label.text = "%d digits" % number_detail_digits
		_animate_settings_value(number_detail_value_label, CLICK_UPGRADE_COLOR)
	_refresh_number_format_ui()
	_play_slider_sound()
	_queue_save()


func _on_exact_number_tooltips_toggled(enabled: bool) -> void:
	exact_number_tooltips = enabled
	_refresh_number_format_ui()
	_queue_save()


func _on_group_full_numbers_toggled(enabled: bool) -> void:
	group_full_numbers = enabled
	_refresh_number_format_ui()
	_queue_save()


func _refresh_number_format_ui() -> void:
	_update_score()
	_update_coins(false)
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_update_food_ui()
	_update_skins_ui()
	if boost_logic != null:
		boost_logic.update_ui()
	if crate_logic != null:
		crate_logic.update_ui()
	if bottomless_bowl_logic != null:
		bottomless_bowl_logic.update_ui()


func _on_particle_limit_changed(value: float) -> void:
	particle_limit = clampi(int(round(value)), 1, PARTICLE_LIMIT_INFINITE)
	if is_instance_valid(particle_limit_value_label):
		particle_limit_value_label.text = _get_particle_limit_text()
		_animate_settings_value(particle_limit_value_label, Color(0.26, 0.86, 0.82))
	_play_slider_sound()
	_queue_save()


func _on_haptics_toggled(enabled: bool) -> void:
	haptics_enabled = enabled
	_queue_save()


func _on_haptic_strength_changed(value: float) -> void:
	haptic_strength = clampi(roundi(value), 0, 100)
	if is_instance_valid(haptic_strength_value_label):
		haptic_strength_value_label.text = "%d%%" % haptic_strength
		_animate_settings_value(haptic_strength_value_label, Color(1.0, 0.58, 0.34))
	_play_slider_sound()
	_queue_save()


func _on_events_toggled(enabled: bool) -> void:
	events_enabled = enabled
	if random_event_logic != null:
		random_event_logic.set_events_enabled(enabled)
	_queue_save()


func _on_floating_numbers_toggled(enabled: bool) -> void:
	floating_numbers_enabled = enabled
	_queue_save()


func _on_coin_trails_toggled(enabled: bool) -> void:
	coin_trails_enabled = enabled
	_queue_save()


func _on_menu_swipe_toggled(enabled: bool) -> void:
	menu_swipe_enabled = enabled
	if not enabled and (settings_swipe_tracking or settings_swipe_dragging):
		_reset_settings_drag()
	_queue_save()


func _on_reverse_sliders_toggled(enabled: bool) -> void:
	reverse_sliders_enabled = enabled
	_queue_save()


func _on_slider_sound_selected(index: int) -> void:
	slider_sound_style = clampi(index, 0, UI_SOUND_VARIANTS.size() - 1)
	_play_slider_sound()
	_queue_save()


func _get_particle_limit_text() -> String:
	return "Infinite" if particle_limit >= PARTICLE_LIMIT_INFINITE else str(particle_limit)


func _get_effective_particle_limit(base_limit: int = MAX_COIN_PARTICLES) -> int:
	var configured_limit := base_limit if particle_limit >= PARTICLE_LIMIT_INFINITE else particle_limit
	return maxi(1, roundi(float(configured_limit) * effects_scale))


func _play_slider_sound() -> void:
	if not ui_sounds_enabled:
		return
	var now := Time.get_ticks_msec()
	if now - last_slider_sound_msec < 65:
		return
	last_slider_sound_msec = now
	ui_sound.stop()
	ui_sound.stream = UI_SOUND_VARIANTS[clampi(slider_sound_style, 0, UI_SOUND_VARIANTS.size() - 1)]
	ui_sound.play()


func _apply_volume() -> void:
	var focus_multiplier := 0.0 if mute_unfocused and not app_has_focus else 1.0
	var master := master_volume * focus_multiplier
	var click_level := master * click_volume
	var interface_level := master * ui_volume
	cat_click_sound.volume_db = _linear_volume_to_db(click_level if click_sounds_enabled else 0.0)
	cat_meow_sound.volume_db = _linear_volume_to_db(click_level if click_sounds_enabled else 0.0)
	bonus_sound.volume_db = _linear_volume_to_db(click_level)
	special_milestone_sound.volume_db = _linear_volume_to_db(click_level)
	ui_sound.volume_db = _linear_volume_to_db(interface_level if ui_sounds_enabled else 0.0)
	for player in [reward_redeem_sound, purchase_sound, crate_open_sound, gem_reveal_sound, gem_discovery_sound]:
		player.volume_db = _linear_volume_to_db(interface_level)


func _linear_volume_to_db(volume: float) -> float:
	if volume <= 0.0:
		return -80.0

	return linear_to_db(volume)


func _get_upgrade_cost(next_value: int) -> int:
	return upgrade_logic.get_upgrade_cost(next_value)


func _get_base_bonus_chance_percent(level: int = -1) -> float:
	if level < 0:
		level = bonus_chance_level
	return float(level) * 0.1


func _get_bonus_chance_percent(level: int = -1) -> float:
	return upgrade_logic.get_bonus_chance_percent(level)


func _get_base_bonus_multiplier() -> int:
	return int(BONUS_MULTIPLIERS[bonus_value_index])


func _get_bonus_multiplier() -> int:
	return upgrade_logic.get_bonus_multiplier()


func _get_bonus_chance_cost() -> int:
	return upgrade_logic.get_bonus_chance_cost()


func _get_bonus_value_cost() -> int:
	return upgrade_logic.get_bonus_value_cost()


func _get_bonus_streak_cost() -> int:
	return upgrade_logic.get_bonus_streak_cost()


func _get_passive_upgrade_cost() -> int:
	return upgrade_logic.get_passive_upgrade_cost()


func _roll_bonus_multiplier() -> int:
	return upgrade_logic.roll_bonus_multiplier()


func _is_bonus_guaranteed() -> bool:
	return boost_logic.is_bonus_guaranteed()


func _record_bonus_click(was_bonus: bool) -> void:
	click_logic.record_bonus_click(was_bonus)


func _get_recent_bonus_count() -> int:
	return click_logic.get_recent_bonus_count()


func _upgrade_click_value() -> void:
	var previous_value := unlocked_click_value
	upgrade_logic.upgrade_click_value()
	if unlocked_click_value > previous_value:
		_tutorial_notify("upgrade_bought")


func _upgrade_passive_gain() -> void:
	upgrade_logic.upgrade_passive_gain()
	_tutorial_notify("upgrade_bought")


func _upgrade_bonus_chance() -> void:
	upgrade_logic.upgrade_bonus_chance()
	_tutorial_notify("upgrade_bought")


func _upgrade_bonus_value() -> void:
	upgrade_logic.upgrade_bonus_value()
	_tutorial_notify("upgrade_bought")


func _upgrade_bonus_streak() -> void:
	upgrade_logic.upgrade_bonus_streak()
	_tutorial_notify("upgrade_bought")


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
	cat_tween.set_parallel(true)
	var pop_scale := CAT_BONUS_POP_SCALE if is_bonus else CAT_POP_SCALE
	cat_tween.tween_property(cat_button, "scale", cat_base_scale * pop_scale, 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	cat_tween.tween_property(cat_button, "rotation", 0.035 if is_bonus else 0.0, 0.07).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	cat_tween.chain().tween_property(cat_button, "scale", cat_base_scale, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	cat_tween.parallel().tween_property(cat_button, "rotation", 0.0, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _cancel_cat_press_for_navigation() -> void:
	cat_button.set_pressed_no_signal(false)
	if cat_tween != null and cat_tween.is_valid():
		cat_tween.kill()
	cat_tween = create_tween().set_parallel(true)
	cat_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	cat_tween.tween_property(cat_button, "scale", cat_base_scale, 0.12)
	cat_tween.tween_property(cat_button, "rotation", 0.0, 0.12)


func _play_tap_haptic(is_bonus: bool) -> void:
	if not haptics_enabled or haptic_strength <= 0:
		return
	if not OS.has_feature("mobile"):
		return
	const HAPTIC_TICK_MS := 20
	var duration_ms := HAPTIC_TICK_MS * (2 if is_bonus else 1)
	var base_amplitude := 0.72 if is_bonus else 0.28
	var amplitude := clampf(base_amplitude * (float(haptic_strength) / 50.0), 0.0, 1.0)
	Input.vibrate_handheld(duration_ms, amplitude)


func _pulse_label(label: Label, is_bonus: bool) -> void:
	var tween_ref := score_tween if label == score_label else coins_tween
	if tween_ref != null and tween_ref.is_valid():
		tween_ref.kill()

	label.pivot_offset = label.size * 0.5
	label.scale = Vector2.ONE
	label.modulate = Color.WHITE
	if reduce_motion_enabled:
		return
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
		button.scale = Vector2.ONE
		button.rotation = 0.0
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
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
	var previous_tween: Tween
	if control.has_meta("scale_tween"):
		previous_tween = control.get_meta("scale_tween") as Tween
	if previous_tween != null and previous_tween.is_valid():
		previous_tween.kill()
	if reduce_motion_enabled:
		control.scale = Vector2.ONE
		return
	var tween := create_tween()
	tween.tween_property(control, "scale", target_scale, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	control.set_meta("scale_tween", tween)


func _pop_control(control: Control, target_scale: Vector2, duration: float) -> void:
	var previous_tween: Tween
	if control.has_meta("scale_tween"):
		previous_tween = control.get_meta("scale_tween") as Tween
	if previous_tween != null and previous_tween.is_valid():
		previous_tween.kill()
	control.pivot_offset = control.size * 0.5
	if reduce_motion_enabled:
		control.scale = Vector2.ONE
		return
	var tween := create_tween()
	tween.tween_property(control, "scale", target_scale, duration * 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(control, "scale", Vector2.ONE, duration * 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	control.set_meta("scale_tween", tween)


func _celebrate_upgrade(card: Control, accent: Color, success_text: String = "UPGRADED!") -> void:
	_pop_control(card, Vector2(1.025, 1.025), 0.24)
	card.modulate = accent.lightened(0.45)
	var tween := create_tween()
	tween.tween_property(card, "modulate", Color.WHITE, 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_pulse_label(upgrade_coins_label, false)
	_spawn_upgrade_burst(card, accent, success_text)


func _spawn_upgrade_burst(card: Control, accent: Color, success_text: String = "UPGRADED!") -> void:
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
	success_label.text = success_text
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
	]
	entrance_nodes.append_array(extended_upgrade_cards)
	_animate_control_sequence(entrance_nodes, 0.055, 34.0)

	_start_upgrade_ambient_animation()


func _animate_pause_menu() -> void:
	if not menu_panel.visible:
		return

	var entrance_nodes: Array[Control] = [
		menu_header,
		menu_wallet,
		daily_reward_card,
		settings_button,
		tutorial_menu_replay_button,
		achievements_button,
		stats_button,
	]
	_animate_control_sequence(entrance_nodes, 0.045, 30.0)

	menu_coin_icon.pivot_offset = menu_coin_icon.size * 0.5
	menu_coin_icon.scale = Vector2(0.6, 0.6)
	var coin_tween := create_tween()
	coin_tween.set_parallel(true)
	coin_tween.tween_property(menu_coin_icon, "rotation", TAU, 0.62).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	coin_tween.tween_property(menu_coin_icon, "scale", Vector2.ONE, 0.42).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	coin_tween.chain().tween_callback(func() -> void:
		menu_coin_icon.rotation = 0.0
		menu_coin_icon.scale = Vector2.ONE
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
	], 0.055, 32.0)


func _animate_stats_screen() -> void:
	if not stats_panel.visible:
		return
	var controls: Array[Control] = [stats_header]
	controls.append_array(stats_card_controls)
	_animate_control_sequence(controls, 0.04, 28.0)


func _animate_achievements_screen() -> void:
	if not achievements_panel.visible:
		return
	var items := achievements_list.get_parent() as Control
	var controls: Array[Control] = []
	for child in items.get_children():
		if child is Control and child.visible:
			controls.append(child as Control)
	_animate_control_sequence(controls, 0.065, 34.0)


func _on_achievements_filter_selected(_index: int) -> void:
	_update_achievements_ui()


func _animate_skins_screen() -> void:
	if not skins_panel.visible:
		return
	var controls: Array[Control] = []
	var items := skins_tabs_row.get_parent()
	for child in items.get_children():
		if child is Control and child.visible and child != skins_scroll:
			controls.append(child as Control)
	var active_panel := skins_section_panels.get(skins_active_section) as Control
	if active_panel != null:
		for child in active_panel.get_children():
			if child is Control and child.visible:
				controls.append(child as Control)
	var active_list: VBoxContainer = null
	match skins_active_section:
		"crates":
			active_list = crates_list
		"background":
			active_list = room_skins_list
		_:
			active_list = skins_list
	for child in active_list.get_children():
		if child is Control and child.visible:
			controls.append(child as Control)
	_animate_control_sequence(controls, 0.035, 36.0)


func _animate_control_sequence(
	controls: Array[Control],
	delay_step: float = 0.045,
	_unused_slide_distance: float = 30.0
) -> void:
	_stop_entrance_animations()
	for index in range(controls.size()):
		var control := controls[index]
		if not is_instance_valid(control) or not control.visible:
			continue
		control.pivot_offset = control.size * 0.5
		# Telegram fragments keep content motion quiet: a short, bounded fade
		# and nearly imperceptible settle instead of elastic card rotation.
		control.scale = Vector2(0.985, 0.985)
		control.rotation = 0.0
		control.modulate = Color(1.0, 1.0, 1.0, 0.0)
		entrance_controls.append(control)
		var delay := minf(float(index) * delay_step * 0.22, 0.12)
		var entrance_tween := create_tween().set_parallel(true)
		entrance_tweens.append(entrance_tween)
		entrance_tween.tween_property(control, "modulate:a", 1.0, 0.16).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		entrance_tween.tween_property(control, "scale", Vector2.ONE, 0.18).set_delay(delay).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _stop_entrance_animations() -> void:
	for tween in entrance_tweens:
		if tween != null and tween.is_valid():
			tween.kill()
	entrance_tweens.clear()
	for control in entrance_controls:
		if is_instance_valid(control):
			control.scale = Vector2.ONE
			control.rotation = 0.0
			control.modulate = Color.WHITE
	entrance_controls.clear()


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
	_configure_touch_scroll(boosts_scroll)
	if crate_logic != null and is_instance_valid(crate_logic.scroll):
		_configure_touch_scroll(crate_logic.scroll)


func _setup_modal_navigation() -> void:
	var obsolete_navigation: Array[Control] = [
		resume_button,
		settings_back_button,
		upgrades_back_button,
		achievements_back_button,
		stats_back_button,
		skins_back_button,
		boosts_back_button,
	]
	for control in obsolete_navigation:
		control.hide()

	menu_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	menu_overlay.color = Color(0.01, 0.015, 0.035, 0.76)
	for panel in _get_overlay_panels():
		panel.mouse_filter = Control.MOUSE_FILTER_STOP

	modal_close_button = Button.new()
	modal_close_button.name = "ModalCloseButton"
	modal_close_button.text = "×"
	modal_close_button.tooltip_text = "Close (Esc)"
	modal_close_button.size = Vector2(48.0, 48.0)
	modal_close_button.custom_minimum_size = Vector2(48.0, 48.0)
	modal_close_button.flat = false
	modal_close_button.focus_mode = Control.FOCUS_NONE
	modal_close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	modal_close_button.z_index = 20
	modal_close_button.add_theme_font_size_override("font_size", 28)
	modal_close_button.add_theme_color_override("font_color", Color(0.78, 0.9, 1.0, 1.0))
	modal_close_button.add_theme_color_override("font_hover_color", Color.WHITE)
	modal_close_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	modal_close_button.add_theme_color_override("font_shadow_color", Color(0.0, 0.08, 0.18, 0.72))
	modal_close_button.add_theme_constant_override("shadow_offset_x", 0)
	modal_close_button.add_theme_constant_override("shadow_offset_y", 2)
	modal_close_button.add_theme_stylebox_override("normal", _make_upgrade_style(Color(0.055, 0.085, 0.14, 0.98), Color(0.3, 0.7, 1.0, 0.82), 12, 2, -1, 7))
	modal_close_button.add_theme_stylebox_override("hover", _make_upgrade_style(Color(0.09, 0.16, 0.26, 1.0), Color(0.48, 0.84, 1.0, 1.0), 12, 2, -1, 9))
	modal_close_button.add_theme_stylebox_override("pressed", _make_upgrade_style(Color(0.04, 0.07, 0.13, 1.0), Color(0.72, 0.56, 1.0, 1.0), 12, 2, -1, 4))
	modal_close_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	modal_close_button.pressed.connect(_hide_menu)
	modal_close_button.mouse_entered.connect(_animate_modal_close_hover.bind(true))
	modal_close_button.mouse_exited.connect(_animate_modal_close_hover.bind(false))
	menu_overlay.add_child(modal_close_button)

	_build_modal_decorations()


func _build_modal_decorations() -> void:
	var colors := [
		Color(0.48, 0.84, 1.0, 0.9),
		Color(0.78, 0.5, 1.0, 0.9),
		Color(1.0, 0.72, 0.28, 0.9),
	]
	for index in range(8):
		var sparkle := ColorRect.new()
		sparkle.name = "ModalSparkle%d" % index
		var sparkle_size := 7.0 if index % 3 == 0 else 5.0
		sparkle.size = Vector2(sparkle_size, sparkle_size)
		sparkle.pivot_offset = sparkle.size * 0.5
		sparkle.rotation = PI * 0.25
		sparkle.color = colors[index % colors.size()]
		sparkle.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sparkle.z_index = 18
		sparkle.modulate.a = 0.0
		menu_overlay.add_child(sparkle)
		modal_decorations.append(sparkle)


func _get_overlay_panels() -> Array[Control]:
	var panels: Array[Control] = [
		menu_panel,
		settings_panel,
		upgrades_panel,
		achievements_panel,
		stats_panel,
		skins_panel,
		boosts_panel,
		food_panel,
		museum_panel,
	]
	if bottomless_bowl_logic != null and is_instance_valid(bottomless_bowl_logic.panel):
		panels.append(bottomless_bowl_logic.panel)
	if crate_logic != null and is_instance_valid(crate_logic.panel):
		panels.append(crate_logic.panel)
	if mission_logic != null and is_instance_valid(mission_logic.panel):
		panels.append(mission_logic.panel)
	return panels


func _get_visible_overlay_panel() -> Control:
	for panel in _get_overlay_panels():
		if panel.visible:
			return panel
	return null


func _position_modal_close_button(panel: Control) -> void:
	if not is_instance_valid(modal_close_button) or not panel.visible:
		return
	var panel_rect := panel.get_global_rect()
	modal_close_button.global_position = panel_rect.position + Vector2(panel_rect.size.x - 52.0, 4.0)
	var decoration_offsets := [
		Vector2(-8.0, 70.0),
		Vector2(panel_rect.size.x + 2.0, 96.0),
		Vector2(-5.0, panel_rect.size.y * 0.36),
		Vector2(panel_rect.size.x + 1.0, panel_rect.size.y * 0.46),
		Vector2(12.0, panel_rect.size.y - 34.0),
		Vector2(panel_rect.size.x - 20.0, panel_rect.size.y - 22.0),
		Vector2(panel_rect.size.x * 0.28, -4.0),
		Vector2(panel_rect.size.x * 0.68, panel_rect.size.y + 1.0),
	]
	for index in range(mini(modal_decorations.size(), decoration_offsets.size())):
		var decoration := modal_decorations[index]
		decoration.global_position = panel_rect.position + decoration_offsets[index]


func _animate_modal_close_hover(hovered: bool) -> void:
	if not is_instance_valid(modal_close_button):
		return
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		modal_close_button,
		"rotation",
		0.16 if hovered else 0.0,
		0.16
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		modal_close_button,
		"scale",
		Vector2(1.22, 1.22) if hovered else Vector2.ONE,
		0.16
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _start_modal_decoration_animation() -> void:
	if modal_decoration_tween != null and modal_decoration_tween.is_valid():
		modal_decoration_tween.kill()
	modal_decoration_tween = create_tween().set_loops().set_parallel(true)
	for index in range(modal_decorations.size()):
		var decoration := modal_decorations[index]
		var direction := 1.0 if index % 2 == 0 else -1.0
		modal_decoration_tween.tween_property(
			decoration,
			"rotation",
			decoration.rotation + TAU * direction,
			4.0
		).set_trans(Tween.TRANS_LINEAR)


func _finish_modal_open(panel: Control) -> void:
	if panel == null or not panel.visible:
		return
	_position_modal_close_button(panel)
	_start_modal_decoration_animation()


func _reset_panel_scroll(panel: Control) -> void:
	if not panel.visible:
		return
	var scroll := _find_scroll_container(panel)
	if scroll != null:
		scroll.scroll_vertical = 0
		scroll.scroll_horizontal = 0


func _find_scroll_container(node: Node) -> ScrollContainer:
	if node is ScrollContainer:
		return node as ScrollContainer
	for child in node.get_children():
		var scroll := _find_scroll_container(child)
		if scroll != null:
			return scroll
	return null


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


func _get_scroll_at_position(global_position: Vector2) -> ScrollContainer:
	var candidate_scrolls: Array[ScrollContainer] = []
	if skins_panel.visible:
		if skins_active_section == "background" and is_instance_valid(room_skins_scroll):
			candidate_scrolls.append(room_skins_scroll)
		elif skins_active_section == "crates" and is_instance_valid(crates_scroll):
			candidate_scrolls.append(crates_scroll)
		elif is_instance_valid(skins_scroll):
			candidate_scrolls.append(skins_scroll)
		if is_instance_valid(room_skins_scroll):
			candidate_scrolls.append(room_skins_scroll)
		if is_instance_valid(crates_scroll):
			candidate_scrolls.append(crates_scroll)
		if is_instance_valid(skins_scroll):
			candidate_scrolls.append(skins_scroll)
	if boosts_panel.visible and is_instance_valid(boosts_scroll):
		candidate_scrolls.append(boosts_scroll)
	if food_panel.visible and is_instance_valid(food_scroll):
		candidate_scrolls.append(food_scroll)
	if stats_panel.visible and is_instance_valid(stats_cards):
		candidate_scrolls.append(stats_cards.get_parent() as ScrollContainer)
	if crate_logic != null and is_instance_valid(crate_logic.panel) and crate_logic.panel.visible and is_instance_valid(crate_logic.scroll):
		candidate_scrolls.append(crate_logic.scroll)
	if mission_logic != null and is_instance_valid(mission_logic.panel) and mission_logic.panel.visible:
		var mission_scroll := _find_scroll_container(mission_logic.panel)
		if mission_scroll != null:
			candidate_scrolls.append(mission_scroll)
	if museum_panel.visible and is_instance_valid(museum_scroll):
		candidate_scrolls.append(museum_scroll)
	if bottomless_bowl_logic != null and is_instance_valid(bottomless_bowl_logic.panel) and bottomless_bowl_logic.panel.visible:
		var bowl_scroll := _find_scroll_container(bottomless_bowl_logic.panel)
		if bowl_scroll != null:
			candidate_scrolls.append(bowl_scroll)
	for panel in [menu_panel, settings_panel, upgrades_panel, achievements_panel]:
		if panel.visible:
			var panel_scroll := _find_scroll_container(panel)
			if panel_scroll != null:
				candidate_scrolls.append(panel_scroll)

	for scroll in candidate_scrolls:
		if scroll != null and scroll.is_visible_in_tree() and scroll.get_global_rect().has_point(global_position):
			return scroll
	return _get_visible_menu_scroll()


func _get_visible_menu_scroll() -> ScrollContainer:
	if stats_panel.visible:
		return stats_cards.get_parent() as ScrollContainer
	if skins_panel.visible:
		if skins_active_section == "background" and is_instance_valid(room_skins_scroll):
			return room_skins_scroll
		if skins_active_section == "crates" and is_instance_valid(crates_scroll):
			return crates_scroll
		return skins_scroll
	if boosts_panel.visible:
		return boosts_scroll
	if food_panel.visible:
		return food_scroll
	if crate_logic != null and is_instance_valid(crate_logic.panel) and crate_logic.panel.visible:
		return crate_logic.scroll
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
	if is_instance_valid(food_list):
		food_list.columns = 2 if viewport_size.x < 520.0 else 3
		_apply_food_grid_responsive_style(viewport_size.x)
	_set_responsive_panel_size(menu_panel, Vector2(510.0, 760.0), panel_width, panel_height)
	_set_responsive_panel_size(settings_panel, Vector2(560.0, 920.0), panel_width, panel_height)
	_set_responsive_panel_size(upgrades_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(achievements_panel, Vector2(520.0, 620.0), panel_width, panel_height)
	_set_responsive_panel_size(stats_panel, Vector2(610.0, 900.0), panel_width, panel_height)
	_set_responsive_panel_size(skins_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(boosts_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(food_panel, Vector2(640.0, 980.0), panel_width, panel_height)
	_set_responsive_panel_size(museum_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_apply_upgrades_responsive_layout(viewport_size.x)
	_apply_boosts_responsive_layout(viewport_size.x)
	_apply_museum_responsive_layout(viewport_size.x)
	_apply_skins_responsive_layout(viewport_size.x)
	if mission_logic != null:
		mission_logic.apply_responsive_layout(viewport_size.x)
	if bottomless_bowl_logic != null and is_instance_valid(bottomless_bowl_logic.panel):
		_set_responsive_panel_size(bottomless_bowl_logic.panel, Vector2(640.0, 1080.0), panel_width, panel_height)
		bottomless_bowl_logic.apply_responsive_layout(viewport_size.x)
	if crate_logic != null and is_instance_valid(crate_logic.panel):
		_set_responsive_panel_size(crate_logic.panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	if mission_logic != null and is_instance_valid(mission_logic.panel):
		_set_responsive_panel_size(mission_logic.panel, Vector2(640.0, 920.0), panel_width, panel_height)
	if is_instance_valid(telegram_pager_host):
		telegram_pager_host.offset_top = telegram_top_height
		telegram_pager_host.offset_bottom = -telegram_bottom_height
		for telegram_panel in _get_overlay_panels():
			if telegram_panel == menu_panel:
				_layout_pause_popup()
				continue
			telegram_panel.custom_minimum_size = Vector2.ZERO
			telegram_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if is_instance_valid(settings_shell):
		_layout_settings_shell()
	if is_instance_valid(pause_detail_shell):
		_layout_pause_detail_shell()

	var short_phone := viewport_size.y < 1080.0
	var game_margin := 18 if short_phone else 24
	var bottom_reserved := 64 if short_phone else 84
	var game_separation := 12 if short_phone else 22
	var tap_width := minf(560.0, content_width - side_margin * 2.0)
	var tap_height_limit := maxf(300.0, viewport_size.y - bottom_reserved - (300.0 if short_phone else 330.0))
	var tap_height := minf(tap_width * 1.05, tap_height_limit)
	cat_button.custom_minimum_size = Vector2(maxf(260.0, tap_width), maxf(300.0, tap_height))
	score_label.add_theme_font_size_override("font_size", 34 if short_phone else 42)

	var game_layer := get_node("GameLayer") as MarginContainer
	var game_box := get_node("GameLayer/GameBox") as VBoxContainer
	game_layer.add_theme_constant_override("margin_left", game_margin)
	game_layer.add_theme_constant_override("margin_top", roundi(telegram_top_height + 12.0) if is_instance_valid(telegram_navigation) else (54 if short_phone else 64))
	game_layer.add_theme_constant_override("margin_right", game_margin)
	game_layer.add_theme_constant_override("margin_bottom", roundi(telegram_bottom_height + 14.0) if is_instance_valid(telegram_navigation) else bottom_reserved)
	game_box.add_theme_constant_override("separation", game_separation)

	var phone_layout := content_width < 700.0 or DisplayServer.get_name() in ["Android", "iOS"]
	var legacy_hud_actions_visible := upgrade_button.visible
	var hud_gap := (28.0 if phone_layout else 22.0) if legacy_hud_actions_visible else 0.0
	var available_hud_width := content_width - side_margin * 2.0 - hud_gap
	var hud_width := (
		(minf(300.0, available_hud_width * 0.52) if phone_layout else available_hud_width * 0.43)
		if legacy_hud_actions_visible
		else available_hud_width
	)
	var upgrade_width := (
		(minf(250.0, available_hud_width - hud_width) if phone_layout else available_hud_width - hud_width)
		if legacy_hud_actions_visible
		else 0.0
	)
	var hud_row_width := hud_width + hud_gap + upgrade_width
	var hud_row_left := content_left + (content_width - hud_row_width) * 0.5
	var hud_row_right := hud_row_left + hud_row_width
	var hud_height := 62.0 if short_phone else 68.0
	var shell_bottom_offset := telegram_bottom_height if is_instance_valid(telegram_navigation) else 0.0
	hud_wallet.offset_left = hud_row_left
	hud_wallet.offset_top = -shell_bottom_offset - hud_height - side_margin
	hud_wallet.offset_right = hud_row_left + hud_width
	hud_wallet.offset_bottom = -shell_bottom_offset - side_margin
	if is_instance_valid(compact_inventory_panel):
		compact_inventory_panel.offset_left = hud_row_left
		compact_inventory_panel.offset_right = hud_row_left + hud_width
		compact_inventory_panel.offset_bottom = hud_wallet.offset_top - 10.0
	upgrade_button.offset_left = -(viewport_size.x - hud_row_right + upgrade_width)
	upgrade_button.offset_top = -shell_bottom_offset - hud_height - side_margin
	upgrade_button.offset_right = -(viewport_size.x - hud_row_right)
	upgrade_button.offset_bottom = -shell_bottom_offset - side_margin
	upgrade_button.custom_minimum_size = Vector2(upgrade_width, hud_height)
	hud_coin_icon.custom_minimum_size = Vector2(48.0, 48.0)
	call_deferred("_animate_hud_coin_text")
	upgrade_button.add_theme_font_size_override("font_size", 18 if phone_layout else 21)

	var boost_height := 64.0
	boosts_button.custom_minimum_size = Vector2(upgrade_width, boost_height)
	boosts_button.offset_left = upgrade_button.offset_left
	boosts_button.offset_top = upgrade_button.offset_top - boost_height - 12.0
	boosts_button.offset_right = upgrade_button.offset_right
	boosts_button.offset_bottom = upgrade_button.offset_top - 12.0
	boosts_button.add_theme_font_size_override("font_size", 17 if phone_layout else 19)

	if is_instance_valid(inventory_shop_bar):
		var backpack_size := 68.0 if short_phone else 76.0
		var backpack_top := telegram_top_height + 12.0
		inventory_shop_bar.offset_left = -side_margin - backpack_size
		inventory_shop_bar.offset_top = backpack_top
		inventory_shop_bar.offset_right = -side_margin
		inventory_shop_bar.offset_bottom = backpack_top + backpack_size
		inventory_button.custom_minimum_size = Vector2(backpack_size, backpack_size)
		shop_button.hide()

	var menu_size := 70.0 if short_phone else 78.0
	var menu_top := telegram_top_height + 12.0 if is_instance_valid(telegram_navigation) else side_margin
	menu_button.custom_minimum_size = Vector2(menu_size, menu_size)
	menu_button.offset_left = -(viewport_size.x - content_right + side_margin + menu_size)
	menu_button.offset_top = menu_top
	menu_button.offset_right = -(viewport_size.x - content_right + side_margin)
	menu_button.offset_bottom = menu_top + menu_size

	var skins_width := 142.0 if short_phone else 154.0
	var skins_height := 64.0
	skins_button.custom_minimum_size = Vector2(skins_width, skins_height)
	skins_button.offset_left = content_left + side_margin
	skins_button.offset_top = side_margin
	skins_button.offset_right = content_left + side_margin + skins_width
	skins_button.offset_bottom = side_margin + skins_height

	if crate_logic != null and is_instance_valid(crate_logic.button) and crate_logic.button.visible:
		var crates_height := 64.0
		crate_logic.button.custom_minimum_size = Vector2(skins_width, crates_height)
		crate_logic.button.offset_left = content_left + side_margin
		crate_logic.button.offset_top = side_margin + skins_height + 10.0
		crate_logic.button.offset_right = content_left + side_margin + skins_width
		crate_logic.button.offset_bottom = side_margin + skins_height + 10.0 + crates_height
		crate_logic.button.add_theme_font_size_override("font_size", 15 if phone_layout else 17)

	if mission_logic != null and is_instance_valid(mission_logic.button):
		var missions_height := 72.0
		var missions_top := side_margin + skins_height + 10.0
		if crate_logic != null and is_instance_valid(crate_logic.button) and crate_logic.button.visible:
			missions_top = crate_logic.button.offset_bottom + 10.0
		mission_logic.button.custom_minimum_size = Vector2(skins_width, missions_height)
		mission_logic.button.offset_left = content_left + side_margin
		mission_logic.button.offset_top = missions_top
		mission_logic.button.offset_right = content_left + side_margin + skins_width
		mission_logic.button.offset_bottom = missions_top + missions_height
		mission_logic.button.add_theme_font_size_override("font_size", 15 if phone_layout else 17)

	var museum_width := 142.0 if short_phone else 154.0
	var museum_height := 64.0
	var museum_top := side_margin + skins_height + 10.0
	if mission_logic != null and is_instance_valid(mission_logic.button) and mission_logic.button.visible:
		museum_top = mission_logic.button.offset_bottom + 10.0
	elif crate_logic != null and is_instance_valid(crate_logic.button) and crate_logic.button.visible:
		museum_top = crate_logic.button.offset_bottom + 10.0
	museum_button.custom_minimum_size = Vector2(museum_width, museum_height)
	museum_button.offset_left = content_left + side_margin
	museum_button.offset_top = museum_top
	museum_button.offset_right = content_left + side_margin + museum_width
	museum_button.offset_bottom = museum_top + museum_height
	museum_button.add_theme_font_size_override("font_size", 16 if phone_layout else 18)

	var bowl_height := 64.0
	bottomless_bowl_button.custom_minimum_size = Vector2(museum_width, bowl_height)
	bottomless_bowl_button.offset_left = museum_button.offset_left
	bottomless_bowl_button.offset_top = museum_button.offset_bottom + 10.0
	bottomless_bowl_button.offset_right = museum_button.offset_right
	bottomless_bowl_button.offset_bottom = museum_button.offset_bottom + 10.0 + bowl_height
	bottomless_bowl_button.add_theme_font_size_override("font_size", 15 if phone_layout else 17)

	upgrade_alert_badge.offset_left = -(viewport_size.x - hud_row_right + 44.0)
	upgrade_alert_badge.offset_top = -hud_height - side_margin + 8.0
	upgrade_alert_badge.offset_right = -(viewport_size.x - hud_row_right) - 8.0
	upgrade_alert_badge.offset_bottom = -hud_height - side_margin + 44.0
	var visible_panel := _get_visible_overlay_panel()
	if visible_panel != null:
		call_deferred("_position_modal_close_button", visible_panel)
	if tutorial_active or tutorial_prompt_visible:
		call_deferred("_update_tutorial_layout")
	_apply_touch_target_hierarchy(self)


func _set_responsive_panel_size(panel: Control, preferred_size: Vector2, max_width: float, max_height: float) -> void:
	panel.custom_minimum_size = Vector2(minf(preferred_size.x, max_width), minf(preferred_size.y, max_height))


func _apply_food_grid_responsive_style(viewport_width: float = -1.0) -> void:
	if viewport_width <= 0.0:
		viewport_width = get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	food_scroll.custom_minimum_size.y = 0.0 if compact or get_viewport_rect().size.y < 900.0 else 470.0
	var horizontal_margin := 6 if compact else 10
	var button_padding := 5.0 if compact else 12.0
	for card_node in food_cards.values():
		var card := card_node as PanelContainer
		if card == null:
			continue
		var margin := card.get_child(0) as MarginContainer
		if margin != null:
			margin.add_theme_constant_override("margin_left", horizontal_margin)
			margin.add_theme_constant_override("margin_right", horizontal_margin)
		var action := _meta_or_null(card, "action_button") as Button
		if action == null:
			continue
		action.custom_minimum_size.x = 0.0
		action.add_theme_font_size_override("font_size", 18 if compact else 20)
		var accent: Color = action.get_meta("normal_style_accent", Color(0.96, 0.68, 0.26, 1.0))
		_style_upgrade_button(action, accent)
		for style_name in ["normal", "hover", "pressed", "disabled"]:
			var style := action.get_theme_stylebox(style_name) as StyleBoxFlat
			if style != null:
				style.content_margin_left = button_padding
				style.content_margin_right = button_padding
				style.content_margin_top = 7.0
				style.content_margin_bottom = 7.0


func _apply_upgrades_responsive_layout(viewport_width: float = -1.0) -> void:
	if not is_instance_valid(upgrades_panel):
		return
	if viewport_width <= 0.0:
		viewport_width = get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	var root_margin := upgrades_panel.find_child("UpgradesMargin", true, false) as MarginContainer
	if root_margin != null:
		_set_telegram_margins(root_margin, 8 if compact else 12, 8 if compact else 10, 8 if compact else 12, 12 if compact else 14)
	var hero_margin := upgrades_panel.find_child("HeroMargin", true, false) as MarginContainer
	if hero_margin != null:
		_set_telegram_margins(hero_margin, 10 if compact else 18, 10 if compact else 14, 10 if compact else 18, 10 if compact else 14)
	var title := upgrades_panel.find_child("UpgradesTitle", true, false) as Label
	if title != null:
		title.custom_minimum_size.x = 0.0
		title.clip_text = true
		title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		title.add_theme_font_size_override("font_size", 25 if compact else 30)
	if is_instance_valid(wallet_chip):
		wallet_chip.custom_minimum_size.x = 190.0 if compact else 230.0
	if is_instance_valid(upgrade_coins_label):
		upgrade_coins_label.custom_minimum_size.x = 0.0
		upgrade_coins_label.clip_text = true
		upgrade_coins_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		upgrade_coins_label.add_theme_font_size_override("font_size", 20 if compact else 23)
	var tabs := upgrades_items.find_child("UpgradeCategoryTabs", false, false) as GridContainer
	if tabs != null:
		tabs.custom_minimum_size.x = 0.0
		tabs.add_theme_constant_override("h_separation", 6 if compact else 10)
		tabs.add_theme_constant_override("v_separation", 6 if compact else 8)
		for tab_node in tabs.get_children():
			var tab := tab_node as Button
			if tab == null:
				continue
			tab.custom_minimum_size = Vector2(0.0, 48.0 if compact else 52.0)
			tab.add_theme_font_size_override("font_size", 17 if compact else 20)
	var cards: Array[Control] = [click_upgrade_card, bonus_chance_card, bonus_value_card, bonus_streak_card, passive_gain_card]
	cards.append_array(extended_upgrade_cards)
	for card in cards:
		_apply_upgrade_card_responsive_layout(card, compact)


func _apply_upgrade_card_responsive_layout(card: Control, compact: bool) -> void:
	if not is_instance_valid(card):
		return
	card.custom_minimum_size.x = 0.0
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var margin := card.find_child("CardMargin", true, false) as MarginContainer
	if margin != null:
		_set_telegram_margins(margin, 9 if compact else 14, 9 if compact else 11, 9 if compact else 14, 10 if compact else 12)
	var header := card.find_child("Header", true, false) as HBoxContainer
	if header != null:
		header.custom_minimum_size.x = 0.0
		header.add_theme_constant_override("separation", 5 if compact else 10)
	var badge := card.find_child("Badge", true, false) as Label
	if badge != null:
		badge.custom_minimum_size = Vector2(60.0 if compact else 94.0, 36.0 if compact else 40.0)
		badge.clip_text = true
		badge.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		badge.add_theme_font_size_override("font_size", 14 if compact else 17)
	var name_label := card.find_child("Name", true, false) as Label
	if name_label != null:
		name_label.custom_minimum_size.x = 0.0
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.clip_text = true
		name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		name_label.add_theme_font_size_override("font_size", 16 if compact else 20)
	if header != null:
		for header_child in header.get_children():
			var header_label := header_child as Label
			if header_label == null or header_label == badge or header_label == name_label:
				continue
			header_label.custom_minimum_size.x = 58.0 if compact else 84.0
			header_label.size_flags_horizontal = Control.SIZE_SHRINK_END
			header_label.clip_text = true
			header_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			header_label.add_theme_font_size_override("font_size", 18 if compact else 24)
	for label_node in card.find_children("*", "Label", true, false):
		var label := label_node as Label
		if label == null or label == badge or label == name_label or label.get_parent() == header:
			continue
		label.custom_minimum_size.x = 0.0
		if label.autowrap_mode == TextServer.AUTOWRAP_OFF:
			label.clip_text = true
			label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		label.add_theme_font_size_override("font_size", 16 if compact else maxi(18, label.get_theme_font_size("font_size")))
	for button_node in card.find_children("*", "Button", true, false):
		var button := button_node as Button
		if button == null:
			continue
		button.custom_minimum_size.x = 0.0
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		button.add_theme_font_size_override("font_size", 17 if compact else 20)
		var accent: Color = button.get_meta("normal_style_accent", CLICK_UPGRADE_COLOR)
		_style_upgrade_button(button, accent)


func _apply_boosts_responsive_layout(viewport_width: float = -1.0) -> void:
	if not is_instance_valid(boosts_panel):
		return
	if viewport_width <= 0.0:
		viewport_width = get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	var root_margin := boosts_panel.find_child("BoostsOuterMargin", true, false) as MarginContainer
	if root_margin != null:
		_set_telegram_margins(root_margin, 8 if compact else 12, 8 if compact else 10, 8 if compact else 12, 12 if compact else 14)
	var hero_margin := boosts_panel.find_child("BoostsHeroMargin", true, false) as MarginContainer
	if hero_margin != null:
		_set_telegram_margins(hero_margin, 10 if compact else 18, 9 if compact else 12, 10 if compact else 18, 9 if compact else 12)
	var title := boosts_panel.find_child("BoostsTitle", true, false) as Label
	if title != null:
		title.custom_minimum_size.x = 0.0
		title.clip_text = true
		title.add_theme_font_size_override("font_size", 27 if compact else 30)
	var subtitle := boosts_panel.find_child("BoostsSubtitle", true, false) as Label
	if subtitle != null:
		subtitle.custom_minimum_size.x = 0.0
		subtitle.add_theme_font_size_override("font_size", 15 if compact else 18)
	var tabs := boosts_panel.find_child("BoostCategoryTabs", true, false) as GridContainer
	if tabs != null:
		tabs.custom_minimum_size.x = 0.0
		tabs.add_theme_constant_override("h_separation", 6 if compact else 10)
		tabs.add_theme_constant_override("v_separation", 6 if compact else 8)
		for tab_node in tabs.get_children():
			var tab := tab_node as Button
			if tab == null:
				continue
			tab.custom_minimum_size = Vector2(0.0, 48.0 if compact else 52.0)
			tab.add_theme_font_size_override("font_size", 17 if compact else 20)
	if is_instance_valid(boosts_scroll):
		boosts_scroll.custom_minimum_size.y = 0.0 if compact or get_viewport_rect().size.y < 900.0 else 360.0
	if is_instance_valid(boost_wallet_label):
		boost_wallet_label.custom_minimum_size.x = 164.0 if compact else 210.0
		boost_wallet_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		boost_wallet_label.clip_text = true
		boost_wallet_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		boost_wallet_label.add_theme_font_size_override("font_size", 20 if compact else 22)
	for card_node in boost_cards.values():
		var card := card_node as PanelContainer
		if card == null:
			continue
		card.custom_minimum_size.x = 0.0
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var margin := _meta_or_null(card, "margin") as MarginContainer
		if margin != null:
			_set_telegram_margins(margin, 9 if compact else 14, 10 if compact else 12, 9 if compact else 14, 10 if compact else 12)
		var header := _meta_or_null(card, "header") as HBoxContainer
		if header != null:
			header.custom_minimum_size.x = 0.0
			header.add_theme_constant_override("separation", 5 if compact else 10)
		var badge := _meta_or_null(card, "badge") as TextureRect
		if badge != null:
			badge.custom_minimum_size = Vector2(52.0 if compact else 64.0, 52.0 if compact else 64.0)
		var name_label := _meta_or_null(card, "name_label") as Label
		if name_label != null:
			name_label.custom_minimum_size.x = 0.0
			name_label.clip_text = true
			name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			name_label.add_theme_font_size_override("font_size", 16 if compact else 20)
		var status := _meta_or_null(card, "status_label") as Label
		if status != null:
			status.visible = not compact
			status.custom_minimum_size.x = 0.0
		var description := _meta_or_null(card, "description") as Label
		if description != null:
			description.custom_minimum_size.x = 0.0
			description.add_theme_font_size_override("font_size", 16 if compact else 20)
		var tier_info := _meta_or_null(card, "tier_info") as Label
		if tier_info != null:
			tier_info.custom_minimum_size.x = 0.0
			tier_info.clip_text = true
			tier_info.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			tier_info.add_theme_font_size_override("font_size", 14 if compact else 18)
		var actions := _meta_or_null(card, "actions") as HBoxContainer
		if actions != null:
			actions.custom_minimum_size.x = 0.0
			actions.add_theme_constant_override("separation", 5 if compact else 8)
		for action_node in boost_action_buttons.get(String(card.name).to_snake_case().trim_suffix("_card"), []):
			var action := action_node as Button
			if action == null:
				continue
			action.custom_minimum_size.x = 0.0
			action.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			action.add_theme_font_size_override("font_size", 14 if compact else 18)
			var accent: Color = action.get_meta("normal_style_accent", Color(0.68, 0.42, 1.0, 1.0))
			_style_upgrade_button(action, accent)


func _meta_or_null(object: Object, key: StringName) -> Variant:
	return object.get_meta(key) if object.has_meta(key) else null


func _apply_museum_responsive_layout(viewport_width: float = -1.0) -> void:
	if not is_instance_valid(museum_panel) or not is_instance_valid(museum_content):
		return
	if viewport_width <= 0.0:
		viewport_width = get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	var root_margin := museum_panel.find_child("MuseumRootMargin", true, false) as MarginContainer
	if root_margin != null:
		_set_telegram_margins(root_margin, 8 if compact else 12, 8 if compact else 10, 8 if compact else 12, 12 if compact else 14)
	museum_content.custom_minimum_size.x = 0.0
	var cat_grid := museum_panel.find_child("MuseumCatGrid", true, false) as GridContainer
	if cat_grid != null:
		cat_grid.columns = 2 if compact else (3 if viewport_width < 900.0 else 4)
	for grid_name in ["MuseumCatGrid", "MuseumTreasureGrid", "MuseumAchievementGrid"]:
		var grid := museum_panel.find_child(grid_name, true, false) as GridContainer
		if grid == null:
			continue
		grid.custom_minimum_size.x = 0.0
		grid.add_theme_constant_override("h_separation", 8 if compact else 10)
		for grid_child in grid.get_children():
			var control := grid_child as Control
			if control != null:
				control.custom_minimum_size.x = 0.0
	for panel_node in museum_panel.find_children("*", "PanelContainer", true, false):
		var panel := panel_node as PanelContainer
		if panel == null:
			continue
		var role := String(panel.get_meta("museum_role", ""))
		if role == "plaque":
			panel.custom_minimum_size = Vector2(0.0, 88.0 if compact else 82.0)
		elif role == "portrait":
			panel.custom_minimum_size = Vector2(0.0, 154.0 if compact else 172.0)
	for label_node in museum_panel.find_children("*", "Label", true, false):
		var label := label_node as Label
		if label == null:
			continue
		label.custom_minimum_size.x = 0.0
		var role := String(label.get_meta("museum_role", ""))
		match role:
			"hero":
				label.custom_minimum_size.y = 142.0 if compact else 126.0
				label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				label.add_theme_font_size_override("font_size", 22 if compact else 25)
			"section_title":
				label.clip_text = true
				label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
				label.add_theme_font_size_override("font_size", 20 if compact else 24)
			"section_detail":
				label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				label.add_theme_font_size_override("font_size", 17 if compact else 18)
			"plaque_label":
				label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				label.add_theme_font_size_override("font_size", 15 if compact else 18)
			"portrait_name":
				label.clip_text = true
				label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
				label.add_theme_font_size_override("font_size", 16 if compact else 18)
			_:
				if label.autowrap_mode == TextServer.AUTOWRAP_OFF:
					label.clip_text = true
					label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	for button_node in museum_panel.find_children("*", "Button", true, false):
		var button := button_node as Button
		if button == null:
			continue
		button.custom_minimum_size.x = 0.0
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		button.add_theme_font_size_override("font_size", 16 if compact else 20)


func _apply_skins_responsive_layout(viewport_width: float = -1.0) -> void:
	if not is_instance_valid(skins_panel):
		return
	if viewport_width <= 0.0:
		viewport_width = get_viewport_rect().size.x
	var compact := viewport_width < 520.0
	var root_margin := skins_panel.find_child("SkinsOuterMargin", true, false) as MarginContainer
	if root_margin != null:
		_set_telegram_margins(root_margin, 8 if compact else 12, 8 if compact else 10, 8 if compact else 12, 12 if compact else 14)
	var hero_margin := skins_panel.find_child("SkinsHeroMargin", true, false) as MarginContainer
	if hero_margin != null:
		_set_telegram_margins(hero_margin, 10 if compact else 18, 9 if compact else 13, 10 if compact else 18, 9 if compact else 13)
	var title := skins_panel.find_child("SkinsTitle", true, false) as Label
	if title != null:
		title.custom_minimum_size.x = 0.0
		title.clip_text = true
		title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		title.add_theme_font_size_override("font_size", 27 if compact else 30)
	if is_instance_valid(skins_status_label):
		skins_status_label.custom_minimum_size = Vector2(0.0, 42.0 if compact else 0.0)
		skins_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		skins_status_label.add_theme_font_size_override("font_size", 16 if compact else 18)
	if is_instance_valid(skins_wallet_label):
		skins_wallet_label.custom_minimum_size.x = 230.0 if compact else 310.0
		skins_wallet_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		skins_wallet_label.clip_text = true
		skins_wallet_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		skins_wallet_label.add_theme_font_size_override("font_size", 16 if compact else 22)
	skins_tabs_row.custom_minimum_size.x = 0.0
	skins_tabs_row.add_theme_constant_override("separation", 6 if compact else 8)
	for tab_node in skins_tabs_row.get_children():
		var tab := tab_node as Button
		if tab == null:
			continue
		tab.custom_minimum_size = Vector2(0.0, 48.0)
		tab.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	for scroll in [skins_scroll, crates_scroll, room_skins_scroll]:
		if scroll == null:
			continue
		scroll.custom_minimum_size.y = 0.0 if compact or get_viewport_rect().size.y < 900.0 else 720.0
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	for panel_node in skins_panel.find_children("*", "PanelContainer", true, false):
		var card := panel_node as PanelContainer
		if card == null:
			continue
		var role := String(card.get_meta("skins_role", ""))
		if role.is_empty():
			continue
		card.custom_minimum_size.x = 0.0
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if role == "skin_card":
			card.custom_minimum_size.y = 176.0 if compact else 214.0
			var card_margin := card.find_child("SkinCardMargin", true, false) as MarginContainer
			if card_margin != null:
				_set_telegram_margins(card_margin, 9 if compact else 12, 9 if compact else 12, 9 if compact else 12, 9 if compact else 12)
			var row := card.find_child("SkinCardRow", true, false) as HBoxContainer
			if row != null:
				row.custom_minimum_size.x = 0.0
				row.add_theme_constant_override("separation", 9 if compact else 14)
			var preview := card.find_child("SkinPreview", true, false) as TextureRect
			if preview != null:
				preview.custom_minimum_size = Vector2(98.0 if compact else 150.0, 142.0 if compact else 150.0)
		elif role == "set_card":
			var set_margin := card.find_child("SkinSetMargin", true, false) as MarginContainer
			if set_margin != null:
				_set_telegram_margins(set_margin, 9 if compact else 12, 9 if compact else 12, 9 if compact else 12, 9 if compact else 12)
			var set_row := card.find_child("SkinSetRow", true, false) as HBoxContainer
			if set_row != null:
				set_row.custom_minimum_size.x = 0.0
				set_row.add_theme_constant_override("separation", 8 if compact else 14)
				if set_row.get_child_count() > 0 and set_row.get_child(0) is Label:
					(set_row.get_child(0) as Label).custom_minimum_size.x = 42.0 if compact else 54.0
		elif role == "room_card":
			card.custom_minimum_size = Vector2(0.0, 184.0)
			var room_preview := card.find_child("RoomSkinPreview", true, false) as TextureRect
			if room_preview != null:
				room_preview.custom_minimum_size = Vector2(0.0, 110.0)
		for label_node in card.find_children("*", "Label", true, false):
			var label := label_node as Label
			if label == null or label.name == "LockOverlay":
				continue
			label.custom_minimum_size.x = 0.0
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			label.add_theme_font_size_override("font_size", 16 if compact else maxi(18, label.get_theme_font_size("font_size")))
		for button_node in card.find_children("*", "Button", true, false):
			var action := button_node as Button
			if action == null:
				continue
			action.custom_minimum_size.x = 0.0
			action.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			action.add_theme_font_size_override("font_size", 16 if compact else 20)
	if crate_logic != null:
		crate_logic.apply_responsive_layout(viewport_width)


func _spawn_click_popup(amount: int, bonus_multiplier: int = 1, streak_multiplier: int = 1, current_combo_bonus: float = 0.0) -> void:
	if not floating_numbers_enabled:
		return
	if optimized_tap_effects and click_popup_layer.get_child_count() > _get_effective_particle_limit():
		return
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
	var combo_heat := clampf(current_combo_bonus / get_effective_combo_cap(), 0.0, 1.0)
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
	if not reduce_motion_enabled:
		tween.tween_property(popup, "position", popup.position + drift, 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var end_scale := 1.02 + (float(streak_multiplier - 1) * 0.04) + combo_heat * 0.08
	if not reduce_motion_enabled:
		tween.tween_property(popup, "scale", Vector2(end_scale, end_scale), 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 0.0, 0.42 if reduce_motion_enabled else 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(Callable(popup, "queue_free"))


func _spawn_tap_burst(is_bonus: bool) -> void:
	if reduce_motion_enabled:
		return
	if optimized_tap_effects and not is_bonus:
		return
	var cat_rect: Rect2 = cat_button.get_global_rect()
	var origin := Vector2(cat_rect.get_center().x, cat_rect.end.y + 8.0)

	var base_count := 8 if is_bonus else 4
	var particle_count := mini(_get_effective_particle_limit(base_count), maxi(1, roundi(float(base_count) * effects_scale)))
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
	if is_instance_valid(telegram_pager_host):
		_show_pause_popup()
		_tutorial_notify("menu_opened")
		return
	_show_overlay_panel(menu_panel)
	call_deferred("_animate_pause_menu")
	_tutorial_notify("menu_opened")


func _show_settings() -> void:
	_play_ui_sound()
	settings_back_to_pause = pause_popup_open
	if pause_popup_open:
		_hide_pause_popup(false, true)
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_settings_shell()


func _show_upgrades() -> void:
	_play_ui_sound()
	active_shop_section = "upgrades"
	_refresh_shop_section_tabs()
	if is_instance_valid(settings_shell) and settings_shell.visible:
		settings_back_to_pause = false
		_hide_settings_shell_immediate()
	_update_upgrade_ui()
	_update_stats_ui()
	_update_daily_reward_ui()
	_apply_telegram_page_style(upgrades_panel)
	_apply_upgrades_responsive_layout()
	_refresh_telegram_segment_buttons(upgrade_category_buttons, upgrade_active_category)
	_show_overlay_panel(upgrades_panel)
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_destination("shop")
	call_deferred("_animate_upgrade_screen")
	_tutorial_notify("upgrades_opened")


func _show_achievements() -> void:
	_play_ui_sound()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_pause_detail(achievements_panel, "Achievements")
	_update_achievements_ui()
	_style_telegram_achievements_detail()
	call_deferred("_animate_achievements_screen")


func _show_stats() -> void:
	_play_ui_sound()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_pause_detail(stats_panel, "Statistics")
	_style_telegram_stats_detail()
	call_deferred("_animate_stats_screen")


func _show_skins() -> void:
	_play_ui_sound()
	var skin_data := _get_skin_data(equipped_skin_id)
	skins_status_label.text = "Equipped: %s. %s" % [_get_equipped_skin_name(), _get_skin_bonus_text(skin_data)]
	_set_skins_section("skins")
	_update_skins_ui()
	_apply_telegram_page_style(skins_panel)
	_refresh_telegram_segment_buttons(skins_tab_buttons, skins_active_section)
	_apply_skins_responsive_layout()
	_show_overlay_panel(skins_panel)
	call_deferred("_animate_skins_screen")
	_tutorial_notify("skins_opened")


func _show_boosts() -> void:
	_play_ui_sound()
	active_shop_section = "boosts"
	_refresh_shop_section_tabs()
	boost_logic.update_ui()
	_apply_telegram_page_style(boosts_panel)
	_apply_boosts_responsive_layout()
	_refresh_telegram_segment_buttons(boost_category_buttons, boost_active_category)
	_show_overlay_panel(boosts_panel)
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_destination("shop")
	call_deferred("_animate_boost_screen")
	_tutorial_notify("boosts_opened")


func _show_inventory() -> void:
	_play_ui_sound()
	food_panel_mode = "inventory"
	food_status_label.text = "Choose Food or Boosts. Use now, or drag onto the cat."
	_update_food_ui()
	_show_overlay_panel(food_panel)
	call_deferred("_animate_food_screen")
	_tutorial_notify("inventory_opened")


func _show_shop() -> void:
	_show_shop_section("food")


func _show_crates() -> void:
	_play_ui_sound()
	crate_logic.update_ui(false)
	_show_overlay_panel(crate_logic.panel)
	call_deferred("_animate_crates_screen")


func _show_museum() -> void:
	_play_ui_sound()
	_rebuild_museum()
	_apply_telegram_page_style(museum_panel)
	_apply_museum_responsive_layout()
	_show_overlay_panel(museum_panel)


func _show_bottomless_bowl() -> void:
	_play_ui_sound()
	bottomless_bowl_logic.update_ui()
	_apply_telegram_page_style(bottomless_bowl_logic.panel)
	bottomless_bowl_logic.apply_responsive_layout()
	_show_overlay_panel(bottomless_bowl_logic.panel)


func _show_missions() -> void:
	_play_ui_sound()
	mission_logic.update_ui()
	_apply_telegram_page_style(mission_logic.panel)
	mission_logic.apply_responsive_layout()
	_show_overlay_panel(mission_logic.panel)
	_tutorial_notify("missions_opened")


func _animate_crates_screen() -> void:
	if crate_logic == null or not is_instance_valid(crate_logic.panel) or not crate_logic.panel.visible:
		return
	var controls: Array[Control] = []
	var content: Node = crate_logic.scroll.get_child(0)
	for child in content.get_children():
		if child is Control and child.visible:
			controls.append(child as Control)
	_animate_control_sequence(controls, 0.025, 28.0)


func _animate_boost_screen() -> void:
	if not boosts_panel.visible:
		return
	var controls: Array[Control] = []
	var items := boosts_scroll.get_parent()
	for child in items.get_children():
		if child is Control and child.visible and child != boosts_scroll:
			controls.append(child as Control)
	for boost_data in BoostLogic.BOOST_DATA:
		var card := boost_cards.get(String(boost_data["id"])) as Control
		if card != null:
			controls.append(card)
	_animate_control_sequence(controls, 0.035, 36.0)


func _animate_food_screen() -> void:
	if not food_panel.visible:
		return
	var controls: Array[Control] = [food_panel_title, food_wallet_label, food_status_label]
	for child in food_list.get_children():
		if child is Control and child.visible:
			controls.append(child as Control)
	_animate_control_sequence(controls, 0.015, 22.0)


func _build_telegram_navigation() -> void:
	telegram_pager_host = Control.new()
	telegram_pager_host.name = "TelegramPagerHost"
	telegram_pager_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	telegram_pager_host.offset_top = telegram_top_height
	telegram_pager_host.offset_bottom = -telegram_bottom_height
	telegram_pager_host.clip_contents = true
	telegram_pager_host.mouse_filter = Control.MOUSE_FILTER_PASS
	menu_overlay.add_child(telegram_pager_host)
	for panel in _get_overlay_panels():
		if panel == menu_panel:
			panel.reparent(menu_overlay)
			panel.set_anchors_preset(Control.PRESET_CENTER)
			panel.offset_left = -260.0
			panel.offset_top = -370.0
			panel.offset_right = 260.0
			panel.offset_bottom = 370.0
			panel.custom_minimum_size = Vector2.ZERO
			panel.z_index = 51
			_apply_telegram_style_tree(panel, true)
			panel.hide()
			continue
		panel.reparent(telegram_pager_host)
		panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		panel.custom_minimum_size = Vector2.ZERO
		panel.position = Vector2.ZERO
		panel.pivot_offset = Vector2.ZERO
		_apply_telegram_page_style(panel)
	pause_dim = ColorRect.new()
	pause_dim.name = "PauseDim"
	pause_dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_dim.color = Color(0.0, 0.0, 0.0, 0.62)
	pause_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_dim.z_index = 50
	pause_dim.gui_input.connect(_on_pause_dim_gui_input)
	pause_dim.hide()
	menu_overlay.add_child(pause_dim)
	# GUI picking follows Control tree order, not only visual z_index. Keep the
	# dimmer before the popup so it receives only clicks outside MenuPanel.
	menu_overlay.move_child(pause_dim, menu_panel.get_index())
	menu_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	modal_close_button.hide()
	for decoration in modal_decorations:
		decoration.hide()
	menu_overlay.color = NORMAL_SHELL_BACKGROUND
	menu_overlay.mouse_filter = Control.MOUSE_FILTER_STOP

	telegram_navigation = TelegramNavigation.new()
	telegram_navigation.name = "TelegramNavigation"
	add_child(telegram_navigation)
	telegram_navigation.destination_requested.connect(_on_telegram_destination_requested)
	telegram_navigation.pause_requested.connect(_show_menu)
	telegram_navigation.layout_metrics_changed.connect(_on_telegram_layout_metrics_changed)
	telegram_navigation.pager_drag_started.connect(_on_telegram_pager_drag_started)
	telegram_navigation.pager_dragged.connect(_on_telegram_pager_dragged)
	telegram_navigation.pager_drag_released.connect(_on_telegram_pager_drag_released)
	_on_telegram_layout_metrics_changed(
		float(telegram_navigation.call("get_top_height")),
		float(telegram_navigation.call("get_bottom_height"))
	)
	_build_settings_shell()
	_build_pause_detail_shell()
	# The shell owns primary navigation. Legacy HUD shortcuts stay alive for
	# tutorial callbacks, but are no longer visible or interactive.
	menu_button.hide()
	upgrade_button.hide()
	upgrade_alert_badge.hide()
	skins_button.hide()
	boosts_button.hide()
	inventory_shop_bar.hide()
	shop_button.hide()
	museum_button.hide()
	if mission_logic != null and is_instance_valid(mission_logic.button):
		mission_logic.button.hide()
	if crate_logic != null and is_instance_valid(crate_logic.button):
		crate_logic.button.hide()
	for node_path in [
		"Background",
		"RoomBackground",
		"RoomVignette",
		"GameLayer",
		"HudWallet",
		"MenuButton",
		"UpgradeAlertBadge",
		"ClickPopupLayer",
	]:
		var main_control := get_node_or_null(node_path) as Control
		if main_control != null:
			telegram_main_transition_nodes.append(main_control)
	if random_event_logic != null and is_instance_valid(random_event_logic.layer):
		telegram_main_transition_nodes.append(random_event_logic.layer)


func _on_telegram_layout_metrics_changed(top_height: float, bottom_height: float) -> void:
	telegram_top_height = top_height
	telegram_bottom_height = bottom_height
	if is_instance_valid(telegram_pager_host):
		telegram_pager_host.offset_top = telegram_top_height
		telegram_pager_host.offset_bottom = -telegram_bottom_height
	var game_layer := get_node_or_null("GameLayer") as MarginContainer
	if game_layer != null:
		game_layer.add_theme_constant_override("margin_top", roundi(telegram_top_height + 12.0))
		game_layer.add_theme_constant_override("margin_bottom", roundi(telegram_bottom_height + 14.0))
	if is_instance_valid(menu_panel):
		_layout_pause_popup()
	if is_instance_valid(settings_shell):
		_layout_settings_shell()
	if is_instance_valid(pause_detail_shell):
		_layout_pause_detail_shell()


func _build_settings_shell() -> void:
	settings_shell = ColorRect.new()
	settings_shell.name = "SettingsShell"
	settings_shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	settings_shell.color = NORMAL_SHELL_BACKGROUND
	settings_shell.mouse_filter = Control.MOUSE_FILTER_STOP
	settings_shell.z_index = 80
	settings_shell.hide()
	add_child(settings_shell)

	settings_action_bar = PanelContainer.new()
	settings_action_bar.name = "SettingsActionBar"
	settings_action_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	settings_action_bar.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(NORMAL_SHELL_SURFACE, Color(1.0, 1.0, 1.0, 0.1), 0, 1, -1, 4)
	)
	settings_shell.add_child(settings_action_bar)
	settings_action_safe_margin = MarginContainer.new()
	settings_action_bar.add_child(settings_action_safe_margin)
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 4)
	settings_action_safe_margin.add_child(action_row)
	var back := Button.new()
	back.name = "SettingsShellBackButton"
	back.text = "\u2190"
	back.custom_minimum_size = Vector2(64.0, 64.0)
	back.flat = false
	back.focus_mode = Control.FOCUS_NONE
	back.add_theme_font_size_override("font_size", 30)
	_style_upgrade_button(back, CLICK_UPGRADE_COLOR)
	back.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	back.pressed.connect(_close_settings_shell)
	action_row.add_child(back)
	var action_title := Label.new()
	action_title.name = "SettingsShellTitle"
	action_title.text = "Settings"
	action_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	action_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	action_title.add_theme_font_size_override("font_size", 26)
	action_title.add_theme_color_override("font_color", NORMAL_SHELL_TEXT)
	action_row.add_child(action_title)
	var action_spacer := Control.new()
	action_spacer.custom_minimum_size.x = 16.0
	action_row.add_child(action_spacer)

	settings_tabs_bar = PanelContainer.new()
	settings_tabs_bar.name = "SettingsTabsBar"
	settings_tabs_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	settings_tabs_bar.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(NORMAL_SHELL_RAISED, Color(1.0, 1.0, 1.0, 0.08), 0, 1, -1, 2)
	)
	settings_shell.add_child(settings_tabs_bar)
	var tabs_layer := Control.new()
	tabs_layer.name = "SettingsTabsLayer"
	tabs_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	settings_tabs_bar.add_child(tabs_layer)
	settings_tab_indicator = PanelContainer.new()
	settings_tab_indicator.name = "SettingsTabIndicator"
	settings_tab_indicator.position.y = 13.0
	settings_tab_indicator.size = Vector2(96.0, 34.0)
	settings_tab_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	settings_tab_indicator.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(
			Color(CLICK_UPGRADE_COLOR.r, CLICK_UPGRADE_COLOR.g, CLICK_UPGRADE_COLOR.b, 0.2),
			Color(CLICK_UPGRADE_COLOR.r, CLICK_UPGRADE_COLOR.g, CLICK_UPGRADE_COLOR.b, 0.58),
			17,
			1,
			-1,
			3
		)
	)
	tabs_layer.add_child(settings_tab_indicator)
	settings_tabs_scroll = ScrollContainer.new()
	settings_tabs_scroll.name = "SettingsTabsScroll"
	settings_tabs_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	settings_tabs_scroll.offset_left = 8.0
	settings_tabs_scroll.offset_right = -8.0
	settings_tabs_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	settings_tabs_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	settings_tabs_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	tabs_layer.add_child(settings_tabs_scroll)
	settings_tabs_row = HBoxContainer.new()
	settings_tabs_row.name = "SettingsTabRow"
	settings_tabs_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	settings_tabs_row.add_theme_constant_override("separation", 2)
	settings_tabs_scroll.add_child(settings_tabs_row)
	settings_tabs_scroll.get_h_scroll_bar().value_changed.connect(_on_settings_tabs_scrolled)
	for index in SETTINGS_PAGE_LABELS.size():
		var tab := Button.new()
		tab.text = SETTINGS_PAGE_LABELS[index]
		tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab.custom_minimum_size.y = 60.0
		tab.flat = false
		tab.focus_mode = Control.FOCUS_NONE
		tab.add_theme_font_size_override("font_size", 20)
		tab.add_theme_color_override("font_color", NORMAL_SHELL_MUTED)
		tab.add_theme_color_override("font_hover_color", Color.WHITE)
		tab.add_theme_stylebox_override("normal", _make_upgrade_style(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 12, 0))
		tab.add_theme_stylebox_override(
			"hover",
			_make_upgrade_style(Color(CLICK_UPGRADE_COLOR.r, CLICK_UPGRADE_COLOR.g, CLICK_UPGRADE_COLOR.b, 0.12), Color(CLICK_UPGRADE_COLOR.r, CLICK_UPGRADE_COLOR.g, CLICK_UPGRADE_COLOR.b, 0.26), 12, 1)
		)
		tab.add_theme_stylebox_override(
			"pressed",
			_make_upgrade_style(Color(CLICK_UPGRADE_COLOR.r, CLICK_UPGRADE_COLOR.g, CLICK_UPGRADE_COLOR.b, 0.22), Color(CLICK_UPGRADE_COLOR.r, CLICK_UPGRADE_COLOR.g, CLICK_UPGRADE_COLOR.b, 0.42), 12, 1)
		)
		tab.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		tab.pressed.connect(_show_settings_page.bind(index, true))
		settings_tabs_row.add_child(tab)
		settings_tab_buttons.append(tab)

	settings_pager_host = Control.new()
	settings_pager_host.name = "SettingsPagerHost"
	settings_pager_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	settings_pager_host.clip_contents = true
	settings_pager_host.mouse_filter = Control.MOUSE_FILTER_PASS
	settings_shell.add_child(settings_pager_host)
	for index in SETTINGS_PAGE_LABELS.size():
		var page := Control.new()
		page.name = "%sSettingsPage" % SETTINGS_PAGE_LABELS[index]
		page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		page.mouse_filter = Control.MOUSE_FILTER_PASS
		page.visible = index == 0
		settings_pager_host.add_child(page)
		settings_pages.append(page)
		var scroll := ScrollContainer.new()
		scroll.name = "SettingsPageScroll"
		scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		scroll.scroll_deadzone = 8
		scroll.follow_focus = true
		page.add_child(scroll)
		var page_margin := MarginContainer.new()
		page_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_set_telegram_margins(page_margin, 20, 16, 20, 28)
		scroll.add_child(page_margin)
		settings_page_margins.append(page_margin)
		var content := VBoxContainer.new()
		content.name = "SettingsPageContent"
		content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		content.add_theme_constant_override("separation", 12)
		page_margin.add_child(content)
		settings_page_contents.append(content)

	_add_settings_page_intro(settings_page_contents[0], "GENERAL", "Game account, tutorial and progression shortcuts")
	_add_settings_page_intro(settings_page_contents[1], "PERFORMANCE", "Rendering and effects tuned for this device")
	_add_settings_page_intro(settings_page_contents[2], "AUDIO", "Sound levels and interface feedback")
	_add_settings_page_intro(settings_page_contents[3], "CONTROLS", "Touch feedback and game events")
	settings_header.hide()
	_build_settings_general_group()
	if is_instance_valid(performance_settings_card):
		performance_settings_card.reparent(settings_page_contents[1])
		performance_settings_card.show()
	if is_instance_valid(audio_settings_card):
		audio_settings_card.reparent(settings_page_contents[2])
		audio_settings_card.show()
	if is_instance_valid(touch_settings_card):
		touch_settings_card.reparent(settings_page_contents[3])
		touch_settings_card.show()
	settings_panel.hide()
	_layout_settings_shell()
	call_deferred("_show_settings_page", 0, false)


func _add_settings_page_intro(parent: VBoxContainer, title_text: String, description: String) -> void:
	var header := Label.new()
	header.text = title_text
	header.custom_minimum_size.y = 40.0
	header.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 20)
	header.add_theme_color_override("font_color", CLICK_UPGRADE_COLOR.lightened(0.18))
	parent.add_child(header)
	var caption := Label.new()
	caption.text = description
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.add_theme_font_size_override("font_size", 18)
	caption.add_theme_color_override("font_color", NORMAL_SHELL_MUTED)
	parent.add_child(caption)


func _build_settings_general_group() -> void:
	settings_general_group = PanelContainer.new()
	settings_general_group.name = "SettingsGeneralGroup"
	settings_general_group.clip_contents = true
	settings_general_group.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	settings_page_contents[0].add_child(settings_general_group)
	var rows := VBoxContainer.new()
	rows.name = "SettingsGeneralRows"
	rows.add_theme_constant_override("separation", 0)
	settings_general_group.add_child(rows)

	settings_wallet.reparent(rows)
	settings_wallet.show()
	var wallet_row := settings_wallet.find_child("WalletRow", true, false) as HBoxContainer
	if wallet_row != null:
		wallet_row.alignment = BoxContainer.ALIGNMENT_BEGIN
		wallet_row.custom_minimum_size.y = 64.0
		var wallet_title := Label.new()
		wallet_title.name = "SettingsWalletTitle"
		wallet_title.text = "Kibbles"
		wallet_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		wallet_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		wallet_title.add_theme_font_size_override("font_size", 20)
		wallet_row.add_child(wallet_title)
		wallet_row.move_child(wallet_title, 1)
		menu_coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		menu_coins_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	rows.add_child(_create_settings_row_separator())
	abbreviate_numbers_check_box = _create_settings_check("Abbreviate numbers (1K, 1M, ...)", CLICK_UPGRADE_COLOR)
	abbreviate_numbers_check_box.set_pressed_no_signal(abbreviate_numbers)
	abbreviate_numbers_check_box.toggled.connect(_on_abbreviate_numbers_toggled)
	rows.add_child(abbreviate_numbers_check_box)
	rows.add_child(_create_settings_row_separator())
	var number_detail_block := VBoxContainer.new()
	number_detail_block.add_theme_constant_override("separation", 0)
	var number_detail_row := HBoxContainer.new()
	number_detail_row.custom_minimum_size.y = 48.0
	var number_detail_title := Label.new()
	number_detail_title.text = "Number detail"
	number_detail_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	number_detail_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	number_detail_title.add_theme_font_size_override("font_size", 18)
	number_detail_row.add_child(number_detail_title)
	number_detail_value_label = Label.new()
	number_detail_value_label.text = "%d digits" % number_detail_digits
	number_detail_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	number_detail_value_label.add_theme_color_override("font_color", CLICK_UPGRADE_COLOR.lightened(0.18))
	number_detail_row.add_child(number_detail_value_label)
	number_detail_block.add_child(number_detail_row)
	number_detail_slider = HSlider.new()
	number_detail_slider.min_value = MIN_NUMBER_DETAIL_DIGITS
	number_detail_slider.max_value = MAX_NUMBER_DETAIL_DIGITS
	number_detail_slider.step = 1
	number_detail_slider.value = number_detail_digits
	number_detail_slider.value_changed.connect(_on_number_detail_changed)
	_style_settings_slider(number_detail_slider, CLICK_UPGRADE_COLOR)
	number_detail_block.add_child(number_detail_slider)
	rows.add_child(number_detail_block)
	rows.add_child(_create_settings_row_separator())
	exact_number_tooltips_check_box = _create_settings_check("Show exact number tooltips", CLICK_UPGRADE_COLOR)
	exact_number_tooltips_check_box.set_pressed_no_signal(exact_number_tooltips)
	exact_number_tooltips_check_box.toggled.connect(_on_exact_number_tooltips_toggled)
	rows.add_child(exact_number_tooltips_check_box)
	rows.add_child(_create_settings_row_separator())
	group_full_numbers_check_box = _create_settings_check("Group full numbers (1,000)", CLICK_UPGRADE_COLOR)
	group_full_numbers_check_box.set_pressed_no_signal(group_full_numbers)
	group_full_numbers_check_box.toggled.connect(_on_group_full_numbers_toggled)
	rows.add_child(group_full_numbers_check_box)
	rows.add_child(_create_settings_row_separator())

	tutorial_replay_button.reparent(rows)
	tutorial_replay_button.show()
	tutorial_replay_button.text = "Replay tutorial"
	tutorial_replay_button.icon = load("res://assets/ui/navigation/settings_tutorial.svg") as Texture2D
	rows.add_child(_create_settings_row_separator())

	open_upgrades_button.reparent(rows)
	open_upgrades_button.show()
	open_upgrades_button.text = "Upgrades"
	open_upgrades_button.icon = load("res://assets/ui/navigation/settings_upgrades.svg") as Texture2D
	_style_settings_general_group()


func _create_settings_row_separator(left_margin: int = 58) -> MarginContainer:
	var separator_margin := MarginContainer.new()
	separator_margin.name = "SettingsRowSeparator"
	separator_margin.custom_minimum_size.y = 1.0
	separator_margin.add_theme_constant_override("margin_left", left_margin)
	var separator := ColorRect.new()
	separator.color = Color(1.0, 1.0, 1.0, 0.09)
	separator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	separator_margin.add_child(separator)
	return separator_margin


func _style_settings_general_group() -> void:
	if not is_instance_valid(settings_general_group):
		return
	settings_general_group.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(NORMAL_SHELL_SURFACE, Color(NORMAL_SHELL_GOLD.r, NORMAL_SHELL_GOLD.g, NORMAL_SHELL_GOLD.b, 0.18), 18, 1, -1, 3)
	)
	settings_wallet.custom_minimum_size.y = 64.0
	settings_wallet.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.11, 0.085, 0.035, 0.72), Color(NORMAL_SHELL_GOLD.r, NORMAL_SHELL_GOLD.g, NORMAL_SHELL_GOLD.b, 0.28), 16, 1, -1, 2)
	)
	var wallet_margin := settings_wallet.find_child("WalletMargin", true, false) as MarginContainer
	if wallet_margin != null:
		_set_telegram_margins(wallet_margin, 16, 4, 16, 4)
	var wallet_title := settings_wallet.find_child("SettingsWalletTitle", true, false) as Label
	if wallet_title != null:
		wallet_title.add_theme_color_override("font_color", NORMAL_SHELL_TEXT)
	var settings_coin_icon := settings_wallet.find_child("SettingsCoinIcon", true, false) as TextureRect
	if settings_coin_icon != null:
		settings_coin_icon.custom_minimum_size = Vector2(28.0, 28.0)
	menu_coins_label.add_theme_font_size_override("font_size", 20)
	menu_coins_label.add_theme_color_override("font_color", NORMAL_SHELL_GOLD.lightened(0.16))
	for row_button in [tutorial_replay_button, open_upgrades_button]:
		if not is_instance_valid(row_button):
			continue
		var accent := CLICK_UPGRADE_COLOR if row_button == tutorial_replay_button else CHANCE_UPGRADE_COLOR
		row_button.custom_minimum_size.y = 64.0
		row_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		row_button.expand_icon = true
		row_button.add_theme_constant_override("icon_max_width", 28)
		row_button.add_theme_constant_override("h_separation", 16)
		row_button.add_theme_font_size_override("font_size", 20)
		_style_upgrade_button(row_button, accent)
		row_button.add_theme_color_override("icon_normal_color", accent.lightened(0.12))
		row_button.add_theme_color_override("icon_hover_color", accent.lightened(0.28))
		row_button.add_theme_color_override("icon_pressed_color", Color.WHITE)
		row_button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


func _layout_settings_shell() -> void:
	if not is_instance_valid(settings_shell):
		return
	var tabs_height := 60.0
	var base_action_height := 72.0
	var base_bottom_height := 78.0
	var safe_top := 0.0
	if is_instance_valid(telegram_navigation):
		tabs_height = telegram_navigation.FILTER_TABS_HEIGHT
		base_action_height = telegram_navigation.ACTION_BAR_PORTRAIT
		base_bottom_height = telegram_navigation.BOTTOM_BAR_HEIGHT
		if telegram_navigation.has_method("get_safe_top"):
			safe_top = float(telegram_navigation.call("get_safe_top"))
	var action_height := base_action_height + safe_top
	var safe_bottom := maxf(0.0, telegram_bottom_height - base_bottom_height)
	settings_action_bar.offset_bottom = action_height
	settings_action_safe_margin.add_theme_constant_override("margin_top", roundi(safe_top))
	settings_tabs_bar.offset_top = action_height
	settings_tabs_bar.offset_bottom = action_height + tabs_height
	settings_pager_host.offset_top = action_height + tabs_height
	var viewport_width := get_viewport_rect().size.x
	var horizontal_margin := 14 if viewport_width < 440.0 else (20 if viewport_width < 720.0 else 24)
	for page_margin in settings_page_margins:
		_set_telegram_margins(page_margin, horizontal_margin, 16, horizontal_margin, 28)
	for tab in settings_tab_buttons:
		tab.custom_minimum_size.y = tabs_height
	_layout_settings_tabs(viewport_width)
	settings_tab_indicator.position.y = (tabs_height - 34.0) * 0.5
	settings_tab_indicator.size.y = 34.0
	settings_pager_host.offset_bottom = -safe_bottom
	call_deferred("_move_settings_tab_indicator", settings_current_page, false)


func _layout_settings_tabs(viewport_width: float) -> void:
	if not is_instance_valid(settings_tabs_row) or settings_tab_buttons.is_empty():
		return
	var compact := viewport_width < 520.0
	var natural_widths: Array[float] = []
	var natural_total := 0.0
	for tab in settings_tab_buttons:
		tab.add_theme_font_size_override("font_size", 16 if compact else 20)
		var font := tab.get_theme_font("font")
		var text_width := font.get_string_size(
			tab.text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1.0,
			tab.get_theme_font_size("font_size")
		).x
		var natural_width := maxf(64.0 if compact else 72.0, text_width + (24.0 if compact else 30.0))
		natural_widths.append(natural_width)
		natural_total += natural_width
	var separation_total := float(settings_tab_buttons.size() - 1) * 2.0
	var available_width := maxf(0.0, viewport_width - 16.0 - separation_total)
	var extra_per_tab := maxf(0.0, available_width - natural_total) / float(settings_tab_buttons.size())
	for index in settings_tab_buttons.size():
		settings_tab_buttons[index].custom_minimum_size.x = natural_widths[index] + extra_per_tab
	settings_tabs_row.custom_minimum_size.x = maxf(available_width, natural_total + separation_total)


func _on_settings_tabs_scrolled(_value: float) -> void:
	if is_instance_valid(settings_shell) and settings_shell.visible:
		call_deferred("_move_settings_tab_indicator", settings_current_page, false)


func _show_settings_shell() -> void:
	if not is_instance_valid(settings_shell):
		return
	_apply_telegram_settings_style()
	_show_settings_page(0, false)
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_interaction_enabled(false)
	if settings_shell_tween != null and settings_shell_tween.is_valid():
		settings_shell_tween.kill()
	var width := get_viewport_rect().size.x
	settings_shell.position = Vector2(width, 0.0)
	settings_shell.modulate = Color.WHITE
	settings_shell.show()
	call_deferred("_animate_settings_page_content", settings_current_page)
	if reduce_motion_enabled:
		settings_shell.position = Vector2.ZERO
		return
	settings_shell_tween = create_tween()
	settings_shell_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	settings_shell_tween.tween_property(settings_shell, "position:x", 0.0, 0.26)


func _close_settings_shell() -> void:
	if not is_instance_valid(settings_shell) or not settings_shell.visible:
		return
	if settings_back_to_pause and not pause_popup_open:
		_show_pause_popup()
	if settings_shell_tween != null and settings_shell_tween.is_valid():
		settings_shell_tween.kill()
	if reduce_motion_enabled:
		_finish_close_settings_shell()
		return
	settings_shell_tween = create_tween()
	settings_shell_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	settings_shell_tween.tween_property(settings_shell, "position:x", get_viewport_rect().size.x, 0.22)
	settings_shell_tween.tween_callback(_finish_close_settings_shell)


func _finish_close_settings_shell() -> void:
	settings_shell.hide()
	settings_shell.position = Vector2.ZERO
	if is_instance_valid(telegram_navigation) and not pause_popup_open:
		telegram_navigation.set_interaction_enabled(true)


func _hide_settings_shell_immediate() -> void:
	if not is_instance_valid(settings_shell):
		return
	if settings_shell_tween != null and settings_shell_tween.is_valid():
		settings_shell_tween.kill()
	settings_shell.hide()
	settings_shell.position = Vector2.ZERO
	if is_instance_valid(telegram_navigation) and not pause_popup_open:
		telegram_navigation.set_interaction_enabled(true)


func _build_pause_detail_shell() -> void:
	_unwrap_pause_detail_panel(achievements_panel)
	pause_detail_shell = ColorRect.new()
	pause_detail_shell.name = "PauseDetailShell"
	pause_detail_shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_detail_shell.color = NORMAL_SHELL_BACKGROUND
	pause_detail_shell.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_detail_shell.z_index = 80
	pause_detail_shell.hide()
	add_child(pause_detail_shell)

	pause_detail_action_bar = PanelContainer.new()
	pause_detail_action_bar.name = "PauseDetailActionBar"
	pause_detail_action_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	var action_style := _make_upgrade_style(NORMAL_SHELL_SURFACE, Color(1.0, 1.0, 1.0, 0.1), 0, 1, -1, 4)
	action_style.border_width_bottom = 1
	action_style.border_width_left = 0
	action_style.border_width_right = 0
	action_style.border_width_top = 0
	pause_detail_action_bar.add_theme_stylebox_override("panel", action_style)
	pause_detail_shell.add_child(pause_detail_action_bar)
	pause_detail_action_safe_margin = MarginContainer.new()
	pause_detail_action_bar.add_child(pause_detail_action_safe_margin)
	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 4)
	pause_detail_action_safe_margin.add_child(action_row)
	var back := Button.new()
	back.name = "PauseDetailBackButton"
	back.text = "\u2190"
	back.custom_minimum_size = Vector2(64.0, 64.0)
	back.focus_mode = Control.FOCUS_NONE
	back.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	back.add_theme_font_size_override("font_size", 30)
	_style_upgrade_button(back, Color(0.62, 0.48, 1.0, 1.0))
	back.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	back.pressed.connect(_close_pause_detail_shell)
	action_row.add_child(back)
	pause_detail_title = Label.new()
	pause_detail_title.name = "PauseDetailTitle"
	pause_detail_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pause_detail_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	pause_detail_title.add_theme_font_size_override("font_size", 26)
	pause_detail_title.add_theme_color_override("font_color", NORMAL_SHELL_TEXT)
	action_row.add_child(pause_detail_title)
	var spacer := Control.new()
	spacer.custom_minimum_size.x = 16.0
	action_row.add_child(spacer)

	pause_detail_host = Control.new()
	pause_detail_host.name = "PauseDetailHost"
	pause_detail_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_detail_host.clip_contents = true
	pause_detail_host.mouse_filter = Control.MOUSE_FILTER_PASS
	pause_detail_shell.add_child(pause_detail_host)
	_layout_pause_detail_shell()


func _unwrap_pause_detail_panel(panel: PanelContainer) -> void:
	# Achievements was historically wrapped in an extra page-level scroller.
	# A Telegram fragment uses one full-height list instead, so remove that
	# wrapper and let ItemList own vertical scrolling.
	if panel.get_child_count() != 1 or not (panel.get_child(0) is ScrollContainer):
		return
	var wrapper := panel.get_child(0) as ScrollContainer
	if wrapper.get_child_count() != 1:
		return
	var content := wrapper.get_child(0)
	content.reparent(panel)
	if content is Control:
		var control := content as Control
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.size_flags_vertical = Control.SIZE_EXPAND_FILL
	wrapper.queue_free()


func _layout_pause_detail_shell() -> void:
	if not is_instance_valid(pause_detail_shell):
		return
	var tabs_height := 60.0
	var base_action_height := 72.0
	var base_bottom_height := 78.0
	var safe_top := 0.0
	if is_instance_valid(telegram_navigation):
		tabs_height = telegram_navigation.FILTER_TABS_HEIGHT
		base_action_height = telegram_navigation.ACTION_BAR_PORTRAIT
		base_bottom_height = telegram_navigation.BOTTOM_BAR_HEIGHT
		if telegram_navigation.has_method("get_safe_top"):
			safe_top = float(telegram_navigation.call("get_safe_top"))
	var action_height := base_action_height + safe_top
	var safe_bottom := maxf(0.0, telegram_bottom_height - base_bottom_height)
	pause_detail_action_bar.offset_bottom = action_height
	pause_detail_action_safe_margin.add_theme_constant_override("margin_top", roundi(safe_top))
	pause_detail_host.offset_top = action_height
	pause_detail_host.offset_bottom = -safe_bottom


func _show_pause_detail(panel: Control, title_text: String) -> void:
	if not is_instance_valid(pause_detail_shell) or not is_instance_valid(panel):
		return
	pause_detail_back_to_pause = pause_popup_open
	if pause_popup_open:
		_hide_pause_popup(false, true)
	if pause_detail_tween != null and pause_detail_tween.is_valid():
		pause_detail_tween.kill()
	if is_instance_valid(pause_detail_current) and pause_detail_current != panel:
		pause_detail_current.hide()
	if panel.get_parent() != pause_detail_host:
		panel.reparent(pause_detail_host)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.custom_minimum_size = Vector2.ZERO
	panel.position = Vector2.ZERO
	panel.modulate = Color.WHITE
	panel.show()
	pause_detail_current = panel
	pause_detail_title.text = title_text
	_apply_telegram_page_style(panel)
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_interaction_enabled(false)
	var width := get_viewport_rect().size.x
	pause_detail_shell.position = Vector2(width, 0.0)
	pause_detail_shell.show()
	pause_detail_tween = create_tween()
	pause_detail_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	pause_detail_tween.tween_property(pause_detail_shell, "position:x", 0.0, 0.26)


func _close_pause_detail_shell() -> void:
	if not is_instance_valid(pause_detail_shell) or not pause_detail_shell.visible:
		return
	if pause_detail_back_to_pause and not pause_popup_open:
		_show_pause_popup()
	if pause_detail_tween != null and pause_detail_tween.is_valid():
		pause_detail_tween.kill()
	pause_detail_tween = create_tween()
	pause_detail_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	pause_detail_tween.tween_property(pause_detail_shell, "position:x", get_viewport_rect().size.x, 0.22)
	pause_detail_tween.tween_callback(_finish_close_pause_detail_shell)


func _finish_close_pause_detail_shell() -> void:
	pause_detail_shell.hide()
	pause_detail_shell.position = Vector2.ZERO
	if is_instance_valid(pause_detail_current):
		pause_detail_current.hide()
	if is_instance_valid(telegram_navigation) and not pause_popup_open and (not is_instance_valid(settings_shell) or not settings_shell.visible):
		telegram_navigation.set_interaction_enabled(true)


func _hide_pause_detail_shell_immediate() -> void:
	if not is_instance_valid(pause_detail_shell):
		return
	if pause_detail_tween != null and pause_detail_tween.is_valid():
		pause_detail_tween.kill()
	pause_detail_shell.hide()
	pause_detail_shell.position = Vector2.ZERO
	if is_instance_valid(pause_detail_current):
		pause_detail_current.hide()
	if is_instance_valid(telegram_navigation) and not pause_popup_open and (not is_instance_valid(settings_shell) or not settings_shell.visible):
		telegram_navigation.set_interaction_enabled(true)


func _show_settings_page(index: int, animated := true) -> void:
	if settings_pages.is_empty():
		return
	index = clampi(index, 0, settings_pages.size() - 1)
	animated = animated and not reduce_motion_enabled
	if settings_swipe_dragging:
		_reset_settings_drag()
	if settings_page_tween != null and settings_page_tween.is_valid():
		settings_page_tween.kill()
	for page_index in settings_pages.size():
		settings_pages[page_index].position = Vector2.ZERO
		settings_pages[page_index].visible = page_index == settings_current_page
	var outgoing := settings_pages[settings_current_page]
	var incoming := settings_pages[index]
	var direction := signi(index - settings_current_page)
	settings_current_page = index
	_update_settings_tab_states()
	if is_instance_valid(settings_tabs_scroll):
		settings_tabs_scroll.ensure_control_visible(settings_tab_buttons[index])
	call_deferred("_move_settings_tab_indicator", index, animated)
	var scroll := incoming.find_child("SettingsPageScroll", true, false) as ScrollContainer
	if scroll != null:
		scroll.scroll_vertical = 0
	if outgoing == incoming or not animated or direction == 0:
		for page_index in settings_pages.size():
			settings_pages[page_index].visible = page_index == index
		incoming.position = Vector2.ZERO
		if animated:
			call_deferred("_animate_settings_page_content", index)
		return
	var width := maxf(settings_pager_host.size.x, get_viewport_rect().size.x)
	outgoing.show()
	incoming.position.x = float(direction) * width
	incoming.show()
	settings_page_tween = create_tween().set_parallel(true)
	settings_page_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	settings_page_tween.tween_property(outgoing, "position:x", -float(direction) * width, 0.28)
	settings_page_tween.tween_property(incoming, "position:x", 0.0, 0.28)
	settings_page_tween.chain().tween_callback(_finish_settings_page_transition.bind(index))


func _finish_settings_page_transition(index: int) -> void:
	for page_index in settings_pages.size():
		settings_pages[page_index].visible = page_index == index
		settings_pages[page_index].position = Vector2.ZERO
	_animate_settings_page_content(index)


func _animate_settings_page_content(index: int) -> void:
	if reduce_motion_enabled or index < 0 or index >= settings_page_contents.size():
		return
	var content := settings_page_contents[index]
	if not is_instance_valid(content) or not content.is_visible_in_tree():
		return
	var old_tween: Tween
	if content.has_meta("settings_entrance_tween"):
		old_tween = content.get_meta("settings_entrance_tween") as Tween
	if old_tween != null and old_tween.is_valid():
		old_tween.kill()
	content.pivot_offset = Vector2(content.size.x * 0.5, 0.0)
	content.scale = Vector2(0.985, 0.985)
	content.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween := create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(content, "scale", Vector2.ONE, 0.24)
	tween.tween_property(content, "modulate:a", 1.0, 0.2)
	content.set_meta("settings_entrance_tween", tween)


func _update_settings_tab_states() -> void:
	for index in settings_tab_buttons.size():
		var active := index == settings_current_page
		settings_tab_buttons[index].add_theme_color_override("font_color", CLICK_UPGRADE_COLOR.lightened(0.18) if active else NORMAL_SHELL_MUTED)
		settings_tab_buttons[index].add_theme_color_override("font_hover_color", CLICK_UPGRADE_COLOR.lightened(0.3) if active else Color.WHITE)


func _move_settings_tab_indicator(index: int, animated := true) -> void:
	if index < 0 or index >= settings_tab_buttons.size() or not is_instance_valid(settings_tab_indicator):
		return
	var geometry := _get_settings_tab_indicator_geometry(index)
	var target_x := geometry.x
	var target_width := geometry.y
	if animated:
		var indicator_tween := create_tween().set_parallel(true)
		indicator_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		indicator_tween.tween_property(settings_tab_indicator, "position:x", target_x, 0.24)
		indicator_tween.tween_property(settings_tab_indicator, "size:x", target_width, 0.24)
	else:
		settings_tab_indicator.position.x = target_x
		settings_tab_indicator.size.x = target_width


func _get_settings_tab_indicator_geometry(index: int) -> Vector2:
	var button := settings_tab_buttons[index]
	var font := button.get_theme_font("font")
	var text_width := font.get_string_size(
		button.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		button.get_theme_font_size("font_size")
	).x
	var target_width := maxf(44.0, text_width + 28.0)
	var target_x: float = button.global_position.x - (settings_tab_indicator.get_parent() as Control).global_position.x + (button.size.x - target_width) * 0.5
	return Vector2(target_x, target_width)


func _move_settings_tab_indicator_progress(from_index: int, to_index: int, progress: float) -> void:
	if not is_instance_valid(settings_tab_indicator):
		return
	var from_geometry := _get_settings_tab_indicator_geometry(from_index)
	var to_geometry := _get_settings_tab_indicator_geometry(to_index)
	progress = clampf(progress, 0.0, 1.0)
	settings_tab_indicator.position.x = lerpf(from_geometry.x, to_geometry.x, progress)
	settings_tab_indicator.size.x = lerpf(from_geometry.y, to_geometry.y, progress)


func _handle_settings_shell_swipe(event: InputEvent) -> bool:
	if not menu_swipe_enabled:
		if settings_swipe_tracking or settings_swipe_dragging:
			_reset_settings_drag()
		return false
	if event is InputEventScreenTouch:
		if event.pressed:
			settings_swipe_start = event.position
			settings_swipe_tracking = event.position.y >= telegram_top_height and _get_slider_at_position(event.position) == null
			settings_swipe_dragging = false
			settings_swipe_velocity_x = 0.0
			return false
		if settings_swipe_tracking:
			settings_swipe_tracking = false
			if settings_swipe_dragging:
				_settle_settings_drag()
				return true
			return false
	elif event is InputEventScreenDrag and settings_swipe_tracking:
		var delta: Vector2 = event.position - settings_swipe_start
		settings_swipe_velocity_x = event.velocity.x
		return _update_settings_drag(delta)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			settings_swipe_start = event.position
			settings_swipe_tracking = event.position.y >= telegram_top_height and _get_slider_at_position(event.position) == null
			settings_swipe_dragging = false
			settings_swipe_velocity_x = 0.0
			return false
		if settings_swipe_tracking:
			settings_swipe_tracking = false
			if settings_swipe_dragging:
				_settle_settings_drag()
				return true
			return false
	elif event is InputEventMouseMotion and settings_swipe_tracking and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var delta: Vector2 = event.position - settings_swipe_start
		settings_swipe_velocity_x = event.velocity.x
		return _update_settings_drag(delta)
	return false


func _update_settings_drag(delta: Vector2) -> bool:
	if not settings_swipe_dragging:
		if absf(delta.x) < 16.0 or absf(delta.x) <= absf(delta.y):
			return false
		_begin_settings_drag(1 if delta.x < 0.0 else -1)
	var width := maxf(settings_pager_host.size.x, get_viewport_rect().size.x)
	var drag_x := clampf(delta.x, -width, width)
	if settings_swipe_direction > 0:
		drag_x = minf(0.0, drag_x)
	else:
		drag_x = maxf(0.0, drag_x)
	if settings_swipe_neighbor < 0:
		drag_x *= 0.22
	settings_swipe_drag_x = drag_x
	var outgoing := settings_pages[settings_current_page]
	outgoing.position.x = drag_x
	if settings_swipe_neighbor >= 0:
		var incoming := settings_pages[settings_swipe_neighbor]
		incoming.position.x = drag_x + float(settings_swipe_direction) * width
		_move_settings_tab_indicator_progress(
			settings_current_page,
			settings_swipe_neighbor,
			absf(drag_x) / width
		)
	return true


func _begin_settings_drag(direction: int) -> void:
	if settings_page_tween != null and settings_page_tween.is_valid():
		settings_page_tween.kill()
	settings_swipe_dragging = true
	settings_swipe_direction = direction
	settings_swipe_neighbor = settings_current_page + direction
	if settings_swipe_neighbor < 0 or settings_swipe_neighbor >= settings_pages.size():
		settings_swipe_neighbor = -1
	var outgoing := settings_pages[settings_current_page]
	outgoing.position = Vector2.ZERO
	outgoing.show()
	if settings_swipe_neighbor >= 0:
		var width := maxf(settings_pager_host.size.x, get_viewport_rect().size.x)
		var incoming := settings_pages[settings_swipe_neighbor]
		incoming.position = Vector2(float(direction) * width, 0.0)
		incoming.show()


func _settle_settings_drag() -> void:
	if not settings_swipe_dragging:
		return
	var width := maxf(settings_pager_host.size.x, get_viewport_rect().size.x)
	var velocity_commits := (
		absf(settings_swipe_velocity_x) >= 900.0
		and signf(settings_swipe_velocity_x) == -float(settings_swipe_direction)
	)
	var commit := (
		settings_swipe_neighbor >= 0
		and (absf(settings_swipe_drag_x) >= width / 3.0 or velocity_commits)
	)
	var outgoing := settings_pages[settings_current_page]
	if settings_page_tween != null and settings_page_tween.is_valid():
		settings_page_tween.kill()
	settings_page_tween = create_tween().set_parallel(true)
	settings_page_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	if commit:
		var next_index := settings_swipe_neighbor
		var incoming := settings_pages[next_index]
		var remaining_ratio := 1.0 - absf(settings_swipe_drag_x) / width
		var duration := clampf(0.14 + remaining_ratio * 0.16, 0.14, 0.30)
		settings_current_page = next_index
		_update_settings_tab_states()
		if is_instance_valid(settings_tabs_scroll):
			settings_tabs_scroll.ensure_control_visible(settings_tab_buttons[next_index])
		settings_page_tween.tween_property(outgoing, "position:x", -float(settings_swipe_direction) * width, duration)
		settings_page_tween.tween_property(incoming, "position:x", 0.0, duration)
		settings_page_tween.tween_property(settings_tab_indicator, "position:x", _get_settings_tab_indicator_geometry(next_index).x, duration)
		settings_page_tween.tween_property(settings_tab_indicator, "size:x", _get_settings_tab_indicator_geometry(next_index).y, duration)
		settings_page_tween.chain().tween_callback(_finish_settings_drag.bind(next_index))
	else:
		var cancel_duration := clampf(0.14 + absf(settings_swipe_drag_x) / width * 0.12, 0.14, 0.26)
		settings_page_tween.tween_property(outgoing, "position:x", 0.0, cancel_duration)
		if settings_swipe_neighbor >= 0:
			var incoming := settings_pages[settings_swipe_neighbor]
			settings_page_tween.tween_property(incoming, "position:x", float(settings_swipe_direction) * width, cancel_duration)
		var current_geometry := _get_settings_tab_indicator_geometry(settings_current_page)
		settings_page_tween.tween_property(settings_tab_indicator, "position:x", current_geometry.x, cancel_duration)
		settings_page_tween.tween_property(settings_tab_indicator, "size:x", current_geometry.y, cancel_duration)
		settings_page_tween.chain().tween_callback(_cancel_settings_drag)


func _finish_settings_drag(index: int) -> void:
	_finish_settings_page_transition(index)
	_reset_settings_drag(false)
	call_deferred("_move_settings_tab_indicator", index, false)


func _cancel_settings_drag() -> void:
	_reset_settings_drag()
	_move_settings_tab_indicator(settings_current_page, false)


func _reset_settings_drag(hide_other_pages := true) -> void:
	settings_swipe_tracking = false
	settings_swipe_dragging = false
	settings_swipe_direction = 0
	settings_swipe_neighbor = -1
	settings_swipe_drag_x = 0.0
	settings_swipe_velocity_x = 0.0
	for page_index in settings_pages.size():
		settings_pages[page_index].position = Vector2.ZERO
		if hide_other_pages:
			settings_pages[page_index].visible = page_index == settings_current_page


func _show_pause_popup() -> void:
	if pause_popup_open:
		return
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_interaction_enabled(false)
		telegram_navigation.set_pause_active(true)
	_apply_telegram_pause_style()
	resume_button.hide()
	exit_button.hide()
	_layout_pause_popup()
	pause_popup_open = true
	pause_opened_over_page = (
		menu_overlay.visible
		and telegram_current_panel != null
		and telegram_current_panel.visible
	)
	if not pause_opened_over_page:
		menu_overlay.color = Color(0, 0, 0, 0)
		menu_overlay.show()
	pause_dim.modulate.a = 0.0
	pause_dim.show()
	menu_panel.modulate.a = 0.0
	menu_panel.scale = Vector2(0.96, 0.96)
	menu_panel.pivot_offset = menu_panel.size * 0.5
	menu_panel.show()
	if modal_transition_tween != null and modal_transition_tween.is_valid():
		modal_transition_tween.kill()
	modal_transition_tween = create_tween().set_parallel(true)
	modal_transition_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(pause_dim, "modulate:a", 1.0, 0.16)
	modal_transition_tween.tween_property(menu_panel, "modulate:a", 1.0, 0.18)
	modal_transition_tween.tween_property(menu_panel, "scale", Vector2.ONE, 0.22)


func _on_pause_dim_gui_input(event: InputEvent) -> void:
	var pressed_outside: bool = false
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		pressed_outside = mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed
	elif event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		pressed_outside = touch_event.pressed
	if not pressed_outside:
		return
	get_viewport().set_input_as_handled()
	_hide_pause_popup()


func _hide_pause_popup(play_sound := true, immediate := false) -> void:
	if not pause_popup_open:
		return
	pause_popup_open = false
	if play_sound:
		_play_ui_sound()
	if modal_transition_tween != null and modal_transition_tween.is_valid():
		modal_transition_tween.kill()
	if immediate:
		_finish_hide_pause_popup()
		return
	modal_transition_tween = create_tween().set_parallel(true)
	modal_transition_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	modal_transition_tween.tween_property(pause_dim, "modulate:a", 0.0, 0.14)
	modal_transition_tween.tween_property(menu_panel, "modulate:a", 0.0, 0.14)
	modal_transition_tween.tween_property(menu_panel, "scale", Vector2(0.97, 0.97), 0.16)
	modal_transition_tween.chain().tween_callback(_finish_hide_pause_popup)


func _finish_hide_pause_popup() -> void:
	pause_dim.hide()
	pause_dim.modulate.a = 1.0
	menu_panel.hide()
	menu_panel.modulate.a = 1.0
	menu_panel.scale = Vector2.ONE
	if not pause_opened_over_page:
		menu_overlay.hide()
	menu_overlay.color = NORMAL_SHELL_BACKGROUND
	pause_opened_over_page = false
	if is_instance_valid(telegram_navigation):
		telegram_navigation.set_pause_active(false)
	if is_instance_valid(telegram_navigation) and (not is_instance_valid(settings_shell) or not settings_shell.visible):
		telegram_navigation.set_interaction_enabled(true)


func _layout_pause_popup() -> void:
	if not is_instance_valid(menu_panel):
		return
	var viewport_size := get_viewport_rect().size
	var horizontal_margin := clampf(viewport_size.x * 0.065, 20.0, 48.0)
	if viewport_size.x < 360.0:
		horizontal_margin = 1.0
	var content_top := telegram_top_height + 12.0
	var content_bottom := viewport_size.y - telegram_bottom_height - 12.0
	var available_height := maxf(280.0, content_bottom - content_top)
	var popup_width := minf(520.0, viewport_size.x - horizontal_margin * 2.0)
	var desired_height := 610.0
	var menu_items := menu_panel.find_child("MenuItems", true, false) as VBoxContainer
	if menu_items != null:
		desired_height = clampf(menu_items.get_combined_minimum_size().y + 28.0, 480.0, 640.0)
	var popup_height := minf(desired_height, available_height)
	var popup_left := (viewport_size.x - popup_width) * 0.5
	var popup_top := content_top + (available_height - popup_height) * 0.5
	# Explicit top-left geometry is stable even if a pager tween finishes while
	# the modal is opening; it also keeps the dialog inside navigation insets.
	menu_panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	menu_panel.offset_left = popup_left
	menu_panel.offset_top = popup_top
	menu_panel.offset_right = popup_left + popup_width
	menu_panel.offset_bottom = popup_top + popup_height
	menu_panel.custom_minimum_size = Vector2.ZERO


func _on_telegram_destination_requested(destination: String, direction: int) -> void:
	if destination == "main":
		_sync_main_pause_button(destination)
		_hide_menu_from_navigation()
		telegram_navigation.set_destination(destination)
		return
	var panel := _prepare_telegram_destination(destination)
	if panel == null:
		return
	_sync_main_pause_button(destination)
	telegram_pending_direction = direction
	_show_overlay_panel(panel)
	telegram_navigation.set_destination(destination)
	_notify_telegram_destination(destination)


func _sync_main_pause_button(destination: String) -> void:
	if is_instance_valid(menu_button):
		menu_button.hide()
	if is_instance_valid(inventory_shop_bar):
		inventory_shop_bar.hide()


func _notify_telegram_destination(destination: String) -> void:
	match destination:
		"skins":
			_tutorial_notify("skins_opened")
		"missions":
			_tutorial_notify("missions_opened")
		"inventory":
			_tutorial_notify("inventory_opened")
		"shop":
			_tutorial_notify("shop_opened")
		"upgrades":
			_tutorial_notify("upgrades_opened")
		"boosts":
			_tutorial_notify("boosts_opened")


func _on_telegram_pager_drag_started(direction: int) -> void:
	if telegram_swipe_dragging:
		return
	_cancel_cat_press_for_navigation()
	if telegram_page_transition != null and telegram_page_transition.is_valid():
		telegram_page_transition.kill()
	_reset_telegram_main_positions()
	telegram_transition_serial += 1
	telegram_swipe_dragging = true
	telegram_swipe_direction = direction
	telegram_swipe_drag_x = 0.0
	telegram_swipe_velocity_x = 0.0
	var current_destination: String = telegram_navigation.current_destination
	var current_index: int = telegram_navigation.TOP_DESTINATIONS.find(current_destination)
	var neighbor_index: int = current_index + direction
	telegram_swipe_neighbor_destination = ""
	if current_index >= 0 and neighbor_index >= 0 and neighbor_index < telegram_navigation.TOP_DESTINATIONS.size():
		telegram_swipe_neighbor_destination = telegram_navigation.TOP_DESTINATIONS[neighbor_index]
	telegram_swipe_outgoing_panel = null if current_destination == "main" else telegram_current_panel
	telegram_swipe_incoming_panel = null
	if not telegram_swipe_neighbor_destination.is_empty() and telegram_swipe_neighbor_destination != "main":
		telegram_swipe_incoming_panel = _prepare_telegram_destination(telegram_swipe_neighbor_destination, false)

	for candidate in _get_overlay_panels():
		if candidate == menu_panel:
			continue
		if candidate != telegram_swipe_outgoing_panel and candidate != telegram_swipe_incoming_panel:
			candidate.hide()
	if is_instance_valid(telegram_swipe_outgoing_panel):
		telegram_swipe_outgoing_panel.position = Vector2.ZERO
		telegram_swipe_outgoing_panel.modulate = Color.WHITE
		telegram_swipe_outgoing_panel.show()
	if is_instance_valid(telegram_swipe_incoming_panel):
		var width := maxf(telegram_pager_host.size.x, get_viewport_rect().size.x)
		telegram_swipe_incoming_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		telegram_swipe_incoming_panel.position = Vector2(float(direction) * width, 0.0)
		telegram_swipe_incoming_panel.modulate = Color.WHITE
		telegram_swipe_incoming_panel.show()

	var main_is_involved := current_destination == "main" or telegram_swipe_neighbor_destination == "main"
	if main_is_involved:
		_capture_telegram_main_positions()
	if not telegram_swipe_neighbor_destination.is_empty() and (current_destination != "main" or telegram_swipe_neighbor_destination != "main"):
		if not menu_overlay.visible and combo_timer != null:
			combo_was_running_before_overlay = not combo_timer.is_stopped()
			combo_time_left_before_overlay = combo_timer.time_left
			if combo_was_running_before_overlay:
				combo_timer.stop()
			menu_time_pause_started = Time.get_unix_time_from_system()
		menu_overlay.color = Color(0, 0, 0, 0)
		menu_overlay.modulate = Color.WHITE
		menu_overlay.show()


func _on_telegram_pager_dragged(delta_x: float, velocity_x: float, direction: int) -> void:
	if not telegram_swipe_dragging or direction != telegram_swipe_direction:
		return
	var width := maxf(telegram_pager_host.size.x, get_viewport_rect().size.x)
	var drag_x := clampf(delta_x, -width, width)
	if direction > 0:
		drag_x = minf(0.0, drag_x)
	else:
		drag_x = maxf(0.0, drag_x)
	if telegram_swipe_neighbor_destination.is_empty():
		drag_x *= 0.22
	telegram_swipe_drag_x = drag_x
	telegram_swipe_velocity_x = velocity_x
	var current_destination: String = telegram_navigation.current_destination
	if current_destination == "main":
		_set_telegram_main_offset(drag_x)
	elif is_instance_valid(telegram_swipe_outgoing_panel):
		telegram_swipe_outgoing_panel.position.x = drag_x
	if not telegram_swipe_neighbor_destination.is_empty():
		var neighbor_offset := float(direction) * width + drag_x
		if telegram_swipe_neighbor_destination == "main":
			_set_telegram_main_offset(neighbor_offset)
		elif is_instance_valid(telegram_swipe_incoming_panel):
			telegram_swipe_incoming_panel.position.x = neighbor_offset
		telegram_navigation.preview_pager_drag(direction, absf(drag_x) / width)


func _on_telegram_pager_drag_released(delta_x: float, velocity_x: float, direction: int) -> void:
	if not telegram_swipe_dragging or direction != telegram_swipe_direction:
		return
	_on_telegram_pager_dragged(delta_x, velocity_x, direction)
	var width := maxf(telegram_pager_host.size.x, get_viewport_rect().size.x)
	var velocity_commits := (
		absf(telegram_swipe_velocity_x) >= 900.0
		and signf(telegram_swipe_velocity_x) == -float(direction)
	)
	var commit := (
		not telegram_swipe_neighbor_destination.is_empty()
		and (absf(telegram_swipe_drag_x) >= width / 3.0 or velocity_commits)
	)
	if telegram_page_transition != null and telegram_page_transition.is_valid():
		telegram_page_transition.kill()
	telegram_page_transition = create_tween().set_parallel(true)
	telegram_page_transition.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	telegram_navigation.set_interaction_enabled(false)
	if commit:
		var remaining_ratio := 1.0 - absf(telegram_swipe_drag_x) / width
		var duration := clampf(0.14 + remaining_ratio * 0.16, 0.14, 0.30)
		var destination := telegram_swipe_neighbor_destination
		telegram_navigation.set_destination(destination, true)
		_play_ui_sound()
		_notify_telegram_destination(destination)
		var started_from_main := telegram_swipe_outgoing_panel == null and destination != "main"
		if started_from_main:
			_tween_telegram_main_to_offset(telegram_page_transition, -float(direction) * width, duration)
		elif is_instance_valid(telegram_swipe_outgoing_panel):
			telegram_page_transition.tween_property(
				telegram_swipe_outgoing_panel,
				"position:x",
				-float(direction) * width,
				duration
			)
		if destination == "main":
			_tween_telegram_main_to_offset(telegram_page_transition, 0.0, duration)
		elif is_instance_valid(telegram_swipe_incoming_panel):
			telegram_page_transition.tween_property(telegram_swipe_incoming_panel, "position:x", 0.0, duration)
		var serial := telegram_transition_serial
		telegram_page_transition.chain().tween_callback(
			_finish_telegram_swipe_commit.bind(destination, serial)
		)
	else:
		var cancel_duration := clampf(0.14 + absf(telegram_swipe_drag_x) / width * 0.12, 0.14, 0.26)
		var current_destination: String = telegram_navigation.current_destination
		telegram_navigation.cancel_pager_preview()
		if current_destination == "main":
			_tween_telegram_main_to_offset(telegram_page_transition, 0.0, cancel_duration)
		elif is_instance_valid(telegram_swipe_outgoing_panel):
			telegram_page_transition.tween_property(telegram_swipe_outgoing_panel, "position:x", 0.0, cancel_duration)
		if telegram_swipe_neighbor_destination == "main":
			_tween_telegram_main_to_offset(telegram_page_transition, float(direction) * width, cancel_duration)
		elif is_instance_valid(telegram_swipe_incoming_panel):
			telegram_page_transition.tween_property(
				telegram_swipe_incoming_panel,
				"position:x",
				float(direction) * width,
				cancel_duration
			)
		telegram_page_transition.chain().tween_callback(_finish_telegram_swipe_cancel)


func _finish_telegram_swipe_commit(destination: String, serial: int) -> void:
	if serial != telegram_transition_serial:
		return
	_reset_telegram_main_positions()
	for panel in _get_overlay_panels():
		if panel == menu_panel:
			continue
		if panel != telegram_swipe_incoming_panel:
			panel.hide()
		panel.position = Vector2.ZERO
		panel.modulate = Color.WHITE
	if destination == "main":
		telegram_current_panel = null
		menu_overlay.hide()
		menu_overlay.color = NORMAL_SHELL_BACKGROUND
		_resume_combo_after_menu()
	else:
		telegram_current_panel = telegram_swipe_incoming_panel
		if is_instance_valid(telegram_current_panel):
			telegram_current_panel.position = Vector2.ZERO
			telegram_current_panel.show()
			call_deferred("_reset_panel_scroll", telegram_current_panel)
		menu_overlay.color = NORMAL_SHELL_BACKGROUND
		menu_overlay.show()
	_sync_main_pause_button(destination)
	_reset_telegram_swipe_state()
	telegram_navigation.set_interaction_enabled(true)


func _finish_telegram_swipe_cancel() -> void:
	var current_destination: String = telegram_navigation.current_destination
	_reset_telegram_main_positions()
	if is_instance_valid(telegram_swipe_incoming_panel):
		telegram_swipe_incoming_panel.hide()
		telegram_swipe_incoming_panel.position = Vector2.ZERO
	if is_instance_valid(telegram_swipe_outgoing_panel):
		telegram_swipe_outgoing_panel.position = Vector2.ZERO
		telegram_swipe_outgoing_panel.show()
	if current_destination == "main":
		menu_overlay.hide()
		menu_overlay.color = NORMAL_SHELL_BACKGROUND
		_resume_combo_after_menu()
	else:
		menu_overlay.color = NORMAL_SHELL_BACKGROUND
		menu_overlay.show()
	_sync_main_pause_button(current_destination)
	telegram_navigation.cancel_pager_preview()
	_reset_telegram_swipe_state()
	telegram_navigation.set_interaction_enabled(true)


func _reset_telegram_swipe_state() -> void:
	telegram_swipe_dragging = false
	telegram_swipe_direction = 0
	telegram_swipe_neighbor_destination = ""
	telegram_swipe_outgoing_panel = null
	telegram_swipe_incoming_panel = null
	telegram_swipe_drag_x = 0.0
	telegram_swipe_velocity_x = 0.0


func _prepare_telegram_destination(destination: String, play_sound := true) -> Control:
	if play_sound:
		_play_ui_sound()
	match destination:
		"shop":
			return _prepare_shop_section(active_shop_section)
		"inventory":
			food_panel_mode = "inventory"
			food_status_label.text = "Use an item now, or drag it onto the cat."
			_update_food_ui()
			_apply_telegram_page_style(food_panel)
			_apply_food_grid_responsive_style()
			return food_panel
		"upgrades":
			_update_upgrade_ui()
			_update_stats_ui()
			_update_daily_reward_ui()
			_apply_telegram_page_style(upgrades_panel)
			_apply_upgrades_responsive_layout()
			_refresh_telegram_segment_buttons(upgrade_category_buttons, upgrade_active_category)
			return upgrades_panel
		"boosts":
			boost_logic.update_ui()
			_apply_telegram_page_style(boosts_panel)
			_apply_boosts_responsive_layout()
			_refresh_telegram_segment_buttons(boost_category_buttons, boost_active_category)
			return boosts_panel
		"skins":
			var skin_data := _get_skin_data(equipped_skin_id)
			skins_status_label.text = "Equipped: %s. %s" % [_get_equipped_skin_name(), _get_skin_bonus_text(skin_data)]
			_set_skins_section("skins")
			_update_skins_ui()
			_apply_telegram_page_style(skins_panel)
			_refresh_telegram_segment_buttons(skins_tab_buttons, skins_active_section)
			_apply_skins_responsive_layout()
			return skins_panel
		"missions":
			mission_logic.update_ui()
			_apply_telegram_page_style(mission_logic.panel)
			mission_logic.apply_responsive_layout()
			return mission_logic.panel
		"museum":
			_rebuild_museum()
			_apply_telegram_page_style(museum_panel)
			_apply_museum_responsive_layout()
			return museum_panel
	return null


func _hide_menu_from_navigation() -> void:
	if pause_popup_open:
		_hide_pause_popup(false, true)
	telegram_transition_serial += 1
	if telegram_page_transition != null and telegram_page_transition.is_valid():
		telegram_page_transition.kill()
	_reset_telegram_main_positions()
	if menu_overlay.visible:
		var outgoing := telegram_current_panel
		if outgoing != null and outgoing.visible:
			var width := maxf(telegram_pager_host.size.x, get_viewport_rect().size.x)
			menu_overlay.color = Color(0, 0, 0, 0)
			_capture_telegram_main_positions()
			_set_telegram_main_offset(-width)
			outgoing.position = Vector2.ZERO
			outgoing.modulate = Color.WHITE
			telegram_page_transition = create_tween().set_parallel(true)
			telegram_page_transition.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
			telegram_page_transition.tween_property(outgoing, "position:x", width, 0.30)
			_tween_telegram_main_to_base(telegram_page_transition, 0.30)
			telegram_page_transition.chain().tween_callback(_finish_telegram_return_to_main)
		else:
			_finish_telegram_return_to_main()
	if is_instance_valid(compact_inventory_panel):
		compact_inventory_panel.hide()


func _finish_telegram_return_to_main() -> void:
	_reset_telegram_main_positions()
	for panel in _get_overlay_panels():
		# The pause popup is a centered modal, not a pager page. Resetting its
		# position here races with opening Pause during the final pager frames.
		if panel == menu_panel:
			continue
		panel.hide()
		panel.position = Vector2.ZERO
		panel.modulate = Color.WHITE
	telegram_current_panel = null
	if pause_popup_open:
		# Pause may be opened while the last pager frame is still settling.
		# Keep its dimmer and modal in the active GUI tree.
		menu_overlay.color = Color(0, 0, 0, 0)
		menu_overlay.show()
		pause_opened_over_page = false
	else:
		menu_overlay.hide()
		menu_overlay.color = NORMAL_SHELL_BACKGROUND
	modal_closing = false
	if not pause_popup_open:
		_resume_combo_after_menu()


func _capture_telegram_main_positions() -> void:
	telegram_main_base_positions.clear()
	for node in telegram_main_transition_nodes:
		if is_instance_valid(node):
			telegram_main_base_positions[node] = node.position


func _set_telegram_main_offset(offset_x: float) -> void:
	for node in telegram_main_base_positions.keys():
		if is_instance_valid(node):
			var base_position: Vector2 = telegram_main_base_positions[node]
			(node as Control).position = base_position + Vector2(offset_x, 0.0)


func _tween_telegram_main_to_base(tween: Tween, duration: float) -> void:
	_tween_telegram_main_to_offset(tween, 0.0, duration)


func _tween_telegram_main_to_offset(tween: Tween, offset_x: float, duration: float) -> void:
	for node in telegram_main_base_positions.keys():
		if is_instance_valid(node):
			var base_position: Vector2 = telegram_main_base_positions[node]
			tween.tween_property(node, "position", base_position + Vector2(offset_x, 0.0), duration)


func _reset_telegram_main_positions() -> void:
	for node in telegram_main_base_positions.keys():
		if is_instance_valid(node):
			var base_position: Vector2 = telegram_main_base_positions[node]
			(node as Control).position = base_position
	telegram_main_base_positions.clear()


func _apply_telegram_page_style(panel: Control) -> void:
	_apply_telegram_style_tree(panel, true)
	_apply_telegram_root_spacing(panel)


func _apply_telegram_style_tree(node: Node, _is_root := false) -> void:
	for child in node.get_children():
		if child is Button:
			var button := child as Button
			var normalized_text := button.text.strip_edges().to_upper()
			if normalized_text in ["BACK", "BACK TO GAME", "CLOSE"]:
				button.hide()
		_apply_telegram_style_tree(child)


func _refresh_telegram_segment_buttons(buttons: Dictionary, active_key: String) -> void:
	var compact := get_viewport_rect().size.x < 520.0
	var horizontal_padding := 4.0 if compact else 10.0
	for key in buttons.keys():
		var button := buttons[key] as Button
		if button == null:
			continue
		var accent: Color = button.get_meta("telegram_segment_accent", CLICK_UPGRADE_COLOR)
		var active := String(key) == active_key
		var compact_font_size := 13 if button.text.length() > 8 else 16
		button.add_theme_font_size_override("font_size", compact_font_size if compact else 20)
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.add_theme_color_override("font_color", accent.lightened(0.2) if active else NORMAL_SHELL_MUTED)
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_stylebox_override(
			"normal",
			_normal_segment_style(accent, active, false, horizontal_padding)
		)
		button.add_theme_stylebox_override(
			"hover",
			_normal_segment_style(accent, active, true, horizontal_padding)
		)
		button.add_theme_stylebox_override(
			"pressed",
			_normal_segment_style(accent, true, true, horizontal_padding)
		)
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())


func _normal_segment_style(accent: Color, active: bool, hovered: bool, horizontal_padding: float) -> StyleBoxFlat:
	var background := Color(0.055, 0.06, 0.07, 0.82)
	var border := Color(1.0, 1.0, 1.0, 0.09)
	if active:
		background = Color(accent.r, accent.g, accent.b, 0.3 if hovered else 0.22)
		border = Color(accent.r, accent.g, accent.b, 0.64 if hovered else 0.48)
	elif hovered:
		background = Color(accent.r, accent.g, accent.b, 0.14)
		border = Color(accent.r, accent.g, accent.b, 0.3)
	var style := _make_upgrade_style(background, border, 14, 1, -1, 3 if active else 0)
	style.content_margin_left = horizontal_padding
	style.content_margin_right = horizontal_padding
	style.content_margin_top = 6.0
	style.content_margin_bottom = 6.0
	return style


func _apply_telegram_root_spacing(panel: Control) -> void:
	for child in panel.find_children("*", "MarginContainer", true, false):
		var margin := child as MarginContainer
		if margin.get_parent() == panel or margin.get_parent() is ScrollContainer:
			margin.add_theme_constant_override("margin_left", 12)
			margin.add_theme_constant_override("margin_top", 10)
			margin.add_theme_constant_override("margin_right", 12)
			margin.add_theme_constant_override("margin_bottom", 14)
			for margin_child in margin.get_children():
				if margin_child is VBoxContainer:
					(margin_child as VBoxContainer).add_theme_constant_override("separation", 10)


func _apply_telegram_settings_style() -> void:
	settings_shell.color = NORMAL_SHELL_BACKGROUND
	audio_settings_card.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.055, 0.062, 0.078, 0.96), Color(0.62, 0.48, 1.0, 0.16), 22, 1, -1, 2)
	)
	if is_instance_valid(performance_settings_card):
		performance_settings_card.add_theme_stylebox_override(
			"panel",
			_make_upgrade_style(Color(0.055, 0.062, 0.078, 0.96), Color(0.26, 0.86, 0.82, 0.16), 22, 1, -1, 2)
		)
	if is_instance_valid(touch_settings_card):
		touch_settings_card.add_theme_stylebox_override(
			"panel",
			_make_upgrade_style(Color(0.055, 0.062, 0.078, 0.96), Color(1.0, 0.58, 0.34, 0.16), 22, 1, -1, 2)
		)
	_style_settings_slider(click_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	_style_settings_slider(ui_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	if is_instance_valid(master_volume_slider):
		_style_settings_slider(master_volume_slider, Color(0.62, 0.48, 1.0, 1.0))
	if is_instance_valid(particle_limit_slider):
		_style_settings_slider(particle_limit_slider, Color(0.26, 0.86, 0.82))
	if is_instance_valid(haptic_strength_slider):
		_style_settings_slider(haptic_strength_slider, Color(1.0, 0.58, 0.34))
	if is_instance_valid(number_detail_slider):
		_style_settings_slider(number_detail_slider, CLICK_UPGRADE_COLOR)
	if is_instance_valid(slider_sound_option):
		slider_sound_option.custom_minimum_size.y = 56.0
		slider_sound_option.add_theme_font_size_override("font_size", 18)
		_style_upgrade_button(slider_sound_option, Color(0.62, 0.48, 1.0, 1.0))
	_style_settings_general_group()


func _style_telegram_achievements_detail() -> void:
	var title := achievements_panel.find_child("AchievementsTitle", true, false) as Label
	if title != null:
		title.hide()
	var margin := achievements_panel.find_child("AchievementsMargin", true, false) as MarginContainer
	if margin != null:
		_set_telegram_margins(margin, 16, 14, 16, 20)
	var items := achievements_panel.find_child("AchievementsItems", true, false) as VBoxContainer
	if items != null:
		items.alignment = BoxContainer.ALIGNMENT_BEGIN
		items.size_flags_vertical = Control.SIZE_EXPAND_FILL
		items.add_theme_constant_override("separation", 10)
	achievements_summary.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.12, 0.09, 0.025, 0.95), Color(1.0, 0.74, 0.2, 0.75), 16, 2, -1, 7)
	)
	achievements_progress_label.add_theme_font_size_override("font_size", 22)
	achievements_progress_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.42, 1.0))
	_style_upgrade_progress(achievements_progress_bar, Color(1.0, 0.72, 0.2, 1.0))
	achievements_filter.custom_minimum_size = Vector2(0.0, 60.0)
	achievements_filter.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(achievements_filter, Color(0.76, 0.6, 0.18, 1.0))
	achievements_filter.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	achievements_filter.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	achievements_list.custom_minimum_size = Vector2(0.0, 180.0)
	achievements_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	achievements_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	achievements_list.add_theme_font_size_override("font_size", 20)
	achievements_list.add_theme_constant_override("line_separation", 14)
	achievements_list.add_theme_color_override("font_color", Color(0.76, 0.8, 0.88, 1.0))
	achievements_list.add_theme_color_override("font_selected_color", Color.WHITE)
	var list_style := _make_upgrade_style(Color(0.025, 0.03, 0.045, 0.98), Color(0.28, 0.3, 0.38, 1.0), 14, 1)
	list_style.content_margin_left = 10.0
	list_style.content_margin_right = 10.0
	list_style.content_margin_top = 8.0
	list_style.content_margin_bottom = 8.0
	var selected_style := _make_upgrade_style(Color(0.76, 0.6, 0.18, 0.28), Color(1.0, 0.74, 0.2, 0.62), 10, 1)
	achievements_list.add_theme_stylebox_override("panel", list_style)
	achievements_list.add_theme_stylebox_override("focus", list_style)
	achievements_list.add_theme_stylebox_override("selected", selected_style)
	achievements_list.add_theme_stylebox_override("selected_focus", selected_style)
	achievements_list.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _style_telegram_stats_detail() -> void:
	stats_header.hide()
	var margin := stats_panel.find_child("StatsMargin", true, false) as MarginContainer
	if margin != null:
		_set_telegram_margins(margin, 12, 12, 12, 20)
	var items := stats_panel.find_child("StatsItems", true, false) as VBoxContainer
	if items != null:
		items.add_theme_constant_override("separation", 8)
	var scroll := stats_panel.find_child("StatsScroll", true, false) as ScrollContainer
	if scroll != null:
		scroll.custom_minimum_size = Vector2.ZERO
		scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	stats_cards.add_theme_constant_override("separation", 18)
	var compact_grid := get_viewport_rect().size.x < 520.0
	for grid_node in stats_cards.find_children("*", "GridContainer", true, false):
		var grid := grid_node as GridContainer
		grid.columns = 1 if compact_grid else 2
		grid.add_theme_constant_override("h_separation", 10)
		grid.add_theme_constant_override("v_separation", 10)
	for card in stats_card_controls:
		card.custom_minimum_size = Vector2(0.0, 86.0)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _apply_telegram_pause_style() -> void:
	var compact := get_viewport_rect().size.x < 520.0
	_setup_pause_menu_visuals()
	var menu_margin := menu_panel.find_child("MenuMargin", true, false) as MarginContainer
	if menu_margin != null:
		_set_telegram_margins(menu_margin, 12 if compact else 16, 10 if compact else 14, 12 if compact else 16, 10 if compact else 14)
	var menu_items := menu_panel.find_child("MenuItems", true, false) as VBoxContainer
	if menu_items != null:
		menu_items.add_theme_constant_override("separation", 6 if compact else 8)
	var header_labels := menu_header.find_children("*", "Label", true, false)
	for index in header_labels.size():
		var header_label := header_labels[index] as Label
		if index == 0:
			header_label.add_theme_font_size_override("font_size", 24 if compact else 28)
			header_label.add_theme_color_override("font_color", NORMAL_SHELL_GOLD.lightened(0.16))
		else:
			header_label.add_theme_font_size_override("font_size", 16 if compact else 18)
			header_label.add_theme_color_override("font_color", NORMAL_SHELL_MUTED)
	for button in [settings_button, achievements_button, stats_button]:
		button.custom_minimum_size.x = 0.0
		button.custom_minimum_size.y = 52.0 if compact else 60.0
		button.add_theme_font_size_override("font_size", 18 if compact else 20)
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _set_telegram_margins(margin: MarginContainer, left: int, top: int, right: int, bottom: int) -> void:
	margin.add_theme_constant_override("margin_left", left)
	margin.add_theme_constant_override("margin_top", top)
	margin.add_theme_constant_override("margin_right", right)
	margin.add_theme_constant_override("margin_bottom", bottom)


func _show_overlay_panel(panel: Control) -> void:
	if is_instance_valid(telegram_pager_host):
		if pause_popup_open and panel != menu_panel:
			_hide_pause_popup(false, true)
		_show_telegram_pager_panel(panel, telegram_pending_direction)
		telegram_pending_direction = 0
		return
	upgrade_alert_elapsed = 0.0
	var overlay_was_visible := menu_overlay.visible
	_stop_entrance_animations()
	if modal_transition_tween != null and modal_transition_tween.is_valid():
		modal_transition_tween.kill()
	if modal_decoration_tween != null and modal_decoration_tween.is_valid():
		modal_decoration_tween.kill()
	modal_closing = false
	if not overlay_was_visible and combo_timer != null:
		combo_was_running_before_overlay = not combo_timer.is_stopped()
		combo_time_left_before_overlay = combo_timer.time_left
		if combo_was_running_before_overlay:
			combo_timer.stop()
		menu_time_pause_started = Time.get_unix_time_from_system()
	if panel != upgrades_panel:
		_stop_upgrade_ambient_animation()
	menu_panel.hide()
	settings_panel.hide()
	upgrades_panel.hide()
	achievements_panel.hide()
	stats_panel.hide()
	skins_panel.hide()
	boosts_panel.hide()
	food_panel.hide()
	if is_instance_valid(museum_panel):
		museum_panel.hide()
	if bottomless_bowl_logic != null and is_instance_valid(bottomless_bowl_logic.panel):
		bottomless_bowl_logic.panel.hide()
	if crate_logic != null and is_instance_valid(crate_logic.panel):
		crate_logic.panel.hide()
	if mission_logic != null and is_instance_valid(mission_logic.panel):
		mission_logic.panel.hide()
	panel.show()
	panel.modulate.a = 0.0
	panel.scale = Vector2(0.78, 0.78)
	panel.rotation = -0.018
	panel.pivot_offset = panel.size * 0.5
	menu_overlay.show()
	modal_close_button.disabled = false
	modal_close_button.pivot_offset = modal_close_button.size * 0.5
	modal_close_button.modulate.a = 0.0
	modal_close_button.scale = Vector2(0.35, 0.35)
	modal_close_button.rotation = -0.7
	for decoration in modal_decorations:
		decoration.modulate.a = 0.0
		decoration.scale = Vector2(0.3, 0.3)
	if not overlay_was_visible:
		menu_overlay.modulate.a = 0.0
	modal_transition_tween = create_tween()
	modal_transition_tween.set_parallel(true)
	modal_transition_tween.tween_property(panel, "modulate:a", 1.0, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(panel, "scale", Vector2.ONE, 0.48).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(panel, "rotation", 0.0, 0.38).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(menu_overlay, "modulate:a", 1.0, 0.24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(modal_close_button, "modulate:a", 1.0, 0.18).set_delay(0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(modal_close_button, "scale", Vector2.ONE, 0.38).set_delay(0.08).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	modal_transition_tween.tween_property(modal_close_button, "rotation", 0.0, 0.34).set_delay(0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for index in range(modal_decorations.size()):
		var decoration := modal_decorations[index]
		var delay := 0.12 + float(index) * 0.025
		modal_transition_tween.tween_property(decoration, "modulate:a", 0.88, 0.22).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		modal_transition_tween.tween_property(decoration, "scale", Vector2.ONE, 0.34).set_delay(delay).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	modal_transition_tween.chain().tween_callback(_finish_modal_open.bind(panel))
	call_deferred("_position_modal_close_button", panel)
	call_deferred("_reset_panel_scroll", panel)


func _show_telegram_pager_panel(panel: Control, direction: int) -> void:
	upgrade_alert_elapsed = 0.0
	var overlay_was_visible := menu_overlay.visible
	if not overlay_was_visible and combo_timer != null:
		combo_was_running_before_overlay = not combo_timer.is_stopped()
		combo_time_left_before_overlay = combo_timer.time_left
		if combo_was_running_before_overlay:
			combo_timer.stop()
			menu_time_pause_started = Time.get_unix_time_from_system()
	if telegram_page_transition != null and telegram_page_transition.is_valid():
		telegram_page_transition.kill()
	_reset_telegram_main_positions()
	telegram_transition_serial += 1
	var serial := telegram_transition_serial
	var outgoing := telegram_current_panel
	if outgoing == panel:
		panel.show()
		panel.position = Vector2.ZERO
		panel.modulate = Color.WHITE
		menu_overlay.show()
		call_deferred("_reset_panel_scroll", panel)
		return
	for candidate in _get_overlay_panels():
		if candidate != outgoing and candidate != panel:
			candidate.hide()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.position = Vector2.ZERO
	panel.scale = Vector2.ONE
	panel.rotation = 0.0
	panel.modulate = Color.WHITE
	panel.show()
	menu_overlay.modulate = Color.WHITE
	menu_overlay.show()
	if (outgoing == null or not overlay_was_visible) and direction != 0:
		var width := maxf(telegram_pager_host.size.x, get_viewport_rect().size.x)
		menu_overlay.color = Color(0, 0, 0, 0)
		panel.position.x = float(direction) * width
		_capture_telegram_main_positions()
		telegram_page_transition = create_tween().set_parallel(true)
		telegram_page_transition.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		telegram_page_transition.tween_property(panel, "position:x", 0.0, 0.30)
		for main_node in telegram_main_base_positions.keys():
			if is_instance_valid(main_node):
				var base_position: Vector2 = telegram_main_base_positions[main_node]
				telegram_page_transition.tween_property(
					main_node,
					"position",
					base_position + Vector2(-float(direction) * width, 0.0),
					0.30
				)
		telegram_page_transition.chain().tween_callback(_finish_telegram_page_transition.bind(panel, outgoing, serial))
	elif outgoing == null or not overlay_was_visible:
		panel.modulate.a = 0.0
		panel.position.y = 8.0
		telegram_page_transition = create_tween().set_parallel(true)
		telegram_page_transition.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		telegram_page_transition.tween_property(panel, "modulate:a", 1.0, 0.16)
		telegram_page_transition.tween_property(panel, "position:y", 0.0, 0.22)
		telegram_page_transition.chain().tween_callback(_finish_telegram_page_transition.bind(panel, outgoing, serial))
	elif direction == 0:
		panel.modulate.a = 0.0
		telegram_page_transition = create_tween().set_parallel(true)
		telegram_page_transition.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		telegram_page_transition.tween_property(outgoing, "modulate:a", 0.0, 0.12)
		telegram_page_transition.tween_property(panel, "modulate:a", 1.0, 0.16)
		telegram_page_transition.chain().tween_callback(_finish_telegram_page_transition.bind(panel, outgoing, serial))
	else:
		var width := maxf(telegram_pager_host.size.x, get_viewport_rect().size.x)
		panel.position.x = float(direction) * width
		outgoing.position = Vector2.ZERO
		outgoing.modulate = Color.WHITE
		telegram_page_transition = create_tween().set_parallel(true)
		# Telegram's ViewPagerFixed uses an ease-out-quint curve and moves both
		# real page views across the complete viewport.
		telegram_page_transition.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		telegram_page_transition.tween_property(outgoing, "position:x", -float(direction) * width, 0.30)
		telegram_page_transition.tween_property(panel, "position:x", 0.0, 0.30)
		telegram_page_transition.chain().tween_callback(_finish_telegram_page_transition.bind(panel, outgoing, serial))
	telegram_current_panel = panel
	call_deferred("_reset_panel_scroll", panel)


func _finish_telegram_page_transition(panel: Control, outgoing: Control, serial: int) -> void:
	if serial != telegram_transition_serial:
		return
	if outgoing != null and outgoing != panel:
		outgoing.hide()
		outgoing.position = Vector2.ZERO
		outgoing.modulate = Color.WHITE
	panel.position = Vector2.ZERO
	panel.modulate = Color.WHITE
	_reset_telegram_main_positions()
	menu_overlay.color = NORMAL_SHELL_BACKGROUND
	telegram_current_panel = panel


func _hide_menu() -> void:
	if is_instance_valid(settings_shell) and settings_shell.visible:
		_close_settings_shell()
		return
	if is_instance_valid(pause_detail_shell) and pause_detail_shell.visible:
		_close_pause_detail_shell()
		return
	if not menu_overlay.visible or modal_closing:
		return
	if pause_popup_open:
		_hide_pause_popup()
		return
	if is_instance_valid(telegram_pager_host):
		telegram_navigation.set_destination("main")
		_hide_menu_from_navigation()
		return
	modal_closing = true
	_play_ui_sound()
	_stop_upgrade_ambient_animation()
	_stop_entrance_animations()
	if modal_decoration_tween != null and modal_decoration_tween.is_valid():
		modal_decoration_tween.kill()
	touch_scroll_index = -1
	touch_scroll_dragging = false
	touch_scroll_distance = 0.0
	touch_scroll = null
	upgrade_alert_elapsed = 0.0
	modal_close_button.disabled = true
	var panel := _get_visible_overlay_panel()
	if modal_transition_tween != null and modal_transition_tween.is_valid():
		modal_transition_tween.kill()
	modal_transition_tween = create_tween()
	modal_transition_tween.set_parallel(true)
	if panel != null:
		modal_transition_tween.tween_property(panel, "modulate:a", 0.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		modal_transition_tween.tween_property(panel, "scale", Vector2(0.82, 0.82), 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		modal_transition_tween.tween_property(panel, "rotation", 0.018, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	modal_transition_tween.tween_property(modal_close_button, "modulate:a", 0.0, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	modal_transition_tween.tween_property(modal_close_button, "scale", Vector2(0.3, 0.3), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	modal_transition_tween.tween_property(modal_close_button, "rotation", 0.7, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	for decoration in modal_decorations:
		modal_transition_tween.tween_property(decoration, "modulate:a", 0.0, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		modal_transition_tween.tween_property(decoration, "scale", Vector2(0.2, 0.2), 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	modal_transition_tween.tween_property(menu_overlay, "modulate:a", 0.0, 0.22).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	modal_transition_tween.chain().tween_callback(_finish_hiding_menu.bind(panel))


func _finish_hiding_menu(panel: Control) -> void:
	if panel != null:
		panel.hide()
		panel.modulate.a = 1.0
		panel.scale = Vector2.ONE
		panel.rotation = 0.0
	menu_overlay.hide()
	menu_overlay.modulate.a = 1.0
	modal_close_button.modulate.a = 1.0
	modal_close_button.scale = Vector2.ONE
	modal_close_button.rotation = 0.0
	for decoration in modal_decorations:
		decoration.modulate.a = 0.0
		decoration.scale = Vector2.ONE
	modal_close_button.disabled = false
	modal_closing = false
	_resume_combo_after_menu()
	_resume_gameplay_time_after_menu()


func _resume_combo_after_menu() -> void:
	if combo_timer != null and combo_was_running_before_overlay and combo_time_left_before_overlay > 0.0:
		combo_timer.start(combo_time_left_before_overlay)
	combo_was_running_before_overlay = false
	combo_time_left_before_overlay = 0.0


func is_menu_time_paused() -> bool:
	return menu_time_pause_started > 0.0 and menu_overlay.visible


func _resume_gameplay_time_after_menu() -> void:
	if menu_time_pause_started <= 0.0:
		return
	var paused_at := menu_time_pause_started
	var paused_seconds := maxf(0.0, Time.get_unix_time_from_system() - paused_at)
	menu_time_pause_started = 0.0
	if paused_seconds <= 0.0:
		return
	_extend_end_time_dictionary(active_boost_end_times, paused_seconds, paused_at)
	_extend_end_time_dictionary(boost_recharge_end_times, paused_seconds, paused_at)
	_extend_end_time_dictionary(active_food_boosts, paused_seconds, paused_at)
	if bottomless_bowl_logic != null and bottomless_bowl_logic.boost_end_time > paused_at:
		bottomless_bowl_logic.boost_end_time += int(ceil(paused_seconds))
	_queue_save()


func _extend_end_time_dictionary(end_times: Dictionary, seconds: float, reference_time: float) -> void:
	for key in end_times.keys():
		if float(end_times[key]) > reference_time:
			end_times[key] = float(end_times[key]) + seconds


func _exit_game() -> void:
	_play_ui_sound()
	_save_game()
	get_tree().quit()


func _play_cat_sound() -> void:
	cat_click_sound.stop()
	cat_click_sound.pitch_scale = 1.0
	cat_click_sound.play()


func _play_bonus_sound() -> void:
	bonus_sound.stop()
	bonus_sound.play()


func _play_milestone_sound_if_needed(previous_score: int) -> void:
	click_logic.play_milestone_sound_if_needed(previous_score)


func _get_scaled_meow_interval(current_score: int) -> int:
	return click_logic.get_scaled_meow_interval(current_score)


func _play_ui_sound() -> void:
	if not ui_sounds_enabled:
		return
	ui_sound.stop()
	ui_sound.stream = UI_SOUND_VARIANTS[ui_sound_variant_index]
	ui_sound_variant_index = (ui_sound_variant_index + 1) % UI_SOUND_VARIANTS.size()
	ui_sound.play()


func _play_reward_redeem_sound() -> void:
	reward_redeem_sound.stop()
	reward_redeem_sound.play()


func _play_purchase_sound() -> void:
	purchase_sound.stop()
	purchase_sound.play()


func _play_crate_open_sound() -> void:
	crate_open_sound.stop()
	crate_open_sound.play()


func _play_gem_reveal_sound(is_new_discovery: bool = false) -> void:
	var player := gem_discovery_sound if is_new_discovery else gem_reveal_sound
	player.stop()
	player.play()


func _queue_save() -> void:
	save_logic.queue_save()


func _save_game() -> void:
	save_logic.save_game()


func _load_game() -> void:
	save_logic.load_game()


func _apply_offline_gain(last_seen_unix: int) -> void:
	save_logic.apply_offline_gain(last_seen_unix)


func _apply_resumed_offline_gain() -> void:
	save_logic.apply_resumed_offline_gain()


func _show_offline_gain_message() -> void:
	save_logic.show_offline_gain_message()


func _get_offline_info_text() -> String:
	return save_logic.get_offline_info_text()


func _get_unix_time() -> int:
	if is_menu_time_paused():
		return int(menu_time_pause_started)
	return save_logic.get_unix_time()


func _get_current_day_number() -> int:
	return floori(float(_get_unix_time()) / 86400.0)


func _clamp_resource_value(value: int) -> int:
	return clampi(value, 0, MAX_RESOURCE_VALUE)


func _safe_resource_round(value: float, minimum: int = 0) -> int:
	if is_nan(value) or value <= float(minimum):
		return minimum
	if is_inf(value) or value >= float(MAX_RESOURCE_VALUE):
		return MAX_RESOURCE_VALUE
	return clampi(roundi(value), minimum, MAX_RESOURCE_VALUE)


func _add_resource_value(value: int, amount: int) -> int:
	value = _clamp_resource_value(value)
	if amount >= MAX_RESOURCE_VALUE:
		return MAX_RESOURCE_VALUE
	if amount >= MAX_RESOURCE_VALUE - value:
		return MAX_RESOURCE_VALUE
	return _clamp_resource_value(value + amount)


func _add_score(amount: int) -> int:
	if amount <= 0:
		return 0
	score_counter.add_int(amount)
	score = score_counter.to_clamped_int(MAX_RESOURCE_VALUE)
	return amount


func _add_coins(amount: int) -> int:
	if amount <= 0:
		return 0
	coins_counter.add_int(amount)
	coins = coins_counter.to_clamped_int(MAX_RESOURCE_VALUE)
	if coins_counter.compare(best_coin_balance_counter) > 0:
		best_coin_balance_counter.copy_from(coins_counter)
	best_coin_balance = best_coin_balance_counter.to_clamped_int(MAX_RESOURCE_VALUE)
	return amount


func _spend_coins(amount: int) -> bool:
	if amount <= 0:
		return true
	if not coins_counter.subtract_int(amount):
		return false
	coins = coins_counter.to_clamped_int(MAX_RESOURCE_VALUE)
	return true


func _sync_resource_bounds() -> void:
	score = score_counter.to_clamped_int(MAX_RESOURCE_VALUE)
	coins = coins_counter.to_clamped_int(MAX_RESOURCE_VALUE)
	if coins_counter.compare(best_coin_balance_counter) > 0:
		best_coin_balance_counter.copy_from(coins_counter)
	best_coin_balance = best_coin_balance_counter.to_clamped_int(MAX_RESOURCE_VALUE)


func _coins_exceed_display_int() -> bool:
	return coins_counter.exceeds_int(MAX_RESOURCE_VALUE)


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
	admin_panel.offset_right = 392.0
	admin_panel.offset_bottom = 560.0
	admin_panel.z_index = 50
	add_child(admin_panel)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.05, 0.07, 0.11, 0.97)
	panel_style.border_color = Color(0.36, 0.86, 1.0, 0.95)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(18)
	panel_style.shadow_color = Color(0.0, 0.0, 0.0, 0.52)
	panel_style.shadow_size = 18
	admin_panel.add_theme_stylebox_override("panel", panel_style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	admin_panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	margin.add_child(column)

	admin_header = PanelContainer.new()
	admin_header.mouse_default_cursor_shape = Control.CURSOR_MOVE
	admin_header.gui_input.connect(_on_admin_header_gui_input)
	column.add_child(admin_header)

	var header_style := StyleBoxFlat.new()
	header_style.bg_color = Color(0.08, 0.14, 0.22, 0.96)
	header_style.border_color = Color(1.0, 0.84, 0.34, 0.95)
	header_style.set_border_width_all(2)
	header_style.set_corner_radius_all(14)
	admin_header.add_theme_stylebox_override("panel", header_style)

	var header_margin := MarginContainer.new()
	header_margin.add_theme_constant_override("margin_left", 14)
	header_margin.add_theme_constant_override("margin_top", 12)
	header_margin.add_theme_constant_override("margin_right", 10)
	header_margin.add_theme_constant_override("margin_bottom", 12)
	admin_header.add_child(header_margin)

	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 10)
	header_margin.add_child(header_row)

	var title_column := VBoxContainer.new()
	title_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_column.add_theme_constant_override("separation", 2)
	header_row.add_child(title_column)

	var title := Label.new()
	title.text = "EDITOR ADMIN"
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.94, 0.72, 1.0))
	title_column.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Drag me around | Ctrl+Alt+1 toggles"
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.add_theme_color_override("font_color", Color(0.72, 0.82, 0.93, 1.0))
	title_column.add_child(subtitle)

	var close_button := Button.new()
	close_button.text = "X"
	close_button.tooltip_text = "Hide admin panel"
	close_button.custom_minimum_size = Vector2(42.0, 42.0)
	close_button.pressed.connect(_toggle_admin_panel)
	header_row.add_child(close_button)

	column.add_child(_build_admin_row("Add clicks", true))
	column.add_child(_build_admin_row("Add kibbles", false))
	column.add_child(_build_admin_reset_section())
	column.add_child(_build_admin_text_section())

	admin_status_label = Label.new()
	admin_status_label.text = "Clicks and kibbles are unlimited."
	admin_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	admin_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	admin_status_label.add_theme_font_size_override("font_size", 13)
	admin_status_label.add_theme_color_override("font_color", Color(0.79, 0.86, 0.95, 1.0))
	column.add_child(admin_status_label)


func _build_admin_row(label_text: String, adds_clicks: bool) -> VBoxContainer:
	var wrapper := VBoxContainer.new()
	wrapper.add_theme_constant_override("separation", 8)

	var card := PanelContainer.new()
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.09, 0.11, 0.17, 0.92)
	card_style.border_color = Color(0.2, 0.3, 0.44, 0.95)
	card_style.set_border_width_all(1)
	card_style.set_corner_radius_all(12)
	card.add_theme_stylebox_override("panel", card_style)
	wrapper.add_child(card)

	var card_margin := MarginContainer.new()
	card_margin.add_theme_constant_override("margin_left", 14)
	card_margin.add_theme_constant_override("margin_top", 12)
	card_margin.add_theme_constant_override("margin_right", 14)
	card_margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(card_margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	card_margin.add_child(content)

	var label := Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(0.9, 0.95, 1.0, 1.0))
	content.add_child(label)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	content.add_child(row)

	var spinbox := SpinBox.new()
	spinbox.min_value = ADMIN_MIN_AMOUNT
	spinbox.max_value = ADMIN_CLICK_SOFT_MAX
	spinbox.step = 1.0
	spinbox.allow_greater = true
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


func _build_admin_reset_section() -> PanelContainer:
	var card := PanelContainer.new()
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.11, 0.08, 0.13, 0.94)
	card_style.border_color = Color(0.56, 0.34, 0.76, 0.95)
	card_style.set_border_width_all(1)
	card_style.set_corner_radius_all(12)
	card.add_theme_stylebox_override("panel", card_style)

	var card_margin := MarginContainer.new()
	card_margin.add_theme_constant_override("margin_left", 14)
	card_margin.add_theme_constant_override("margin_top", 12)
	card_margin.add_theme_constant_override("margin_right", 14)
	card_margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(card_margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	card_margin.add_child(content)

	var title := Label.new()
	title.text = "Reset data"
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.94, 0.88, 1.0, 1.0))
	content.add_child(title)

	var reset_grid := GridContainer.new()
	reset_grid.columns = 2
	reset_grid.add_theme_constant_override("h_separation", 8)
	reset_grid.add_theme_constant_override("v_separation", 8)
	content.add_child(reset_grid)

	for button_data in [
		{"text": "RESET CLICKS", "action": Callable(self, "_on_admin_reset_clicks_pressed")},
		{"text": "RESET KIBBLES", "action": Callable(self, "_on_admin_reset_coins_pressed")},
		{"text": "RESET UPGRADES", "action": Callable(self, "_on_admin_reset_upgrades_pressed")},
		{"text": "RESET SKINS", "action": Callable(self, "_on_admin_reset_skins_pressed")},
	]:
		var action_button := Button.new()
		action_button.text = String(button_data["text"])
		action_button.custom_minimum_size = Vector2(0.0, 40.0)
		action_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		action_button.pressed.connect(button_data["action"])
		reset_grid.add_child(action_button)

	return card


func _build_admin_text_section() -> PanelContainer:
	var card := PanelContainer.new()
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.08, 0.12, 0.1, 0.94)
	card_style.border_color = Color(0.28, 0.76, 0.56, 0.95)
	card_style.set_border_width_all(1)
	card_style.set_corner_radius_all(12)
	card.add_theme_stylebox_override("panel", card_style)

	var card_margin := MarginContainer.new()
	card_margin.add_theme_constant_override("margin_left", 14)
	card_margin.add_theme_constant_override("margin_top", 12)
	card_margin.add_theme_constant_override("margin_right", 14)
	card_margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(card_margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	card_margin.add_child(content)

	var title := Label.new()
	title.text = "Custom text"
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.9, 1.0, 0.94, 1.0))
	content.add_child(title)

	admin_text_edit = LineEdit.new()
	admin_text_edit.placeholder_text = "Write any message here"
	admin_text_edit.text_submitted.connect(_on_admin_text_submitted)
	content.add_child(admin_text_edit)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	content.add_child(row)

	var set_text_button := Button.new()
	set_text_button.text = "SET TEXT"
	set_text_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	set_text_button.custom_minimum_size = Vector2(0.0, 38.0)
	set_text_button.pressed.connect(_on_admin_set_text_pressed)
	row.add_child(set_text_button)

	var clear_text_button := Button.new()
	clear_text_button.text = "CLEAR"
	clear_text_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clear_text_button.custom_minimum_size = Vector2(0.0, 38.0)
	clear_text_button.pressed.connect(_on_admin_clear_text_pressed)
	row.add_child(clear_text_button)

	var edit_title := Label.new()
	edit_title.text = "Selected text style"
	edit_title.add_theme_font_size_override("font_size", 14)
	edit_title.add_theme_color_override("font_color", Color(0.78, 0.98, 0.9, 1.0))
	content.add_child(edit_title)

	var style_row := HBoxContainer.new()
	style_row.add_theme_constant_override("separation", 8)
	content.add_child(style_row)

	admin_text_size_spinbox = SpinBox.new()
	admin_text_size_spinbox.min_value = 12
	admin_text_size_spinbox.max_value = 120
	admin_text_size_spinbox.step = 1.0
	admin_text_size_spinbox.rounded = true
	admin_text_size_spinbox.value = 34
	admin_text_size_spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	admin_text_size_spinbox.value_changed.connect(_on_admin_text_size_changed)
	style_row.add_child(admin_text_size_spinbox)

	admin_text_rotation_spinbox = SpinBox.new()
	admin_text_rotation_spinbox.min_value = -180
	admin_text_rotation_spinbox.max_value = 180
	admin_text_rotation_spinbox.step = 1.0
	admin_text_rotation_spinbox.rounded = true
	admin_text_rotation_spinbox.value = 0
	admin_text_rotation_spinbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	admin_text_rotation_spinbox.value_changed.connect(_on_admin_text_rotation_changed)
	style_row.add_child(admin_text_rotation_spinbox)

	admin_text_color_picker = ColorPickerButton.new()
	admin_text_color_picker.custom_minimum_size = Vector2(96.0, 38.0)
	admin_text_color_picker.color = Color(1.0, 0.96, 0.74, 1.0)
	admin_text_color_picker.color_changed.connect(_on_admin_text_color_changed)
	style_row.add_child(admin_text_color_picker)

	_refresh_admin_overlay_text_controls()

	return card


func _toggle_admin_panel() -> void:
	if not is_instance_valid(admin_panel):
		return

	admin_panel.visible = not admin_panel.visible
	admin_dragging = false
	if admin_panel.visible:
		admin_status_label.text = "Clicks and kibbles are unlimited."
		admin_click_spinbox.get_line_edit().grab_focus()


func _get_admin_amount(spinbox: SpinBox) -> int:
	if spinbox.value >= float(MAX_RESOURCE_VALUE):
		return MAX_RESOURCE_VALUE
	return maxi(ADMIN_MIN_AMOUNT, int(round(spinbox.value)))


func _get_admin_click_amount() -> int:
	if admin_click_spinbox.value >= float(MAX_RESOURCE_VALUE):
		return MAX_RESOURCE_VALUE
	return maxi(ADMIN_MIN_AMOUNT, int(round(admin_click_spinbox.value)))


func _on_admin_header_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			admin_dragging = true
			admin_drag_offset = event.global_position - admin_panel.global_position
			get_viewport().set_input_as_handled()
		else:
			admin_dragging = false
			get_viewport().set_input_as_handled()


func _move_admin_panel(global_mouse_position: Vector2) -> void:
	if not is_instance_valid(admin_panel):
		return

	var target_position := global_mouse_position - admin_drag_offset
	var viewport_rect := get_viewport_rect()
	var panel_size := admin_panel.size
	target_position.x = clampf(target_position.x, 8.0, maxf(8.0, viewport_rect.size.x - panel_size.x - 8.0))
	target_position.y = clampf(target_position.y, 8.0, maxf(8.0, viewport_rect.size.y - panel_size.y - 8.0))
	admin_panel.global_position = target_position


func _refresh_admin_overlay_text_controls() -> void:
	var has_overlay_text := is_instance_valid(admin_overlay_text_label)
	if is_instance_valid(admin_text_size_spinbox):
		admin_text_size_spinbox.editable = has_overlay_text and admin_overlay_text_selected
		if has_overlay_text:
			var font_size := admin_overlay_text_label.get_theme_font_size("font_size")
			if int(round(admin_text_size_spinbox.value)) != font_size:
				admin_text_size_spinbox.value = font_size
	if is_instance_valid(admin_text_rotation_spinbox):
		admin_text_rotation_spinbox.editable = has_overlay_text and admin_overlay_text_selected
		if has_overlay_text:
			var rotation_degrees := rad_to_deg(admin_overlay_text_label.rotation)
			if absf(admin_text_rotation_spinbox.value - rotation_degrees) > 0.01:
				admin_text_rotation_spinbox.value = rotation_degrees
	if is_instance_valid(admin_text_color_picker):
		admin_text_color_picker.disabled = not has_overlay_text or not admin_overlay_text_selected
		if has_overlay_text:
			var font_color := admin_overlay_text_label.get_theme_color("font_color")
			if admin_text_color_picker.color != font_color:
				admin_text_color_picker.color = font_color


func _set_admin_overlay_text_selected(selected: bool) -> void:
	admin_overlay_text_selected = selected and is_instance_valid(admin_overlay_text_label)
	if is_instance_valid(admin_overlay_text_outline):
		admin_overlay_text_outline.visible = admin_overlay_text_selected
	if is_instance_valid(admin_overlay_text_resize_handle):
		admin_overlay_text_resize_handle.visible = admin_overlay_text_selected
	if is_instance_valid(admin_overlay_text_rotate_handle):
		admin_overlay_text_rotate_handle.visible = admin_overlay_text_selected
	if is_instance_valid(admin_overlay_text_rotate_stem):
		admin_overlay_text_rotate_stem.visible = admin_overlay_text_selected
	_refresh_admin_overlay_text_controls()


func _admin_overlay_text_hit_test(global_position: Vector2) -> bool:
	if not is_instance_valid(admin_overlay_text_label):
		return false
	if admin_overlay_text_label.get_global_rect().has_point(global_position):
		return true
	if is_instance_valid(admin_overlay_text_resize_handle) and admin_overlay_text_resize_handle.get_global_rect().has_point(global_position):
		return true
	if is_instance_valid(admin_overlay_text_rotate_handle) and admin_overlay_text_rotate_handle.get_global_rect().has_point(global_position):
		return true
	return false


func _ensure_admin_overlay_text_label() -> void:
	if is_instance_valid(admin_overlay_text_label):
		_refresh_admin_overlay_text_controls()
		return

	admin_overlay_text_label = Label.new()
	admin_overlay_text_label.name = "AdminOverlayText"
	admin_overlay_text_label.mouse_filter = Control.MOUSE_FILTER_STOP
	admin_overlay_text_label.mouse_default_cursor_shape = Control.CURSOR_MOVE
	admin_overlay_text_label.z_index = 70
	admin_overlay_text_label.position = Vector2(42.0, 160.0)
	admin_overlay_text_label.add_theme_font_size_override("font_size", 34)
	admin_overlay_text_label.add_theme_color_override("font_color", Color(1.0, 0.96, 0.74, 1.0))
	admin_overlay_text_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	admin_overlay_text_label.add_theme_constant_override("shadow_offset_x", 2)
	admin_overlay_text_label.add_theme_constant_override("shadow_offset_y", 3)
	admin_overlay_text_label.gui_input.connect(_on_admin_overlay_text_gui_input)
	add_child(admin_overlay_text_label)
	admin_overlay_text_outline = Panel.new()
	admin_overlay_text_outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	admin_overlay_text_outline.visible = false
	admin_overlay_text_label.add_child(admin_overlay_text_outline)
	var outline_style := StyleBoxFlat.new()
	outline_style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	outline_style.border_color = Color(0.32, 0.84, 1.0, 0.96)
	outline_style.set_border_width_all(2)
	outline_style.set_corner_radius_all(6)
	admin_overlay_text_outline.add_theme_stylebox_override("panel", outline_style)

	admin_overlay_text_rotate_stem = ColorRect.new()
	admin_overlay_text_rotate_stem.color = Color(0.32, 0.84, 1.0, 0.82)
	admin_overlay_text_rotate_stem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	admin_overlay_text_rotate_stem.visible = false
	admin_overlay_text_label.add_child(admin_overlay_text_rotate_stem)

	admin_overlay_text_resize_handle = Panel.new()
	admin_overlay_text_resize_handle.mouse_filter = Control.MOUSE_FILTER_STOP
	admin_overlay_text_resize_handle.mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
	admin_overlay_text_resize_handle.visible = false
	admin_overlay_text_resize_handle.gui_input.connect(_on_admin_overlay_text_resize_handle_gui_input)
	admin_overlay_text_label.add_child(admin_overlay_text_resize_handle)
	var resize_style := StyleBoxFlat.new()
	resize_style.bg_color = Color(1.0, 0.85, 0.35, 1.0)
	resize_style.border_color = Color(0.0, 0.0, 0.0, 0.65)
	resize_style.set_border_width_all(1)
	resize_style.set_corner_radius_all(4)
	admin_overlay_text_resize_handle.add_theme_stylebox_override("panel", resize_style)

	admin_overlay_text_rotate_handle = Panel.new()
	admin_overlay_text_rotate_handle.mouse_filter = Control.MOUSE_FILTER_STOP
	admin_overlay_text_rotate_handle.mouse_default_cursor_shape = Control.CURSOR_CROSS
	admin_overlay_text_rotate_handle.visible = false
	admin_overlay_text_rotate_handle.gui_input.connect(_on_admin_overlay_text_rotate_handle_gui_input)
	admin_overlay_text_label.add_child(admin_overlay_text_rotate_handle)
	var rotate_style := StyleBoxFlat.new()
	rotate_style.bg_color = Color(1.0, 0.48, 0.56, 1.0)
	rotate_style.border_color = Color(0.0, 0.0, 0.0, 0.65)
	rotate_style.set_border_width_all(1)
	rotate_style.set_corner_radius_all(10)
	admin_overlay_text_rotate_handle.add_theme_stylebox_override("panel", rotate_style)
	_update_admin_overlay_text_edit_box()
	_set_admin_overlay_text_selected(false)
	_refresh_admin_overlay_text_controls()


func _on_admin_overlay_text_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			admin_overlay_text_dragging = true
			admin_overlay_text_drag_offset = event.global_position - admin_overlay_text_label.global_position
			_set_admin_overlay_text_selected(true)
			_refresh_admin_overlay_text_controls()
			admin_status_label.text = "Text selected. Drag, resize, rotate, or edit it from the admin panel."
			get_viewport().set_input_as_handled()
		else:
			admin_overlay_text_dragging = false
			get_viewport().set_input_as_handled()


func _on_admin_overlay_text_resize_handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			admin_overlay_text_resizing = true
			admin_overlay_text_dragging = false
			admin_overlay_text_rotating = false
			admin_overlay_text_resize_start_mouse = event.global_position
			admin_overlay_text_resize_start_font_size = admin_overlay_text_label.get_theme_font_size("font_size")
			_set_admin_overlay_text_selected(true)
			admin_status_label.text = "Resize the text with the corner handle."
			get_viewport().set_input_as_handled()
		else:
			admin_overlay_text_resizing = false
			get_viewport().set_input_as_handled()


func _on_admin_overlay_text_rotate_handle_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			admin_overlay_text_rotating = true
			admin_overlay_text_dragging = false
			admin_overlay_text_resizing = false
			var center := admin_overlay_text_label.global_position + admin_overlay_text_label.pivot_offset
			admin_overlay_text_rotate_offset = admin_overlay_text_label.rotation - (event.global_position - center).angle()
			_set_admin_overlay_text_selected(true)
			admin_status_label.text = "Rotate the text with the top handle."
			get_viewport().set_input_as_handled()
		else:
			admin_overlay_text_rotating = false
			get_viewport().set_input_as_handled()


func _move_admin_overlay_text(global_mouse_position: Vector2) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return

	var target_position := global_mouse_position - admin_overlay_text_drag_offset
	_set_admin_overlay_text_position(target_position)


func _resize_admin_overlay_text(global_mouse_position: Vector2) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return

	var delta := global_mouse_position - admin_overlay_text_resize_start_mouse
	var target_font_size := clampi(admin_overlay_text_resize_start_font_size + int(round((delta.x + delta.y) * 0.18)), 12, 180)
	admin_overlay_text_label.add_theme_font_size_override("font_size", target_font_size)
	admin_overlay_text_label.reset_size()
	_set_admin_overlay_text_position(admin_overlay_text_label.global_position)
	_refresh_admin_overlay_text_controls()


func _rotate_admin_overlay_text(global_mouse_position: Vector2) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return

	var center := admin_overlay_text_label.global_position + admin_overlay_text_label.pivot_offset
	admin_overlay_text_label.rotation = (global_mouse_position - center).angle() + admin_overlay_text_rotate_offset
	_refresh_admin_overlay_text_controls()


func _set_admin_overlay_text_position(target_position: Vector2) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return

	var viewport_rect := get_viewport_rect()
	var label_size := admin_overlay_text_label.size
	target_position.x = clampf(target_position.x, 8.0, maxf(8.0, viewport_rect.size.x - label_size.x - 8.0))
	target_position.y = clampf(target_position.y, 8.0, maxf(8.0, viewport_rect.size.y - label_size.y - 8.0))
	admin_overlay_text_label.global_position = target_position
	admin_overlay_text_label.pivot_offset = admin_overlay_text_label.size * 0.5
	_update_admin_overlay_text_edit_box()


func _update_admin_overlay_text_edit_box() -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return

	admin_overlay_text_label.pivot_offset = admin_overlay_text_label.size * 0.5
	if is_instance_valid(admin_overlay_text_outline):
		admin_overlay_text_outline.position = Vector2(-8.0, -8.0)
		admin_overlay_text_outline.size = admin_overlay_text_label.size + Vector2(16.0, 16.0)
	if is_instance_valid(admin_overlay_text_resize_handle):
		admin_overlay_text_resize_handle.position = admin_overlay_text_label.size + Vector2(2.0, 2.0)
		admin_overlay_text_resize_handle.size = Vector2(16.0, 16.0)
	if is_instance_valid(admin_overlay_text_rotate_stem):
		admin_overlay_text_rotate_stem.position = Vector2((admin_overlay_text_label.size.x * 0.5) - 1.0, -26.0)
		admin_overlay_text_rotate_stem.size = Vector2(2.0, 18.0)
	if is_instance_valid(admin_overlay_text_rotate_handle):
		admin_overlay_text_rotate_handle.position = Vector2((admin_overlay_text_label.size.x * 0.5) - 8.0, -38.0)
		admin_overlay_text_rotate_handle.size = Vector2(16.0, 16.0)


func _on_admin_add_clicks_pressed() -> void:
	var amount := _get_admin_click_amount()
	var added_amount := _add_score(amount)
	_update_score()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Added %s clicks." % _format_number(added_amount)


func _on_admin_add_coins_pressed() -> void:
	var amount := _get_admin_amount(admin_coin_spinbox)
	var added_amount := _add_coins(amount)
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Added %s kibbles." % _format_number(added_amount)


func _on_admin_reset_clicks_pressed() -> void:
	score_counter.set_zero()
	score = 0
	combo_bonus = 0.0
	combo_drain_elapsed = 0.0
	combo_grace_left = 0.0
	combo_clicks_toward_step = 0
	recent_bonus_clicks.clear()
	if combo_timer != null:
		combo_timer.stop()
	_update_score()
	_update_combo_ui()
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Clicks reset to 0."


func _on_admin_reset_coins_pressed() -> void:
	coins_counter.set_zero()
	best_coin_balance_counter.set_zero()
	coins = 0
	best_coin_balance = 0
	_update_coins(false)
	_update_upgrade_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Kibbles reset to 0."


func _on_admin_reset_upgrades_pressed() -> void:
	unlocked_click_value = 1
	click_value = 1
	bonus_chance_level = 1
	bonus_value_index = 0
	bonus_streak_multiplier = MIN_BONUS_STREAK_MULTIPLIER
	passive_clicks_per_minute = 1
	for raw_upgrade_data in EXTENDED_UPGRADE_DATA:
		var upgrade_data: Dictionary = raw_upgrade_data
		extended_upgrade_levels[String(upgrade_data["id"])] = 0
	combo_bonus = minf(combo_bonus, get_effective_combo_cap())
	_update_score()
	_update_coins(false)
	_update_combo_ui()
	_update_upgrade_ui()
	_update_daily_reward_ui()
	_update_achievements_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Upgrades reset."


func _on_admin_reset_skins_pressed() -> void:
	owned_skin_ids.clear()
	equipped_skin_id = DEFAULT_SKIN_ID
	_apply_equipped_skin()
	_update_upgrade_ui()
	_update_skins_ui()
	_update_daily_reward_ui()
	_update_stats_ui()
	_queue_save()
	admin_status_label.text = "Skins reset to Classic Cat."


func _on_admin_set_text_pressed() -> void:
	var custom_text := admin_text_edit.text.strip_edges()
	if custom_text.is_empty():
		admin_status_label.text = "Write something first."
		return
	_ensure_admin_overlay_text_label()
	var current_position := admin_overlay_text_label.global_position
	admin_overlay_text_label.text = custom_text
	admin_overlay_text_label.reset_size()
	_set_admin_overlay_text_position(current_position)
	_set_admin_overlay_text_selected(true)
	admin_status_label.text = "Custom text placed in game. Drag it to move."


func _on_admin_clear_text_pressed() -> void:
	admin_text_edit.text = ""
	if is_instance_valid(admin_overlay_text_label):
		admin_overlay_text_label.queue_free()
		admin_overlay_text_label = null
	admin_overlay_text_dragging = false
	admin_overlay_text_drag_offset = Vector2.ZERO
	admin_overlay_text_resizing = false
	admin_overlay_text_rotating = false
	_set_admin_overlay_text_selected(false)
	admin_status_label.text = ""


func _on_admin_text_submitted(_text: String) -> void:
	_on_admin_set_text_pressed()


func _on_admin_text_size_changed(value: float) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return
	admin_overlay_text_label.add_theme_font_size_override("font_size", int(round(value)))
	admin_overlay_text_label.reset_size()
	_set_admin_overlay_text_position(admin_overlay_text_label.global_position)
	admin_status_label.text = "Text size updated."


func _on_admin_text_rotation_changed(value: float) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return
	admin_overlay_text_label.rotation = deg_to_rad(value)
	_refresh_admin_overlay_text_controls()
	admin_status_label.text = "Text rotation updated."


func _on_admin_text_color_changed(color: Color) -> void:
	if not is_instance_valid(admin_overlay_text_label):
		return
	admin_overlay_text_label.add_theme_color_override("font_color", color)
	admin_status_label.text = "Text color updated."
