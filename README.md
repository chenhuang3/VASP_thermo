# VASP_thermo

Albert's script for computing the entropy and internal thermal energy based on the frequency calculations from VASP.

The script is thermo.pl

The example job is Frequencies.tar.gz, unzip it and run the VASP job inside. After the VASP job, run the script thermo.pl. It will read the OUTCAR, extract the frequencies and output the entropy, and internal thermal energy due to vibrational modes.
