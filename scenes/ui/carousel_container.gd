@tool
extends Node2D
class_name CarouselContainer


@export var is_vm: Control = null
@export var spacing: float = 20.0

@export var wraparound_enabled: bool = false
@export var wraparound_radius: float = 300.0
@export var wraparound_height: float = 50.0

@export_range(0.0, 1.0) var opacity_strength: float = 0.35
@export_range(0.0, 1.0) var scale_strength: float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1

@export var smoothing_speed: float = 6.5
@export var selected_index: int = 0
@export var follow_button_focus: bool = false

@export var position_offset_node: Control = null


#varibles for sandbox mode
@onready var title: Label = $"../MapDetails/sbName"
@onready var path: Label = $"../MapDetails/Difficulty"
@onready var description: Label = $"../MapDetails/Description"
@onready var paragraph: Label = $"../MapDetails/Description/Paragraph"

#variables for vmmode
@onready var vm_title: Label = $"../MapDetails/vmName"
@onready var level_recommendation: Label = $"../MapDetails/Suggested"
@onready var vm_description: Label = $"../MapDetails/Description"

var title_array: Array = ["Treatment Area", "Courtyard", "Konbini", "Hellbent", "The Maze", "Requiem"]
var path_num: Array = ["1", "1", "2", "4", "3", "3"]
var sb_map_desc_paragraph: Array = [
	"After the collapse of Earth’s Core, several facilities were converted into rehabilitation centers. The Treatment Area became a refuge for the survivors, where the remaining humans continue to support the artificial magnetic field. However, its direct connection to the S.E.R.V.E.R., or the Secret Enigmatic Regent Vanguard of Earth's Remnant, eventually attracted the attention of cyber threats, as they see it as the next source of immense power after Earth's Core was destroyed. What is now once built to heal becomes a battlefield against cyber threats.",
	"Built around the haven, The Courtyard was a place for gathering, once full of people’s laughter, and a place that continues to support life despite the world’s devastation. The happy memories remain, but the peace has long vanished. Now, a route for hostile enemies that targets the power of S.E.R.V.E.R echoes. ",
	"The Konbini was originally a place to provide food, medicine, and daily necessities to humanity. However, due to its continued service, multiple paths, and the flow of data and power from S.E.R.V.E.R., it has attracted cyber threats. A perfect way to exploit the artificial rotating heart of humanity’s last hope. What once filled the convenience and hunger has become another battlefield for humanity’s struggle for the future.",
	"An abandoned community facility that studied the advancement of artificial intelligence. A place where humanity once hoped for convenience through AI is now being destroyed by what was once created by them. The environment was once full of innovation now a place for exploited paths, corrupted machines, and traces of vulnerabilities. It has attracted the attention of cyber threats because of its united path leading to the S.E.R.V.E.R., a perfect path for their objective.",
	"As cyber threats continue to evolve, the founder of S.E.R.V.E.R constructed a massive security network design to delay the inevitable, the ruin brought by the hostile AI. The Maze was designed to have a complicated pathway for intruders to be confused and conceal secrets. However, enemies learned, adapted, and forcefully attacked the Maze to exploit the S.E.R.V.E.R.’s power that holds humanity’s only hope. Now, the Maze serves not only to conceal critical assets but also as a defense.",
	"Placed within its ground, the S.E.R.V.E.R., a facility that keeps the Earth alive through an artificial magnetic field. This place holds humanity’s last hope and last line of defense. Within its hall, it contains the past and the truth. The event that led to the ruins. The answer to who we are. Here, the final battlefield awaits, which determines the future of humanity.  "
]
var sb_map_desc: Array = [
	"The recovery from the devastating catastrophe.",
	"A memory of happy echoes.",
	"A light that stays even during the darkest.",
	"The perfect place for corruption.",
	"The place that once held critical assets.",
	"The place that remembers the past."
]

#virual mode
var vm_title_array: Array = ["Ticking Bomb", "Swarm Overload", "Malware Interruption", "Random Defense", "DDoS Stress Test", "Ransomware in Action", "Switched Positions", "Automatic Defense", "Endless Onslaught"]
var recommended: Array = ["5", "10", "16", "25", "34", "37", "45", "50", "51"]
var vm_map_desc_paragraph: Array = [
	"The S.E.R.V.E.R. malfunctions; it loses health every 5 seconds. Defeat 300 virus enemies before the S.E.R.V.E.R. health reaches 0.",
	"A massive outbreak of Worms and Spam floods the paths. Defeat 1,000 enemies without taking any damage.",
	"The S.E.R.V.E.R. has only 1 HP left. Win the game without taking any damage from malware enemies for 7 waves. A single damage will cost the player everything. The player must defend the S.E.R.V.E.R. at any cost.",
	"Random towers randomly appear. The player must place them correctly and strategically. Win 7 waves to win the challenge.",
	"Only Distributed Denial-of-Service (DDoS) attacks the S.E.R.V.E.R. to test how it handles floods of internet traffic. The player must defeat 300 enemies before the timer runs out.",
	"Random numbers (40%) of blocks are locked. You cannot put towers in them. Win 7 waves to win the challenges. Additionally, every 3 waves, the randomly locked blocks shift position, forcing the player to adapt quickly to win the challenge.",
	"The battlefield is already filled with defense towers. The player must breach the S.E.R.V.E.R. Defeat the S.E.R.V.E.R. ( 0 HP) by placing enemies.",
	"All sentinels are disabled during the challenge. Win 7 waves to win the challenge.",
	"Survive as long as you can!                                                       "

]


var count: int = 0


func _ready() -> void:
	Data.change_challenge.connect(_change_challenge)

func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return

	selected_index = clamp(selected_index, 0, position_offset_node.get_child_count() - 1)
	
	for i in position_offset_node.get_children():
		if wraparound_enabled:
			var max_index_range = max(1, (position_offset_node.get_child_count() - 1) / 2.0)
			var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI
			var x = sin(angle) * wraparound_radius
			var y = cos(angle) * wraparound_height
			var target_pos = Vector2(x, y - wraparound_height) - i.size / 2.0
			i.position = lerp(i.position, target_pos, smoothing_speed * delta)
		else:
			var position_x = 0
			if i.get_index() > 0:
				position_x = position_offset_node.get_child(i.get_index() - 1).position.x + position_offset_node.get_child(i.get_index() - 1).size.x + spacing
			i.position = Vector2(position_x, -i.size.y / 2.0)
	
		i.pivot_offset = i.size / 2.0
		var target_scale = 1.0 - (scale_strength * abs(i.get_index() - selected_index))
		target_scale = clamp(target_scale, scale_min, 1.0)
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed * delta)

		var target_opacity = 1.0 - (opacity_strength * abs(i.get_index() - selected_index))
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed * delta)

		if i.get_index() == selected_index:
			i.z_index = 1
		else:
			i.z_index = - abs(i.get_index() - selected_index)
		
		if follow_button_focus and i.has_focus():
			selected_index = i.get_index()

	if wraparound_enabled:
		position_offset_node.position.x = lerp(position_offset_node.position.x, 0.0, smoothing_speed * delta)
	else:
		position_offset_node.position.x = lerp(position_offset_node.position.x, - (position_offset_node.get_child(selected_index).position.x + position_offset_node.get_child(selected_index).size.x / 2.0), smoothing_speed * delta)

func _left():
	selected_index -= 1
	if selected_index < 0:
		selected_index += 1

	count -= 1
	if count == -1:
		count = 1
		return

	if Data.is_vmmode:
		vm_title.text = vm_title_array[count]
		vm_description.text = vm_map_desc_paragraph[count]
		level_recommendation.text = recommended[count]

	if !Data.is_vmmode:
		title.text = title_array[count]
		path.text = path_num[count]
		description.text = sb_map_desc[count]
		paragraph.text = sb_map_desc_paragraph[count]
		match path_num[count]:
			"1":
				path.add_theme_color_override("font_color", Color(0.129, 0.596, 0.678))
			"2":
				path.add_theme_color_override("font_color", Color(0.277, 0.622, 0.287))
			"3":
				path.add_theme_color_override("font_color", Color(0.784, 0.431, 0.118))
			"4":
					path.add_theme_color_override("font_color", Color(1.0, 0.0, 0.016))
		

func _right():
	selected_index += 1
	if selected_index > position_offset_node.get_child_count() - 1:
		selected_index -= 1

	count += 1


	if Data.is_vmmode:
		if count == 9:
			count = 8
			return
		vm_title.text = vm_title_array[count]
		vm_description.text = vm_map_desc_paragraph[count]
		level_recommendation.text = recommended[count]
	

	if !Data.is_vmmode:
		if count == 6:
			count = 5
			return
		
		title.text = title_array[count]
		path.text = path_num[count]
		description.text = sb_map_desc[count]
		paragraph.text = sb_map_desc_paragraph[count]

		match path_num[count]:
			"1":
				path.add_theme_color_override("font_color", Color(0.129, 0.596, 0.678))
			"2":
				path.add_theme_color_override("font_color", Color(0.277, 0.622, 0.287))
			"3":
				path.add_theme_color_override("font_color", Color(0.784, 0.431, 0.118))
			"4":
				path.add_theme_color_override("font_color", Color(1.0, 0.0, 0.016))

func _change_challenge(index: int) -> void:
	if is_vm:
		print("yea")
		selected_index = index
		count = index
		vm_title.text = vm_title_array[count]
		vm_description.text = vm_map_desc_paragraph[count]
		level_recommendation.text = recommended[count]
	if is_vm == null:
		return
