/* from linux-2.6.20: /include/asm/unistd.h */

.equ SYS_RESTART_SYSCALL, 0
.equ SYS_EXIT, 1
.equ SYS_FORK, 2
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_WAITPID, 7
.equ SYS_CREAT, 8
.equ SYS_LINK, 9
.equ SYS_UNLINK, 10
.equ SYS_EXECVE, 11
.equ SYS_CHDIR, 12
.equ SYS_TIME, 13
.equ SYS_MKNOD, 14
.equ SYS_CHMOD, 15
.equ SYS_LCHOWN, 16
.equ SYS_BREAK, 17
.equ SYS_OLDSTAT, 18
.equ SYS_LSEEK, 19
.equ SYS_GETPID, 20
.equ SYS_MOUNT, 21
.equ SYS_UMOUNT, 22
.equ SYS_SETUID, 23
.equ SYS_GETUID, 24
.equ SYS_STIME, 25
.equ SYS_PTRACE, 26
.equ SYS_ALARM, 27
.equ SYS_OLDFSTAT, 28
.equ SYS_PAUSE, 29
.equ SYS_UTIME, 30
.equ SYS_STTY, 31
.equ SYS_GTTY, 32
.equ SYS_ACCESS, 33
.equ SYS_NICE, 34
.equ SYS_FTIME, 35
.equ SYS_SYNC, 36
.equ SYS_KILL, 37
.equ SYS_RENAME, 38
.equ SYS_MKDIR, 39
.equ SYS_RMDIR, 40
.equ SYS_DUP, 41
.equ SYS_PIPE, 42
.equ SYS_TIMES, 43
.equ SYS_PROF, 44
.equ SYS_BRK, 45
.equ SYS_SETGID, 46
.equ SYS_GETGID, 47
.equ SYS_SIGNAL, 48
.equ SYS_GETEUID, 49
.equ SYS_GETEGID, 50
.equ SYS_ACCT, 51
.equ SYS_UMOUNT2, 52
.equ SYS_LOCK, 53
.equ SYS_IOCTL, 54
.equ SYS_FCNTL, 55
.equ SYS_MPX, 56
.equ SYS_SETPGID, 57
.equ SYS_ULIMIT, 58
.equ SYS_OLDOLDUNAME, 59
.equ SYS_UMASK, 60
.equ SYS_CHROOT, 61
.equ SYS_USTAT, 62
.equ SYS_DUP2, 63
.equ SYS_GETPPID, 64
.equ SYS_GETPGRP, 65
.equ SYS_SETSID, 66
.equ SYS_SIGACTION, 67
.equ SYS_SGETMASK, 68
.equ SYS_SSETMASK, 69
.equ SYS_SETREUID, 70
.equ SYS_SETREGID, 71
.equ SYS_SIGSUSPEND, 72
.equ SYS_SIGPENDING, 73
.equ SYS_SETHOSTNAME, 74
.equ SYS_SETRLIMIT, 75
.equ SYS_GETRLIMIT, 76
.equ SYS_GETRUSAGE, 77
.equ SYS_GETTIMEOFDAY, 78
.equ SYS_SETTIMEOFDAY, 79
.equ SYS_GETGROUPS, 80
.equ SYS_SETGROUPS, 81
.equ SYS_SELECT, 82
.equ SYS_SYMLINK, 83
.equ SYS_OLDLSTAT, 84
.equ SYS_READLINK, 85
.equ SYS_USELIB, 86
.equ SYS_SWAPON, 87
.equ SYS_REBOOT, 88
.equ SYS_READDIR, 89
.equ SYS_MMAP, 90
.equ SYS_MUNMAP, 91
.equ SYS_TRUNCATE, 92
.equ SYS_FTRUNCATE, 93
.equ SYS_FCHMOD, 94
.equ SYS_FCHOWN, 95
.equ SYS_GETPRIORITY, 96
.equ SYS_SETPRIORITY, 97
.equ SYS_PROFIL, 98
.equ SYS_STATFS, 99
.equ SYS_FSTATFS, 100
.equ SYS_IOPERM, 101
.equ SYS_SOCKETCALL, 102
.equ SYS_SYSLOG, 103
.equ SYS_SETITIMER, 104
.equ SYS_GETITIMER, 105
.equ SYS_STAT, 106
.equ SYS_LSTAT, 107
.equ SYS_FSTAT, 108
.equ SYS_OLDUNAME, 109
.equ SYS_IOPL, 110
.equ SYS_VHANGUP, 111
.equ SYS_IDLE, 112
.equ SYS_VM86OLD, 113
.equ SYS_WAIT4, 114
.equ SYS_SWAPOFF, 115
.equ SYS_SYSINFO, 116
.equ SYS_IPC, 117
.equ SYS_FSYNC, 118
.equ SYS_SIGRETURN, 119
.equ SYS_CLONE, 120
.equ SYS_SETDOMAINNAME, 121
.equ SYS_UNAME, 122
.equ SYS_MODIFY_LDT, 123
.equ SYS_ADJTIMEX, 124
.equ SYS_MPROTECT, 125
.equ SYS_SIGPROCMASK, 126
.equ SYS_CREATE_MODULE, 127
.equ SYS_INIT_MODULE, 128
.equ SYS_DELETE_MODULE, 129
.equ SYS_GET_KERNEL_SYMS, 130
.equ SYS_QUOTACTL, 131
.equ SYS_GETPGID, 132
.equ SYS_FCHDIR, 133
.equ SYS_BDFLUSH, 134
.equ SYS_SYSFS, 135
.equ SYS_PERSONALITY, 136
.equ SYS_AFS_SYSCALL, 137
.equ SYS_SETFSUID, 138
.equ SYS_SETFSGID, 139
.equ SYS__LLSEEK, 140
.equ SYS_GETDENTS, 141
.equ SYS__NEWSELECT, 142
.equ SYS_FLOCK, 143
.equ SYS_MSYNC, 144
.equ SYS_READV, 145
.equ SYS_WRITEV, 146
.equ SYS_GETSID, 147
.equ SYS_FDATASYNC, 148
.equ SYS__SYSCTL, 149
.equ SYS_MLOCK, 150
.equ SYS_MUNLOCK, 151
.equ SYS_MLOCKALL, 152
.equ SYS_MUNLOCKALL, 153
.equ SYS_SCHED_SETPARAM, 154
.equ SYS_SCHED_GETPARAM, 155
.equ SYS_SCHED_SETSCHEDULER, 156
.equ SYS_SCHED_GETSCHEDULER, 157
.equ SYS_SCHED_YIELD, 158
.equ SYS_SCHED_GET_PRIORITY_MAX, 159
.equ SYS_SCHED_GET_PRIORITY_MIN, 160
.equ SYS_SCHED_RR_GET_INTERVAL, 161
.equ SYS_NANOSLEEP, 162
.equ SYS_MREMAP, 163
.equ SYS_SETRESUID, 164
.equ SYS_GETRESUID, 165
.equ SYS_VM86, 166
.equ SYS_QUERY_MODULE, 167
.equ SYS_POLL, 168
.equ SYS_NFSSERVCTL, 169
.equ SYS_SETRESGID, 170
.equ SYS_GETRESGID, 171
.equ SYS_PRCTL, 172
.equ SYS_RT_SIGRETURN, 173
.equ SYS_RT_SIGACTION, 174
.equ SYS_RT_SIGPROCMASK, 175
.equ SYS_RT_SIGPENDING, 176
.equ SYS_RT_SIGTIMEDWAIT, 177
.equ SYS_RT_SIGQUEUEINFO, 178
.equ SYS_RT_SIGSUSPEND, 179
.equ SYS_PREAD64, 180
.equ SYS_PWRITE64, 181
.equ SYS_CHOWN, 182
.equ SYS_GETCWD, 183
.equ SYS_CAPGET, 184
.equ SYS_CAPSET, 185
.equ SYS_SIGALTSTACK, 186
.equ SYS_SENDFILE, 187
.equ SYS_GETPMSG, 188
.equ SYS_PUTPMSG, 189
.equ SYS_VFORK, 190
.equ SYS_UGETRLIMIT, 191
.equ SYS_MMAP2, 192
.equ SYS_TRUNCATE64, 193
.equ SYS_FTRUNCATE64, 194
.equ SYS_STAT64, 195
.equ SYS_LSTAT64, 196
.equ SYS_FSTAT64, 197
.equ SYS_LCHOWN32, 198
.equ SYS_GETUID32, 199
.equ SYS_GETGID32, 200
.equ SYS_GETEUID32, 201
.equ SYS_GETEGID32, 202
.equ SYS_SETREUID32, 203
.equ SYS_SETREGID32, 204
.equ SYS_GETGROUPS32, 205
.equ SYS_SETGROUPS32, 206
.equ SYS_FCHOWN32, 207
.equ SYS_SETRESUID32, 208
.equ SYS_GETRESUID32, 209
.equ SYS_SETRESGID32, 210
.equ SYS_GETRESGID32, 211
.equ SYS_CHOWN32, 212
.equ SYS_SETUID32, 213
.equ SYS_SETGID32, 214
.equ SYS_SETFSUID32, 215
.equ SYS_SETFSGID32, 216
.equ SYS_PIVOT_ROOT, 217
.equ SYS_MINCORE, 218
.equ SYS_MADVISE, 219
.equ SYS_MADVISE1, 219
.equ SYS_GETDENTS64, 220
.equ SYS_FCNTL64, 221
.equ SYS_GETTID, 224
.equ SYS_READAHEAD, 225
.equ SYS_SETXATTR, 226
.equ SYS_LSETXATTR, 227
.equ SYS_FSETXATTR, 228
.equ SYS_GETXATTR, 229
.equ SYS_LGETXATTR, 230
.equ SYS_FGETXATTR, 231
.equ SYS_LISTXATTR, 232
.equ SYS_LLISTXATTR, 233
.equ SYS_FLISTXATTR, 234
.equ SYS_REMOVEXATTR, 235
.equ SYS_LREMOVEXATTR, 236
.equ SYS_FREMOVEXATTR, 237
.equ SYS_TKILL, 238
.equ SYS_SENDFILE64, 239
.equ SYS_FUTEX, 240
.equ SYS_SCHED_SETAFFINITY, 241
.equ SYS_SCHED_GETAFFINITY, 242
.equ SYS_SET_THREAD_AREA, 243
.equ SYS_GET_THREAD_AREA, 244
.equ SYS_IO_SETUP, 245
.equ SYS_IO_DESTROY, 246
.equ SYS_IO_GETEVENTS, 247
.equ SYS_IO_SUBMIT, 248
.equ SYS_IO_CANCEL, 249
.equ SYS_FADVISE64, 250
.equ SYS_EXIT_GROUP, 252
.equ SYS_LOOKUP_DCOOKIE, 253
.equ SYS_EPOLL_CREATE, 254
.equ SYS_EPOLL_CTL, 255
.equ SYS_EPOLL_WAIT, 256
.equ SYS_REMAP_FILE_PAGES, 257
.equ SYS_SET_TID_ADDRESS, 258
.equ SYS_TIMER_CREATE, 259
.equ SYS_TIMER_SETTIME, 260
.equ SYS_TIMER_GETTIME, 261
.equ SYS_TIMER_GETOVERRUN, 262
.equ SYS_TIMER_DELETE, 263
.equ SYS_CLOCK_SETTIME, 264
.equ SYS_CLOCK_GETTIME, 265
.equ SYS_CLOCK_GETRES, 266
.equ SYS_CLOCK_NANOSLEEP, 267
.equ SYS_STATFS64, 268
.equ SYS_FSTATFS64, 269
.equ SYS_TGKILL, 270
.equ SYS_UTIMES, 271
.equ SYS_FADVISE64_64, 272
.equ SYS_VSERVER, 273
.equ SYS_MBIND, 274
.equ SYS_GET_MEMPOLICY, 275
.equ SYS_SET_MEMPOLICY, 276
.equ SYS_MQ_OPEN, 277
.equ SYS_MQ_UNLINK, 278
.equ SYS_MQ_TIMEDSEND, 279
.equ SYS_MQ_TIMEDRECEIVE, 280
.equ SYS_MQ_NOTIFY, 281
.equ SYS_MQ_GETSETATTR, 282
.equ SYS_KEXEC_LOAD, 283
.equ SYS_WAITID, 284
/* #DEFINE __NR_SYS_SETALTROOT	285 */
.equ SYS_ADD_KEY, 286
.equ SYS_REQUEST_KEY, 287
.equ SYS_KEYCTL, 288
.equ SYS_IOPRIO_SET, 289
.equ SYS_IOPRIO_GET, 290
.equ SYS_INOTIFY_INIT, 291
.equ SYS_INOTIFY_ADD_WATCH, 292
.equ SYS_INOTIFY_RM_WATCH, 293
.equ SYS_MIGRATE_PAGES, 294
.equ SYS_OPENAT, 295
.equ SYS_MKDIRAT, 296
.equ SYS_MKNODAT, 297
.equ SYS_FCHOWNAT, 298
.equ SYS_FUTIMESAT, 299
.equ SYS_FSTATAT64, 300
.equ SYS_UNLINKAT, 301
.equ SYS_RENAMEAT, 302
.equ SYS_LINKAT, 303
.equ SYS_SYMLINKAT, 304
.equ SYS_READLINKAT, 305
.equ SYS_FCHMODAT, 306
.equ SYS_FACCESSAT, 307
.equ SYS_PSELECT6, 308
.equ SYS_PPOLL, 309
.equ SYS_UNSHARE, 310
.equ SYS_SET_ROBUST_LIST, 311
.equ SYS_GET_ROBUST_LIST, 312
.equ SYS_SPLICE, 313
.equ SYS_SYNC_FILE_RANGE, 314
.equ SYS_TEE, 315
.equ SYS_VMSPLICE, 316
.equ SYS_MOVE_PAGES, 317
.equ SYS_GETCPU, 318
.equ SYS_EPOLL_PWAIT, 319