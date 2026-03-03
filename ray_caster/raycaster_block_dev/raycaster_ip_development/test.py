raw = open("C:/Users/louja/Desktop/Imperial_2/IP/pynq_raycaster/ray_caster/raycaster_block_dev/raycaster_ip_development/raycaster_ip_development.sim/sim_1/behav/xsim/frame.csv").read().split()
print(f"Total values: {len(raw)}")
print(f"Unique values: {set(raw)}")
print(f"First 20: {raw[:20]}")