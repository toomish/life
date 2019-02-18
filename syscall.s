.ifndef __SYSCALL__
.equ __SYSCALL__, 1

.ifdef KVER
.if KVER == 24
	.include "syscall-24.s"
.else
.if KVER == 26
	.include "syscall-26.s"
.else
	.error "bad kernel version"
.endif
.endif
.else
	.error "kernel version is not defined"
.endif

.endif
