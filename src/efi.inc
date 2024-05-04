; 64-bit code
bits 64

; http://www.uefi.org/sites/default/files/resources/UEFI Spec 2_7_A Sept 6.pdf#G8.1001729
struc EFI_TABLE_HEADER
    .Signature  RESQ 1
    .Revision   RESD 1
    .HeaderSize RESD 1
    .CRC32      RESD 1
    .Reserved   RESD 1
endstruc

; http://www.uefi.org/sites/default/files/resources/UEFI Spec 2_7_A Sept 6.pdf#G8.1001773
struc EFI_SYSTEM_TABLE
    .Hdr                  RESB EFI_TABLE_HEADER_size
    .FirmwareVendor       RESQ 1
    .FirmwareRevision     RESD 1
    .ConsoleInHandle      RESQ 1
    .ConIn                RESQ 1
    .ConsoleOutHandle     RESQ 1
    .ConOut               RESQ 1
    .StandardErrorHandle  RESQ 1
    .StdErr               RESQ 1
    .RuntimeServices      RESQ 1
    .BootServices         RESQ 1
    .NumberOfTableEntries RESQ 1
    .ConfigurationTable   RESQ 1
endstruc

; http://www.uefi.org/sites/default/files/resources/UEFI Spec 2_7_A Sept 6.pdf#G16.1016807
struc EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL
    .Reset             RESQ 1
    .OutputString      RESQ 1
    .TestString        RESQ 1
    .QueryMode         RESQ 1
    .SetMode           RESQ 1
    .SetAttribute      RESQ 1
    .ClearScreen       RESQ 1
    .SetCursorPosition RESQ 1
    .EnableCursor      RESQ 1
    .Mode              RESQ 1
endstruc