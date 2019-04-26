# ECG DATA PROCESSING SCRIPT
# This script allows you to remove the lower frequencies, filter the data,
# and detect the peaks. Finally the script will output the average heart
# rate.
# 
# MATLAB VERSION OF THIS SCRIPT ORIGINALLY CREATED BY SERGEY CHERNENKO (LIBROW.COM)
# SCRIPT MODIFIED TO R LANGUAGE BY NASTASIA GRIFFIOEN on 25 April 2019
# 
# BEFORE RUNNING, PLEASE MAKE SURE YOU ADJUST THE DIRECTORY NAMES

#---- VARIABLE PREP ----

# LOAD PACKAGES
library("pracma")

scriptsdir = choose.dir(caption="Please select the folder containing these scripts.")
datadir = choose.dir(caption="Please select the folder containing your data files and to which the HR file will be saved.")

# WHAT ARE THE PPNR BOUNDS FOR THE SCRIPT
ppfirst = as.numeric(readline("Please enter the lower bound participant number: "))
pplast = as.numeric(readline("Up until (including) participant numer: "))

# SAMPLING RATE
samplingrate = 1000

# INITIALISING THE DATA STRUCTURE THAT WILL HOLD ALL VALUES
datastruct = matrix(nrow=pplast,ncol=1)


#----RUN THE BASELINE AND MANIPULATION HR CALCULATIONS FOR PPs SPECIFIED----

for (ppnr in ppfirst:pplast){
  
  #----RUN THE SCRIPT FOR BOTH PHASES (BASELINE & MANIPULATION)---- 
    
    # COMPILE THE RIGHT FILE NAME FOR LOADING DATA
    filename = paste0("PP",ppnr,"_ecg.txt")
    
    # SET THE CORRECT WORKING DIRECTORY
    setwd(datadir)
    
    # IT IS POSSIBLE THAT A PP DOES NOT HAVE PHYS DATA
    # If this is the case, the script will skip the rest of this loop
    # and go on with the next iteration (i.e. the next pp)
    
    possibleError <- tryCatch({ecgdata = read.table(filename)}, error=function(e) e)
    
    if(inherits(possibleError, "error")){
      dataabsent = 1
      next
    } else {
      dataabsent = 0
    }
    
    # TRANSPOSE THE DATA
    #ecg = t(ecgdata)
    
    # REMOVE LOWER FREQUENCIES FROM SIGNAL
    # APPLY FOURIER TRANSFORM
    fresult = fft(as.numeric(unlist(ecgdata)))
    # Once in frequency domain, revert the first n values to 0
    fresult[1 : round(length(fresult)*5/samplingrate)]=0;
    # Also revert the last n values to 0
    fresult[(length(fresult) - round(length(fresult)*5/samplingrate)):length(fresult)]=0;
    # Translate signal back to ECG data using inverse Fourier transform
    corrected=Re(ifft(fresult));
    
    # DETERMINING FILTERING WINDOW SIZE
    WinSize = floor(samplingrate * 571 / 1000);
    # Check if window size is uneven; if not, make it uneven
    if (rem(WinSize,2)==0){
    WinSize = WinSize+1
    }
    
    # CHANGE WORKING DIRECTORY TO WHERE THE SCRIPTS ARE
    setwd(scriptsdir)
    
    # RUN THE FILTERING SCRIPT
    filtered1 <- ecgfilt(corrected, WinSize)
    
    # SCALING THE DATA TO SMALLER SCALE
    peaks1 = filtered1/(max(filtered1)/7);
    
    # RUN THROUGH DATA AND FILTER BY THE THRESHOLD FILTER
    for (data in 1:length(peaks1)){
      if (peaks1[data] < 4){     
        peaks1[data] = 0;
      }else{                     
        peaks1[data]=1;
      }
    }
    
    #  FIND POSITIONS OF THE PEAKS        
    positions=which(!peaks1==0,arr.ind = T)
    
    #  GET A SENSE OF INTER-PEAK INTERVAL BY LOOKING AT FIRST DISTANCE
    distance=positions[2]-positions[1]
    
    # COMPARE ALL DISTANCES TO THIS FIRST DISTANCE AND ADJUST TO
    # SMALLER IF NECESSARY
    for (data in 1:(length(positions)-1)){
      if (positions[data+1]-positions[data]<distance){
        distance=positions[data+1]-positions[data]
      }
    }
    
    # OPTIMISE THE FILTER WINDOW SIZE
    # Set up a standard distance between Q wave and R peak
    QRdistance=floor(0.04*samplingrate)
    # If this QR distance is not uneven, make it uneven
    if (rem(QRdistance,2)==0){
      QRdistance=QRdistance+1
    }
    # ADJUST FILTER WINDOW SIZE ACCORDINGLY
    WinSize=2*distance-QRdistance
    
    # FILTERING - 2nd PASS
    filtered2 <- ecgfilt(corrected, WinSize)
    peaks2=filtered2
    
    # RUN THROUGH DATA AND FILTER BY THE THRESHOLD FILTER
    for (data in 1:length(peaks2)){
      if (peaks2[data] < 4){     
        peaks2[data] = 0;
      }else{                     
        peaks2[data]=1;
      }
    }
    
    # SAVE FINAL PEAK POSITIONS
    positions2=which(!peaks2==0,arr.ind = T)
    
    
    #---- HEART RATE CALCULATION ----
    
    # CREATE NEW ARRAY CONTAINING DISTANCES BETWEEN PEAKS IN SAMPLES/MILLISECONDS
    differencesBetweenPeaks = diff(positions2)
    # CALCULATE MOMENTARY HEART RATE IN PEAKS PER MINUTE
    HR = 60./(differencesBetweenPeaks/1000);
    # CALCULATE AVERAGE HEART RATE OVER ALL DATA
    averageHR = mean(HR);
    
    print(paste0("Average HR for PP ",ppnr," in the ",phasename," phase is: ",averageHR))
    
  }
  
  #----GETTING READY TO SAVE DATA----

  # SET THE WORKING DIRECTORY TO THE FOLDER YOU WANT TO SAVE THE DATA IN
  setwd(datadir)
 
  # MAKE SURE THAT ROWS PERTAINING TO PP WHO DON'T HAVE PHYS DATA ARE SKIPPED
  if (dataabsent == 1){
    datastruct[ppnr,1] = 0
  }else{
    datastruct[ppnr,1] = averageHR
  
}

write.table(x = datastruct,file = "finalphysdata.txt")

