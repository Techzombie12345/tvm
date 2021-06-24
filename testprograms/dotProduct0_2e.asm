; contributed by Texedo
; dot product function v0.2(experimental)
; float dot( vec4 * vector1, vec4 * vector2 )

; input params
; ra = vec4 pointer, v0
; rb = vec4 pointer, v1

; returns the dot product as a float, by way of
; ra being the signed mantissa
; rb being the signed exponent

; rd = return stack

; types:
; float
; two 16 bit signed components:
;      mantissa,   exponent
; byte 0x00, 0x00, 0x00, 0x00
;
; vec4 ( four component( floats ) vector )
; X    mantissa,   exponent
; byte 0x00, 0x00, 0x00, 0x00
; Y
; byte 0x00, 0x00, 0x00, 0x00
; Z
; byte 0x00, 0x00, 0x00, 0x00
; W
; byte 0x00, 0x00, 0x00, 0x00

; ra = Lo and dest operand, rb = Hi

dot:
  ; set up localStack
  mov re,rd
  mov dotLocalStack,re
  pushw r0 ; v0 iterator
  pushw r1 ; v1 iterator
  pushw r2 ; source op
  pushw r3 ; prod iterator
  pushw r4 ; int i ( loop iterator )
  ; reassigned input params away from ra and rb
  mov ra,r0
  mov rb,r1
  ; set prod iterator
  mov componentProduct,r3
  ; clear i
  xor r4,r4,r4

  ; multiply mantissas, assign Hi and Lo to ra and rb
dotLoop1:
  loadw r0,r2
  loadw r1,ra
  mov componentProduct,r3
  xor rb,rb,rb
  imul r2,ra,rb,ra
  call overflow
  ; don't forget: unconditionally add rb to product exponent
  storew ra,r3 ; store mantissa
  add 2,r0,r0 ; v0[i].exponent
  add 2,r1,r1 ; v1[i].exponent
  add 2,r3,r3 ; product[i].exponent
  loadw r0,r2 ; source
  loadw r1,ra ; destination
  add r2,rb,r2 ; in case of overflow
  add r2,ra,ra
  storew ra,r3
  ; product[i] is ready, cycle for next loop, or add products
  add 2,r0,r0 ; v0[i+1].mantissa
  add 2,r1,r1 ; v1[i+1].mantissa
  add 2,r3,r3 ; product[i+1].mantissa
  add 1,r4,r4 ; i++
  ; loop 4 times
  ifl r4,4
  mov dotLoop1,rf

  ; TODO: write overflow function and finish dotLoop2

dotLoop2:
  ; add products together for return value

; .data

  byte 0x00, 0x00, 0x00, 0x00
  byte 0x00, 0x00, 0x00, 0x00
  byte 0x00, 0x00, 0x00, 0x00
  byte 0x00, 0x00, 0x00, 0x00
dotLocalStack:

componentProduct:
;      mantissa,   exponent
  byte 0x00, 0x00, 0x00, 0x00
  byte 0x00, 0x00, 0x00, 0x00
  byte 0x00, 0x00, 0x00, 0x00
  byte 0x00, 0x00, 0x00, 0x00
