#!/usr/bin/env python3
"""
Super Mario Bros NES Emulator
Integrated NES emulator to test ROM modifications.

This is a simplified emulator framework that provides basic functionality
for loading and displaying ROM information. For full emulation, consider
using external emulators like FCEUX, Nestopia, or Mesen.

Note: Full NES emulation requires implementing:
- 6502 CPU emulation
- PPU (Picture Processing Unit)
- APU (Audio Processing Unit)
- Input handling
- Memory management
"""

import sys
import struct


class NESEmulator:
    """Basic NES ROM loader and information display."""
    
    # iNES header format (16 bytes)
    INES_HEADER_SIZE = 16
    INES_MAGIC = b'NES\x1a'
    
    def __init__(self, rom_path):
        """Initialize with ROM file path."""
        self.rom_path = rom_path
        self.rom_data = None
        self.header = None
        self.prg_rom = None
        self.chr_rom = None
        self.load_rom()
    
    def load_rom(self):
        """Load and parse NES ROM file."""
        try:
            with open(self.rom_path, 'rb') as f:
                self.rom_data = f.read()
            print(f"[+] Loaded ROM: {self.rom_path} ({len(self.rom_data)} bytes)")
            self.parse_header()
        except FileNotFoundError:
            print(f"[!] Error: ROM file not found: {self.rom_path}")
            sys.exit(1)
        except Exception as e:
            print(f"[!] Error loading ROM: {e}")
            sys.exit(1)
    
    def parse_header(self):
        """Parse iNES header."""
        if len(self.rom_data) < self.INES_HEADER_SIZE:
            print("[!] Error: File too small to be a valid NES ROM")
            sys.exit(1)
        
        # Check magic number
        magic = self.rom_data[0:4]
        if magic != self.INES_MAGIC:
            print(f"[!] Error: Invalid NES ROM header (magic: {magic})")
            sys.exit(1)
        
        # Parse header fields
        self.header = {
            'prg_rom_size': self.rom_data[4] * 16384,  # 16KB units
            'chr_rom_size': self.rom_data[5] * 8192,   # 8KB units
            'flags6': self.rom_data[6],
            'flags7': self.rom_data[7],
            'prg_ram_size': self.rom_data[8] * 8192,   # 8KB units
            'flags9': self.rom_data[9],
            'flags10': self.rom_data[10],
        }
        
        # Extract mapper number
        mapper_low = (self.header['flags6'] & 0xF0) >> 4
        mapper_high = self.header['flags7'] & 0xF0
        self.header['mapper'] = mapper_high | mapper_low
        
        # Extract mirroring
        self.header['mirroring'] = 'Vertical' if (self.header['flags6'] & 0x01) else 'Horizontal'
        self.header['has_battery'] = bool(self.header['flags6'] & 0x02)
        self.header['has_trainer'] = bool(self.header['flags6'] & 0x04)
        
        # Extract ROM data
        offset = self.INES_HEADER_SIZE
        if self.header['has_trainer']:
            offset += 512  # Skip trainer
        
        prg_size = self.header['prg_rom_size']
        chr_size = self.header['chr_rom_size']
        
        self.prg_rom = self.rom_data[offset:offset + prg_size]
        offset += prg_size
        
        if chr_size > 0:
            self.chr_rom = self.rom_data[offset:offset + chr_size]
        else:
            self.chr_rom = None  # CHR RAM
        
        print("[+] ROM parsed successfully")
    
    def display_info(self):
        """Display ROM information."""
        if self.header is None:
            print("[!] No ROM loaded")
            return
        
        print("\n" + "=" * 50)
        print("NES ROM Information")
        print("=" * 50)
        print(f"ROM File: {self.rom_path}")
        print(f"Total Size: {len(self.rom_data)} bytes")
        print(f"\nPRG ROM Size: {self.header['prg_rom_size']} bytes ({self.header['prg_rom_size'] // 1024} KB)")
        print(f"CHR ROM Size: {self.header['chr_rom_size']} bytes ({self.header['chr_rom_size'] // 1024} KB)")
        
        if self.header['chr_rom_size'] == 0:
            print("  (Uses CHR RAM)")
        
        print(f"PRG RAM Size: {self.header['prg_ram_size']} bytes")
        print(f"\nMapper: {self.header['mapper']}")
        print(f"Mirroring: {self.header['mirroring']}")
        print(f"Battery: {'Yes' if self.header['has_battery'] else 'No'}")
        print(f"Trainer: {'Yes' if self.header['has_trainer'] else 'No'}")
        
        # Display some PRG ROM info
        if self.prg_rom:
            print(f"\nPRG ROM Data:")
            print(f"  First 16 bytes: {' '.join(f'{b:02X}' for b in self.prg_rom[:16])}")
            print(f"  Last 16 bytes:  {' '.join(f'{b:02X}' for b in self.prg_rom[-16:])}")
        
        # Display some CHR ROM info
        if self.chr_rom:
            print(f"\nCHR ROM Data:")
            print(f"  First 16 bytes: {' '.join(f'{b:02X}' for b in self.chr_rom[:16])}")
        
        print("=" * 50)
    
    def verify_rom(self):
        """Verify ROM integrity."""
        print("\n[*] Verifying ROM integrity...")
        
        issues = []
        
        # Check size
        expected_size = (self.INES_HEADER_SIZE + 
                        self.header['prg_rom_size'] + 
                        self.header['chr_rom_size'])
        
        if self.header['has_trainer']:
            expected_size += 512
        
        if len(self.rom_data) < expected_size:
            issues.append(f"ROM file is smaller than expected ({len(self.rom_data)} < {expected_size})")
        
        # Check for common issues
        if self.header['mapper'] > 255:
            issues.append(f"Invalid mapper number: {self.header['mapper']}")
        
        if self.header['prg_rom_size'] == 0:
            issues.append("PRG ROM size is 0")
        
        if issues:
            print("[!] ROM verification found issues:")
            for issue in issues:
                print(f"    - {issue}")
        else:
            print("[+] ROM verification passed")
        
        return len(issues) == 0
    
    def extract_prg_rom(self, output_path):
        """Extract PRG ROM to a file."""
        try:
            with open(output_path, 'wb') as f:
                f.write(self.prg_rom)
            print(f"[+] PRG ROM extracted to: {output_path}")
        except Exception as e:
            print(f"[!] Error extracting PRG ROM: {e}")
    
    def extract_chr_rom(self, output_path):
        """Extract CHR ROM to a file."""
        if self.chr_rom is None:
            print("[!] ROM uses CHR RAM, no CHR ROM to extract")
            return
        
        try:
            with open(output_path, 'wb') as f:
                f.write(self.chr_rom)
            print(f"[+] CHR ROM extracted to: {output_path}")
        except Exception as e:
            print(f"[!] Error extracting CHR ROM: {e}")
    
    def launch_external_emulator(self, emulator='fceux'):
        """
        Launch ROM in external emulator.
        
        Note: Requires external emulator to be installed.
        """
        import subprocess
        
        print(f"\n[*] Launching {emulator}...")
        
        emulators = {
            'fceux': ['fceux', self.rom_path],
            'nestopia': ['nestopia', self.rom_path],
            'mesen': ['mesen', self.rom_path],
        }
        
        if emulator not in emulators:
            print(f"[!] Unknown emulator: {emulator}")
            print(f"    Available: {', '.join(emulators.keys())}")
            return
        
        try:
            subprocess.Popen(emulators[emulator])
            print(f"[+] Launched {emulator}")
        except FileNotFoundError:
            print(f"[!] Emulator not found: {emulator}")
            print(f"    Please install {emulator} to use this feature")
        except Exception as e:
            print(f"[!] Error launching emulator: {e}")


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Super Mario Bros NES Emulator")
        print("=" * 40)
        print("\nUsage:")
        print("  python nes_emulator.py <rom_file> [options]")
        print("\nOptions:")
        print("  --info               Display ROM information")
        print("  --verify             Verify ROM integrity")
        print("  --extract-prg PATH   Extract PRG ROM")
        print("  --extract-chr PATH   Extract CHR ROM")
        print("  --launch EMULATOR    Launch in external emulator")
        print("                       (fceux, nestopia, mesen)")
        print("\nExamples:")
        print("  python nes_emulator.py smb.nes --info")
        print("  python nes_emulator.py smb.nes --verify")
        print("  python nes_emulator.py smb.nes --extract-prg prg.bin")
        print("  python nes_emulator.py smb.nes --launch fceux")
        print("\nNote: Full emulation requires external emulator software.")
        sys.exit(0)
    
    rom_path = sys.argv[1]
    emulator = NESEmulator(rom_path)
    
    if len(sys.argv) == 2 or '--info' in sys.argv:
        emulator.display_info()
    
    if '--verify' in sys.argv:
        emulator.verify_rom()
    
    if '--extract-prg' in sys.argv:
        idx = sys.argv.index('--extract-prg')
        output = sys.argv[idx + 1]
        emulator.extract_prg_rom(output)
    
    if '--extract-chr' in sys.argv:
        idx = sys.argv.index('--extract-chr')
        output = sys.argv[idx + 1]
        emulator.extract_chr_rom(output)
    
    if '--launch' in sys.argv:
        idx = sys.argv.index('--launch')
        emu_name = sys.argv[idx + 1]
        emulator.launch_external_emulator(emu_name)


if __name__ == "__main__":
    main()
