extends Node

signal level_completed
signal next_map

var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var level_root: Node2D
var level_manager: Node
var wave_active: bool = false
var spawning_wave: bool = false

# waves data

var WAVE_DATA: Dictionary = {
	# MAP 1
	1: {
		"enemies": {
			Data.Enemy.DEFAULT: [24] # 24 Spam
		}
	},
	2: {
		"enemies": {
			Data.Enemy.DEFAULT: [28] # 28 Spam
		}
	},
	3: {
		"enemies": {
			Data.Enemy.DEFAULT: [30] # 30 Spam
		}
	},
	4: {
		"enemies": {
			Data.Enemy.DEFAULT: [16], # 16 Spam
			Data.Enemy.VIRUS: [16] # 16 Virus
		}
	},
	5: {
		"enemies": {
			Data.Enemy.DEFAULT: [16], # 16 Spam
			Data.Enemy.VIRUS: [20] # 20 Virus
		}
	},
	6: {
		"enemies": {
			Data.Enemy.DEFAULT: [15], # 15 Spam
			Data.Enemy.VIRUS: [25] # 25 Virus
		}
	},
	7: {
		"enemies": {
			Data.Enemy.DEFAULT: [14], # 14 Spam
			Data.Enemy.VIRUS: [29] # 29 Virus
		}
	},
	8: {
		"enemies": {
			Data.Enemy.DEFAULT: [13], # 13 Spam
			Data.Enemy.VIRUS: [14], # 14 Virus
			Data.Enemy.ADWARE: [20] # 20 Adware
		}
	},
	9: {
		"enemies": {
			Data.Enemy.DEFAULT: [13], # 13 Spam
			Data.Enemy.VIRUS: [14], # 14 Virus
			Data.Enemy.ADWARE: [23] # 23 Adware
		}
	},
	10: {
		"enemies": {
			Data.Enemy.BOSS1: [1], # 1 Boss (ILOVEYOU)
			Data.Enemy.VIRUS: [40], # 40 Virus
			Data.Enemy.DEFAULT: [15], # 15 Spam
			Data.Enemy.ADWARE: [20] # 20 Adware
		}
	},
# --- MAP 2 (2 paths) ---
	11: {
		"enemies": {
			Data.Enemy.DEFAULT: [7, 7],
			Data.Enemy.VIRUS: [7, 7],
			Data.Enemy.ADWARE: [15, 15]
		}
	},
	12: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 6],
			Data.Enemy.VIRUS: [6, 6],
			Data.Enemy.ADWARE: [8, 7],
			Data.Enemy.WORM: [13, 12]
		}
	},
	13: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 6],
			Data.Enemy.VIRUS: [6, 6],
			Data.Enemy.ADWARE: [8, 7],
			Data.Enemy.WORM: [15, 15]
		}
	},
	14: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 6],
			Data.Enemy.VIRUS: [6, 6],
			Data.Enemy.ADWARE: [8, 7],
			Data.Enemy.WORM: [18, 17]
		}
	},
	15: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 6],
			Data.Enemy.VIRUS: [6, 6],
			Data.Enemy.ADWARE: [8, 7],
			Data.Enemy.WORM: [20, 19]
		}
	},
	16: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 5],
			Data.Enemy.VIRUS: [6, 6],
			Data.Enemy.ADWARE: [7, 6],
			Data.Enemy.WORM: [10, 10],
			Data.Enemy.SPYWARE: [14, 13]
		}
	},
	17: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 5],
			Data.Enemy.VIRUS: [6, 5],
			Data.Enemy.ADWARE: [7, 6],
			Data.Enemy.WORM: [10, 10],
			Data.Enemy.SPYWARE: [16, 15]
		}
	},
	18: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 5],
			Data.Enemy.VIRUS: [6, 5],
			Data.Enemy.ADWARE: [7, 6],
			Data.Enemy.WORM: [9, 9],
			Data.Enemy.SPYWARE: [19, 18]
		}
	},
	19: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 5],
			Data.Enemy.VIRUS: [6, 5],
			Data.Enemy.ADWARE: [6, 6],
			Data.Enemy.WORM: [8, 8],
			Data.Enemy.SPYWARE: [10, 10],
			Data.Enemy.BOTNET: [13, 13]
		}
	},
	20: {
		"enemies": {
			Data.Enemy.BOSS2: [1],
			Data.Enemy.BOTNET: [21, 21],
			Data.Enemy.DEFAULT: [6, 5],
			Data.Enemy.VIRUS: [6, 5],
			Data.Enemy.ADWARE: [6, 6],
			Data.Enemy.WORM: [8, 7],
			Data.Enemy.SPYWARE: [8, 7]
		}
	},
	# --- MAP 3 (2 paths) ---
	21: {
		"enemies": {
			Data.Enemy.DEFAULT: [5, 5],
			Data.Enemy.VIRUS: [5, 5],
			Data.Enemy.ADWARE: [6, 5],
			Data.Enemy.WORM: [8, 7],
			Data.Enemy.SPYWARE: [9, 9],
			Data.Enemy.BOTNET: [18, 18]
		}
	},
	22: {
		"enemies": {
			Data.Enemy.DEFAULT: [5, 4],
			Data.Enemy.VIRUS: [5, 5],
			Data.Enemy.ADWARE: [6, 5],
			Data.Enemy.WORM: [7, 6],
			Data.Enemy.SPYWARE: [8, 7],
			Data.Enemy.BOTNET: [9, 9],
			Data.Enemy.CREDS: [14, 14]
		}
	},
	23: {
		"enemies": {
			Data.Enemy.DEFAULT: [5, 4],
			Data.Enemy.VIRUS: [5, 4],
			Data.Enemy.ADWARE: [5, 5],
			Data.Enemy.WORM: [6, 6],
			Data.Enemy.SPYWARE: [8, 7],
			Data.Enemy.BOTNET: [9, 9],
			Data.Enemy.CREDS: [17, 17]
		}
	},
	24: {
		"enemies": {
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [5, 4],
			Data.Enemy.ADWARE: [5, 5],
			Data.Enemy.WORM: [6, 5],
			Data.Enemy.SPYWARE: [7, 6],
			Data.Enemy.BOTNET: [8, 8],
			Data.Enemy.CREDS: [9, 9],
			Data.Enemy.TROJAN: [13, 13]
		}
	},
	25: {
		"enemies": {
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [4, 4],
			Data.Enemy.ADWARE: [5, 4],
			Data.Enemy.WORM: [5, 5],
			Data.Enemy.SPYWARE: [6, 6],
			Data.Enemy.BOTNET: [8, 7],
			Data.Enemy.CREDS: [8, 7],
			Data.Enemy.TROJAN: [19, 19]
		}
	},
	26: {
		"enemies": {
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [4, 4],
			Data.Enemy.ADWARE: [5, 4],
			Data.Enemy.WORM: [5, 5],
			Data.Enemy.SPYWARE: [6, 6],
			Data.Enemy.BOTNET: [7, 7],
			Data.Enemy.CREDS: [8, 7],
			Data.Enemy.TROJAN: [22, 21]
		}
	},
	27: {
		"enemies": {
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [4, 4],
			Data.Enemy.ADWARE: [5, 4],
			Data.Enemy.WORM: [5, 5],
			Data.Enemy.SPYWARE: [6, 6],
			Data.Enemy.BOTNET: [7, 6],
			Data.Enemy.CREDS: [8, 7],
			Data.Enemy.TROJAN: [25, 25]
		}
	},
	28: {
		"enemies": {
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [4, 4],
			Data.Enemy.ADWARE: [4, 4],
			Data.Enemy.WORM: [5, 4],
			Data.Enemy.SPYWARE: [6, 6],
			Data.Enemy.BOTNET: [7, 6],
			Data.Enemy.CREDS: [7, 6],
			Data.Enemy.TROJAN: [10, 10],
			Data.Enemy.INSIDERTHREAT: [17, 17]
		}
	},
	29: {
		"enemies": {
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [4, 4],
			Data.Enemy.ADWARE: [4, 4],
			Data.Enemy.WORM: [5, 4],
			Data.Enemy.SPYWARE: [6, 5],
			Data.Enemy.BOTNET: [6, 6],
			Data.Enemy.CREDS: [6, 6],
			Data.Enemy.TROJAN: [9, 9],
			Data.Enemy.INSIDERTHREAT: [21, 21]
		}
	},
	30: {
		"enemies": {
			Data.Enemy.BOSS3: [1],
			Data.Enemy.DEFAULT: [4, 4],
			Data.Enemy.VIRUS: [4, 4],
			Data.Enemy.ADWARE: [4, 4],
			Data.Enemy.WORM: [5, 4],
			Data.Enemy.SPYWARE: [6, 5],
			Data.Enemy.BOTNET: [6, 6],
			Data.Enemy.CREDS: [6, 6],
			Data.Enemy.TROJAN: [9, 9],
			Data.Enemy.INSIDERTHREAT: [18, 17]
		}
	},
	# --- MAP 4 (4 paths) ---
	31: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2, 2],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 3, 2, 2],
			Data.Enemy.BOTNET: [3, 3, 3, 3],
			Data.Enemy.CREDS: [3, 3, 3, 3],
			Data.Enemy.TROJAN: [5, 5, 4, 4],
			Data.Enemy.INSIDERTHREAT: [12, 12, 11, 11]
		}
	},
	32: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 3, 2, 2],
			Data.Enemy.BOTNET: [3, 3, 3, 2],
			Data.Enemy.CREDS: [3, 3, 3, 2],
			Data.Enemy.TROJAN: [5, 5, 4, 4],
			Data.Enemy.INSIDERTHREAT: [5, 5, 5, 5],
			Data.Enemy.ROOTKIT: [9, 9, 8, 8]
		}
	},
	33: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2, 2],
			Data.Enemy.BOTNET: [3, 3, 3, 2],
			Data.Enemy.CREDS: [3, 3, 3, 2],
			Data.Enemy.TROJAN: [4, 4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [5, 5, 4, 4],
			Data.Enemy.ROOTKIT: [11, 11, 11, 10]
		}
	},
	34: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2, 2],
			Data.Enemy.BOTNET: [3, 3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2, 2],
			Data.Enemy.TROJAN: [4, 4, 4, 3],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4, 4],
			Data.Enemy.ROOTKIT: [5, 5, 5, 5],
			Data.Enemy.SQL: [8, 8, 8, 8]
		}
	},
	35: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 1, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2, 2],
			Data.Enemy.TROJAN: [4, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4, 3],
			Data.Enemy.ROOTKIT: [5, 5, 4, 4],
			Data.Enemy.SQL: [11, 11, 11, 11]
		}
	},
	36: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 1, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4, 3],
			Data.Enemy.ROOTKIT: [4, 4, 4, 3],
			Data.Enemy.SQL: [5, 5, 4, 4],
			Data.Enemy.DDOS: [9, 9, 9, 8]
		}
	},
	37: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 1, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 3, 3, 3],
			Data.Enemy.ROOTKIT: [4, 4, 4, 3],
			Data.Enemy.SQL: [4, 4, 4, 3],
			Data.Enemy.DDOS: [12, 12, 11, 11]
		}
	},
	38: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 1, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 3, 3, 3],
			Data.Enemy.ROOTKIT: [4, 4, 4, 3],
			Data.Enemy.SQL: [4, 4, 4, 3],
			Data.Enemy.DDOS: [5, 5, 5, 5],
			Data.Enemy.RANSOMWARE: [8, 8, 8, 8]
		}
	},
	39: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 1, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 2, 2],
			Data.Enemy.INSIDERTHREAT: [3, 3, 2, 2],
			Data.Enemy.ROOTKIT: [4, 4, 4, 3],
			Data.Enemy.SQL: [4, 4, 4, 3],
			Data.Enemy.DDOS: [7, 7, 7, 7],
			Data.Enemy.RANSOMWARE: [7, 7, 7, 7]
		}
	},
	40: {
		"enemies": {
			Data.Enemy.BOSS4: [1],
			Data.Enemy.DEFAULT: [2, 2, 1, 1],
			Data.Enemy.VIRUS: [2, 2, 2, 1],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [2, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 2, 2],
			Data.Enemy.INSIDERTHREAT: [3, 3, 2, 2],
			Data.Enemy.ROOTKIT: [3, 3, 2, 2],
			Data.Enemy.SQL: [3, 3, 2, 2],
			Data.Enemy.DDOS: [4, 4, 4, 3],
			Data.Enemy.RANSOMWARE: [4, 4, 4, 3]
		}
	},
	# --- MAP 5 (3 paths) ---
	41: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [3, 2, 2],
			Data.Enemy.ADWARE: [3, 3, 2],
			Data.Enemy.WORM: [3, 3, 2],
			Data.Enemy.SPYWARE: [3, 3, 2],
			Data.Enemy.BOTNET: [3, 3, 2],
			Data.Enemy.CREDS: [3, 3, 3],
			Data.Enemy.TROJAN: [4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4],
			Data.Enemy.ROOTKIT: [5, 5, 5],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [8, 8, 8],
			Data.Enemy.RANSOMWARE: [12, 11, 11]
		}
	},
	42: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [3, 2, 2],
			Data.Enemy.ADWARE: [3, 3, 2],
			Data.Enemy.WORM: [3, 3, 2],
			Data.Enemy.SPYWARE: [3, 3, 2],
			Data.Enemy.BOTNET: [3, 3, 2],
			Data.Enemy.CREDS: [3, 3, 3],
			Data.Enemy.TROJAN: [4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4],
			Data.Enemy.ROOTKIT: [5, 5, 5],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [8, 8, 8],
			Data.Enemy.RANSOMWARE: [13, 13, 12]
		}
	},
	43: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [5, 4, 4],
			Data.Enemy.DDOS: [6, 6, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [12, 12, 12]
		}
	},
	44: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [5, 4, 4],
			Data.Enemy.DDOS: [6, 6, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [14, 13, 13]
		}
	},
	45: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [14, 13, 13]
		}
	},
	46: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [15, 15, 14]
		}
	},
	47: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [4, 3, 3],
			Data.Enemy.TROJAN: [4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [15, 15, 14]
		}
	},
	48: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [4, 3, 3],
			Data.Enemy.TROJAN: [4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [16, 16, 16]
		}
	},
	49: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [4, 3, 3],
			Data.Enemy.TROJAN: [4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [6, 6, 6],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [17, 16, 16]
		}
	},
	50: {
		"enemies": {
			Data.Enemy.BOSS5: [1],
			Data.Enemy.BOTNET: [9, 8, 8],
			Data.Enemy.DDOS: [9, 8, 8],
			Data.Enemy.DEFAULT: [14, 13, 13],
			Data.Enemy.WORM: [9, 8, 8],
			Data.Enemy.INSIDERTHREAT: [9, 8, 8],
			Data.Enemy.VIRUS: [3, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2],
			Data.Enemy.ROOTKIT: [3, 2, 2],
			Data.Enemy.SQL: [3, 2, 2],
			Data.Enemy.RANSOMWARE: [3, 2, 2],
			Data.Enemy.ZERO: [3, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2],
			Data.Enemy.TROJAN: [3, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2]
		}
	},
	# --- MAP 6 (3 paths) ---
	51: {
		"enemies": {
			Data.Enemy.BOSS5: [1],
			Data.Enemy.DEFAULT: [4, 3, 3],
			Data.Enemy.VIRUS: [4, 3, 3],
			Data.Enemy.ADWARE: [4, 3, 3],
			Data.Enemy.WORM: [4, 3, 3],
			Data.Enemy.SPYWARE: [4, 3, 3],
			Data.Enemy.BOTNET: [4, 3, 3],
			Data.Enemy.CREDS: [4, 3, 3],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 3, 3],
			Data.Enemy.ROOTKIT: [4, 3, 3],
			Data.Enemy.SQL: [4, 3, 3],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [7, 7, 6],
			Data.Enemy.ZERO: [4, 3, 3]
		}
	}
}

func _ready() -> void:
	add_to_group("WaveManager")
	
func setup(root: Node2D, map_manager: Node) -> void:
	level_root = root
	level_manager = map_manager


func update_wave_state() -> void:
	var ui = get_tree().get_first_node_in_group("UI")

	var enemies = get_tree().get_nodes_in_group("Enemies")
	if wave_active and not spawning_wave and enemies.size() == 0:
		wave_active = false
		if Data.current_wave > 0 and Data.current_wave % 5 == 0 and Data.checkpoint_wave < Data.current_wave:
			Data.checkpoint_wave = Data.current_wave
		if not wave_active and Data.current_wave % 10 == 0:
			if !Data.is_sandbox:
				if ui:
					ui.disable_auto()
				level_completed.emit()
				next_map.emit()
				
	
	if not wave_active and not spawning_wave and enemies.size() == 0:
		if Data.current_wave == 2 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_defeat_spam: # to trigger spam dialogue
			GameDialogueManager.show_dialogue_spam_defeat()
		if ui and ui.is_auto_enabled():
			start_wave()

		if Data.current_wave == 3 and wave_active == false and !Data.is_sandbox and !GameDialogueManager.is_wave2_defeated: # to trigger wave 2 defeat dialogue
			GameDialogueManager.play_scene("2nd_scene")

				
	if not wave_active and not spawning_wave and enemies.size() == 0 and Data.wave_started:
		Data.wave_started = false
		Data.current_wave += 1
		ui.update_wave_label()

func start_wave() -> void:
	if wave_active or spawning_wave:
		return
	Data.wave_started = true
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.update_wave_label()

	
	match Data.current_wave:
		6:
			$'../WeatherEffects/DustParticles'.visible = false
			$'../WeatherEffects/WindParticles'.visible = false
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = true
		11:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = false
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = false
		21:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = false
			$'../WeatherEffects/BloomParticles'.visible = false
		31:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = false
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false

		41:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = true
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false
		51:
			$'../WeatherEffects/DustParticles'.visible = true
			$'../WeatherEffects/WindParticles'.visible = true
			$'../WeatherEffects/RainParticles'.visible = true
			$'../WeatherEffects/LightningEffects'.visible = true
			$'../WeatherEffects/BloomParticles'.visible = false


	wave_active = true
	spawning_wave = true

	# predefined
	var wave_data = WAVE_DATA.get(Data.current_wave, null)
	
	if wave_data != null:
		# Predefined wave: spawn exact counts per path
		await _spawn_predefined_wave(wave_data)
	else:
		# Fallback: random generation for undefined waves
		var data = _random_wave_size()
		for enemy_enum in data:
			for i in range(data[enemy_enum]):
				_spawn_enemy(enemy_enum)
				await get_tree().create_timer(0.5).timeout

	spawning_wave = false


# predefined wave spanwing

func _spawn_predefined_wave(wave_data: Dictionary) -> void:
	var paths: Array[Path2D] = _get_paths()
	
	var enemies_data: Dictionary = wave_data["enemies"]
	
	for enemy_enum in enemies_data.keys():
		var per_path_counts: Array = enemies_data[enemy_enum]
		
		for path_index in range(per_path_counts.size()):
			var count: int = per_path_counts[path_index]
			
			if path_index >= paths.size():
				push_warning("Wave %d: path index %d out of bounds (only %d paths)" % [Data.current_wave, path_index, paths.size()])
				continue
			
			var path: Path2D = paths[path_index]
			
			for i in range(count):
				_spawn_enemy_on_path(enemy_enum, path)
				await get_tree().create_timer(0.5).timeout


func _spawn_enemy_on_path(enemy_enum: Data.Enemy, path: Path2D) -> void:
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()
	enemy.setup(path_follow, enemy_enum)
	path_follow.add_child(enemy)
	path.add_child(path_follow)


func spawn_sandbox_enemy(enemy_enum: Data.Enemy) -> void:
	wave_active = true
	_spawn_enemy(enemy_enum)


func _spawn_enemy(enemy_enum: Data.Enemy) -> void:
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	enemy.setup(path_follow, enemy_enum)
	path_follow.add_child(enemy)
	var path: Path2D = _choose_path_for_spawn()
	if path:
		path.add_child(path_follow)


func _random_wave_size() -> Dictionary:
	var difficulty = Data.current_wave
	var total_enemies = randi_range(5 + difficulty * 2, 8 + difficulty * 3)
	var wave: Dictionary = {}

	for i in range(total_enemies):
		var enemy_type = _choose_random_enemy_type(difficulty)
		wave[enemy_type] = wave.get(enemy_type, 0) + 1

	return wave


func _choose_random_enemy_type(difficulty: int) -> Data.Enemy:
	var default_chance = clamp(70 - difficulty * 4, 15, 70)
	var fast_chance = clamp(70 - difficulty * 4, 15, 70)
	var big_chance = clamp(60 + difficulty * 3, 15, 60)
	var strong_chance = clamp(50 + difficulty * 2, 10, 50)
	var extreme_chance = clamp(40 + difficulty * 2, 10, 40)
	var worm_chance = clamp(40 + difficulty * 2, 10, 40)
	var insider_chance = clamp(40 + difficulty * 2, 10, 40)

	var roll = randi() % 100
	if roll < default_chance:
		return Data.Enemy.DEFAULT
	elif roll < default_chance + big_chance:
		return Data.Enemy.ADWARE
	elif roll < default_chance + fast_chance + strong_chance:
		return Data.Enemy.SPYWARE
	elif roll < default_chance + fast_chance + strong_chance + worm_chance:
		return Data.Enemy.CREDS
	elif roll < default_chance + fast_chance + strong_chance + extreme_chance + worm_chance:
		return Data.Enemy.BOTNET
	return Data.Enemy.WORM


func _get_paths() -> Array[Path2D]:
	var paths: Array[Path2D] = []
	
	for child in level_root.get_children():
		if child is Path2D:
			paths.append(child)
	return paths

func _choose_path_for_spawn() -> Path2D:
	var paths: Array = _get_paths()
	return paths[randi() % paths.size()]

func spawn_worm_clone(path: Path2D, progress: float):
	var path_follow = PathFollow2D.new()
	path_follow.progress = progress

	var enemy = enemy_scene.instantiate()
	enemy.setup(path_follow, Data.Enemy.WORM)
	enemy.can_clone = false

	path_follow.add_child(enemy)
	path.add_child(path_follow)
	enemy.can_clone = false

func spawn_ddos_clones(path: Path2D, progress: float):
	var offsets = [-40, 0, 40]

	for offset in offsets:
		var path_follow = PathFollow2D.new()
		path_follow.progress = max(progress + offset, 0)

		var enemy = enemy_scene.instantiate()
		enemy.setup(path_follow, Data.Enemy.DDOS)

		enemy.scale = Vector2(0.75, 0.75) # clone is 25% smaller
		enemy.is_ddos_clone = true

		var hp = int(Data.ENEMY_DATA[Data.Enemy.DDOS]["health"] * 0.35)
		enemy.health = hp
		enemy.get_node("hpbar").max_value = hp
		enemy.get_node("hpbar").value = hp

		path_follow.add_child(enemy)
		path.add_child(path_follow)

func spawn_enemy_on_path(enemy_enum: Data.Enemy, path: Path2D):
	var path_follow = PathFollow2D.new()
	var enemy = enemy_scene.instantiate()

	enemy.setup(path_follow, enemy_enum)

	path_follow.add_child(enemy)
	path.add_child(path_follow)

func spawn_boss_viruses():
	var paths: Array[Path2D] = []

	if level_root:
		for child in level_root.get_children():
			if child is Path2D:
				paths.append(child)
	else:
		for child in get_tree().current_scene.get_children():
			if child is Path2D:
				paths.append(child)

	for path in paths:
		spawn_enemy_on_path(Data.Enemy.VIRUS, path)

func spawn_boss_botnets():
	var paths: Array[Path2D] = []

	if level_root:
		for child in level_root.get_children():
			if child is Path2D:
				paths.append(child)
	else:
		for child in get_tree().current_scene.get_children():
			if child is Path2D:
				paths.append(child)

	for path in paths:
		spawn_enemy_on_path(Data.Enemy.BOTNET, path)