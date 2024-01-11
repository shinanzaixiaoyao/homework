SSEG SEGMENT STACK
    DW 32 DUP(?)
SSEG ENDS

DSEG SEGMENT
    SCORE DB 76,82,65,43,59,99,90,69,29,49,36,100
    SNUM = $-SCORE
    RATE DB 8 DUP(0)
DSEG ENDS

CSEG SEGMENT
ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:
    MOV AX,DSEG
    MOV DS,AX    
    XOR AX,AX
            
    MOV SI,OFFSET SCORE
    PUSH SI
    MOV CX,SNUM
    MOV AL,60
    MOV BL,SNUM
    
NEXT:
    CMP AL,[SI]  
    INC SI
    JBE GETNUM 
    DEC BL 
GETNUM:
    LOOP NEXT 
          
    POP SI
    MOV AL,BL
    MOV BX,100
    MUL BX
    MOV CX,SNUM
    DIV CX 
    
    MOV CL,10
    DIV CL
    ADD AH,30H
    MOV [SI+2],AH
    XOR AH,AH    
    DIV CL
    ADD AH,30H
    MOV [SI+1],AH
    CMP AL,0
    JE DOT
    ADD AL,30H
    MOV [SI],AL
    
DOT:
    MOV BYTE PTR [SI+3],'.'
    MOV AX,DX
    MUL AX
    MOV CX,SNUM
    DIV AX
    
    MOV CL,10
    DIV CL
    ADD AH,30H
    MOV [SI+5],AH
    ADD AL,30H
    MOV [DI+4],AL
    MOV BYTE PTR [SI+6],'%'    
    
    MOV BYTE PTR [SI+7],'$'
    LEA CX,RATE
    MOV AH,09H
    INT 21H
    
    MOV AH,4CH
    INT 21H
END START
                       