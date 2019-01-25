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

Small_Cactus_Shape_1 db '*  *','$'
Small_Cactus_Shape_2 db '* *** *','$'
Small_Cactus_Shape_3 db '* *****','$'
Small_Cactus_Shape_4 db '*****','$'
Small_Cactus_Shape_5 db '  ***','$' 

Small_Cactus_Height equ 5

Big_Cactus_Shape_1 db '   *  *','$'
Big_Cactus_Shape_2 db '* *** *','$'
Big_Cactus_Shape_3 db '* *** *','$'
Big_Cactus_Shape_4 db '***** *','$'
Big_Cactus_Shape_5 db '  *****','$'
Big_Cactus_Shape_6 db '  *** ','$'
Big_Cactus_Shape_7 db '  *** ','$'

Y_Cactus equ 21
X_T_Rex equ 2
T_Rex_Position db 21;db because only y axis change every frame
Small_Cactus_Position db 40 ;db because only x axis change every frame
Big_Cactus_Position db 73 ;db because only x axis change every frame 


Max_Jump equ 10
Jump_Mode db 0 ;0 => not in jump, 1 => in jump going up and 2 => in jump going down 

.code
main proc far           
    
mov ax,@data
mov ds,ax            

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

Check:             
    mov ah,1
    int 16h 
    pushf     
    ;----------------Making Delay----------------
    mov cx,0H
    mov dx,7A12H
    mov ah,86H
    int 15H
    ;--------------------------------------------
    popf 
    jz Check     
    mov ah,0
    int 16h 
    cmp In_Jump_bool, 1
    jmp GameLoop
    ;---------------Jump--------------
    cmp al,20h  ;space buttom
    jz Jump
    cmp al,48h  ;Up buttom
    jz Jump
    
    jmp GameLoop     
    
    Jump:
        
    
    
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

;-----------------------------end main----------------------------------
exitGame:
mov ah,04ch ;DOS "terminate" function
int 21h    
end main                        
                                         
                                                       
                                                    
                                      