#!/usr/bin/env python3
"""
Generate 360/perpDist LUT for DDA raycaster wall strip half-heights.

Input:  12-bit unsigned index (perp_dist[15:4] from a Q6.10 distance)
Output:  9-bit unsigned integer (half-strip pixel height, clamped to 360)

Entry 0: saturated to MAX_OUTPUT (distance would be zero)

Verilog usage:
    wire [15:0] perp_dist  = ...;              // Q6.10 distance
    wire [11:0] idx        = perp_dist[15:4];  // top 12 bits as LUT index
    wire [8:0]  half_strip = bar_height_lut[idx];
    wire [9:0]  draw_start = 10'd360 - {1'b0, half_strip};
    wire [9:0]  draw_end   = 10'd360 + {1'b0, half_strip};
"""

INPUT_SCALE      = 64         # step = 2^4 / 2^10 = 1/64 real units
MAX_OUTPUT       = 360
LUT_SIZE         = 4096       # 2^12

lut = []
for i in range(LUT_SIZE):
    if i == 0:
        lut.append(MAX_OUTPUT)
    else:
        real_dist = i / INPUT_SCALE
        val = int(round(360.0 / real_dist))
        lut.append(min(val, MAX_OUTPUT))

# ── Output formats ────────────────────────────────────────────────────────────
def write_c_header(lut, path="bar_height_lut.h"):
    with open(path, "w") as f:
        f.write("/* 360/perpDist LUT  —  Q6.10 input (12-bit index), 9-bit integer output */\n\n")
        f.write(f"#define BAR_HEIGHT_LUT_SIZE {LUT_SIZE}\n\n")
        f.write("static const uint16_t bar_height_lut[BAR_HEIGHT_LUT_SIZE] = {\n")
        for j in range(0, LUT_SIZE, 8):
            row = lut[j:j+8]
            f.write("    " + ", ".join(f"{v:5d}" for v in row) + ",\n")
        f.write("};\n")
    print(f"Written: {path}")

def write_mem_hex(lut, path="bar_height_lut.mem"):
    with open(path, "w") as f:
        for v in lut:
            f.write(f"{v:03X}\n")
    print(f"Written: {path}")

def write_coe(lut, path="bar_height_lut.coe"):
    with open(path, "w") as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        for i, v in enumerate(lut):
            sep = "," if i < len(lut) - 1 else ";"
            f.write(f"{v:03X}{sep}\n")
    print(f"Written: {path}")

write_c_header(lut, "bar_height_lut.h")
write_mem_hex(lut,  "bar_height_lut.mem")
write_coe(lut,      "bar_height_lut.coe")

# ── Sanity checks ─────────────────────────────────────────────────────────────
print(f"\n{'label':>25}  {'idx':>5}  {'lut_val':>7}  {'expected':>9}  {'error':>8}")
print("-" * 70)
tests = [
    (0.5,  "very close (0.5)"),
    (1.0,  "unit distance (1.0)"),
    (2.0,  "mid distance (2.0)"),
    (5.0,  "far distance (5.0)"),
    (10.0, "very far (10.0)"),
    (63.0, "max Q6.10 dist (63.0)"),
    (0.0,  "zero (clamped)"),
]
for dist_real, label in tests:
    idx      = min(int(dist_real * INPUT_SCALE), LUT_SIZE - 1)
    lut_val  = lut[idx]
    expected = min(360.0 / dist_real, MAX_OUTPUT) if dist_real > 0 else MAX_OUTPUT
    error    = abs(lut_val - expected) / expected * 100 if dist_real > 0 else 0
    print(f"  {label:25s}  {idx:5d}  {lut_val:7d}  {expected:9.3f}  {error:7.3f}%")