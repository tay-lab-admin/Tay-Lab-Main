import subprocess
import os
import csv

# Returns a list of measurements for each image

def process_images(pipeline_filename, image_filenames, storage_folder, verbose = True):
	run_cellprofiler(pipeline_filename, image_filenames, storage_folder, verbose)
	return fetch_image_results(image_filenames, storage_folder)

def run_cellprofiler(pipeline_filename, image_filenames, storage_folder, verbose = True):
	# Create file list in temp folder
	fileListFilename = storage_folder + "/filelist"
	fileList = open(fileListFilename, 'w')
	for filename in image_filenames:
		print "Writing" + filename
		fileList.write(filename + "\n")
	fileList.close()

	arguments = ["cellprofiler", "-c", "-r"]
	arguments.extend(["-o", storage_folder])
	arguments.extend(["-p", pipeline_filename])
	arguments.extend(["--file-list", fileListFilename])

	if verbose:
		retcode = subprocess.check_output(arguments)
	else:
		outfile = open(storage_folder + "/log.txt", 'w')
		retcode = subprocess.check_output(arguments, stdout=outfile, stderr=outfile)
		outfile.close()

def fetch_image_results(image_filenames, storage_folder):
	results = [{}]*len(image_filenames)

	resultsFile = open(storage_folder + "/MyExpt_organoids.csv")
	resultsReader = csv.reader(resultsFile)
	header = resultsReader.next()

	for row in resultsReader:
		imageNumber = int(row[0])-1
		print "Checking image " + str(imageNumber)
		for i in range(len(header)):
			if header[i] in results[imageNumber]:
				results[imageNumber][header[i]].append(row[i])
			else:
				results[imageNumber][header[i]] = [row[i]]

	resultsFile.close()

	return results

def do_test():
	image_filenames = os.listdir("/Users/jonathanmatthews/Downloads/images")

	for i in range(len(image_filenames)):
		image_filenames[i] = "/Users/jonathanmatthews/Downloads/images/"+ image_filenames[i]

	storage_folder = "/Users/jonathanmatthews/Downloads/output"
	pipeline_filename = "/Users/jonathanmatthews/Downloads/organoids.cppipe"
	
	return process_images(pipeline_filename, image_filenames, storage_folder)

def main():
	image_filenames = []

	image_filenames.append("/Users/jonathanmatthews/Downloads/organoids/eg.tif")

	storage_folder = "/Users/jonathanmatthews/Downloads/output"
	pipeline_filename = "/Users/jonathanmatthews/Downloads/organoids.cppipe"
	
	print process_images(pipeline_filename, image_filenames, storage_folder)

if __name__ == "__main__":
	main()