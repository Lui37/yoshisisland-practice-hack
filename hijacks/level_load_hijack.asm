; hijack at level load after it sets camera
; checks if we're loading a savestate and override camera if we are

org level_load_camera
    autoclean JSL fix_camera
    NOP

org level_init_hijack
    JSR level_init_hook
	
org room_init_hijack
    JSR room_init_hook

org level_main_hijack
    JSR level_main_hook

; freespace in bank 01 - starts here in J, in the middle of a large block in U
org $01FED2

level_init_hook:
    INC !gamemode
    autoclean JSL level_init
    RTS
		
room_init_hook:
    INC !gamemode
    autoclean JSL room_init
    RTS
		
level_main_hook:
    STA $0B83
    autoclean JSL level_tick
    RTS
