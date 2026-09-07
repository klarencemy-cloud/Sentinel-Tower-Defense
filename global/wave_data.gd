extends Node


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
	# MAP 2
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
			Data.Enemy.WORM: [12, 13]
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
			Data.Enemy.WORM: [17, 18]
		}
	},
	15: {
		"enemies": {
			Data.Enemy.DEFAULT: [6, 6],
			Data.Enemy.VIRUS: [6, 6],
			Data.Enemy.ADWARE: [8, 7],
			Data.Enemy.WORM: [19, 20]
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
			Data.Enemy.BOSS2: [1, 0],
			Data.Enemy.BOTNET: [21, 21],
			Data.Enemy.DEFAULT: [6, 5],
			Data.Enemy.VIRUS: [6, 5],
			Data.Enemy.ADWARE: [6, 6],
			Data.Enemy.WORM: [8, 7],
			Data.Enemy.SPYWARE: [8, 7]
		}
	},
	# MAP 3
	21: {
		"enemies": {
			Data.Enemy.DEFAULT: [5, 5],
			Data.Enemy.VIRUS: [5, 5],
			Data.Enemy.ADWARE: [5, 6],
			Data.Enemy.WORM: [7, 8],
			Data.Enemy.SPYWARE: [9, 9],
			Data.Enemy.BOTNET: [18, 18]
		}
	},
	22: {
		"enemies": {
			Data.Enemy.DEFAULT: [5, 4],
			Data.Enemy.VIRUS: [5, 5],
			Data.Enemy.ADWARE: [6, 5],
			Data.Enemy.WORM: [6, 7],
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
			Data.Enemy.BOSS3: [0, 1],
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
	# MAP 4
	31: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 2], # path 1 to 4
			Data.Enemy.VIRUS: [2, 2, 2, 2],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 3, 2],
			Data.Enemy.BOTNET: [3, 3, 3, 3],
			Data.Enemy.CREDS: [3, 3, 3, 3],
			Data.Enemy.TROJAN: [5, 4, 5, 4],
			Data.Enemy.INSIDERTHREAT: [12, 11, 12, 11]
		}
	},
	32: {
		"enemies": {
			Data.Enemy.DEFAULT: [3, 2, 2, 0],
			Data.Enemy.VIRUS: [0, 2, 2, 3],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2, 3],
			Data.Enemy.BOTNET: [2, 3, 3, 3],
			Data.Enemy.CREDS: [3, 3, 3, 2],
			Data.Enemy.TROJAN: [5, 4, 4, 5],
			Data.Enemy.INSIDERTHREAT: [5, 5, 5, 5],
			Data.Enemy.ROOTKIT: [9, 9, 8, 8]
		}
	},
	33: {
		"enemies": {
			Data.Enemy.DEFAULT: [3, 2, 2, 0],
			Data.Enemy.VIRUS: [2, 2, 0, 3],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 3, 3, 3],
			Data.Enemy.CREDS: [3, 3, 2, 3],
			Data.Enemy.TROJAN: [4, 4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [4, 5, 4, 4],
			Data.Enemy.ROOTKIT: [11, 10, 11, 11]
		}
	},
	34: {
		"enemies": {
			Data.Enemy.DEFAULT: [3, 0, 2, 2],
			Data.Enemy.VIRUS: [2, 3, 2, 0],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [3, 2, 2, 2],
			Data.Enemy.BOTNET: [3, 3, 2, 2],
			Data.Enemy.CREDS: [3, 2, 3, 2],
			Data.Enemy.TROJAN: [4, 4, 4, 3],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4, 4],
			Data.Enemy.ROOTKIT: [5, 5, 5, 5],
			Data.Enemy.SQL: [8, 8, 8, 8]
		}
	},
	35: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 0],
			Data.Enemy.VIRUS: [2, 2, 0, 3],
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
			Data.Enemy.DEFAULT: [2, 2, 0, 2],
			Data.Enemy.VIRUS: [3, 0, 2, 2],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [3, 2, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [4, 4, 4, 3],
			Data.Enemy.ROOTKIT: [4, 3, 4, 4],
			Data.Enemy.SQL: [5, 5, 4, 4],
			Data.Enemy.DDOS: [9, 9, 9, 8]
		}
	},
	37: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 0, 2],
			Data.Enemy.VIRUS: [3, 2, 2, 0],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 3, 3, 3],
			Data.Enemy.ROOTKIT: [4, 4, 4, 3],
			Data.Enemy.SQL: [4, 4, 3, 4],
			Data.Enemy.DDOS: [12, 12, 11, 11]
		}
	},
	38: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 0, 2, 2],
			Data.Enemy.VIRUS: [3, 2, 2, 0],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 3, 3, 3],
			Data.Enemy.ROOTKIT: [4, 4, 3, 4],
			Data.Enemy.SQL: [4, 3, 4, 4],
			Data.Enemy.DDOS: [5, 5, 5, 5],
			Data.Enemy.RANSOMWARE: [8, 8, 8, 8]
		}
	},
	39: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2, 0],
			Data.Enemy.VIRUS: [3, 0, 2, 2],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [3, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 3, 2, 2],
			Data.Enemy.INSIDERTHREAT: [3, 2, 3, 2],
			Data.Enemy.ROOTKIT: [4, 4, 3, 4],
			Data.Enemy.SQL: [4, 4, 4, 3],
			Data.Enemy.DDOS: [7, 7, 7, 7],
			Data.Enemy.RANSOMWARE: [7, 7, 7, 7]
		}
	},
	40: {
		"enemies": {
			Data.Enemy.BOSS4: [1, 0, 0, 0],
			Data.Enemy.DEFAULT: [0, 2, 2, 2],
			Data.Enemy.VIRUS: [2, 3, 2, 0],
			Data.Enemy.ADWARE: [2, 2, 2, 2],
			Data.Enemy.WORM: [2, 2, 2, 2],
			Data.Enemy.SPYWARE: [2, 2, 2, 2],
			Data.Enemy.BOTNET: [2, 2, 2, 2],
			Data.Enemy.CREDS: [2, 2, 2, 2],
			Data.Enemy.TROJAN: [3, 2, 3, 2],
			Data.Enemy.INSIDERTHREAT: [2, 3, 2, 3],
			Data.Enemy.ROOTKIT: [3, 2, 3, 2],
			Data.Enemy.SQL: [2, 3, 2, 3],
			Data.Enemy.DDOS: [4, 4, 4, 3],
			Data.Enemy.RANSOMWARE: [4, 4, 3, 4]
		}
	},
	# MAP 5 
	41: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [3, 2, 2],
			Data.Enemy.ADWARE: [3, 3, 2],
			Data.Enemy.WORM: [3, 2, 3],
			Data.Enemy.SPYWARE: [3, 3, 2],
			Data.Enemy.BOTNET: [2, 3, 3],
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
			Data.Enemy.WORM: [3, 2, 3],
			Data.Enemy.SPYWARE: [3, 3, 2],
			Data.Enemy.BOTNET: [2, 3, 3],
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
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [4, 5, 4],
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
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [4, 5, 4],
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
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [4, 4, 5],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [6, 7, 7],
			Data.Enemy.ZERO: [14, 13, 13]
		}
	},
	46: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [4, 4, 5],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [6, 7, 7],
			Data.Enemy.ZERO: [16, 14, 14]
		}
	},
	47: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [4, 4, 5],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [6, 7, 7],
			Data.Enemy.ZERO: [17, 16, 15]
		}
	},
	48: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [3, 3, 2],
			Data.Enemy.TROJAN: [4, 3, 3],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [4, 4, 5],
			Data.Enemy.SQL: [5, 5, 5],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [6, 7, 7],
			Data.Enemy.ZERO: [19, 17, 16]
		}
	},
	49: {
		"enemies": {
			Data.Enemy.DEFAULT: [2, 2, 2],
			Data.Enemy.VIRUS: [2, 2, 2],
			Data.Enemy.ADWARE: [3, 2, 2],
			Data.Enemy.WORM: [2, 3, 2],
			Data.Enemy.SPYWARE: [2, 2, 3],
			Data.Enemy.BOTNET: [3, 2, 2],
			Data.Enemy.CREDS: [4, 3, 3],
			Data.Enemy.TROJAN: [4, 4, 4],
			Data.Enemy.INSIDERTHREAT: [3, 4, 3],
			Data.Enemy.ROOTKIT: [5, 4, 4],
			Data.Enemy.SQL: [6, 6, 6],
			Data.Enemy.DDOS: [7, 7, 6],
			Data.Enemy.RANSOMWARE: [6, 7, 7],
			Data.Enemy.ZERO: [17, 16, 16]
		}
	},
	50: {
		"enemies": {
			Data.Enemy.BOSS5: [1, 0, 0],
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
	# MAP 6
	51: {
		"enemies": {
			Data.Enemy.BOSS6: [1, 0, 0]
		}
	}
}
