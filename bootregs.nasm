;******************************************************************************
;
; bootregs
;
; Write the values of a machine's registers at bootup. Some of the registers
; are significant, others are unimportant. This code makes a bootsector.
;
;******************************************************************************

;
;
;Build with
;
;  nasm -f bin bootregs.nasm -l bootregs.lst
;
;Write to a floppy with
;
;  (Windows)    dd bs=512 count=1 if=bootregs of=\\.\a:
;  (Unix)  sudo dd bs=512 count=1 if=bootregs of=
;
;where for Unix you supply the disk device (/dev/something) after
; the of= argument.
;

cpu 8086
bits 16
org 0x7c00

;Set the hexadecimal letter case
;  For upper case use 7
;  For lower case use 7 + 32
hex_case:    equ    7        ;See preceding comment


;******************************************************************************
;
; Set up environment
;
;******************************************************************************

  push ds
  pushf
;Note that the pushes above must match the pops in the code below

  xor ax, ax
  mov ds, ax


;******************************************************************************
;
; Report incoming flags
;
;******************************************************************************

  mov si, msg_flags
  call write_string
  pop ax ;Fetch the incoming flags
  call write_binary_ax

  mov si, msg_flags_ids
  call write_string


;******************************************************************************
;
; Report start address
;
;******************************************************************************

report_start_address:
  mov si, msg_cs
  call write_string
  mov ax, cs
  call write_hex_ax

  mov si, msg_ip
  call write_string
  call .next
.next:
  pop ax
  sub ax, .next - $$
  call write_hex_ax


;******************************************************************************
;
; Report initial stack
;
;******************************************************************************

  mov si, msg_ss
  call write_string
  mov ax, ss
  call write_hex_ax

  mov si, msg_sp
  call write_string
  mov ax, sp

;DS is still on the stack. Allow for it
  add ax, 2

  call write_hex_ax


;******************************************************************************
;
; Report other segment registers
;
;******************************************************************************

  mov si, msg_ds
  call write_string
  pop ax ;Initial ds
  call write_hex_ax

  mov si, msg_es
  call write_string
  mov ax, es
  call write_hex_ax


;******************************************************************************
;
; Report other info
;
;******************************************************************************

  mov si, msg_dx
  call write_string
  mov ax, dx
  call write_hex_ax


;******************************************************************************
;
; Halt
;
;******************************************************************************

halt_loop:
    ;halt the system
    hlt
    jmp halt_loop


;******************************************************************************
;
; Utility routines
;
;******************************************************************************

write_string:        ;;writes string on the screen
  push ax
  push si
  jmp short .test

.each_char:
  call write_al

.test:
  lodsb ;(mov al, [si]; inc si)
  test al, al
  jnz .each_char
  pop si
  pop ax
  ret

write_space:
  push ax
  mov al, " "
  call write_al
  pop ax
  ret

write_colon:
  push ax
  mov al, ":"
  call write_al
  pop ax
  ret

write_underscore:
  push ax
  mov al, "_"
  call write_al
  pop ax
  ret

write_al:
  push ax
  push bx
  mov ah, 0x0e
  mov bx, 0x0007 ;Paper and ink colours if graphics console
  int 0x10
  pop bx
  pop ax
  ret

write_binary_ax:
  push ax
  mov al, ah
  call write_binary_al
  call write_underscore
  pop ax
  jmp short write_binary_al

write_binary_al:
  push ax
  push cx
  mov cl, 4
  shr al, cl
  call write_binary_nibble_al
  call write_underscore
  pop cx
  pop ax
  jmp short write_binary_nibble_al

write_binary_nibble_al:
  push ax
  push cx
  mov cl, 3
  ror al, cl
  mov cl, 4

.each_bit:
  push ax
  and al, 1
  add al, "0"
  call write_al
  pop ax
  rol al, 1
  loop .each_bit

  pop cx
  pop ax
  ret

write_hex_ax:
  push ax
  mov al, ah
  call write_hex_al
  pop ax
  jmp short write_hex_al
 
write_hex_al:
  push ax ;Save both digits of AL
  push cx
  mov cl, 4
  shr al, cl
  pop cx
  call make_hex_printable_al
  call write_al
  pop ax
  push ax ;Save it for return
  call make_hex_printable_al
  call write_al
  pop ax
  ret
 
make_hex_printable_al:
  and al, 0xf
  cmp al, 9
  jle .rawval
  add al, hex_case
 
.rawval:
  add al, "0"
  ret
 

;******************************************************************************
;
; Data
;
;******************************************************************************

msg_flags:         db 13,10,"Flags: ",0
msg_flags_ids:     db 13,10,"       0NLL VDIT SZ0A 0P1C",0
msg_ds:            db 13,10,"DS: ",0
msg_es:            db 13,10,"ES: ",0
msg_cs:            db 13,10,"CS: ",0
msg_ip:            db " IP: ",0
msg_ss:            db 13,10,"SS: ",0
msg_sp:            db " SP: ",0
msg_dx:            db 13,10,"DX: ",0

 
times 510-($-$$) db 0x00 
db    0x55, 0xaa
