.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    MSG1 DB CR, LF, 'ENTER THE PASSWORD: $'
      
    OUTPUT1 DB CR, LF, 'VALID PASSWORD $' 
    OUTPUT2 DB CR, LF, 'INVALID PASSWORD $'
    I DB ? 
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
 
    ;INT 21H
    ;INT 21H
    
    INT 21H
    MOV Y, AL
    
    ;INT 21H
    ;INT 21H
    
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
    
       
VALIDITY PROC
    
    CMP X, 0
    JE INPUT_LOOP 
    CMP Y, 0
    JE INPUT_LOOP
    CMP Z, 0
    JE INPUT_LOOP 
    
    LEA DX, OUTPUT1  
    JMP INPUT_LOOP
    
   

VALIDITY ENDP  
    
        

;main procedure  



MAIN PROC 
    
    
;initialize DS 

    MOV AX, @DATA
    MOV DS, AX     
       
    MOV X, 0
    MOV Y, 0
    MOV Z, 0
    
    LEA DX, OUTPUT2
    
    MOV AH, 1
    MOV CX, 1 
  
    
    INPUT_LOOP:
    
        INT 21H 
        MOV I, AL 
        CMP I, 21H
        JL PRINT
        CMP I, 7EH
        JG PRINT
        CMP I, 39H
        JLE FOR_DIGIT
        CMP I, 5AH
        JLE FOR_CAPITAL
        CMP I, 7AH
        JLE FOR_SMALL
          
    
    FOR_DIGIT: 
        
        CMP I, 30H
        JL INPUT_LOOP
        MOV X, 1
        CALL VALIDITY

    
    
    FOR_CAPITAL:
    
        CMP I, 41H
        JL INPUT_LOOP
        MOV Y, 1 
        CALL VALIDITY
    
    
    FOR_SMALL:
    
        CMP I, 61H
        JL INPUT_LOOP
        MOV Z, 1
        CALL VALIDITY
        


PRINT:
 
    MOV AH, 09H
    INT 21H         

 
 
EXIT:   
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN