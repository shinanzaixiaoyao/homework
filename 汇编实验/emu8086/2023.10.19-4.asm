
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.MODEL SMALL
.STACK 0100H
.DATA
    ARRAY DB 10H,04H,30H
    SUM DB 0
.CODE
    MAIN PROC
        MOV AX,@DATA
        MOV DS,AX
        
        MOV BX,0010H
        MOV SI,OFFSET ARRAY
        MOV CX,3
    SET_LOOP:
        MOV AL,[SI]
        MOV [BX],AL
        ADD BX,1
        INC SI
    LOOP SET_LOOP
    
        MOV BX,10H
        MOV AX,0
        MOV CX,3  
    SUM_LOOP:
        ADD AX,[BX]
        ADD BX,1
    LOOP SUM_LOOP
        MOV SUM,AL
        
        MOV BX,0010H
        MOV AX,1
        MOV CX,3
        
        MOV BX,0013H
        MOV AL,SUM
        MOV [BX],AL
        
        MOV AH,4CH
        INT 21H
    MAIN ENDP
END MAIN

; add your code here

ret




