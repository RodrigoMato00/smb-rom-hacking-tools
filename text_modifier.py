#!/usr/bin/env python3
"""
Super Mario Bros Text Modifier
Personalize title text and in-game messages.

NES Text Encoding:
- Text is stored as tile indices
- Each character maps to a specific tile in CHR ROM
- Text strings are stored in PRG ROM

Common SMB text locations:
- Title screen text
- World indicators (WORLD X-X)
- Score/time displays
"""

import sys


class TextModifier:
    """Modify text strings in Super Mario Bros ROM."""
    
    # SMB Character mapping (simplified)
    # Maps ASCII characters to NES tile indices
    CHAR_MAP = {
        'A': 0x0A, 'B': 0x0B, 'C': 0x0C, 'D': 0x0D, 'E': 0x0E, 'F': 0x0F,
        'G': 0x10, 'H': 0x11, 'I': 0x12, 'J': 0x13, 'K': 0x14, 'L': 0x15,
        'M': 0x16, 'N': 0x17, 'O': 0x18, 'P': 0x19, 'Q': 0x1A, 'R': 0x1B,
        'S': 0x1C, 'T': 0x1D, 'U': 0x1E, 'V': 0x1F, 'W': 0x20, 'X': 0x21,
        'Y': 0x22, 'Z': 0x23,
        '0': 0x00, '1': 0x01, '2': 0x02, '3': 0x03, '4': 0x04,
        '5': 0x05, '6': 0x06, '7': 0x07, '8': 0x08, '9': 0x09,
        ' ': 0x24, '-': 0x28, '!': 0x2B, '©': 0x29, '®': 0x2A,
        '.': 0x25, ',': 0x26, '?': 0x27
    }
    
    # Reverse mapping for display
    TILE_MAP = {v: k for k, v in CHAR_MAP.items()}
    
    # Known text locations in SMB ROM (approximate)
    # These would need to be verified for specific ROM versions
    TITLE_TEXT_OFFSET = 0x4F4  # "SUPER MARIO BROS" location (example)
    COPYRIGHT_OFFSET = 0x520   # Copyright text
    WORLD_TEXT_OFFSET = 0x670  # "WORLD" text
    
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
            output_path = self.rom_path.replace('.nes', '_modified_text.nes')
        
        try:
            with open(output_path, 'wb') as f:
                f.write(self.rom_data)
            print(f"[+] Saved modified ROM: {output_path}")
        except Exception as e:
            print(f"[!] Error saving ROM: {e}")
            sys.exit(1)
    
    def text_to_tiles(self, text):
        """Convert text string to NES tile indices."""
        tiles = []
        for char in text.upper():
            if char in self.CHAR_MAP:
                tiles.append(self.CHAR_MAP[char])
            else:
                tiles.append(self.CHAR_MAP[' '])  # Default to space
        return tiles
    
    def tiles_to_text(self, tiles):
        """Convert NES tile indices to text string."""
        text = ""
        for tile in tiles:
            if tile in self.TILE_MAP:
                text += self.TILE_MAP[tile]
            else:
                text += '?'
        return text
    
    def search_text(self, search_str):
        """Search for text pattern in ROM."""
        tiles = self.text_to_tiles(search_str)
        results = []
        
        print(f"\n[*] Searching for: '{search_str}'")
        print(f"    Tile pattern: {[hex(t) for t in tiles]}")
        
        # Search in PRG ROM area
        for i in range(0x10, min(0x8010, len(self.rom_data) - len(tiles))):
            match = True
            for j, tile in enumerate(tiles):
                if self.rom_data[i + j] != tile:
                    match = False
                    break
            
            if match:
                results.append(i)
                print(f"    Found at offset: 0x{i:04X}")
        
        if not results:
            print(f"    Pattern not found")
        
        return results
    
    def read_text(self, offset, length):
        """Read text from ROM at specified offset."""
        if offset + length > len(self.rom_data):
            print(f"[!] Offset out of range")
            return None
        
        tiles = self.rom_data[offset:offset + length]
        text = self.tiles_to_text(tiles)
        
        print(f"\n[*] Text at 0x{offset:04X} ({length} chars):")
        print(f"    Tiles: {[hex(t) for t in tiles]}")
        print(f"    Text: '{text}'")
        
        return text
    
    def write_text(self, offset, text):
        """Write text to ROM at specified offset."""
        tiles = self.text_to_tiles(text)
        
        if offset + len(tiles) > len(self.rom_data):
            print(f"[!] Text too long or offset out of range")
            return False
        
        print(f"\n[*] Writing text at 0x{offset:04X}:")
        print(f"    Text: '{text}'")
        print(f"    Tiles: {[hex(t) for t in tiles]}")
        
        for i, tile in enumerate(tiles):
            self.rom_data[offset + i] = tile
        
        print(f"[+] Text written successfully")
        return True
    
    def replace_text(self, old_text, new_text):
        """Find and replace text in ROM."""
        offsets = self.search_text(old_text)
        
        if not offsets:
            print(f"[!] Text '{old_text}' not found in ROM")
            return False
        
        # Ensure new text isn't longer than old text
        if len(new_text) > len(old_text):
            print(f"[!] Warning: New text is longer than old text")
            print(f"    Truncating to {len(old_text)} characters")
            new_text = new_text[:len(old_text)]
        
        # Pad if shorter
        if len(new_text) < len(old_text):
            new_text = new_text + ' ' * (len(old_text) - len(new_text))
        
        print(f"\n[*] Replacing '{old_text}' with '{new_text}'")
        
        for offset in offsets:
            self.write_text(offset, new_text)
        
        print(f"[+] Replaced {len(offsets)} occurrence(s)")
        return True
    
    def custom_title(self, title):
        """Set a custom title screen text."""
        print(f"\n[*] Setting custom title: '{title}'")
        
        # Try to find existing title text patterns
        common_titles = ["SUPER MARIO", "MARIO BROS", "WORLD"]
        
        found = False
        for pattern in common_titles:
            offsets = self.search_text(pattern)
            if offsets:
                print(f"[+] Found title pattern: '{pattern}'")
                # Use first occurrence
                self.write_text(offsets[0], title)
                found = True
                break
        
        if not found:
            print(f"[!] Could not locate title text automatically")
            print(f"    Use --write-at <offset> to specify exact location")
            return False
        
        return True
    
    def easter_egg_messages(self):
        """Add custom easter egg messages."""
        print("\n[*] Adding easter egg messages...")
        
        # This is a demonstration function
        # Real implementation would find game over text, etc.
        
        messages = [
            ("GAME OVER", "TRY AGAIN"),
            ("TIME UP", "TOO SLOW"),
        ]
        
        for old, new in messages:
            offsets = self.search_text(old)
            if offsets:
                self.write_text(offsets[0], new)
                print(f"[+] Changed '{old}' to '{new}'")


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Super Mario Bros Text Modifier")
        print("=" * 40)
        print("\nUsage:")
        print("  python text_modifier.py <rom_file> [options]")
        print("\nOptions:")
        print("  --search TEXT         Search for text in ROM")
        print("  --read OFFSET LENGTH  Read text at offset")
        print("  --write-at OFFSET TEXT")
        print("                        Write text at offset")
        print("  --replace OLD NEW     Replace text")
        print("  --title TEXT          Set custom title")
        print("  --easter-eggs         Add easter egg messages")
        print("\nExamples:")
        print("  python text_modifier.py smb.nes --search 'MARIO'")
        print("  python text_modifier.py smb.nes --read 0x4F4 16")
        print("  python text_modifier.py smb.nes --title 'CUSTOM GAME'")
        print("  python text_modifier.py smb.nes --replace 'MARIO' 'LUIGI'")
        sys.exit(0)
    
    rom_path = sys.argv[1]
    modifier = TextModifier(rom_path)
    
    modified = False
    
    if '--search' in sys.argv:
        idx = sys.argv.index('--search')
        text = sys.argv[idx + 1]
        modifier.search_text(text)
    
    if '--read' in sys.argv:
        idx = sys.argv.index('--read')
        offset = int(sys.argv[idx + 1], 16)
        length = int(sys.argv[idx + 2])
        modifier.read_text(offset, length)
    
    if '--write-at' in sys.argv:
        idx = sys.argv.index('--write-at')
        offset = int(sys.argv[idx + 1], 16)
        text = sys.argv[idx + 2]
        modifier.write_text(offset, text)
        modified = True
    
    if '--replace' in sys.argv:
        idx = sys.argv.index('--replace')
        old_text = sys.argv[idx + 1]
        new_text = sys.argv[idx + 2]
        modifier.replace_text(old_text, new_text)
        modified = True
    
    if '--title' in sys.argv:
        idx = sys.argv.index('--title')
        title = sys.argv[idx + 1]
        modifier.custom_title(title)
        modified = True
    
    if '--easter-eggs' in sys.argv:
        modifier.easter_egg_messages()
        modified = True
    
    if modified:
        modifier.save_rom()


if __name__ == "__main__":
    main()
