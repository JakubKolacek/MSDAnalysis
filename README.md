# MSDAnalysis
Matlab scripts for MSD analysis for Comsol Mutliphysics's Particle Tracing module.
Two data plots are available directly from the script. A classic plot and loglog plot.
Each analysis is automatically saved to the current directory.

**MSDsimple.m**

Script for MSD analysis when one or multiple studies is used in Comsol Multiphysics.

Instructions:
1. Create a new empty working directory
2. Set path to the directory in the DataPath variable of the script (line 5)
3. Put CSV files with particle positions to the working directory
4. Name of the files must be in the following format: **x_N.csv** and **y_N.csv**
   where N is the consecutive number of study starting from 1.
   If you want to analyze only one study you will need following files in the directory: _x_1.csv_, _y_1.csv_
   
   For analysing multiple studies: _x_1.csv_, _y_1.csv_, _x_2.csv_, _y_2.csv_...
5. Run the Matlab script

**MSDparams.m**

Script for MSD analysis when one parametric study is used in Comsol Multiphysics

Instructions:
1. Create a new empty working directory
2. Set path to the directory in the DataPath variable of the script (line 5)
3. Put CSV files with particle positions to the working directory
4. Name of the files MUST BE **x_param.csv** and **y_param.csv**!
5. Run the Matlab script

