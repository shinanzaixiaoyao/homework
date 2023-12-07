
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here   
.model small
.stack 100h

.data
array DW -10, 20, -5, -15, -30, 25, -35, 40, -45, 50
MAX DW 0

.code
start:
    MOV AX, @data
    MOV DS, AX

    MOV CX, 10         
    LEA SI, array    

    MOV AX, [SI]      
    ADD SI, 2         

LOOP_START:
    CALL FIND_MAX    
    ADD SI, 2       
    LOOP LOOP_START   

    MOV [MAX], AX    

    MOV AH, 4Ch       
    INT 21h

; 求两个数中的最大值
FIND_MAX PROC
    MOV BX, [SI]       
    CMP AX, BX         
    JGE NEXT           
    MOV AX, BX         
NEXT:
    RET
FIND_MAX ENDP

END start

ret




