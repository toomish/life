.include "syscall.s"
.include "defs.s"
.include "bpp.s"

.ifdef FULLBPP
	BLACK = 0x00000000
	COLOR = 0x0000ff00
.else
	BLACK = 0x0000
	COLOR = 0x0f00
.endif

.macro push_color color
.ifdef FULLBPP
	pushl \color
.else
	pushw \color
.endif
.endm

.macro rep_stos_color
.ifdef FULLBPP
	rep stosl
.else
	rep stosw
.endif
.endm

.macro mov_color_to_eax color
.ifdef FULLBPP
	movl \color, %eax
.else
	movw \color, %ax
.endif
.endm

.macro copy_row src, dst
	movl \src, %esi
	movl \dst, %edi

	movl $WIDTH, %ecx
	rep movsb
.endm

.macro copy_col src, dst
	movl \src, %esi
	movl \dst, %edi

	movl $HEIGHT, %ecx
	1:
	movsb
	addl $WIDTH + 1, %esi
	addl $WIDTH + 1, %edi
	decl %ecx
	testl %ecx, %ecx
	jnz 1b
.endm

.macro copy src, dst
	movl \src, %esi
	movl \dst, %edi
	movsb
.endm

DRAWCELL_ARGLEN = 8 + BYTES_PER_PIXEL

.equ EV_REL, 		1
.equ EV_ACQ, 		2
.equ EV_EXIT, 		4
.equ EV_RESTART, 	8 # re-read file and draw life again
.equ EV_PRINT,		16

.equ M_OPEN,		0001
.equ M_MMAP,		0002
.equ M_ICANON,		0004
.equ M_GRAPHICS,	0010

.text
.globl _start
_start:
	movl %esp, %ebp
	movl (%ebp), %eax
	decl %eax
	testl %eax, %eax
	jnz 1f

	movl $SYS_WRITE, %eax
	movl $2, %ebx
	movl $str_usage, %ecx
	movl $str_usage_len, %edx
	int $0x80

	xorl %eax, %eax
	jmp exit

	1:

# check first command line arg for access

	movl $SYS_ACCESS, %eax
	movl 8(%ebp), %ebx
	movl $R_OK, %ecx
	int $0x80

	testl %eax, %eax
	jnz access_error

# check if arg is a directory

	subl $128, %esp
	movl $SYS_STAT64, %eax
	movl 8(%ebp), %ebx
	movl %esp, %ecx
	int $0x80

	testl %eax, %eax
	jnz stat_error

	movl 16(%esp), %eax
	andl $S_IFMT, %eax
	subl $S_IFDIR, %eax
	testl %eax, %eax
	jnz 1f

	pushl $0
	pushl $str_fnot
	pushl 8(%ebp)
	call print_strings
	jmp restore

	1:
	addl $(64 - 6), %esp

# test if stdin refers to linux console

	movl $SYS_IOCTL, %eax
	xorl %ebx, %ebx
	movl $VT_GETSTATE, %ecx
	movl %esp, %edx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	addl $6, %esp

# open frame buffer device

	movl $SYS_OPEN, %eax
	movl $fbdev, %ebx
	movl $O_RDWR, %ecx
	int $0x80

	cmpl $0, %eax
	jl open_error

	orb $M_OPEN, (prog_mode)

	subl $200, %esp
	movl %eax, (desc)

# get frame buffer screeninfo

	movl %eax, %ebx
	movl $SYS_IOCTL, %eax
	movl $FBIOGET_VSCREENINFO, %ecx
	movl %esp, %edx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	movl %esp, %esi
	movl $res, %edi
	movl $2, %ecx
	rep movsl

	addl $200, %esp
	movl (res), %eax
	mull (res + 4)
	shll $BPP_SHIFT, %eax
	movl %eax, (fbsize)

# mmap fbdev into memory

	pushl $0
	pushl (desc)
	pushl $MAP_SHARED
	pushl $(PROT_READ | PROT_WRITE)
	pushl (fbsize)
	pushl $0
	movl $SYS_MMAP, %eax
	movl %esp, %ebx
	int $0x80

	movl %eax, %ebx
	notl %ebx
	testl $0xffffff00, %ebx
	jz mmap_error

	movl %eax, (fbmem)

	addl $24, %esp
	orb $M_MMAP, (prog_mode)

	movl $SYS_CLOSE, %eax
	movl (desc), %ebx
	int $0x80

	andb $~M_OPEN, (prog_mode)

# set signal handlers

	xorl %edx, %edx
	pushl %edx
	pushl $SA_RESTART
	pushl %edx
	pushl $vt_switch_catch
	movl %esp, %ecx

	movl $SYS_SIGACTION, %eax
	movl $SIGUSR1, %ebx
	int $0x80

	movl $SYS_SIGACTION, %eax
	movl $SIGUSR2, %ebx
	int $0x80

	movl $sig_die_catch, (%esp)
	movl $sig_die_set, %esi

	1:
	lodsb
	testb %al, %al
	jz 2f

	movzx %al, %ebx
	movl $SYS_SIGACTION, %eax
	int $0x80
	jmp 1b

	2:
	movl $SIG_IGN, (%esp)
	movl $SYS_SIGACTION, %eax
	movl $SIGTSTP, %ebx
	int $0x80

	addl $16, %esp

# set O_NONBLOCK flag for stdin

	movl $SYS_FCNTL, %eax
	xorl %ebx, %ebx
	movl $F_GETFL, %ecx
	int $0x80

	cmpl $0, %eax
	jl fcntl_error

	orl $O_NONBLOCK, %eax
	movl %eax, %edx
	movl $SYS_FCNTL, %eax
	movl $F_SETFL, %ecx
	int $0x80

	testl %eax, %eax
	jnz fcntl_error

# initialise virtual terminal

	subl $8, %esp

	movl $SYS_IOCTL, %eax
	movl $VT_GETMODE, %ecx
	movl %esp, %edx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	movb $VT_PROCESS, (%esp)
	movb $0, 1(%esp)
	movw $SIGUSR1, 2(%esp)
	movw $SIGUSR2, 4(%esp)

	movl $SYS_IOCTL, %eax
	movl $VT_SETMODE, %ecx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	addl $8, %esp

# set non-canonical and non-echo input mode

	movl $SYS_IOCTL, %eax
	movl $TCGETS, %ecx
	movl $termios, %edx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	pushl (termios + 12)
	andl $~(ICANON | ECHO), (termios + 12)
	movl $SYS_IOCTL, %eax
	movl $TCSETSF, %ecx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	popl (termios + 12)
	orb $M_ICANON, (prog_mode)

# set graphics mode

	movl $SYS_IOCTL, %eax
	movl $KDSETMODE, %ecx
	movl $KD_GRAPHICS, %edx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

	orb $M_GRAPHICS, (prog_mode)

# now we are able to read from file

read_file:

	movl $SYS_OPEN, %eax
	movl 8(%ebp), %ebx
	movl $O_RDONLY, %ecx
	int $0x80

	cmpl $0, %eax
	jl open_error

	movl %eax, (desc)
	orb $M_OPEN, (prog_mode)

	subl $BUF_SIZE + 8, %esp
	movl $life_map + START, %edi
	movl $WIDTH, -4(%ebp)
	movl $TOTAL, -8(%ebp)

read_next:
	movl $SYS_READ, %eax
	movl (desc), %ebx
	movl %esp, %ecx
	movl $BUF_SIZE, %edx
	int $0x80

	cmpl $0, %eax
	jl read_error
	je read_end

	movl %eax, %ebx
	movl -4(%ebp), %ecx
	movl -8(%ebp), %edx
	movl %esp, %esi

.charloop:
	lodsb
	cmpb $0x0a, %al
	jne 1f

	cmpl $WIDTH, %ecx
	je .charloop_next

	xorb %al, %al
	subl %ecx, %edx
	rep stosb
	jmp 2f

	1:
	subb $'0, %al
	testb $0b11111110, %al
	jnz .charloop_next

	stosb
	decl %ecx
	decl %edx
	testl %ecx, %ecx
	jnz 1f

	2:
	addl $2, %edi
	movl $WIDTH, %ecx

	1:
	testl %edx, %edx
	jz read_end

.charloop_next:
	decl %ebx
	testl %ebx, %ebx
	jnz .charloop

	movl %ecx, -4(%ebp)
	movl %edx, -8(%ebp)
	jmp read_next

read_end:

	addl $BUF_SIZE + 8, %esp

	movl $SYS_CLOSE, %eax
	movl (desc), %ebx
	int $0x80

	andb $~M_OPEN, (prog_mode)

# starting child thread for reading keys from tty
# if started (child_pid not NULL) - skip

	movl (child_pid), %eax
	testl %eax, %eax
	jnz life_start

	movl $SYS_CLONE, %eax
	movl $CLONE_VM, %ebx
	xorl %ecx, %ecx
	int $0x80

	cmpl $0, %eax
	jl clone_error

	testl %eax, %eax
	jz child_thread

	movl %eax, (child_pid)

# drawing first generation from life_map

	subl $TOTAL, %esp

life_start:

	movl (fbmem), %edi
	movl (fbsize), %ecx
	shrl $BPP_SHIFT, %ecx
	mov_color_to_eax $BLACK
	rep_stos_color

	movl $0, (curx)
	movl $0, (cury)
	movl $life_map + START, %esi
	movl $HEIGHT, %edx
.L1:
	movl $WIDTH, %ecx
.L2:
	lodsb
	testb %al, %al
	jz 1f

	push_color $COLOR
	pushl (cury)
	pushl (curx)
	call drawcell

	addl $DRAWCELL_ARGLEN, %esp

	1:
	addl $CELL_WIDTH, (curx)
	decl %ecx
	testl %ecx, %ecx
	jnz .L2

	addl $2, %esi
	decl %edx
	movl $0, (curx)
	addl $CELL_HEIGHT, (cury)
	testl %edx, %edx
	jnz .L1

# calc new generation, redraw display on fly

life_loop:

	movb (event), %al
	testb %al, %al
	jnz event_handler

	movl $SYS_NANOSLEEP, %eax
	movl $timespec, %ebx
	movl $0, %ecx
	int $0x80

	movb (event), %al
	testb %al, %al
	jnz event_handler

	movl (pause), %eax
	testl %eax, %eax
	jnz life_loop

resume:

	copy_row $life_map + START, $life_map + BOTTOM
	copy_row $life_map + LASTROW, $life_map + 1
	copy_col $life_map + START, $life_map + RIGHT
	copy_col $life_map + LASTCOL, $life_map + LEFT

	copy $life_map + TOP_LEFT, $life_map + BOTTOM_RIGHT_EXT
	copy $life_map + TOP_RIGHT, $life_map + BOTTOM_LEFT_EXT
	copy $life_map + BOTTOM_RIGHT, $life_map + TOP_LEFT_EXT
	copy $life_map + BOTTOM_LEFT,  $life_map + TOP_RIGHT_EXT

	movl $life_map + START, %esi
	movl %esp, %edi
	movl $HEIGHT, %edx
	movl $0, (curx)
	movl $0, (cury)

scan_next_line:
	movl $WIDTH, %ecx
scan_next_cell:
	movb -WIDTH_EXT-1(%esi), %al
	addb -WIDTH_EXT(%esi), %al
	addb -WIDTH_EXT+1(%esi), %al
	addb -1(%esi), %al
	addb 1(%esi), %al
	addb WIDTH_EXT-1(%esi), %al
	addb WIDTH_EXT(%esi), %al
	addb WIDTH_EXT+1(%esi), %al

	movb %al, %ah
	lodsb
	testb %al, %al
	jz zero_cell

	testb $0b11111110, %ah
	jz 1f
	testb $0b11111100, %ah
	jz store_val

	1:
	push_color $BLACK
	pushl (cury)
	pushl (curx)
	call drawcell
	addl $DRAWCELL_ARGLEN, %esp

	xorb %al, %al
	jmp store_val

zero_cell:
	cmpb $3, %ah
	jne store_val

	push_color $COLOR
	pushl (cury)
	pushl (curx)
	call drawcell
	addl $DRAWCELL_ARGLEN, %esp

	incb %al
store_val:
	stosb
	addl $CELL_WIDTH, (curx)
	decl %ecx
	testl %ecx, %ecx
	jnz scan_next_cell

	decl %edx
	movl $0, (curx)
	addl $CELL_HEIGHT, (cury)
	addl $2, %esi
	testl %edx, %edx
	jnz scan_next_line

# store new generation to life_map

	movl $HEIGHT, %edx
	movl %esp, %esi
	movl $life_map + START, %edi
	1:
	movl $WIDTH, %ecx
	rep movsb
	addl $2, %edi
	decl %edx
	testl %edx, %edx
	jnz 1b

	jmp life_loop

event_handler:
	movb $0, (event)

	testb $EV_REL, %al
	jnz release_display
	testb $EV_RESTART, %al
	jnz read_file
	testb $EV_PRINT, %al
	jnz export

# is case when life is started, when its virtual terminal is nonactive
# when this vt activated, process recieve SIGUSR2 signal
# and sets variable event to EV_ACQ
# and we must catch it, without this code process will finish

	testb $EV_ACQ, %al 
	jnz resume

restore:
	xorl %ebx, %ebx

	testb $M_GRAPHICS, (prog_mode)
	jz .rest_icanon

	movl $SYS_IOCTL, %eax
	movl $KDSETMODE, %ecx
	movl $KD_TEXT, %edx
	int $0x80

.rest_icanon:
	testb $M_ICANON, (prog_mode)
	jz .rest_mmap

	movl $SYS_IOCTL, %eax
	movl $TCSETSF, %ecx
	movl $termios, %edx
	int $0x80

.rest_mmap:
	testb $M_MMAP, (prog_mode)
	jz .rest_open

	movl $SYS_MUNMAP, %eax
	movl (fbmem), %ebx
	movl (fbsize), %ecx
	int $0x80

.rest_open:
	testb $M_OPEN, (prog_mode)
	jz exit

	movl $SYS_CLOSE, %eax
	movl (desc), %ebx
	int $0x80

export:
	jmp resume

exit:
	movl %eax, %ebx
	movl $SYS_EXIT, %eax
	int $0x80

release_display:
	movl $SYS_IOCTL, %eax
	xorl %ebx, %ebx
	movl $VT_RELDISP, %ecx
	movl $1, %edx
	int $0x80

	testl %eax, %eax
	jnz ioctl_error

.loop_acq:
	movl $SYS_PAUSE, %eax
	int $0x80

	testb $EV_ACQ, (event)
	jz .loop_acq

	movb $0, (event)
	jmp life_start

# signal handler's functions

vt_switch_catch:
	movl 4(%esp), %eax
	testl $~SIGUSR1, %eax
	jnz 1f

	movb $EV_REL, (event)
	jmp .vt_switch_ret

	1:
	testl $~SIGUSR2, %eax
	jnz .vt_switch_ret
	
	movb $EV_ACQ, (event)

.vt_switch_ret:
	ret

sig_die_catch:
	pushl %ebp
	movl %esp, %ebp

	subl $9, %esp
	movl %esp, %eax
	pushl %eax
	pushl 8(%ebp)
	call itoa

	pushl $0
	pushl $str_ret
	leal -3(%ebp), %eax
	pushl %eax
	pushl $str_intr
	call print_strings

	leave

	movl (child_pid), %ebx
	testl %ebx, %ebx
	jz restore

	movl $SYS_GETPID, %eax
	int $0x80

	cmpl %ebx, %eax
	jne .kill_child

	movl $0, (child_pid)
	jmp exit

.kill_child:
	movl $SYS_KILL, %eax
	movl $SIGINT, %ecx
	int $0x80

	testl %eax, %eax
	jnz kill_error

	movl $SYS_WAITPID, %eax
	xorl %ecx, %ecx
	movl $__WCLONE, %edx
	int $0x80

	cmpl %ebx, %eax
	jne waitpid_error

	jmp restore

# draw rectangle CELL_WIDTH * CELL_HEIGHT

drawcell:
	pushal
	movl (fbmem), %edi
	movl 40(%esp), %eax
	mull (res)
	addl 36(%esp), %eax
	shll $BPP_SHIFT, %eax
	addl %eax, %edi
	movl $CELL_HEIGHT, %edx
	mov_color_to_eax 44(%esp)

	movl (res), %ebx
	shll $BPP_SHIFT, %ebx

	.draw_line:
	movl $CELL_WIDTH, %ecx
	pushl %edi
	rep_stos_color

	popl %edi
	addl %ebx, %edi
	decl %edx
	testl %edx, %edx
	jnz .draw_line

	popal
	ret

child_thread:
	movw $POLLIN, (pollfd + 4)
	decl %esp

poll_loop:
	movl $SYS_POLL, %eax
	movl $pollfd, %ebx
	movl $1, %ecx
	movl $POLL_TIMEOUT, %edx
	int $0x80

	cmpl $1, %eax
	jne poll_loop
	testw $POLLIN, (pollfd + 6)
	jz poll_loop

	movl $SYS_READ, %eax
	xorl %ebx, %ebx
	movl %esp, %ecx
	movl $1, %edx
	int $0x80

	cmpl $0, %eax
	jl read_error

	testl %eax, %eax
	jz poll_loop

	movb (%esp), %al
	cmpb $'q, %al
	jne 1f

	movb $EV_EXIT, (event)
	jmp exit

	1:
	cmpb $'r, %al
	jne 1f
	movb $EV_RESTART, (event)

	1:
	cmpb $' ', %al
	jne 1f
	notl (pause)

	1:
	cmpb $'p', %al
	jne 1f
	movb $EV_PRINT, (event)

	1:
	jmp poll_loop

# some functions to output error message

open_error:
	pushl $str_open
	jmp sys_error

read_error:
	pushl $str_read
	jmp sys_error

ioctl_error:
	pushl $str_ioctl
	jmp sys_error

access_error:
	pushl $str_access
	jmp sys_error

clone_error:
	pushl $str_clone
	jmp sys_error

kill_error:
	pushl $str_kill
	jmp sys_error

waitpid_error:
	pushl $str_waitpid
	jmp sys_error

fcntl_error:
	pushl $str_fcntl
	jmp sys_error

stat_error:
	pushl $str_stat
	jmp sys_error

mmap_error:
	pushl $str_mmap

sys_error:
	pushl %ebp
	movl %esp, %ebp

	subl $44, %esp
	leal -36(%ebp), %esi
	movl %esi, 4(%esp)

	negl %eax
	movl %eax, (%esp)
	call itoa
	movl %ebx, (%esp)
	addl $9, 4(%esp)
	call itoa
	movl %ecx, (%esp)
	addl $9, 4(%esp)
	call itoa
	movl %edx, (%esp)
	addl $9, 4(%esp)
	call itoa

	leal -9(%ebp), %eax

	pushl $0
	pushl $str_ret
	pushl %eax
	pushl $str_edx
	subl $9, %eax
	pushl %eax
	pushl $str_ecx
	subl $9, %eax
	pushl %eax
	pushl $str_ebx
	subl $9, %eax
	pushl %eax
	pushl $str_eax
	pushl 4(%ebp)
	pushl $str_error
	call print_strings

	leave
	jmp restore

print_strings:
	pushl %ebp
	movl %esp, %ebp
	subl $BUF_SIZE, %esp
	leal 8(%ebp), %esi
	movl %esp, %edi
	xorl %edx, %edx

.print_next:
	movl (%esi), %ebx
	testl %ebx, %ebx
	jz .print_write

/*
	pushl %edx
*/

	pushl %esi
	movl %ebx, %esi
	1:
	lodsb
	testb %al, %al
	jz 2f
	stosb
	incl %edx
	jmp 1b

	2:
	popl %esi

/*
	popl %eax
	subl %edx, %eax
	negl %eax

	pushl %ebx
	pushl %eax
	pushl $fmt
	call printf
	addl $12, %esp
*/

	addl $4, %esi
	jmp .print_next

.print_write:
	movl $SYS_WRITE, %eax
	movl $2, %ebx
	movl %esp, %ecx
	int $0x80

	leave
	ret

itoa:
	pushal
	movl 36(%esp), %ebx
	movl 40(%esp), %edi
	movl $8, %ecx
	1:
	roll $4, %ebx
	movb %bl, %al
	andb $0x0f, %al
	addb $'0, %al
	cmpb $'9, %al
	jle 2f
	addb $0x27, %al
	2:
	stosb
	loop 1b
	xorb %al, %al
	stosb
	popal
	ret

.data
fbdev:	.asciz "/dev/fb0"
/*
fmt:	.asciz "Debug: str(%d): %s\n"
*/
str_usage:	.ascii "Usage: life <life_map>\n"
str_usage_len = .-str_usage
str_ret:	.asciz "\n"
str_fnot:	.asciz " is directory\n"
str_intr:	.asciz "Interrupted by signal "
str_error:	.asciz "syscall error: "
str_eax:	.asciz "\n\tneg eax = 0x"
str_ebx:	.asciz "\n\tebx = 0x"
str_ecx:	.asciz "\n\tecx = 0x"
str_edx:	.asciz "\n\tedx = 0x"
str_ioctl:	.asciz "ioctl"
str_mmap:	.asciz "mmap"
str_kill:	.asciz "kill"
str_open:	.asciz "open"
str_read:	.asciz "read"
str_waitpid:	.asciz "waitpid"
str_clone:	.asciz "clone"
str_access:	.asciz "access"
str_stat:	.asciz "stat"
str_fcntl:	.asciz "fcntl"
sig_die_set:
	.byte SIGINT, SIGQUIT, SIGILL, SIGABRT, SIGBUS, SIGTERM, SIGSEGV, 0

timespec:
	.int 0
	.int 100000000

.bss
.comm desc, 4
.comm fbmem, 4
.comm fbsize, 4
.comm life_map, TOTAL_EXT
.comm res, 8
.comm curx, 4
.comm cury, 4
.comm event, 1
.comm termios, 36
.comm prog_mode, 1
.comm pollfd, 8
.comm child_pid, 4
.comm pause, 4
