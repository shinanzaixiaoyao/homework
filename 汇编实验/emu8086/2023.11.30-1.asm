               
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h  

.MODEL SMALL
.STACK
.DATA   
    X DB 0
    Y DB 0
.CODE
START:
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX
    
    CMP [X],0
    JG POSITIVE
    JL NEGATIVE
    MOV [Y],0
    JMP QUIT
    
  POSITIVE:
      MOV [Y],1 
      JMP QUIT
  NEGATIVE:
      MOV [Y],-1
  QUIT:
      LEA DX,Y
      MOV AH,09H
      INT 21H
        
    MOV AH,1
    INT 21H 
        
    MOV AX ,4C00H
    INT 21H
END START

ret




