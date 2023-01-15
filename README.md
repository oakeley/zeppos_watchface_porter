# zeppos_watchface_porter
Automated script to port ARKRN gts4mini watchfaces to the Amazfit Falcon
It takes the latest version of the code from <a href="https://github.com/4RK4N/zeppos_watchdrip_timer_wf">4RK4N</a> and transforms to make a Falcon version.

Instructions:
## type:
##   mkdir folder
##   cd folder
##   git clone https://github.com/4RK4N/zeppos_watchdrip_timer_wf
## To remove AAPS text and replace with date:
##   bash fixwatchface.sh bot
## To keep AAPS text and squish the date in below the clock:
##   bash fixwatchface.sh top
