# CS 1.6 - Custom Weapons Shop
A plugin that allows you to create your own Weapon Shop.

The plugin is fully customizable! You can change weapon names, adjust ammo for each weapon separately, and create your own weapon sets.

# Installation
- Just download the plugin and upload the .amxx file to your plugins folder on your server (or you can of course compile the .sma file and then upload the compilated .amxx file to your server).
- Then write the plugin name (with .amxx) to `/cstrike/addons/amxmodx/configs/plugins.ini`.
- If you want to use sounds (see format below), you must create a new folder in the `sound/` folder with the exact name `customweapons` and then upload your sounds to it.

# Requirements
- AMX Mod X 1.10

# Commands
| Command | Chat or Console? | Description |
| - | - | - |
| /cws | Chat | Opens the main menu. |
| /customweapons | Chat | Opens the main menu. |
| cws_menu | Console | Opens the main menu. |

# Format
`"<weapon1>" "<weapon2>" "<weapon3>" "<sound>" "<team>" "<admin_flag>" "<vip_text>" "<money>"`
- Make sure you have entered the exact name of the sound file in `sound`. Example: ... \<woohoo\> <- the file name must be `woohoo.wav`.

# Default Config Files:
- When first launched, the plugin creates three files in the `../data` folder: weaponnames.cfg, custom_weapons_ammo.cfg, and custom_weapons.cfg.

## weaponnames.cfg
```
; You can customize the names of weapons to suit your preferences.
weapon_p228 = P228
weapon_shield = Shield
weapon_scout = Scout
weapon_hegrenade = HE
weapon_xm1014 = XM1014
weapon_c4 = C4
weapon_mac10 = MAC10
weapon_aug = Aug
weapon_smokegrenade = SMOKE
weapon_elite = Dual Beretta
weapon_fiveseven = Five Seven
weapon_ump45 = UMP45
weapon_sg550 = SG-550
weapon_galil = Galil
weapon_famas = Famas
weapon_usp = USP
weapon_glock18 = Glock18
weapon_awp = AWP
weapon_mp5navy = MP5
weapon_m249 = M249
weapon_m3 = M3
weapon_m4a1 = M4A1
weapon_tmp = TMP
weapon_g3sg1 = G3/SG-1
weapon_flashbang = Flashbang
weapon_deagle = Desert Eagle
weapon_sg552 = Sig 552
weapon_ak47 = AK-47
weapon_p90 = P-90
```

## custom_weapons_ammo.cfg
```
; You can customize the backpack ammo for given weapons.
weapon_p228 = 250
weapon_shield = 250
weapon_scout = 250
weapon_hegrenade = 5
weapon_xm1014 = 250
weapon_mac10 = 250
weapon_aug = 250
weapon_smokegrenade = 250
weapon_elite = 250
weapon_fiveseven = 250
weapon_ump45 = 250
weapon_sg550 = 250
weapon_galil = 250
weapon_famas = 250
weapon_usp = 250
weapon_glock18 = 250
weapon_awp = 250
weapon_mp5navy = 250
weapon_m249 = 250
weapon_m3 = 250
weapon_m4a1 = 250
weapon_tmp = 250
weapon_g3sg1 = 250
weapon_flashbang = 5
weapon_deagle = 250
weapon_sg552 = 250
weapon_ak47 = 250
weapon_p90 = 250
```
- Ammo for C4 is not on the list because it would not make sense. There is always only one C4.

## custom_weapons.cfg
```
; Custom Weapons Config File
; Example:
;
; "<weapon1>" "<weapon2>" "<weapon3>" "<sound>" "<team>" "<admin_flag>" "<vip_text>" "<money>"
;
; The value "none" can be used for: "weapon2", "weapon3", "sound", "admin_flag", "vip_text", "money"
; Teams available: "t", "ct", "both"
"weapon_m4a1" "weapon_deagle" "weapon_hegrenade" "none" "both" "none" "none" "5400"
"weapon_awp" "weapon_deagle" "none" "none" "t" "t" "VIP" "none"
```

# Showcases
To be added later...

# Support
If you having any issues please feel free to write your issue to the issue section :) .