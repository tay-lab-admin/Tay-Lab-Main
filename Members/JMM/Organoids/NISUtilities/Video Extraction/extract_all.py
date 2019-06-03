"""

This script is used to generate .AVI videos from .nd2 files.

Required libraries:

ND2Reader (pip install nd2reader)
matplotlib (pip install matplotlib)
Pillow (pip install Pillow)

-------

Inputs: 

- One .nd2 files.
- Output folder.
- A Z slice for the .nd2 file to make the image for (default is 1)
- A list of color channels to make the image for (default is '' to use all channels)
- A framerate to use

Outputs:

For each XY field of view, a .mp4 file is created (within the supplied output 
folder path) 

-------

Author: Jonathan Matthews
Date Created: 07/07/2017
Last Modified: 07/07/2017

"""

### Input Parameters

# Full path to output folder (include slash at the end)
outputFolder = "/Users/jonathanmatthews/Downloads/"

# Full path to the nd2 file
nd2Filename = '/Volumes/VariousMembers/Brooke/20170509 Pancreatic Organoid Exp 2/20170508ORGANOID001.nd2'

# Z slice to use for the video (if there is only one Z slice in your .nd2 file,
# just set this to 1)
z_slice = 3

# Color channel. Set to '' to use all channels.
color_channels = ''

# Framerate. default is 3
framerate = 3

### SCRIPT BELOW

from nd2reader import ND2Reader
from PIL import Image
import os
import numpy
import imageio
import subprocess

reader = ND2Reader(nd2Filename)
parser = reader.parser

# Get information about file

frames = reader.metadata['frames']
height = reader.metadata['height']
width = reader.metadata['width']
fovs = reader.metadata['fields_of_view']
channels = reader.metadata['channels']

if color_channels == '':
	color_channels = channels[0]

print fovs

# Generate pngs
for fov in fovs:
	destination_folder = outputFolder + "nisOutput"
				
	if not os.path.exists(destination_folder):
		os.makedirs(destination_folder)

	frame = frames[0]

	image_array = parser.get_image_by_attributes(frame, fov, color_channels, z_slice-1, height, width)

	export_filename = "%003d" % fov + ".tif"

	image_array = image_array.astype(numpy.uint16)

	image = Image.fromarray(image_array)
	image.save(destination_folder + "/" + export_filename)

	# # Generate video from pngs
	# current = os.getcwd()
	# os.chdir(destination_folder)
	# subprocess.call(['ffmpeg', '-framerate', str(framerate), '-i', '%d.tif', '-y', '-r', str(framerate), '-pix_fmt', 'yuv420p', str(fov) + '.mp4'])
	# os.chdir(current)