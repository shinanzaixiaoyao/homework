
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

MOV AL,15H  
ADD AL,AL
MOV BL,15H
MUL BL
; add your code here

ret




