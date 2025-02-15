; Edit level load (with text) timer
; Now starts as soon as there is input
if !enable_level_intro_skip
org level_intro_wait
wait:
    LDA $0035
    ORA $0940
    BEQ wait
endif

; Skip icon rotating on world map
org map_icon_rotation
    LDA #$0000

; speed up world map transition
org world_map_prev_fold_away
    NOP #19

org world_map_new_fold_in
    NOP #14
