;          �   �   ������Ŀ     �   �
; �������¿�ڿ����ڿ��ڿ¿��ڿ���ڿ���ڿڿ�����������������������������������Ŀ
; �     ��������  ����ڴ� � ��  ����� � ��     code and artwork by Dr.Chandra �
; �����������������������������������������������������������������������������
;                  ��������
;
;-*---------------------------------------*-
;
;      Well thiz ain't nothing to be proud of... (If ya don't think so, watch
; some "big group" demos) :) but I released the full (lame) source w/the hope
; that it will help someone... (PS: Also sorry 'bout my poor English) ;)
;
;     Ok! The EXE is 2994 bytes long coz it's a "intro" (ehem) coded with the
; next millenium in mind... (Ya know all this Trekkie stuff... "Live Long and
; Eat my Phaser") :) (Greets 2 Captain Ifyarluck Pickacard!) :):)
;
;       PS: Some comments are written in Spanglish but *I know* my limitations
; and thought that this |&#/�$+%@*! will probably will never cross the spanish
; frontier... (or it will?) :)
;
; -> Greets <- ...That's why all thiz ASM coding stands for... ;)
;
; * Marta... (she knows perfectly why... or not?) :)
; * JMdJ, Karlitos, and Takashi! (gr8 friends)
; * All CarWars players AROUND THE WORLD... Specially Heinrich Frobenius and
;   his troupe... (next time I'll *kill* you, I promise)
;   -- Omega Speedway Night-Bowl Final on June 17th -- ask4it!
;   -- Don't forget Karnaugh-Doughnut's Masacre on Wheels on June 20th --
; * Frank, Steve (Where are you?), Francesc and all other C00L sysops around!
;   (Those NON-C00L sysops know who they are...) :)
; * All ASM coders and DemoMakers... (Specially The Virtual Crew, Iguana,
;   Postumum, and all Spanish ones...) (Hi's & Yo's jmp to D�-Ph�$$�D!,
;   Dyonisos, Chc, Darkmind, Ripness, Jare, JCAB, and all others!)
;   Thanks All Source Releasers, werever and whoever they are! :)
; * (this greet is Intentionally left blank)
; * And specially all FIBers around... (Please Remember to use *ALL KIND* of
;   alternative E-MAIL SYSTEMS and forget the nasty "CORREU" imposed by our
;   well know dictator...
;   Hi's and Yo's jmp to Akira, Carlos (the one who introduced us to the SIRDs
;   time ago...), N�M�S|S (how come?), Ojetes Azules and all the others!
;   (except LSI related guys, you know who you are)
; * I Think I spent more time writting all this shit than coding the "intro"!
;
;-*---------------------------------------*-

        .286                    ; � Did I really USED 286 instructions ? :)
        .model small            ; of COZ! (haw, haw)
        .stack 100

        .data

scroll_dir equ 160*17           ; �ndice a mem_video where scroll is!!

int_mask db ?                   ; M�scara existente en Ctrlador de Ints!

Equipment db 'Sorry, but you need a VGA card to run this AnSi.',0Dh,0Ah,'$'
; I removed 286 Messy 'cos there's no 286-checking routine... :)

smooth  dw 0                    ; Scanline a ense�ar 0-1600
sin_idx dw 0                    ; Indice a sintable para smooth!

; Logo

akron label byte
        db      2,16,25,'=Code by Dr.Chandra',24,24,24,24,24,24,24,24
        db      24,25,13,1,'�������',25,30,'��',24,25,12,'��',25,4,'�'
        db      '� ��',25,3,'��  ',26,5,'�  ',26,6,'�  ������  ',26,7
        db      '�',24,25,12,'��',25,4,'�� ��',25,3,'��',25,6,'�� ��'
        db      25,3,'��',25,2,'��',25,8,'���',24,25,12,'��',25,4,'�'
        db      '� ��',25,3,'��  ������� ��',25,8,'��',25,6,'���',24,25
        db      12,'�� ��� �� ��',25,3,'�� ��',25,3,'�� ��',25,8,'��'
        db      25,4,'���',24,25,13,'�������  ��',26,3,'��� ��',26,3,'�'
        db      '�� ��',25,8,'����� ��',26,5,'�',24,25,18,'���',25,'-'
        db      'BBS',24,25,2,26,'I�',24,24,25,2,26,'I�',24,25,9,'2:'
        db      '343/130@fidonet, 14:4500/105@sbcnet, 16:1400/104@zy'
        db      'xelnet',24,25,8,'34:3000/0@soundnet, 34:3000/10@sou'
        db      'ndnet, 34:3000/100@soundnet',24,25,13,'757:101/23@r'
        db      'edbbs, 93:308/4@bcnnet, 93:300/0@bcnnet',24,25,3,'7'
        db      '57:101/23@redbbs, 93:308/4@bcnnet, 93:300/0@bcnnet,'
        db      ' 147:1720/2@warpspd',24,25,4,'(+34-3)276-4345 (24 h'
        db      ') - Barcelona (Spain) - Sysop: Francisco Carrillo',24
akron_length equ ($ - akron)

msg_idx dw msg_start            ; Indice a msg a pintar.
msg_start label byte            ; solo saldr�n la primera vez!
        db '* This File Came From Quartz BBS *',0
        db '- Elite SoundBB -',0
        db 'With All Stuff You L00K For:',0
msg_ini label byte              ; estos se "ciclar�n" tol rato... :)
        db 'Last Demos & Sound Programs',0
        db 'Best Gus And Sb Utilities Around',0
        db '8 Bits Emulators Support',0
        db 'Msx-1 And Cpc Games',0
        db '1500 Spectrum Games On-Line!',0
        db 'Cd-Rom x2 Speed With Best Freeware',0
        db 'No Ratios! Free Access!',0
        db 'Tons Of Message Areas!',0
        db 'CooL SysOp! ;)',0
        db 'Dont''t Forget To Contact Us',0
        db '+34-3-2764345, 24 hrs, ZyX 19k2',0
        db 'PReSS aNy Key To QuiT',0
        db 'Remember...',0
msg_end label byte

;-----------------------------------------------------------------------------

back_ini label byte             ; Palette for RASTER_COLORING! :)
        db 00h,00h,00h,02h,00h,02h,04h,00h,04h,07h,00h,06h,09h,00h,09h,0Ch
        db 00h,0Bh,0Eh,00h,0Dh,11h,00h,0Fh,13h,00h,12h,16h,00h,14h,18h,00h
        db 16h,1Ah,00h,18h,1Dh,00h,1Bh,1Fh,00h,1Dh,22h,00h,1Fh,24h,00h,21h
        db 27h,00h,24h,29h,00h,26h,2Ch,00h,28h,2Eh,00h,2Ah,31h,00h,2Dh,32h
        db 00h,2Dh,33h,00h,2Ch,33h,00h,2Bh,34h,00h,2Ah,35h,00h,2Ah,35h,00h
        db 29h,36h,01h,28h,36h,01h,27h,37h,01h,27h,37h,01h,26h,38h,02h,25h
        db 38h,02h,24h,39h,02h,24h,39h,02h,23h,3Ah,03h,22h,3Ah,03h,21h,3Bh
        db 03h,20h,3Bh,04h,20h,3Bh,04h,1Fh,3Ch,05h,1Eh,3Ch,05h,1Dh,3Ch,05h
        db 1Dh,3Dh,06h,1Ch,3Dh,06h,1Bh,3Dh,07h,1Ah,3Eh,07h,19h,3Eh,08h,19h
        db 3Eh,08h,18h,3Eh,09h,17h,3Fh,0Ah,16h,3Fh,0Ah,16h,3Fh,0Bh,15h,3Fh
        db 0Bh,14h,3Fh,0Ch,13h,3Fh,0Dh,13h,3Fh,0Dh,12h,3Fh,0Eh,11h,3Fh,0Fh
        db 11h,3Fh,0Fh,10h,3Fh,10h,0Fh,3Fh,11h,0Fh,3Fh,11h,0Eh,3Fh,12h,0Dh
        db 3Fh,13h,0Dh,3Fh,13h,0Ch,3Fh,14h,0Bh,3Fh,15h,0Bh,3Fh,16h,0Ah,3Fh
        db 16h,0Ah,3Eh,17h,09h,3Eh,18h,08h,3Eh,19h,08h,3Eh,19h,07h,3Dh,1Ah
        db 07h,3Dh,1Bh,06h,3Dh,1Ch,06h,3Ch,1Dh,05h,3Ch,1Dh,05h,3Ch,1Eh,05h
        db 3Bh,1Fh,04h,3Bh,20h,04h,3Bh,20h,03h,3Ah,21h,03h,3Ah,22h,03h,39h
        db 23h,02h,39h,24h,02h,38h,24h,02h,38h,25h,02h,37h,26h,01h,37h,27h
        db 01h,36h,27h,01h,36h,28h,01h,35h,29h,00h,35h,2Ah,00h,34h,2Ah,00h
        db 33h,2Bh,00h,33h,2Ch,00h,32h,2Dh,00h,31h,2Dh,00h,31h,2Eh,00h,30h
        db 2Fh,00h,2Fh,2Fh,00h,2Fh,30h,00h,2Eh,31h,00h,2Dh,31h,00h,2Dh,32h
        db 00h,2Ch,33h,00h,2Bh,33h,00h,2Ah,34h,00h,2Ah,35h,00h,29h,35h,00h
        db 28h,36h,01h,27h,36h,01h,27h,37h,01h,26h,37h,01h,25h,38h,02h,24h
        db 38h,02h,24h,39h,02h,23h,39h,02h,22h,3Ah,03h,21h,3Ah,03h,20h,3Bh
        db 03h,20h,3Bh,04h,1Fh,3Bh,04h,1Eh,3Ch,05h,1Dh,3Ch,05h,1Dh,3Ch,05h
        db 1Ch,3Dh,06h,1Bh,3Dh,06h,1Ah,3Dh,07h,19h,3Eh,07h,19h,3Eh,08h,18h
        db 3Eh,08h,17h,3Eh,09h,16h,3Fh,0Ah,16h,3Fh,0Ah,15h,3Fh,0Bh,14h,3Fh
        db 0Bh,13h,3Fh,0Ch,13h,3Fh,0Dh,12h,3Fh,0Dh,11h,3Fh,0Eh,11h,3Fh,0Fh
        db 10h,3Fh,0Fh,0Fh,3Fh,10h,0Fh,3Fh,11h,0Eh,3Fh,11h,0Dh,3Fh,12h,0Dh
        db 3Fh,13h,0Ch,3Fh,13h,0Bh,3Fh,14h,0Bh,3Fh,15h,0Ah,3Fh,16h,0Ah,3Fh
        db 16h,09h,3Eh,17h,08h,3Eh,18h,08h,3Eh,19h,07h,3Eh,19h,07h,3Dh,1Ah
        db 06h,3Dh,1Bh,06h,3Dh,1Ch,05h,3Ch,1Dh,05h,3Ch,1Dh,05h,3Ch,1Eh,04h
        db 3Bh,1Fh,04h,3Bh,20h,03h,3Bh,20h,03h,3Ah,21h,03h,3Ah,22h,02h,39h
        db 23h,02h,39h,24h,02h,38h,24h,02h,38h,25h,01h,37h,26h,01h,37h,27h
        db 01h,36h,27h,01h,36h,28h,00h,35h,29h,00h,35h,2Ah,00h,34h,2Ah,00h
        db 33h,2Bh,00h,33h,2Ch,00h,32h,2Dh,00h,31h,2Dh,00h,31h,2Eh,00h,30h
        db 2Fh,00h,2Fh,2Fh,00h,2Fh,30h,00h,2Eh,31h,00h,2Dh,31h,00h,2Dh,32h
        db 00h,2Ch,33h,00h,2Bh,33h,00h,2Ah,34h,00h,2Ah,35h,00h,29h,35h,01h
        db 28h,36h,01h,27h,36h,01h,27h,37h,01h,26h,37h,02h,25h,38h,02h,24h
        db 38h,02h,24h,39h,02h,23h,39h,03h,22h,3Ah,03h,21h,3Ah,03h,20h,3Bh
        db 04h,20h,3Bh,04h,1Fh,3Bh,05h,1Eh,3Ch,05h,1Dh,3Ch,05h,1Dh,3Ch,06h
        db 1Ch,3Dh,06h,1Bh,3Dh,07h,1Ah,3Dh,07h,19h,3Eh,08h,19h,3Eh,08h,18h
        db 3Eh,09h,17h,3Eh,0Ah,16h,3Fh,0Ah,16h,3Fh,0Bh,15h,3Fh,0Bh,14h,3Fh
        db 0Ch,13h,3Fh,0Ch,13h,3Dh,0Ch,12h,3Bh,0Bh,12h,39h,0Bh,11h,37h,0Ah
        db 10h,35h,0Ah,10h,32h,0Ah,0Fh,30h,09h,0Eh,2Eh,09h,0Eh,2Ch,08h,0Dh
        db 2Ah,08h,0Ch,28h,08h,0Ch,25h,07h,0Bh,23h,07h,0Ah,21h,06h,0Ah,1Fh
        db 06h,09h,1Dh,05h,08h,1Bh,05h,08h,18h,05h,07h,16h,04h,06h,14h,04h
        db 06h,12h,03h,05h,10h,03h,04h,0Eh,03h,04h,0Bh,02h,03h,09h,02h,02h
        db 07h,01h,02h,05h,01h,01h,03h,00h,00h,00h
back_len equ ($ - back_ini) / 3

;-----------------------------------------------------------------------------

sintable label byte             ; (Sin(x) * 200-16)+1 (360 divisions)
        db   1,   1,   1,   1,   1,   1,   1,   1,   1,   2,   2,   2
        db   3,   3,   3,   4,   4,   5,   5,   6,   6,   7,   7,   8
        db   8,   9,  10,  11,  11,  12,  13,  14,  14,  15,  16,  17
        db  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  29,  30
        db  31,  32,  33,  35,  36,  37,  38,  40,  41,  42,  44,  45
        db  46,  48,  49,  51,  52,  54,  55,  57,  58,  60,  61,  63
        db  64,  66,  67,  69,  70,  72,  73,  75,  77,  78,  80,  81
        db  83,  84,  86,  88,  89,  91,  93,  94,  96,  97,  99, 101
        db 102, 104, 105, 107, 108, 110, 112, 113, 115, 116, 118, 119
        db 121, 122, 124, 125, 127, 128, 130, 131, 133, 134, 136, 137
        db 138, 140, 141, 143, 144, 145, 147, 148, 149, 150, 152, 153
        db 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166
        db 167, 168, 169, 170, 171, 171, 172, 173, 174, 174, 175, 176
        db 177, 177, 178, 178, 179, 179, 180, 180, 181, 181, 182, 182
        db 182, 183, 183, 183, 184, 184, 184, 184, 184, 184, 184, 184
        db 184, 184, 184, 184, 184, 184, 184, 184, 184, 183, 183, 183
        db 182, 182, 182, 181, 181, 180, 180, 179, 179, 178, 178, 177
        db 177, 176, 175, 174, 174, 173, 172, 171, 171, 170, 169, 168
        db 167, 166, 165, 164, 163, 162, 161, 160, 159, 158, 156, 155
        db 154, 153, 152, 150, 149, 148, 147, 145, 144, 143, 141, 140
        db 139, 137, 136, 134, 133, 131, 130, 128, 127, 125, 124, 122
        db 121, 119, 118, 116, 115, 113, 112, 110, 108, 107, 105, 104
        db 102, 101,  99,  97,  96,  94,  93,  91,  89,  88,  86,  84
        db  83,  81,  80,  78,  77,  75,  73,  72,  70,  69,  67,  66
        db  64,  63,  61,  60,  58,  57,  55,  54,  52,  51,  49,  48
        db  47,  45,  44,  42,  41,  40,  38,  37,  36,  35,  33,  32
        db  31,  30,  29,  27,  26,  25,  24,  23,  22,  21,  20,  19
        db  18,  17,  16,  15,  14,  14,  13,  12,  11,  11,  10,   9
        db   8,   8,   7,   7,   6,   6,   5,   5,   4,   4,   3,   3
        db   3,   2,   2,   2,   1,   1,   1,   1,   1,   1,   1,   1
sin_len equ ($ - sintable)

;font    label byte              ; I also had Designed thiz TeXTFoNT! ;)
;include font.inc                ; all 256 chars Included... hehehe!

;-----------------------------------------------------------------------------
           .code
;------------------------------------------------------------------------------

wait_for_retrace MACRO
           LOCAL  @@xx

           mov    dx, 03dah
     @@xx: in     al, dx
           test   al, 8
           jz     @@xx

           ENDM

;-----------------------------------------------------------------------------

wait_for_display MACRO
           LOCAL  @@xx

           mov    dx, 03dah            ; Wait for display
     @@xx: in     al, dx
           test   al,8
           jnz    @@xx

           ENDM

;-----------------------------------------------------------------------------

vsync      MACRO
           LOCAL @@x1, @@x2

           mov    dx, 03dah
     @@x1: in     al, dx
           test   al, 8
           jnz    @@x1

     @@x2: in     al, dx
           test   al, 8
           jz     @@x2

           ENDM

;-----------------------------------------------------------------------------

hsync      MACRO
           LOCAL @@x1, @@x2

           mov    dx, 03dah            ; Wait for horiz RETRACE!
     @@x1: in     al, dx               ; Ŀ
           test   al, 1                ;  �
           jnz    @@x1                 ;  �
     @@x2: in     al, dx               ;  �
           test   al, 1                ;  � THNX to VGA.DOC! ;)
           jz     @@x2                 ; ��

           ENDM

;-----------------------------------------------------------------------------

smooth_in_retrace MACRO

           mov    dx, 3d4h             ; This is for Some Smooth
           mov    ax, 8                ; esto ti� que hacerse en retrace!
           out    dx, ax               ; y la otra parte en display...
           inc    dx                   ; a ver si alguien me dice el pq! :)
           in     al, dx
           mov    bx, [smooth]         ; A mi me vibraba cuando lo hacia a
           and    al, 0E0h             ; y al final me he copiado de como lo
           and    bl, 00Fh             ; hace Jare en "nosequedemo", es decir
           or     al, bl               ; una parte en display y otra en
           out    dx, al               ; retrace

           ENDM

;-----------------------------------------------------------------------------

smooth_in_display MACRO

           cli
           mov    dx, 3d4h             ; Inicio de MEM de video a ense�ar!
           mov    ax, 0ch              ; (direccion del 1er caracter)
           out    dx, ax
           inc    dx
           mov    ax, [smooth]
           shr    ax, 4                ; ax <- smooth / scanlines_per_char
           mov    bl, 80               ; ax <- ax * chars_per_textline
           mul    bl
           mov    al, ah
           out    dx, al

           mov    dx, 3d4h             ; Smooth ][ ;)
           mov    ax, 0dh
           out    dx, ax
           inc    dx
           mov    ax, [smooth]
           shr    ax, 4
           mul    bl
           out    dx, al
           sti

           ENDM

;-----------------------------------------------------------------------------

back_palette MACRO
           LOCAL  @@margin, @@h_buc

           mov    dx, 03c8h            ; Ponemos el color de los credits (2)
           mov    al, 2                ; a cero para que no se vea por la parte
           out    dx, al               ; superior de la Pantalla!
           inc    dx
           xor    ax, ax
           out    dx, al
           out    dx, al
           out    dx, al

           wait_for_display

           mov    cx, 62               ; margen superior!
 @@margin: hsync
           loop   @@margin

           mov    cx, back_len
           mov    si, OFFSET back_ini

  @@h_buc: lodsb                       ; fetch del siguiente ds:[si]
           mov    ah, al               ; guardamos el componente rojo...
           lodsb
           mov    bl, al               ; ...el verde...
           lodsb
           mov    bh, al               ; ...y el azul!

           mov    dx, 03c8h
           mov    al, 1                ; Num de registro de paleta
           out    dx, al               ; que cambiaremos despues de hsync!

           hsync                       ; esperamos al inicio de CADA
                                       ; barrido horizontal!
           mov    dl, 0c9h
           mov    al, ah               ; Escupimos las tres componentes
           out    dx, al               ; que teniamos en AH, BL y BH!
           mov    al, bl
           out    dx, al
           mov    al, bh
           out    dx, al
           loop   @@h_buc

           mov    al, 15               ; Despues del Bucle ponemos el color de
           out    dx, al               ; los creditos tal y como le corresponde
           out    dx, al               ; <15,15,15>
           out    dx, al

           ENDM

;-----------------------------------------------------------------------------

cambio_msg MACRO
           LOCAL  @@pinta, @@pr_nxt, @@quit

           cmp    sin_idx, 0           ; Hay que pintarrrrr?
           je     @@pinta
           cmp    sin_idx, sin_len/2   ; y ahorrrra? :)
           je     @@pinta
           jmp    @@quit

  @@pinta: mov    ax, 0720h
           mov    di, scroll_dir
           mov    cx, 80
           cld
           rep    stosw                ; Borramos la linea

           mov    di, msg_idx          ; Leemos el (char *)  ;)
           mov    si, di               ; y lo guardamos en SI!
           mov    al, 0                ; buscamos un cero!
           push   es                   ; salvamos es
           push   ds
           pop    es
           mov    cx, 81               ; m�ximo a buscar (80 + el '\0')
           repne  scasb                ; y buscamos el 0!!
          ;jne    rutina_de_error      ; ASCIIZ demasiado largo...
           pop    es
           mov    msg_idx, di          ; DI apunta al principio del siguiente!
           sub    di, si               ; vamos a calcular la longitud!

           mov    cx, di               ; cx = strlen(ASCIIZ_que_toca)
           and    cx, 0FFFEh           ; cx tiene que ser par! ;)
           mov    ax, 80
           sub    ax, cx               ; ax = byte a empezar [0-39]
           mov    di, scroll_dir
           add    di, ax
 @@pr_nxt: movsb
           inc    di                   ; Nos saltamos el atributo!
           loop   @@pr_nxt

           cmp    msg_idx, offset msg_end
           jb     @@quit
           mov    msg_idx, offset msg_ini
   @@quit:
           ENDM

;-----------------------------------------------------------------------------

keyb_strobe MACRO

           in     al, 61h              ; y hacemos el Strobe de teclado :
           or     al, 10000000b        ;  � Activando el bit 7
           out    61h,al               ;  � y sac�ndolo pol puerto 61h
           and    al, 01111111b        ;  � apagamos el bit 7
           out    61h,al               ;  � y lo escupimos de nuevo

           ENDM

;-----------------------------------------------------------------------------

uncrunch   proc   near

           mov    ax, seg akron        ; pantalla base!
           mov    ds, ax
           mov    ax, offset akron
           mov    si, ax
           xor    ax, ax
           mov    di, ax
           mov    cx, akron_length

           mov    dx,di                ; Save X coordinate for later.
           xor    ax,ax                ; Set Current attributes.
           cld

Loopa:     lodsb                       ; Get next character.
           cmp    al,32                ; If a control character, jump.
           jc     ForeGround
           stosw                       ; Save letter on screen.
Next:      loop   Loopa
           jmp    Short Done

ForeGround:
           cmp    al,16                ; If less than 16, then change the
           jnc    BackGround           ; foreground color.  Otherwise jump.
           and    ah,0f0h              ; strip off old foreground.
           or     ah,al
           jmp    Next

BackGround:
           cmp    al,24                ; If less than 24, then change the
           jz     NextLine             ; background color.  If exactly 24,
           jnc    FlashBitToggle       ; then jump down to next line.
           sub    al, 16               ; Otherwise jump to multiple output
           add    al, al               ; routines.
           add    al, al
           add    al, al
           add    al, al
           and    ah, 8fh              ; Strip off old background.
           or     ah, al
           jmp    Next

NextLine:
           add    dx,160               ; If equal to 24,
           mov    di,dx                ; then jump down to
           jmp    Next                 ; the next line.

FlashBitToggle:
           cmp    al,27                ; Does user want to toggle the blink
           jc     MultiOutput          ; attribute?
           jnz    next
           xor    ah,128               ; Done.
           jmp    next

MultiOutput:
           cmp    al,25                ; Set Z flag if multi-space output.
           mov    bx,cx                ; Save main counter.
           lodsb                       ; Get count of number of times
           mov    cl,al                ; to display character.
           mov    al,32
           jz     StartOutput          ; Jump here if displaying spaces.
           lodsb                       ; Otherwise get character to use.
           dec    bx                   ; Adjust main counter.

StartOutput:
           xor    ch,ch
           inc    cx
           rep    stosw
           mov    cx,bx
           dec    cx                   ; Adjust main counter.
           loopnz loopa                ; Loop if anything else to do...

done:      ret

uncrunch   endp

;-----------------------------------------------------------------------------

restore_time proc near

           xor    al, al               ; Someday I have time I'll comment IT!
           out    70h,al               ; Please Don't credit me if you rip
           in     al, 71h              ; it... I'ts not mine!!!!!
           mov    dh, al
           and    dh, 15
           shr    al, 4
           mov    dl, 10
           mul    dl
           add    dh, al

           mov    al, 2
           out    70h, al
           in     al, 71h
           mov    cl, al
           and    cl, 15
           shr    al, 4
           mov    dl, 10
           mul    dl
           add    cl, al

           mov    al, 4
           out    70h, al
           in     al, 71h
           mov    ch, al
           and    ch, 15
           shr    al, 4
           mov    dl, 10
           mul    dl
           add    ch, al

           xor    dl, dl
           mov    ah, 2dh
           int    21h

           mov    al, 7
           out    70h, al
           in     al, 71h
           mov    dl, al
           and    dl, 15
           shr    al, 4
           mov    ch, 10
           mul    ch
           add    dl, al

           mov    al, 8
           out    70h,al
           in     al, 71h
           mov    dh, al
           and    dh, 15
           shr    al, 4
           mov    ch, 10
           mul    ch
           add    dh, al

           mov    al, 4
           out    70h,al
           in     al, 71h
           mov    cl, al
           and    cl, 15
           shr    al, 4
           mov    ch, 10
           mul    ch
           add    cl, al

           xor    ch, ch
           add    cx, 1900
           mov    ah, 2bh
           int    21h
           ret

restore_time endp

;-----------------------------------------------------------------------------

inicio:    xor    bx, bx               ; Vga detection routine *RIPPED*
           mov    ax, 01a00h           ; from "the_cop" by Jare/Iguana.
           int    10h                  ; Many thanks for the sources!
           cmp    bl, 7
           jc     notfound
           cmp    bl, 0dh
           jc     detected
notfound:  mov    dx, OFFSET equipment
           mov    ax, SEG equipment
           mov    ds, ax;
           mov    ah,9
           int    21h
           mov    ax,4c01h             ; This ErrorLevel *WILL* become a Std!
           int    21h                  ; Back to Me$$y-Dos!

detected:  mov    ax, 0003h            ; Setup 80x25 color mode!
           int    10h

;          mov    ax, SEG Font         ; Ponemos las fuentes!
;          mov    es, ax
;          mov    bp, OFFSET Font
;          mov    bh, 16               ; 16 bytes/char
;          mov    cx, 256              ; FULL CHARSET!
;          mov    dx, 0                ; So starting on ascii 0
;          xor    bl, bl               ; 1er bloc...
;          mov    ax, 1110h            ; load 8x16 font ;)   et voil�!
;          int    10h                  ; :-P

           cli
           in     al,21h
           mov    [int_mask], al       ; old status of the INT ctrller saved!
           or     al,11111111b
           out    21h,al               ; NO ints (�hay diferencia con un CLI?)
           sti

           mov    dx, 3d4h             ; VGA params to change... ;)
           mov    al, 0ah              ; Cursor START register
           out    dx, al
           inc    dl
           in     al, dx
           or     al, 00100000b        ; Apagamos el Cursor...! (bit 5==1)
           out    dx, al               ; Many thanks to VGA.DOC ;)

           mov    ax, 0B800h           ; Inicializamos los registros de Segm.
           mov    es, ax               ; ES <- Pantalla

           mov    dx, 03c8h
           mov    al, 1                ; Zeropalette! (colores 1 y 2)
           out    dx, al
           inc    dx
           xor    al, al
           mov    cx, 6
      @@1: out    dx, al
           loop   @@1

           call   uncrunch             ; Pintamos la pantalla base!!

           mov    dx, 3d4h             ; Tocamos el Line Compare ;)
           mov    al, 07h              ; para meter los creditz!
           out    dx, al
           inc    dl
           in     al, dx
           or     al, 00010000b        ; ponemos el bit 8 de LCr a 1 (+256) ;)
           out    dx, al
           dec    dl
           mov    al, 09h              ; max scan line reg.
           out    dx, al
           inc    dl
           in     al, dx
           and    al, 10111111b        ; clear bit 9 LC (no + 512) :):)
           out    dx, al
           dec    dl
           mov    al, 18h              ; set bits 0-7 LC (reg 18)
           out    dx, al
           inc    dl
           mov    al, 124              ; (+256 pq el bit 8 == 1)
           out    dx, al

main_loop: wait_for_retrace            ; pues eso!

           smooth_in_retrace

           cambio_msg                  ; Cambiamos el "texto" (si toca...)

           mov    bx, sin_idx          ; Ponemos en smooth un valor
           inc    bx                   ; sinusoidal sacado de sinustable
           cmp    bx, sin_len          ; Joder, como si no lo supierais! ;)
           jne    cont
           xor    bx, bx
     cont: mov    sin_idx, bx
           xor    ax, ax
           mov    al, sintable[bx]
           dec    al
           mov    [smooth], ax

           mov    bx, sin_idx          ; Intensidad del Texto!!
           add    bx, bx               ; bx = sin_idx * 2
           cmp    bx, sin_len
           jb     no_mod
           sub    bx, sin_len          ; bx = (sin_idx * 2) mod sin_len!
   no_mod: mov    ah, sintable[bx]
           shr    ah, 2                ; al = sin(bx) / 4 [0..45]
           mov    dx, 03c8h
           mov    al, 7                ; Color del texto!!! :)
           out    dx, al               ; Num de registro de paleta!
           inc    dx
           mov    al, ah
           out    dx, al               ; Intesidad del texto! :)
           out    dx, al
           out    dx, al

           back_palette                ; Enga�ado el Monitor.... :)
                                       ; Greets jmp here to D�-Ph�$$�D!/TVC!

           smooth_in_display           ; Pues backpal nos deja a medio display

           mov    al, 0ah
           out    20h, al
           in     al, 20h              ; AL <- IRR del 8259

           and    al, 00000010b        ; Se ha activado el IR del teclado?
           jz     cont_loop            ; no -> seguimos... ;)

           in     al, 60h              ; si hay una tecla, la leemos,
           mov    ah, al               ; la guardamos en AH,
           keyb_strobe                 ; y mandamos el strobe!

           cmp    ah, 10011100b        ; si es un break de return -> seguimos
           je     cont_loop
           and    ah, 10000000b        ; es un make o un break ?
           jnz    end_loop             ; break -> salimos

cont_loop: jmp    main_loop

 end_loop: cli
           mov    al, [int_mask]
           out    21h, al              ; restore old interrupt mask!
           sti

           mov    ax, 0003h
           int    10h                  ; restorin' txt mode! toma ch�!

           call   uncrunch             ; Pintamos la pantalla base!!

           mov    cx, 80*25
           mov    di, 1
           cld
           mov    ax, 08h              ; Atributo para colorear! (GrisOscuro)
      @@x: stosb                       ; "ponemos" el atributo y...
           inc    di                   ; ...nos saltamos el caracter
           loop   @@x

           mov    ah, 02               ; Bios SetCursor!
           xor    bh, bh               ; pagina 0!
           mov    dx, 1000h            ; Put the cursor 16 lines down! :)
           int    10h

           call   restore_time         ; Restore Time From CMOS!

messydos:  mov    ax, 4c00h            ; retornem al dos
           int    21h

end        inicio
