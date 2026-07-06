extends RefCounted
class_name RewardLogic

var game


func _init(game_ref) -> void:
	game = game_ref


func update_daily_reward_ui() -> void:
	var reward = get_daily_reward_amount(get_next_daily_reward_streak())
	var available = can_claim_daily_reward()
	game.daily_reward_label.text = "Daily reward streak: %d" % game.daily_reward_streak
	game.daily_reward_alert_label.hide()
	if available:
		game.menu_button.modulate = Color(1.0, 0.82, 0.22, 1.0)
		game.daily_reward_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.22, 1.0))
		game.daily_reward_button.disabled = false
		game.daily_reward_button.text = "Claim %s kibbles" % game._format_number(reward)
		game.daily_reward_timer_label.text = "Available now"
		game.daily_reward_timer_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.22, 1.0))
	else:
		game.menu_button.modulate = Color.WHITE
		game.daily_reward_label.add_theme_color_override("font_color", Color.WHITE)
		game.daily_reward_button.disabled = true
		game.daily_reward_button.text = "Claimed today"
		game.daily_reward_timer_label.text = "Next reward in %s" % format_time_until_next_day()
		game.daily_reward_timer_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.68, 1.0))


func show_startup_popups() -> void:
	game._show_offline_gain_message()


func can_claim_daily_reward() -> bool:
	return game._get_current_day_number() > game.last_daily_reward_day


func get_next_daily_reward_streak() -> int:
	var today = game._get_current_day_number()
	if game.last_daily_reward_day == today - 1:
		return game.daily_reward_streak + 1
	return 1


func get_daily_reward_amount(streak: int = -1) -> int:
	if streak < 0:
		streak = game.daily_reward_streak
	var base_reward = game.DAILY_REWARD_BASE_COINS + (streak * game.DAILY_REWARD_STREAK_BONUS) + (game.click_value * 10) + (game._get_effective_passive_gain() * 5)
	return game._apply_skin_gain_bonus(base_reward, "daily_reward")


func format_time_until_next_day() -> String:
	var seconds_per_day = 86400
	var now = game._get_unix_time()
	var seconds_left = seconds_per_day - (now % seconds_per_day)
	var hours = int(seconds_left / 3600)
	var minutes = int((seconds_left % 3600) / 60)
	var seconds = int(seconds_left % 60)
	return "%02d:%02d:%02d" % [hours, minutes, seconds]


func claim_daily_reward() -> void:
	if not can_claim_daily_reward():
		return

	var today = game._get_current_day_number()
	if game.last_daily_reward_day == today - 1:
		game.daily_reward_streak += 1
	else:
		game.daily_reward_streak = 1

	game.last_daily_reward_day = today
	game.best_daily_reward_streak = maxi(game.best_daily_reward_streak, game.daily_reward_streak)
	var reward = get_daily_reward_amount()
	game._gain_coins(reward, game.daily_reward_button.get_global_rect().get_center())
	game._update_upgrade_ui()
	game._update_achievements_ui()
	update_daily_reward_ui()
	game._spawn_click_popup(reward, 1)
	game._play_reward_redeem_sound()
	game._save_game()
