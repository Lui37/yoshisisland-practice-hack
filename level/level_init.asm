level_init:
	PHP
	REP #$30
	PHB
	PHK
	PLB
	
	JSR level_room_init_common
	
	SEP #$30
	STZ !level_frames
	STZ !level_seconds
	STZ !level_minutes
	STZ !total_frames
    STZ !lag_counter
	STZ !room_frames
	STZ !room_seconds
	STZ !room_minutes
	
	PLB
	PLP
	RTL

room_init:	
	PHP
	REP #$30
	PHB
	PHK
	PLB
	
	JSR level_room_init_common

    STZ !lag_counter
	STZ !room_frames
	STZ !room_seconds
	STZ !room_minutes
	
	PLB
	PLP
	RTL

macro init_hdma(channel, control, target_reg, table_bank, table_hi, table_lo)
	LDA <control> : STA $43<channel>0
	LDA <target_reg> : STA $43<channel>1
	LDA.b <table_lo> : STA $43<channel>2
	LDA.b <table_hi> : STA $43<channel>3
	LDA.b <table_bank> : STA $43<channel>4
endmacro

level_room_init_common:
    JSR load_font

	REP #$10
	SEP #$20
    LDA !hud_enabled
    BNE .draw_hud
    RTS

.draw_hud
	LDA #$01 : STA !hud_displayed

	; hdma to override any other hdmas in a given level which mess with BG3 offsets, in the hud region only
	; e.g. 1-4 falling walls use channel 4 to set bg3vofs
    ; TODO make this a loop as in $0DD4D0 to make it easier to switch channels around
	%init_hdma(!hud_hdma_channel_h, #%00000010, #$11, #$7E, #hud_hdma_table_h>>8, #hud_hdma_table_h)
	%init_hdma(!hud_hdma_channel_v, #%00000010, #$12, #$7E, #hud_hdma_table_v>>8, #hud_hdma_table_v)
	LDA #!hud_hdma_channels : TSB !r_reg_hdmaen_mirror ; hdmaen gets started at the top of the screen

	REP #$20
	
	; init hud buffer, 192 ($C0) bytes = 3 lines * 64 bytes per line... $1E00-$1EC0
	LDX #$00BE
-
	LDA hud_tilemap,x
	STA !hud_buffer,x
	DEX
	DEX
	BPL -
	
	; DMA tilemap data to VRAM $6400 ($C800) - TODO confirm this isnt necessary
	; LDA #hud_tilemap>>8
	; STA $00
	; LDX #hud_tilemap
	; LDY #$6400
	; LDA #$0100
	; JSL vram_dma_01
	RTS

; 3 lines, 32 columns
hud_tilemap:
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$37,$30,$3F,$30 ; 00-0F
	db $3F,$30,$3F,$30,$36,$30,$3F,$30,$3F,$30,$3F,$30,$34,$30,$3F,$30 ; 10-1F
	db $2B,$30,$3F,$30,$3F,$30,$2B,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 20-2F
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 30-3F
	
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3E,$30,$3F,$30 ; 40-4F
	db $3F,$30,$3F,$30,$38,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 50-5F
	db $2B,$30,$3F,$30,$3F,$30,$2B,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 60-6F
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 70-7F
	
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 80-8F
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; 90-9F
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; A0-AF
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30 ; B0-BF

	; extra (not in the buffer)
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30
	db $3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30,$3F,$30
