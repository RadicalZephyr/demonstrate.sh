import time
import sys
import random

line = ' '.join(sys.argv[1:])
seconds = 0.1

i = 0
for char in line:
    sys.stdout.write(char)
    sys.stdout.flush()
    if (i % 3) == 0:
        if random.choice([True, False]):
            seconds = 0.25
        else:
            seconds = 0.15
    time.sleep(seconds)
    seconds += random.uniform(0.0, 0.05) - 0.025
