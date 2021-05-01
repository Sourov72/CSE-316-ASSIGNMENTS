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
    Z DW ?

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
               
        MOV CX, 2
        
     ;READ A CHAR 
     
         
         
        
     REPEAT:
        MOV AH, 1
       INT 21H
      
        
       ;CONVERT TO DIGIT
       
       AND AX, 00FH
       PUSH AX
       
       ;TOTAL = TOTAL*10 + DIGIT
       
       MOV AX, 10
       MUL BX
       POP BX
       ADD BX, AX
       
       ;READ A CHARACTER
       
       LOOP REPEAT
       
       ;UNTIL CX
       END:
       MOV AX, BX
      
       
    EXITINPUT:
        POP DX
        POP CX
        POP BX
        
        RET
        
INPUT ENDP
        
   
 
 
 
OUTPUT PROC
    
    
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX  
    ;AX < 0?
    
    OR AX, AX
    JGE END_IFF   ;NO, > 0
    
    PUSH AX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX
    
    END_IFF:
    
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
         
        CMP Y, 1
        JE POPPING 
         
        MOV DL, 2CH
        INT 21H
        
        MOV DL, 20H
        INT 21H       
        
     POPPING: 
         
        POP DX
        POP CX
        POP BX
        POP AX
        RET
        
OUTPUT ENDP 
 
 
 
 
  
     
RECURSION PROC  
    
          
        PUSH BP
        MOV BP, SP
        
        CMP Y, 0  
        
        JG END_IF
        
        JMP RETURN
        
        END_IF:
        
            MOV AX, [BP+4]
            ADD AX, [BP+6]
            MOV Z, AX
            CALL OUTPUT
            
            DEC Y
            CMP WORD PTR[BP+4], 1
            JE FOUND_ONE
            CMP WORD PTR[BP+6], 0
            JE ONE
            JMP ELSE
            
            
        ONE:
            PUSH [BP+6]
            MOV X, 1
            PUSH X
            JMP CALLING_REC 
            
        FOUND_ONE:
            CMP WORD PTR[BP+12], 1
            JE ELSE
            JMP ONE
            
        ELSE:
            
            PUSH [BP+4]
            PUSH Z
              
        
        CALLING_REC:
            CALL RECURSION  
    
        RETURN:
            POP BP
            RET 4   
    

    
        RET
        
RECURSION ENDP
      
    
   
 
    
        

;main procedure  



MAIN PROC 
    
    
;initialize DS 

    MOV AX, @DATA
    MOV DS, AX     
       
    CALL INPUT 
    
    MOV X, 0
    MOV Y, AX 
    
    
    PUSH X
    PUSH X     
    
    LEA DX, OUTPUT1
    MOV AH, 9
    INT 21H
    
    
    
    
    CALL RECURSION
    
    
 
       

 
 
EXIT:   
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN