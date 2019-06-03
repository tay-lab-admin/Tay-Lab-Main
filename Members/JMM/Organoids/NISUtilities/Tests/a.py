# Full path and name of the first .ND2 file.
# Copy and paste the above line for each other .ND2 file needed. Remember the
# order should match the columns of the .CSV file.

### SCRIPT BELOW

from nd2reader import ND2Reader
from PIL import Image
import matplotlib.pyplot as plt
import os
import csv
import numpy
import ntpath

def calculate_focus(image, percent_cutoff):
	fft_image = numpy.absolute(numpy.fft.fftshift(numpy.fft.fft2(image_1_array)))
	fft_image.flatten()
	return fft_image

reader = ND2Reader('/Volumes/VariousMembers/Brooke/20170509 Pancreatic Organoid Exp 2/20170514ORGANOID008.nd2')
image_1_array = reader.parser.get_image_by_attributes(1, 158, u'bf', 1, 1022, 1024).astype(numpy.uint16)
image_2_array = reader.parser.get_image_by_attributes(1, 158, u'bf', 4, 1022, 1024).astype(numpy.uint16)

plt.figure(1)

plt.subplot(211)
plt.plot(calculate_focus(image_1_array, 90))

plt.subplot(212)
plt.plot(calculate_focus(image_2_array, 90))

plt.show()
