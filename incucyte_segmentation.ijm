//specify input and output folders
input = "D:/Fiji/input/";
output = "D:/Fiji/output/";

//bulk of the work to segment and locate cells within incucyte images
function segment(input, output, filename) {
	open(input + filename);
	run("Morphological Filters", "operation=Laplacian element=Square radius=2");
	run("32-bit");
	run("PHANTAST", "sigma=1.20 epsilon=0.03 do new");
	run("Morphological Filters", "operation=Opening element=Square radius=3");
	selectWindow(filename);
	run("Add Image...", "image=PHANTAST-Opening x=0 y=0 opacity=100");
	run("Create Mask");
	run("Analyze Particles...", "size=10-10000 display clear summarize add");
	roiManager("Measure");
	roiManager("List");

	//save list of located cells to output folder
	saveAs("Results", output + filename + "_positions.csv");
}


// Closes the "Results" and "Log" windows and all image windows
function cleanUp() {
    requires("1.30e");
    if (isOpen("Results")) {
         selectWindow("Results"); 
         run("Close" );
    {
    if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );
    }
    while (nImages()>0) {
          selectImage(nImages());  
          run("Close");
    }
}


list = getFileList(input);

//batchMode enabled is safer for in-order execution
setBatchMode(true); 

//apply function to all files in input folder
for (i = 0; i < list.length; i++){
        segment(input, output, list[i]);
        cleanUp();
}