extends Node

# {enemy_type: kill_count}
var enemy_kills: Dictionary = {}

# {enemy_type: {"name": String, "texture": String}}
var enemy_info: Dictionary = {}

signal enemy_killed(enemy_type: Data.Enemy, new_count: int)

func register_enemy_type(enemy_type: Data.Enemy) -> void:
    if enemy_info.has(enemy_type):
        return
    var data = Data.ENEMY_DATA[enemy_type]
    enemy_info[enemy_type] = {
        "name": data["name"],
        "texture": data["texture"]
    }
    enemy_kills[enemy_type] = 0

func add_kill(enemy_type: Data.Enemy) -> void:
    if not enemy_kills.has(enemy_type):
        register_enemy_type(enemy_type)
    enemy_kills[enemy_type] += 1
    enemy_killed.emit(enemy_type, enemy_kills[enemy_type])

func get_sorted_enemies() -> Array:
    var result = []
    for enemy_type in enemy_kills.keys():
        result.append({
            "enemy_type": enemy_type,
            "kills": enemy_kills[enemy_type]
        })
    result.sort_custom(func(a, b): return a["kills"] > b["kills"])
    return result

func get_max_kills() -> int:
    var max_kills = 0
    for enemy_type in enemy_kills:
        max_kills = max(max_kills, enemy_kills[enemy_type])
    return max_kills