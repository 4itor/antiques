comment ÿÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ · ÄÄÄÄÄÄÄ · ÄÄÄÄÄÄÄÄÄÄÄ · ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
        Ö½                  ÇÄ ÖÄ·Ò Ò ÇÄ ÒÄ·ÖÄ·ÖÄ·ÖÄ¶ÖÄ·ÒÄ·                  Ó·
        º                   º  ÇÄ½ÓÒĞ·º  º  ÇÄ½ÖÄ¶º ºÇÄ½º                     º
        º                   ÓÄ½ÓÄ½ Ğ ĞÓÄ½Ğ  ÓÄ½ÓÄ½ÓÄ½ÓÄ½Ğ                     º
        ºúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúúº
        Ó·                      by Dr.Chandra/HeuristiX                      Ö½
         ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½ÿ

        ideal
        model tiny
        locals

;°°°°°°°°°°°°°°°° equates'n'constants °°°°°°°°°°°°°°°°
;
; We also all love Tran's Comment Style... :):)
;
debug           equ     0               ; Do you want some debugging info? :)
esc_brk         equ     10000001b       ; C¢digo de Break de la tecla ESCAPE!
scanlns         equ     46*8+1          ; numero de scanlines a "colorear"
Bios            equ     10h
Dos             equ     21h
accel           equ     1
lines           equ     102


;°°°°°°°°°°°°°°°° COM definition! °°°°°°°°°°°°°°°°
;
        codeseg
        org     100h
        assume  cs:@code, ds:@code

start:  jmp     main

;°°°°°°°°°°°°°°°° miscelaneous initialized data °°°°°°°°°°°°°°°°
;
Equipment  db   'Sorry, but you need a VGA card to run this TeXTReaDeR.',0Dh,0Ah,24h
Coded      db   'TeXTReaDeR coded by Dr.Chandra.',0Dh,0Ah,24h

int_mask   db   ?               ; M scara existente en Ctrlador de Ints!

smooth     dw   16              ; Skip "split-screen" area!
speed      dw   0               ; actual speed...
set_spd    dw   0               ; spd to change to...

label   keytable byte           ; Pressed Key table!
           db   0, 0, 0, 0      ; up, down, pgup, pgdn

label   key_spd word            ; Scroll speed for each key...
           dw   -15,15,-45,45   ; up, down, pgup, pgdn

label   scantable byte          ; scancodes!
           db     72d, 80d, 73d, 81d
num_of_keys equ 4

help       db     ' ',7,' ',7,' ',7,' ',7,' ',7,' ',7,'H',11,'e',3,'u',7
           db     'r',7,'i',7,'s',7,'t',7,'i',3,'X',11,' ',7,'T',11,'e'
           db     3,'X',7,'T',7,'R',7,'e',7,'a',7,'D',7,'e',3,'R',11,' '
           db     7,'í',8,' ',7,'<',8,'u',11,'p',3,'/',8,'d',11,'o',3,'w'
           db     7,'n',7,'/',8,'p',11,'g',3,'u',7,'p',7,'/',8,'p',11,'g'
           db     3,'d',7,'n',7,'>',8,' ',7,'í',8,' ',7,'<',8,'e',11,'s'
           db     3,'c',7,'>',8,' ',7,'q',7,'u',7,'i',7,'t',7,' ',7,'í'
           db     8,' ',7,'h',11,'a',3,'v',7,'e',7,' ',7,'p',11,'h',3,'u'
           db     7,'n',7,' ',7,' ',7,' ',7,' ',7,' ',7,' ',7,' ',7

;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ úCúOúDúEú!ú ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
;
;°°°°°°°°°°°°°°°° wait_for_retrace °°°°°°°°°°°°°°°°
;
proc    wait_for_retrace near

        mov    dx, 03dah
 @@xx2: in     al,dx
        jmp    $+2              ; ¨ Y este ?
        test   al,8
        jz     @@xx2

        ret
endp    wait_for_retrace


;°°°°°°°°°°°°°°°° wait_for_display °°°°°°°°°°°°°°°°
;
proc    wait_for_display near

        mov     dx, 03dah
 @@xx2: in      al,dx
        jmp     $+2             ; ¨ Y este ?
        test    al,8
        jnz     @@xx2

        ret
endp    wait_for_display


;°°°°°°°°°°°°°°°° vsync °°°°°°°°°°°°°°°°
;
proc    vsync near

        mov     dx, 03dah
  @@v1: in      al,dx
        jmp     $+2             ; ¨ Es necesario el retardo ? ;)
        test    al, 8
        jnz     @@v1

  @@v2: in      al,dx
        jmp     $+2             ; ¨ Y este ?
        test    al, 8
        jz      @@v2

        ret
endp    vsync


;°°°°°°°°°°°°°°°° uncrunch °°°°°°°°°°°°°°°°
;
proc    uncrunch near

        mov     dx, di          ; Save X coordinate for later.
        xor     ax, ax          ; Set Current attributes.
        cld

Loopa:  lodsb                   ; Get next character.
        cmp     al, 32          ; If a control character, jump.
        jc      ForeGround
        stosw                   ; Save letter on screen.
Next:   loop    Loopa
        jmp     short Done

ForeGround:
        cmp     al, 16          ; If less than 16, then change the
        jnc     BackGround      ; foreground color.  Otherwise jump.
        and     ah, 0f0h        ; strip off old foreground.
        or      ah, al
        jmp     Next

BackGround:
        cmp     al,24           ; If less than 24, then change the
        jz      NextLine        ; background color.  If exactly 24,
        jnc     FlashBitToggle  ; then jump down to next line.
        sub     al, 16          ; Otherwise jump to multiple output
        shl     al, 4           ; routines.
        and     ah, 8fh         ; Strip off old background.
        or      ah, al
        jmp     Next

NextLine:
        add     dx, 160         ; If equal to 24,
        mov     di, dx          ; then jump down to
        jmp     Next            ; the next line.

FlashBitToggle:
        cmp     al, 27          ; Does user want to toggle the blink
        jc      MultiOutput     ; attribute?
        jnz     next
        xor     ah, 128         ; Done.
        jmp     next

MultiOutput:
        cmp     al, 25          ; Set Z flag if multi-space output.
        mov     bx, cx          ; Save main counter.
        lodsb                   ; Get count of number of times
        mov     cl, al          ; to display character.
        mov     al, 32
        jz      StartOutput     ; Jump here if displaying spaces.
        lodsb                   ; Otherwise get character to use.
        dec     bx              ; Adjust main counter.

StartOutput:
        xor     ch, ch
        inc     cx
        rep     stosw
        mov     cx, bx
        dec     cx              ; Adjust main counter.
        loopnz loopa            ; Loop if anything else to do...
done:
        ret

endp    uncrunch


;°°°°°°°°°°°°°°°° calcline °°°°°°°°°°°°°°°°
;
proc    calcline near

        mov     [set_spd], 0    ; defaults to slowdown... (set_spd = 0)

        push    es
        push    cs
        pop     es              ; es = cs but save it first.
        cld
        mov     al, 1           ; search for any pressed key...
        mov     si, offset keytable
        mov     di, si
        mov     cx, num_of_keys
        repne   scasb           ; search for the scankey in scantable...
        pop     es
        jne     no_key

        sub     di, si          ; but if any key pressed let's find spd!
        dec     di
        mov     bx, di
        shl     bx, 1
        mov     ax, [key_spd+bx]
        mov     [set_spd], ax
       ;jmp     @@xx            ; if we jump the prefetch queue...
no_key: mov     ax, [set_spd]   ;                      ...will reset
  @@xx: cmp     [speed], ax
        jge     @@dummy1
        add     [speed], accel  ; if its bigger dec speed
        jmp     set_scan

@@dummy1:je     set_scan        ; if not equals must be lesser...
        sub     [speed], accel  ; ...then inc speed!

 set_scan:
        mov     ax, [speed]
        sar     ax, 1
        add     ax, [smooth]
        cmp     ax, 16          ; reached TOP?
        jge     @@dummy2
        mov     ax, 16
        neg     [speed]
        shr     [speed], 1
        jmp     @@end

@@dummy2:cmp    ax, 16*(lines-25) ; reached BOTTOM?
        jle     @@end
        mov     ax, 16*(lines-25)
        shr     [speed], 1
        neg     [speed]

 @@end: mov     [smooth], ax
        ret

endp    calcline


;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ main proc! ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
;
proc    main    near

        push    cs              ; setup ds as needed!
        pop     ds

        xor     bx, bx          ; Vga detection routine *RIPPED*
        mov     ax, 01a00h      ; from "the_cop" by Jare/Iguana.
        int     10h             ; Many thanks for the sources!
        cmp     bl, 7
        jc      novga
        cmp     bl, 0dh
        jc      okvga

novga:  mov     dx, OFFSET equipment
        mov     ah, 9
        int     21h
        mov     ax, 4c01h       ; This ErrorLevel *WILL* become a Std!
        int     21h             ; Back to Me$$y-Dos!

okvga:  mov     ax, 0003h       ; Setup 80x25 color mode!
        int     10h
        cli
        in      al, 21h
        mov     [int_mask], al  ; old status of the INT ctrller saved!
        or      al, 11111111b
        out     21h, al         ; NO ints (¨hay diferencia con un CLI?)
        sti

        mov     dx, 3d4h        ; VGA params to change... ;)
        mov     al, 0ah         ; Cursor START register
        out     dx, al
        inc     dl
        in      al, dx
        or      al, 00100000b   ; Apagamos el Cursor...! (bit 5==1)
        out     dx, al          ; Many thanks to VGA.DOC ;)

        mov     dx, 3d4h        ; setup Line Compare ;)
        mov     al, 07h         ; to show the "help" message...
        out     dx, al
        inc     dl
        in      al, dx
        or      al, 00010000b   ; ponemos el bit 8 de LCr a 1 (+256) ;)
        out     dx, al
        dec     dl
        mov     al, 09h         ; max scan line reg.
        out     dx, al
        inc     dl
        in      al, dx
        and     al, 10111111b   ; clear bit 9 LC (no + 512) :):)
        out     dx, al
        dec     dl
        mov     al, 18h         ; set bits 0-7 LC (reg 18)
        out     dx, al
        inc     dl
        mov     al, 127         ; (+256 pq el bit 8 == 1)
        out     dx, al

        cli                     ; And we must HIDE the split area...
        mov     dx, 3d4h
        mov     ax, 0ch         ; Start adress high!
        out     dx, ax
        inc     dx
        mov     al, 0           ; al = MSB(80)
        out     dx, al          ; barf it to the vga!
        mov     dx, 3d4h
        mov     ax, 0dh         ; Start address low!
        out     dx, ax
        inc     dx
        mov     al, 80          ; al = LSB(80)
        out     dx, al
        sti

;       mov     bp, OFFSET Font ; Ponemos las fuentes!
;       mov     bh, 16          ; 16 bytes/char
;       mov     cx, 256         ; FULL CHARSET!
;       mov     dx, 0           ; So starting on ascii 0
;       xor     bl, bl          ; 1er bloc...
;       mov     ax, 1110h       ; load 8x16 font ;)   et voil…!
;       int     10h             ; <geeeez!>

        mov     ax, 0B800h      ; Inicializamos los registros de Segm.
        mov     es, ax          ; ES <- Pantalla

        mov     si, offset ansi ; pintamos pantalla base!
        mov     di, 160         ; coz 1st line is 4 split screen area!
        mov     cx, [ansi_length]
        call    uncrunch        ; Pintamos la pantalla base!!

        mov     si, offset help ; paint help message!
        xor     di, di
        mov     cx, 80
        rep     movsw

        call    vsync
pr_buc:                         ; Hasta que se pulse una tecla!
        call    wait_for_display

        cli
        mov     dx, 3d4h
        mov     ax, 0ch         ; Start adress high!
        out     dx, ax
        inc     dx
        mov     ax, [smooth]
        shr     ax, 4
        mov     bl, 80
        mul     bl
        mov     al, ah          ; al = MSB(scanline*80/16)
        out     dx, al          ; barf it to the vga!

        mov     dx, 3d4h
        mov     ax, 0dh         ; Start address low!
        out     dx, ax
        inc     dx
        mov     ax, [smooth]
        shr     ax, 4
        mul     bl              ; al = MSB(scanline*80/16)
        out     dx, al
        sti

        call    wait_for_retrace

        mov     dx, 3d4h        ; Let's "finetune" the scrolly! ;)
        mov     ax, 8
        out     dx, ax
        inc     dx
        in      al, dx          ; read previous content of register!
        mov     bx, [smooth]
        and     al, 0E0h
        and     bl, 00Fh
        or      al, bl          ; add scanline mod 16!
        out     dx, al          ; and PAN [scanline] mod 16 "pixels"...

        call    calcline

        mov     al, 0ah
        out     20h, al         ; Selecccion
        in      al, 20h         ; AL <- IRR del 8259

        and     al, 00000010b   ; Se ha activado el IR del teclado?
        jnz     do_key          ; si -> la "ejecutamos"... ;)
        jmp     pr_buc

do_key: in      al, 60h         ; si hay una tecla, la leemos
        mov     ah, al          ; y la guardamos en AH!
        in      al, 61h         ; y hacemos el Strobe de teclado :
        or      al, 10000000b   ;  Ú Activando el bit 7
        out     61h,al          ;  ³ y sac ndolo pol puerto 61h
        jmp     $+2             ;  ³ (si, esta pausa la he metido yo)
        and     al, 01111111b   ;  ³ apagamos el bit 7
        out     61h,al          ;  À y lo escupimos de nuevo

        mov     al, ah
        cmp     al, 10000001b   ; si es un break de ESC -> salimos
        je      ending
        mov     ah, 1           ; Por defecto "activamos" tecla...
        test    al, 10000000b   ; es un break?
        jz      make
        mov     ah, 0           ; pero si es un break la "apagamos"...
        and     al, 01111111b   ; y lo convertimos en make para...
                                ;     ...buscar en la tabla de teclas!
  make: push    es
        push    ds
        pop     es              ; es = ds but save it first.
        cld
        mov     si, offset scantable
        mov     di, si
        mov     cx, num_of_keys
        repne   scasb           ; search for the scankey in scantable...
        pop     es
        jne     not_found       ; if any other key pres./rel. ignore it!

        sub     di, si
        dec     di              ; di = si + keytable_idx + 1
        mov     bx, di          ; index of pressed key in keytable! :)
        mov     [keytable+bx],ah; put a 1/0 (depending on make/break)!

not_found:
        jmp     pr_buc

ending:
        cli
        mov     al, [int_mask]
        out     21h, al         ; restore old interrupt mask!
        sti

        mov     ax, 0003h
        int     10h             ; restorin' txt mode!

        mov     dx, OFFSET coded
        mov     ah, 9
        int     21h
 
messydos:
        mov    ax, 4c00h        ; retornem al dos
        int    21h

endp    main

;°°°°°°°°°°°°°°°° ANSI DATA °°°°°°°°°°°°°°°°
;
label   ansi_length word
        dw      3451
label   ansi    byte
include 'ansi.inc'

        end     start
