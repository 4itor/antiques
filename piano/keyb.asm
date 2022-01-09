comment+
                   ┌┐    .     ┐             ┐
    ···─────────── │┌┬┐  ┐┌┐ ┌┐├ ┬┐┐┐┌┬┐┌┐┌┐ ├ ┌┐ ──────────────···
        HeuristiX  ├│││  ││└┐└┐│ │ ││││││┘│└┐│ └┐  DeMo SeCTioN
    ···─────────── │└ └  ┘└ ┘└┘└┘┘ └┴└ └└┘┘ ┘└┘└┘ ──────────────···
                   ┘
       » With your feet in the air and your head on the ground...
                                                                  (pixies)

       +

        ideal
        model   tiny

;-----------------------------------------------------------------------------
; Equates and constants
;-----------------------------------------------------------------------------

MAK     equ     (100000b*256)   ; Keypress (bit 5 de ah)

SILENCE equ     0FFFFh          ; No output!

OC0     equ     (00000b*256)    ; Octavas (bits 2,3,4 de AH)
OC1     equ     (00100b*256)
OC2     equ     (01000b*256)
OC3     equ     (01100b*256)
OC4     equ     (10000b*256)
OC5     equ     (10100b*256)
OC6     equ     (11000b*256)
OC7     equ     (11100b*256)

_Cs     equ     16Bh            ; Notas! (bits 0,1 de AH y todo AL)
_D      equ     181h            ; s = #
_Ds     equ     198h
_E      equ     1B0h
_F      equ     1CAh
_Fs     equ     1E5h
_G      equ     202h
_Gs     equ     220h
_A      equ     241h
_As     equ     263h
_B      equ     287h
_C      equ     2AEh

;-----------------------------------------------------------------------------
; Main Segment
;-----------------------------------------------------------------------------

        codeseg
        org     100h
        assume  ds:@code, cs:@code, es:@code

inicio:
        jmp     start

label   n_table word
        dw      SILENCE         ; None!!   (0)
        dw      SILENCE         ; Esc      (1)
        dw      SILENCE         ; 1        (2)
        dw      MAK+OC3+_Cs     ; 2        (3)
        dw      MAK+OC3+_Ds     ; 3        (4)
        dw      SILENCE         ; 4        (5)
        dw      MAK+OC3+_Fs     ; 5        (6)
        dw      MAK+OC3+_Gs     ; 6        (7)
        dw      MAK+OC3+_As     ; 7        (8)
        dw      SILENCE         ; 8        (9)
        dw      MAK+OC4+_Cs     ; 9        (10)
        dw      MAK+OC4+_Ds     ; 0        (11)
        dw      SILENCE         ;          (12)
        dw      SILENCE         ;          (13)
        dw      SILENCE         ;          (14)
        dw      SILENCE         ;          (15)
        dw      MAK+OC2+_C      ; Q        (16)
        dw      MAK+OC3+_D      ; W        (17)
        dw      MAK+OC3+_E      ; E        (18)
        dw      MAK+OC3+_F      ; R        (19)
        dw      MAK+OC3+_G      ; T        (20)
        dw      MAK+OC3+_A      ; Y        (21)
        dw      MAK+OC3+_B      ; U        (22)
        dw      MAK+OC3+_C      ; I        (23)
        dw      MAK+OC4+_D      ; O        (24)
        dw      MAK+OC4+_E      ; P        (25)
        dw      SILENCE         ;          (26)
        dw      SILENCE         ;          (27)
        dw      SILENCE         ;          (28)
        dw      SILENCE         ;          (29)
        dw      SILENCE         ; A        (30)
        dw      MAK+OC2+_Cs     ; S        (31)
        dw      MAK+OC2+_Ds     ; D        (32)
        dw      SILENCE         ; F        (33)
        dw      MAK+OC2+_Fs     ; G        (34)
        dw      MAK+OC2+_Gs     ; H        (35)
        dw      MAK+OC2+_As     ; J        (36)
        dw      SILENCE         ;          (37)
        dw      SILENCE         ;          (38)
        dw      SILENCE         ;          (39)
        dw      SILENCE         ;          (40)
        dw      SILENCE         ;          (41)
        dw      SILENCE         ;          (42)
        dw      SILENCE         ;          (43)
        dw      MAK+OC1+_C      ; Z        (44)
        dw      MAK+OC2+_D      ; X        (45)
        dw      MAK+OC2+_E      ; C        (46)
        dw      MAK+OC2+_F      ; V        (47)
        dw      MAK+OC2+_G      ; B        (48)
        dw      MAK+OC2+_A      ; N        (49)
        dw      MAK+OC2+_B      ; M        (50)

label   message byte
        db      0Dh,0Ah
        db      "                             ┌┐        .",0Dh,0Ah
        db      "              ···───────────·│┌┬┐·──·┌┐┐┌┐┌┐·┌┐·──────────────···",0Dh,0Ah
        db      "                  HeuristiX  ├│││ 1k │││┌┤│└┐││  DeMo SeCTioN",0Dh,0Ah
        db      "              ···───────────·│└ ┘·──·├┘┴└┴└ ┘└┘·──────────────···",0Dh,0Ah
        db      "                s d   g h j  ┘ keys: └  2 3   5 6 7   9 0   (esc)",0Dh,0Ah
        db      "               z x c v b n m           q w e r t y u i o p",0Dh,0Ah,'$'

channel db      0,1,2,8,9,10,16,17,18  ; Where to put channel[n] carrier_data
                                       ; Modulator_data is channel[n]'s one +3!

label   fm_instrument byte                                  ; <Registers>
        db      0C2h    ; AM/VIB/EG/KSR/Multi Carrier ···────┬─ 20..35
        db      0E2h    ; AM/VIB/EG/KSR/Multi Modulator ···──┘
        db      006h    ; KSL/Volume Carrier ···────┬────────── 40..55
        db      004h    ; KSL/Volume Modulator ···──┘
        db      0C3h    ; Attack/Decay Carrier ···────┬──────── 60..75
        db      0F3h    ; Attack/Decay Modulator ···──┘
        db      0F5h    ; Sustain/Release Carrier ···────┬───── 80..95
        db      0F5h    ; Sustain/Release Modulator ···──┘
        db      009h    ; Feedback/FM ···────────────────────── C0..C8
        db      000h    ; Waveform Carrier ···────┬──────────── E0..F5
        db      002h    ; Waveform Modulator ···──┘

;        db      0e0h    ; AM/VIB/EG/KSR/Multi Carrier ···────┬─ 20..35
;        db      0cfh    ; AM/VIB/EG/KSR/Multi Modulator ···──┘
;        db      0c0h    ; KSL/Volume Carrier ···────┬────────── 40..55
;        db      000h    ; KSL/Volume Modulator ···──┘
;        db      0f7h    ; Attack/Decay Carrier ···────┬──────── 60..75
;        db      0f0h    ; Attack/Decay Modulator ···──┘
;        db      0f4h    ; Sustain/Release Carrier ···────┬───── 80..95
;        db      084h    ; Sustain/Release Modulator ···──┘
;        db      00eh    ; Feedback/FM ···────────────────────── C0..C8
;        db      000h    ; Waveform Carrier ···────┬──────────── E0..F5
;        db      000h    ; Waveform Modulator ···──┘

num_ch  equ     9
cur_ch  dw      0

;-----------------------------------------------------------------------------
;      ·C·O·D·E·
;-----------------------------------------------------------------------------

;■■■■■■■■■■■■■■■■ adlib register management ■■■■■■■■■■■■■■■■
;
; AH = aDLiB register to load, AL = data

ad_reg: push    ax
        push    cx

        xchg    al, ah
        mov     dx, 0388h
        out     dx, al          ; Select Register

        mov     cx, 6
  @@x1: in      al, dx
        loop    @@x1            ; Wait 4 card! (read port 6 times)

        inc     dx
        mov     al, ah
        out     dx, al          ; Ok. fill the register!

        mov     cl, 35
  @@x2: in      al, dx
        loop    @@x2            ; Lets read adlib port 35 times... <geez!>

        pop     cx
        pop     ax
        ret

;■■■■■■■■■■■■■■■■ load instrument ■■■■■■■■■■■■■■■■
;
; DS:SI points to instrument data and BX to the channel number (0..8)

ad_load_instrument:
        push    ax
        push    bx
        push    cx

        mov     bh, [channel+bx]
        mov     ah, 20h
        add     ah, bh
        mov     cx, 4;
@@first4par:
        lodsb                   ; fetch instrument data!
        call    ad_reg
        add     ah, 3
        lodsb
        call    ad_reg
        add     ah, 1Dh         ; Point to next register (+20h)
        loop    @@first4par

        mov     ah, 0C0h        ; Put Feedback/Connection Type Parameter
        add     ah, bl          ; ah <- register to put F/CT info!
        lodsb
        call    ad_reg

        mov     ah, 0E0h        ; Put Last Parameter!
        add     ah, bh          ; point to desired channel register
        lodsb
        call    ad_reg
        add     ah, 3
        lodsb
        call    ad_reg

        pop     cx
        pop     bx
        pop     ax
        ret

;■■■■■■■■■■■■■■■■ play note ■■■■■■■■■■■■■■■■
;
; BX = Canal, AX = (make|break + octava + nota)

ad_play:push    bx
        xchg    ah, bl
        add     ah, 0A0h
        call    ad_reg
        mov     al, bl
        add     ah, 010h
        pop     bx
        jmp     ad_reg

;■■■■■■■■■■■■■■■■ prepare instruments ■■■■■■■■■■■■■■■■
;

song_init:
        xor     bx, bx
 @@nxt: mov     si, offset fm_instrument
        call    ad_load_instrument
        xor     ax, ax
        call    ad_play
        inc     bx
        cmp     bx, num_ch
        jb      @@nxt
        ret

;■■■■■■■■■■■■■■■■ initialize adlib ■■■■■■■■■■■■■■■■

ad_init:
        mov     ax, 120h
        call    ad_reg
        mov     ax, 800h
        call    ad_reg
        mov     ah, 0bdh
        jmp     ad_reg
        xor     ax, ax
        mov     cx, 0FFh
 @@buc: call    ad_reg
        inc     ah
        loop    @@buc           ; Clear ALL adlib registers... :)

;████████████████ main routine ████████████████

start:  ;mov     ax, @DATA
        ;mov     ds, ax

        mov     ax, cs
        mov     ds, ax
        mov     es, ax

        mov     dx, offset message
        mov     ah, 9
        int     21h

        call    ad_init         ; Initialize ADLIB!
        call    song_init       ; Load instruments/patches

        cli
        in      al, 21h
        mov     [int_msk], al   ; old status of the INT ctrller saved!
        or      al, 11111111b
        out     21h, al         ; NO ints (¿hay diferencia con un CLI?)
        sti

main:   mov     al, 0ah         ; Any key pressed?
        out     20h, al
        in      al, 20h         ; AL <- IRR del 8259

        and     al, 00000010b   ; Se ha activado el IR del teclado?
        jz      main            ; no -> seguimos... ;)

        in      al, 60h         ; si hay una tecla, la leemos,
        mov     ah, al          ; la guardamos en AH,
        in      al, 61h         ; y hacemos el Strobe de teclado :
        or      al, 10000000b   ;  ┌ Activando el bit 7
        out     61h,al          ;  │ y sacándolo pol puerto 61h
        and     al, 01111111b   ;  │ apagamos el bit 7
        out     61h,al          ;  └ y lo escupimos de nuevo

        cmp     ah, 10000001b   ; si es un break de ESC -> salimos
        jne     @noend
        jmp     @end

@noend: test    ah, 10000000b   ; es un make o un break ?
        jnz     @brk            ; break -> apagamos el sonido que toca!

;■■■■■■■■■■■■■■■■ Make ■■■■■■■■■■■■■■■■
        cmp     ah, 50
        jg      main            ; if scancode is biggest than 50 ignore it!!
        xor     bx, bx
        mov     bl, ah          ; save the scancode on BL!
        cmp     [k_table+bx], 1
        je      main            ; if Key was already pressed is TYPEMATIC!
        mov     [k_table+bx], 1
        shl     bx, 1           ; multiply scancode by WORD size to find IDX!
        mov     ax, [n_table+bx]
        cmp     ax, SILENCE
        je      main            ; if silence no output!
        push    ax              ; Save NoteInfo
        xor     cx, num_ch      ; num de canales maximos donde buscar "blank"
        mov     bx, [cur_ch]
        add     bx, [cur_ch]    ; bx = last played channel * 2
inc_ch: add     bx, 2           ; Go next channel
        cmp     bx, num_ch*2
        jl      @@no_mod
        sub     bx, num_ch*2
@@no_mod:
        mov     ax, [ch_nfo+bx]
        or      ax, ax
        jz      @@found_b       ; we have found a blank channel!
        loop    inc_ch          ; Follow searching for a blank!
        pop     ax              ; Restore Stack (Xtract unused Noteinfo)
        jmp     main            ; if there's no place just ignore las note!

@@found_b:
        pop     ax              ; Restore NoteInfo
        mov     [ch_nfo+bx], ax
        shr     bx, 1           ; Divide BX /2 to find channel numba!
        mov     [cur_ch], bx    ; Updated Current Channel
        call    ad_play         ; and play ya note....
        jmp     main

;■■■■■■■■■■■■■■■■ Break ■■■■■■■■■■■■■■■■
@brk:   and     ah, 01111111b   ; convert break to make!
        cmp     ah, 50
        jng     @@cont
        jmp     main            ; if scancode is biggest than 50 ignore it!!
@@cont: xor     bx, bx
        mov     bl, ah          ; save the scancode on BL!
        mov     [k_table+bx], 0 ; deactivate key_flag[bx]
        shl     bx, 1           ; multiply scancode by WORD size to find IDX!
        mov     ax, [n_table+bx]
        cmp     ax, SILENCE
        jne     @@play          ; if no silence lets play... ;)
        jmp     main
@@play: xor     bx, bx          ; Start to find on channel 0
        mov     cx, ax          ; save noteinfo to search for...
@@srch: mov     ax, [ch_nfo+bx]
        cmp     cx, ax
        je      @@found
        add     bx, 2           ; Next channel!
        cmp     bx, num_ch*2
        jnz     @@srch          ; If channel < MAX continue search...
        jmp     @end            ; If not found ignore this "break" (and exit!)

@@found:mov     [ch_nfo+bx], 0  ; Reset ch_nfo!
        shr     bx, 1           ; Divide BX /2 to find channel numba!
        and     ah, 11011111b   ; Release named Key!
        call    ad_play         ; and play the "released" note
        jmp     main            ; Back to we started! ;)

;■■■■■■■■■■■■■■■■ End ■■■■■■■■■■■■■■■■
@end:   cli
        mov     al, [int_msk]
        out     21h, al         ; restore old interrupt mask!
        sti

        call    ad_init         ; Shut up the aDLiB!

        mov     ah, 4ch
        int     21h

;-------------------------------; Uninitialized data goes HERE!

ch_nfo  dw      num_ch dup (0)
int_msk db      0
k_table db      50 dup (0)      ; Flag para tecla pulsada!

end     inicio
