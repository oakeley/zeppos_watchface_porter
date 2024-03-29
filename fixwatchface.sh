## Automatic script to fix all the manual steps for watchdrip face porting from gts4mini to falcon
## Edward Oakeley 2023-Jan-13, 2023-Jan-15, 2023-Jan-22
## type:
##   mkdir folder
##   cd folder
##   git clone https://github.com/4RK4N/zeppos_watchdrip_timer_wf
##   bash fixwatchface.sh falcon (allowed options are "falcon" or gtr-3-pro"... ping me on Discord with the screen size if you have a different watch)

# Set variables
##   Input watch
export iX=336
export iY=384

d="F"

if [[ $1 == "falcon" ]]; then name="falcon"; export oX=416; export oY=416; export offset=1; export d0=101; export d="T"; fi
if [[ $1 == "gtr-3-pro" ]]; then name="gtr-3-pro"; export oX=480; export oY=480; offset=0.95; d0=110; d="T"; fi
if [[ $1 == "gtr4" ]]; then name="gtr4"; export oX=466; export oY=466; offset=0.95; d0=110; d="T"; fi
if [[ $1 == "band7" ]]; then name="band7"; export oX=194; export oY=368; offset=0.95; d0=110; d="T"; fi
if [[ $d == "F" ]]; then echo "Unsupported watch"; exit; fi

##   Scaling factors
xScale=`echo $iX" "$oX | awk '{print $2/$1}'`
yScale=`echo $iY" "$oY | awk '{print $2/$1}'`

# Date position
export dPos=95
#if [[ $1 == "bot" ]]; then dPos=345; fi

#dPos=`echo $dPos $rat | awk '{print int(($1*$2)+.5)}'`

# Backup all the folders and copy the gts4mini into falcon so we can have the updates
rm -rf zeppos_watchdrip_timer_wf/assets/$name
rm -rf zeppos_watchdrip_timer_wf/watchface/$name
rsync -vaz zeppos_watchdrip_timer_wf/assets/gts4mini/ zeppos_watchdrip_timer_wf/assets/$name
rsync -vaz zeppos_watchdrip_timer_wf/watchface/gts4mini/ zeppos_watchdrip_timer_wf/watchface/$name

# Make a Falcon low power background
cp ~/Pictures/bg-"$name".png zeppos_watchdrip_timer_wf/assets/$name/images/bg/bg.png
# Make a low power heart icon
#cp ~/Pictures/heart.png zeppos_watchdrip_timer_wf/assets/$name/images/widgets/
# Fix the glucose warning icons
echo `ls ~/Pictures/bg?*.png | grep -v "-"` | awk -v name=$name '{for (i=1; i<=NF; i+=1) {system("cp "$i" zeppos_watchdrip_timer_wf/assets/"name"/watchdrip/")}}'
# Fix the preview image
cp ~/Pictures/preview.png zeppos_watchdrip_timer_wf/assets/$name/images/
rsync -va ~/bigNumAOD/* zeppos_watchdrip_timer_wf/assets/$name/images/bigNumAOD/
# Auto-fixing doesn't actually work that well because it is so hard to make a general rule so we just edit the rest inline and write intermetiate tmp file to RAM
cat zeppos_watchdrip_timer_wf/watchface/gts4mini/styles.js | \
   sed "s/hour_startX: px(84),/hour_startX: +("`echo $d0 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/hour_startY: px(6),/hour_startY: +("`echo 26 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/m_x: px(258),/m_x: +("`echo 238 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/m_y: px(42),/m_y: +("`echo 42 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/hour_startX: px(54),/hour_startX: +("`echo 77 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/hour_startY: px(122),/hour_startY: +("`echo 100 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/m_x: px(281),/m_x: +("`echo 262.5 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/m_y: px(151),/m_y: +("`echo 111 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/month_unit_sc: img(/\/\/ month_unit_sc: img(/g" | \
   sed "s/month_unit_tc: img(/\/\/ month_unit_tc: img(/g" | \
   sed "s/month_unit_en: img(/\/\/ month_unit_en: img(/g" | \
   sed "s/const dateX = px(163);/const dateX = +("`echo 163 $xScale | awk '{print int(($1*$2)+.5)}'`");/g" | \
   sed "s/const dateY = px(75);/const dateY = +("`echo $dPos $yScale | awk '{print int(($1*$2)+.5)}'`");/g" | \
   sed "s/    x: px(101),/    x: +("`echo 115 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(75),/    y: +("`echo $dPos $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(114),/    x: +("`echo 114 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(122),/    y: +("`echo 201 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(125),/    y: +("`echo 125 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(201),/    y: +("`echo 171 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(5),/    x: +("`echo 10 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(81),/    y: +("`echo $dPos $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(125),/    x: +("`echo 110 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(115),/    x: +("`echo 120 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    w: px(336),/    w: +("`echo 336 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    h: px(384),/    h: +("`echo 384 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/const editWidgetW = px(90);/const editWidgetW = +("`echo 90 $xScale | awk '{print int(($1*$2)+.5)}'`");/g" | \
   sed "s/const editWidgetH = px(70);/const editWidgetH = +("`echo 70 $yScale | awk '{print int(($1*$2)+.5)}'`");/g" | \
   sed "s/const topLeftX = 7;/const topLeftX = "`echo 15 $xScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/const topLeftY = 110;/const topLeftY = "`echo 110 $yScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/const topRightX = 239;/const topRightX = "`echo 250 $xScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/const topRightY = 110;/const topRightY = "`echo 100 $xScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/const bottomLeftX = 7;/const bottomLeftX = "`echo 15 $xScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/const bottomLeftY = 195;/const bottomLeftY = "`echo 195 $yScale | awk '{print int(($1*$2)+.5)}'`";/g"| \
   sed "s/const bottomRightX = 239;/const bottomRightX = "`echo 250 $xScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/const bottomRightY = 195;/const bottomRightY = "`echo 195 $yScale | awk '{print int(($1*$2)+.5)}'`";/g" | \
   sed "s/    w: px(40),/    w: +(40),/g" | \
   sed "s/    h: px(10),/    w: +(10),/g" | \
   sed "s/    y: px(276),/    y: +("`echo 276 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(65),/    x: +("`echo 65 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(201),/    y: +("`echo 201 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(259),/    x: +("`echo 259 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(105),/    x: +("`echo 115 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    x: px(216),/    x: +("`echo 205 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(108),/    y: +("`echo 110 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
   sed "s/    y: px(276),/    y: +("`echo 276 $yScale | awk '{print int(($1*$2)+.5)}'`"),/g" \
   > /dev/shm/styles.js.tmp

# Apply the screen calculations to every remaining number that looks like a coordinate
cat /dev/shm/styles.js.tmp | \
   tr "(" "@" | \
   awk -v xS1=$xScale -v yS1=$yScale -v of=$offset -F"px@" '{OFS="px@"; xS=xS1*of; yS=yS1*of; if ($0 ~ "px@") {A=split($2,a,")"); if (length(a[1])<4) {if ($0 ~ "x: px@" || $0 ~ "X: px@" || $0 ~ "w: px@") {x=int((a[1]*xS)+.5); $2=x")"a[2]}; if ($0 ~ "y: px@" || $0 ~ "Y: px@" || $0 ~ "h: px@") {y=int((a[1]*yS)+.5); $2=y")"a[2]}}}; print $0 }' | \
   tr "@" "(" | \
   sed 's/ +(/ px(/g' > zeppos_watchdrip_timer_wf/watchface/$name/styles.js

#if [[ $1 != "bot" ]]; then exit; fi

# Optionally get rid of AAPS stuff because it doesn't work with default xDrip
#perl -0777 -i -pe 's/\QFill data from modified xDrip ExternalStatusService.getLastStatusLine\E.*?\QaapsText.setProperty(hmUI.prop.TEXT, aapsString);\E//gs' zeppos_watchdrip_timer_wf/watchface/$name/index.js

#   sed "s/    x: px(259),/    x: px("`echo 259 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \
#   sed "s/    x: px(5),/    x: px("`echo 5 $xScale | awk '{print int(($1*$2)+.5)}'`"),/g" | \   
