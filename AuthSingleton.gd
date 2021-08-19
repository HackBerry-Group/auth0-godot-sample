extends Node

const AUTH0_DOMAIN := "<your domain>"
const AUDIENCE := "<api identifier>"
const SCOPE := "<scope>"
const CLIENT_ID := "<client id>"

const AUTH_URL := "https://%s/oauth/token" % AUTH0_DOMAIN

signal auth_failed(response_code, body)
signal auth_succeeded(access_token, token_type)

var current_request: HTTPRequest
var timer: Timer

var access_token: String
var token_type: String
var last_username: String setget, __get_last_username
var last_password: String setget, __get_last_password


func _ready() -> void:
    if not timer:
        timer = Timer.new()
        timer.one_shot = false
        add_child(timer)

        # warning-ignore: return_value_discarded
        timer.connect("timeout", self, "_on_timeout")


func login(username: String, password: String) -> void:
    timer.stop()

    if current_request:
        current_request.cancel_request()
        current_request.disconnect("request_completed", self, "_on_request_completed")
        current_request.queue_free()
        current_request = null

    var query_string := "grant_type=password"
    query_string += "&username=%s" % username.percent_encode()
    query_string += "&password=%s" % password.percent_encode()
    query_string += "&audience=%s" % AUDIENCE.percent_encode()
    query_string += "&scope=%s" % SCOPE.percent_encode()
    query_string += "&client_id=%s" % CLIENT_ID.percent_encode()

    current_request = HTTPRequest.new()
    add_child(current_request)
    assert(
        current_request.request(
            AUTH_URL,
            ["Content-Type: application/x-www-form-urlencoded"],
            true,
            HTTPClient.METHOD_POST,
            query_string
        ) == OK
    )

    # warning-ignore: return_value_discarded
    current_request.connect("request_completed", self, "_on_request_completed")

    last_username = username
    last_password = password


func _on_request_completed(
    result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray
) -> void:
    if result != HTTPRequest.RESULT_SUCCESS:
        prints("Result failed:", result, body.get_string_from_utf8())
        emit_signal("auth_failed", response_code, body)
        return

    if response_code < 200 or response_code >= 300:
        prints("Bad response code:", response_code, body.get_string_from_utf8())
        emit_signal("auth_failed", response_code, body)
        return

    var json_parse := JSON.parse(body.get_string_from_utf8())
    var json: Dictionary = json_parse.result

    access_token = json.access_token
    token_type = json.token_type
    timer.start(json.expires_in / 2)
    prints("Authenticated:", json.expires_in, access_token, token_type)
    emit_signal("auth_succeeded", access_token, token_type)


# this lets us prevent other nodes from being able to access the username and password we use to
# refresh the auth token
func __get_last_username():
    return null


func __get_last_password():
    return null
