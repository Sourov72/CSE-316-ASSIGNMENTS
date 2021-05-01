.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A UPPER CASE LETTER: $'
    MSG2 DB CR, LF, 'ITS PREVIOUS LOWER CASE LETTER IT IS: $' 
    MSG3 DB CR, LF, 'ITS 1S COMPLEMENT IS: $'
    CHAR DB ?
    LCHAR DB ?

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;input a upper case character and convert it to lower case     
    MOV AH, 1
    INT 21H
    MOV CHAR, AL
    ADD AL, 31
    MOV LCHAR, AL
    
;display the lower case character 
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    
 
    MOV AH, 2
    MOV DL, LCHAR
    INT 21H
    
       
;display the 1's complement of the letter
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  
    
      
    MOV AH, CHAR
    NOT AH
    MOV CHAR, AH 
      
   
    MOV AH, 2
    MOV DL, CHAR
    INT 21H    
    
    
    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN