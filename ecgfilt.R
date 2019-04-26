
ecgfilt <- function(Original,WinSize){
  
  WinHalfSize = floor(WinSize/2)
  WinHalfSizePlus = WinHalfSize+1
  WinSizeSpec = WinSize-1
  FrontIterator = 1
  WinPos = WinHalfSize
  WinMaxPos = WinHalfSize
  WinMax = Original[1]
  OutputIterator = 0
  Filtered = vector()
 
  for (LengthCounter in 0:WinHalfSize-1) {
      
    if (Original[FrontIterator+1] > WinMax){
      WinMax = Original[FrontIterator+1]
        WinMaxPos = WinHalfSizePlus + LengthCounter
    }
    FrontIterator=FrontIterator+1;
  }
  
  if (WinMaxPos == WinHalfSize){
    Filtered[OutputIterator+1]=WinMax;
  }else{
    Filtered[OutputIterator+1]=0;
  }
  
  OutputIterator = OutputIterator+1;
  
  for (LengthCounter in 0:WinHalfSize-1){
    
    if (Original[FrontIterator+1]>WinMax){
      WinMax=Original[FrontIterator+1];
      WinMaxPos=WinSizeSpec;
    }else{
      WinMaxPos=WinMaxPos-1;
    }
  
    if (WinMaxPos == WinHalfSize){
      Filtered[OutputIterator+1]=WinMax;
    }else{
      Filtered[OutputIterator+1]=0;
    }
  
    FrontIterator = FrontIterator+1;
    OutputIterator = OutputIterator+1;
  }
  
  for (FrontIterator in FrontIterator:length(Original)-1){
    if (Original[FrontIterator+1]>WinMax){
      WinMax=Original[FrontIterator+1];
      WinMaxPos=WinSizeSpec;
    }else{
        WinMaxPos=WinMaxPos-1;
        if (WinMaxPos < 0){
          WinIterator = FrontIterator-WinSizeSpec;
          WinMax = Original[WinIterator+1];
          WinMaxPos = 0;
          WinPos=0;
          for (WinIterator in WinIterator:FrontIterator){
            if (Original[WinIterator+1]>WinMax){
                WinMax = Original[WinIterator+1];
                WinMaxPos = WinPos;
            }
            WinPos=WinPos+1;
          }
        }
    }
    
    if (WinMaxPos==WinHalfSize){
      Filtered[OutputIterator+1]=WinMax;
    }else{
      Filtered[OutputIterator+1]=0;
    }
    OutputIterator=OutputIterator+1;
  }
  
  WinIterator = WinIterator-1;
  WinMaxPos = WinMaxPos-1;
  
  for (LengthCounter in 1:WinHalfSizePlus-1){
    if (WinMaxPos<0){
      WinIterator=length(Original)-WinSize+LengthCounter;
      WinMax=Original[WinIterator+1];
      WinMaxPos=0;
      WinPos=1;
      for (WinIterator in (WinIterator+1):(length(Original)-1)){
        if (Original[WinIterator+1]>WinMax){
            WinMax=Original[WinIterator+1];
            WinMaxPos=WinPos;
        }
        WinPos=WinPos+1;
      }
    }
  
    if (WinMaxPos==WinHalfSize){
      Filtered[OutputIterator+1]=WinMax;
    }else{
      Filtered[OutputIterator+1]=0;
    }
  
  FrontIterator=FrontIterator-1;
  WinMaxPos=WinMaxPos-1;
  OutputIterator=OutputIterator+1;
  
  }
  return(Filtered)
}