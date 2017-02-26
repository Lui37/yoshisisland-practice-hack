lorom

;=================================

org $00815F
    autoclean JML game_loop_hijack

freecode $FF

game_loop_hijack:
; 8-bit mode
; Hijacked right before jumping into game mode
; Current gamemode index is in X, rest of registers are free

; Check if state has been loaded
; Initial value is $02 and does before load preparations
handle_loadstate:
    LDA !loaded_state
    BEQ .next

    DEC A
    STA !loaded_state
    BEQ .after_load

.before_load
; This part will be run just before entering gamemode 0C
    JMP load_state_before_load

.after_load
; First frame after load complete
    JMP load_state_after_load
.next


handle_music_toggle:
    LDA !disable_music
    BEQ .next
; send music off command each frame (ugly)
    LDA #$F0
    STA $4D
.next


handle_debug_menu:
    LDA !debug_menu
    BEQ .next
; jump to debug menu processing code
    JMP main_debug_menu
.next


controller_checks:
.load_button
    LDA !controller_data1_press
; X-button
    AND #$40
    BEQ .save_button
    JMP prepare_load

.save_button
    LDA !controller_data2_press
; select
    AND #$20
    BEQ .debug_menu_button
    JMP save_state

.debug_menu_button
    LDA !controller_2_data2_press
; controller 2 data 2 on press
; start
    AND #$10
    BEQ .disable_music
    JMP init_debug_menu

.disable_music
; controller 2 data 2 on press
; select
    LDA !controller_2_data2_press
    AND #$20
    BEQ .disable_autoscroll
; toggle music
    JSR toggle_music

.disable_autoscroll
; controller 2 data 2 on press
; Y-button
    LDA !controller_2_data2_press
    AND #$40
    BEQ game_mode_return
; clear out autoscroll flags
    STZ $0C1C
    STZ $0C1E
    STZ $0C20



game_mode_return:
; Setting up gamemode pointer to stack as per original routine
    LDA $00816B,x
    PHA
    LDA $00816A,x
    PHA
    RTL
