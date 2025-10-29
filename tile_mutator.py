#!/usr/bin/env python3
"""
Super Mario Bros Tile Mutator
Mutate sprites and tiles for creative visual effects.

NES Graphics Structure:
- Pattern tables store 8x8 tiles (16 bytes each)
- 2 bitplanes per tile (8 bytes each)
- CHR ROM contains all graphics data
"""

import sys
import random


class TileMutator:
    """Mutate and transform sprite tiles."""
    
    CHR_ROM_OFFSET = 0x8010
    TILE_SIZE = 16
    
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
            output_path = self.rom_path.replace('.nes', '_mutated.nes')
        
        try:
            with open(output_path, 'wb') as f:
                f.write(self.rom_data)
            print(f"[+] Saved modified ROM: {output_path}")
        except Exception as e:
            print(f"[!] Error saving ROM: {e}")
            sys.exit(1)
    
    def get_chr_rom_range(self):
        """Get the valid range for CHR ROM."""
        # CHR ROM typically starts at 0x8010 and goes to end of file
        # or until next section
        start = self.CHR_ROM_OFFSET
        # Assume CHR ROM is 8KB (0x2000 bytes) for SMB
        end = min(start + 0x2000, len(self.rom_data))
        return start, end
    
    def read_tile(self, tile_index):
        """Read a tile from CHR ROM."""
        start, end = self.get_chr_rom_range()
        offset = start + (tile_index * self.TILE_SIZE)
        
        if offset + self.TILE_SIZE > end:
            print(f"[!] Tile index out of range: {tile_index}")
            return None
        
        return bytearray(self.rom_data[offset:offset + self.TILE_SIZE])
    
    def write_tile(self, tile_index, tile_data):
        """Write a tile to CHR ROM."""
        if len(tile_data) != self.TILE_SIZE:
            print(f"[!] Invalid tile data size")
            return False
        
        start, end = self.get_chr_rom_range()
        offset = start + (tile_index * self.TILE_SIZE)
        
        if offset + self.TILE_SIZE > end:
            print(f"[!] Tile index out of range: {tile_index}")
            return False
        
        self.rom_data[offset:offset + self.TILE_SIZE] = tile_data
        return True
    
    def randomize_tile(self, tile_index):
        """Randomly mutate a tile."""
        print(f"\n[*] Randomizing tile {tile_index}...")
        tile_data = bytearray(random.randint(0, 255) for _ in range(self.TILE_SIZE))
        self.write_tile(tile_index, tile_data)
        print(f"[+] Tile {tile_index} randomized")
    
    def glitch_tile(self, tile_index):
        """Apply glitch effect to a tile."""
        print(f"\n[*] Glitching tile {tile_index}...")
        tile_data = self.read_tile(tile_index)
        if tile_data is None:
            return
        
        # Randomly flip some bits
        for i in range(len(tile_data)):
            if random.random() < 0.3:  # 30% chance to glitch each byte
                # Flip random bits
                mask = random.randint(1, 255)
                tile_data[i] ^= mask
        
        self.write_tile(tile_index, tile_data)
        print(f"[+] Tile {tile_index} glitched")
    
    def rotate_tile(self, tile_index, direction='cw'):
        """Rotate a tile 90 degrees."""
        print(f"\n[*] Rotating tile {tile_index} ({direction})...")
        tile_data = self.read_tile(tile_index)
        if tile_data is None:
            return
        
        # Extract bitplanes
        low_plane = tile_data[0:8]
        high_plane = tile_data[8:16]
        
        def rotate_plane(plane, cw=True):
            """Rotate an 8x8 bit plane."""
            # Convert to 2D array
            grid = []
            for byte in plane:
                row = [(byte >> (7 - i)) & 1 for i in range(8)]
                grid.append(row)
            
            # Rotate
            if cw:
                rotated = [[grid[7 - j][i] for j in range(8)] for i in range(8)]
            else:
                rotated = [[grid[j][7 - i] for j in range(8)] for i in range(8)]
            
            # Convert back to bytes
            result = []
            for row in rotated:
                byte = 0
                for i, bit in enumerate(row):
                    byte |= (bit << (7 - i))
                result.append(byte)
            
            return result
        
        cw = (direction == 'cw')
        rotated_low = rotate_plane(low_plane, cw)
        rotated_high = rotate_plane(high_plane, cw)
        
        rotated_tile = bytearray(rotated_low + rotated_high)
        self.write_tile(tile_index, rotated_tile)
        print(f"[+] Tile {tile_index} rotated")
    
    def flip_tile(self, tile_index, direction='horizontal'):
        """Flip a tile horizontally or vertically."""
        print(f"\n[*] Flipping tile {tile_index} ({direction})...")
        tile_data = self.read_tile(tile_index)
        if tile_data is None:
            return
        
        flipped = bytearray(self.TILE_SIZE)
        
        if direction == 'horizontal':
            # Flip each byte's bits
            for i in range(16):
                byte = tile_data[i]
                flipped[i] = int('{:08b}'.format(byte)[::-1], 2)
        
        elif direction == 'vertical':
            # Reverse row order in each plane
            for plane in range(2):
                offset = plane * 8
                for i in range(8):
                    flipped[offset + i] = tile_data[offset + 7 - i]
        
        else:
            print(f"[!] Unknown direction: {direction}")
            return
        
        self.write_tile(tile_index, flipped)
        print(f"[+] Tile {tile_index} flipped {direction}")
    
    def swap_tiles(self, tile1, tile2):
        """Swap two tiles."""
        print(f"\n[*] Swapping tiles {tile1} and {tile2}...")
        data1 = self.read_tile(tile1)
        data2 = self.read_tile(tile2)
        
        if data1 is None or data2 is None:
            return
        
        self.write_tile(tile1, data2)
        self.write_tile(tile2, data1)
        print(f"[+] Tiles swapped")
    
    def mutate_range(self, start, end, mutation_type='glitch'):
        """Mutate a range of tiles."""
        print(f"\n[*] Mutating tiles {start}-{end} with {mutation_type}...")
        count = 0
        
        for tile_index in range(start, end + 1):
            if mutation_type == 'glitch':
                self.glitch_tile(tile_index)
            elif mutation_type == 'random':
                self.randomize_tile(tile_index)
            elif mutation_type == 'invert':
                tile_data = self.read_tile(tile_index)
                if tile_data:
                    inverted = bytearray([~b & 0xFF for b in tile_data])
                    self.write_tile(tile_index, inverted)
            count += 1
        
        print(f"[+] Mutated {count} tiles")
    
    def psychedelic_mode(self):
        """Apply psychedelic mutations to various tiles."""
        print("\n[*] Applying psychedelic mode...")
        
        # Mutate random tiles
        start, end = self.get_chr_rom_range()
        num_tiles = (end - start) // self.TILE_SIZE
        
        # Mutate 20% of tiles randomly
        mutation_count = num_tiles // 5
        
        for _ in range(mutation_count):
            tile = random.randint(0, num_tiles - 1)
            mutation = random.choice(['glitch', 'rotate', 'flip'])
            
            if mutation == 'glitch':
                self.glitch_tile(tile)
            elif mutation == 'rotate':
                self.rotate_tile(tile, random.choice(['cw', 'ccw']))
            elif mutation == 'flip':
                self.flip_tile(tile, random.choice(['horizontal', 'vertical']))
        
        print(f"[+] Psychedelic mode applied!")


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Super Mario Bros Tile Mutator")
        print("=" * 40)
        print("\nUsage:")
        print("  python tile_mutator.py <rom_file> [options]")
        print("\nOptions:")
        print("  --randomize INDEX         Randomize tile")
        print("  --glitch INDEX            Glitch tile")
        print("  --rotate INDEX DIR        Rotate tile (cw/ccw)")
        print("  --flip INDEX DIR          Flip tile (horizontal/vertical)")
        print("  --swap INDEX1 INDEX2      Swap two tiles")
        print("  --mutate-range START END TYPE")
        print("                            Mutate tile range")
        print("                            TYPE: glitch, random, invert")
        print("  --psychedelic             Psychedelic mode!")
        print("\nExamples:")
        print("  python tile_mutator.py smb.nes --glitch 0")
        print("  python tile_mutator.py smb.nes --rotate 5 cw")
        print("  python tile_mutator.py smb.nes --flip 10 horizontal")
        print("  python tile_mutator.py smb.nes --mutate-range 0 20 glitch")
        print("  python tile_mutator.py smb.nes --psychedelic")
        sys.exit(0)
    
    rom_path = sys.argv[1]
    mutator = TileMutator(rom_path)
    
    modified = False
    
    if '--randomize' in sys.argv:
        idx = sys.argv.index('--randomize')
        tile = int(sys.argv[idx + 1])
        mutator.randomize_tile(tile)
        modified = True
    
    if '--glitch' in sys.argv:
        idx = sys.argv.index('--glitch')
        tile = int(sys.argv[idx + 1])
        mutator.glitch_tile(tile)
        modified = True
    
    if '--rotate' in sys.argv:
        idx = sys.argv.index('--rotate')
        tile = int(sys.argv[idx + 1])
        direction = sys.argv[idx + 2]
        mutator.rotate_tile(tile, direction)
        modified = True
    
    if '--flip' in sys.argv:
        idx = sys.argv.index('--flip')
        tile = int(sys.argv[idx + 1])
        direction = sys.argv[idx + 2]
        mutator.flip_tile(tile, direction)
        modified = True
    
    if '--swap' in sys.argv:
        idx = sys.argv.index('--swap')
        tile1 = int(sys.argv[idx + 1])
        tile2 = int(sys.argv[idx + 2])
        mutator.swap_tiles(tile1, tile2)
        modified = True
    
    if '--mutate-range' in sys.argv:
        idx = sys.argv.index('--mutate-range')
        start = int(sys.argv[idx + 1])
        end = int(sys.argv[idx + 2])
        mut_type = sys.argv[idx + 3]
        mutator.mutate_range(start, end, mut_type)
        modified = True
    
    if '--psychedelic' in sys.argv:
        mutator.psychedelic_mode()
        modified = True
    
    if modified:
        mutator.save_rom()


if __name__ == "__main__":
    main()
