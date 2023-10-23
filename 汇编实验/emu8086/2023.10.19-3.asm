
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

MOV WORD PTR [1000H],2058H
MOV WORD PTR [1002H],0012H
MOV AX,[1000H]    
MOV BX,[1002H]
DIV BX
MOV [1003H],AX
; add your code here

ret




