import sys
import subprocess
import os
import matplotlib.pyplot as plt
import re
from PIL import Image
import numpy as np

def install(package):
	subprocess.call([sys.executable, "-m", "pip", "install", package])

try:
	import tkinter
except ImportError:
	install('tkinter')
	import tkinter

import tkinter.filedialog

try:
	import nd2reader
except ImportError:
	install('nd2reader')
	import nd2reader


class ND2File:
	def __init__(self, filename=None):
		if filename == None:
			tkinter.Tk().withdraw()
			filename = tkinter.filedialog.askopenfilename(title="Select a ND2 file", filetypes=[("Nikon Elements File" ,"*.nd2"), ("TIFF File", "*.tif")])
		self.filename = filename
		if self.filename.split('.')[-1] == 'tif':
			self.type = 'TIF'
			self._initTIF()
		else:
			self.type = 'ND2'
			self._initND2()

	def _initND2(self):
		self.reader = nd2reader.ND2Reader(self.filename)
		self.positionCount = float(len(self.reader.metadata['fields_of_view']))
		self.timepointCount = float(len(self.reader.metadata['frames']))
		self.zLevelCount = float(len(self.reader.metadata['z_levels']))
		self.channels = self.reader.metadata['channels']
		self.micronsPerPixel = self.reader.metadata['pixel_microns']
		self.experimentDurationSeconds = float(self.reader.metadata['experiment']['loops'][0]['duration']/1000)
		self.timepointIntervalSeconds = float(self.reader.metadata['experiment']['loops'][0]['sampling_interval']/1000)
		self.height = float(self.reader.metadata['height'])
		self.width = float(self.reader.metadata['width'])

		self.position_names = []
		points = self.reader.parser._raw_metadata.image_metadata[b'SLxExperiment'][b'ppNextLevelEx'][b''][b'uLoopPars'][b'Points'][b'']
		for point in points:
			self.position_names.append(point[b'dPosName'].decode('UTF-8'))


	def _initTIF(self):
		self.directory = os.path.dirname(self.filename)
		filename = os.path.basename(self.filename)
		files = os.listdir(self.directory)

		self.position_names = []
		self.zLevelCount = None
		self.timepoints = []
		self.channels = []
		self.micronsPerPixel = None
		self.experimentDurationSeconds = None
		self.timepointIntervalSeconds = None

		for file in files:
			metadata = self.ParseTIFName(file)
			if metadata != None:
				if not metadata['positionName'] in self.position_names:
					self.position_names.append(metadata['positionName'])
				if not metadata['timepoint'] in self.timepoints:
					self.timepoints.append(metadata['timepoint'])
				if not metadata['channel'] in self.channels:
					self.channels.append(metadata['channel'])
				self.timepointDigits = metadata['timepointDigits']
				self.channelDigits = metadata['channelDigits']
				self.setName = metadata['setName']

		self.timepointCount = len(self.timepoints)
		self.positionCount = len(self.position_names)
		image = self.GetImage(0, 0)
		(self.height, self.width) = image.shape

	def ParseTIFName(self, filename):
		pattern = re.compile('(.*)t(\d+)(.*)c(\d+)\.tif')
		match = pattern.match(filename)
		if match == None:
			return None
		metadata = {}
		metadata['setName'] = match.group(1)
		metadata['timepoint'] = int(match.group(2))
		metadata['timepointDigits'] = len(match.group(2))
		metadata['positionName'] = match.group(3)
		metadata['channel'] = int(match.group(4))
		metadata['channelDigits'] = len(match.group(4))
		
		return metadata

	def GetImage(self, positionIndex, timepointIndex, channelIndex=0, zLevel=0):
		if self.type == 'TIF':
			return self._GetTIFImage(positionIndex, timepointIndex, channelIndex, zLevel)
		else:
			return self._GetND2Image(positionIndex, timepointIndex, channelIndex, zLevel)

	def _GetND2Image(self, positionIndex, timepointIndex, channelIndex, zLevel):
		if positionIndex >= self.positionCount:
			raise Exception('Position index out of range.')
		if timepointIndex >= self.timepointCount:
			raise Exception('Timepoint index out of range.')
		if channelIndex >= len(self.channels):
			raise Exception('Channel index out of range.')
		if zLevel != 0 and zLevel >= self.zLevelCount:
			raise Exception('Z-level index out of range.')

		return self.reader.parser.get_image_by_attributes(
			frame_number = int(timepointIndex),
			field_of_view = int(positionIndex),
			channel_name = self.channels[int(channelIndex)],
			z_level = int(zLevel),
			height = int(self.height),
			width = int(self.width))

	def _GetTIFImage(self, positionIndex, timepointIndex, channelIndex, zLevel):
		if positionIndex >= self.positionCount:
			raise Exception('Position index out of range.')
		if timepointIndex >= self.timepointCount:
			raise Exception('Timepoint index out of range.')
		if channelIndex >= len(self.channels):
			raise Exception('Channel index out of range.')

		timepointString = ('t%0' + str(self.timepointDigits) + 'd') % self.timepoints[timepointIndex]
		positionString = self.position_names[positionIndex]
		channelString = ('c%0' + str(self.channelDigits) + 'd') % self.channels[channelIndex]

		filename = self.setName + timepointString + positionString + channelString + '.tif'
		fullpath = os.path.join(self.directory + '/', filename)

		print('Opening ' + fullpath + '\n')
		image = Image.open(fullpath)
		return np.array(image)