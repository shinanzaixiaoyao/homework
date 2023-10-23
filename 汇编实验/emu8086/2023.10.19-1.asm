
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

MOV AX,1018H
MOV SI,230AH
ADD AX,SI
ADD AL,30H
MOV BX,3FFH
SUB AX,BX
MOV WORD PTR [20H],1000H
ADD [20H],AX
PUSH AX
POP BX    
MOV AX,0FFFFH
INC AL
ADD AH,1

MOV BL,25H
MOV BYTE PTR [10H],4
MOV AL,[10H]
MUL BL 
 
MOV WORD PTR [10H],80H
MOV BL,4
MOV AX,[10H]
DIV BL

; add your code here

ret




