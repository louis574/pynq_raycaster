import numpy as np
from PIL import Image

raw = open("C:/Users/louja/Desktop/Imperial_2/IP/pynq_raycaster/ray_caster/raycaster_block_dev/raycaster_ip_development/raycaster_ip_development.sim/sim_1/behav/xsim/frame.csv").read().split()

pixels = [p for p in raw if p in ('0', '1', '2', '3')]
print(f"Got {len(pixels)} total pixels ({len(pixels) // (720*720)} full frames)")

colour_map = {
    '0': (255, 255, 255),
    '1': (210, 210, 210),
    '2': (0,   128, 0  ),
    '3': (135, 206, 235),
}

frame_size = 720 * 720

for frame_num in range(4):
    frame_pixels = pixels[frame_num * frame_size : (frame_num + 1) * frame_size]
    if len(frame_pixels) < frame_size:
        print(f"Frame {frame_num + 1}: not enough pixels ({len(frame_pixels)}), skipping")
        continue
    print(f"Frame {frame_num + 1} unique values: {set(frame_pixels)}")
    print(f"Frame {frame_num + 1} wall pixel count: {frame_pixels.count('0') + frame_pixels.count('1')}")
    rgb = [colour_map[p] for p in frame_pixels]
    img = np.array(rgb, dtype=np.uint8).reshape(720, 720, 3)
    path = rf"C:/Users/louja/Desktop/Imperial_2/IP/pynq_raycaster/ray_caster/raycaster_block_dev/raycaster_ip_development/frame{frame_num + 1}.png"
    Image.fromarray(img).save(path)
    print(f"Saved frame{frame_num + 1}.png")