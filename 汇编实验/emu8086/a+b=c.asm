
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h  

MOV AH,01H
INT 21H   
SUB AL,30H  
MOV BL,AL

MOV AH,02H  
MOV DL,'+'  
INT 21H  

MOV AH,01H   
INT 21H
SUB AL,30H
   
ADD AL,BL
XOR AH,AH
MOV BL,10
DIV BL
ADD AX,3030H
MOV BX,AX
  
MOV AH,02H
MOV DL,'='
INT 21H 

MOV DL,BL
INT 21H
MOV DL,BH
INT 21H

MOV AH,4CH
INT 21H  

ret




