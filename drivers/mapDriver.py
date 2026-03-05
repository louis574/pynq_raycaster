from pynq import Overlay, MMIO
import json

class RaycasterOverlay:
    
    BRAM_BASE_ADDR = 0x40000000
    BRAM_RANGE = 0x2000  # 8K
    MAP_ROWS = 32
    
    def __init__(self, bitfile="raycaster.bit"):
        self.ol = Overlay(bitfile)
        self.bram = MMIO(self.BRAM_BASE_ADDR, self.BRAM_RANGE)
    
    def load_map(self, map_data):
        """
        Accepts either:
        - list of 32 ints (pre-encoded, one 32-bit word per row)
        - 32x32 list of lists (0/1 tiles, will be bit-packed)
        """
        if isinstance(map_data[0], list):
            map_data = self._encode_map(map_data)
        
        assert len(map_data) == self.MAP_ROWS, f"Expected 32 rows, got {len(map_data)}"
        
        for row, word in enumerate(map_data):
            self.bram.write(row * 4, int(word) & 0xFFFFFFFF)
    
    def read_map(self):
        """Read back all 32 rows as list of ints"""
        return [self.bram.read(row * 4) for row in range(self.MAP_ROWS)]
    
    def verify_map(self, map_data):
        """Returns True if readback matches what was written"""
        if isinstance(map_data[0], list):
            map_data = self._encode_map(map_data)
        return self.read_map() == list(map_data)
    
    def load_from_json(self, payload: str):
        """Load map from JSON string received from AWS"""
        map_data = json.loads(payload)
        self.load_map(map_data)
    
    def _encode_map(self, grid):
        """Pack 32x32 grid of 0/1 into 32 x 32-bit words, LSB = column 0"""
        words = []
        for row in grid:
            word = 0
            for col, tile in enumerate(row):
                if tile:
                    word |= (1 << col)
            words.append(word)
        return words
    
    def print_map(self):
        """Debug helper — prints map as ASCII"""
        for word in self.read_map():
            print(''.join('#' if (word >> col) & 1 else '.' for col in range(32)))