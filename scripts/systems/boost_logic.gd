extends RefCounted
class_name BoostLogic

const BOOST_DATA: Array[Dictionary] = [
	{
		"id": "cat_frenzy",
		"name": "CAT FRENZY",
		"badge": "+50%",
		"cost": 900000,
			"duration": 6.0,
		"description": "Every tap deals 50% more tap power.",
		"accent": Color(1.0, 0.38, 0.28, 1.0),
	},
	{
		"id": "lucky_paws",
		"name": "LUCKY PAWS",
		"badge": "LUCK",
		"cost": 750000,
			"duration": 6.0,
		"description": "Adds 10 percentage points to bonus chance.",
		"accent": Color(1.0, 0.72, 0.2, 1.0),
	},
	{
		"id": "time_freeze",
		"name": "TIME FREEZE",
		"badge": "TIME",
		"cost": 1000000,
			"duration": 6.0,
		"description": "Temporarily protects the current combo from decay.",
		"accent": Color(0.45, 0.7, 1.0, 1.0),
	},
	{
		"id": "purrstorm",
		"name": "PURRSTORM",
		"badge": "+GHOST",
		"cost": 1500000,
			"duration": 6.0,
		"description": "Each press fires one half-value ghost tap.",
		"accent": Color(0.68, 0.42, 1.0, 1.0),
	},
	{
		"id": "golden_meow",
		"name": "GOLDEN MEOW",
		"badge": "GOLD",
		"cost": 3750000,
			"duration": 5.0,
		"description": "All bonus hits pay 25% more.",
		"accent": Color(1.0, 0.86, 0.18, 1.0),
	},
	{
		"id": "whisker_rush",
		"name": "WHISKER RUSH",
		"badge": "RUSH",
		"cost": 1100000,
			"duration": 6.0,
		"description": "Combo growth needs two fewer taps per step.",
		"accent": Color(0.28, 1.0, 0.62, 1.0),
	},
	{
		"id": "nine_lives",
		"name": "NINE LIVES",
		"badge": "9",
		"cost": 450000,
		"duration": 0.0,
		"description": "The next 3, 6, or 9 taps guarantee bonuses and protect combo.",
		"accent": Color(1.0, 0.5, 0.72, 1.0),
	},
	{
		"id": "kibble_storm",
		"name": "KIBBLE STORM",
		"badge": "AUTO",
		"cost": 2000000,
			"duration": 8.0,
		"description": "Automatically fires one half-value ghost tap every 2 seconds.",
		"accent": Color(0.3, 0.88, 1.0, 1.0),
	},
	{
		"id": "combo_nova",
		"name": "COMBO NOVA",
		"badge": "x1.15",
		"cost": 2500000,
			"duration": 6.0,
		"description": "Multiplies current combo power by x1.15.",
		"accent": Color(0.7, 0.35, 1.0, 1.0),
	},
	{
		"id": "streak_surge",
		"name": "STREAK SURGE",
		"badge": "x1.25",
		"cost": 3250000,
			"duration": 6.0,
		"description": "Triggered bonus streaks become 25% stronger.",
		"accent": Color(1.0, 0.32, 0.58, 1.0),
	},
	{
		"id": "jackpot_engine",
		"name": "JACKPOT ENGINE",
		"badge": "+10%",
		"cost": 6000000,
			"duration": 5.0,
		"description": "Successful bonus hits pay 10% more.",
		"accent": Color(1.0, 0.78, 0.12, 1.0),
	},
	{
		"id": "combo_overclock",
		"name": "COMBO OVERCLOCK",
		"badge": "+.15",
		"cost": 1750000,
			"duration": 7.0,
		"description": "Each combo step adds +0.15 instead of +0.1.",
		"accent": Color(0.2, 1.0, 0.68, 1.0),
	},
	{
		"id": "payday_pulse",
		"name": "PAYDAY PULSE",
		"badge": "$$$",
		"cost": 4000000,
			"duration": 6.0,
		"description": "Pays 30 seconds of offline income every second.",
		"accent": Color(0.44, 0.94, 0.34, 1.0),
	},
	{
		"id": "meteor_paws",
		"name": "METEOR PAWS",
		"badge": "+FLAT",
		"cost": 3000000,
			"duration": 5.0,
		"description": "Adds one minute of offline income to every tap.",
		"accent": Color(1.0, 0.44, 0.2, 1.0),
	},
	{
		"id": "gem_magnet",
		"name": "GEM MAGNET",
		"badge": "x2 GEM",
		"cost": 1250000,
		"duration": 10.0,
		"description": "Every crate drops twice as many gem fragments.",
		"accent": Color(0.25, 0.9, 1.0, 1.0),
	},
	{
		"id": "lucky_lock",
		"name": "LUCKY LOCK",
		"badge": "+PICK",
		"cost": 1800000,
		"duration": 10.0,
		"description": "Every crate contains one extra cat-gem pick.",
		"accent": Color(0.78, 0.48, 1.0, 1.0),
	},
	{
		"id": "royal_treat",
		"name": "ROYAL TREAT",
		"badge": "+25%",
		"cost": 2800000,
		"duration": 8.0,
		"description": "All kibble income is increased by 25%.",
		"accent": Color(1.0, 0.72, 0.18, 1.0),
	},
	{
		"id": "supernova_paws",
		"name": "SUPERNOVA PAWS",
		"badge": "x2 TAP",
		"cost": 8000000,
		"duration": 5.0,
		"description": "Doubles every tap before the combined boost cap.",
		"accent": Color(1.0, 0.35, 0.72, 1.0),
	},
	{
		"id": "fortune_orbit",
		"name": "FORTUNE ORBIT",
		"badge": "+20%",
		"cost": 5000000,
		"duration": 6.0,
		"description": "Adds 20 percentage points to bonus chance.",
		"accent": Color(0.45, 0.9, 1.0, 1.0),
	},
	{
		"id": "royal_banquet",
		"name": "ROYAL BANQUET",
		"badge": "+60% ALL",
		"cost": 10000000,
		"duration": 5.0,
		"description": "All sources create 60% more kibbles.",
		"accent": Color(1.0, 0.62, 0.16, 1.0),
	},
	{"id": "quantum_frenzy", "category": "advanced", "name": "QUANTUM FRENZY", "badge": "x3 TAP", "cost": 50000000, "duration": 8.0, "description": "Triples tap power during a quantum surge.", "accent": Color(0.2, 0.95, 1.0)},
	{"id": "infinite_fortune", "category": "advanced", "name": "INFINITE FORTUNE", "badge": "+40%", "cost": 65000000, "duration": 8.0, "description": "Adds 40 percentage points to bonus chance.", "accent": Color(1.0, 0.8, 0.18)},
	{"id": "celestial_rain", "category": "advanced", "name": "CELESTIAL RAIN", "badge": "x2 ALL", "cost": 90000000, "duration": 10.0, "description": "Doubles every source of kibble income.", "accent": Color(0.55, 0.7, 1.0)},
	{"id": "ghost_army", "category": "advanced", "name": "GHOST ARMY", "badge": "+3 GHOST", "cost": 110000000, "duration": 8.0, "description": "Each press fires three additional ghost taps.", "accent": Color(0.72, 0.42, 1.0)},
	{"id": "jackpot_overdrive", "category": "advanced", "name": "JACKPOT OVERDRIVE", "badge": "x2 BONUS", "cost": 140000000, "duration": 7.0, "description": "Doubles all successful bonus payouts.", "accent": Color(1.0, 0.55, 0.15)},
	{"id": "combo_singularity", "category": "advanced", "name": "COMBO SINGULARITY", "badge": "x2 COMBO", "cost": 180000000, "duration": 9.0, "description": "Doubles current combo power.", "accent": Color(1.0, 0.32, 0.72)},
	{"id": "time_emperor", "category": "advanced", "name": "TIME EMPEROR", "badge": "TIME", "cost": 250000000, "duration": 12.0, "description": "Freezes combo and grants x2.5 global income.", "accent": Color(0.3, 0.82, 1.0)},
	{"id": "prismatic_frenzy", "category": "legendary", "name": "PRISMATIC FRENZY", "badge": "x4 TAP", "cost": 1000000000, "duration": 10.0, "description": "Quadruples tap power during a short ascension burst.", "accent": Color(0.25, 1.0, 0.78)},
	{"id": "solar_fortune", "category": "legendary", "name": "SOLAR FORTUNE", "badge": "+60%", "cost": 1500000000, "duration": 10.0, "description": "Adds 60 percentage points to bonus chance.", "accent": Color(1.0, 0.84, 0.28)},
	{"id": "nebula_rain", "category": "legendary", "name": "NEBULA RAIN", "badge": "x3 ALL", "cost": 2250000000, "duration": 12.0, "description": "Triples every source of kibble income.", "accent": Color(0.45, 0.78, 1.0)},
	{"id": "citadel_jackpot", "category": "legendary", "name": "CITADEL JACKPOT", "badge": "x3 BONUS", "cost": 3400000000, "duration": 9.0, "description": "Triples all successful bonus payouts.", "accent": Color(1.0, 0.48, 0.28)},
	{"id": "gravity_surge", "category": "legendary", "name": "GRAVITY SURGE", "badge": "x3 COMBO", "cost": 5100000000, "duration": 10.0, "description": "Triples current combo power.", "accent": Color(0.78, 0.52, 1.0)},
	{"id": "starlight_army", "category": "legendary", "name": "STARLIGHT ARMY", "badge": "+5 GHOST", "cost": 7600000000, "duration": 10.0, "description": "Each press fires five additional ghost taps.", "accent": Color(0.38, 0.92, 1.0)},
	{"id": "galaxy_frenzy", "category": "mythic", "name": "GALAXY FRENZY", "badge": "x8 TAP", "cost": 1000000000000, "duration": 12.0, "description": "Multiplies tap power by eight during a galaxy burst.", "accent": Color(0.52, 1.0, 0.72)},
	{"id": "miracle_fortune", "category": "mythic", "name": "MIRACLE FORTUNE", "badge": "+100%", "cost": 1500000000000, "duration": 12.0, "description": "Adds 100 percentage points to bonus chance.", "accent": Color(1.0, 0.9, 0.34)},
	{"id": "infinity_rain", "category": "mythic", "name": "INFINITY RAIN", "badge": "x6 ALL", "cost": 2250000000000, "duration": 14.0, "description": "Multiplies every source of kibble income by six.", "accent": Color(0.52, 0.84, 1.0)},
	{"id": "crown_overdrive", "category": "mythic", "name": "CROWN OVERDRIVE", "badge": "x6 BONUS", "cost": 3400000000000, "duration": 11.0, "description": "Multiplies all successful bonus payouts by six.", "accent": Color(1.0, 0.54, 0.3)},
	{"id": "singularity_surge", "category": "mythic", "name": "SINGULARITY SURGE", "badge": "x6 COMBO", "cost": 5100000000000, "duration": 12.0, "description": "Multiplies current combo power by six.", "accent": Color(0.82, 0.6, 1.0)},
	{"id": "eternity_army", "category": "mythic", "name": "ETERNITY ARMY", "badge": "+10 GHOST", "cost": 7600000000000, "duration": 12.0, "description": "Each press fires ten additional ghost taps.", "accent": Color(0.42, 0.96, 1.0)},
]
const MAX_COMBINED_CLICK_BOOST := 10.0

var game
var ui_elapsed := 0.0
var storm_elapsed := 0.0
var payday_elapsed := 0.0


func _init(game_ref) -> void:
	game = game_ref


func process(delta: float) -> void:
	var protects_combo: bool = is_active("time_freeze") or is_active("time_emperor") or game.nine_lives_taps_left > 0
	if game.combo_timer != null and game.combo_timer.paused != protects_combo:
		game.combo_timer.paused = protects_combo

	if game.is_menu_time_paused():
		if is_instance_valid(game.boosts_panel) and game.boosts_panel.visible:
			update_ui()
		return

	if is_active("kibble_storm"):
		storm_elapsed += delta
		while storm_elapsed >= 2.0:
			storm_elapsed -= 2.0
			game.click_logic.perform_tap(true)
	else:
		storm_elapsed = 0.0

	if is_active("payday_pulse"):
		payday_elapsed += delta
		while payday_elapsed >= 1.0:
			payday_elapsed -= 1.0
			var pulse_amount: int = maxi(1, roundi(float(game._get_effective_passive_gain()) * 0.5))
			game._gain_coins(pulse_amount, game.coins_label.get_global_rect().get_center())
			game._queue_save()
	else:
		payday_elapsed = 0.0

	ui_elapsed += delta
	if ui_elapsed >= 0.25:
		ui_elapsed = 0.0
		if is_instance_valid(game.boosts_panel) and game.boosts_panel.visible:
			update_ui()


func is_active(boost_id: String) -> bool:
	if boost_id == "nine_lives":
		return game.nine_lives_taps_left > 0
	return get_remaining_seconds(boost_id) > 0.0


func get_remaining_seconds(boost_id: String) -> float:
	var end_time := float(game.active_boost_end_times.get(boost_id, 0.0))
	return maxf(0.0, end_time - game._get_unix_time())


func get_recharge_seconds(boost_id: String) -> float:
	var end_time := float(game.boost_recharge_end_times.get(boost_id, 0.0))
	return maxf(0.0, end_time - game._get_unix_time())


func is_recharging(boost_id: String) -> bool:
	return get_recharge_seconds(boost_id) > 0.0


func get_combo_taps_per_step() -> int:
	var base_taps: int = int(game.COMBO_CLICKS_PER_STEP) - (2 if is_active("whisker_rush") else 0)
	return int(game.get_effective_combo_taps_per_step(base_taps))


func is_bonus_guaranteed() -> bool:
	return game.nine_lives_taps_left > 0


func get_temporary_bonus_chance() -> float:
	var bonus := 10.0 if is_active("lucky_paws") else 0.0
	if is_active("fortune_orbit"):
		bonus += 20.0
	if is_active("infinite_fortune"):
		bonus += 40.0
	if is_active("solar_fortune"):
		bonus += 60.0
	if is_active("miracle_fortune"):
		bonus += 100.0
	return bonus


func get_tap_multiplier() -> float:
	var multiplier := 1.5 if is_active("cat_frenzy") else 1.0
	if is_active("supernova_paws"):
		multiplier *= 2.0
	if is_active("quantum_frenzy"):
		multiplier *= 3.0
	if is_active("prismatic_frenzy"):
		multiplier *= 4.0
	if is_active("galaxy_frenzy"):
		multiplier *= 8.0
	return multiplier


func get_bonus_payout_multiplier() -> float:
	var multiplier := 1.0
	if is_active("golden_meow"):
		multiplier *= 1.25
	if is_active("jackpot_engine"):
		multiplier *= 1.1
	if is_active("jackpot_overdrive"):
		multiplier *= 2.0
	if is_active("citadel_jackpot"):
		multiplier *= 3.0
	if is_active("crown_overdrive"):
		multiplier *= 6.0
	return multiplier


func get_extra_ghost_taps() -> int:
	return (1 if is_active("purrstorm") else 0) + (3 if is_active("ghost_army") else 0) + (5 if is_active("starlight_army") else 0) + (10 if is_active("eternity_army") else 0)


func get_combo_power_multiplier() -> float:
	return (1.15 if is_active("combo_nova") else 1.0) * (2.0 if is_active("combo_singularity") else 1.0) * (3.0 if is_active("gravity_surge") else 1.0) * (6.0 if is_active("singularity_surge") else 1.0)


func get_streak_multiplier() -> float:
	return 1.25 if is_active("streak_surge") else 1.0


func transform_bonus_multiplier(multiplier: int) -> int:
	return multiplier


func get_combo_step() -> float:
	return 0.15 if is_active("combo_overclock") else float(game.COMBO_STEP)


func get_flat_tap_bonus() -> int:
	if not is_active("meteor_paws"):
		return 0
	return maxi(1, int(game._get_effective_passive_gain()))


func get_crate_fragment_multiplier() -> int:
	return 2 if is_active("gem_magnet") else 1


func get_extra_crate_picks() -> int:
	return 1 if is_active("lucky_lock") else 0


func get_global_gain_multiplier() -> float:
	var multiplier := 1.25 if is_active("royal_treat") else 1.0
	if is_active("royal_banquet"):
		multiplier *= 1.6
	if is_active("celestial_rain"):
		multiplier *= 2.0
	if is_active("time_emperor"):
		multiplier *= 2.5
	if is_active("nebula_rain"):
		multiplier *= 3.0
	if is_active("infinity_rain"):
		multiplier *= 6.0
	return multiplier


func cap_boosted_click(boosted_amount: int, unboosted_amount: int) -> int:
	var maximum: int = maxi(unboosted_amount, game._safe_resource_round(float(unboosted_amount) * MAX_COMBINED_CLICK_BOOST))
	return mini(boosted_amount, maximum)


func consume_protected_tap() -> void:
	if game.nine_lives_taps_left <= 0:
		return
	game.nine_lives_taps_left -= 1
	if game.nine_lives_taps_left == 0 and game.nine_lives_recharge_duration > 0.0:
		game.boost_recharge_end_times["nine_lives"] = game._get_unix_time() + game.nine_lives_recharge_duration
		game.nine_lives_recharge_duration = 0.0
		game._queue_save()
	update_ui()


func purchase(boost_id: String, tier: int) -> void:
	tier = clampi(tier, 1, 3)
	var data := get_data(boost_id)
	if data.is_empty():
		return
	var cost := get_tier_cost(int(data["cost"]), tier)
	if game.coins < cost:
		return

	if not game._spend_coins(cost):
		return
	var inventory_key: String = game._get_boost_inventory_key(boost_id, tier)
	game.boost_inventory[inventory_key] = int(game.boost_inventory.get(inventory_key, 0)) + 1
	game._refresh_boost_inventory_ui()

	game._update_coins(false)
	update_ui()
	game._play_purchase_sound()
	game._save_game()
	game._tutorial_notify("boost_bought")

	var card := game.boost_cards.get(boost_id) as Control
	if card != null:
		game._celebrate_upgrade(card, data["accent"] as Color, "PACKED!")


func activate_owned(boost_id: String, tier: int) -> bool:
	tier = clampi(tier, 1, 3)
	if is_active(boost_id) or is_recharging(boost_id):
		return false
	var data := get_data(boost_id)
	if data.is_empty():
		return false
	var duration := float(data["duration"])
	if duration > 0.0:
		var active_duration := duration * float(tier)
		var active_end: float = float(game._get_unix_time()) + active_duration
		game.active_boost_end_times[boost_id] = active_end
		game.boost_recharge_end_times[boost_id] = active_end + active_duration * 2.0
	else:
		match boost_id:
			"nine_lives":
				game.nine_lives_taps_left = 3 * tier
				game.nine_lives_recharge_duration = 18.0 * float(tier)

	game._update_upgrade_ui()
	game._update_achievements_ui()
	game._update_stats_ui()
	update_ui()
	game._play_bonus_sound()
	game._save_game()
	game._tutorial_notify("boost_used")
	return true


func update_ui() -> void:
	if not is_instance_valid(game.boost_wallet_label):
		return
	game.boost_wallet_label.text = "%s KIBBLES" % game._format_coins()

	for data in BOOST_DATA:
		var boost_id := String(data["id"])
		var status_label := game.boost_status_labels.get(boost_id) as Label
		var buttons: Array = game.boost_action_buttons.get(boost_id, [])
		var remaining := get_remaining_seconds(boost_id)
		var recharge_remaining := get_recharge_seconds(boost_id)
		var recharging: bool = recharge_remaining > 0.0

		if status_label != null:
			if remaining > 0.0:
				status_label.text = "ACTIVE  %s" % format_seconds(remaining)
				status_label.add_theme_color_override("font_color", (data["accent"] as Color).lightened(0.2))
			elif boost_id == "nine_lives" and game.nine_lives_taps_left > 0:
				status_label.text = "ACTIVE  %d TAPS LEFT" % game.nine_lives_taps_left
				status_label.add_theme_color_override("font_color", (data["accent"] as Color).lightened(0.2))
			elif recharging:
				status_label.text = "RECHARGING  %s" % format_seconds(recharge_remaining)
				status_label.add_theme_color_override("font_color", Color(0.58, 0.64, 0.74, 1.0))
			else:
				status_label.text = "READY TO ACTIVATE"
				status_label.add_theme_color_override("font_color", Color(0.62, 0.68, 0.78, 1.0))

		for index in range(buttons.size()):
			var button := buttons[index] as Button
			if button == null:
				continue
			var tier := index + 1
			var cost := get_tier_cost(int(data["cost"]), tier)
			button.disabled = game.coins < cost
			button.text = "BUY\n%s  -  %s" % [get_tier_name(tier), game._format_number(cost)]

func get_data(boost_id: String) -> Dictionary:
	for data in BOOST_DATA:
		if String(data["id"]) == boost_id:
			return data
	return {}


func get_tier_cost(base_cost: int, tier: int) -> int:
	return roundi(float(base_cost) * (1.0 + 0.5 * float(tier - 1)))


func get_tier_name(tier: int) -> String:
	match tier:
		2:
			return "DOUBLE"
		3:
			return "TRIPLE"
		_:
			return "NORMAL"


func format_seconds(seconds: float) -> String:
	var total_tenths := ceili(seconds * 10.0)
	return "%d.%ds" % [total_tenths / 10, total_tenths % 10]
