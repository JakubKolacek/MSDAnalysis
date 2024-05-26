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

**MSDparam.m**

Script for MSD analysis when one parametric study is used in Comsol Multiphysics

Instructions:
1. Create a new empty working directory
2. Set path to the directory in the DataPath variable of the script (line 5)
3. Put CSV files with particle positions to the working directory
4. Name of the files MUST BE **x_param.csv** and **y_param.csv**!
5. Run the Matlab script

This code was developed as part of a Bachelor's thesis titled 'Microrheology modeling with COMSOL Multiphysics package' at the Faculty of Chemistry, Brno University of Technology. The full thesis can be accessed at [https://www.vut.cz/en/students/final-thesis/detail/156714](https://www.vut.cz/en/students/final-thesis/detail/138972).

<img src="https://github.com/JakubKolacek/MSDAnalysis/assets/102429931/51ad0237-0354-4d0a-bb90-6b8377c54221" alt="UFSCH_color_RGB_EN" width="400"/>
