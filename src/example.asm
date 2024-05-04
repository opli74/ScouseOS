BITS 64
org 0x00100000 ;Space for a small stack?

;**************
;*** HEADER ***
;**************

section .header
DOS_HEADER:
   dw 0x5a4d ;DOS Magic number
   times 29 dw 0 ;Zeroes
   dd 0x00000080 ;Address of PE header

DOS_STUB:
   ; I don't know how to write this as text, so you get zeroes
   times 32 dw 0

PE_HEADER:
   dd 0x00004550 ;PE Magic number
   dw 0x8664 ;Building for x86 architecture
   dw 2 ;Two sections (.text, .data)
   dd 0x5ed4b58 ;number of seconds between 00:00:00 1st January 1970 and 00:00:00 1st July 2021
   dd 0x0 ;No symbol table
   dd 0x0 ;No symbols in the non-existent symbol table!
   dw oSize ;The size of the entire optional header. See the OPTIONAL_HEADER_END label for the calculation.
   dw 0x1002 ;Is a valid image file, is a system file. No other fancy characteristics.

oSize equ OPTIONAL_HEADER_END - OPTIONAL_HEADER_STANDARD_FIELDS

OPTIONAL_HEADER_STANDARD_FIELDS: ;Not actually optional
   dw 0x020b ;PE32+ Executable. I want my 64-bit registers!
   dw 0x0 ;What linker?
   dd 1024 ;The size of the code segment
   dd 1024 ;The size of the data segment
   dd 0x0 ;No .bss section. All variables to be initialised.
   dd 1024 ;The program's entry point
   dd 1024 ;The program's first instruction. Same as the start of the code execution. Duh.

OPTIONAL_HEADER_WINDOWS_FIELDS: ;This is required for UEFI applications too. Trust me, plenty of debugging went into that discovery.
   dq 0x00100000 ;The entry point of the image
   dd 0x1024 ;The section alignment
   dd 0x1024 ;The file alignment
   dw 0x0 ;No operating system requirements
   dw 0x0 ;Stil no operating system requirements
   dw 0x0 ;Major image version number
   dw 0x1 ;Minor image version number
   dw 0x0 ;Major subsystem version. Doesn't matter, as long as it supports UEFI.
   dw 0x0 ;Minor subsystem version. Doesn't matter, as long as it supports UEFI.
   dd 0x0 ;A dedicated zero
   dd 3072 ;Image size
   dd 1024 ;Header size
   dd 0x0 ;Checksum //TODO ADD LATER
   dw 0x000A ;UEFI Subsystem number.
   dw 0x0 ;Not a DLL, so this can be zero

   ;Using PE32+ file type, so the following are dqs, not dds
   dq 0x8000 ;Amount of stack space to reserve
   dq 0x8000 ;Amount of stack space to commit immediately
   dq 0x8000 ;Amount of local heap space to reserve
   dq 0x0 ;Amount of local heap space to commit immediately. Hopefully not needed.
   dd 0x0 ;Another four bytes dedicated to being zeroes
   dd 0x0 ;Number of data dictionary entries

;OPTIONAL_HEADER_DATA_DIRECTORIES: ;We don't have any special sections, so we don't need this header!

OPTIONAL_HEADER_END: ;This label is required for calculating value of oSize

SECTION_TABLE: ;as if you don't have enough information already :\
.1: ;text section
   dq `.text` ;The name of the text section
   dd 1024 ;virtual size.
   dd 1024 ;virtual entry point address.
   dd 1024 ;actual size.
   dd 1024 ;actual entry point address.
   dd 0 ;No relocations
   dd 0 ;No line numbers
   dw 0 ;No relocations
   dw 0 ;No line numbers
   dd 0x60000020 ;Contains executable code, can be executed as code, can be read.

.2: ;data section
   dq `.data` ;The name of the data section
   dd 1024 ;virtual size.
   dd 2048 ;virtual entry point address.
   dd 1024 ;actual size.
   dd 2048 ;actual entry point address.
   dd 0 ;No relocations
   dd 0 ;No line numbers
   dw 0 ;No relocations
   dw 0 ;No line numbers
   dd 0xc0000040 ;Contains initialised data, can be read, can be written to.

times 1024 - ($-$$) db 0 ;alignment

;*****************
;*** MAIN CODE ***
;*****************

section .text follows=.header
vars:
   ;Function return codes.
   EFI_SUCCESS equ 0
   
   ;Offsets for loading function addresses
   OFFSET_TABLE_BOOT_SERVICES equ 96
   OFFSET_TABLE_ERROR_CONSOLE equ 80
   OFFSET_TABLE_OUTPUT_CONSOLE equ 64
   OFFSET_TABLE_RUNTIME_SERVICES equ 88
   OFFSET_BOOT_EXIT_PROGRAM equ 216
   OFFSET_BOOT_STALL equ 248
   OFFSET_CONSOLE_OUTPUT_STRING equ 8

   ;Numbers used in the program.
   waitTime equ 1000000 ;One million microseconds, equals one second

start:
   sub rsp, 6*8+8 ; Copied from Charles AP's implementation, fix stack alignment issue (Thanks Charles AP!)

   ;Start moving handoff variables.
   mov [EFI_HANDLE], rcx
   mov [EFI_SYSTEM_TABLE], rdx
   mov [EFI_RETURN], rsp

   ;Set up necessary boot services functions
   add rdx, OFFSET_TABLE_BOOT_SERVICES ;get boot services table
   mov rcx, [rdx]
   mov [BOOT_SERVICES], rcx
   add rcx, OFFSET_BOOT_EXIT_PROGRAM ;get exit function from boot services table
   mov rdx, [rcx]
   mov [BOOT_SERVICES_EXIT], rdx
   mov rcx, [BOOT_SERVICES]
   add rcx, OFFSET_BOOT_STALL ;get stall function from boot services table
   mov rdx, [rcx]
   mov [BOOT_SERVICES_STALL], rdx

   ;Set up necessary console functions
   mov rdx, [EFI_SYSTEM_TABLE]
   add rdx, OFFSET_TABLE_ERROR_CONSOLE ;get error console table
   mov rcx, [rdx]
   mov [CONERR], rcx
   add rcx, OFFSET_CONSOLE_OUTPUT_STRING ;get output string function from console table
   mov rdx, [rcx]
   mov [CONERR_PRINT_STRING], rdx

   mov rdx, [EFI_SYSTEM_TABLE]
   add rdx, OFFSET_TABLE_OUTPUT_CONSOLE ;get output console table
   mov rcx, [rdx]
   mov [CONOUT], rcx
   add rcx, OFFSET_CONSOLE_OUTPUT_STRING ;get output string function from console table
   mov rdx, [rcx]
   mov [CONOUT_PRINT_STRING], rdx

   ;Set up necessary runtime services functions
   mov rdx, [EFI_SYSTEM_TABLE]
   add rdx, OFFSET_TABLE_RUNTIME_SERVICES ;get runtime services table
   mov rcx, [rdx]
   mov [RUNTIME_SERVICES], rcx

   ;Clear some registers for use.
   xor rcx, rcx
   xor rdx, rdx
   xor r8, r8

   ;Print a string
   mov rcx, [CONOUT]
   lea rdx, [waitString]
   call [CONOUT_PRINT_STRING]

   ;Wait a second so that the user can read the string
   mov rcx, waitTime
   call [BOOT_SERVICES_STALL]

   ;Print a string
   mov rcx, [CONOUT]
   lea rdx, [hello]
   call [CONOUT_PRINT_STRING]

   ;Return back to the UEFI with success!
   mov rcx, [EFI_HANDLE]
   mov rdx, EFI_SUCCESS
   mov r8, 1
   call [BOOT_SERVICES_EXIT]

   ret

times 1024 - ($-$$) db 0 ;alignment

;************
;*** DATA ***
;************

section .data follows=.text
dataStart:
   ;Handover variables
   EFI_HANDLE dq 0
   EFI_SYSTEM_TABLE dq 0
   EFI_RETURN dq 0

   ;Accessing functions of EFI system table
   BOOT_SERVICES dq 0
   BOOT_SERVICES_EXIT dq 0 ;This one exits the program, not just stop boot services!
   BOOT_SERVICES_STALL dq 0
   CONERR dq 0
   CONERR_PRINT_STRING dq 0
   CONOUT dq 0
   CONOUT_PRINT_STRING dq 0
   RUNTIME_SERVICES dq 0
   
   ;Strings used in the program.
   waitString db __utf16__ `Wait a second...\r\n\0`
   hello db __utf16__ `Hi JD9999!\r\n\0`

times 1024 - ($-$$) db 0 ;alignment