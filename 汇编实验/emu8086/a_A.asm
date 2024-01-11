SSEG SEGMENT STACK
    DW 32 DUP(?)
SSEG ENDS

DSEG SEGMENT
    BUF DB 50,?,50 DUP(?)    
DSEG ENDS

CSEG SEGMENT
ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:
    MOV AX,DSEG
    MOV DS,AX 
    LEA DX,BUF
    
    MOV AH,0AH
    INT 21H
    
    LEA SI,BUF+2
    MOV CL,BUF+1
    MOV CH,0

LTOU:
    MOV AL,[SI]
    CMP AL,61H
    JB NEXT
    CMP AL,7AH
    JA NEXT
    SUB AL,20H
    MOV [SI],AL

NEXT:
    INC SI
    LOOP LTOU  
    
    MOV BYTE PTR [SI],'$'
    MOV AH,02H
    MOV DL,0AH
    INT 21H
    MOV AH,09H
    LEA DX,BUF+2
    INT 21H
    MOV AH,4CH
    INT 21H
CSEG ENDS
END START
    