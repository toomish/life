.ifndef __BPP__
.equ __BPP__, 1

.ifndef BYTES_PER_PIXEL
	.error "BYTES_PER_PIXEL not defined"
.else
	.if BYTES_PER_PIXEL == 4
		.equ BPP_SHIFT, 2
		.equ FULLBPP, 1
	.elseif BYTES_PER_PIXEL == 2
		.equ BPP_SHIFT, 1
	.else
		.error "BYTES_PER_PIXEL must be 2 or 4"
	.endif
.endif

.endif
