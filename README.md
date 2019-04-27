# R ECG PROCESSING

Scripts that can be used in R to process (i.e. filtering and peak-detection) ECG data and produce a file with average heart rates. I have tried to explain what exactly is being done in the script (see the comments) as best as I could.

#### THE SCRIPTS ARE BASED ON CODE ORIGINALLY DEVELOPED BY OLEG CHERNENKO FOR THE MATLAB LANGUAGE (LIBROW.COM) AND SUBSEQUENTLY TRANSLATED INTO R LANGUAGE BY NASTASIA GRIFFIOEN (on April 26th, 2019)
____

#### Preparation: 
In order to be able to run the **physprocessing_generaluse.R** script, make sure that the following packages are installed:
- pracma
- svDialogs

**If you are a Windows user, you will (in principle) not have to change anything about the script. However, if you are NOT a Windows user, you will have to edit lines 23 and 24 of the script and put the scripts and data directory paths in manually.**

  
#### Step 1: 
Open **ecgfilt.R** and click on 'Source'. This will enable R to find this script in the future, which will be necessary when you run the main script.

#### Step 2:
In order to process your participants' ECG data (in .txt format), simply 'Source' **physprocessing_generaluse.R**.

  
#### Step 3: 
ONLY FOR WINDOWS USERS: You will be asked to define the folder in which you keep your analysis scripts (which are **physprocessing_generaluse.R** and **ecgfilt.R**).


#### Step 4: 
ONLY FOR WINDOWS USERS: You will also be asked to define the folder in which you keep your data (.txt) files (this may or may not be the same folder as in Step 2).


#### Step 5: 
Finally, you will be asked to enter the lower bound of the range of participants for who you would like to process the data (e.g. 1).
If you are running on Mac, you might experience that the values that you input here do not show on the screen. No worries, R does process them correctly, unfortunately you just can't see them when you type them in.


#### Step 6: 
You are also asked to provide the upper bound of this range. This depends on the amount of participants in your data, but for demonstration purposes please enter 2 here (since 2 demo participant data files were included in this package). Again, if you are running on Mac, you might experience that the values that you input here do not show on the screen. No worries, R does process them correctly, unfortunately you just can't see them when you type them in.


#### Step 7: 
The resulting file containing average heart rates per participant will be stored in the folder that you defined in Step 3.


### Bob's your uncle!
