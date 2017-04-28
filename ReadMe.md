RN_TrExGUI README
updated: 04-04-2017

Usage
--------
- Unzip directory
- add to Matlab path wit set path
- Run RN_TrodesExtractionBuilder

A Window will appear allowing you to design your extraction.
You choose which steps you would like to execute on each day folder, and the order in which to execute them.
Extraction paths can be saved and loaded. (Eventually you can export it to a matlab script for running your extraction).

Full extraction path: Fix Filenames, Create Trodes Comments, Export Time, Export Spikes, Export LFP, Export DIO, Generate Matclusts


When you click RUN, a pop-up will appear, you can add folders to run your extraction path on. These can be animal or single day folders, and as many as you want from any animals.

Once folders are selected another popup will appear that allows you to choose your settings for extracting each day directory. You can set what prefixes the files in the directory should have (and what prefixes the export directories will have), the order of the rec files, the config file to use for extraction and any custom command line flags you may want to use with your export functions (generally not needed).

New config files can be created based on existing config files. Simply click 'Change' next to the config file and then select 'New'. A pop-up will appear allowing you to select and existing file, name your new config file and then adjust settings for each tetrode. With this you can set spike thresholds and references and LFP channels for every tetrode and can copy settings between tetrodes. 'Default' signifies that the config file stored in the .rec file will be used to extract.

In the main GUI new config files can also be created by going to Tools -> New Config.


BUGS:
    - Program does not yet check extraction paths for validity
    - Config file text in extractionSetupGUI needs to automatically shorten displayed text
FUTURE:
    - Help menus
    - Export to matlab script
    - 
