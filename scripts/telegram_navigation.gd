extends Control

signal destination_requested(destination: String, direction: int)
signal pause_requested
signal layout_metrics_changed(top_height: float, bottom_height: float)
signal pager_drag_started(direction: int)
signal pager_dragged(delta_x: float, velocity_x: float, direction: int)
signal pager_drag_released(delta_x: float, velocity_x: float, direction: int)

const TOP_DESTINATIONS: Array[String] = ["main", "inventory", "skins", "missions", "museum"]
const BOTTOM_DESTINATIONS: Array[String] = ["shop", "main", "pause"]
const TOP_LABELS: Array[String] = ["Main", "Inventory", "Skins", "Missions", "Museum"]
const BOTTOM_LABELS: Array[String] = ["Shop", "Main", "Pause"]
const BOTTOM_ICON_PATHS: Array[String] = [
	"res://assets/ui/navigation/shop.svg",
	"res://assets/ui/navigation/main.svg",
	"res://assets/ui/navigation/pause.svg",
]
const GOLD_ACCENT := Color("#f2b84b")
const SURFACE := Color(0.035, 0.038, 0.045, 0.98)
const SURFACE_RAISED := Color(0.06, 0.066, 0.078, 0.98)
const TEXT_MUTED := Color("#a5adbb")
const TOP_ACCENTS: Array[Color] = [
	GOLD_ACCENT,
	Color(0.96, 0.68, 0.26),
	Color(0.36, 0.82, 1.0),
	Color(0.3, 0.9, 0.5),
	Color(0.92, 0.58, 0.22),
]
const BOTTOM_ACCENTS: Array[Color] = [
	Color(0.96, 0.68, 0.26),
	GOLD_ACCENT,
	Color(0.68, 0.42, 1.0),
]
# Telegram measures these surfaces in density-independent pixels. The project
# renders a 720-wide canvas into a 540-wide debug/mobile window, so slightly
# larger design-space values preserve Telegram's physical touch targets.
const ACTION_BAR_PORTRAIT := 72.0
const ACTION_BAR_LANDSCAPE := 64.0
const FILTER_TABS_HEIGHT := 60.0
const BOTTOM_BAR_HEIGHT := 78.0
const BOTTOM_HORIZONTAL_PADDING := 12.0

var current_destination := "main"
var top_buttons: Array[Button] = []
var bottom_buttons: Array[Button] = []
var bottom_icon_views: Array[TextureRect] = []
var bottom_labels: Array[Label] = []
var bottom_selectors: Array[PanelContainer] = []
var bottom_active: Array[bool] = []
var bottom_hovered: Array[bool] = []
var pause_active := false
var indicator: PanelContainer
var top_scroll: ScrollContainer
var top_bar: PanelContainer
var bottom_bar: PanelContainer
var title_safe_margin: MarginContainer
var title_row: HBoxContainer
var tabs_background: PanelContainer
var tabs_container: HBoxContainer
var bottom_safe_margin: MarginContainer
var bottom_row: Control
var top_height := FILTER_TABS_HEIGHT
var bottom_height := BOTTOM_BAR_HEIGHT
var safe_top_inset := 0.0
var touch_start := Vector2.ZERO
var touch_last := Vector2.ZERO
var tracking_swipe := false
var swipe_consumed := false
var swipe_dragging := false
var swipe_direction := 0
var swipe_velocity_x := 0.0
var interaction_enabled := true
var active_tween: Tween


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# This fullscreen node observes gestures only. PASS forwards to its parent,
	# not to sibling game controls below it, so the shell itself must be IGNORE.
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 40
	_build_top_bar()
	_build_bottom_bar()
	get_viewport().size_changed.connect(_apply_responsive_metrics)
	_apply_responsive_metrics()
	call_deferred("_select_destination", current_destination, false)


func _build_top_bar() -> void:
	top_bar = PanelContainer.new()
	top_bar.name = "TelegramTopBar"
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.offset_bottom = top_height
	top_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	top_bar.add_theme_stylebox_override(
		"panel",
		_game_style(SURFACE, 0.0, Color(1.0, 1.0, 1.0, 0.1), 1, 5)
	)
	add_child(top_bar)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 0)
	top_bar.add_child(stack)

	title_safe_margin = MarginContainer.new()
	stack.add_child(title_safe_margin)
	title_row = HBoxContainer.new()
	title_row.custom_minimum_size.y = 0.0
	title_safe_margin.add_child(title_row)

	tabs_background = PanelContainer.new()
	tabs_background.custom_minimum_size.y = FILTER_TABS_HEIGHT
	tabs_background.add_theme_stylebox_override(
		"panel",
		_game_style(SURFACE_RAISED, 0.0, Color(1.0, 1.0, 1.0, 0.08), 1, 2)
	)
	stack.add_child(tabs_background)
	var tabs_layer := Control.new()
	tabs_layer.mouse_filter = Control.MOUSE_FILTER_PASS
	tabs_background.add_child(tabs_layer)

	indicator = PanelContainer.new()
	indicator.add_theme_stylebox_override(
		"panel",
		_game_style(
			Color(GOLD_ACCENT.r, GOLD_ACCENT.g, GOLD_ACCENT.b, 0.2),
			16.0,
			Color(GOLD_ACCENT.r, GOLD_ACCENT.g, GOLD_ACCENT.b, 0.55),
			1,
			3
		)
	)
	indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	indicator.position.y = (FILTER_TABS_HEIGHT - 34.0) * 0.5
	indicator.size = Vector2(72.0, 34.0)
	tabs_layer.add_child(indicator)

	top_scroll = ScrollContainer.new()
	top_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	top_scroll.offset_left = 8.0
	top_scroll.offset_right = -8.0
	# Telegram's folder strip scrolls, but never paints a desktop scrollbar.
	top_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	top_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	top_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	tabs_layer.add_child(top_scroll)
	tabs_container = HBoxContainer.new()
	tabs_container.name = "Tabs"
	tabs_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs_container.add_theme_constant_override("separation", 2)
	top_scroll.add_child(tabs_container)
	for index in TOP_LABELS.size():
		var accent := TOP_ACCENTS[index]
		var button := Button.new()
		button.text = TOP_LABELS[index]
		button.flat = false
		button.custom_minimum_size = Vector2(96, FILTER_TABS_HEIGHT)
		button.add_theme_font_size_override("font_size", 20)
		button.add_theme_color_override("font_color", TEXT_MUTED)
		button.add_theme_color_override("font_hover_color", Color.WHITE)
		button.add_theme_stylebox_override("normal", _old_button_style(accent, "normal"))
		button.add_theme_stylebox_override("hover", _old_button_style(accent, "hover"))
		button.add_theme_stylebox_override("pressed", _old_button_style(accent, "pressed"))
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.pressed.connect(_request_destination.bind(TOP_DESTINATIONS[index]))
		tabs_container.add_child(button)
		top_buttons.append(button)


func _build_bottom_bar() -> void:
	bottom_bar = PanelContainer.new()
	bottom_bar.name = "TelegramBottomBar"
	bottom_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_bar.offset_top = -bottom_height
	bottom_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	var bottom_style := _game_style(SURFACE, 0.0, Color(1.0, 1.0, 1.0, 0.1), 1, 5)
	bottom_style.border_width_top = 1
	bottom_style.border_width_left = 0
	bottom_style.border_width_right = 0
	bottom_style.border_width_bottom = 0
	bottom_bar.add_theme_stylebox_override("panel", bottom_style)
	add_child(bottom_bar)

	bottom_safe_margin = MarginContainer.new()
	bottom_safe_margin.add_theme_constant_override("margin_left", int(BOTTOM_HORIZONTAL_PADDING))
	bottom_safe_margin.add_theme_constant_override("margin_right", int(BOTTOM_HORIZONTAL_PADDING))
	bottom_bar.add_child(bottom_safe_margin)
	bottom_row = Control.new()
	bottom_row.custom_minimum_size.y = BOTTOM_BAR_HEIGHT
	bottom_safe_margin.add_child(bottom_row)

	for index in BOTTOM_LABELS.size():
		var destination := BOTTOM_DESTINATIONS[index]
		var is_main := destination == "main"
		var button := Button.new()
		button.text = ""
		button.flat = false
		button.focus_mode = Control.FOCUS_NONE
		button.anchor_top = 0.0
		button.anchor_bottom = 1.0
		button.anchor_left = float(index) / float(BOTTOM_LABELS.size())
		button.anchor_right = float(index + 1) / float(BOTTOM_LABELS.size())
		button.offset_left = 3.0
		button.offset_top = 4.0
		button.offset_right = -3.0
		button.offset_bottom = -4.0
		if is_main:
			button.offset_top = -3.0
			button.z_index = 2
		var accent := BOTTOM_ACCENTS[index]
		button.add_theme_stylebox_override("normal", _old_button_style(accent, "normal"))
		button.add_theme_stylebox_override("hover", _old_button_style(accent, "hover"))
		button.add_theme_stylebox_override("pressed", _old_button_style(accent, "pressed"))
		button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.pressed.connect(_request_destination.bind(destination))
		button.mouse_entered.connect(_set_bottom_hovered.bind(index, true))
		button.mouse_exited.connect(_set_bottom_hovered.bind(index, false))
		bottom_row.add_child(button)
		bottom_buttons.append(button)

		var selector := PanelContainer.new()
		selector.anchor_left = 0.5
		selector.anchor_right = 0.5
		selector.offset_left = -34.0 if is_main else -32.0
		selector.offset_right = 34.0 if is_main else 32.0
		selector.offset_top = 8.0 if is_main else 11.0
		selector.offset_bottom = 46.0
		selector.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(selector)
		bottom_selectors.append(selector)
		bottom_active.append(false)
		bottom_hovered.append(false)

		var icon := TextureRect.new()
		var icon_size := 36.0 if is_main else 31.0
		icon.anchor_left = 0.5
		icon.anchor_right = 0.5
		icon.offset_left = -icon_size * 0.5
		icon.offset_right = icon_size * 0.5
		icon.offset_top = 7.0 if is_main else 12.0
		icon.offset_bottom = icon.offset_top + icon_size
		icon.texture = load(BOTTOM_ICON_PATHS[index]) as Texture2D
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(icon)
		bottom_icon_views.append(icon)

		var label := Label.new()
		label.text = BOTTOM_LABELS[index]
		label.anchor_right = 1.0
		label.offset_top = 48.0
		label.offset_bottom = 75.0
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.clip_text = true
		label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		label.add_theme_font_size_override("font_size", 20 if is_main else 18)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(label)
		bottom_labels.append(label)


func _apply_responsive_metrics() -> void:
	var viewport_size := get_viewport_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return
	var safe_insets := _get_mobile_safe_insets(viewport_size)
	var action_height := 0.0
	var next_top_height := safe_insets.y + action_height + FILTER_TABS_HEIGHT
	var next_bottom_height := BOTTOM_BAR_HEIGHT + safe_insets.w
	var metrics_changed := not is_equal_approx(top_height, next_top_height) or not is_equal_approx(bottom_height, next_bottom_height)
	top_height = next_top_height
	bottom_height = next_bottom_height
	safe_top_inset = safe_insets.y
	top_bar.offset_bottom = top_height
	title_safe_margin.add_theme_constant_override("margin_top", roundi(safe_insets.y))
	title_row.custom_minimum_size.y = action_height
	tabs_background.custom_minimum_size.y = FILTER_TABS_HEIGHT
	bottom_bar.offset_top = -bottom_height
	bottom_safe_margin.add_theme_constant_override("margin_bottom", roundi(safe_insets.w))
	bottom_row.custom_minimum_size.y = BOTTOM_BAR_HEIGHT
	_layout_top_tabs(viewport_size.x)
	_layout_bottom_items(viewport_size.x)
	call_deferred("_refresh_indicator")
	if metrics_changed:
		layout_metrics_changed.emit(top_height, bottom_height)


func _get_mobile_safe_insets(viewport_size: Vector2) -> Vector4:
	if DisplayServer.get_name() not in ["Android", "iOS"]:
		return Vector4.ZERO
	var screen_size_i := DisplayServer.screen_get_size()
	var screen_size := Vector2(screen_size_i)
	var safe_area_i := DisplayServer.get_display_safe_area()
	var safe_area := Rect2(safe_area_i)
	if screen_size.x <= 0.0 or screen_size.y <= 0.0 or safe_area.size.x <= 0.0 or safe_area.size.y <= 0.0:
		return Vector4.ZERO
	var scale_x := viewport_size.x / screen_size.x
	var scale_y := viewport_size.y / screen_size.y
	return Vector4(
		safe_area.position.x * scale_x,
		safe_area.position.y * scale_y,
		maxf(0.0, screen_size.x - safe_area.end.x) * scale_x,
		maxf(0.0, screen_size.y - safe_area.end.y) * scale_y
	)


func _layout_top_tabs(viewport_width: float) -> void:
	if top_buttons.is_empty():
		return
	var compact := viewport_width < 520.0
	var natural_widths: Array[float] = []
	var natural_total := 0.0
	for button in top_buttons:
		button.add_theme_font_size_override("font_size", 16 if compact else 20)
		var font := button.get_theme_font("font")
		var text_width := font.get_string_size(
			button.text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1.0,
			button.get_theme_font_size("font_size")
		).x
		var natural_width := maxf(64.0 if compact else 72.0, text_width + (26.0 if compact else 32.0))
		natural_widths.append(natural_width)
		natural_total += natural_width
	var separation_total := float(top_buttons.size() - 1) * 2.0
	var available_width := maxf(0.0, viewport_width - 16.0 - separation_total)
	var extra_per_tab := maxf(0.0, available_width - natural_total) / float(top_buttons.size())
	for index in top_buttons.size():
		top_buttons[index].custom_minimum_size = Vector2(natural_widths[index] + extra_per_tab, FILTER_TABS_HEIGHT)


func _layout_bottom_items(viewport_width: float) -> void:
	var compact := viewport_width < 520.0
	for index in bottom_buttons.size():
		var is_main := BOTTOM_DESTINATIONS[index] == "main"
		var selector_half_width := (30.0 if is_main else 27.0) if compact else (34.0 if is_main else 32.0)
		bottom_selectors[index].offset_left = -selector_half_width
		bottom_selectors[index].offset_right = selector_half_width
		bottom_selectors[index].offset_top = (9.0 if is_main else 12.0) if compact else (8.0 if is_main else 11.0)
		bottom_selectors[index].offset_bottom = 44.0 if compact else 46.0
		var icon_size := (30.0 if is_main else 25.0) if compact else (36.0 if is_main else 31.0)
		var icon_top := (8.0 if is_main else 13.0) if compact else (7.0 if is_main else 12.0)
		bottom_icon_views[index].offset_left = -icon_size * 0.5
		bottom_icon_views[index].offset_right = icon_size * 0.5
		bottom_icon_views[index].offset_top = icon_top
		bottom_icon_views[index].offset_bottom = icon_top + icon_size
		bottom_labels[index].offset_top = 47.0 if compact else 48.0
		bottom_labels[index].offset_bottom = 75.0
		bottom_labels[index].add_theme_font_size_override("font_size", (16 if is_main else 14) if compact else (20 if is_main else 18))


func get_top_height() -> float:
	return top_height


func get_bottom_height() -> float:
	return bottom_height


func get_safe_top() -> float:
	return safe_top_inset


func get_destination_button(destination: String) -> Button:
	var top_index := TOP_DESTINATIONS.find(destination)
	if top_index >= 0 and top_index < top_buttons.size():
		return top_buttons[top_index]
	var bottom_index := BOTTOM_DESTINATIONS.find(destination)
	if bottom_index >= 0 and bottom_index < bottom_buttons.size():
		return bottom_buttons[bottom_index]
	return null


func _input(event: InputEvent) -> void:
	if not interaction_enabled:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start = event.position
			touch_last = event.position
			tracking_swipe = _is_in_pager_area(event.position)
			swipe_consumed = false
			swipe_dragging = false
			swipe_direction = 0
			swipe_velocity_x = 0.0
		elif tracking_swipe:
			_release_pager_drag(event.position)
	elif event is InputEventScreenDrag and tracking_swipe:
		touch_last = event.position
		swipe_velocity_x = event.velocity.x
		_update_pager_drag()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start = event.position
			touch_last = event.position
			tracking_swipe = _is_in_pager_area(event.position)
			swipe_consumed = false
			swipe_dragging = false
			swipe_direction = 0
			swipe_velocity_x = 0.0
		elif tracking_swipe:
			_release_pager_drag(event.position)
	elif event is InputEventMouseMotion and tracking_swipe and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		touch_last = event.position
		swipe_velocity_x = event.velocity.x
		_update_pager_drag()


func _is_in_pager_area(position: Vector2) -> bool:
	return position.y > top_height and position.y < size.y - bottom_height


func _update_pager_drag() -> void:
	var delta := touch_last - touch_start
	if not swipe_dragging:
		if absf(delta.x) < 14.0 or absf(delta.x) <= absf(delta.y):
			return
		swipe_dragging = true
		swipe_consumed = true
		swipe_direction = 1 if delta.x < 0.0 else -1
		pager_drag_started.emit(swipe_direction)
	if swipe_direction > 0:
		delta.x = minf(0.0, delta.x)
	else:
		delta.x = maxf(0.0, delta.x)
	pager_dragged.emit(delta.x, swipe_velocity_x, swipe_direction)
	get_viewport().set_input_as_handled()


func _release_pager_drag(end_position: Vector2) -> void:
	tracking_swipe = false
	if not swipe_dragging:
		return
	touch_last = end_position
	var delta_x := touch_last.x - touch_start.x
	if swipe_direction > 0:
		delta_x = minf(0.0, delta_x)
	else:
		delta_x = maxf(0.0, delta_x)
	pager_drag_released.emit(delta_x, swipe_velocity_x, swipe_direction)
	swipe_dragging = false
	swipe_direction = 0
	get_viewport().set_input_as_handled()


func _request_destination(destination: String) -> void:
	if not interaction_enabled:
		return
	if destination == "pause":
		pause_requested.emit()
		return
	var old_index := TOP_DESTINATIONS.find(current_destination)
	var new_index := TOP_DESTINATIONS.find(destination)
	var direction := 0
	if old_index >= 0 and new_index >= 0:
		direction = signi(new_index - old_index)
	destination_requested.emit(destination, direction)


func set_destination(destination: String, animated := true) -> void:
	current_destination = destination
	_select_destination(destination, animated)


func set_interaction_enabled(enabled: bool) -> void:
	interaction_enabled = enabled
	set_process_input(enabled)


func _select_destination(destination: String, animated: bool) -> void:
	for index in top_buttons.size():
		var active: bool = TOP_DESTINATIONS[index] == destination
		var top_accent := TOP_ACCENTS[index]
		top_buttons[index].add_theme_color_override("font_color", top_accent.lightened(0.2) if active else Color(0.88, 0.91, 0.96, 1.0))
		top_buttons[index].add_theme_color_override("font_hover_color", Color.WHITE)
		top_buttons[index].add_theme_stylebox_override("normal", _old_button_style(top_accent, "normal", active))
	var active_bottom_destination := "pause" if pause_active else ("main" if destination in TOP_DESTINATIONS else destination)
	for index in bottom_buttons.size():
		var active: bool = BOTTOM_DESTINATIONS[index] == active_bottom_destination
		var bottom_accent := BOTTOM_ACCENTS[index]
		bottom_active[index] = active
		bottom_icon_views[index].modulate = bottom_accent.lightened(0.16) if active else Color(0.82, 0.85, 0.91, 1.0)
		bottom_labels[index].add_theme_color_override("font_color", bottom_accent.lightened(0.16) if active else Color(0.82, 0.85, 0.91, 1.0))
		_refresh_bottom_selector(index)
	var top_index := TOP_DESTINATIONS.find(destination)
	if top_index >= 0:
		_set_indicator_accent(TOP_ACCENTS[top_index])
		_move_indicator(top_index, animated)
	else:
		indicator.hide()


func _set_bottom_hovered(index: int, hovered: bool) -> void:
	if index < 0 or index >= bottom_hovered.size():
		return
	bottom_hovered[index] = hovered
	_refresh_bottom_selector(index)


func set_pause_active(active: bool) -> void:
	pause_active = active
	_select_destination(current_destination, false)


func _refresh_bottom_selector(index: int) -> void:
	var alpha := 0.0
	if bottom_active[index]:
		alpha = 0.18
	elif bottom_hovered[index]:
		alpha = 0.11
	var accent := BOTTOM_ACCENTS[index]
	var foreground := accent.lightened(0.12) if bottom_active[index] else (Color("#d4dae4") if bottom_hovered[index] else TEXT_MUTED)
	bottom_icon_views[index].modulate = foreground
	bottom_labels[index].add_theme_color_override("font_color", foreground)
	bottom_selectors[index].add_theme_stylebox_override(
		"panel",
		_game_style(
			Color(accent.r, accent.g, accent.b, alpha),
			19.0 if BOTTOM_DESTINATIONS[index] == "main" else 18.0,
			Color(accent.r, accent.g, accent.b, 0.5 if bottom_active[index] else (0.24 if bottom_hovered[index] else 0.0)),
			1 if alpha > 0.0 else 0,
			4 if bottom_active[index] else 0
		)
	)
	bottom_buttons[index].add_theme_stylebox_override(
		"normal",
		_old_button_style(accent, "hover" if bottom_hovered[index] else "normal", bottom_active[index])
	)


func _move_indicator(index: int, animated: bool) -> void:
	if index < 0 or index >= top_buttons.size():
		return
	indicator.show()
	var button := top_buttons[index]
	top_scroll.ensure_control_visible(button)
	var geometry := _get_indicator_geometry(index)
	var target_x := geometry.x
	var target_width := geometry.y
	indicator.position.y = (FILTER_TABS_HEIGHT - 34.0) * 0.5
	indicator.size.y = 34.0
	if active_tween != null and active_tween.is_valid():
		active_tween.kill()
	if animated:
		active_tween = create_tween().set_parallel(true)
		active_tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		active_tween.tween_property(indicator, "position:x", target_x, 0.24)
		active_tween.tween_property(indicator, "size:x", target_width, 0.24)
	else:
		indicator.position.x = target_x
		indicator.size.x = target_width


func _get_indicator_geometry(index: int) -> Vector2:
	var button := top_buttons[index]
	var tab_font: Font = button.get_theme_font("font")
	var text_width: float = tab_font.get_string_size(
		button.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		button.get_theme_font_size("font_size")
	).x
	var target_width: float = maxf(32.0, text_width + 24.0)
	var target_x: float = button.global_position.x - indicator.get_parent().global_position.x + (button.size.x - target_width) * 0.5
	return Vector2(target_x, target_width)


func preview_pager_drag(direction: int, progress: float) -> void:
	var from_index := TOP_DESTINATIONS.find(current_destination)
	var to_index := from_index + direction
	if from_index < 0 or to_index < 0 or to_index >= TOP_DESTINATIONS.size():
		return
	if active_tween != null and active_tween.is_valid():
		active_tween.kill()
	top_scroll.ensure_control_visible(top_buttons[to_index])
	progress = clampf(progress, 0.0, 1.0)
	var from_geometry := _get_indicator_geometry(from_index)
	var to_geometry := _get_indicator_geometry(to_index)
	var preview_accent := TOP_ACCENTS[from_index].lerp(TOP_ACCENTS[to_index], progress)
	_set_indicator_accent(preview_accent)
	indicator.position.x = lerpf(from_geometry.x, to_geometry.x, progress)
	indicator.size.x = lerpf(from_geometry.y, to_geometry.y, progress)
	for index in top_buttons.size():
		var color := TEXT_MUTED
		if index == from_index:
			color = TOP_ACCENTS[from_index].lightened(0.16).lerp(TEXT_MUTED, progress)
		elif index == to_index:
			color = TEXT_MUTED.lerp(TOP_ACCENTS[to_index].lightened(0.16), progress)
		top_buttons[index].add_theme_color_override("font_color", color)


func cancel_pager_preview() -> void:
	_select_destination(current_destination, false)


func _refresh_indicator() -> void:
	_select_destination(current_destination, false)


func _set_indicator_accent(accent: Color) -> void:
	indicator.add_theme_stylebox_override(
		"panel",
		_game_style(
			Color(accent.r, accent.g, accent.b, 0.2),
			16.0,
			Color(accent.r, accent.g, accent.b, 0.55),
			1,
			3
		)
	)


func _old_button_style(accent: Color, state: String, active := false) -> StyleBoxFlat:
	var background := Color(accent.r, accent.g, accent.b, 0.18)
	var border := Color(accent.r, accent.g, accent.b, 0.24)
	var shadow_size := 0
	if state == "hover":
		background = Color(accent.r, accent.g, accent.b, 0.3)
		border = Color(accent.r, accent.g, accent.b, 0.48)
		shadow_size = 3
	elif state == "pressed":
		background = Color(accent.r, accent.g, accent.b, 0.42)
		border = Color(1.0, 1.0, 1.0, 0.42)
	elif active:
		background = Color(accent.r, accent.g, accent.b, 0.34)
		border = Color(accent.r, accent.g, accent.b, 0.68)
		shadow_size = 4
	return _game_style(background, 16.0, border, 1, shadow_size)


func _game_style(
	color: Color,
	radius: float,
	border := Color(0.0, 0.0, 0.0, 0.0),
	border_width := 0,
	shadow_size := 0
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(border_width)
	style.corner_radius_top_left = int(radius)
	style.corner_radius_top_right = int(radius)
	style.corner_radius_bottom_left = int(radius)
	style.corner_radius_bottom_right = int(radius)
	if shadow_size > 0:
		style.shadow_color = Color(0.0, 0.0, 0.0, 0.42)
		style.shadow_size = shadow_size
		style.shadow_offset = Vector2(0.0, 3.0)
	return style
