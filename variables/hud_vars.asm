; Custom HUD vars
!vars_ram = $1800 ; TODO idk if this is a suitable value or not

!frames_passed = !vars_ram
!lag_counter = !vars_ram+1

!total_frames = !vars_ram+3

!level_frames = !vars_ram+5
!level_seconds = !vars_ram+6
!level_minutes = !vars_ram+7
!room_frames = !vars_ram+8
!room_seconds = !vars_ram+9
!room_minutes = !vars_ram+10
!timer_enabled = !vars_ram+11
!hud_enabled = !vars_ram+12
!hud_displayed = !vars_ram+13 ; the hud is not always shown even when it is enabled
!hud_displayed_backup = !vars_ram+14
!active_sprites = !vars_ram+15
!bg3_cam_x_backup = !vars_ram+16
!bg3_cam_y_backup = !vars_ram+18

!hud_buffer = $1E00

; Custom HUD consts
!irq_v = $20 ; scanline for custom irq 2 (bottom of the hud) TODO make this smaller?
!nmi_v = $D8 ; scanline for NMI TODO is this low enough? often get black lines at top of screen
!hud_hofs = #$0000 ; 0
!hud_vofs = #$FFF7 ; 1015 (effectively -9)
!hud_hdma_channel_h = 6
!hud_hdma_channel_v = 7
!hud_hdma_channels = %11000000 ; TODO figure out best channels to use, might need to adjust per-level e.g. big bowser uses 1100 0110, baby bowser uses 0010 0000
!hud_hdma_channels_DD = %00011000 ; bowser room
