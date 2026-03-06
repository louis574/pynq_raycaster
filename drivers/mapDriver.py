from pynq import Overlay, MMIO
import json

class RaycasterOverlay:
    
    BRAM_BASE_ADDR = 0x40000000
    BRAM_RANGE = 0x2000
    MAP_ROWS = 32
    # map occupies 0x00–0x7C (32 words * 4 bytes), player state starts at 0x80
    PLAYER_POS_OFFSET = 0x80   # [31:16] = x (Q6.10), [15:0] = y (Q6.10)
    PLAYER_ANGLE_OFFSET = 0x84 # [11:0] = angle, 0x000=0deg, 0xFFF=360deg, anticlockwise from east
    
    def __init__(self, bitfile="raycaster.bit"):
        self.ol = Overlay(bitfile)
        self.bram = MMIO(self.BRAM_BASE_ADDR, self.BRAM_RANGE)
    
    # write all 32 map rows into BRAM
    def load_map(self, map_data):
        if isinstance(map_data[0], list):
            map_data = self._encode_map(map_data)
        assert len(map_data) == self.MAP_ROWS, f"Expected 32 rows, got {len(map_data)}"
        for row, word in enumerate(map_data):
            self.bram.write(row * 4, int(word) & 0xFFFFFFFF)
    
    # read back all 32 rows as list of ints
    def read_map(self):
        return [self.bram.read(row * 4) for row in range(self.MAP_ROWS)]
    
    # returns True if BRAM readback matches written map
    def verify_map(self, map_data):
        if isinstance(map_data[0], list):
            map_data = self._encode_map(map_data)
        return self.read_map() == list(map_data)
    
    # load map from raw JSON string received from AWS
    def load_from_json(self, payload: str):
        map_data = json.loads(payload)
        self.load_map(map_data)
    
    # write player position — x and y are Q6.10 fixed-point ints
    def set_player_pos(self, x_q610, y_q610):
        word = ((x_q610 & 0xFFFF) << 16) | (y_q610 & 0xFFFF)
        self.bram.write(self.PLAYER_POS_OFFSET, word)
    
    # write player angle — raw 12-bit value, 0x000=0deg east, 0xFFF=360deg, anticlockwise
    def set_player_angle(self, angle_raw):
        self.bram.write(self.PLAYER_ANGLE_OFFSET, int(angle_raw) & 0xFFF)
    
    # write both position and angle in one call
    def set_player(self, x_q610, y_q610, angle_raw):
        self.set_player_pos(x_q610, y_q610)
        self.set_player_angle(angle_raw)
    
    # read back player position as tuple of raw Q6.10 ints (x, y)
    def read_player_pos(self):
        word = self.bram.read(self.PLAYER_POS_OFFSET)
        return (word >> 16) & 0xFFFF, word & 0xFFFF
    
    # read back raw 12-bit angle value
    def read_player_angle(self):
        return self.bram.read(self.PLAYER_ANGLE_OFFSET) & 0xFFF
    
    # pack 32x32 grid of 0/1 into 32 x 32-bit words, LSB = column 0
    def _encode_map(self, grid):
        words = []
        for row in grid:
            word = 0
            for col, tile in enumerate(row):
                if tile:
                    word |= (1 << col)
            words.append(word)
        return words
    
    # print map as ASCII for debug, # = wall, . = empty
    def print_map(self):
        for word in self.read_map():
            print(''.join('#' if (word >> col) & 1 else '.' for col in range(32)))