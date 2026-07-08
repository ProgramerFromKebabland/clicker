extends RefCounted
class_name UpgradeLogic

var game


func _init(game_ref) -> void:
	game = game_ref


func update_upgrade_ui() -> void:
	game.click_value_label.text = "Click value: x%d / unlocked x%d" % [game.click_value, game.unlocked_click_value]
	game.click_power_label.text = "Use click value: x%d" % game.click_value
	game.click_power_slider.max_value = game.unlocked_click_value
	game.click_power_slider.value = game.click_value
	game.upgrade_value_label.text = "x%d" % game.unlocked_click_value
	game.upgrade_button.disabled = false
	game.offline_info_label.text = game._get_offline_info_text()

	if game.unlocked_click_value >= game.MAX_CLICK_VALUE:
		game.upgrade_button.text = "UPGRADES"
		game.upgrade_cost_label.text = "Maximum click power reached"
		game._set_upgrade_progress(game.click_progress_bar, 1, true)
		set_upgrade_button_state(game.upgrade_purchase_button, "Max value x%d" % game.MAX_CLICK_VALUE, true)
		update_bonus_upgrade_ui()
		return

	var next_value = game.unlocked_click_value + 1
	var upgrade_cost = get_upgrade_cost(next_value)
	game.upgrade_button.text = "UPGRADES"
	game.upgrade_cost_label.text = "Next x%d  |  %s kibbles" % [next_value, game._format_number(upgrade_cost)]
	game._set_upgrade_progress(game.click_progress_bar, upgrade_cost)
	set_upgrade_button_state(game.upgrade_purchase_button, "BUY CLICK POWER x%d" % next_value, game.coins < upgrade_cost, upgrade_cost)
	update_bonus_upgrade_ui()


func update_bonus_upgrade_ui() -> void:
	game.bonus_chance_label.text = "%.1f%%" % get_bonus_chance_percent()
	if game.bonus_chance_level >= game.MAX_BONUS_CHANCE_LEVEL:
		game.bonus_chance_cost_label.text = "Maximum bonus chance reached"
		game._set_upgrade_progress(game.bonus_chance_progress_bar, 1, true)
		set_upgrade_button_state(game.bonus_chance_button, "Max chance %.1f%%" % get_bonus_chance_percent(), true)
	else:
		var chance_cost: int = get_bonus_chance_cost()
		var next_chance = get_bonus_chance_percent(game.bonus_chance_level + 1)
		game.bonus_chance_cost_label.text = "Next %.1f%%  |  %s kibbles" % [next_chance, game._format_number(chance_cost)]
		game._set_upgrade_progress(game.bonus_chance_progress_bar, chance_cost)
		set_upgrade_button_state(game.bonus_chance_button, "BOOST LUCK TO %.1f%%" % next_chance, game.coins < chance_cost, chance_cost)

	game.bonus_value_label.text = "x%d" % get_bonus_multiplier()
	if game.bonus_value_index >= game.BONUS_MULTIPLIERS.size() - 1:
		game.bonus_value_cost_label.text = "Maximum bonus power reached"
		game._set_upgrade_progress(game.bonus_value_progress_bar, 1, true)
		set_upgrade_button_state(game.bonus_value_button, "Max bonus x%d" % get_bonus_multiplier(), true)
	else:
		var next_bonus: int = maxi(2, roundi(float(game.BONUS_MULTIPLIERS[game.bonus_value_index + 1]) * game._get_bonus_value_multiplier_bonus()))
		var value_cost: int = get_bonus_value_cost()
		game.bonus_value_cost_label.text = "Next x%d  |  %s kibbles" % [next_bonus, game._format_number(value_cost)]
		game._set_upgrade_progress(game.bonus_value_progress_bar, value_cost)
		set_upgrade_button_state(game.bonus_value_button, "AMPLIFY BONUS TO x%d" % next_bonus, game.coins < value_cost, value_cost)

	var effective_streak = game.bonus_streak_multiplier + game._get_streak_bonus()
	game.bonus_streak_label.text = "x%d" % effective_streak
	if game.bonus_streak_multiplier >= game.MAX_BONUS_STREAK_MULTIPLIER:
		game.bonus_streak_cost_label.text = "Maximum streak boost reached"
		game._set_upgrade_progress(game.bonus_streak_progress_bar, 1, true)
		set_upgrade_button_state(game.bonus_streak_button, "Max streak x%d" % (game.MAX_BONUS_STREAK_MULTIPLIER + game._get_streak_bonus()), true)
	else:
		var streak_cost: int = get_bonus_streak_cost()
		var next_streak = game.bonus_streak_multiplier + 1 + game._get_streak_bonus()
		game.bonus_streak_cost_label.text = "Next x%d  |  %s kibbles" % [next_streak, game._format_number(streak_cost)]
		game._set_upgrade_progress(game.bonus_streak_progress_bar, streak_cost)
		set_upgrade_button_state(game.bonus_streak_button, "POWER STREAK TO x%d" % next_streak, game.coins < streak_cost, streak_cost)

	var effective_passive = game._get_effective_passive_gain()
	game.passive_gain_label.text = "%d/min" % effective_passive
	game.settings_passive_gain_label.text = "Offline gain: %d/min" % effective_passive
	if game.passive_clicks_per_minute >= game.MAX_PASSIVE_CLICKS_PER_MINUTE:
		game.passive_gain_cost_label.text = "Maximum offline income reached"
		game._set_upgrade_progress(game.passive_gain_progress_bar, 1, true)
		set_upgrade_button_state(game.passive_gain_button, "Max offline %d/min" % (game.MAX_PASSIVE_CLICKS_PER_MINUTE + game._get_passive_gain_bonus()), true)
		game.settings_passive_gain_cost_label.text = "Max offline gain reached"
		set_upgrade_button_state(game.settings_passive_gain_button, "Max offline %d/min" % (game.MAX_PASSIVE_CLICKS_PER_MINUTE + game._get_passive_gain_bonus()), true)
	else:
		var passive_cost: int = get_passive_upgrade_cost()
		var next_passive = game.passive_clicks_per_minute + 1 + game._get_passive_gain_bonus()
		game.passive_gain_cost_label.text = "Next %d/min  |  %s kibbles" % [next_passive, game._format_number(passive_cost)]
		game._set_upgrade_progress(game.passive_gain_progress_bar, passive_cost)
		set_upgrade_button_state(game.passive_gain_button, "GROW INCOME TO %d/MIN" % next_passive, game.coins < passive_cost, passive_cost)
		game.settings_passive_gain_cost_label.text = "Next: %d/min for %s kibbles" % [next_passive, game._format_number(passive_cost)]
		set_upgrade_button_state(game.settings_passive_gain_button, "Upgrade offline", game.coins < passive_cost, passive_cost)
	update_extended_upgrade_ui()
	game._update_upgrade_alert()


func update_extended_upgrade_ui() -> void:
	for raw_upgrade_data in game.EXTENDED_UPGRADE_DATA:
		var upgrade_data: Dictionary = raw_upgrade_data
		var upgrade_id: String = String(upgrade_data["id"])
		var level: int = int(game.get_extended_upgrade_level(upgrade_id))
		var max_level: int = int(upgrade_data["max_level"])
		var controls: Dictionary = game.extended_upgrade_controls.get(upgrade_id, {})
		if controls.is_empty():
			continue
		var value_label := controls["value"] as Label
		var cost_label := controls["cost"] as Label
		var progress_bar := controls["progress"] as ProgressBar
		var button := controls["button"] as Button
		value_label.text = get_extended_upgrade_value_text(upgrade_id, level)
		if level >= max_level:
			cost_label.text = "Maximum level reached"
			game._set_upgrade_progress(progress_bar, 1, true)
			set_upgrade_button_state(button, "MAX LEVEL", true)
			continue
		var cost: int = get_extended_upgrade_cost(upgrade_data, level)
		cost_label.text = "%s  |  %s kibbles" % [get_extended_upgrade_next_text(upgrade_id, level + 1), game._format_number(cost)]
		game._set_upgrade_progress(progress_bar, cost)
		var button_text := "%s KIBBLES" % game._format_number(cost) if String(upgrade_data.get("category", "classical")) == "advanced" else "UPGRADE TO LEVEL %d" % (level + 1)
		var displayed_cost := -1 if String(upgrade_data.get("category", "classical")) == "advanced" else cost
		set_upgrade_button_state(button, button_text, game.coins < cost, displayed_cost)


func set_upgrade_button_state(button: Button, ready_text: String, disabled: bool, cost: int = -1) -> void:
	button.disabled = disabled
	if disabled and cost > 0 and game.coins < cost:
		button.text = "Need %s more" % game._format_number(cost - game.coins)
		return
	button.text = ready_text


func has_affordable_upgrade() -> bool:
	if game.unlocked_click_value < game.MAX_CLICK_VALUE and game.coins >= get_upgrade_cost(game.unlocked_click_value + 1):
		return true
	if game.bonus_chance_level < game.MAX_BONUS_CHANCE_LEVEL and game.coins >= get_bonus_chance_cost():
		return true
	if game.bonus_value_index < game.BONUS_MULTIPLIERS.size() - 1 and game.coins >= get_bonus_value_cost():
		return true
	if game.bonus_streak_multiplier < game.MAX_BONUS_STREAK_MULTIPLIER and game.coins >= get_bonus_streak_cost():
		return true
	if game.passive_clicks_per_minute < game.MAX_PASSIVE_CLICKS_PER_MINUTE and game.coins >= get_passive_upgrade_cost():
		return true
	for raw_upgrade_data in game.EXTENDED_UPGRADE_DATA:
		var upgrade_data: Dictionary = raw_upgrade_data
		var upgrade_id: String = String(upgrade_data["id"])
		var level: int = int(game.get_extended_upgrade_level(upgrade_id))
		if level < int(upgrade_data["max_level"]) and game.coins >= get_extended_upgrade_cost(upgrade_data, level):
			return true
	return false


func get_extended_upgrade_cost(upgrade_data: Dictionary, current_level: int) -> int:
	return int(upgrade_data["base_cost"]) * int(pow(2.0, current_level))


func get_extended_upgrade_value_text(upgrade_id: String, level: int) -> String:
	match upgrade_id:
		"tap_mastery":
			return "+%d%%" % (level * 5)
		"combo_capacity":
			return "x%.1f" % (1.0 + game.MAX_COMBO_BONUS + (level * 0.1))
		"combo_momentum":
			return "%d taps" % game.get_effective_combo_taps_per_step(game.COMBO_CLICKS_PER_STEP)
		"daily_feast":
			return "+%d%%" % (level * 10)
		"offline_storage":
			return "%dh" % int(game.get_offline_gain_max_seconds() / 3600)
		"kibble_alchemy":
			return "+%d%% all" % (level * 3)
		"lucky_whiskers":
			return "+%.1f%% luck" % (level * 0.5)
		"dream_engine":
			return "+%d%% idle" % (level * 10)
	return "Lv. %d" % level


func get_extended_upgrade_next_text(upgrade_id: String, next_level: int) -> String:
	match upgrade_id:
		"tap_mastery":
			return "Tap gain +%d%%" % (next_level * 5)
		"combo_capacity":
			return "Max combo x%.1f" % (1.0 + game.MAX_COMBO_BONUS + (next_level * 0.1))
		"combo_momentum":
			return "Combo step every %d taps" % maxi(1, game.COMBO_CLICKS_PER_STEP - next_level)
		"daily_feast":
			return "Daily reward +%d%%" % (next_level * 10)
		"offline_storage":
			return "Offline cap %dh" % int(game.OFFLINE_GAIN_MAX_SECONDS / 3600 + next_level)
		"kibble_alchemy":
			return "All kibble gain +%d%%" % (next_level * 3)
		"lucky_whiskers":
			return "Bonus luck +%.1f%%" % (next_level * 0.5)
		"dream_engine":
			return "Offline income +%d%%" % (next_level * 10)
	return "Level %d" % next_level


func get_upgrade_cost(next_value: int) -> int:
	if next_value <= 10:
		return next_value * next_value * 25
	var cost = get_upgrade_cost(10)
	for value in range(11, next_value + 1):
		cost *= 2
	return cost


func get_bonus_chance_percent(level: int = -1) -> float:
	if level < 0:
		level = game.bonus_chance_level
	return game._get_base_bonus_chance_percent(level) + game._get_bonus_chance_bonus_percent()


func get_bonus_multiplier() -> int:
	return maxi(2, roundi(float(game._get_base_bonus_multiplier()) * game._get_bonus_value_multiplier_bonus()))


func get_bonus_chance_cost() -> int:
	return 50 + (game.bonus_chance_level * 25)


func get_bonus_value_cost() -> int:
	var next_index: int = game.bonus_value_index + 1
	return int(game.BONUS_VALUE_COSTS[next_index - 1])


func get_bonus_streak_cost() -> int:
	var next_multiplier = game.bonus_streak_multiplier + 1
	return game.BASE_BONUS_STREAK_COST * next_multiplier * next_multiplier


func get_passive_upgrade_cost() -> int:
	var purchase_index = game.passive_clicks_per_minute - 1
	var final_purchase_index = game.MAX_PASSIVE_CLICKS_PER_MINUTE - 2
	if purchase_index <= 0:
		return game.MIN_PASSIVE_UPGRADE_COST
	if purchase_index >= final_purchase_index:
		return game.MAX_PASSIVE_UPGRADE_COST
	var progress = float(purchase_index) / float(final_purchase_index)
	var cost_ratio = float(game.MAX_PASSIVE_UPGRADE_COST) / float(game.MIN_PASSIVE_UPGRADE_COST)
	var raw_cost = float(game.MIN_PASSIVE_UPGRADE_COST) * pow(cost_ratio, progress)
	return int(round(raw_cost / 100.0)) * 100


func roll_bonus_multiplier() -> int:
	var chance: float = minf(100.0, get_bonus_chance_percent() + game.boost_logic.get_temporary_bonus_chance() + game.get_food_bonus_chance_bonus())
	if not game._is_bonus_guaranteed() and randf() > chance / 100.0:
		return 1
	return get_bonus_multiplier()


func upgrade_click_value() -> void:
	if game.unlocked_click_value >= game.MAX_CLICK_VALUE:
		return
	var next_value = game.unlocked_click_value + 1
	var upgrade_cost = get_upgrade_cost(next_value)
	if game.coins < upgrade_cost:
		return
	if not game._spend_coins(upgrade_cost):
		return
	game.unlocked_click_value = next_value
	game.click_value = next_value
	game._update_score()
	game._update_coins(false)
	update_upgrade_ui()
	game._update_achievements_ui()
	game._celebrate_upgrade(game.click_upgrade_card, game.CLICK_UPGRADE_COLOR)
	game._play_purchase_sound()
	game._save_game()


func upgrade_passive_gain() -> void:
	if game.passive_clicks_per_minute >= game.MAX_PASSIVE_CLICKS_PER_MINUTE:
		return
	var cost: int = get_passive_upgrade_cost()
	if game.coins < cost:
		return
	if not game._spend_coins(cost):
		return
	game.passive_clicks_per_minute += 1
	game._update_coins(false)
	update_upgrade_ui()
	game._update_achievements_ui()
	game._celebrate_upgrade(game.passive_gain_card, game.PASSIVE_UPGRADE_COLOR)
	game._play_purchase_sound()
	game._save_game()


func upgrade_bonus_chance() -> void:
	if game.bonus_chance_level >= game.MAX_BONUS_CHANCE_LEVEL:
		return
	var cost: int = get_bonus_chance_cost()
	if game.coins < cost:
		return
	if not game._spend_coins(cost):
		return
	game.bonus_chance_level += 1
	game._update_coins(false)
	update_upgrade_ui()
	game._update_achievements_ui()
	game._celebrate_upgrade(game.bonus_chance_card, game.CHANCE_UPGRADE_COLOR)
	game._play_purchase_sound()
	game._save_game()


func upgrade_bonus_value() -> void:
	if game.bonus_value_index >= game.BONUS_MULTIPLIERS.size() - 1:
		return
	var cost: int = get_bonus_value_cost()
	if game.coins < cost:
		return
	if not game._spend_coins(cost):
		return
	game.bonus_value_index += 1
	game._update_coins(false)
	update_upgrade_ui()
	game._update_achievements_ui()
	game._celebrate_upgrade(game.bonus_value_card, game.VALUE_UPGRADE_COLOR)
	game._play_purchase_sound()
	game._save_game()


func upgrade_bonus_streak() -> void:
	if game.bonus_streak_multiplier >= game.MAX_BONUS_STREAK_MULTIPLIER:
		return
	var cost: int = get_bonus_streak_cost()
	if game.coins < cost:
		return
	if not game._spend_coins(cost):
		return
	game.bonus_streak_multiplier += 1
	game._update_coins(false)
	update_upgrade_ui()
	game._update_achievements_ui()
	game._update_stats_ui()
	game._celebrate_upgrade(game.bonus_streak_card, game.STREAK_UPGRADE_COLOR)
	game._play_purchase_sound()
	game._save_game()


func upgrade_extended(upgrade_id: String) -> void:
	var upgrade_data: Dictionary = {}
	for raw_candidate in game.EXTENDED_UPGRADE_DATA:
		var candidate: Dictionary = raw_candidate
		if String(candidate["id"]) == upgrade_id:
			upgrade_data = candidate
			break
	if upgrade_data.is_empty():
		return
	var level: int = int(game.get_extended_upgrade_level(upgrade_id))
	if level >= int(upgrade_data["max_level"]):
		return
	var cost: int = get_extended_upgrade_cost(upgrade_data, level)
	if game.coins < cost:
		return
	if not game._spend_coins(cost):
		return
	game.extended_upgrade_levels[upgrade_id] = level + 1
	game.combo_bonus = minf(game.combo_bonus, game.get_effective_combo_cap())
	game._update_coins(false)
	update_upgrade_ui()
	game._update_combo_ui()
	game._update_daily_reward_ui()
	game._update_stats_ui()
	var controls: Dictionary = game.extended_upgrade_controls[upgrade_id]
	game._celebrate_upgrade(controls["card"] as Control, controls["accent"] as Color)
	game._play_purchase_sound()
	game._save_game()
