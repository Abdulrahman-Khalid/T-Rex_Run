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

Small_Cactus_Shape_1 db '*  *','$'
Small_Cactus_Shape_2 db '* *** *','$'
Small_Cactus_Shape_3 db '* *****','$'
Small_Cactus_Shape_4 db '*****','$'
Small_Cactus_Shape_5 db '  ***','$' 

Small_Cactus_Height equ 5 
Small_Cactus_width equ 7

Big_Cactus_Shape_1 db '   *  *','$'
Big_Cactus_Shape_2 db '* *** *','$'
Big_Cactus_Shape_3 db '* *** *','$'
Big_Cactus_Shape_4 db '***** *','$'
Big_Cactus_Shape_5 db '  *****','$'
Big_Cactus_Shape_6 db '  *** ','$'
Big_Cactus_Shape_7 db '  *** ','$'

Big_Cactus_Height equ 7 
Big_Cactus_width equ 7

Y_Cactus equ 21
X_T_Rex equ 2 
T_Rex_On_Ground equ 21 

T_Rex_Position db 21;db because only y axis change every frame
Small_Cactus_Position db 40 ;db because only x axis change every frame
Big_Cactus_Position db 73 ;db because only x axis change every frame 


Max_Jump equ 11 ;the legs position at the max jump
Jump_Mode db 0 ;0 => not in jump, 1 => in jump going up and 2 => in jump going down 
Top_Left dw 0
Bottom_Right dw 1950h
.code
main proc far           
    
mov ax,@data
mov ds,ax            

;----------------Disable Cursor-----------------------------------
Mov ch, 32
Mov ah, 1
Int 10h   

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
;------------------ 
call DrawT_Rex
call DrawSmallCactus
call DrawBigCactus

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
    mov dh, Y_Cactus 
    mov Bottom_Right, dx
    call clear 
    ;---------Second decide move or start over--- 
    cmp Small_Cactus_Position, 0 
    jnz Continue_Moving_Small_Cactus
    
    mov Small_Cactus_Position, 80 ;width of the screen
    sub Small_Cactus_Position, Small_Cactus_width
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
    mov dh, Y_Cactus 
    mov Bottom_Right, dx
    call clear 
    ;---------Second decide move or start over---
    cmp Big_Cactus_Position, 0 
    jnz Continue_Moving_Big_Cactus
    
    mov Big_Cactus_Position, 80 ;width of the screen
    sub Big_Cactus_Position, Big_Cactus_width
    jmp Big_Cactus
            
    Continue_Moving_Big_Cactus:
    dec Big_Cactus_Position
    
    Big_Cactus:                
    call DrawBigCactus 
    
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
;-----------------------------end main----------------------------------
exitGame:
mov ah,04ch ;DOS "terminate" function
int 21h    
end main                                                                          