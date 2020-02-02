extends KinematicBody2D
class_name Actor

# vector, pointing away from the floor
const FLOOR_NORMAL = Vector2.UP

export var speed = Vector2(900.0, 1000.0)
export var gravity = 4000.0

var velocity = Vector2.ZERO
