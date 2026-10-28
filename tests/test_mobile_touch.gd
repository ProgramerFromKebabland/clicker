extends SceneTree

var game
var failures := 0
var checks := 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(label)

func touch(pos: Vector2, pressed: bool, index := 0, canceled := false) -> void:
	var e := InputEventScreenTouch.new()
	e.position = pos
	e.pressed = pressed
	e.index = index
	e.canceled = canceled
	root.push_input(e, true)

func drag(pos: Vector2, relative: Vector2, index := 0) -> void:
	var e := InputEventScreenDrag.new()
	e.position = pos
	e.relative = relative
	e.index = index
	root.push_input(e, true)

func run() -> void:
	game = load("res://scenes/main.tscn").instantiate()
	game.set_script(load("res://tests/touch_test_game.gd"))
	root.add_child(game)
	await process_frame
	await process_frame
	game.reduce_motion_enabled = true
	game.menu_swipe_enabled = true
	for dimensions in [Vector2i(360, 640), Vector2i(390, 844), Vector2i(720, 1280)]:
		root.size = dimensions
		await process_frame
		await process_frame
		for destination in ["inventory", "inventory:boosts", "skins", "skins:background", "skins:crates", "missions", "museum", "shop:upgrades", "shop:boosts", "shop:food", "upgrades", "boosts"]:
			var parts: PackedStringArray = destination.split(":")
			game._on_telegram_destination_requested(parts[0], 0)
			if parts.size() > 1:
				match parts[0]:
					"skins": game._set_skins_section(parts[1])
					"inventory": game._show_inventory_tab(parts[1])
					"shop": game._show_shop_section(parts[1])
			await create_timer(0.45).timeout
			var scrolls: Array[Node] = game.find_children("*", "ScrollContainer", true, false)
			for node in scrolls:
				var scroll := node as ScrollContainer
				if not scroll.is_visible_in_tree() or scroll.vertical_scroll_mode == ScrollContainer.SCROLL_MODE_DISABLED:
					continue
				var point := scroll.get_global_rect().get_center()
				if game._get_scroll_at_position(point) != scroll:
					continue
				scroll.scroll_vertical = 0
				touch(point, true)
				for step in 160:
					drag(point - Vector2(0, (step + 1) * 0.25), Vector2(0, -0.25))
				var maximum := scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page
				check(maximum <= 0 or scroll.scroll_vertical > 0, "%s %s vertical scroll" % [dimensions, destination])
				check(not game.telegram_navigation.swipe_dragging, "vertical scrolling does not page")
				touch(point - Vector2(0, 40), false)
				check(game.touch_scroll_index == -1, "scroll releases owner")
		# Swipe forward and backward through every top destination.
		game._on_telegram_destination_requested("main", 0)
		await create_timer(0.45).timeout
		for destination in ["inventory", "skins", "missions", "museum", "missions", "skins", "inventory", "main"]:
			var current: int = game.telegram_navigation.TOP_DESTINATIONS.find(game.telegram_navigation.current_destination)
			var target: int = game.telegram_navigation.TOP_DESTINATIONS.find(destination)
			var direction := signi(target - current)
			var size: Vector2 = game.get_viewport_rect().size
			var point := Vector2(size.x * (0.8 if direction > 0 else 0.2), size.y * 0.55)
			touch(point, true)
			# A second finger must not replace the active swipe.
			touch(point + Vector2(5, 5), true, 1)
			touch(point + Vector2(5, 5), false, 1)
			var end := point - Vector2(direction * size.x * 0.6, 0)
			drag(end, end - point)
			touch(end, false)
			await create_timer(0.45).timeout
			check(game.telegram_navigation.current_destination == destination, "%s swipe to %s" % [dimensions, destination])
		game._show_settings_shell()
		await process_frame
		await process_frame
		for index in game.settings_pages.size():
			game._show_settings_page(index, false)
			await process_frame
			await process_frame
			var scroll: ScrollContainer = game.settings_pages[index].find_child("SettingsPageScroll", true, false)
			var point := scroll.get_global_rect().get_center()
			# Find a point away from sliders.
			point.x = scroll.global_position.x + 4
			check(game._get_scroll_at_position(point) == scroll, "settings page hit test %d" % index)
			scroll.scroll_vertical = 0
			touch(point, true)
			drag(point - Vector2(0, 100), Vector2(0, -100))
			var maximum := scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page
			check(maximum <= 0 or scroll.scroll_vertical > 0, "settings page scroll %d" % index)
			touch(point - Vector2(0, 100), false)
			check(game.settings_swipe_touch_index == -1, "settings scroll releases pager owner")
		game._show_settings_page(0, false)
		await process_frame
		var size: Vector2 = game.get_viewport_rect().size
		var point := Vector2(size.x * 0.85, size.y * 0.75)
		touch(point, true)
		drag(point - Vector2(size.x * 0.65, 0), Vector2(-size.x * 0.65, 0))
		touch(point - Vector2(size.x * 0.65, 0), false)
		await create_timer(0.45).timeout
		check(game.settings_current_page == 1, "settings swipe after vertical scrolling")
		game._close_settings_shell()
		await process_frame
	for panel in [game.stats_panel, game.achievements_panel]:
		if panel == game.stats_panel:
			game._show_stats()
		else:
			game._show_achievements()
		await create_timer(0.35).timeout
		var detail_scroll: Control = game.achievements_list if panel == game.achievements_panel else game._find_scroll_container(panel)
		var detail_point := detail_scroll.get_global_rect().get_center()
		check(game._get_scroll_at_position(detail_point) == detail_scroll, "pause detail finds its own scroll")
		detail_scroll.get_v_scroll_bar().value = 0
		touch(detail_point, true)
		drag(detail_point - Vector2(0, 100), Vector2(0, -100))
		var maximum: float = detail_scroll.get_v_scroll_bar().max_value - detail_scroll.get_v_scroll_bar().page
		check(maximum <= 0 or detail_scroll.get_v_scroll_bar().value > 0, "pause detail scrolls")
		touch(detail_point - Vector2(0, 100), false)
		game._close_pause_detail_shell()
		await create_timer(0.35).timeout

	# A native touch must survive the duplicate mouse event generated by phones.
	game._on_telegram_destination_requested("main", 0)
	await create_timer(0.45).timeout
	var size: Vector2 = game.get_viewport_rect().size
	var point := Vector2(size.x * 0.8, size.y * 0.55)
	touch(point, true)
	var mouse := InputEventMouseButton.new()
	mouse.device = InputEvent.DEVICE_ID_EMULATION
	mouse.button_index = MOUSE_BUTTON_LEFT
	mouse.pressed = true
	mouse.position = point + Vector2(90, 0)
	root.push_input(mouse, true)
	check(game.telegram_navigation.touch_start == point, "emulated mouse does not reset touch start")
	var end := point - Vector2(size.x * 0.65, 0)
	drag(end, end - point)
	touch(end, false, 0, true)
	await create_timer(0.45).timeout
	check(game.telegram_navigation.current_destination == "main", "canceled swipe returns to original page")
	check(game.telegram_navigation.swipe_touch_index == -1, "canceled swipe releases finger")

	# Force overflow to verify hidden horizontal tabs can still be reached.
	var nav = game.telegram_navigation
	for button in nav.top_buttons:
		button.custom_minimum_size.x = 300
	await process_frame
	await process_frame
	var tab_point: Vector2 = nav.top_scroll.get_global_rect().get_center()
	touch(tab_point, true)
	drag(tab_point - Vector2(120, 0), Vector2(-120, 0))
	check(nav.top_scroll.scroll_horizontal > 0, "horizontal top tabs scroll")
	touch(tab_point - Vector2(120, 0), false)
	nav._apply_responsive_metrics()

	game._show_settings_shell()
	await process_frame
	await process_frame
	for target in [1, 2, 3, 2, 1, 0]:
		var direction: int = signi(target - game.settings_current_page)
		point = Vector2(size.x * (0.85 if direction > 0 else 0.15), size.y * 0.75)
		touch(point, true)
		touch(point + Vector2(0, 4), true, 1)
		touch(point + Vector2(0, 4), false, 1)
		end = point - Vector2(direction * size.x * 0.65, 0)
		drag(end, end - point)
		touch(end, false)
		await create_timer(0.45).timeout
		check(game.settings_current_page == target, "settings multi-finger swipe to %d" % target)
	game._close_settings_shell()
	await process_frame

	# Quick item gestures scroll; holding first preserves drag-and-drop.
	game._on_telegram_destination_requested("inventory", 0)
	await create_timer(0.45).timeout
	var food_id: String = game._get_food_id(0)
	game.food_inventory[food_id] = 1
	var scroll: ScrollContainer = game.food_scroll
	point = scroll.get_global_rect().get_center()
	touch(point, true)
	var item_touch := InputEventScreenTouch.new()
	item_touch.position = point
	item_touch.index = 0
	item_touch.pressed = true
	game._on_food_icon_gui_input(item_touch, food_id)
	drag(point - Vector2(0, 60), Vector2(0, -60))
	check(game.dragged_food_id.is_empty(), "quick vertical swipe does not drag item")
	touch(point - Vector2(0, 60), false)
	await create_timer(0.12).timeout
	touch(point, true)
	game._on_food_icon_gui_input(item_touch, food_id)
	await create_timer(0.28).timeout
	drag(point - Vector2(60, 0), Vector2(-60, 0))
	check(game.dragged_food_id == food_id, "hold and drag item survives pager arbitration")
	touch(Vector2(-100, -100), false)

	check(ProjectSettings.get_setting("application/boot_splash/image") == "res://assets/cat1.png", "splash uses clickable cat")
	check(ProjectSettings.get_setting("application/boot_splash/show_image"), "splash enabled")
	print("TOUCH CHECKS: %d, FAILURES: %d" % [checks, failures])
	game.queue_free()
	await process_frame
	quit(1 if failures else 0)


