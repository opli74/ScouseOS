cmake_minimum_required(VERSION 3.16...3.29)

project(ScouseOS C CXX ASM ) 

# Source directory
set(SOURCE_DIR src)

# Output directory
set(OUTPUT_DIR out)

# Create the output directory if it doesn't exist
file(MAKE_DIRECTORY ${OUTPUT_DIR})

# List NASM source files using file(GLOB ...)
file(GLOB SOURCES CMAKE_CONFIGURE_DEPENDS 
    *.asm
        src/*.asm
)

foreach(SOURCE ${SOURCES})
    # Get the filename without the extension
    get_filename_component(NAME ${SOURCE} NAME_WE)
    # Add a custom command to assemble the source file
    add_custom_command(
        OUTPUT ${OUTPUT_DIR}/${NAME}.bin
        COMMAND nasm ${SOURCE} -f bin -o ${OUTPUT_DIR}/${NAME}.bin
        DEPENDS ${SOURCE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Assembling ${SOURCE_FILE}"
    )
    # Add a custom target to make sure the command is executed
    add_custom_target(${NAME} ALL DEPENDS ${OUTPUT_DIR}/${NAME}.bin)
endforeach()