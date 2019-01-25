.model small
.stack 64
.data                                               
                         
T_Rex_Shape_1 db '    ****','$'
T_Rex_Shape_2 db '    ****','$'
T_Rex_Shape_3 db '    ****','$'
T_Rex_Shape_4 db '*   **','$'
T_Rex_Shape_5 db '** ***','$'
T_Rex_Shape_6 db ' *****','$'
T_Rex_Shape_7 db '  *** ','$'
T_Rex_Shape_8 db '  * *','$' 

T_Rex_Height equ 8
T_Rex_Width equ 8 
T_Rex_Edges_Count equ 8 
T_Rex_Edges dw ?, ?, ?, ?, ?, ?, ?, ?   
T_Rex_Position db 21;db because only y axis change every frame  
Max_Jump equ 11 ;the legs position at the max jump
Jump_Mode db 0 ;0 => not in jump, 1 => in jump going up and 2 => in jump going down 

Small_Cactus_Shape_1 db '*  *','$'
Small_Cactus_Shape_2 db '* *** *','$'
Small_Cactus_Shape_3 db '* *****','$'
Small_Cactus_Shape_4 db '*****','$'
Small_Cactus_Shape_5 db '  ***','$' 

Small_Cactus_Height equ 5 
Small_Cactus_width equ 7           
Small_Cactus_Edges_Count equ 5
Small_Cactus_Edges dw ?, ?, ?, ?, ?      
Small_Cactus_Position db 40 ;db because only x axis change every frame


Big_Cactus_Shape_1 db '   *  *','$'
Big_Cactus_Shape_2 db '* *** *','$'
Big_Cactus_Shape_3 db '* *** *','$'
Big_Cactus_Shape_4 db '***** *','$'              
Big_Cactus_Shape_5 db '  *****','$'
Big_Cactus_Shape_6 db '  *** ','$'
Big_Cactus_Shape_7 db '  *** ','$' 

Big_Cactus_Height equ 7 
Big_Cactus_width equ 7     
Big_Cactus_Edges_Count equ 5 
Big_Cactus_Edges dw ?, ?, ?, ?, ?
Big_Cactus_Position db 73 ;db because only x axis change every frame                              

 
Clouds_Shape_1 db '   **                     **','$'
Clouds_Shape_2 db '  *  *  **           **  *  *   **','$'
Clouds_Shape_3 db ' *    **  *         *  **    * *  *','$'
Clouds_Shape_4 db '*          *       *          *    *','$'
Clouds_Shape_5 db '************       *****************','$'
Clouds_Position equ 0617h

Y_Cactus equ 21
X_T_Rex equ 2 
T_Rex_On_Ground equ 21 
Best_Score dw 0
Score dw 0    

Top_Left dw ?
Bottom_Right dw ?
.code
main proc far           
    
mov ax,@data
mov ds,ax 
           
StartOver:
;----------------Disable Cursor-----------------------------------
mov ch, 32
mov ah, 1
int 10h   
;---------------Clear Whole Screen-------------------------------
mov Top_Left, 0
mov Bottom_Right, 1950h
call clear
;----move cursor----  
mov ah,2
mov dl,0  ;x axis
mov dh,22 ; y axis
int 10h
;----draw ground----  
mov ah,9
mov bh,0                    
mov al,'*' 
mov cx, 80 ; the screen's width is 80 so the number of * to be in the ground should be 80
mov bl, 0fh
int 10h    
;-----------------Draw Clouds-------------------------------------
  
;----move cursor----  
mov ah, 2      
mov dx, Clouds_Position
int 10h   
;----Draw Clouds----
mov ah, 9
mov dx, offset Clouds_Shape_5 
int 21h

;----move cursor----  
mov ah, 2      
mov dx, Clouds_Position 
sub dh, 1                
int 10h   
;----Draw Clouds----
mov ah, 9
mov dx, offset Clouds_Shape_4
int 21h      

;----move cursor----  
mov ah, 2      
mov dx, Clouds_Position 
sub dh, 2                
int 10h   
;----Draw Clouds----
mov ah, 9
mov dx, offset Clouds_Shape_3
int 21h   

;----move cursor----  
mov ah, 2      
mov dx, Clouds_Position 
sub dh, 3                
int 10h   
;----Draw Clouds----
mov ah, 9
mov dx, offset Clouds_Shape_2
int 21h   

;----move cursor----  
mov ah, 2      
mov dx, Clouds_Position 
sub dh, 4                
int 10h   
;----Draw Clouds----
mov ah, 9
mov dx, offset Clouds_Shape_1
int 21h


;------------------ 
call DrawT_Rex
call DrawSmallCactus
call DrawBigCactus 

;intialization of Edges  

;--T-Rex--------------- 

;        * * *  *
;        * * *  *
;        * *(2)(1)
; *      * *
;(8)*  * * *
; (7)* * *(3)
;    *(5)* 
;   (6) (4)   

;T_Rex_Position + 7x-5y to go to 1
;-x  to go to 2
;-x+3y to go to 3 
;-x+2y to go to 4
;-x-y to go to 5
;-x+y to go to 6
;-x-2y to go to 7  
;-x-y to go to 8

mov dh, T_Rex_Position
mov dl, X_T_Rex

add dl, 7       ;7x
sub dh, 5       ;-5y
mov T_Rex_Edges[0], dx  ;Go to 1

sub dl, 1 ;-x
mov T_Rex_Edges[2], dx  ;Go to 2

sub dl, 1 ;-x  
add dh, 3 ;+3y
mov T_Rex_Edges[4], dx  ;Go to 3

sub dl, 1 ;-x  
add dh, 2 ;+2y
mov T_Rex_Edges[6], dx  ;Go to 4

sub dl, 1 ;-x  
sub dh, 1 ;-y
mov T_Rex_Edges[8], dx  ;Go to 5  

sub dl, 1 ;-x  
add dh, 1 ;+y
mov T_Rex_Edges[10], dx  ;Go to 6   

sub dl, 1 ;-x  
sub dh, 2 ;-2y
mov T_Rex_Edges[12], dx  ;Go to 7

sub dl, 1 ;-x  
sub dh, 1 ;-y
mov T_Rex_Edges[14], dx  ;Go to 8

;--Small Cactus-------- 

;(1)  (3)
; * (2)*(4)(5)
; *  * * * **
; ** * * *
;    * * *

; Small_Cactus_Position -4y to go to 1
; 2x+y to go to 2
; x-y to go to 3
; x+y to go to 4
; 2x to go to 5

mov dl, Small_Cactus_Position
mov dh, Y_Cactus

sub dh, 4       ;-4y
mov Small_Cactus_Edges[0], dx  ;Go to 1

add dl, 2 ;+2x
add dh, 1 ;+y
mov Small_Cactus_Edges[2], dx  ;Go to 2

add dl, 1 ;+x  
sub dh, 1 ;-y
mov Small_Cactus_Edges[4], dx  ;Go to 3

add dl, 1 ;+x  
add dh, 1 ;+y
mov Small_Cactus_Edges[6], dx  ;Go to 4

add dl, 2 ;+2x  
mov Small_Cactus_Edges[8], dx  ;Go to 5

;--Small Cactus-------- 

;     (3)  (5)
;(1)(2)*(4) *
; *  * * *  *
; ** * * *  *
;    * * * **
;    * * *
;    * * *  

;Big_Cactus_Position -5y to go to 1
;+2x to go to 2
;+x-y to go to 3
;+x+y to go to 4
;+2x-y to go to 5

mov dl, Big_Cactus_Position
mov dh, Y_Cactus

sub dh, 5       ;-5y
mov Big_Cactus_Edges[0], dx  ;Go to 1

add dl, 2 ;+2x
mov Big_Cactus_Edges[2], dx  ;Go to 2

add dl, 1 ;+x  
sub dh, 1 ;-y
mov Big_Cactus_Edges[4], dx  ;Go to 3

add dl, 1 ;+x  
add dh, 1 ;+y
mov Big_Cactus_Edges[6], dx  ;Go to 4

add dl, 2 ;+2x
sub dh, 1 ;-y  
mov Big_Cactus_Edges[8], dx  ;Go to 5



GameLoop:               
    mov ah,1
    int 16h 
    pushf                               
    ;----------------Making Delay----------------
    mov cx,0H
    mov dx,7A12H
    mov ah,86H
    int 15H
    ;-------------------New Frame---------------- 
    ;-------------------First the T-Rex---------- 
    cmp Jump_Mode, 0
    jz Skip_T_Rex   
    ;-------------------First Clear T-Rex--------
    mov dl, X_T_Rex
    mov dh, T_Rex_Position     
    sub dh, T_Rex_Height
    mov Top_Left, dx 
    add dl, T_Rex_width
    mov dh, T_Rex_Position 
    mov Bottom_Right, dx
    call clear 
    ;-------------------Second Move T-Rex--------
    cmp Jump_Mode, 1
    jz Dec_Y_T_Rex 
    
    inc T_Rex_Position ; if jump mode is 2 
    jmp T_Rex                              
    
    Dec_Y_T_Rex:
    dec T_Rex_Position
    
    T_Rex:
    call DrawT_Rex
    
    cmp T_Rex_Position, T_Rex_On_Ground 
    jz Landed  
    
    cmp T_Rex_Position, Max_Jump 
    jz TopJump 
    
    jmp Skip_T_Rex
    
    Landed:
    mov Jump_Mode, 0 ;Landed
    
    jmp Skip_T_Rex
    
    TopJump:
    mov Jump_Mode, 2 ;Start to fall down
     
    Skip_T_Rex:
    ;-----------------Small Cactus-----
    ;----First clear-------------------
    mov dl, Small_Cactus_Position
    mov dh, Y_Cactus     
    sub dh, Small_Cactus_Height
    mov Top_Left, dx 
    add dl, Small_Cactus_width
    dec dl
    mov dh, Y_Cactus 
    mov Bottom_Right, dx
    call clear 
    ;---------Second decide move or start over--- 
    cmp Small_Cactus_Position, 0 
    jnz Continue_Moving_Small_Cactus
    
    mov Small_Cactus_Position, 80 ;width of the screen
    sub Small_Cactus_Position, Small_Cactus_width  
    inc Score 
    jmp Small_Cactus
            
    Continue_Moving_Small_Cactus:
    dec Small_Cactus_Position
    
    Small_Cactus:            
    call DrawSmallCactus   
    ;-----------------Big Cactus-----
    ;----First clear------------------- 
    mov dl, Big_Cactus_Position
    mov dh, Y_Cactus     
    sub dh, Big_Cactus_Height
    mov Top_Left, dx 
    add dl, Big_Cactus_width
    dec dl
    mov dh, Y_Cactus       
    mov Bottom_Right, dx
    call clear 
    ;---------Second decide move or start over---
    cmp Big_Cactus_Position, 0 
    jnz Continue_Moving_Big_Cactus
    
    mov Big_Cactus_Position, 80 ;width of the screen
    sub Big_Cactus_Position, Big_Cactus_width      
    inc Score
    jmp Big_Cactus
            
    Continue_Moving_Big_Cactus:
    dec Big_Cactus_Position
    
    Big_Cactus:                
    call DrawBigCactus 
    ;-------------Check if Collision happened-------------
    mov dl, X_T_Rex
    add dl, T_Rex_Width
    dec dl
    cmp Small_Cactus_Position, dl
    JG Skip_Small_Collision ;Skip_Collision_Check_With_Small_Cactus
      
    mov di, 0
    mov si, 0
    mov ax, Small_Cactus_Edges_Count
    
    Outer_Loop_Small_Collision:
    mov cx, T_Rex_Edges_Count
    mov di, 0            
    
        Check_Small_Collision:   
        mov bx, T_Rex_Edges[di]
        cmp bx, Small_Cactus_Edges[si]
        jz GameOver
        add di, 2
        loop Check_Small_Collision   
    add si, 2
    dec ax
    cmp ax, 0
    jnz Outer_Loop_Small_Collision  
     
    jmp Skip_Big_Collision ; lw check el small mosta7el yt4eq el kbera 3l4an el etnen m4 hayb2o 3nd el dinsasour f nafs el frame  
    
    Skip_Small_Collision: 
    cmp Big_Cactus_Position, dl
    JG Skip_Big_Collision ;Skip_Collision_Check_With_Small_Cactus 
    
    ;--------------Big Collision--------------------------
    mov di, 0
    mov si, 0
    mov ax, Big_Cactus_Edges_Count
    
    Outer_Loop_Big_Collision:
    mov cx, T_Rex_Edges_Count
    mov di, 0            
    
        Check_Big_Collision:
        mov bx, T_Rex_Edges[di]  
        cmp bx, Big_Cactus_Edges[si]
        jz GameOver
        add di, 2
        loop Check_Big_Collision   
    
    add si, 2
    dec ax
    cmp ax, 0
    jnz Outer_Loop_Big_Collision
    
    Skip_Big_Collision: 
    
    
    
    ;-------------------------------------------
    popf 
    jz GameLoop     
    mov ah,0
    int 16h 
    cmp Jump_Mode, 0
    jnz GameLoop
    ;---------------Jump--------------
    cmp al,20h  ;space buttom
    jz Jump
    cmp ax,4800h  ;Up buttom
    jz Jump
    
    jmp GameLoop     
    
    Jump:
    mov Jump_Mode, 1 ; jump up    
    
    
    jmp GameLoop  
    
    GameOver:
    mov bx, Score
    mov Best_Score, bx
    
    mov T_Rex_Position, 2
    mov Small_Cactus_Position, 40
    mov Big_Cactus_Position, 73 
    mov Score, 0
             
    Wait_Reset: 
    mov ah, 0h
    int 16h
    cmp al, 'r'
    jz StartOver
    cmp al, 'R' 
    jz StartOver
    jmp Wait_Reset   
                                
main endp

;---------------------Drawing Functions-------------
DrawT_Rex proc near    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; x of the t-rex      
    mov dh, T_Rex_Position ; y axis
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_8 
    int 21h
    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; start x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 1                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_7
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; start x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 2                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_6
    int 21h  
    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; start x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 3                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_5
    int 21h    
                     
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; start x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 4               
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_4
    int 21h
    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 5                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_3
    int 21h
    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 6                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_2
    int 21h   
    
    ;----move cursor----  
    mov ah, 2
    mov dl, X_T_Rex  ; x of the t-rex      
    mov dh, T_Rex_Position ; y axis 
    sub dh, 7                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset T_Rex_Shape_1
    int 21h                     
    
    ret
DrawT_Rex endp  

DrawSmallCactus proc near   
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Small_Cactus_Position ; x axis
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Small_Cactus_Shape_5 
    int 21h
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Small_Cactus_Position ; x axis
    sub dh, 1                
    int 10h                                                     
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Small_Cactus_Shape_4
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Small_Cactus_Position ; x axis 
    sub dh, 2                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Small_Cactus_Shape_3
    int 21h  
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Small_Cactus_Position ; x axis 
    sub dh, 3                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Small_Cactus_Shape_2
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Small_Cactus_Position ; x axis
    sub dh, 4                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Small_Cactus_Shape_1
    int 21h     
                     
    ret
DrawSmallCactus endp 

DrawBigCactus proc near   
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_7 
    int 21h
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis
    sub dh, 1                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_6
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis 
    sub dh, 2                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_5
    int 21h  
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis 
    sub dh, 3                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_4
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis
    sub dh, 4                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_3
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis
    sub dh, 5                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_2
    int 21h 
    
    ;----move cursor----  
    mov ah, 2
    mov dh, Y_Cactus      
    mov dl, Big_Cactus_Position ; x axis
    sub dh, 6                
    int 10h   
    ;----Draw T_Rex_____
    mov ah, 9
    mov dx, offset Big_Cactus_Shape_1
    int 21h                          
    
    ret
DrawBigCactus endp
;--------Clear Function----
Clear proc near
    pusha  
    mov ax, 0600H
    mov bh, 0fh ;white with black bg
    mov cx, Top_Left
    mov dx, Bottom_Right
    int 10h 
    popa
    ret   
Clear endp

;----Display Decimal Function---- 
DisplayNumber proc near
    MOV CX, 0            
L1: 
    MOV DX, 0
    MOV BX, 10
    DIV BX
    ADD DX, 30H
    PUSH DX
    INC CX
                
    CMP AX, 0
    JNE L1 
    
    MOV AH,2
    
L2:             
    POP DX
    int 21h
    LOOP L2 
`   
    ret            
DisplayNumber endp     
;-----------------------------end main----------------------------------
exitGame:
mov ah,04ch ;DOS "terminate" function
int 21h    
end main                                                                          