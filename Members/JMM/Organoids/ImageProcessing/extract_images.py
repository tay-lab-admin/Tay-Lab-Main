import sys, getopt
import os
import numpy

def main(argv):
	nd2Filename = ''
	outputFolder = os.getcwd()
	zSlice = 0
	fov = 0

	try:
		opts, args = getopt.getopt(argv,"hi:o:z:f:")
	except getopt.GetoptError:
		print 'extract_images.py -i <nd2Filename> -o <outputFolder> -z <zSlice> -f <fov>'
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print 'extract_images.py -i <nd2Filename> -o <outputFolder> -z <zSlice> -f <fov>'
			sys.exit()
		elif opt in ("-i"):
			nd2Filename = arg
		elif opt in ("-o"):
			outputFolder = arg
		elif opt in ("-z"):
			zSlice = int(arg)
		elif opt in ("-f"):
			fov = int(arg)

	from nd2reader import ND2Reader
	from PIL import Image

	reader = ND2Reader(nd2Filename)
	parser = reader.parser

	# Get information about file

	frames = reader.metadata['frames']
	height = reader.metadata['height']
	width = reader.metadata['width']
	channels = reader.metadata['channels'][0]
				
	if not os.path.exists(outputFolder):
		os.makedirs(outputFolder)

	# Generate pngs
	if outputFolder[-1] not in ('/', '\\'):
		outputFolder = outputFolder + '/'

	for frame in frames:
		image_array = parser.get_image_by_attributes(frame, fov-1, channels, zSlice-1, height, width)

		export_filename = "%002d" % frame + ".tif"

		image_array = image_array.astype(numpy.uint16)

		image = Image.fromarray(image_array)
		image.save(outputFolder + export_filename)

if __name__ == "__main__":
	main(sys.argv[1:])