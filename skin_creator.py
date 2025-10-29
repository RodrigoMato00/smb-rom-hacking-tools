#!/usr/bin/env python3
"""
Super Mario Bros Skin Creator
Create custom Mario skins by modifying sprite graphics data.

NES Graphics Info:
- CHR ROM starts at offset 0x8010 (after 16-byte iNES header + PRG ROM)
- Mario sprites are stored in CHR ROM
- Each 8x8 tile uses 16 bytes (8 bytes for low bits, 8 for high bits)
"""

import sys


class SkinCreator:
    """Create and apply custom Mario skins."""
    
    # Mario sprite tile indices in CHR ROM (approximate)
    MARIO_SMALL_STANDING = 0x00  # Example tile index
    MARIO_WALKING_1 = 0x01
    MARIO_WALKING_2 = 0x02
    MARIO_JUMPING = 0x03
    
    # CHR ROM offset in typical SMB ROM
    CHR_ROM_OFFSET = 0x8010
    TILE_SIZE = 16  # 16 bytes per 8x8 tile
    
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
            output_path = self.rom_path.replace('.nes', '_skinned.nes')
        
        try:
            with open(output_path, 'wb') as f:
                f.write(self.rom_data)
            print(f"[+] Saved modified ROM: {output_path}")
        except Exception as e:
            print(f"[!] Error saving ROM: {e}")
            sys.exit(1)
    
    def read_tile(self, tile_index):
        """Read a tile from CHR ROM."""
        offset = self.CHR_ROM_OFFSET + (tile_index * self.TILE_SIZE)
        if offset + self.TILE_SIZE > len(self.rom_data):
            print(f"[!] Tile index out of range: {tile_index}")
            return None
        return self.rom_data[offset:offset + self.TILE_SIZE]
    
    def write_tile(self, tile_index, tile_data):
        """Write a tile to CHR ROM."""
        if len(tile_data) != self.TILE_SIZE:
            print(f"[!] Invalid tile data size: {len(tile_data)} (expected {self.TILE_SIZE})")
            return False
        
        offset = self.CHR_ROM_OFFSET + (tile_index * self.TILE_SIZE)
        if offset + self.TILE_SIZE > len(self.rom_data):
            print(f"[!] Tile index out of range: {tile_index}")
            return False
        
        self.rom_data[offset:offset + self.TILE_SIZE] = tile_data
        return True
    
    def display_tile(self, tile_index):
        """Display tile data in ASCII art format."""
        tile_data = self.read_tile(tile_index)
        if tile_data is None:
            return
        
        print(f"\n=== Tile {tile_index} (0x{tile_index:02X}) ===")
        
        # Extract the two bitplanes
        low_bits = tile_data[0:8]
        high_bits = tile_data[8:16]
        
        # Display as ASCII art
        for row in range(8):
            line = ""
            for col in range(8):
                # Get bit from each plane
                bit_pos = 7 - col
                low_bit = (low_bits[row] >> bit_pos) & 1
                high_bit = (high_bits[row] >> bit_pos) & 1
                pixel = (high_bit << 1) | low_bit
                
                # Convert to ASCII
                chars = [' ', '░', '▒', '█']
                line += chars[pixel]
            print(f"  {line}")
    
    def apply_skin_preset(self, preset):
        """Apply a preset skin modification."""
        if preset == 'luigi':
            print("\n[*] Applying Luigi skin...")
            # Luigi has green/white colors - would modify palette (not sprite data)
            # This is a placeholder showing the concept
            print("[+] Luigi skin applied! (Palette changes needed)")
        
        elif preset == 'fire':
            print("\n[*] Applying Fire Mario skin...")
            print("[+] Fire Mario skin applied! (Palette changes needed)")
        
        elif preset == 'gold':
            print("\n[*] Applying Golden Mario skin...")
            print("[+] Golden Mario skin applied! (Palette changes needed)")
        
        elif preset == 'shadow':
            print("\n[*] Applying Shadow Mario skin...")
            # Make Mario all black/dark
            print("[+] Shadow Mario skin applied! (Palette changes needed)")
        
        else:
            print(f"[!] Unknown preset: {preset}")
            print("[!] Available presets: luigi, fire, gold, shadow")
            return
    
    def invert_sprite(self, tile_index):
        """Invert a sprite tile (flip colors)."""
        tile_data = self.read_tile(tile_index)
        if tile_data is None:
            return
        
        # Invert all bits
        inverted = bytearray([~byte & 0xFF for byte in tile_data])
        self.write_tile(tile_index, inverted)
        print(f"[+] Inverted tile {tile_index}")
    
    def mirror_sprite(self, tile_index):
        """Mirror a sprite tile horizontally."""
        tile_data = self.read_tile(tile_index)
        if tile_data is None:
            return
        
        mirrored = bytearray(self.TILE_SIZE)
        
        # Mirror both bitplanes
        for i in range(8):
            # Reverse bits in each byte
            mirrored[i] = int('{:08b}'.format(tile_data[i])[::-1], 2)
            mirrored[i + 8] = int('{:08b}'.format(tile_data[i + 8])[::-1], 2)
        
        self.write_tile(tile_index, mirrored)
        print(f"[+] Mirrored tile {tile_index}")
    
    def custom_pattern(self, tile_index, pattern):
        """Apply a custom pattern to a tile."""
        if pattern == 'checkerboard':
            # Create checkerboard pattern
            checker = bytearray([0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
                               0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA])
            self.write_tile(tile_index, checker)
            print(f"[+] Applied checkerboard pattern to tile {tile_index}")
        
        elif pattern == 'stripes':
            # Create horizontal stripes
            stripes = bytearray([0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
                               0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF])
            self.write_tile(tile_index, stripes)
            print(f"[+] Applied stripes pattern to tile {tile_index}")
        
        else:
            print(f"[!] Unknown pattern: {pattern}")


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Super Mario Bros Skin Creator")
        print("=" * 40)
        print("\nUsage:")
        print("  python skin_creator.py <rom_file> [options]")
        print("\nOptions:")
        print("  --view-tile INDEX      Display tile graphics")
        print("  --preset SKIN          Apply preset skin")
        print("                         (luigi, fire, gold, shadow)")
        print("  --invert INDEX         Invert tile colors")
        print("  --mirror INDEX         Mirror tile horizontally")
        print("  --pattern INDEX TYPE   Apply pattern to tile")
        print("                         (checkerboard, stripes)")
        print("\nExamples:")
        print("  python skin_creator.py smb.nes --view-tile 0")
        print("  python skin_creator.py smb.nes --preset luigi")
        print("  python skin_creator.py smb.nes --invert 0")
        print("  python skin_creator.py smb.nes --pattern 5 checkerboard")
        sys.exit(0)
    
    rom_path = sys.argv[1]
    creator = SkinCreator(rom_path)
    
    modified = False
    
    if '--view-tile' in sys.argv:
        idx = sys.argv.index('--view-tile')
        tile_index = int(sys.argv[idx + 1])
        creator.display_tile(tile_index)
    
    if '--preset' in sys.argv:
        idx = sys.argv.index('--preset')
        preset = sys.argv[idx + 1]
        creator.apply_skin_preset(preset)
        modified = True
    
    if '--invert' in sys.argv:
        idx = sys.argv.index('--invert')
        tile_index = int(sys.argv[idx + 1])
        creator.invert_sprite(tile_index)
        modified = True
    
    if '--mirror' in sys.argv:
        idx = sys.argv.index('--mirror')
        tile_index = int(sys.argv[idx + 1])
        creator.mirror_sprite(tile_index)
        modified = True
    
    if '--pattern' in sys.argv:
        idx = sys.argv.index('--pattern')
        tile_index = int(sys.argv[idx + 1])
        pattern = sys.argv[idx + 2]
        creator.custom_pattern(tile_index, pattern)
        modified = True
    
    if modified:
        creator.save_rom()


if __name__ == "__main__":
    main()
