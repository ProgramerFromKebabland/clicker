extends Control

const ClickLogic = preload("res://scripts/systems/click_logic.gd")
const UpgradeLogic = preload("res://scripts/systems/upgrade_logic.gd")
const AchievementLogic = preload("res://scripts/systems/achievement_logic.gd")
const SaveLogic = preload("res://scripts/systems/save_logic.gd")
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
const SAVE_EQUIPPED_ROOM_SKIN_KEY := "equipped_room_skin"
const SAVE_EXTENDED_UPGRADES_KEY := "extended_upgrades"
const SAVE_TUTORIAL_COMPLETED_KEY := "tutorial_completed"
const SAVE_095_BALANCE_MIGRATION_KEY := "migration_095_balance_applied"
const UPDATE_095_RESOURCE_CAP := 100000000
const ADMIN_MIN_AMOUNT := 1
const ADMIN_MAX_AMOUNT := 1000000000
const ADMIN_CLICK_SOFT_MAX := 1000000000000
const MAX_RESOURCE_VALUE := 1000000000000000
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
const MAX_COMBO_MOMENTUM_LEVEL := 5
const MAX_OFFLINE_STORAGE_LEVEL := 5
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
const EXTENDED_UPGRADE_DATA: Array[Dictionary] = [
	{"id": "tap_mastery", "badge": "TAP+", "name": "TAP MASTERY", "accent": Color(0.22, 0.86, 0.92, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 2500},
	{"id": "combo_capacity", "badge": "CAP", "name": "COMBO CAPACITY", "accent": Color(0.72, 0.46, 1.0, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 4000},
	{"id": "combo_momentum", "badge": "FLOW", "name": "COMBO MOMENTUM", "accent": Color(1.0, 0.48, 0.72, 1.0), "max_level": MAX_COMBO_MOMENTUM_LEVEL, "base_cost": 6500},
	{"id": "daily_feast", "badge": "DAY", "name": "DAILY FEAST", "accent": Color(1.0, 0.58, 0.22, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 5000},
	{"id": "offline_storage", "badge": "TIME", "name": "OFFLINE STORAGE", "accent": Color(0.38, 0.72, 1.0, 1.0), "max_level": MAX_OFFLINE_STORAGE_LEVEL, "base_cost": 10000},
	{"id": "kibble_alchemy", "badge": "ALL+", "name": "KIBBLE ALCHEMY", "accent": Color(0.35, 1.0, 0.68, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 18000},
	{"id": "lucky_whiskers", "badge": "LUCK+", "name": "LUCKY WHISKERS", "accent": Color(1.0, 0.75, 0.22, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 22000},
	{"id": "dream_engine", "badge": "IDLE+", "name": "DREAM ENGINE", "accent": Color(0.42, 0.68, 1.0, 1.0), "max_level": MAX_EXTENDED_UPGRADE_LEVEL, "base_cost": 30000},
]
const MAX_COIN_PARTICLES := 18
const UPGRADE_ALERT_SHAKE_INTERVAL := 3.0
const ACHIEVEMENT_REFRESH_INTERVAL := 0.75
const TUTORIAL_STARTER_GOAL := 10
const TUTORIAL_STARTER_REWARD := 90
const TUTORIAL_CARD_MAX_WIDTH := 520.0
const TUTORIAL_STEPS: Array[Dictionary] = [
	{"title": "Grow your kibble pile", "body": "Your goal is simple: tap, earn kibbles, buy upgrades, and reach bigger milestones.", "target": "cat", "wait_for": "continue"},
	{"title": "Tap the cat", "body": "Each tap earns kibbles. Try a few taps now.", "target": "cat", "wait_for": "cat_clicks", "count": 3},
	{"title": "Watch your wallet", "body": "Kibbles fly into this bowl. This is what you spend on upgrades.", "target": "wallet", "wait_for": "continue"},
	{"title": "Reach your first goal", "body": "Earn 10 kibbles. Small goals help you know what to do next.", "target": "wallet", "wait_for": "coins_goal", "amount": TUTORIAL_STARTER_GOAL},
	{"title": "Open upgrades", "body": "Upgrades make every tap stronger. Open the upgrade panel.", "target": "upgrade_button", "wait_for": "upgrades_opened"},
	{"title": "Buy click power", "body": "Buy click power if it is available. If you already own it all, you can keep going.", "target": "buy_click_power", "wait_for": "upgrade_or_continue"},
	{"title": "Upgrade families", "body": "Luck, bonus power, streaks, offline income, and extra upgrades all improve progress in different ways.", "target": "bonus_chance", "wait_for": "continue"},
	{"title": "Feel the upgrade", "body": "Tap again. Stronger upgrades make each tap and bonus more valuable.", "target": "cat", "wait_for": "powered_click"},
	{"title": "Build a combo", "body": "Tapping several times in a row builds flow. Keep tapping to make short bursts stronger.", "target": "cat", "wait_for": "cat_clicks", "count": 5},
	{"title": "Open the pause menu", "body": "Tap the pause button. This is where settings, stats, achievements, and replay tutorial live.", "target": "menu_button", "wait_for": "menu_opened"},
	{"title": "Replay lives here", "body": "You can restart this tutorial from the pause menu any time. Use it if you forget a system later.", "target": "pause_replay", "wait_for": "continue"},
	{"title": "Open skins", "body": "Now open the skins menu. Skins add bonuses and give you something fun to collect.", "target": "skins_button", "wait_for": "skins_opened"},
	{"title": "Keep chasing milestones", "body": "After the tutorial, save kibbles, buy the next useful upgrade, claim rewards, and push for bigger numbers.", "target": "upgrade_button", "wait_for": "continue"},
]
const TAP_BURST_COLORS := [
	Color(1.0, 0.88, 0.33, 0.95),
	Color(1.0, 1.0, 1.0, 0.9),
	Color(0.42, 0.86, 1.0, 0.9),
]
const DEFAULT_SKIN_ID := "classic"
const SKIN_ACCENT := Color(0.36, 0.82, 1.0, 1.0)
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
	{"id": "angelic", "name": "Angelic Cat", "cost": 100000, "texture": "res://assets/skins/angelic_cat.png", "bonus_text": "+35% daily reward", "bonus": {"daily_reward_mult": 1.35}},
	{"id": "banana", "name": "Banana Cat", "cost": 123456, "texture": "res://assets/skins/banana_cat.png", "bonus_text": "+35% all kibble gain", "bonus": {"all_gain_mult": 1.35}},
	{"id": "demoniac", "name": "Demoniac Cat", "cost": 125000, "texture": "res://assets/skins/demoniac_cat.png", "bonus_text": "+2.0% bonus luck", "bonus": {"bonus_chance_bonus": 2.0}},
	{"id": "sushi", "name": "Sushi Cat", "cost": 195000, "texture": "res://assets/skins/sushi_cat.png", "bonus_text": "+45% daily reward, +2 offline/min", "bonus": {"daily_reward_mult": 1.45, "passive_gain_bonus": 2}},
	{"id": "taco", "name": "Taco Cat", "cost": 444444, "texture": "res://assets/skins/taco_cat.png", "bonus_text": "+50% tap gain, +40% bonus payout", "bonus": {"click_gain_mult": 1.50, "bonus_value_mult": 1.40}},
	{"id": "businessman", "name": "Businessman Cat", "cost": 1000000, "texture": "res://assets/skins/businessman_cat.png", "bonus_text": "+30% all kibble gain", "bonus": {"all_gain_mult": 1.30}},
	{"id": "bronze", "name": "Bronze Cat", "cost": 25000000, "texture": "res://assets/skins/bronze_cat.png", "bonus_text": "+80% all gain, +2.5% bonus luck", "bonus": {"all_gain_mult": 1.80, "bonus_chance_bonus": 2.5}},
	{"id": "silver", "name": "Silver Cat", "cost": 50000000, "texture": "res://assets/skins/silver_cat.png", "bonus_text": "+120% all gain, +6 offline/min", "bonus": {"all_gain_mult": 2.20, "passive_gain_bonus": 6}},
	{"id": "gold", "name": "Gold Cat", "cost": 100000000, "texture": "res://assets/skins/gold_cat.png", "bonus_text": "+180% all gain, +60% bonus payout", "bonus": {"all_gain_mult": 2.80, "bonus_value_mult": 1.60}},
	{"id": "rainbow", "name": "Rainbow Cat", "cost": 500000000, "texture": "res://assets/skins/rainbow_cat.png", "bonus_text": "+300% all gain, +5% luck, +1 streak, +75% daily reward", "bonus": {"all_gain_mult": 4.00, "bonus_chance_bonus": 5.0, "streak_bonus": 1, "daily_reward_mult": 1.75}},
]
const SPECIAL_SPARKLE_SKIN_IDS := ["bronze", "silver", "gold", "rainbow"]
const SKIN_SET_DATA: Array[Dictionary] = [
	{"id": "food", "name": "Food Cats", "icon": "🍔", "members": ["banana", "burger", "cheese", "coffee", "cookie", "donut", "ice_cream", "kebab", "pizza", "popcorn", "sushi", "taco", "watermelon"], "bonus_text": "+25% all kibble gain", "bonus": {"all_gain_mult": 1.25}, "accent": Color(1.0, 0.62, 0.24, 1.0)},
	{"id": "cosmic", "name": "Cosmic Cats", "icon": "✦", "members": ["alien", "galaxy", "void"], "bonus_text": "+3% bonus luck", "bonus": {"bonus_chance_bonus": 3.0}, "accent": Color(0.58, 0.45, 1.0, 1.0)},
	{"id": "military", "name": "Military Cats", "icon": "★", "members": ["military", "commando", "commando_hacker"], "bonus_text": "+35% tap gain", "bonus": {"click_gain_mult": 1.35}, "accent": Color(0.42, 0.72, 0.38, 1.0)},
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
var equipped_room_skin_id := DEFAULT_ROOM_SKIN_ID
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
var touch_slider_index := -1
var touch_slider: HSlider
var app_backgrounded_at_unix := 0
var app_was_backgrounded := false
var skins_button: Button
var skins_panel: PanelContainer
var skins_wallet_label: Label
var skins_status_label: Label
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
var modal_close_button: Button
var modal_decorations: Array[Control] = []
var combo_was_running_before_overlay := false
var combo_time_left_before_overlay := 0.0
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


func _ready() -> void:
	set_process(false)
	get_tree().auto_accept_quit = false
	randomize()
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
	_build_extended_upgrades_ui()
	_build_skins_ui()
	_build_boosts_ui()
	_build_museum_ui()
	bottomless_bowl_logic.build_ui()
	_build_bottomless_bowl_button()
	# Still available inside the museum, without a second main-HUD button.
	bottomless_bowl_button.hide()
	crate_logic.build_ui()
	mission_logic.build_ui()
	random_event_logic.build_ui()
	_apply_equipped_skin()
	_apply_equipped_room_skin()
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
	achievement_tracking_ready = true
	_apply_volume()
	last_cat_press_global_position = cat_button.get_global_rect().get_center()
	cat_button.button_down.connect(_on_cat_pressed)
	menu_button.pressed.connect(_show_menu)
	skins_button.pressed.connect(_show_skins)
	boosts_button.pressed.connect(_show_boosts)
	crate_logic.button.pressed.connect(_show_crates)
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
	resume_button.pressed.connect(_hide_menu)
	exit_button.pressed.connect(_exit_game)
	skins_back_button.pressed.connect(_hide_menu)
	boosts_back_button.pressed.connect(_hide_menu)
	_setup_ui_animations(self)
	_build_admin_panel()
	_prepare_mobile_panels()
	_setup_modal_navigation()
	_apply_mobile_layout()
	menu_overlay.hide()
	call_deferred("_show_startup_popups")
	call_deferred("_maybe_start_first_time_tutorial")
	set_process(true)


func _process(delta: float) -> void:
	if boost_logic != null:
		boost_logic.process(delta)
	if mission_logic != null:
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
		return

	if event.is_action_pressed("ui_cancel"):
		_hide_menu()
		get_viewport().set_input_as_handled()
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if _should_close_overlay_at(event.position):
			_hide_menu()
			get_viewport().set_input_as_handled()
			return

	if event is InputEventScreenTouch:
		if event.pressed:
			if _should_close_overlay_at(event.position):
				_hide_menu()
				get_viewport().set_input_as_handled()
				return
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
	progress_bar.tooltip_text = "Complete" if maxed else "%s / %s kibbles" % [_format_number(coins), _format_number(cost)]


func _setup_main_ui_visuals() -> void:
	room_background.tooltip_text = "Your cat's gem lounge"
	score_label.add_theme_color_override("font_color", Color(0.94, 0.98, 1.0, 1.0))
	score_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.14, 0.28, 0.9))
	score_label.add_theme_constant_override("shadow_offset_x", 2)
	score_label.add_theme_constant_override("shadow_offset_y", 3)
	score_label.add_theme_stylebox_override(
		"normal",
		_make_upgrade_style(Color(0.015, 0.035, 0.065, 0.72), Color(0.28, 0.84, 0.95, 0.44), 18, 1, -1, 8)
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
	skins_status_label.text = "Find a cat's gem in crates, then equip the skin."
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
	coin_icon.texture = CrateLogic.GEM_FRAME
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

	var skin_columns := HBoxContainer.new()
	skin_columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	skin_columns.add_theme_constant_override("separation", 10)
	items.add_child(skin_columns)
	skin_columns.add_child(skins_scroll)

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

	room_skins_scroll = ScrollContainer.new()
	room_skins_scroll.custom_minimum_size = Vector2(168.0, 720.0)
	room_skins_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_configure_touch_scroll(room_skins_scroll)
	skin_columns.add_child(room_skins_scroll)

	room_skins_list = VBoxContainer.new()
	room_skins_list.custom_minimum_size = Vector2(158.0, 0.0)
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


func _build_museum_ui() -> void:
	museum_button = Button.new()
	museum_button.name = "MuseumButton"
	museum_button.text = "MUSEUM"
	museum_button.tooltip_text = "Visit your evolving collection museum"
	museum_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	museum_button.grow_horizontal = Control.GROW_DIRECTION_BEGIN
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
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 18)
	museum_panel.add_child(margin)
	var root := VBoxContainer.new()
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
	bottomless_bowl_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	bottomless_bowl_button.grow_horizontal = Control.GROW_DIRECTION_BEGIN
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
	title.text = text
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", accent)
	section.add_child(title)
	var detail := Label.new()
	detail.text = subtitle
	detail.add_theme_font_size_override("font_size", 14)
	detail.add_theme_color_override("font_color", Color(0.72, 0.72, 0.7, 1.0))
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	section.add_child(detail)
	return section


func _museum_plaque(text: String, accent: Color, locked: bool = false) -> PanelContainer:
	var plaque := PanelContainer.new()
	plaque.custom_minimum_size = Vector2(190.0, 82.0)
	plaque.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	plaque.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent if not locked else Color(0.28, 0.29, 0.32, 1.0), false))
	var label := Label.new()
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
	hero.add_theme_stylebox_override("panel", _make_upgrade_style(Color(0.12 + room_tier * 0.025, 0.075, 0.035, 1.0), Color(0.78 + room_tier * 0.05, 0.48 + room_tier * 0.06, 0.2, 1.0), 18, 2, 4, 8))
	museum_content.add_child(hero)
	var hero_label := Label.new()
	hero_label.text = "THE CAT MUSEUM\n%s  •  ROOM LEVEL %d\n%d%% COMPLETE" % [room_names[room_tier], room_tier, int(round(completion * 100.0))]
	hero_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_label.add_theme_font_size_override("font_size", 25)
	hero_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.52, 1.0))
	hero_label.custom_minimum_size = Vector2(0.0, 126.0)
	hero_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hero.add_child(hero_label)

	var bowl_button := Button.new()
	bowl_button.text = "VISIT THE BOTTOMLESS CAT BOWL"
	bowl_button.custom_minimum_size = Vector2(0.0, 64.0)
	bowl_button.add_theme_font_size_override("font_size", 18)
	_style_upgrade_button(bowl_button, Color(0.82, 0.38, 0.72, 1.0))
	museum_content.add_child(bowl_button)
	bowl_button.pressed.connect(_show_bottomless_bowl)

	var cat_section := _add_museum_title("CAT GALLERY", "%d / %d portraits on display" % [found_cats, SKIN_DATA.size()], Color(0.4, 0.84, 1.0, 1.0))
	var cat_grid := GridContainer.new()
	cat_grid.columns = 4
	cat_grid.add_theme_constant_override("h_separation", 8)
	cat_grid.add_theme_constant_override("v_separation", 8)
	cat_section.add_child(cat_grid)
	for skin_data in SKIN_DATA:
		var owned := _owns_skin(String(skin_data["id"]))
		var portrait := PanelContainer.new()
		portrait.custom_minimum_size = Vector2(126.0, 136.0)
		portrait.add_theme_stylebox_override("panel", _make_upgrade_card_style(SKIN_ACCENT if owned else Color(0.22, 0.23, 0.26, 1.0), false))
		var stack := VBoxContainer.new()
		portrait.add_child(stack)
		var image := TextureRect.new()
		image.custom_minimum_size = Vector2(108.0, 100.0)
		image.texture = load(String(skin_data["texture"])) as Texture2D if owned else null
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		stack.add_child(image)
		var cat_name := Label.new()
		cat_name.text = String(skin_data["name"]) if owned else "UNDISCOVERED"
		cat_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cat_name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		cat_name.add_theme_font_size_override("font_size", 11)
		stack.add_child(cat_name)
		cat_grid.add_child(portrait)

	var treasure_section := _add_museum_title("TREASURE VAULT", "%d / 4 crate relics recovered" % treasures, Color(1.0, 0.72, 0.24, 1.0))
	var treasure_grid := GridContainer.new()
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


func _build_boosts_ui() -> void:
	boosts_button = Button.new()
	boosts_button.name = "BoostsButton"
	boosts_button.text = "BOOSTS"
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
		_make_upgrade_style(Color(0.035, 0.043, 0.065, 0.99), Color(0.58, 0.34, 0.9, 1.0), 24, 2, -1, 18)
	)

	var outer_margin := MarginContainer.new()
	outer_margin.add_theme_constant_override("margin_left", 18)
	outer_margin.add_theme_constant_override("margin_top", 18)
	outer_margin.add_theme_constant_override("margin_right", 18)
	outer_margin.add_theme_constant_override("margin_bottom", 18)
	boosts_panel.add_child(outer_margin)

	var items := VBoxContainer.new()
	items.add_theme_constant_override("separation", 12)
	outer_margin.add_child(items)

	var header := PanelContainer.new()
	header.add_theme_stylebox_override(
		"panel",
		_make_upgrade_style(Color(0.09, 0.055, 0.16, 1.0), Color(0.72, 0.48, 1.0, 0.78), 18, 2, 5, 8)
	)
	items.add_child(header)

	var header_margin := MarginContainer.new()
	header_margin.add_theme_constant_override("margin_left", 18)
	header_margin.add_theme_constant_override("margin_top", 12)
	header_margin.add_theme_constant_override("margin_right", 18)
	header_margin.add_theme_constant_override("margin_bottom", 12)
	header.add_child(header_margin)

	var header_items := VBoxContainer.new()
	header_items.add_theme_constant_override("separation", 3)
	header_margin.add_child(header_items)

	var title := Label.new()
	title.text = "BOOSTS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 1.0, 1.0))
	header_items.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "NORMAL price, DOUBLE +50%, TRIPLE +100%"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.68, 0.6, 0.82, 1.0))
	header_items.add_child(subtitle)

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

	boost_wallet_label = Label.new()
	boost_wallet_label.add_theme_font_size_override("font_size", 22)
	boost_wallet_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.46, 1.0))
	wallet_row.add_child(boost_wallet_label)

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

	boosts_back_button = Button.new()
	boosts_back_button.text = "BACK TO GAME"
	boosts_back_button.custom_minimum_size = Vector2(0.0, 56.0)
	boosts_back_button.add_theme_font_size_override("font_size", 20)
	_style_upgrade_button(boosts_back_button, Color(0.42, 0.5, 0.66, 1.0))
	items.add_child(boosts_back_button)
	boost_logic.update_ui()


func _add_boost_card(boost_data: Dictionary) -> void:
	var boost_id := String(boost_data["id"])
	var accent := boost_data["accent"] as Color
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0.0, 218.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
	card.mouse_entered.connect(_set_upgrade_card_hover.bind(card, accent, true))
	card.mouse_exited.connect(_set_upgrade_card_hover.bind(card, accent, false))
	boosts_list.add_child(card)
	boost_cards[boost_id] = card

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var card_items := VBoxContainer.new()
	card_items.add_theme_constant_override("separation", 7)
	margin.add_child(card_items)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	card_items.add_child(header)

	var badge := Label.new()
	badge.text = String(boost_data["badge"])
	badge.custom_minimum_size = Vector2(64.0, 30.0)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 13)
	badge.add_theme_color_override("font_color", accent.lightened(0.18))
	badge.add_theme_stylebox_override(
		"normal",
		_make_upgrade_style(Color(accent.r, accent.g, accent.b, 0.14), Color(accent.r, accent.g, accent.b, 0.55), 8, 1)
	)
	header.add_child(badge)

	var name_label := Label.new()
	name_label.text = String(boost_data["name"])
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 19)
	name_label.add_theme_color_override("font_color", accent.lightened(0.25))
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(name_label)

	var status_label := Label.new()
	status_label.text = "READY TO ACTIVATE"
	status_label.add_theme_font_size_override("font_size", 13)
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(status_label)
	boost_status_labels[boost_id] = status_label

	var description := Label.new()
	description.text = String(boost_data["description"])
	description.add_theme_font_size_override("font_size", 15)
	description.add_theme_color_override("font_color", Color(0.78, 0.83, 0.91, 1.0))
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_items.add_child(description)

	var duration := float(boost_data["duration"])
	var tier_info := Label.new()
	if duration > 0.0:
		tier_info.text = "TIME: %ds  |  %ds  |  %ds" % [roundi(duration), roundi(duration * 2.0), roundi(duration * 3.0)]
	elif boost_id == "nine_lives":
		tier_info.text = "TAPS: 3  |  6  |  9"
	else:
		tier_info.text = "NORMAL  |  DOUBLE  |  TRIPLE"
	tier_info.add_theme_font_size_override("font_size", 13)
	tier_info.add_theme_color_override("font_color", Color(0.58, 0.64, 0.74, 1.0))
	card_items.add_child(tier_info)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	card_items.add_child(actions)

	var buttons: Array[Button] = []
	for tier in range(1, 4):
		var action := Button.new()
		action.custom_minimum_size = Vector2(0.0, 58.0)
		action.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		action.add_theme_font_size_override("font_size", 14)
		action.pressed.connect(boost_logic.purchase.bind(boost_id, tier))
		_style_upgrade_button(action, accent)
		actions.add_child(action)
		buttons.append(action)
	boost_action_buttons[boost_id] = buttons


func _add_skin_card(skin_data: Dictionary) -> void:
	var skin_id := String(skin_data["id"])
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(0.0, 214.0)
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
	card.custom_minimum_size = Vector2(0.0, 116.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
	skins_list.add_child(card)

	var margin := MarginContainer.new()
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 12)
	card.add_child(margin)

	var row := HBoxContainer.new()
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
	card.custom_minimum_size = Vector2(152.0, 184.0)
	card.add_theme_stylebox_override("panel", _make_upgrade_card_style(accent, false))
	room_skins_list.add_child(card)
	var margin := MarginContainer.new()
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 7)
	card.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 5)
	margin.add_child(content)
	var preview := TextureRect.new()
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
	var upgrade_multiplier := 1.0 + (0.03 * get_extended_upgrade_level("kibble_alchemy"))
	var bowl_multiplier: float = bottomless_bowl_logic.get_gain_multiplier() if bottomless_bowl_logic != null else 1.0
	return float(bonus_data.get("all_gain_mult", 1.0)) * _get_skin_set_bonus_value("all_gain_mult", 1.0) * gem_multiplier * boost_multiplier * event_multiplier * upgrade_multiplier * bowl_multiplier


func _get_click_gain_multiplier() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("click_gain_mult", 1.0)) * _get_skin_set_bonus_value("click_gain_mult", 1.0) * (1.0 + (0.05 * get_extended_upgrade_level("tap_mastery")))


func _get_daily_reward_multiplier() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("daily_reward_mult", 1.0)) * (1.0 + (0.10 * get_extended_upgrade_level("daily_feast")))


func _get_bonus_chance_bonus_percent() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("bonus_chance_bonus", 0.0)) + _get_skin_set_bonus_value("bonus_chance_bonus", 0.0) + (0.5 * get_extended_upgrade_level("lucky_whiskers"))


func _get_bonus_value_multiplier_bonus() -> float:
	var bonus_data := _get_equipped_skin_bonus_data()
	return float(bonus_data.get("bonus_value_mult", 1.0))


func _get_streak_bonus() -> int:
	var bonus_data := _get_equipped_skin_bonus_data()
	return int(bonus_data.get("streak_bonus", 0))


func _get_passive_gain_bonus() -> int:
	var bonus_data := _get_equipped_skin_bonus_data()
	return int(bonus_data.get("passive_gain_bonus", 0))


func _get_effective_passive_gain() -> int:
	var base_gain := passive_clicks_per_minute + _get_passive_gain_bonus()
	return maxi(1, roundi(float(base_gain) * (1.0 + 0.1 * get_extended_upgrade_level("dream_engine"))))


func get_extended_upgrade_level(upgrade_id: String) -> int:
	return int(extended_upgrade_levels.get(upgrade_id, 0))


func get_effective_combo_cap() -> float:
	return MAX_COMBO_BONUS + (0.1 * get_extended_upgrade_level("combo_capacity"))


func get_effective_combo_taps_per_step(base_taps: int) -> int:
	return maxi(1, base_taps - get_extended_upgrade_level("combo_momentum"))


func get_offline_gain_max_seconds() -> int:
	return OFFLINE_GAIN_MAX_SECONDS + (get_extended_upgrade_level("offline_storage") * 60 * 60)


func _apply_skin_gain_bonus(amount: int, gain_type: String) -> int:
	if amount <= 0:
		return 0
	var total := float(amount) * _get_global_gain_multiplier()
	match gain_type:
		"click":
			total *= _get_click_gain_multiplier()
		"daily_reward":
			total *= _get_daily_reward_multiplier()
	return maxi(1, roundi(total))


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
	if menu_overlay.visible or not _has_special_skin_sparkles():
		special_skin_sparkle_elapsed = 0.0
		return

	special_skin_sparkle_elapsed += delta
	var spawn_interval := 0.28 if equipped_skin_id == "rainbow" else 0.34
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
	var sparkle_count := 2

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
	slider.mouse_filter = Control.MOUSE_FILTER_STOP
	slider.focus_mode = Control.FOCUS_NONE
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


func _handle_slider_touch(event: InputEvent) -> bool:
	if event is InputEventScreenTouch:
		if event.pressed:
			for slider in [click_power_slider, click_volume_slider, ui_volume_slider]:
				if is_instance_valid(slider) and slider.is_visible_in_tree() and slider.get_global_rect().has_point(event.position):
					touch_slider = slider
					touch_slider_index = event.index
					_set_slider_from_touch(slider, event.position)
					return true
		elif event.index == touch_slider_index:
			touch_slider_index = -1
			touch_slider = null
			return true
	elif event is InputEventScreenDrag and event.index == touch_slider_index:
		if is_instance_valid(touch_slider):
			_set_slider_from_touch(touch_slider, event.position)
		return true
	return false


func _set_slider_from_touch(slider: HSlider, global_position: Vector2) -> void:
	var rect := slider.get_global_rect()
	if rect.size.x <= 0.0:
		return
	var ratio := clampf((global_position.x - rect.position.x) / rect.size.x, 0.0, 1.0)
	slider.value = lerpf(slider.min_value, slider.max_value, ratio)


func _build_extended_upgrades_ui() -> void:
	var back_index := upgrades_back_button.get_index()
	for upgrade_data in EXTENDED_UPGRADE_DATA:
		var card := _create_extended_upgrade_card(upgrade_data)
		upgrades_items.add_child(card)
		upgrades_items.move_child(card, back_index)
		back_index += 1


func _create_extended_upgrade_card(upgrade_data: Dictionary) -> PanelContainer:
	var upgrade_id := String(upgrade_data["id"])
	var accent := upgrade_data["accent"] as Color
	var card := PanelContainer.new()
	card.name = "%sCard" % upgrade_id.to_pascal_case()

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_top", 11)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var items := VBoxContainer.new()
	items.add_theme_constant_override("separation", 5)
	margin.add_child(items)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	items.add_child(header)

	var badge := Label.new()
	badge.custom_minimum_size = Vector2(62, 30)
	badge.text = String(upgrade_data["badge"])
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 13)
	header.add_child(badge)

	var title := Label.new()
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
	tutorial_step_completing = false
	tutorial_highlight.show()
	tutorial_arrow.show()
	tutorial_reward_given = tutorial_completed and force_replay
	tutorial_overlay.show()
	_advance_tutorial()


func _skip_tutorial() -> void:
	_finish_tutorial(true)


func _replay_tutorial_from_settings() -> void:
	_play_ui_sound()
	_hide_menu()
	call_deferred("_show_tutorial_prompt", true)


func _on_tutorial_next_pressed() -> void:
	if tutorial_prompt_visible:
		_start_tutorial(tutorial_prompt_replay)
		return
	var step := _get_tutorial_step(tutorial_step_index)
	var wait_for := String(step.get("wait_for", ""))
	if wait_for == "continue" or wait_for == "upgrade_or_continue":
		_complete_tutorial_step()


func _tutorial_notify(event_name: String) -> void:
	if not tutorial_active:
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
		"skins_opened":
			if event_name == "skins_opened":
				_complete_tutorial_step()
		"upgrade_bought":
			if event_name == "upgrade_bought":
				_complete_tutorial_step()
		"upgrade_or_continue":
			if event_name == "upgrade_bought":
				_complete_tutorial_step()
		"powered_click":
			if event_name == "cat_clicked":
				_complete_tutorial_step()


func _advance_tutorial() -> void:
	tutorial_step_index += 1
	tutorial_clicks_this_step = 0
	tutorial_step_completing = false
	if tutorial_step_index >= _get_tutorial_step_count():
		_finish_tutorial(false)
		return
	_enter_tutorial_step()


func _complete_tutorial_step() -> void:
	if tutorial_step_completing or not tutorial_active:
		return
	tutorial_step_completing = true
	if tutorial_step_index == 3 and not tutorial_reward_given:
		tutorial_reward_given = true
		var added := _add_coins(TUTORIAL_STARTER_REWARD)
		_update_coins(true)
		_update_upgrade_ui()
		_show_tutorial_feedback("+%s starter kibbles" % _format_number(added))
		_play_bonus_sound()
	else:
		_show_tutorial_feedback("Step complete")
		_play_ui_sound()
	_advance_tutorial()


func _finish_tutorial(skipped: bool) -> void:
	tutorial_prompt_visible = false
	tutorial_prompt_replay = false
	tutorial_active = false
	tutorial_step_index = -1
	tutorial_step_completing = false
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


func _enter_tutorial_step() -> void:
	var step := _get_tutorial_step(tutorial_step_index)
	var target_id := String(step.get("target", ""))
	var keep_overlay_open := target_id == "buy_click_power" or target_id == "bonus_chance" or target_id == "pause_replay"
	if not keep_overlay_open and menu_overlay.visible:
		_hide_menu()
	tutorial_target = _get_tutorial_target(target_id)
	_update_tutorial_text()
	_update_tutorial_layout()
	_animate_tutorial_card()
	_pulse_tutorial_highlight()


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
		body = _get_tutorial_upgrade_body()
	tutorial_progress_label.text = "STEP %d OF %d" % [tutorial_step_index + 1, _get_tutorial_step_count()]
	tutorial_title_label.text = String(step.get("title", ""))
	tutorial_body_label.text = body
	var wait_for := String(step.get("wait_for", ""))
	tutorial_next_button.visible = wait_for == "continue" or wait_for == "upgrade_or_continue"
	tutorial_next_button.text = "Finish" if tutorial_step_index == _get_tutorial_step_count() - 1 else "Got it"
	if String(step.get("wait_for", "")) == "coins_goal" and coins >= int(step.get("amount", 0)):
		call_deferred("_complete_tutorial_step_if_current", tutorial_step_index)


func _complete_tutorial_step_if_current(expected_step_index: int) -> void:
	if tutorial_step_index == expected_step_index:
		_complete_tutorial_step()


func _get_tutorial_upgrade_body() -> String:
	if unlocked_click_value >= MAX_CLICK_VALUE:
		return "Your click power is already maxed. That is exactly what upgrades are for: turning taps into much bigger gains."
	var next_value := unlocked_click_value + 1
	var upgrade_cost := _get_upgrade_cost(next_value)
	if coins >= upgrade_cost:
		return "Buy Click Power x%d now. It costs %s kibbles and makes every tap stronger." % [next_value, _format_number(upgrade_cost)]
	return "The next Click Power costs %s kibbles. In normal play, save up, open upgrades, and buy it when the button lights up." % _format_number(upgrade_cost)


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
		"menu_button":
			return menu_button
		"skins_button":
			return skins_button
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
	if is_instance_valid(tutorial_target) and tutorial_target.visible and tutorial_target.is_inside_tree():
		target_rect = tutorial_target.get_global_rect()
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


func _play_tap_haptic(is_bonus: bool) -> void:
	if not OS.has_feature("mobile"):
		return
	Input.vibrate_handheld(35 if is_bonus else 12, 0.72 if is_bonus else 0.28)


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
	var previous_tween: Tween
	if control.has_meta("scale_tween"):
		previous_tween = control.get_meta("scale_tween") as Tween
	if previous_tween != null and previous_tween.is_valid():
		previous_tween.kill()
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
	var tween := create_tween()
	tween.tween_property(control, "scale", target_scale, duration * 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(control, "scale", Vector2.ONE, duration * 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	control.set_meta("scale_tween", tween)


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
		exit_button,
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
	var items := skins_scroll.get_parent()
	for child in items.get_children():
		if child is Control and child.visible and child != skins_scroll:
			controls.append(child as Control)
	for child in skins_list.get_children():
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
		control.scale = Vector2(0.78, 0.78)
		control.rotation = -0.025 if index % 2 == 0 else 0.025
		control.modulate = Color(1.0, 1.0, 1.0, 0.0)
		entrance_controls.append(control)
		var delay := float(index) * delay_step
		var entrance_tween := create_tween().set_parallel(true)
		entrance_tweens.append(entrance_tween)
		entrance_tween.tween_property(control, "modulate:a", 1.0, 0.2).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		entrance_tween.tween_property(control, "scale", Vector2.ONE, 0.42).set_delay(delay).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		entrance_tween.tween_property(control, "rotation", 0.0, 0.34).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


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
	modal_close_button.text = "X"
	modal_close_button.tooltip_text = "Close (Esc)"
	modal_close_button.size = Vector2(48.0, 48.0)
	modal_close_button.custom_minimum_size = Vector2(48.0, 48.0)
	modal_close_button.flat = true
	modal_close_button.focus_mode = Control.FOCUS_NONE
	modal_close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	modal_close_button.z_index = 20
	modal_close_button.add_theme_font_size_override("font_size", 30)
	modal_close_button.add_theme_color_override("font_color", Color(1.0, 0.42, 0.52, 1.0))
	modal_close_button.add_theme_color_override("font_hover_color", Color(1.0, 0.72, 0.78, 1.0))
	modal_close_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	modal_close_button.add_theme_color_override("font_shadow_color", Color(0.5, 0.0, 0.08, 0.72))
	modal_close_button.add_theme_constant_override("shadow_offset_x", 0)
	modal_close_button.add_theme_constant_override("shadow_offset_y", 2)
	var empty_button_style := StyleBoxEmpty.new()
	for style_name in ["normal", "hover", "pressed", "focus", "disabled"]:
		modal_close_button.add_theme_stylebox_override(style_name, empty_button_style)
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


func _should_close_overlay_at(global_position: Vector2) -> bool:
	if is_instance_valid(admin_panel) and admin_panel.visible and admin_panel.get_global_rect().has_point(global_position):
		return false
	var visible_panel := _get_visible_overlay_panel()
	return visible_panel != null and not visible_panel.get_global_rect().has_point(global_position)


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


func _get_visible_menu_scroll() -> ScrollContainer:
	if stats_panel.visible:
		return stats_cards.get_parent() as ScrollContainer
	if skins_panel.visible:
		return skins_scroll
	if boosts_panel.visible:
		return boosts_scroll
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
	_set_responsive_panel_size(menu_panel, Vector2(510.0, 760.0), panel_width, panel_height)
	_set_responsive_panel_size(settings_panel, Vector2(560.0, 920.0), panel_width, panel_height)
	_set_responsive_panel_size(upgrades_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(achievements_panel, Vector2(520.0, 620.0), panel_width, panel_height)
	_set_responsive_panel_size(stats_panel, Vector2(610.0, 900.0), panel_width, panel_height)
	_set_responsive_panel_size(skins_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(boosts_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	_set_responsive_panel_size(museum_panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	if bottomless_bowl_logic != null and is_instance_valid(bottomless_bowl_logic.panel):
		_set_responsive_panel_size(bottomless_bowl_logic.panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	if crate_logic != null and is_instance_valid(crate_logic.panel):
		_set_responsive_panel_size(crate_logic.panel, Vector2(640.0, 1080.0), panel_width, panel_height)
	if mission_logic != null and is_instance_valid(mission_logic.panel):
		_set_responsive_panel_size(mission_logic.panel, Vector2(640.0, 920.0), panel_width, panel_height)

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
	game_layer.add_theme_constant_override("margin_top", 54 if short_phone else 64)
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

	var boost_height := 54.0 if short_phone else 60.0
	boosts_button.custom_minimum_size = Vector2(upgrade_width, boost_height)
	boosts_button.offset_left = upgrade_button.offset_left
	boosts_button.offset_top = upgrade_button.offset_top - boost_height - 12.0
	boosts_button.offset_right = upgrade_button.offset_right
	boosts_button.offset_bottom = upgrade_button.offset_top - 12.0
	boosts_button.add_theme_font_size_override("font_size", 17 if phone_layout else 19)

	var menu_size := 78.0 if short_phone else 92.0
	menu_button.custom_minimum_size = Vector2(menu_size, menu_size)
	menu_button.offset_left = -(viewport_size.x - content_right + side_margin + menu_size)
	menu_button.offset_top = side_margin
	menu_button.offset_right = -(viewport_size.x - content_right + side_margin)
	menu_button.offset_bottom = side_margin + menu_size

	var museum_width := 142.0 if short_phone else 154.0
	var museum_height := 56.0 if short_phone else 62.0
	museum_button.custom_minimum_size = Vector2(museum_width, museum_height)
	museum_button.offset_left = -(viewport_size.x - content_right + side_margin + museum_width)
	museum_button.offset_top = side_margin + menu_size + 10.0
	museum_button.offset_right = -(viewport_size.x - content_right + side_margin)
	museum_button.offset_bottom = side_margin + menu_size + 10.0 + museum_height
	museum_button.add_theme_font_size_override("font_size", 16 if phone_layout else 18)

	var bowl_height := 54.0 if short_phone else 60.0
	bottomless_bowl_button.custom_minimum_size = Vector2(museum_width, bowl_height)
	bottomless_bowl_button.offset_left = museum_button.offset_left
	bottomless_bowl_button.offset_top = museum_button.offset_bottom + 10.0
	bottomless_bowl_button.offset_right = museum_button.offset_right
	bottomless_bowl_button.offset_bottom = museum_button.offset_bottom + 10.0 + bowl_height
	bottomless_bowl_button.add_theme_font_size_override("font_size", 15 if phone_layout else 17)

	var skins_width := 142.0 if short_phone else 154.0
	var skins_height := 56.0 if short_phone else 62.0
	skins_button.custom_minimum_size = Vector2(skins_width, skins_height)
	skins_button.offset_left = content_left + side_margin
	skins_button.offset_top = side_margin
	skins_button.offset_right = content_left + side_margin + skins_width
	skins_button.offset_bottom = side_margin + skins_height

	if crate_logic != null and is_instance_valid(crate_logic.button):
		var crates_height := 54.0 if short_phone else 60.0
		crate_logic.button.custom_minimum_size = Vector2(skins_width, crates_height)
		crate_logic.button.offset_left = content_left + side_margin
		crate_logic.button.offset_top = side_margin + skins_height + 10.0
		crate_logic.button.offset_right = content_left + side_margin + skins_width
		crate_logic.button.offset_bottom = side_margin + skins_height + 10.0 + crates_height
		crate_logic.button.add_theme_font_size_override("font_size", 15 if phone_layout else 17)

	if mission_logic != null and is_instance_valid(mission_logic.button):
		var missions_height := 54.0 if short_phone else 60.0
		var missions_top := side_margin + skins_height + 10.0
		if crate_logic != null and is_instance_valid(crate_logic.button):
			missions_top = crate_logic.button.offset_bottom + 10.0
		mission_logic.button.custom_minimum_size = Vector2(skins_width, missions_height)
		mission_logic.button.offset_left = content_left + side_margin
		mission_logic.button.offset_top = missions_top
		mission_logic.button.offset_right = content_left + side_margin + skins_width
		mission_logic.button.offset_bottom = missions_top + missions_height
		mission_logic.button.add_theme_font_size_override("font_size", 14 if phone_layout else 16)

	upgrade_alert_badge.offset_left = -(viewport_size.x - hud_row_right + 46.0)
	upgrade_alert_badge.offset_top = -hud_height - side_margin - 24.0
	upgrade_alert_badge.offset_right = -(viewport_size.x - hud_row_right) + 2.0
	upgrade_alert_badge.offset_bottom = -hud_height - side_margin + 24.0
	var visible_panel := _get_visible_overlay_panel()
	if visible_panel != null:
		call_deferred("_position_modal_close_button", visible_panel)
	if tutorial_active or tutorial_prompt_visible:
		call_deferred("_update_tutorial_layout")


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
	tween.tween_property(popup, "position", popup.position + drift, 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var end_scale := 1.02 + (float(streak_multiplier - 1) * 0.04) + combo_heat * 0.08
	tween.tween_property(popup, "scale", Vector2(end_scale, end_scale), 0.26).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "modulate:a", 0.0, 1.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(Callable(popup, "queue_free"))


func _spawn_tap_burst(is_bonus: bool) -> void:
	var cat_rect: Rect2 = cat_button.get_global_rect()
	var origin := Vector2(cat_rect.get_center().x, cat_rect.end.y + 8.0)

	var particle_count := 8 if is_bonus else 4
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
	_tutorial_notify("menu_opened")


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
	_tutorial_notify("upgrades_opened")


func _show_achievements() -> void:
	_play_ui_sound()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(achievements_panel)
	_update_achievements_ui()
	call_deferred("_animate_achievements_screen")


func _show_stats() -> void:
	_play_ui_sound()
	_update_stats_ui()
	_update_daily_reward_ui()
	_show_overlay_panel(stats_panel)
	call_deferred("_animate_stats_screen")


func _show_skins() -> void:
	_play_ui_sound()
	var skin_data := _get_skin_data(equipped_skin_id)
	skins_status_label.text = "Equipped: %s. %s" % [_get_equipped_skin_name(), _get_skin_bonus_text(skin_data)]
	_update_skins_ui()
	_show_overlay_panel(skins_panel)
	call_deferred("_animate_skins_screen")
	_tutorial_notify("skins_opened")


func _show_boosts() -> void:
	_play_ui_sound()
	boost_logic.update_ui()
	_show_overlay_panel(boosts_panel)
	call_deferred("_animate_boost_screen")


func _show_crates() -> void:
	_play_ui_sound()
	crate_logic.update_ui(false)
	_show_overlay_panel(crate_logic.panel)
	call_deferred("_animate_crates_screen")


func _show_museum() -> void:
	_play_ui_sound()
	_rebuild_museum()
	_show_overlay_panel(museum_panel)


func _show_bottomless_bowl() -> void:
	_play_ui_sound()
	bottomless_bowl_logic.update_ui()
	_show_overlay_panel(bottomless_bowl_logic.panel)


func _show_missions() -> void:
	_play_ui_sound()
	mission_logic.update_ui()
	_show_overlay_panel(mission_logic.panel)


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


func _show_overlay_panel(panel: Control) -> void:
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
	if panel != upgrades_panel:
		_stop_upgrade_ambient_animation()
	menu_panel.hide()
	settings_panel.hide()
	upgrades_panel.hide()
	achievements_panel.hide()
	stats_panel.hide()
	skins_panel.hide()
	boosts_panel.hide()
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


func _hide_menu() -> void:
	if not menu_overlay.visible or modal_closing:
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
	if combo_timer != null and combo_was_running_before_overlay and combo_time_left_before_overlay > 0.0:
		combo_timer.start(combo_time_left_before_overlay)
	combo_was_running_before_overlay = false
	combo_time_left_before_overlay = 0.0


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
	click_logic.play_milestone_sound_if_needed(previous_score)


func _get_scaled_meow_interval(current_score: int) -> int:
	return click_logic.get_scaled_meow_interval(current_score)


func _play_ui_sound() -> void:
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
	return save_logic.get_unix_time()


func _get_current_day_number() -> int:
	return save_logic.get_current_day_number()


func _clamp_resource_value(value: int) -> int:
	return clampi(value, 0, MAX_RESOURCE_VALUE)


func _add_score(amount: int) -> int:
	if amount <= 0:
		return 0
	var previous := score
	score = _clamp_resource_value(score + amount)
	return score - previous


func _add_coins(amount: int) -> int:
	if amount <= 0:
		return 0
	var previous := coins
	coins = _clamp_resource_value(coins + amount)
	best_coin_balance = maxi(best_coin_balance, coins)
	return coins - previous


func _spend_coins(amount: int) -> bool:
	if amount <= 0:
		return true
	if coins < amount:
		return false
	coins = _clamp_resource_value(coins - amount)
	return true


func _sync_resource_bounds() -> void:
	score = _clamp_resource_value(score)
	coins = _clamp_resource_value(coins)
	best_coin_balance = _clamp_resource_value(maxi(best_coin_balance, coins))


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
	admin_status_label.text = "Clicks are unlimited. Kibbles stay within 1 to 1,000,000,000."
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
	spinbox.max_value = ADMIN_CLICK_SOFT_MAX if adds_clicks else ADMIN_MAX_AMOUNT
	spinbox.step = 1.0
	spinbox.allow_greater = adds_clicks
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
		admin_status_label.text = "Clicks are unlimited. Kibbles stay within 1 to 1,000,000,000."
		admin_click_spinbox.get_line_edit().grab_focus()


func _get_admin_amount(spinbox: SpinBox) -> int:
	return clampi(int(round(spinbox.value)), ADMIN_MIN_AMOUNT, ADMIN_MAX_AMOUNT)


func _get_admin_click_amount() -> int:
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
