.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    MSG1 DB  'ENTER THE FIRST MATRIX: $'
    MSG2 DB CR, LF, 'ENTER THE SECOND MATRIX; $'
      
    OUTPUT1 DB CR, LF, 'RESULT IS: $' 
   
    
    X DW ?
    Y DW ? 
    
    
    FIRST_MATRIX DB 2 DUP (?)
                 DB 2 DUP (?)  
                 
    SECOND_MATRIX DB 2 DUP (?) 
                  DB 2 DUP (?) 
   

.CODE 

 ;INPUT PROCEDURE
 
INPUT PROC 
    
    
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV AH, 2
    MOV DL, 10D
    INT 21H
    MOV DL, 13D 
    INT 21H
    
    
    
    MOV BL, 4
    
    REPEAT:
            
        MOV AH, 1
        INT 21H     
        CMP BL, 0
        JE EXIT_INPUT: 
        
        
        AND AL, 0FH
        MOV [SI], AL;
        INC SI; 
        DEC BL
        CMP BL, 2
        JE NEW_LINE
        
        CMP BL, 0
        JE EXIT_INPUT 
        
        INT 21H
    
       
        
        JMP REPEAT 
    
    NEW_LINE:
    
        
        MOV AH, 2
        MOV DL, 10D
        INT 21H
        MOV DL, 13D 
        INT 21H
        JMP REPEAT
       
    EXIT_INPUT: 
    
        
        POP SI
        POP DX
        POP CX 
        POP BX
        RET 
        

       
INPUT ENDP    


    
 
 ;OUTPUT PROCEDURE
 
OUTPUT PROC



    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    OR AX, AX  
    

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
        
        MOV DL, 20H
        INT 21H      
        
         
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
    
    
    LEA DX, MSG1
    MOV AH, 9
    INT 21H 
    
    LEA SI, FIRST_MATRIX 
    CALL INPUT
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    LEA SI, SECOND_MATRIX
    
    CALL INPUT
    
    
    
    MOV CX, 4
    XOR SI, SI
    
     
    
      
    LEA DX, OUTPUT1
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    MOV DL, 10
    INT 21H
    
    MOV AH, 2
    MOV DL, 13
    INT 21H
    
      
      
   
    
   
      
    XOR SI, SI
    MOV CX, 4 
    SUM: 
                            
        
        MOV DL, FIRST_MATRIX[SI] 
        ADD DL, SECOND_MATRIX[SI]
        MOV FIRST_MATRIX[SI], DL 
        
        ADD SI, 1
        LOOP SUM
        
       
        
    XOR SI, SI
    MOV CX, 4  
    
    
    PRINT:
         
         MOV AL, FIRST_MATRIX[SI] 
         AND AX, 0FFH
         CALL OUTPUT
         ADD SI, 1
         
         CMP SI, 2
         JE NEWLINEE
         CMP SI, 4
         JE EXIT
         
         
         LOOP PRINT  
         
         NEWLINEE: 
         
            MOV AH, 2
            MOV DL, 10D
            INT 21H
            MOV DL, 13D 
            INT 21H
            LOOP PRINT
            
         
         
    

 
 
EXIT:   
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
