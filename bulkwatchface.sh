## Automatic script to fix all the manual steps for watchdrip face porting from gts4mini to all watchfaces and then making a child-friendly derivertive
## Edward Oakeley 2023-Jan-13, 2023-Jan-15, 2023-Jan-22, 2023-Jan-30
## type:
##   git clone https://github.com/oakeley/zeppos_watchface_porter
##   cd zeppos_watchface_porter
##   bash ./bulkwatchface.sh

# Set date
printf -v date '%(%Y%m%d-%H%M%S)T\n' -1

# Make some folders
mkdir "$date"
cd "$date"

# Get today's version
git clone https://github.com/4RK4N/zeppos_watchdrip_timer_wf
bash ../fixwatchface.sh falcon
bash ../fixwatchface.sh gtr-3-pro
bash ../fixwatchface.sh gtr4


