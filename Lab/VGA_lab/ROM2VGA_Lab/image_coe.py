import numpy as np
from PIL import Image

# 1
image = Image.open("C:\\Users\\88697\\Desktop\\Xilinx\\0.Lab\\VGA_Lab\\mm.jpg")
image_array = np.array(image)

# 2
height, width, _ = image_array.shape

# 3
red = image_array[:,:,0]
green = image_array[:,:,1]
blue = image_array[:,:,2]

# 4
red_4bit = (red >> 4).astype(np.uint32)
green_4bit = (green >> 4).astype(np.uint32)
blue_4bit = (blue >> 4).astype(np.uint32)

# 5
rgb = (red_4bit << 8) + (green_4bit << 4) + blue_4bit

# 6
coe_content = "memory_initialization_radix=16;\nmemory_initialization_vector=\n"

#7
for i in range(height * width - 1):
    coe_content += "{:03X},\n".format(rgb.flatten()[i])

#8
coe_content += "{:03X};".format(rgb.flatten()[-1])

#9
with open("mm.coe", "w") as f:
    f.write(coe_content)
    
print("Sucessful")

