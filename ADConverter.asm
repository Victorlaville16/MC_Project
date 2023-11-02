#include<p18F4550.inc>
    
RES_VECT CODE 0x0000
 goto prog_init
    
org 0x0008 ; interrupt vector
  goto irq_handle
 
MAIN_PROG CODE
    
prog_init ; initialize the code
    ; --- DDDDDDDA - only RA0 Analog
    movlw B'00001010'
    movwf ADCON1
    ; --- enable AD interrupts
    bsf PIE1, ADIE
    bsf INTCON, GIE
    bsf INTCON, PEIE
    clrf PIR1, ADIF
    
    setf TRISA ; PORTA is an input
    
    ;Select channel 0 AN0, Set ADON bit to enable A/D converter
    movlw B'00010001'
    movwf ADCON0
    
    ;ADFM=1 -> result is right justified
    movlw B'00000000'
    movwf ADCON2
    
    ; initialize PORTC
    clrf TRISB ; PORTC is an output
    clrf PORTB ; clear PORTC 
    clrf PORTA
    
    goto start_AD
    
    ; --- IRQ routine
irq_handle
    btfsc PIR1, ADIF ; is it AD?
    goto AD_interrupt ; yes
    retfie ; no, return f.i.
    
AD_interrupt
    bcf PIR1, ADIF ; clear the flag
    ; A/D result goes into PORTC
    movff ADRESH, PORTB
    retfie
     
    
; --- Main loop
start_AD
    ; start the A/D conversion
    bsf ADCON0, GO_DONE
    goto start_AD
end 
    





