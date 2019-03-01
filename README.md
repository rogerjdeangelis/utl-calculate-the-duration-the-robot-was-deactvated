# utl-calculate-the-duration-the-robot-was-deactvated
Calculate the duration the robot was deactvated 
    Calculate the duration the robot was deactvated                                                                 
                                                                                                                    
        Two Solutions                                                                                               
                                                                                                                    
            1. SAS                                                                                                  
            2, R                                                                                                    
                                                                                                                    
    If Active=0 the robot is deactivated.                                                                           
    If Active=1 then robot is activated.                                                                            
    Robots cannot have consecutive deactivations.                                                                   
                                                                                                                    
                                                                                                                    
    github                                                                                                          
    https://tinyurl.com/y3onzzkn                                                                                    
    https://github.com/rogerjdeangelis/utl-calculate-the-duration-the-robot-was-deactvated                          
                                                                                                                    
    StackOverFlow                                                                                                   
    https://tinyurl.com/yxbdnzyv                                                                                    
    https://stackoverflow.com/questions/54928038/percentage-of-duration-of-deactivation-in-r                        
                                                                                                                    
    Arg0naut                                                                                                        
    https://stackoverflow.com/users/8389003/arg0naut                                                                
                                                                                                                    
    *_                   _                                                                                          
    (_)_ __  _ __  _   _| |_                                                                                        
    | | '_ \| '_ \| | | | __|                                                                                       
    | | | | | |_) | |_| | |_                                                                                        
    |_|_| |_| .__/ \__,_|\__|                                                                                       
            |_|                                                                                                     
    ;                                                                                                               
                                                                                                                    
    data have;                                                                                                      
      input Robot Time Active;                                                                                      
    cards4;                                                                                                         
    64 394  1                                                                                                       
    74 396  1                                                                                                       
    76 397  1                                                                                                       
    80 399  0                                                                                                       
    22 404  1                                                                                                       
    74 415  1                                                                                                       
    80 417  1                                                                                                       
    51 424  1                                                                                                       
    80 426  0                                                                                                       
    80 427  1                                                                                                       
    ;;;;                                                                                                            
    run;quit;                                                                                                       
                                                                                                                    
    I sorted the input to document the problem                                                                      
                                                                                                                    
     WORK.HAVSRT total obs=10                                                                                       
                                                                                                                    
                              | RULES (You cannot have consecutive deactivations)                                   
                              |                                                                                     
      ROBOT   TIME    ACTIVE  |ROBOT   DUR     DURPCT                                                               
                              |                                                                                     
        22     404       1    |  22      0    0.00000                                                               
        51     424       1    |  51      0    0.00000                                                               
        64     394       1    |  64      0    0.00000                                                               
                                                                                                                    
        74     396       1    |  74      0    0.00000                                                               
        74     415       1    |                                                                                     
                                                                                                                    
        76     397       1    |  76      0    0.00000                                                               
                              |                                                                                     
        80     399       0    |  80     19    0.57576                                                               
        80     417       1    |                                                                                     
        80     426       0    |  DUR    = (417-399) + (427-426) = 19                                                
        80     427       1    |  DURPCT = 19/(427-399) = 19/28 = 0.67857                                            
                                                                                                                    
    *                                                                                                               
     ___  __ _ ___                                                                                                  
    / __|/ _` / __|                                                                                                 
    \__ \ (_| \__ \                                                                                                 
    |___/\__,_|___/                                                                                                 
                                                                                                                    
    ;                                                                                                               
                                                                                                                    
    proc sort data=have out=havSrt;                                                                                 
    by robot time;                                                                                                  
    run;quit;                                                                                                       
                                                                                                                    
    data want;                                                                                                      
                                                                                                                    
      retain robot dur 0 durPct;                                                                                    
                                                                                                                    
      * compute total duration;                                                                                     
      set have(obs=1 keep=time) nobs=obs;                                                                           
      set have(keep=time rename=time=endtym) point=obs;                                                             
      durTot=endtym-time;                                                                                           
                                                                                                                    
      do until (dne);                                                                                               
         set havSrt end=dne;                                                                                        
         by robot;                                                                                                  
         lagTym=lag(time);                                                                                          
         if first.robot then begTym=time;                                                                           
         if lag(Active)=0 and (active=1) then dur=dur + (time-lagTym);                                              
         if last.robot then do;                                                                                     
            durPct=coalesce(divide(dur,(time-begTym)),0);                                                           
            output;                                                                                                 
            dur=0;                                                                                                  
         end;                                                                                                       
      end;                                                                                                          
      drop endtym lagtym active durtot time begTym;                                                                 
                                                                                                                    
    run;quit;                                                                                                       
                                                                                                                    
    /*                                                                                                              
     WORK.WANT total obs=6                                                                                          
                                                                                                                    
      ROBOT    DUR     DURPCT                                                                                       
                                                                                                                    
        22       0    0.00000                                                                                       
        51       0    0.00000                                                                                       
        64       0    0.00000                                                                                       
        74       0    0.00000                                                                                       
        76       0    0.00000                                                                                       
        80      19    0.67857                                                                                       
    */                                                                                                              
                                                                                                                    
    data want;                                                                                                      
                                                                                                                    
      retain id dur 0 durPct;                                                                                       
                                                                                                                    
      do until (dne);                                                                                               
         set havSrt end=dne;                                                                                        
         by robot;                                                                                                  
         lagTym=lag(time);                                                                                          
         if first                                                                                                   
         if lag(Active)=0 and (active=1) then dur=dur + (time-lagTym);                                              
         if last.robot then do;durPct=dur/durtot; output; dur=0; end;                                               
      end;                                                                                                          
      drop endtym lagtym active durtot time;                                                                        
                                                                                                                    
    run;quit;                                                                                                       
                                                                                                                    
    *____                                                                                                           
    |  _ \                                                                                                          
    | |_) |                                                                                                         
    |  _ <                                                                                                          
    |_| \_\                                                                                                         
                                                                                                                    
    ;                                                                                                               
    options validvarname=upcase;                                                                                    
    libname sd1 "d:/sd1";                                                                                           
    data sd1.have;                                                                                                  
      input Robot Time Active;                                                                                      
    cards4;                                                                                                         
    64 394  1                                                                                                       
    74 396  1                                                                                                       
    76 397  1                                                                                                       
    80 399  0                                                                                                       
    22 404  1                                                                                                       
    74 415  1                                                                                                       
    80 417  1                                                                                                       
    51 424  1                                                                                                       
    80 426  0                                                                                                       
    80 427  1                                                                                                       
    ;;;;                                                                                                            
    run;quit;                                                                                                       
                                                                                                                    
                                                                                                                    
    %utlfkil(d:/xpt/want.xpt);                                                                                      
                                                                                                                    
    %utl_submit_r64('                                                                                               
    library(haven);                                                                                                 
    library(dplyr);                                                                                                 
    library(SASxport);                                                                                              
    library(data.table);                                                                                            
    have<-as.data.frame(read_sas("d:/sd1/have.sas7bdat"));                                                          
    have;                                                                                                           
    want<-data.table(have %>%                                                                                       
      group_by(ROBOT) %>%                                                                                           
      mutate(time_diff = lead(TIME) - TIME) %>%                                                                     
      mutate(                                                                                                       
        Percentage = sum(time_diff[ACTIVE == 0], na.rm = T) / sum(time_diff, na.rm = T),                            
        Percentage = scales::percent(coalesce(Percentage, +(ACTIVE == 0) * 1))                                      
      ) %>%                                                                                                         
      distinct(ROBOT, Percentage));                                                                                 
    str(want);                                                                                                      
    write.xport(want,file="d:/xpt/want.xpt");                                                                       
    ');                                                                                                             
                                                                                                                    
                                                                                                                    
    libname xpt xport "d:/xpt/want.xpt";                                                                            
    data want;                                                                                                      
      set xpt.want;                                                                                                 
    run;quit;                                                                                                       
    libname xpt clear;                                                                                              
                                                                                                                    
    /*                                                                                                              
    WANT total obs=6                                                                                                
                                                                                                                    
     ROBOT    PERCENTA                                                                                              
                                                                                                                    
       64      0%                                                                                                   
       74      0%                                                                                                   
       76      0%                                                                                                   
       80      67.9%                                                                                                
       22      0%                                                                                                   
       51      0%                                                                                                   
    */                                                                                                              
                                                                                                                    
                                                                                                                    
