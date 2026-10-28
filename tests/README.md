# Mobile touch regression checks

Run from the project folder with Godot 4.6:

```powershell
godot --headless --path . --script res://tests/test_mobile_touch.gd
```

The test scene disables loading and saving progress. It injects touch events through the viewport at three phone sizes and checks list scrolling, fractional movements, page swipes, nested sections, settings, pause details, horizontal tabs, multiple fingers, canceled gestures, duplicate mouse events, and item dragging. Test files are excluded from exports.

For manual device verification, check a quick vertical swipe versus holding an inventory item before dragging it, scroll Achievements and each Settings page, and interrupt a swipe by switching apps. Confirm the clickable Classic Cat appears at launch. Desktop simulations do not replace Android/iPhone testing or a signed iOS build.
