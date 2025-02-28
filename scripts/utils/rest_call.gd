@tool
extends Node

signal done(obj: Object)  # or null

var _http : HTTPRequest
var _obj : Object

func _create_http_node() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 5.0
	_http.request_completed.connect(_on_completed)
	add_child(_http)

func _on_completed(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == HTTPRequest.Result.RESULT_SUCCESS and code == 200:
		var json := JSON.parse_string(body.get_string_from_utf8()) as Dictionary
		if json != null:
			done.emit(parse_json(json, _obj))
			return
	_obj = null
	done.emit(null)

func rest_call(url: String, obj: Object) -> void:
	if _http == null:
		_create_http_node()

	_obj = obj
	var err := _http.request(url)
	if err != Error.OK:
		done.emit(null)

func abort() -> void:
	if _http != null:
		_obj = null
		_http.cancel_request()

static func parse_json(json: Dictionary, s: Object) -> Object:
	for prop: Dictionary in s.get_property_list():
		if prop["usage"] == 4096:
			var key := prop["name"] as String
			if key in json:
				s[key] = json[key]
			else:
				return null
	return s
