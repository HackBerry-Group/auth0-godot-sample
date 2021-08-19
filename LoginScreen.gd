extends Control

onready var username_input: LineEdit = $VBoxContainer/HBoxContainer/LineEdit
onready var password_input: LineEdit = $VBoxContainer/HBoxContainer2/LineEdit
onready var submit_button := $VBoxContainer/HBoxContainer3/Submit


func _process(_delta: float) -> void:
    submit_button.disabled = username_input.text.empty() or password_input.text.empty()


func _on_Clear_pressed() -> void:
    username_input.text = ""
    password_input.text = ""


func _on_Submit_pressed() -> void:
    prints("Attempting auth")
    Auth.login(username_input.text, password_input.text)
