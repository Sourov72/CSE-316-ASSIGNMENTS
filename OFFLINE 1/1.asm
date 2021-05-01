.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH

    MSG1 DB CR, LF, 'ENTER X: $'
    MSG2 DB CR, LF, 'ENTER Y: $'
    OUTPUT1 DB CR, LF, 'OUTPUT Z(X-2Y): $'  
    OUTPUT2 DB CR, LF, 'OUTPUT Z((25-(X+Y)): $'
    OUTPUT3 DB CR, LF, 'OUTPUT Z(2X-3Y): $'
    OUTPUT4 DB CR, LF, 'OUTPUT Z(Y-X+1): $'
    X DB ?
    Y DB ?
    Z DB ?

.CODE   
  
;input procedure  

INPUT PROC  
    ;print user prompt for x
    LEA DX, MSG1
    MOV AH, 9
    INT 21H     
    

;input for x
    
    MOV AH, 1
    INT 21H
    MOV X, AL;
    SUB X, 30H; 
    
    
;print user prompt for y
    LEA DX, MSG2
    MOV AH, 9
    INT 21H     
    

;input for y
    
    MOV AH, 1
    INT 21H
    MOV Y, AL;
    SUB Y, 30H;
    
    RET 
    
INPUT ENDP

;output procedure

OUTPUT PROC
             
    ADD Z, 30H       
    MOV AH, 2;  
    MOV DL, Z;
    INT 21H; 
    
    RET

OUTPUT ENDP
    
       
    

;main procedure  



MAIN PROC 
    
    
;initialize DS 

    MOV AX, @DATA
    MOV DS, AX    
    
;1.X-2Y operation    
    
    CALL INPUT

    MOV AH, X;
    SUB AH, Y;
    SUB AH, Y;
    MOV Z, AH; STORING VALUE IN Z
           
    LEA DX, OUTPUT1
    MOV AH, 9
    INT 21H  
    
    CALL OUTPUT 
        

;2.25-(X+Y) OPERATION
    
    MOV AH, 25
    SUB AH, X
    SUB AH, Y
    MOV Z, AH; STORING VALUE IN Z 
    
    LEA DX, OUTPUT2
    MOV AH, 9
    INT 21H   
    
    CALL OUTPUT
       

;3.2X-3Y OPERATION
         
    MOV AH, X
    ADD AH, X
    SUB AH, Y
    SUB AH, Y
    SUB AH, Y
    MOV Z, AH; STORING VALUE IN Z
   
       
    LEA DX, OUTPUT3
    MOV AH, 9
    INT 21H   
    
    CALL OUTPUT
    
      
;4.Y-X+1 OPERATION  
    
    MOV AH, Y
    SUB AH, X
    ADD AH, 1
    MOV Z, AH; STORING VALUE IN Z     
      
    LEA DX, OUTPUT4
    MOV AH, 9
    INT 21H   
    
    CALL OUTPUT
    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN