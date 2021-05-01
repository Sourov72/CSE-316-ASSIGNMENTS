.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    MSG1 DB CR, LF, 'ENTER THE DIGITS: $' 
    MSG2 DB CR, LF, 'ENTER THE SYMBOL; $'
    
      
    OUTPUT1 DB CR, LF, 'RESULT IS: $' 
    OUTPUT2 DB CR, LF, 'WRONG OPERATOR $' 
   
    
    X DW ?
    Y DW ? 
    SIGN DB ?

.CODE

 
  
;input procedure  

INPUT PROC  
    ;print user prompt for input string
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
; input for input string  

    PUSH BX
    PUSH CX
    PUSH DX
    BEGIN:

;TOTAL = 0
        
        XOR BX, BX
     
     ;NEGATIVE
               
        XOR CX, CX
        
     ;READ A CHAR 
     
         MOV AH, 1
         INT 21H
         
     ;MINUS CHAR?
     
        CMP AL, '-'
        JE MINUS
        JMP REPEAT
 
     MINUS:
        MOV CX, 1 
     
        INT 21H
        
     REPEAT:
     
         
        
        CMP AL, '0'
        JNGE NOTDIGIT
        CMP AL, '9'
        JNLE NOTDIGIT
        
       ;CONVERT TO DIGIT
       
       AND AX, 00FH
       PUSH AX
       
       ;TOTAL = TOTAL*10 + DIGIT
       
       MOV AX, 10
       MUL BX
       POP BX
       ADD BX, AX
       
       ;READ A CHARACTER
       
       MOV AH, 1
       INT 21H
       CMP AL, 0DH
       JNE REPEAT
       ;UNTIL CR
       END:
       MOV AX, BX
       
       ;IF NEGATIVE
       OR CX, CX    
       
       JE EXITINPUT ;NO, EXIT
       
       NEG AX
       
    EXITINPUT:
        POP DX
        POP CX
        POP BX
        
        RET
         
    NOTDIGIT:
        MOV AH, 1
        INT 21H
        CMP AL, 0DH
        JNE REPEAT
        JMP END
        
INPUT ENDP
        
   
  
     
OUTPUT PROC
    
    
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX  
    ;AX < 0?
    
    OR AX, AX
    JGE END_IF   ;NO, > 0
    
    PUSH AX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX
    
    END_IF:
    
        XOR CX, CX ;COUNT DIGITS
        MOV BX, 10D ;DIVISOR
        
    REPEAT2:
    
        XOR DX, DX ;PREPARE HIGH WORD OF DIVIDEND
        DIV BX      ; AX = QUOTIENT, DX = REMAINDER
        PUSH DX     ;SAVE REMAINDER ON STACK
        INC CX      ;COUNT++
        
        OR AX, AX ;QUOTIENT = 0?
        JNE REPEAT2 ;NO, KEEP DOING
        
        ;CONVERT DIGITS TO CHAR AND PRINT
        
        MOV AH, 2; PRINT CHAR FUNCTION
        
        
        
    PRINT_LOOP:
    
        POP DX ;DIGIT IN DL
        OR DL, 30H   ;CONVERT TO CHAR
        INT 21H
        LOOP PRINT_LOOP       
        
         
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        
OUTPUT ENDP
      
    
   
 
    
        

;main procedure  



MAIN PROC 
    
    
;initialize DS 

    MOV AX, @DATA
    MOV DS, AX     
       
    CALL INPUT 
    
    MOV X, AX  
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H  
    
    MOV SIGN, AL
    
    CMP SIGN, 'q'
        JE EXIT
        
    CMP SIGN, '+'
        JE SECOND
    CMP SIGN, '-'
        JE SECOND
     CMP SIGN, '*'
        JE SECOND
    CMP SIGN, '/'
        JE SECOND
        
    LEA DX, OUTPUT2
    MOV AH, 9
    INT 21H
    JMP EXIT    
        
    SECOND: 
    
    CALL INPUT
    
    MOV Y, AX 
    
    LEA DX, OUTPUT1
    MOV AH, 9
    INT 21H
    
    
    MOV AX, X
    MOV BX, Y 
    
   
    CMP SIGN, '+'
        JE PLUS
    CMP SIGN, '-'
        JE SUBSTRACT
     CMP SIGN, '*'
        JE MULTIPLY
    CMP SIGN, '/'
        JE DIVIDE 
        
    
        
        
    
         
         
    PLUS: 
    
        ADD AX, BX
        JMP RESULT 
        
    SUBSTRACT:
        
        SUB AX, BX
        JMP RESULT
        
    MULTIPLY:
    
        IMUL BX
        JMP RESULT
        
    DIVIDE: 
    
        XOR DX, DX 
        CWD
        IDIV BX
          
        JMP RESULT
        
    
    RESULT:
    CALL OUTPUT
 
       

 
 
EXIT:   
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN