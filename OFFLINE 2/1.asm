.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    MSG1 DB CR, LF, 'ENTER THE NUMBERS: $'
    OUTPUT1 DB CR, LF, 'ANSWER IS: $'   
    OUTPUT2 DB 'ALL NUMBERS ARE EQUAL $' 
    X DB ?
    Y DB ?
    Z DB ?

.CODE


  
;input procedure  

INPUT PROC  
    ;print user prompt for input string
    LEA DX, MSG1
    MOV AH, 9
    INT 21H     
    
    
; input for input string
    
    MOV AH, 1
    INT 21H
    MOV X, AL 
 
    INT 21H

    
    INT 21H
    MOV Y, AL
    
    INT 21H
    
    INT 21H
    MOV Z, AL
    
    RET 
    
INPUT ENDP

;output procedure

OUTPUT PROC 
    
    
    LEA DX, OUTPUT1
    MOV AH, 9
    INT 21H
    
    RET

OUTPUT ENDP
    
       
PRINT_NUMBER PROC
    
    MOV AH, 2;  
    MOV DL, BL;
    INT 21H;
    
    RET

PRINT_NUMBER ENDP  
    
        

;main procedure  



MAIN PROC 
    
    
;initialize DS 

    MOV AX, @DATA
    MOV DS, AX     
    
    CALL INPUT;
       
    MOV AH, X
    CMP AH, Y
    JGE COMPARE_XZ
    XCHG AH, Y 
    MOV X, AH



COMPARE_XZ:

    CMP AH, Z
    JE COMPARE_XY
    JG COMPARE_YZ 
    JL OUTPUT_X
    

COMPARE_XY:

    CMP AH, Y
    JE EQUAL
    JG OUTPUT_Y
    
       
COMPARE_YZ:
    
    MOV AH, Y
    CMP AH, Z
    JGE OUTPUT_Y
    JL OUTPUT_Z


EQUAL: 
     
     
    CALL OUTPUT 
     
    LEA DX, OUTPUT2
    MOV AH, 9
    INT 21H


    JMP EXIT           
OUTPUT_X: 
    
    
    CALL OUTPUT
    MOV BL, X;
    CALL PRINT_NUMBER  
        
    JMP EXIT

OUTPUT_Y: 
    
    CALL OUTPUT
    MOV BL, Y;
    CALL PRINT_NUMBER

    JMP EXIT 
    
OUTPUT_Z:

    CALL OUTPUT 
    
   MOV BL, Z;
   CALL PRINT_NUMBER    
 
EXIT:   
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN