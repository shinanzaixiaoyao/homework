SSEG SEGMENT STACK
    DB 32 DUP(0)
SSEG ENDS

DSEG SEGMENT
    X DW 1235
    OE DB 0
DSEG ENDS

CSEG SEGMENT
ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:
    MOV AX,DSEG
    MOV DS,AX
    XOR AX,AX
    
    TEST X,0001H
    JZ EVEN
    MOV OE,1
    JMP OK

EVEN:
    MOV OE,0
    
OK:
    MOV AH,4CH
    INT 21H
CSEG ENDS
END START