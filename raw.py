from PIL import Image
import os

# Define raw image input file and output files
input_raw_file = 'start.raw'  # Ensure this filename is correct
pixel_asm_file = 'pixel_data.asm'
palette_asm_file = 'palette_data.asm'

# Set the image dimensions
width, height = 320, 200

try:
    # Read raw pixel data from the file
    with open(input_raw_file, 'rb') as file:
        raw_pixels = file.read()

    # Check if the raw file size matches the expected dimensions (320 * 200 = 64000)
    if len(raw_pixels) != width * height:
        raise ValueError("The raw file size does not match the expected dimensions of 320x200.")

    # Write the pixel data in ASM format
    with open(pixel_asm_file, 'w') as pixel_file:
        pixel_file.write("pixel_data db ")
        pixel_data = ", ".join(f"{hex(byte)}h" for byte in raw_pixels)
        pixel_file.write(pixel_data)
        print(f"Pixel data written to {pixel_asm_file}")

    # Create a grayscale palette if no palette is available in raw format
    grayscale_palette = []
    for i in range(256):
        r = g = b = i // 4  # Scale to VGA range (0-63)
        grayscale_palette.extend([r, g, b])

    # Write the palette data in ASM format
    with open(palette_asm_file, 'w') as palette_file:
        palette_file.write("palette_data db ")
        palette_data = ", ".join(
            f"{hex(r)}h, {hex(g)}h, {hex(b)}h"
            for r, g, b in zip(grayscale_palette[0::3], grayscale_palette[1::3], grayscale_palette[2::3])
        )
        palette_file.write(palette_data)
        print(f"Palette data written to {palette_asm_file}")

except FileNotFoundError:
    print("The input raw image file was not found. Please check the filename and try again.")
except Exception as e:
    print(f"An error occurred: {e}")
