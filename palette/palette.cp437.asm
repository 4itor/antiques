;ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ · ÄÄÄÄÄÄÄ · ÄÄÄÄÄÄ · Ä ·  · ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
;º      Cow-2-matic ÇÄ ÖÄ·Ò Ò ÇÄ ÖÄ·ÖÄ·ºÖÄ·ÇÄ ÇÄ ÖÄ·                   º
;º                  º  ÇÄ½ÓÒÐ·º  º ºÖÄ¶ºÇÄ½º  º  ÇÄ½                   º
;º   (__)           ÓÄ½ÓÄ½ Ð ÐÓÄ½ÇÄ½ÓÄ½ÓÓÄ½ÓÄ½ÓÄ½ÓÄ½ Locker            º
;º-- ( oo ---------------------- ½ ------------------------------------º
;º   /\_|          by Dr.Chandra/HeuristiX, Feb-1994!                  º
;º        Mini residente que mantiene una paleta arbitraria fija.      º
;ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½

Bios           equ      10h            ; Vamos a Parchear la INT 10... :)
Dos            equ      21h            ; DOS Interrupt
Set_Vector     equ      25h            ; Set interrupt vector service
Get_Vector     equ      35h            ; Get interrupt vector service
Get_Pal_Regs   equ      1009h          ; Funcion 09 de la bios de video.

Check_AX       equ      004F1h         ; -> Es la llamada a Read Light Pen...
Check_BX       equ      0F2F3h         ; (AH == 4) el resto es DUMMY... :)
Check_CX       equ      0F4F5h
Check_DX       equ      0F6F7h
Present_AX     equ      01234h         ; Presencia afirmativa!
Present_BX     equ      05678h
Present_CX     equ      09ABCh
Present_DX     equ      0DEF0h

Code           segment
               assume   CS:Code, DS:Code, ES:Code, SS:Code
               org      100h

_PaL_LoCK:     jmp      Start          ; Nos saltamos la parte que quedar ...
                                       ; ...Residente y vamos a la INSTALACION!

;----------------------------------------------------------------------------
; Datos que utiliza la parte residente del Trasto!
;-----------------------------------------------------------------------------

Old_Int      equ  $
Old_Int_Ofs  dw   ?                    ; Espacio para guardar el "viejo"
Old_Int_Seg  dw   ?                    ; Valor de la INT 10

pal_data     db   00, 00, 00           ; black            pal_regs[0]
             db   00, 00, 30           ; blue                 |
             db   00, 41, 14           ; green                |
             db   00, 34, 41           ; cyan                 |
             db   37, 00, 00           ; red                  |
             db   30, 00, 30           ; magenta              |
             db   34, 21, 00           ; brown                |
             db   40, 40, 40           ; gray                 |
             db   21, 21, 21           ; dark gray            |
             db   00, 27, 63           ; bright blue          |
             db   10, 60, 12           ; bright green         |
             db   00, 57, 60           ; bright cyan          |
             db   60, 00, 04           ; bright red           |
             db   63, 40, 47           ; bright magenta       |
             db   63, 55, 10           ; bright yellow        |
             db   63, 63, 63           ; bright white     pal_regs[16]

pal_regs     db   17 dup (?)           ; 16 Colores + Overscan;

;----------------------------------------------------------------------------
; Rutina que se encarga de cambiar los colores del la paleta
;-----------------------------------------------------------------------------

set_pal    proc   near

           pushf                       ; Salvamos los registros que tocamos!
           push   ax
           push   cx
           push   dx
           push   si
           push   di
           push   ds
           push   es

           push   cs
           pop    es
           mov    dx, Offset pal_regs
           mov    ax, Get_Pal_Regs
           int    Bios                 ; Ahora tenemos en pal_regs[]...
                                       ; ...el "mapeo" de los 16 colores!
           push   cs
           pop    ds

           mov    si, Offset pal_data  ; Offset a tabla de RGB's
           mov    di, Offset pal_regs  ;    "   a tabla del Palette Registers
           mov    cx, 16               ; 16 colores a cambiar!

@@buc1:    mov    dx, 03c8h
           mov    al, ds:[di]          ; Cogemos el Palete register [i]
           inc    di
           out    dx, al               ; Num de registro de paleta...
           inc    dx
           lodsb                       ; AL <- ds:[si] , inc si
           out    dx, al               ; Red
           lodsb                       
           out    dx, al               ; Green
           lodsb
           out    dx, al               ; Blue

           dec    cx                   ; Siguiente entrada!
           jnz    @@buc1

           pop    es                   ; Restauramos los registros
           pop    ds
           pop    di
           pop    si
           pop    dx
           pop    cx
           pop    ax
           popf

           ret
Set_Pal    endp

;----------------------------------------------------------------------------
; Parche a la INT 10 que dejar  nuestra paleta FIJA! :)
;-----------------------------------------------------------------------------

New_Int:   cmp    ax, Check_AX         ; Nos estan buscando o es una...
           jne    NoCheck              ; ...llamada "normal" a la Func 04h...
           cmp    bx, Check_BX         ; ...de la bios?
           jne    NoCheck
           cmp    cx, Check_CX
           jne    NoCheck
           cmp    dx, Check_DX
           jne    NoCheck

           mov    ax, Present_AX       ; Ponemos los valores de Present!
           mov    bx, Present_BX
           mov    cx, Present_CX
           mov    dx, Present_DX

           iret                        ; I volvemos para dar el "Presente!"

NoCheck:
           pushf                       ; SIMULAMOS una INT para que la BIOS...
           call   dword ptr cs:Old_Int ; ...haga lo que ti‚ que hacer!

           cmp    ax, 0003h
           jne    NoChangePal          ; Si no estamos es mode 80x25(col) PASA!
           call   Set_Pal

NoChangePal:
           iret                        ; Un iret pa hacer el POPF que toca!
End_Code:

;----------------------------------------------------------------------------
; Barrera de Residencia! :) daqui parriba queda en Mem!!1 :)
;-----------------------------------------------------------------------------

Banner     db     "     The Cow-2-matic TextPalette Locker by Dr.Chandra/HeuristiX v0.9á",13,10
           db     "                  Completely Free for NonCommercial use.",13,10,'$'
Success    db     " (__)   ,--------------------------------------.",13,10
           db     " ( oo  /  Bios Interrupt SuccessFully Grabbed. |",13,10
           db     " /\_|  `---------------------------------------'",13,10,'$'
Installed  db     " (__)   ,--------------------------------.",13,10
           db     " ( oo  /  Already installed, aborting... |",13,10
           db     " /\_|  `---------------------------------'",13,10,'$'

;     Para comprobar si est  instalado llamaremos a la int 10h con ciertos
; parametros (Check) esperando ciertos resultados (Present) es importante,
; claro, que los parametros de Check sean "inofensivos", en este caso
; utilizamos una llamada al "read light-pen status" de la bios.

Start:     mov    dx, offset Banner    ; Ponemos el Mensajito de Marras!
           mov    ah, 9
           int    Dos

           mov    ax, Check_AX         ; Esta ya instalado ?
           mov    bx, Check_BX
           mov    cx, Check_CX
           mov    dx, Check_DX

           Int    Bios                 ; Vamos a ver,,,

           cmp    ax, Present_AX       ; Estamos checkeando para ver si YA
           jne    Install              ; instalado... en caso de fallar
           cmp    bx, Present_BX       ; alguno de los "present" saltamos
           jne    Install              ; al proceso de Instalacion
           cmp    cx, Present_CX
           jne    Install
           cmp    dx, Present_DX
           jne    Install

           mov    dx, offset Installed ; Mensaje de *YA* Instalado
           mov    ah, 9
           int    Dos

           mov    ax, 4c01h            ; De vuelta al DOS con ERRLV == 1
           int    DoS

Install:   call   Set_Pal              ; Ponemos la paleta! ;)
           push   es

           mov    al, Bios
           mov    ah, Get_Vector       ; Guardamos el viejo vector 10!
           int    Dos
           mov    Word Ptr Old_Int_Seg, ES
           mov    Word Ptr Old_Int_Ofs, BX

           push   cs                   ; Pa poder instalar lo nuestro...
           pop    ds                   ; DS tie que ser igual a CS ;)
           mov    dx, Offset New_Int
           mov    al, Bios
           mov    ah, Set_Vector
           int    Dos

           pop    es

           mov    es, es:[2Ch]
           mov    ah,49h               ; Liberamos el el env que nos da...
           int    Dos                  ; ...el DOS (pues no lo necesitamos)

           mov    dx, offset Success   ; Ponemos el Mensajito de Success!
           mov    ah, 9
           int    Dos

           mov    ax, 3100h            ; Terminate and Stay Resident.
           mov    dx, (End_Code - _PaL_LoCK + 100h) shr 4
           inc    dx
           int    Dos

Code       ends
           end    _PaL_LoCK

;-----------------------------------------------------------------------------
