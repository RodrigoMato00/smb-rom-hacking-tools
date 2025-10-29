#!/usr/bin/env python3
"""
Super Mario Bros Palette Editor
Modify colors, create night mode skies, and customize visual appearance.

NES Color Palette addresses in SMB ROM:
- Background palette: 0x0603-0x0612 (16 bytes)
- Sprite palette: 0x0613-0x0622 (16 bytes)
"""

import sys


class PaletteEditor:
    """Edit NES color palettes in Super Mario Bros ROM."""
    
    # NES color palette (simplified 64-color palette)
    NES_COLORS = {
        0x00: "Dark Gray", 0x01: "Light Blue", 0x02: "Blue", 0x03: "Purple",
        0x0F: "Black", 0x10: "Gray", 0x11: "Cyan", 0x12: "Blue",
        0x16: "Red", 0x21: "Green", 0x22: "Lime Green", 0x27: "Brown",
        0x28: "Yellow", 0x29: "Light Yellow", 0x30: "White"
    }
    
    # SMB ROM addresses
    BG_PALETTE_OFFSET = 0x0603
    SPRITE_PALETTE_OFFSET = 0x0613
    SKY_COLOR_OFFSET = 0x0603  # First byte of background palette
    
    def __init__(self, rom_path):
        """Initialize with ROM file path."""
        self.rom_path = rom_path
        self.rom_data = None
        self.load_rom()
    
    def load_rom(self):
        """Load ROM file into memory."""
        try:
            with open(self.rom_path, 'rb') as f:
                self.rom_data = bytearray(f.read())
            print(f"[+] Loaded ROM: {self.rom_path} ({len(self.rom_data)} bytes)")
        except FileNotFoundError:
            print(f"[!] Error: ROM file not found: {self.rom_path}")
            sys.exit(1)
        except Exception as e:
            print(f"[!] Error loading ROM: {e}")
            sys.exit(1)
    
    def save_rom(self, output_path=None):
        """Save modified ROM to file."""
        if output_path is None:
            output_path = self.rom_path.replace('.nes', '_modified.nes')
        
        try:
            with open(output_path, 'wb') as f:
                f.write(self.rom_data)
            print(f"[+] Saved modified ROM: {output_path}")
        except Exception as e:
            print(f"[!] Error saving ROM: {e}")
            sys.exit(1)
    
    def view_palette(self):
        """Display current palette values."""
        print("\n=== Background Palette ===")
        for i in range(16):
            addr = self.BG_PALETTE_OFFSET + i
            value = self.rom_data[addr]
            color = self.NES_COLORS.get(value, f"Color ${value:02X}")
            print(f"  [{i:02d}] Offset 0x{addr:04X}: ${value:02X} ({color})")
        
        print("\n=== Sprite Palette ===")
        for i in range(16):
            addr = self.SPRITE_PALETTE_OFFSET + i
            value = self.rom_data[addr]
            color = self.NES_COLORS.get(value, f"Color ${value:02X}")
            print(f"  [{i:02d}] Offset 0x{addr:04X}: ${value:02X} ({color})")
    
    def set_night_mode(self):
        """Apply night mode with dark sky."""
        print("\n[*] Applying night mode...")
        # Change sky color to black/dark blue
        self.rom_data[self.SKY_COLOR_OFFSET] = 0x0F  # Black sky
        # Darken some background colors
        self.rom_data[self.BG_PALETTE_OFFSET + 1] = 0x01  # Dark blue
        self.rom_data[self.BG_PALETTE_OFFSET + 2] = 0x02  # Blue
        print("[+] Night mode applied!")
    
    def set_custom_color(self, palette_type, index, color_value):
        """
        Set a custom color in the palette.
        
        Args:
            palette_type: 'bg' for background, 'sprite' for sprite
            index: Index in palette (0-15)
            color_value: NES color value (0x00-0x3F)
        """
        if palette_type == 'bg':
            offset = self.BG_PALETTE_OFFSET
        elif palette_type == 'sprite':
            offset = self.SPRITE_PALETTE_OFFSET
        else:
            print(f"[!] Invalid palette type: {palette_type}")
            return
        
        if not (0 <= index < 16):
            print(f"[!] Invalid index: {index} (must be 0-15)")
            return
        
        addr = offset + index
        old_value = self.rom_data[addr]
        self.rom_data[addr] = color_value
        print(f"[+] Changed {palette_type} palette[{index}]: ${old_value:02X} -> ${color_value:02X}")
    
    def rainbow_palette(self):
        """Apply a rainbow color scheme."""
        print("\n[*] Applying rainbow palette...")
        rainbow_colors = [0x16, 0x27, 0x28, 0x22, 0x11, 0x02, 0x03, 0x00]
        for i, color in enumerate(rainbow_colors):
            if i < 8:
                self.rom_data[self.BG_PALETTE_OFFSET + i * 2] = color
        print("[+] Rainbow palette applied!")


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Super Mario Bros Palette Editor")
        print("=" * 40)
        print("\nUsage:")
        print("  python palette_editor.py <rom_file> [options]")
        print("\nOptions:")
        print("  --view              View current palette")
        print("  --night-mode        Apply night mode (dark sky)")
        print("  --rainbow           Apply rainbow colors")
        print("  --set-color TYPE INDEX VALUE")
        print("                      Set custom color")
        print("                      TYPE: bg or sprite")
        print("                      INDEX: 0-15")
        print("                      VALUE: hex color (e.g., 0x0F)")
        print("\nExamples:")
        print("  python palette_editor.py smb.nes --view")
        print("  python palette_editor.py smb.nes --night-mode")
        print("  python palette_editor.py smb.nes --set-color bg 0 0x0F")
        sys.exit(0)
    
    rom_path = sys.argv[1]
    editor = PaletteEditor(rom_path)
    
    if len(sys.argv) == 2 or '--view' in sys.argv:
        editor.view_palette()
    
    if '--night-mode' in sys.argv:
        editor.set_night_mode()
        editor.save_rom()
    
    if '--rainbow' in sys.argv:
        editor.rainbow_palette()
        editor.save_rom()
    
    if '--set-color' in sys.argv:
        try:
            idx = sys.argv.index('--set-color')
            palette_type = sys.argv[idx + 1]
            index = int(sys.argv[idx + 2])
            value = int(sys.argv[idx + 3], 16)
            editor.set_custom_color(palette_type, index, value)
            editor.save_rom()
        except (IndexError, ValueError) as e:
            print(f"[!] Error parsing --set-color arguments: {e}")
            sys.exit(1)


if __name__ == "__main__":
    main()
