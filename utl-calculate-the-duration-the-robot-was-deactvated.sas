Calculate the duration the robot was deactvated Calculate the duration the robot was deactvated                            
                                                                                                                           
Add recent enhancements by Mark Keintz                                                                                     
                                                                                                                           
 Four Solutions                                                                                                            
                                                                                                                           
     1. Best Sort/Datasep solution by Mark Keintz (mkeintz@wharton.upenn.edu)                                              
     2. Single fast hash solution (without the sort) by Mark Keintz (mkeintz@wharton.upenn.edu)                            
     3. Original sort datastep solution                                                                                    
     4, R Solution                                                                                                         
                                                                                                                           
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
                                                                                                                           
                                                                                                                           
*_     __  __            _                      _      __  _       _            _                                          
/ |   |  \/  | __ _ _ __| | __   ___  ___  _ __| |_   / /_| | __ _| |_ __ _ ___| |_ ___ _ __                               
| |   | |\/| |/ _` | '__| |/ /  / __|/ _ \| '__| __| / / _` |/ _` | __/ _` / __| __/ _ \ '_ \                              
| |_  | |  | | (_| | |  |   <   \__ \ (_) | |  | |_ / / (_| | (_| | || (_| \__ \ ||  __/ |_) |                             
|_(_) |_|  |_|\__,_|_|  |_|\_\  |___/\___/|_|   \__/_/ \__,_|\__,_|\__\__,_|___/\__\___| .__/                              
                                                                                       |_|                                 
;                                                                                                                          
                                                                                                                           
Your data step solution can be tightened a bit as below.                                                                   
But you'll see later that I am really sending this reply to                                                                
show a simple last.byvar analog in the hash object.                                                                        
                                                                                                                           
                                                                                                                           
proc sort data=have out=havsrt;                                                                                            
  by robot time;                                                                                                           
run;                                                                                                                       
                                                                                                                           
data want (keep=robot dur durpct);                                                                                         
  set havsrt;                                                                                                              
  by robot;                                                                                                                
                                                                                                                           
  cum_time+dif(time);                                                                                                      
  dur+(lag(active)=0)*coalesce(dif(time),0);  * nice dif RJD;                                                              
                                                                                                                           
  if first.robot then cum_time=0; * simpler RJD;                                                                           
  if first.robot then dur=0;                                                                                               
  if dur=0 then durpct=0;                                                                                                  
  else durpct=dur/cum_time;                                                                                                
                                                                                                                           
  if last.robot;                                                                                                           
run;                                                                                                                       
                                                                                                                           
I think the DATA WANT above is the way to go                                                                               
when dealing with a data set already sorted by robot/time.                                                                 
                                                                                                                           
                                                                                                                           
*____      __  __            _      _               _                                                                      
|___ \    |  \/  | __ _ _ __| | __ | |__   __ _ ___| |__                                                                   
  __) |   | |\/| |/ _` | '__| |/ / | '_ \ / _` / __| '_ \                                                                  
 / __/ _  | |  | | (_| | |  |   <  | | | | (_| \__ \ | | |                                                                 
|_____(_) |_|  |_|\__,_|_|  |_|\_\ |_| |_|\__,_|___/_| |_|                                                                 
                                                                                                                           
;                                                                                                                          
                                                                                                                           
But, since the original data is sorted by time/robot, it occurred to me that one could use an ordered                      
(by robot/time) hash object, a commonly leveraged benefit of hash objects.  Also, in this particular                       
case it turns out that even a hash object that is not specified as ordered                                                 
will produce the desired results.  Either way, it alleviates the need for a proc sort to write an                          
intermediate data set to disk only to read the data back in.                                                               
                                                                                                                           
The main technique needed is the construction of analogs to first.byvar                                                    
and last.byvar, by tactical use of the hash iterator paired with the lag function:                                         
                                                                                                                           
data want (keep=robot cum_time dur durpct);                                                                                
  set have (obs=1);                                                                                                        
  declare hash h (dataset:'have',ordered:'A');  *load ordered (fast);                                                      
    h.definekey('robot','time');                                                                                           
    h.definedata(all:'Y');                                                                                                 
    h.definedone();                                                                                                        
  declare hiter hi ('h');                                                                                                  
                                                                                                                           
  do n=1 by 1 until (rci^=0);                                                                                              
                                                                                                                           
    rci=hi.next();                                                                                                         
    first_dot_robot=(robot^=lag(robot));                                                                                   
    if (first_dot_robot=1 and n>1) or rci^=0 then do;                                                                      
      if rci=0 then hi.prev();                                                                                             
      output;                                                                                                              
      if rci^=0 then leave;                                                                                                
     hi.next();                                                                                                            
    end;                                                                                                                   
                                                                                                                           
    dif_time=coalesce(dif(time),0);                                                                                        
    lag_active=coalesce(lag(active),0);                                                                                    
                                                                                                                           
    cum_time = ifn(first_dot_robot,0,sum(cum_time,dif_time));                                                              
    dur= ifn(first_dot_robot,0,sum(dur,(1-lag_active)*dif_time));                                                          
                                                                                                                           
    if dur=0 then durpct=0;                                                                                                
    else durpct=dur/cum_time;                                                                                              
  end;                                                                                                                     
                                                                                                                           
run;                                                                                                                       
                                                                                                                           
The first.byvar/last.byvar simulation is done by traversing the hash object via the hi.next()                              
method, followed by a test on “robot^=lag(robot)”.  When true, set FIRST_DOT_ROBOT=1,                                      
then back up one data item (hi.prev()) to restore the just-discarded robot id to the PDV                                   
(i.e. simulate a last.byvar status), output the observation, and then                                                      
re-advance one data item to re-establish the                                                                               
first.byvar status for the next id.                                                                                        
                                                                                                                           
Just as a SET statement with a BY statement requires the sas data step to look ahead,                                      
that’s what happens above – except that the PDV has to be explicitly                                                       
repopulated to establish the last.byvar values.                                                                            
                                                                                                                           
The other interesting point in this problem is that you don’t even need the                                                
ordered:’A’” parameter in the declare hash statement.  Because the original                                                
data set is already sorted by time/robot, you can simply replace these two statements:                                     
                                                                                                                           
  declare hash h (dataset:'have',ordered:'A');                                                                             
    h.definekey('robot','time');                                                                                           
                                                                                                                           
with                                                                                                                       
                                                                                                                           
  declare hash h (dataset:'have',multidata:'Y');                                                                           
                                                                                                                           
    h.definekey('robot');                                                                                                  
                                                                                                                           
The multidata:’Y’ option permits dataitems with duplicate key values                                                       
(but now only ROBOT is the key),  and                                                                                      
                                                                                                                           
     **** dataitems with duplicate keys are stored in order they are read in ****                                          
                                                                                                                           
which in this case means the dataitems are ordered by time                                                                 
within each robot group, even if the groups values are not ordered.                                                        
                                                                                                                           
                                                                                                                           
                                                                                                                           
My asterisked observation above comes from page 60 of the Dorfman/Henderson book:                                          
                                                                                                                           
“Within each same-key item group, the relative sequence order is exactly the                                               
same in which the items are received from input.                                                                           
This is true regardless of whether the table is ORDERED or not.”                                                           
                                                                                                                           
                                                                                                                           
It’s a handy bit of knowledge, and nice to have it in print –                                                              
I don’t recall seeing that property stated in any SAS documentation.                                                       
                                                                                                                           
                                                                                                                           
*_____     ___       _       _             _                   _      __  _       _            _                           
|___ /    / _ \ _ __(_) __ _(_)_ __   __ _| |   ___  ___  _ __| |_   / /_| | __ _| |_ __ _ ___| |_ ___ _ __                
  |_ \   | | | | '__| |/ _` | | '_ \ / _` | |  / __|/ _ \| '__| __| / / _` |/ _` | __/ _` / __| __/ _ \ '_ \               
 ___) |  | |_| | |  | | (_| | | | | | (_| | |  \__ \ (_) | |  | |_ / / (_| | (_| | || (_| \__ \ ||  __/ |_) |              
|____(_)  \___/|_|  |_|\__, |_|_| |_|\__,_|_|  |___/\___/|_|   \__/_/ \__,_|\__,_|\__\__,_|___/\__\___| .__/               
                       |___/                                                                          |_|                  
;                                                                                                                          
                                                                                                                           
proc sort data=have out=havSrt;                                                                                            
by robot time;                                                                                                             
run;quit;                                                                                                                  
                                                                                                                           
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
                                                                                                                           
*_  _      ____                                                                                                            
| || |    |  _ \                                                                                                           
| || |_   | |_) |                                                                                                          
|__   _|  |  _ <                                                                                                           
   |_|(_) |_| \_\                                                                                                          
                                                                                                                           
;                                                                                                                          
                                                                                                                           
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
                                                                    
                                                                                                  
