## Automatic script to fix all the manual steps for watchdrip face porting from gts4mini to falcon
## Edward Oakeley 2023-Jan-13, 2023-Jan-15
## type:
##   mkdir folder
##   cd folder
##   git clone https://github.com/4RK4N/zeppos_watchdrip_timer_wf
## To remove AAPS text and replace with date:
##   bash fixwatchface.sh bot
## To keep AAPS text and squish the date in below the clock:
##   bash fixwatchface.sh top

# Set variables
##   Input watch
export iX=336
export oX=416
export iY=384
export oY=416
##   Scaling factors
xScale=`echo $iY" "$oY | awk '{print $2/$1}'`
yScale=`echo $iY" "$oY | awk '{print $2/$1}'`

# Date position
export dPos=105
if [[ $1 == "bot" ]]; then dPos=345; fi

# Backup all the folders and copy the gts4mini into falcon so we can have the updates
rm -rf zeppos_watchdrip_timer_wf/assets/falcon  # zeppos_watchdrip_timer_wf/assets/oldfalcon
rm -rf zeppos_watchdrip_timer_wf/watchface/falcon  #zeppos_watchdrip_timer_wf/watchface/oldfalcon
rsync -vaz zeppos_watchdrip_timer_wf/assets/gts4mini/ zeppos_watchdrip_timer_wf/assets/falcon
rsync -vaz zeppos_watchdrip_timer_wf/watchface/gts4mini/ zeppos_watchdrip_timer_wf/watchface/falcon

# Make a Falcon low power background
cp ~/Pictures/bg.png zeppos_watchdrip_timer_wf/assets/falcon/images/bg/
# Make a low power heart icon
cp ~/Pictures/heart.png zeppos_watchdrip_timer_wf/assets/falcon/images/widgets/
# Fix the glucose warning icons
cp ~/Pictures/bg?*.png zeppos_watchdrip_timer_wf/assets/falcon/watchdrip/
# Fix the preview image
cp ~/Pictures/preview.png zeppos_watchdrip_timer_wf/assets/falcon/images/

# Apply the screen calculations to every number that looks like a coordinate write intermetiate tmp file to RAM
cat zeppos_watchdrip_timer_wf/watchface/gts4mini/styles.js | \
   tr "(" "@" | \
   awk -F"px@" '{OFS="px@"; if ($0 ~ "px@") {A=split($2,a,")"); if (length(a[1])<4) {if ($0 ~ "x: px@" || $0 ~ "X: px@" || $0 ~ "w: px@") {x=int((a[1]*1.238095238)+.5); $2=x")"a[2]}; if ($0 ~ "y: px@" || $0 ~ "Y: px@" || $0 ~ "h: px@") {y=int((a[1]*1.083333333)+.5); $2=y")"a[2]}}}; print $0 }' | \
   tr "@" "(" > /dev/shm/styles.js.tmp

# Auto-fixing doesn't actually work that well because it is so hard to make a general rule so we just edit the rest inline
cat /dev/shm/styles.js.tmp | \
   sed 's/hour_startX: px(104),/hour_startX: px(124),/g' | \
   sed 's/hour_startY: px(6),/hour_startY: px(36),/g' | \
   sed 's/month_unit_sc: img(/\/\/ month_unit_sc: img(/g' | \
   sed 's/month_unit_tc: img(/\/\/ month_unit_tc: img(/g' | \
   sed 's/month_unit_en: img(/\/\/ month_unit_en: img(/g' | \
   sed 's/const dateX = px(163);/const dateX = px(203);/g' | \
   sed "s/const dateY = px(75);/const dateY = px("$dPos");/g" | \
   sed "s/    y: px(81),/    y: px("$dPos"),/g" |\
   sed 's/    x: px(125),/    x: px(145),/g' | \
   sed 's/    w: px(336),/    w: px(416),/g' | \
   sed 's/    h: px(384),/    h: px(416),/g' | \
   sed 's/const editWidgetW = px(90);/const editWidgetW = px(105);/g' | \
   sed 's/const editWidgetH = px(70);/const editWidgetH = px(76);/g' | \
   sed 's/const topLeftX = px(7);/const topLeftX = px(32);/g' | \
   sed 's/const topLeftY = px(110);/const topLeftY = px(115);/g' | \
   sed 's/const topRightX = px(239);/const topRightX = px(286);/g' | \
   sed 's/const bottomLeftX = px(7);/const bottomLeftX = px(42);/g' | \
   sed 's/const bottomLeftY = px(195);/const bottomLeftY = px(217);/g'| \
   sed 's/const bottomRightX = px(239);/const bottomRightX = px(286);/g' | \
   sed 's/const bottomRightY = px(195);/const bottomRightY = px(217);/g' \
   > zeppos_watchdrip_timer_wf/watchface/falcon/styles.js

if [[ $1 != "bot" ]]; then exit; fi

# Optionally get rid of AAPS stuff because it doesn't work with default xDrip
perl -0777 -i -pe 's/\QFill data from modified xDrip ExternalStatusService.getLastStatusLine\E.*?\QaapsText.setProperty(hmUI.prop.TEXT, aapsString);\E//gs' zeppos_watchdrip_timer_wf/watchface/falcon/index.js



