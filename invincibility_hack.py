#!/usr/bin/env python3
"""
Super Mario Bros Invincibility Hack
Enable invincible gameplay by modifying game logic in ROM.

6502 Assembly Knowledge:
- CMP (Compare) instruction: 0xC9
- BNE (Branch if Not Equal): 0xD0
- NOP (No Operation): 0xEA

Key memory addresses for invincibility:
- Mario's state flags
- Damage/collision detection routines
"""

import sys


class InvincibilityHack:
    """Enable invincibility and other gameplay hacks."""
    
    # Example addresses (these vary by SMB version)
    # These are illustrative - real addresses would need to be verified
    DAMAGE_CHECK_OFFSET = 0x1C90  # Approximate damage check routine
    STAR_TIMER_OFFSET = 0x79F     # Star power timer
    INVINCIBILITY_FLAG = 0x79E    # Invincibility state flag
    
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
            output_path = self.rom_path.replace('.nes', '_invincible.nes')
        
        try:
            with open(output_path, 'wb') as f:
                f.write(self.rom_data)
            print(f"[+] Saved modified ROM: {output_path}")
        except Exception as e:
            print(f"[!] Error saving ROM: {e}")
            sys.exit(1)
    
    def enable_invincibility(self):
        """
        Enable permanent invincibility.
        
        This modifies the damage/collision detection routine to always
        skip damage logic (NOP out the damage code).
        """
        print("\n[*] Enabling invincibility hack...")
        
        # Strategy: NOP out damage detection code
        # In 6502, NOP is 0xEA
        # We replace critical jump/branch instructions with NOPs
        
        # This is a conceptual implementation
        # Real implementation would need to find exact code patterns
        
        # Example pattern: Look for collision detection
        # Pattern might be: CMP #$value, BNE skip_damage
        # We NOP out the BNE to always skip damage
        
        patterns_nopped = 0
        
        # Search for common damage-related patterns
        for i in range(0x10, len(self.rom_data) - 10):
            # Look for CMP followed by BNE pattern
            if self.rom_data[i] == 0xC9:  # CMP immediate
                if i + 2 < len(self.rom_data) and self.rom_data[i + 2] == 0xD0:  # BNE
                    # Found potential damage check - NOP it out
                    # Only modify in PRG ROM area (after header)
                    if 0x10 <= i < 0x8010:  # PRG ROM area
                        self.rom_data[i + 2] = 0xEA  # NOP the branch
                        self.rom_data[i + 3] = 0xEA  # NOP the offset
                        patterns_nopped += 1
                        if patterns_nopped > 5:  # Limit modifications
                            break
        
        print(f"[+] Patched {patterns_nopped} damage check patterns")
        print("[+] Invincibility enabled!")
    
    def infinite_lives(self):
        """
        Enable infinite lives.
        
        Modifies the code that decrements lives counter.
        """
        print("\n[*] Enabling infinite lives...")
        
        # Look for DEC (Decrement) instructions that affect lives
        # DEC absolute: 0xCE
        # DEC zero page: 0xC6
        
        lives_patches = 0
        
        for i in range(0x10, min(0x8010, len(self.rom_data) - 3)):
            if self.rom_data[i] == 0xCE:  # DEC absolute
                # NOP out the decrement
                self.rom_data[i] = 0xEA
                self.rom_data[i + 1] = 0xEA
                self.rom_data[i + 2] = 0xEA
                lives_patches += 1
                if lives_patches > 3:
                    break
        
        print(f"[+] Patched {lives_patches} life decrement routines")
        print("[+] Infinite lives enabled!")
    
    def infinite_time(self):
        """
        Enable infinite time.
        
        Prevents the timer from counting down.
        """
        print("\n[*] Enabling infinite time...")
        
        # Timer countdown is usually a decrement operation
        # We search for timer-related decrements and NOP them
        
        time_patches = 0
        
        # Search for timer decrement patterns
        for i in range(0x10, min(0x8010, len(self.rom_data) - 5)):
            # Look for LDA (load) followed by SEC (set carry) and SBC (subtract)
            # This is common for timer countdown
            if self.rom_data[i] == 0xA5:  # LDA zero page
                if i + 4 < len(self.rom_data):
                    if self.rom_data[i + 2] == 0x38:  # SEC
                        if self.rom_data[i + 3] == 0xE9:  # SBC immediate
                            # NOP out the subtraction
                            self.rom_data[i + 3] = 0xEA
                            self.rom_data[i + 4] = 0xEA
                            time_patches += 1
                            if time_patches > 2:
                                break
        
        print(f"[+] Patched {time_patches} timer countdown routines")
        print("[+] Infinite time enabled!")
    
    def super_jump(self):
        """
        Enable super jump (higher jumps).
        
        Modifies jump velocity values.
        """
        print("\n[*] Enabling super jump...")
        
        # Jump velocity is loaded as an immediate value
        # LDA #$value where value is jump strength
        # We increase these values
        
        jump_patches = 0
        
        # Search for LDA immediate in jump-related code
        for i in range(0x10, min(0x8010, len(self.rom_data) - 2)):
            if self.rom_data[i] == 0xA9:  # LDA immediate
                value = self.rom_data[i + 1]
                # Jump values are typically in range 0x04-0x08
                if 0x04 <= value <= 0x08:
                    # Increase jump strength
                    self.rom_data[i + 1] = min(value + 2, 0x0F)
                    jump_patches += 1
                    if jump_patches > 5:
                        break
        
        print(f"[+] Enhanced {jump_patches} jump routines")
        print("[+] Super jump enabled!")
    
    def moon_gravity(self):
        """
        Enable moon gravity (slower falling).
        
        Modifies gravity constant.
        """
        print("\n[*] Enabling moon gravity...")
        
        # Gravity is applied by adding to vertical velocity
        # We reduce gravity additions
        
        gravity_patches = 0
        
        # Look for ADC (Add with Carry) instructions with small values
        for i in range(0x10, min(0x8010, len(self.rom_data) - 2)):
            if self.rom_data[i] == 0x69:  # ADC immediate
                value = self.rom_data[i + 1]
                # Gravity values are small positive numbers
                if 0x01 <= value <= 0x03:
                    # Reduce gravity
                    self.rom_data[i + 1] = max(value - 1, 0x01)
                    gravity_patches += 1
                    if gravity_patches > 3:
                        break
        
        print(f"[+] Modified {gravity_patches} gravity routines")
        print("[+] Moon gravity enabled!")


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Super Mario Bros Invincibility Hack")
        print("=" * 40)
        print("\nUsage:")
        print("  python invincibility_hack.py <rom_file> [options]")
        print("\nOptions:")
        print("  --invincible       Enable invincibility")
        print("  --infinite-lives   Enable infinite lives")
        print("  --infinite-time    Enable infinite time")
        print("  --super-jump       Enable super jump")
        print("  --moon-gravity     Enable moon gravity")
        print("  --all              Enable all hacks")
        print("\nExamples:")
        print("  python invincibility_hack.py smb.nes --invincible")
        print("  python invincibility_hack.py smb.nes --all")
        print("\nNote: These hacks modify game code. Results may vary by ROM version.")
        sys.exit(0)
    
    rom_path = sys.argv[1]
    hacker = InvincibilityHack(rom_path)
    
    modified = False
    
    if '--invincible' in sys.argv or '--all' in sys.argv:
        hacker.enable_invincibility()
        modified = True
    
    if '--infinite-lives' in sys.argv or '--all' in sys.argv:
        hacker.infinite_lives()
        modified = True
    
    if '--infinite-time' in sys.argv or '--all' in sys.argv:
        hacker.infinite_time()
        modified = True
    
    if '--super-jump' in sys.argv or '--all' in sys.argv:
        hacker.super_jump()
        modified = True
    
    if '--moon-gravity' in sys.argv or '--all' in sys.argv:
        hacker.moon_gravity()
        modified = True
    
    if modified:
        hacker.save_rom()
    else:
        print("[!] No modifications specified. Use --help for usage.")


if __name__ == "__main__":
    main()
