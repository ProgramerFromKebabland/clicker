extends RefCounted
class_name BigCounter

## Exact, non-negative integer storage for clicker resources.
##
## Values are split into base-1,000,000,000 chunks. Memory grows by only one
## integer chunk per nine decimal digits, and normal gameplay operations touch
## only the lowest few chunks.

const BASE := 1000000000
const CHUNK_DIGITS := 9

var chunks: Array[int] = [0]


func set_zero() -> void:
	chunks = [0]


func is_zero() -> bool:
	return chunks.size() == 1 and chunks[0] == 0


func set_from_int(value: int) -> void:
	set_zero()
	add_int(maxi(0, value))


func set_from_decimal_string(raw_value: String) -> bool:
	var value := raw_value.strip_edges()
	if value.begins_with("+"):
		value = value.substr(1)
	if value.is_empty():
		set_zero()
		return false
	for character in value:
		if character < "0" or character > "9":
			set_zero()
			return false

	value = value.trim_prefix("0")
	if value.is_empty():
		set_zero()
		return true

	chunks.clear()
	var end := value.length()
	while end > 0:
		var start := maxi(0, end - CHUNK_DIGITS)
		chunks.append(int(value.substr(start, end - start)))
		end = start
	_trim()
	return true


func copy_from(other: BigCounter) -> void:
	chunks = other.chunks.duplicate()


func add_int(value: int) -> void:
	if value <= 0:
		return
	var carry := value
	var index := 0
	while carry > 0:
		if index >= chunks.size():
			chunks.append(0)
		var add_chunk := carry % BASE
		@warning_ignore("integer_division")
		carry /= BASE
		var total := chunks[index] + add_chunk
		if total >= BASE:
			total -= BASE
			carry += 1
		chunks[index] = total
		index += 1


func can_afford_int(value: int) -> bool:
	if value <= 0:
		return true
	if chunks.size() > 3:
		return true
	return to_clamped_int(value) >= value


func subtract_int(value: int) -> bool:
	if value <= 0:
		return true
	if not can_afford_int(value):
		return false

	var borrow_value := value
	var index := 0
	var borrow := 0
	while borrow_value > 0 or borrow > 0:
		var subtract_chunk := borrow_value % BASE
		@warning_ignore("integer_division")
		borrow_value /= BASE
		var result := chunks[index] - subtract_chunk - borrow
		if result < 0:
			result += BASE
			borrow = 1
		else:
			borrow = 0
		chunks[index] = result
		index += 1
	_trim()
	return true


func compare(other: BigCounter) -> int:
	if chunks.size() != other.chunks.size():
		return 1 if chunks.size() > other.chunks.size() else -1
	for index in range(chunks.size() - 1, -1, -1):
		if chunks[index] != other.chunks[index]:
			return 1 if chunks[index] > other.chunks[index] else -1
	return 0


func exceeds_int(value: int) -> bool:
	if value < 0:
		return true
	if chunks.size() > 3:
		return true
	var value_chunk_count := 1
	var remaining_value := value
	while remaining_value >= BASE:
		@warning_ignore("integer_division")
		remaining_value /= BASE
		value_chunk_count += 1
	if chunks.size() != value_chunk_count:
		return chunks.size() > value_chunk_count
	var divisor := 1
	for _index in range(1, chunks.size()):
		divisor *= BASE
	for index in range(chunks.size() - 1, -1, -1):
		@warning_ignore("integer_division")
		var value_chunk := (value / divisor) % BASE
		if chunks[index] != value_chunk:
			return chunks[index] > value_chunk
		@warning_ignore("integer_division")
		divisor /= BASE
	return false


func to_clamped_int(maximum: int) -> int:
	if maximum <= 0:
		return 0
	var result := 0
	for index in range(chunks.size() - 1, -1, -1):
		var chunk := chunks[index]
		@warning_ignore("integer_division")
		var safe_prefix := (maximum - chunk) / BASE
		if result > safe_prefix:
			return maximum
		result = (result * BASE) + chunk
	return mini(result, maximum)


func digit_count() -> int:
	return ((chunks.size() - 1) * CHUNK_DIGITS) + str(chunks.back()).length()


func to_decimal_string() -> String:
	var result := str(chunks.back())
	for index in range(chunks.size() - 2, -1, -1):
		result += "%09d" % chunks[index]
	return result


func to_grouped_string() -> String:
	var plain := to_decimal_string()
	var first_group_length := plain.length() % 3
	if first_group_length == 0:
		first_group_length = 3
	var result := plain.substr(0, first_group_length)
	var index := first_group_length
	while index < plain.length():
		result += "," + plain.substr(index, 3)
		index += 3
	return result


func to_abbreviated_string(suffixes: Array[String], significant_digits: int = 7) -> String:
	var plain := to_decimal_string()
	if plain.length() <= 3:
		return plain
	significant_digits = clampi(significant_digits, 3, 12)
	@warning_ignore("integer_division")
	var group := (plain.length() - 1) / 3
	var whole_digits := plain.length() - (group * 3)
	var decimal_digits := mini(plain.length() - whole_digits, maxi(0, significant_digits - whole_digits))
	var shown := plain.substr(0, whole_digits)
	if decimal_digits > 0:
		var decimal_part := plain.substr(whole_digits, decimal_digits)
		while decimal_part.ends_with("0"):
			decimal_part = decimal_part.trim_suffix("0")
		if not decimal_part.is_empty():
			shown += "." + decimal_part
	if group < suffixes.size():
		return shown + suffixes[group]

	return to_scientific_string(significant_digits)


func to_scientific_string(significant_digits: int = 7) -> String:
	var plain := to_decimal_string()
	if plain.length() <= 3:
		return plain
	significant_digits = clampi(significant_digits, 3, 12)
	var scientific_decimal := plain.substr(1, mini(plain.length() - 1, significant_digits - 1))
	while scientific_decimal.ends_with("0"):
		scientific_decimal = scientific_decimal.trim_suffix("0")
	var scientific := plain.substr(0, 1)
	if not scientific_decimal.is_empty():
		scientific += "." + scientific_decimal
	return "%se%d" % [scientific, plain.length() - 1]


func _trim() -> void:
	while chunks.size() > 1 and chunks.back() == 0:
		chunks.pop_back()
