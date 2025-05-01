[org 0x100]
jmp start
count: dd 0
check_death: db 0
num: dw 260
w_key: db 'w'
s_key: db 's'
a_key: db 'a'
d_key: db 'd'
e_key: db 'e'
p_key: db 'p'
curr_move: db 0
game_over_msg: db 'GAME 0VER'
score_msg: db 'SCORE'
; score_msg1: db 'SCORE'    
is_eat: db 0
score: dw 0
snake_heading: db "SNAKE GAME",0
name1: db "Ali Haider :  22F-8803 ",0
name2: db "Rafay Adeel:  22F-3327 ",0    
;press_s: db "Press 'S' to START",0
instruction1: db "W -> UP", 0
instruction2: db "A -> Left", 0
instruction6: db "S -> Down",0
instruction7: db "D -> Right",0           
instruction0: db "||--- GAME  CONTROLS ---||", 0
instruction3: db "GAME INSTRUCTIONS ", 0
instruction4: db " I. Game will over if snake collides with the boundary", 0
instruction5: db "II. Game will over if snake collides with itself", 0
food_color: db 1
inputname: db '               ',0
entername: db 'Enter the Name:',0


;--------------> SCREEN CLEARING SUBROUTINE
clrscr:    
    push ax
    push es
    push di
    mov ax, 0xb800
    mov es, ax
    mov di, 0
clr:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne clr
    pop di
    pop es
    pop ax
    ret



;--------------> STRING PRINTING SUBROUTINE
printstr:
push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds
pop es ; load ds in es
mov di, [bp+4] ; point di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load a zero in al
repne scasb ; find zero in the string
mov ax, 0xffff ; load maximum number in ax
sub ax, cx ; find change in cx
dec ax ; exclude null from length
jz exit ; no printing if string is empty
mov cx, ax ; load string length in cx
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+8] ; multiply with y position
add ax, [bp+10] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
mov si, [bp+4] ; point si to string
mov ah, [bp+6] ; load attribute in ah
cld ; auto increment mode
nextchar: lodsb ; load next char in al
stosw ; print char/attribute pair
loop nextchar ; repeat for the whole string
exit: pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8


;--------------> BANNER PRINTING SUBROUTINE
print_banner:
    push 30                      ;X value
    push 6                       ;Y value
    mov ax, 0x04                 ;Attribute
    push ax
    mov ax, instruction0
    push ax
    call printstr

    push 39
    push 8
    mov ax, 0x01
    push ax
    mov ax, instruction1
    push ax
    call printstr

    push 39
    push 10
    mov ax, 0x01
    push ax
    mov ax, instruction2
    push ax
    call printstr

    push 39
    push 12
    mov ax, 0x01
    push ax
    mov ax, instruction6
    push ax
    call printstr

    push 39
    push 14
    mov ax, 0x01
    push ax
    mov ax, instruction7
    push ax
    call printstr

    push 35
    push 17
    mov ax, 0x04
    push ax
    mov ax, instruction3
    push ax
    call printstr

    push 16
    push 19
    mov ax, 0x01
    push ax
    mov ax, instruction4
    push ax
    call printstr

    push 16
    push 20
    mov ax, 0x01
    push ax
    mov ax, instruction5
    push ax
    call printstr

    mov cx, 40
    looping_delay_banner:
    call delay
    loop looping_delay_banner

    call clrscr
    push 35
    push 5
    mov ax, 0x04
    push ax
    mov ax, snake_heading
    push ax
    call printstr

    push 30
    push 10
    mov ax, 0x01
    push ax
    mov ax, name1
    push ax
    call printstr

    push 30
    push 12
    mov ax, 0x01
    push ax
    mov ax, name2
    push ax
    call printstr


;--------------> EATING SUBROUTINE
eat:
push bp
mov bp, sp
sub sp, 2
push ax
push bx
push cx
push dx
push si

mov si, pos
mov ax, word[len]
dec ax
shl ax, 1
add si, ax  ;calculating the head position of snake
mov ax, word[num]
mov word[bp-2], ax
cmp [si], ax
jne no_eat


call delay

mov ax, word[num]
mov word[space], ax
call print_space
call print_food

inc word[len]
inc word[score]
add si, 2

mov ax, word[bp-2]
mov word[si], ax
no_eat:

call print_scr
pop si
pop dx
pop cx
pop bx
pop ax

mov sp, bp
pop bp
ret


;--------------> KEYBOARD INTTERUPT SUBROUTINE
snake_int:
    push ax

    xor ax, ax
    mov ah, 0x01 
    int 0x16 ; call BIOS keyboard service
    jz no_int
	call movement
    no_int:

    pop ax
    ret


;--------------> RANDOM NUMBER SUBROUTINE
rand_no:
    push ax
    push dx
    push cx

    rdtsc
    xor dx, dx
    mov cx, 3998
    div cx
    mov word[num], dx

    pop cx
    pop dx
    pop ax
    ret


;--------------> DELAY SUBROUTINE
delay: 
    mov dword[count], 120000
looping_delay:
	dec dword[count]
	cmp dword[count], 0
	jne looping_delay
    ret

;--------------> RANDOM FOOD GENERATING SUBROUTINE
print_food:
push ax
push es
push di
push cx
mov ax, 0xb800
mov es, ax
call rand_no
test word[num], 1
jz ok
dec word[num]
ok:
call checking_food
mov ax, word[num]
mov di, ax
cmp byte[food_color], 10
jne skip_color
mov byte[food_color], 1
skip_color:
inc byte[food_color]
mov ah, byte[food_color]
mov al, 0x6F
mov word[es:di], ax

pop cx
pop di
pop es
pop ax
ret

;--------------> Y-AXIS BORDER PRINTING SUBROUTINE
border_y:                         
    push bp
    mov bp, sp
    push ax
    push cx
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 25
looping_border_y:
    mov word [es:di], 0x1004
    add di, 160
    loop looping_border_y

    pop di
    pop es
    pop cx
    pop ax
    pop bp
    ret 2


;--------------> X-AXIS BORDER PRINTING SUBROUTINE
border_x:                         
    push bp
    mov bp, sp
    push ax
    push cx
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 80
looping_border_x: 
    mov word [es:di], 0x1004
    add di, 2
    loop looping_border_x

    pop di
    pop es
    pop cx
    pop ax
    pop bp
    ret 2


;--------------> ALL BORDER PRINTING AND CLEARING SCREEN (INITIALIZING GAME) SUBROUTINE
load_border:
push ax

call clrscr


push 0
call border_y
push 158
call border_y
push 0
call border_x

    mov si, inputname
    mov ax, 0xb800
    mov es, ax
    mov di,70
    mov cx,15
    mov ah, 0x04
    user_name:
    mov byte al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    loop user_name

push 3840
call border_x

pop ax
ret


;--------------> SNAKE PRINTING SUBROUTINE
print_snake:
    push ax
    push es
    push di
    push cx 
    push bx

    mov ax, 0xb800
    mov es, ax
    mov bx, pos
    mov cx, word[len]
    dec cx
looping_snake:  ;snake body printing 
    mov di, [bx]
    mov word[es:di], 0x0A2A   
    add bx, 2  
    loop looping_snake
    mov di, [bx]    ;snake head printing
    mov word[es:di], 0x029A

    pop bx
    pop cx
    pop di
    pop es
    pop ax
    ret


;--------------> SPACE PRINTING SUBROUTINE
print_space:
    push ax
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov word di, [space]
    mov word [es:di], 0x0720

    pop di
    pop es
    pop ax
    ret


;--------------> RIGHT SHIFTING SUBROUTINE
right_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_right:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_right
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    add word[bx], 2

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> LEFT SHIFTING SUBROUTINE
left_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_left:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_left
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    sub word[bx], 2

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> DOWN SHIFTING SUBROUTINE
down_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_down:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_down
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    add word[bx], 160

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> UP SHIFTING SUBROUTINE
up_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_up:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_up
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    sub word[bx], 160

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> BORDER DEATH CHECKING SUBROUTINE
check_border:
    push ax
    push cx
    push dx
    push si
    push bx

    mov cx, word[len]
    dec cx
    shl cx, 1
    mov bx, pos
    add bx, cx
    mov ax, [bx]
    mov cx, 0
check_left:                        ;LEFT SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 160
    cmp cx, 3840
    jne check_left

    mov cx, 158
check_right:                       ;RIGHT SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 160
    cmp cx, 3998
    jne check_right

    mov cx, 0
check_up:                          ;TOP SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 2
    cmp cx, 158
    jne check_up

    mov cx, 3840
check_down:                        ;BOTTOM SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 2
    cmp cx, 3998
    jne check_down

    jmp skip_checking
found:                             ;IF SNAKE TOUCHES BORDER, COME TO "found" AND EXIT
    mov byte[check_death], 1
skip_checking:

    pop bx                           ;IF NOT TOUCH BORDER, LEAVE THE LOOP AS IT IS
    pop si
    pop dx
    pop cx
    pop ax
    ret


;--------------> BORDER FOOD CHECKING SUBROUTINE
checking_food:
    push ax
    push cx

    mov ax, word[num]
    mov cx, 0
checking_left:                        ;LEFT SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 160
    cmp cx, 3840
    jne checking_left

    mov cx, 158
checking_right:                       ;RIGHT SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 160
    cmp cx, 3998
    jne checking_right

    mov cx, 0
checking_up:                          ;TOP SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 2
    cmp cx, 158
    jne checking_up

    mov cx, 3840
checking_down:                        ;BOTTOM SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 2
    cmp cx, 3998
    jne checking_down

    jmp skip_check
founded:                             ;IF SNAKE TOUCHES BORDER, COME TO "found" AND EXIT
    call print_food
skip_check:

    pop cx
    pop ax
    ret


;--------------> LEFT MOVEMENT SUBROUTINE
move_left:
push ax

mov byte[curr_move], 2
looping_left_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_left
call print_snake
call left_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
jmp looping_left_move

death_left:
call game_over
pop ax
ret


;--------------> RIGHT MOVEMENT SUBROUTINE
move_right:
mov byte[curr_move], 1
push cx
push ax

looping_right_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_right
call print_snake
call right_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
jmp looping_right_move
death_right:
call game_over
pop ax
pop cx
ret


;--------------> UP MOVEMENT SUBROUTINE
move_up:
push ax

mov byte[curr_move], 3
looping_up_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_up
call print_snake
call up_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
call delay
jmp looping_up_move
death_up:
call game_over
pop ax
pop cx
ret


;--------------> DOWN MOVEMENT SUBROUTINE
move_down:
push ax

mov byte[curr_move], 4
looping_down_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_down
call print_snake
call down_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
call delay
jmp looping_down_move
death_down:
call game_over
pop ax
ret


;--------------> PAUSE SUBROUTINE
pausing:
looping_pausing:
call snake_int
jmp looping_pausing

ret


;--------------> OVERALL MOVEMENT CONTROLLER
movement:
    push ax
    xor ah, ah
    int 0x16

    cmp al, [a_key]
	jne skip1
    cmp byte[curr_move], 1
    jne move_left
    skip1:
	cmp al, [d_key]
	jne skip2
    cmp byte[curr_move], 2
    jne move_right
    skip2:
	cmp al, [w_key]
	jne skip3
    cmp byte[curr_move], 4
    jne move_up
    skip3:
	cmp al, [s_key]
	jne skip4
    cmp byte[curr_move], 3
    jne move_down
    skip4:
    cmp al, [e_key]
    jne skip5
    call game_over
    skip5:
    cmp al, [p_key]
    jne skip6
    call pausing
    skip6:

    pop ax
    ret


;--------------> SCORE PRINTING SUBROUTINE after end of game 
print_score:
; subroutine to print a score at top left of screen
; takes the number to be printed as its parameter
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, word[score] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 2324 ; point di to top left column
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x0E ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
ret 
;---------------> print only number on top right screen

print_score1:
    ; subroutine to print a score at top right of screen
    ; takes the number to be printed as its parameter
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov ax, word[score] ; load number in ax
    mov bx, 10 ; use base 10 for division
    mov cx, 0 ; initialize count of digits
    nextdigit1: mov dx, 0 ; zero upper half of dividend
    div bx ; divide by 10
    add dl, 0x30 ; convert digit into ascii value
    push dx ; save ascii value on stack
    inc cx ; increment count of values
    cmp ax, 0 ; is the quotient zero
    jnz nextdigit1 ; if no divide it again
    mov di, 146 ; point di to top left column
    nextpos1: pop dx ; remove a digit from the stack
    mov dh, 0x0E ; use normal attribute
    mov [es:di], dx ; print char on screen
    add di, 2 ; move to next screen location
    loop nextpos1 ; repeat for all digits on stack
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    ret 

;---------------> print score complete message at top right
    print_scr:
    push ax
    push es
    push di
    push cx
    push si
    mov si, score_msg
    mov ax, 0xb800
    mov es, ax
    mov di, 134
    mov cx, 6
    mov ah, 0x04
    looping_score1:                      
    mov byte al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    loop looping_score1
    call print_score1
    pop si
    pop cx
    pop di
    pop es
    pop ax
    ret

;--------------> SELF-COLLISION DEATH CHECK SUBROUTINE
self_collision:
push bx
push ax
push cx

mov bx, pos
mov ax, word[len]
dec ax
shl ax, 1
add bx, ax
mov ax, word[bx]
mov bx, pos
mov cx, word[len]
sub cx, 2
looping_self:
cmp [bx], ax
jne skip_self
call game_over
skip_self:
add bx, 2
dec cx
jnz looping_self

pop cx
pop ax
pop bx
ret

    
;--------------> GAME OVER SUBROUTINE
game_over:
    call clrscr
    mov ax, 0xb800
    mov es, ax
    mov si, game_over_msg
    mov di, 1990
    mov cx, 9
    mov ah, 0x0E
    looping_game_over:
    mov byte al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    loop looping_game_over
    mov si, score_msg
    mov ax, 0xb800
    mov es, ax
    mov di, 2312
    mov cx, 5
    mov ah, 0x0E
    looping_score:                      ;
    mov byte al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    loop looping_score
    call print_score
    mov cx, 3
    loop_over_delay:
    call delay
    loop loop_over_delay

    mov ax, 0x4c00
    int 0x21
    ret
; -------------------->INPUT PLAYER NAME
inputString:
	push bp
	mov bp, sp
	push ax
	push bx
	push es
	push di
	push si

    push 0
    push 0
    mov ax, 0x0A
    push ax
    mov ax, entername
    push ax
    call printstr
	mov ax, 0xB800
	mov es, ax
	mov si, inputname           ;point string
	mov di, 30                  ;location
	mov bx, 0
	input:
		mov ax, 0
		int 0x16
		cmp ax, 0x1C0D
		jz endInput
		cmp ax, 0x0E08
		jnz si1
			cmp bx, 0
			jz si2
			dec bx
			sub di, 2
			mov byte[si+bx], 0x20
			mov word[es:di], 0x0720
			jmp si2
		si1:
		mov byte[si+bx], al
		mov ah, 0x07
		mov word[es:di], ax
		add di, 2
		inc bx
		si2:
		cmp bx, 15
		jnz input
	endInput:
	mov byte[si+bx], 0
	pop si
	pop di
	pop es
	pop bx
	pop ax
	pop bp
	ret


;--------------> GAME STARTING SUBROUTINE
start:

    call clrscr
    call print_banner
mov cx,20
li:
    call delay 
loop li;
continue:
    call clrscr
    call inputString
    call load_border
    call print_food
    call move_right
   

    mov ax, 0x4c00
    int 0x21


;--------------> SNAKE RELATED DATA
len: dw 3
space: dw 162
pos: dw 162, 164, 166