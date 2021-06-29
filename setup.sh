#!/bin/bash
#!/bin/sh
cra(){
    IFS='|' read user pw domi  < <( zenity --window-icon ".res/rage.png" --width=300  --height=190 --forms --title="Credentials" --text="Login Details"    --add-entry="Username"    --add-password="Password"    --add-entry="Domain" )
    dom=`echo $domi | awk '{print toupper($0)}'`
    us=$user
    if [[ $? -eq 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --height=25 --error \
            --text="Login Failed !!!"
            # cra
            exit;
    fi
}
ins_del(){
    zenity --window-icon ".res/question.png" --question --title="Exit" --width=350 --text="Are you sure, You want to delect this Script ?"
    if [ $? = 0 ]; then
        SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
        rm -rf $SCRIPT_DIR
    else
        exit;
    fi
}
rsrt(){
    timeout=30
    for (( i=0 ; i <= $timeout ; i++ )) do
        echo "# System will restart in $[ $timeout - $i ] ..."
        echo $[ 100 * $i / $timeout ]
        sleep 1
    done | zenity  --window-icon ".res/progress.png" --progress --title="Restarting ..."  \
        --window-icon=warning --width=500 --auto-close
    if [ $? = 0 ] ; then
        /sbin/reboot
    else
        zenity --window-icon ".res/info.png" --info --width=280 --height=100 --timeout 15  --title="Restart" --text "<span foreground='black' font='13'>Restart manually ...</span>"
    fi
}
cl(){
    pkgs='curl'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt-get install $pkgs -y >/dev/null
    fi
}
depet(){
    pkgs='apt-transport-https'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt-get install $pkgs -y >/dev/null
    fi
}
wg(){
    pkgs='wget'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		apt-get install $pkgs -y >/dev/null
    fi
}
vscd_chk(){
    pkgs='code'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		vscd
    else
        VSC_VER=$(dpkg -s code | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}')
        zenity --window-icon ".res/done.png" --info --width=250 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'>VS Code Already Installed </span>\n\n<b><i>Version : $VSC_VER   </i></b>✅"
    fi
}
vscd(){
    (
        echo "25" ; sleep 3
        echo "# Downloading VS Code ... "
        wget -O code.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading VS Code ..."
        echo "50" ; sleep 3
        echo "# Installing VS Code ... "
        dpkg -i code.deb >/dev/null
        echo "90" ; sleep 3
        echo "# Installed VS Code ... "
    )|
        zenity --width=500 --window-icon ".res/code.png"  --progress \
            --title="Installing VS Code" \
            --text="Please Wait ..." \
            --percentage=0 --auto-close
            VSC_VER=$(dpkg -s code | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}')
            zenity --window-icon ".res/done.png" --info --width=250 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> VS Code Version </span>\n\n<b><i>Version : $VSC_VER   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
mld_chk(){
    pkgs='meld'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		mld
    else
        MLD_VER=$(dpkg -s meld | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}')
        zenity --window-icon ".res/meld.png" --info --width=290 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Meld Already Installed </span>\n\n<b><i>Version : $MLD_VER   </i></b>✅"
    fi
}

mld(){
    (
        echo "25" ; sleep 3
        echo "# Installing Meld ... "
        apt-get install meld -y >/dev/null 2>&1
        echo "90" ; sleep 3
        echo "# Installed Meld ... "
    ) |
        zenity --width=500 --window-icon ".res/meld.png"  --progress \
        --title="Meld Installation" \
        --text="Meld ..." \
        --percentage=0 --auto-close
        MLD_VER=$(dpkg -s meld | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}')
        zenity --window-icon ".res/done.png" --info --width=290 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Meld Version </span>\n\n<b><i>Version : $MLD_VER   </i></b>✅"
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
            ins_del
        fi
}
chrm_chk(){
    pkgs='google-chrome-stable'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
		chrm
    else
        CHRM_VER=$(dpkg -s google-chrome-stable | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}' | awk 'BEGIN{FS=OFS="."} NF--' | awk 'BEGIN{FS=OFS="."} NF--')
        zenity --window-icon ".res/chrome.png" --info --width=280 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Chrome Already Installed </span>\n\n<b><i>Version : $CHRM_VER   </i></b>✅"
    fi
}
chrm(){
    (
        echo "25" ; sleep 3
        echo "# Downloading Chrome ... "
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity  --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Goole Chrome"
        echo "60" ; sleep 3
        echo "# Installing Chrome ... "
        dpkg -i /tmp/google-chrome-stable_current_amd64.deb >/dev/null 2>&1
        echo "75" ; sleep 3
        echo "# Reoving Download file ... "
        rm -rf /tmp/google-chrome-stable_current_amd64.deb >/dev/null 2>&1
        echo "90" ; sleep 3
        echo "# Installed 👍 "
    ) |
        zenity --width=500 --window-icon ".res/chrome.png"  --progress \
        --title="Chrome Installation" \
        --text="Preparing ..." \
        --percentage=0 --auto-close
        CHRM_VER=$(dpkg -s google-chrome-stable | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}' | awk 'BEGIN{FS=OFS="."} NF--' | awk 'BEGIN{FS=OFS="."} NF--')
        zenity --window-icon ".res/done.png" --info --width=280 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Chrome Version </span>\n\n<b><i>Version : $CHRM_VER   </i></b>✅"
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
            ins_del
        fi
}
scntm_chk(){
    pkgs='screentime'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		scntm
    else
        SCT_VER=$(dpkg -s $pkgs | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}')
        zenity --window-icon ".res/rage.png" --info --width=290 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'>Screen Time Already Installed</span>\n\n<b><i>Version :  $SCT_VER  </i></b>✅"
    fi
}
scntm(){
    (
        echo "25" ; sleep 3
        echo "# Preparing ... "
        PASSWD=`cat .encry.enc | openssl enc -aes-256-cbc -d -a -iter 29 -pass pass:'Lwg&u@qRnS$CwLJ9PBU5RV&w^J5EXnQ^$2s!9@e2+!$PYU$A79'`
        url="http://rgrage:$PASSWD@mobile.ragewip.com/screentime/linux.zip"
        echo "45" ; sleep 3
        echo "# Downloading ScreenTime ... "
        wget $url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Screen Time ..."
        echo "70" ; sleep 3
        echo "# Installing ScreenTime ... "
        unzip /tmp/linux.zip -d /tmp/ >/dev/null
        echo "80" ; sleep 3
        echo "# Installing ScreenTime ... "
        dpkg -i /tmp/Screentime.deb >/dev/null 2>&1
        echo "90" ; sleep 3
        echo "# Installed ScreenTime ... "
        rm -rf /tmp/Screentime.deb > /dev/null 2>&1
        rm -rf /tmp/linux.zip > /dev/null 2>&1
    ) |
        zenity --width=500 --window-icon ".res/rage.png"  --progress \
        --title="Screen Time Installation" \
        --text="Preparing ..." \
        --percentage=0 --auto-close
        SCT_VER=$(dpkg -s screentime | grep Version: | awk -F '-' '{print $1}' | awk '{print $2}')
        zenity --window-icon ".res/rage.png" --info --width=290 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'>Screen Time Installed</span>\n\n<b><i>Version :  $SCT_VER  </i></b>✅"
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
            ins_del
        fi
}
rgk_usr_chk(){
    usr=$(users)
    zenity  --question --title="Users" --width=290 --text="<span foreground='black' font='13'>User <b>$usr</b> was detected !</span>\n\n<b><i>Do you want to install it ?</i></b>"
    if [ $? = 0 ]; then
            rgk_usr_dir
    else
            rgk_usr_lst
    fi
}
rgk_usr_lst(){
    usr=`zenity --list --radiolist --width 200 --height 250 --text "Select playlist from the list below" --title "Please User :" --column "Playlists" --column "Select" --separator="/ " $(ls -d -1 /home/* /home/local/RAGE/* | sed 's|.*/||' | xargs -L1 echo FALSE)`
    if [[ $? -eq 1 ]]; then
        zenity --width=200 --error \
        --text="installation Canceled   ❌"
        rgk_us="no"
    elif [[ $? -eq 0 ]]; then
        rgk_us="yes"
        rgk_usr_dir
    fi
}
rgk_usr_dir(){
    usr_path="/home/$usr"
    usr_path1="/home/local/RAGE/$usr"
    if [[ -d "$usr_path" ]]; then
        usrpath=$usr_path
        usr_nm=$usr
    elif [[ -d "$usr_path1" ]]; then
        usrpath=$usr_path1
        usr_nm="RAGE///$usr"
    fi
}
rgk_rm(){
    cd "$usrpath/RageKiosk"
    ./RageKiosk-uninstall.sh
}
rgk_ins_chk(){
    rgk_usr_chk
    rgk_fl="$usrpath/RageKiosk"
        if [[ -d "$rgk_fl" ]]; then
            # symc_fchk
            zenity  --window-icon ".res/done.png" --question --title="Rage Kiosk Installation" --width=290 --text="<span foreground='black' font='13'>Rage Kiosk Already Installed  ✅</span>\n\n<b><i>Do you want to remove it ?</i></b>"
            if [[ $? -eq 1 ]]; then
                zenity --width=200 --error \
                --text="installation Canceled   ❌"
            elif [ $? = 0 ]; then
                rgk_rm
                rgk_ins_chk
            fi
        else
            rgkiosk
      	fi
}
rgk_chk_cod(){
    cod=$(zenity --entry --width=200  --title "Rage Kiosk" --text "Enter Emp Code : ")
	if ! grep -wq $cod "/tmp/ragekiosk/support/userlist.txt"; then
        zenity --width=200 --error \
        --text="Invalid Emp Code ❌"
		exit;
	fi
}
rgk_dep(){
    pkgs='libxcb-xinerama0'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		pkexec --disable-internal-agent apt install libxcb-xinerama0 -y >/dev/null 2>&1
   fi
}
rgkiosk_set(){
    chmod +x /tmp/ragekiosk/InstallerRageKiosk.run
    sudo -u $usr_nm /tmp/ragekiosk/InstallerRageKiosk.run >/dev/null 2>&1
    sed -i '/export QT_QPA_PLATFORM_PLUGIN_PATH=/a export DISPLAY=:0' $usrpath/RageKiosk/RageKiosk/RageKiosk.sh
    line="30 * * * * /bin/sh $usrpath/RageKiosk/RageKiosk/RageKiosk.sh"
    line2="@reboot sleep 60 && /bin/sh $usrpath/RageKiosk/RageKiosk/RageKiosk.sh"
    (crontab -u $usr_nm -l 2>/dev/null; echo "$line" ; echo "$line2" ) | crontab -u $usr_nm -
    # (crontab -l 2>/dev/null; echo "$line" ; echo "$line2" ) | crontab -
    chusr=$(awk "/$cod/" /tmp/ragekiosk/support/userlist.txt | awk 'NR==1 {print $2}')
    sed -i -e "s/username=.*/username=$chusr/g" /tmp/ragekiosk/support/RageKiosk/loginInfo/userInformation.ini
    mkdir -p $usrpath/.local/share/RageKiosk
    cp -rf /tmp/ragekiosk/support/RageKiosk/* $usrpath/.local/share/RageKiosk/
    cp -rf /tmp/ragekiosk/support/RageKiosk-uninstall.sh $usrpath/RageKiosk/
    chown -R $usr_nm $usrpath/.local/share/RageKiosk
    chmod 777 $usrpath/.local/share/RageKiosk/log
    sudo -u $usr_nm sh $usrpath/RageKiosk/RageKiosk/RageKiosk.sh > /dev/null 2>&1
}
rgkiosk_rm(){
    rm -rf /tmp/ragekiosk > /dev/null 2>&1
    rm -rf /tmp/linux.zip > /dev/null 2>&1
}
rgkiosk(){
    (
        if [[ $rgk_us == "yes" ]]; then
            echo "10" ; sleep 3
            echo "# Preparing ... "
            PASSWD=`cat .encry.enc | openssl enc -aes-256-cbc -d -a -iter 29 -pass pass:'Lwg&u@qRnS$CwLJ9PBU5RV&w^J5EXnQ^$2s!9@e2+!$PYU$A79'`
            url="http://rgrage:$PASSWD@mobile.ragewip.com/ragekiosk/linux.zip"
            echo "20" ; sleep 3
            echo "# Downloading Rage Kiosk ... "
            wget $url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Rage Kiosk ..."
            echo "30" ; sleep 3
            echo "# Preparing Rage Kiosk ... "
            mkdir /tmp/ragekiosk >/dev/null
            unzip /tmp/linux.zip -d /tmp/ragekiosk/ >/dev/null
            echo "40" ; sleep 3
            echo "# Checking User ... "
            # rgk_usr_chk
            echo "50" ; sleep 3
            echo "# Checking User ... "
            rgk_chk_cod
            echo "60" ; sleep 3
            echo "# Installing Dependencies ... "
            rgk_dep
            echo "70" ; sleep 3
            echo "# Installing Rage Kiosk ... "
            rgkiosk_set
            echo "80" ; sleep 3
            echo "# Removing packages ... "
            rgkiosk_rm
            echo "90" ; sleep 3
            echo "# Installed Rage Kiosk ... "
            zenity --window-icon ".res/rage.png" --info --width=290 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'>Rage Kiosk Installed</span>  ✅"
        fi
    ) |
        zenity --width=500 --window-icon ".res/rage.png"  --progress \
        --title="Rage Kiosk Installation" \
        --text="Preparing ..." \
        --percentage=0 --auto-close
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
        fi
}
symc_chk(){
	    file="/usr/lib/symantec/version.sh"
        if [[ -f "$file" ]]; then
        	zenity  --window-icon ".res/done.png" --question --title="Git Installation" --width=290 --text="<span foreground='black' font='13'>Symantec Endpoint Protection Installed  ✅</span>\n\n<b><i>Do you want to remove it ?</i></b>"
            if [ $? = 0 ]; then
                symc_rm
                symc_ins
            fi
        else
            symc_ins
      	fi
}
symc_rm(){
    (
        echo "45" ; sleep 3
        echo "# Preparing Removal ... "
        cd /usr/lib/symantec/
        echo "60" ; sleep 3
        echo "# Removing Symantec Endpoint Protection ... "
        ./uninstall.sh > /dev/null
        echo "90" ; sleep 3
        echo "# Removed Symantec Endpoint Protection ... "
    ) |
        zenity --window-icon ".res/symantec.png" --width=500  --progress \
        --title="Symantec Endpoint Protection Installation" \
        --text="Removing ..." \
        --percentage=0 --auto-close
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
        fi
}
symc_ins(){
    (
        echo "25" ; sleep 3
        echo "# Preparing ... "
        #PASSWD=`cat .encry.enc | openssl enc -aes-256-cbc -d -a -iter 29 -pass pass:'Lwg&u@qRnS$CwLJ9PBU5RV&w^J5EXnQ^$2s!9@e2+!$PYU$A79'`
        url="https://bds.securitycloud.symantec.com/v1/downloads/paQPTDfeboQqeZQcpfRxZABRsO8"
        echo "50" ; sleep 3
        echo "# Downloading Symantec Endpoint Protection ... "
        wget -O /tmp/LinuxInstaller $url 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Rage Kiosk ..."
        echo "70" ; sleep 3
        echo "# Installing Symantec Endpoint Protection ... "
        cd /tmp/
        chmod +x LinuxInstaller
        ./LinuxInstaller >/dev/null
        echo "80" ; sleep 3
        echo "# Configurating Symantec Endpoint Protection ... "
        cd /usr/lib/symantec/
        ./version.sh > /tmp/symver.txt
        echo "90" ; sleep 3
        echo "# Installed Symantec Endpoint Protection ... "
        rm -rf /tmp/LinuxInstaller
    ) |
        zenity --window-icon ".res/symantec.png" --width=500  --progress \
        --title="Symantec Endpoint Protection Installation" \
        --text="Checking ..." \
        --percentage=0 --auto-close
        SYMCA_VER=`cat /tmp/symver.txt | grep "Symantec Agent for Linux" | awk 'NR==1 {print $6}'`
        SYMC_VER=`cat /tmp/symver.txt | grep "version" | awk 'NR==1 {print $2}'`
        zenity --window-icon ".res/done.png" --info --width=290 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'>Symantec Endpoint Protection Installed</span>\n\n<b><i>SEP Agent Version :  $SYMCA_VER\n\nSEP Linux Version : $SYMC_VER </i></b>✅"
        cd /tmp/
        rm -rf LinuxInstaller symver.txt > /dev/null
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
        fi
}
pinta_chk(){
    pkgs='pinta'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
		pinta_ins
    else
        PIN_VER=$(pinta --version)
        zenity --window-icon ".res/pinta.png" --info --timeout 10 --width=250 --height=100 --title="Pinta" --text "<span foreground='black' font='13'> Pinta Already Installed </span>\n\n<b><i>Version : $PIN_VER </i></b>✅"
   fi
}
pinta_ins(){
    (
        echo "5" ; sleep 3
        echo "# Added Repo ... "
        add-apt-repository ppa:pinta-maintainers/pinta-stable -y >/dev/null 2>&1
        echo "5" ; sleep 3
        echo "# Added Repo ... "
        apt-get update -y >/dev/null 2>&1
        echo "5" ; sleep 3
        echo "# Added Repo ... "
        apt-get install pinta -y >/dev/null 2>&1
        echo "5" ; sleep 3
        echo "# Added Repo ... "
    ) |
        zenity --width=500 --window-icon ".res/pinta.png"  --progress \
        --title="Domain Joining" \
        --text="Domain Joining..." \
        --percentage=0 --auto-close
        PIN_VER=$(pinta --version)
        zenity --window-icon ".res/pinta.png" --info --timeout 10 --width=250 --height=100 --title="Pinta" --text "<span foreground='black' font='13'> Pinta Installed </span>\n\n<b><i>Version : $PIN_VER </i></b>✅"
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
            ins_del
        fi
}
domainjoin(){
        cra
    (
        echo "5" ; sleep 3
        echo "# Creating tmp ... "
        cd /tmp
        echo "10" ; sleep 3
        echo "# Downloading Packages ..."
        wget https://github.com/Darkshadee/pbis-open/releases/download/9.1.0/pbis-open-9.1.0.551.linux.x86_64.deb.sh 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity  --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Domain Joining"
        echo "15" ; sleep 3
        echo "# Running Script ..."
        sh pbis-open-9.1.0.551.linux.x86_64.deb.sh >/dev/null 2>&1
        echo "20" ; sleep 3
        echo "# Pbis Running ..."
        # cd pbis-open-9.1.0.551.linux.x86_64.deb
        echo "30" ; sleep 3
        echo "# Permission Changing ..."
        # chmod +x pbis-open-9.1.0.551.linux.x86_64.deb/install.sh
        echo "50" ; sleep 3
        echo "# Running Script ..."
        # sh pbis-open-9.1.0.551.linux.x86_64.deb/install.sh  >/dev/null 2>&1
        echo "65" ; sleep 3
        echo "# Domain Joining ..."
        domainjoin-cli join --disable ssh $dom $us $pw
        echo "75" ; sleep 3
        echo "# Almost Done ..."
        #echo $us
        cd /
        echo "80" ; sleep 3
        echo "# Removing Packages ..."
        rm -rf /tmp/pbis-open-9.1.0.551.linux.x86_64.*
        echo "85" ; sleep 3
        echo "# Installing ssh ..."
        apt-get install ssh -y >/dev/null 2>&1
        echo "90" ; sleep 3
        echo "# Domain Joined Sucessfully ..."
        echo "95" ; sleep 3
        echo "# Rebooting system ..."
        rsrt
        ) |
        zenity --width=500 --window-icon ".res/progress.png"  --progress \
        --title="Domain Joining" \
        --text="Domain Joining..." \
        --percentage=0 --auto-close
        if [[ $? == 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
            ins_del
        fi
}
domain(){
            ListType=`zenity --window-icon ".res/rage.png"  --width=200 --height=170 --list --radiolist \
                --title 'Installation'\
                --text 'Select Option :' \
                --column 'Select' \
                --column 'Actions' TRUE "Join" FALSE "Remove"`
            if [[ $? -eq 1 ]]; then
                # they pressed Cancel or closed the dialog window
                zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                    --text="installation Canceled   ❌"
                exit 1
            elif [ $ListType == "Join" ]; then
                # they selected the short radio button
                    Flag="--Domain-Join"
                    domainjoin
            elif [ $ListType == "Remove" ]; then
                # they selected the short radio button
                    Flag="--Domain-Remove"
            else
                # they selected the long radio button
                Flag=""
            fi
}
php_nl_in(){
        (
            echo "25";
            echo "# Downloading php-composer ..." ; sleep 3
            wget $php_comp_nl_url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Php-composer..."
            echo "70";
            echo "# Installing Php-composer ..." ; sleep 3
            mkdir /usr/local/bin/composer >/dev/null 2>&1
            echo "60";
            mv /tmp/composer.phar /usr/local/bin/composer/ >/dev/null 2>&1
            echo "70":
            printf "alias composer='php /usr/local/bin/composer/composer.phar'" >> /etc/bash.bashrc
            echo "80";
            source /etc/bash.bashrc >/dev/null 2>&1
            echo "95";
            echo "# Installation Done ..." ;
            rm -rf /tmp/composer.phar >/dev/null 2>&1
        ) |
            zenity --width=500 --window-icon ".res/php-com.png"  --progress \
            --title="Installing PHP-Composer" \
            --text="Please wait ..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=280 --height=100 --timeout 15  --title="PHP-Composer" --text "<span foreground='black' font='13'> PHP Composer Installed  </span> ✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
php_comp_lst(){
        (
            url="https://github.com/composer/composer/releases/download/$choice/composer.phar"
            echo "25";
            echo "# Downloading php-composer ..." ; sleep 3
            wget $url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Php-composer..."
            echo "70";
            echo "# Installing Php-composer ..." ; sleep 3
            mkdir /usr/local/bin/composer >/dev/null 2>&1
            echo "60";
            mv /tmp/composer.phar /usr/local/bin/composer/ >/dev/null 2>&1
            echo "70":
            #fusn=$(ls -t /home | awk 'NR==1 {print $1}')
            printf "alias composer='php /usr/local/bin/composer/composer.phar'" >> /etc/bash.bashrc
            echo "80";
            source /etc/bash.bashrc >/dev/null 2>&1
            echo "95";
            echo "# Installation Done ..." ;
            rm -rf /tmp/composer.phar >/dev/null 2>&1
        ) |
            zenity --width=500 --window-icon ".res/php-com.png"  --progress \
            --title="Installing PHP-Composer" \
            --text="Please wait ..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=280 --height=100 --timeout 15  --title="PHP-Composer" --text "<span foreground='black' font='13'> PHP Composer Installed  </span> ✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
php_comp_nl(){
        ver_ned=$(zenity --window-icon ".res/php-com.png" --entry --width=200  --title "PHP-Composer" --text "PHP-Composer" --text="Enter Correct Version : ")
        php_comp_nl_url="https://github.com/composer/composer/releases/download/$ver_ned/composer.phar"
        # echo "$lan_nl_url"
        if curl --output /dev/null --silent --head --fail "$php_comp_nl_url"; then
            php_nl_in
        else
            zenity --window-icon ".res/error.png" --error --width=150  --title="Error" --text "<span foreground='black' font='13'> Incorrect Version !</span>"
        fi
}
php_comp(){
        lst_ph=$(curl -s https://github.com/composer/composer/tags | grep "/composer/composer/releases/tag/" | grep "<a href=" | sed 's|.*/||' | sed 's/.$//' | sed 's/.$//' | sort -Vr)
        choices=()
        mode="true"
        for name in $lst_ph ; do
            choices=("${choices[@]}" "$mode" "$name")
            mode="false"
        done
        choice=`zenity --window-icon ".res/php-com.png" --width=300 --height=380 \
            --list \
            --separator="$IFS" \
            --radiolist \
            --text="Select Versions:" \
            --column "Select" \
            --column "Versions" \
            "${choices[@]}" \
            False "Version Not Listed Here"`
        if [[ $? -eq 1 ]]; then
                # they pressed Cancel or closed the dialog window
                zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                    --text="installation Canceled   ❌"
                ins_del
                exit 1
        fi
        if [[ $choice == *"Version Not Listed Here"* ]]; then
            php_comp_nl
        elif [[ $choice == *"$choice"* ]]; then
            php_comp_lst
        else
            zenity --window-icon ".res/error.png" --error --width=150  --title="Error" --text "<span foreground='black' font='13'>Incorrect Selections !</span>"
        fi
}
php_comp_chk(){
	    file="/usr/bin/php"
       # file1="/usr/local/bin/node"
        if [[ ! -e "$file" ]]; then
        	zenity --window-icon ".res/error.png" --width=200 --error \
                --text="<span foreground='black' font='13'>PHP is not installed  ❌</span>"
        else
      		php_comp
      	fi
}
lan_las(){
    (
        echo "25";
        echo "# Getting Data from lando ..." ; sleep 3
        lan_lat=$(curl -s https://github.com/lando/lando/tags | grep "/lando/lando/releases/tag/v" | grep "<a href=" | sed 's|.*/||' | sed 's/.$//' | sed 's/.$//' | awk 'NR==1 {print $1}')
        selver=`echo "lando-$lan_lat.deb"`
        url="https://github.com/lando/lando/releases/download/$lan_lat/$selver"
        echo "50";
        echo "# Downloading Lando ..." ; sleep 3
        wget $url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Lando..."
        echo "70";
        echo "# Installing Lando ..." ; sleep 3
        dpkg -i --ignore-depends=docker-ce /tmp/$selver > /dev/null 2>&1
        echo "95";
        echo "# Installation Done ..." ; sleep 3
        rm -rf /tmp/$selver
    ) |
            zenity --width=500 --window-icon ".res/lando.png"  --progress \
            --title="Installing Lando" \
            --text="Please Wait ..." \
            --percentage=0 --auto-close
            LAN_VER=$(dpkg -s lando | grep "Version:" | awk '{print $2}')
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Lando Installed </span>\n\n<b><i>Version : $LAN_VER   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
lan_nl(){
        ver_ned=$(zenity --window-icon ".res/lando.png" --entry --width=200  --title "Lando" --text "Lando" --text="Enter Correct Version : ")
        selver=`echo "lando-v$ver_ned.deb"`
        lan_nl_url="https://github.com/lando/lando/releases/download/v$ver_ned/$selver"
        # echo "$lan_nl_url"
        if curl --output /dev/null --silent --head --fail "$lan_nl_url"; then
            lan_nl_in
        else
            zenity --window-icon ".res/error.png" --error --width=150  --title="Error" --text "<span foreground='black' font='13'> Incorrect Version !</span>"
        fi
}
lan_nl_in(){
    (
            echo "50";
            echo "# Downloading Lando ..." ; sleep 3
            wget $lan_nl_url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Lando..."
            echo "70";
            echo "# Installing Lando ..." ; sleep 3
            dpkg -i --ignore-depends=docker-ce /tmp/$selver > /dev/null 2>&1
            echo "95";
            echo "# Installation Done ..." ; sleep 3
            rm -rf /tmp/$selver
    ) |
            zenity --width=500 --window-icon ".res/lando.png"  --progress \
            --title="Installing Lando" \
            --text="Please Wait ..." \
            --percentage=0 --auto-close
            LAN_VER=$(dpkg -s lando | grep "Version:" | awk '{print $2}')
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Lando Installed </span>\n\n<b><i>Version :  $LAN_VER   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
lan_spc_l(){
    (
        selver=`echo "lando-$choice.deb"`
        url="https://github.com/lando/lando/releases/download/$choice/$selver"
        echo "50";
        echo "# Downloading Lando ..." ; sleep 3
        wget $url -P /tmp/ 2>&1 | sed -u 's/.* \([0-9]\+%\)\ \+\([0-9.]\+.\) \(.*\)/\1\n# Downloading at \2\/s, ETA \3/' | zenity --window-icon ".res/download.png" --progress --width=500 --auto-close  --title="Downloading Lando..."
        echo "70";
        echo "# Installing Lando ..." ; sleep 3
        dpkg -i --ignore-depends=docker-ce /tmp/$selver > /dev/null 2>&1
        echo "95";
        echo "# Installation Done ..." ; sleep 3
        rm -rf /tmp/$selver
    ) |
            zenity --width=500 --window-icon ".res/lando.png"  --progress \
            --title="Installing Lando" \
            --text="Please Wait ..." \
            --percentage=0 --auto-close
            LAN_VER=$(dpkg -s lando | grep "Version:" | awk '{print $2}')
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15 --title="Version Details" --text "<span foreground='black' font='13'> Lando Installed </span>\n\n<b><i>Version :  $LAN_VER   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
lan_spc(){
     lst_l=$(curl -s https://github.com/lando/lando/tags | grep "/lando/lando/releases/tag/v" | grep "<a href=" | sed 's|.*/||' | sed 's/.$//' | sed 's/.$//' )
        choices=()
        mode="true"
        for name in $lst_l ; do
            choices=("${choices[@]}" "$mode" "$name")
            mode="false"
        done
        choice=`zenity --window-icon ".res/lando.png" --width=300 --height=380 \
            --list \
            --separator="$IFS" \
            --radiolist \
            --text="Select Versions:" \
            --column "Select" \
            --column "Versions" \
            "${choices[@]}" \
            False "Version Not Listed Here"`
        if [[ $? -eq 1 ]]; then
                # they pressed Cancel or closed the dialog window
                zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                    --text="installation Canceled   ❌"
                ins_del
                exit 1
        fi
        if [[ $choice == *"Version Not Listed Here"* ]]; then
            lan_nl
        else
            lan_spc_l
        fi
}
lan_rm(){
    (
        echo "30";
        echo "# Removing Lando ..." ; sleep 3
        dpkg -P lando  >/dev/null 2>&1
        echo "95";
        echo "# Removed Lando ..." ; sleep 3
    ) |
            zenity --width=500 --window-icon ".res/lando.png"  --progress \
            --title="Removing Lando" \
            --text="Lando..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
lan_chk(){
    pkgs='lando'
	if  dpkg -s $pkgs >/dev/null 2>&1; then
		lan_rm
    fi
}
lan(){
    lan_chk
    lan_sel=`zenity --window-icon ".res/lando.png" --width=170 --height=170 --list --radiolist \
                    --title 'Lando Installation'\
                    --text 'Select Version to install:' \
                    --column 'Select' \
                    --column 'Actions' TRUE "Latest" FALSE "Specific"`

        if [[ $? -eq 1 ]]; then
                    # they pressed Cancel or closed the dialog window
            zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                --text="installation Canceled   ❌"
                exit 1
        elif [[ $lan_sel == "Latest" ]]; then
            # they selected the short radio button
                Flag="--Lando-Latest"
                lan_las
        elif [[ $lan_sel == "Specific" ]]; then
            # they selected the short radio button
                Flag="--Lando-Specific"
                lan_spc
        fi
}
nj_rm(){
    (
        echo "30";
        echo "# Removing NodeJs ..." ; sleep 3
        apt-get purge --auto-remove nodejs -y  >/dev/null 2>&1
        echo "50";
        echo "# Removing Related File ..." ; sleep 3
        rm -rf /etc/apt/sources.list.d/nodesource.list
        echo "95";
        echo "# Removed NodeJs ..." ; sleep 3
    ) |
            zenity --width=500 --window-icon ".res/nodejs.png"  --progress \
            --title="Removing NodeJs" \
            --text="NodeJs..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
npm_bichk(){
    (
        file="/usr/local/bin/npm"
        file1="/usr/local/bin/node"
        if [[ -e "$file" || -e $file1 ]]; then
            echo "30";
            echo "# Removing NodeJs ..." ; sleep 3
            rm -rf /usr/local/lib/node_modules &>/dev/null
            rm -rf /usr/local/share/man/man1/node* &>/dev/null
            rm -rf /usr/local/lib/dtrace/node.d &>/dev/null
            rm -rf ~/.npm &>/dev/null
            echo "50";
            echo "# Removing Related File ..." ; sleep 3
            rm -rf ~/.node-gyp &>/dev/null
            rm -rf /opt/local/bin/node &>/dev/null
            rm -rf opt/local/include/node &>/dev/null
            rm -rf /opt/local/lib/node_modules &>/dev/null
            echo "70";
            echo "# Removing Related File ..." ; sleep 3
            rm -rf /usr/local/lib/node* &>/dev/null
            rm -rf /usr/local/include/node* &>/dev/null
            rm -rf /usr/local/bin/node* &>/dev/null
            echo "95";
            echo "# Removed NodeJs ..." ; sleep 3
        fi
    ) |
            zenity --width=500 --window-icon ".res/nodejs.png"  --progress \
            --title="Removing NodeJs" \
            --text="NodeJs..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
npm_in(){
    zenity --window-icon ".res/question.png" --question --width=350  --text="<span foreground='black' font='13'> Did you want to install  <b>NPM Latest Version</b> ?</span>" --ok-label="Yes" --cancel-label="No"
    if [ $? = 0 ] ; then
    echo "yes"
    npm install -g npm@latest &>/dev/null
    fi
}
nj_chk(){
    pkgs='nodejs'
	if  dpkg -s $pkgs >/dev/null 2>&1; then
		nj_rm
    fi
}
nj_in(){
        (
            echo "25";
            echo "# Getting Data from NodeJs ..." ; sleep 3
            ver=$(curl -s "https://nodejs.org/dist/latest-$choice/" | grep "node" | awk -F 'node-' '{print $2 FS "/"}' | grep "v" | awk -F "/" '{print $1}' | grep "linux-x64.tar.gz" | awk -F "-" '{print $1}')
            selver=`echo "node-$ver-linux-x64.tar.gz"`
            url="https://nodejs.org/dist/latest-$choice/$selver"
            curl -o /tmp/$selver $url 2>&1 | stdbuf -oL tr '\r' '\n' | sed -u 's/^ *\([0-9][0-9]*\).*\( [0-9].*$\)/\1\n#Download Speed\:\2/' | zenity --width=500 --window-icon ".res/download.png" --progress --auto-close --title "Downloading NodeJs"
            echo "70";
            echo "# Installing NodeJs ..." ; sleep 3
            tar -C /usr/local --strip-components 1 -xzf /tmp/$selver >/dev/null
            echo "80";
            echo "# Installing NPM ..." ; sleep 3
            npm_in
            echo "95"
            echo "# Installation Done ..." ; sleep 3
            rm -rvf /tmp/$selver
        ) |
            zenity --width=500 --window-icon ".res/nodejs.png"  --progress \
            --title="Installing NodeJs" \
            --text="Please Wait ..." \
            --percentage=0 --auto-close
            NODE_VER=$(node -v)
            NPM_VER=$(npm -v)
            zenity --window-icon ".res/done.png" --info --width=150 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'> NodeJS </span>\n\n<b><i>Version : $NODE_VER   </i></b>✅\n\n<span foreground='black' font='13'> Npm </span>\n\n<b><i>Version : $NPM_VER  </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
nj_list(){
	    cl
        nj_chk
        npm_bichk
        lst=$(curl -s "https://nodejs.org/dist/" | grep "latest" | awk -F 'latest-' '{print $2 FS "/"}' | grep "v" | awk -F "/" '{print $1}'  | sort -Vr )
        choices=()
        mode="true"
        for name in $lst ; do
            choices=("${choices[@]}" "$mode" "$name")
            mode="false"
        done
        choice=`zenity --window-icon ".res/nodejs.png" --width=300 --height=380 \
            --title 'NodeJS Versions'\
            --list \
            --separator="$IFS" \
            --radiolist \
            --text="Select Versions:" \
            --column "Select" \
            --column "Versions" \
            "${choices[@]}"`
        if [[ $? -eq 1 ]]; then
                # they pressed Cancel or closed the dialog window
            zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                --text="Canceled installation"
            ins_del
            exit 1
        elif [[ $choice == *"$choice"* ]]; then
            nj_in
        else
            zenity --window-icon ".res/error.png" --error --width=150  --title="Error" --text "<b>Incorrect Selections !</b>"
        fi
}
nj_entr(){
        njent=`zenity --entry \
                --title="NodeJs Version" \
                --text="Enter Specific Version:"`
                if [[ $? -eq 1 ]]; then
                    # they pressed Cancel or closed the dialog window
                    zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 --timeout 15 \
                        --text="installation Canceled   ❌"
                    exit 1
                elif [[ -z "$njent" ]]; then
                    zenity --window-icon ".res/error.png" --error --title="Error" --width=200 \
                        --text="Invalid Version"
                    nj
                else
                    nj_entr_ins
                fi
}
nj_entr_pack(){
        (
            echo "10";
            echo "# Checking Dependency ..." ; sleep 3
            cl
            echo "20";
            echo "# Checking Package Is Exist ..." ; sleep 3
            nj_chk
            echo "40";
            echo "# Removing Exist Node ..." ; sleep 3
            npm_bichk
            echo "60";
            echo "# Getting Data from NodeJs ..." ; sleep 3
            nfn="node-v$njent-linux-x64.tar.gz"
            pack_down="$nj_url/$nfn"
            curl -o /tmp/$nfn $pack_down 2>&1 | stdbuf -oL tr '\r' '\n' | sed -u 's/^ *\([0-9][0-9]*\).*\( [0-9].*$\)/\1\n#Download Speed\:\2/' | zenity --width=500 --window-icon ".res/download.png" --progress --auto-close --title "Downloading NodeJs v$njent"
            echo "70";
            echo "# Installing NodeJs v$njent ..." ; sleep 3
            tar -C /usr/local --strip-components 1 -xzf /tmp/$nfn >/dev/null
            echo "80";
            echo "# Installing NPM ..." ; sleep 3
            npm_in
            echo "95"
            echo "# Installation Done ..." ; sleep 3
            rm -rvf /tmp/$nfn
        ) |
            zenity --width=500 --window-icon ".res/nodejs.png"  --progress \
            --title="Installing NodeJs" \
            --text="Please Wait ..." \
            --percentage=0 --auto-close
            NODE_VER=$(node -v)
            NPM_VER=$(npm -v)
            zenity --window-icon ".res/done.png" --info --width=150 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'> NodeJS </span>\n\n<b><i>Version : $NODE_VER   </i></b>✅\n\n<span foreground='black' font='13'> Npm </span>\n\n<b><i>Version : $NPM_VER  </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
nj_entr_ins(){
        nj_url="https://nodejs.org/download/release/v$njent"
        if curl --head --silent --fail "$nj_url" >/dev/null 2>&1;
        then
        nj_entr_pack
        else
            zenity --window-icon ".res/error.png" --error --title="NodeJs" --width=200 \
                --text="Invalid Version"
            nj_entr
        fi
}
nj(){
    nj_sel=`zenity --window-icon ".res/nodejs.png" --width=250 --height=170 --list --radiolist \
            --title 'NodeJs Installation'\
            --text '<b>Install From:</b>' \
            --column 'Select' \
            --column 'Actions' TRUE "NodeJs Release List" FALSE "Specific Version"`

        if [[ $? -eq 1 ]]; then
            # they pressed Cancel or closed the dialog window
            zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                --text="installation Canceled   ❌"
                exit 1
        elif [[ $nj_sel == "NodeJs Release List" ]]; then
            # they selected the short radio button
                Flag="--Nodejs-Latest"
                nj_list
        elif [[ $nj_sel == "Specific Version" ]]; then
            # they selected the short radio button
                Flag="--NodeJs-Specific"
                nj_entr
        fi
}
git_rm(){
    (
        echo "50";
        echo "# Removing Git ...";
        apt-get purge git -y >/dev/null 2>&1
        echo "95";
        echo "# Removed ! ..."; sleep 5;
    ) |
         zenity --width=500 --window-icon ".res/git.png"  --progress \
            --title="Removing Git" \
            --text="Removing Git..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="UnInstalltion Canceled   ❌ "
                # ins_del
            fi
}
gitk_rm(){
    (
        echo "50";
        echo "# Removing Gitk ...";
        apt-get purge gitk -y >/dev/null 2>&1
        echo "95";
        echo "# Removed ! ..."; sleep 5;
    ) |
         zenity --width=500 --window-icon ".res/git.png"  --progress \
            --title="Removing Gitk" \
            --text="Removing Gitk..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="UnInstalltion Canceled   ❌ "
                # ins_del
            fi
}
git_rm_cf(){
    GIT_VER=$(git --version | awk '{print $3}')
    zenity  --window-icon ".res/done.png" --question --title="Git Installation" --width=290 --text="<span foreground='black' font='13'> Git v$GIT_VER is already installed   ✅</span>\n\n<b><i>Do you want to remove it ?</i></b>"
    if [ $? = 0 ]; then
        git_rm
        gt_ans="Yes"
    else
        gt_ans="No"
    fi
}
gitk_rm_cf(){
    GITK_VER=$(dpkg -s git | grep "Version: 1:" | awk '{print $2}' | awk -F ':' '{print $2}' | awk -F '-' '{print $1}')
    zenity --window-icon ".res/done.png"  --question --title="Git Installation" --width=290 --text="<span foreground='black' font='13'> Gitk v$GITK_VER is already installed   ✅</span>\n\n<b><i>Do you want to remove it ?</i></b>"
    if [ $? = 0 ]; then
        gitk_rm
        gtk_ans="Yes"
    else
        gtk_ans="No"
    fi
}
git_chk(){
    pkgs='git'
	if dpkg -s $pkgs >/dev/null 2>&1; then
		git_rm_cf
    else
        gt_ans="Yes"
    fi
}
gitk_chk(){
    pkgs='gitk'
    if dpkg -s $pkgs2 >/dev/null 2>&1; then
        gitk_rm_cf
    else
        gtk_ans="Yes"
    fi
}

git_ins(){
    (
        echo "15";
        echo "# Getting Ready for installation ..."; sleep 5
        echo "50";
        echo  "# Installing Git ...";
        apt-get install git-all -y >/dev/null 2>&1
        echo "90";
        echo  "# Almost Done ...";
    ) |
         zenity --width=500 --window-icon ".res/git.png"  --progress \
            --title="Installing Git" \
            --text="Installing Git..." \
            --percentage=0 --auto-close
            GIT_VER=$(git --version)
            zenity --window-icon ".res/done.png" --info --width=150 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'> Git Installed </span>\n\n<b><i>Version : $GIT_VER   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
                # ins_del
            fi
}
gitk_ins(){
    (
        echo "15";
        echo "# Getting Ready for installation ..."; sleep 5
        echo "50";
        echo  "# Installing Gitk ...";
        apt-get install gitk -y >/dev/null 2>&1
        echo "90";
        echo  "# Almost Done ...";
    ) |
         zenity --width=500 --window-icon ".res/git.png"  --progress \
            --title="Installing Gitk" \
            --text="Installing Gitk..." \
            --percentage=0 --auto-close
            GITK_VER=$(dpkg -s git | grep "Version: 1:" | awk '{print $2}' | awk -F ':' '{print $2}' | awk -F '-' '{print $1}')
            zenity --window-icon ".res/done.png" --info --width=180 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'> GitK Installed </span>\n\n<b><i>Version :  $GITK_VER   </i></b>✅ "
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
                # ins_del
            fi
}
git_main(){
        git_chk
    if [[ $gt_ans == "Yes" ]]; then
        git_ins
    fi
        gitk_chk
    if [[ $gtk_ans == "Yes" ]]; then
        gitk_ins
    fi
}
MYS_CHK(){
    pkgs='mariadb-server'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
        MY_INS
    else
        MYSQL_VER=$(mysql --version | awk '{print $5}')
        zenity --window-icon ".res/mariadb.png" --info --timeout 10 --width=250 --height=100 --title="MariaDB" --text "<span foreground='black' font='13'> MariaDB Already Installed </span>\n\n<b><i>Version : $MYSQL_VER </i></b>✅"
    fi
}
MY_INS(){
    (
        echo "25" ;
        echo "# Updating Packages ..." ;
        apt-get autoremove -y >/dev/null
        dpkg --configure -a
        apt-get update -y >/dev/null
        echo "35"
        echo "# Installing MariaDB ..." ;
        apt-get install -y $pkgs >/dev/null
        echo "50" ;
        echo "# Configuring MariaDB ..." ; sleep 3
        db_root_password=root
cat <<EOF | mysql_secure_installation
y
y
$db_root_password
$db_root_password
y
y
y
y
y
EOF
        echo "75" ;
        echo "# Changing Permission ...";
        MYSQL=`which mysql`
        Q1="grant all privileges on *.* to 'root'@'%' identified by 'root';"
        Q2="FLUSH PRIVILEGES;"
        SQL="${Q1}${Q2}"
        MYSQL_VER=$(mysql --version | awk '{print $5}')
        echo "85";
        echo "# Almost Done ..."
        $MYSQL -uroot -p$db_root_password -e "$SQL"
        echo "100";
        echo  "# MariaDb has been Installed ...";
        zenity --window-icon ".res/mariadb.png" --info --timeout 10 --width=250 --height=100 --title="MariaDB" --text "<span foreground='black' font='13'> MariaDB Installed </span>\n\n<b><i>Version : $MYSQL_VER </i></b>✅"
    ) |
         zenity --width=500 --window-icon ".res/mariadb.png"  --progress \
            --title="Installing MariaDB" \
            --text="Installing MariaDB..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="UnInstalltion Canceled   ❌ "
                ins_del
            fi
}
MY_RMV(){
        (
        pkgs='mariadb-server'
        if ! dpkg -s $pkgs >/dev/null 2>&1; then
            zenity --window-icon ".res/mariadb.png" --info --timeout 10 --width=250 --height=100 --title="MariaDB" --text "<span foreground='black' font='13'> ⚠️  No MariaDB Found  ⚠️ </span>"
        else
        echo "10" ;
        echo "Killing Process" ;
        killall -KILL mysql mysqld_safe mysqld
        echo "25" ;
        echo "# Removing Mysql ..." ;
        dpkg --configure -a
        echo "30"
        service mysql stop
        echo "35"
        dpkg --configure -a
        apt-get  remove "mysql*"  -y >/dev/null
        echo "40"
        apt-get --yes autoremove --purge >/dev/null
        apt-get autoclean >/dev/null
        echo "45"
        deluser --remove-home mysql >/dev/null
        delgroup mysql >/dev/null
        rm -rf /etc/apparmor.d/abstractions/mysql /etc/apparmor.d/cache/usr.sbin.mysqld /etc/mysql /var/lib/mysql /var/log/mysql* /var/log/upstart/mysql.log* /var/run/mysql
        echo "50" ;
        echo "# Removing MariaDB-Server ..." ; sleep 3
        apt-get --purge remove  "mariadb*" -y >/dev/null
        echo "75" ;
        echo "# Removing Files ..." ; sleep 3
        rm -rf /var/lib/mysql/ >/dev/null
        echo "100" ;
        echo "# MariaDB Removed ... " ; sleep 5
        fi
        ) |
         zenity --width=500 --window-icon ".res/mariadb.png" --progress \
            --title="Removing MariaDB" \
            --text="Removing MariaDB..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="UnInstalltion Canceled   ❌ "
                ins_del
            fi
}
MYS(){
            ListType=`zenity --window-icon ".res/mariadb.png" --width=400 --height=200 --list --radiolist \
                --title 'Installation'\
                --text 'Select Software to install:' \
                --column 'Select' \
                --column 'Actions' TRUE "Install" FALSE "Remove"`
            if [[ $ListType == "Install" ]]; then
                # they selected the short radio button
                    MYS_CHK
            elif [[ $ListType == "Remove" ]]; then
                # they selected the short radio button
                    MY_RMV
            else
                zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                    --text="installation Canceled   ❌"
                ins_del
            fi
}
apache_stop(){
    if [ -x "$(command -v apache2)"  ]; then
        systemctl stop apache2 >/dev/null
        systemctl disable apache2 >/dev/null
    fi
}
nginx_stop(){
    if [ -x "$(command -v nginx)"  ]; then
        systemctl stop nginx >/dev/null
        systemctl disable nginx >/dev/null
    fi
}
php5_6_stop(){
    if [ -x "$(command -v php5.6)"  ]; then
        systemctl stop php5.6-fpm.service >/dev/null
        systemctl disable php5.6-fpm.service >/dev/null
    fi
}
php7_0_stop(){
    if [ -x "$(command -v php7.0)"  ]; then
        systemctl stop php7.0-fpm.service >/dev/null
        systemctl disable php7.0-fpm.service >/dev/null
    fi
}
php7_1_stop(){
    if [ -x "$(command -v php7.1)"  ]; then
        systemctl stop php7.1-fpm.service >/dev/null
        systemctl disable php7.1-fpm.service >/dev/null
    fi
}
php7_2_stop(){
    if [ -x "$(command -v php7.2)"  ]; then
        systemctl stop php7.2-fpm.service >/dev/null
        systemctl disable php7.2-fpm.service >/dev/null
    fi
}
php7_3_stop(){
    if [ -x "$(command -v php7.3)"  ]; then
        systemctl stop php7.3-fpm.service >/dev/null
        systemctl disable php7.3-fpm.service >/dev/null
    fi
}
php7_4_stop(){
    if [ -x "$(command -v php7.4)"  ]; then
        systemctl stop php7.4-fpm.service >/dev/null
        systemctl disable php7.4-fpm.service >/dev/null
    fi
}
php8_0_stop(){
    if [ -x "$(command -v php8.0)"  ]; then
        systemctl stop php8.0-fpm.service >/dev/null
        systemctl disable php8.0-fpm.service >/dev/null
    fi
}
php5_6(){
    (
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
 		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 5.6 ...";
        apt-get install php5.6-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 5.6 extensions ...";
        apt-get install php5.6-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
		echo "75";
        echo "# Configuring ..."; sleep 3
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9002/g' /etc/php/5.6/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ...";
		sudo update-rc.d php5.6-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 5.6 Installed ...";
	else
        echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
        echo "50";
        echo "# Updating ..."
		apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 5.6 ...";
        apt-get install php5.6-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 5.6 extensions ...";
        apt-get install php5.6-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
		echo "75";
        echo "# Configuring ..."; sleep 3
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9002/g' /etc/php/5.6/fpm/pool.d/www.conf
		echo "90";
        echo "# Almost Done ...";
        sudo update-rc.d php5.6-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 5.6 Installed ...";
    fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 5.6 Installing" \
            --text="PHP 5.6 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :   5.6   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
            fi
}
php7_0(){
    (
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.0 ...";
        apt-get install php7.0-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.0 extensions ...";
        apt-get install php7.0-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ..."; sleep 3
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9001/g' /etc/php/7.0/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ...";
        sudo update-rc.d php7.0-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.0 Installed ...";
	else
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.0 ...";
        apt-get install php7.0-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.0 extensions ...";
        apt-get install php7.0-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ..."; sleep 3
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9001/g' /etc/php/7.0/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.0-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.0 Installed ...";
	fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 7.0 Installing" \
            --text="PHP 7.0 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :   7.0   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
            fi
}
php7_1(){
    (
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.1 ...";
        apt-get install php7.1-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.1 extensions ...";
        apt-get install php7.1-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9000/g' /etc/php/7.1/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.1-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.1 Installed ...";
	else
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.1 ...";
        apt-get install php7.1-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.1 extensions ...";
        apt-get install php7.1-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9000/g' /etc/php/7.1/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.1-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.1 Installed ...";
	fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 7.1 Installing" \
            --text="PHP 7.1 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :   7.1   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
            fi
}
php7_2(){
	(
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.2 ...";
        apt-get install php7.2-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.2 extensions ...";
        apt-get install php7.2-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.2/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.2-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.2 Installed ...";
	else
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.2 ...";
        apt-get install php7.2-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.2 extensions ...";
        apt-get install php7.2-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.2/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.2-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.2 Installed ...";
	fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 7.2 Installing" \
            --text="PHP 7.2 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :   7.2   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
            fi
}
php7_3(){
	(
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.3 ...";
        apt-get install php7.3-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.3 extensions ...";
        apt-get install php7.3-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.3/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.3-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.3 Installed ...";
	else
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.3 ...";
        apt-get install php7.3-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.3 extensions ...";
        apt-get install php7.3-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.3/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.3-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.3 Installed ...";
	fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 7.3 Installing" \
            --text="PHP 7.3 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :   7.3   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
            fi
}
php7_4(){
	(
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.4 ...";
        apt-get install php7.4-{common,cli,fpm} -y >/dev/null
        echo "70";
        echo "# Installing PHP 7.4 extensions ...";
        apt-get install php7.4-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.4/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.4-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.4 Installed ..."; sleep 3
	else
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 7.4 ...";
        apt-get install php7.4-{common,cli,fpm} -y >/dev/null
        echo "68";
        echo "# Installing PHP 7.4 extensions ...";
        apt-get install php7.4-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9003/g' /etc/php/7.4/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php7.4-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 7.4 Installed ..."; sleep 3
	fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 7.4 Installing" \
            --text="PHP 7.4 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :   7.4   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
            fi
}
php8_0(){
	(
        echo "5";
        echo "# Checking Repository ..."; sleep 3
	pkgs='software-properties-common'
	if ! dpkg -s $pkgs >/dev/null 2>&1; then
        echo "15";
        echo "# Installing Repository ...";
		apt-get install software-properties-common -y >/dev/null
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 8.0 ...";
        apt-get install php8.0-common php8.0-cli php8.0-fpm -y >/dev/null
        echo "70";
        echo "# Installing PHP 8.0 extensions ...";
        apt-get install php8.0-{curl,intl,mysql,readline,xml,gd,imap,intl,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip,bcmath} -y >/dev/null
        # apt-get install php8.0-fpm php8.0-bcmath php8.0-cli php8.0-common php8.0-curl php8.0-gd php8.0-intl php8.0-imap php8.0-json php8.0-ldap php8.0-mbstring php8.0-mysql php8.0-sqlite3  php8.0-pspell php8.0-soap php8.0-tidy php8.0-xml php8.0-xsl php8.0-zip -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9004/g' /etc/php/8.0/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php8.0-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 8.0 Installed ..."; sleep 3
	else
		echo "20";
        echo "# Adding Packages ...";
        add-apt-repository ppa:ondrej/php -y >/dev/null
		echo "50";
        echo "# Updating ..."
        apt-get update -y >/dev/null
        echo "60";
        echo "# Installing PHP 8.0 ...";
        apt-get install php8.0-common php8.0-cli php8.0-fpm -y >/dev/null
        echo "70";
        echo "# Installing PHP 8.0 extensions ...";
        apt-get install php8.0-{bcmath,curl,gd,intl,imap,ldap,mbstring,mysql,sqlite3,pspell,soap,tidy,xml,xsl,zip} -y >/dev/null
        echo "75";
        echo "# Configuring ...";
        sudo sed -i -e 's/listen =.*/listen = 127.0.0.1:9004/g' /etc/php/8.0/fpm/pool.d/www.conf
        echo "90";
        echo "# Almost Done ..."; sleep 3
        sudo update-rc.d php8.0-fpm defaults >/dev/null
        echo "100";
        echo "# PHP 8.0 Installed ..."; sleep 3
	fi
    ) |
        zenity --width=500 --window-icon ".res/php.png"  --progress \
            --title="PHP 8.0 Installing" \
            --text="PHP 8.0 Installing..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --width=200 --height=100 --timeout 15  --title="Version Details" --text "<span foreground='black' font='13'>PHP Installed !</span>\n\n<b><i>Version :  8.0   </i></b>✅"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌ "
                ins_del
            fi
}
php_ver(){

    php_sel=$(zenity --window-icon ".res/php.png" --width=150 --height=280 --checklist --list \
                --title='PHP'\
                --text="<b>Select PHP Version To Install :</b>"\
                --column="Select" --column="Version List" \
                " " "8.0" \
                " " "7.4" \
                " " "7.3" \
                " " "7.2" \
                " " "7.1" \
                " " "7.0" \
                " " "5.6"
                )

        if [[ $? -eq 1 ]]; then
                # they pressed Cancel or closed the dialog window
                zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                    --text="installation Canceled   ❌ "
                # ins_del
                exit 1
        fi
        if [[ -z "$php_sel" ]]; then
                # they selected the short radio button
                zenity --width=200 --height=25 --timeout 15 --error \
                --text="Select Any One To Install ⚠️"
                # ins
        fi
        if [[ $php_sel == *"8.0"* ]]; then
            if ! [ -x "$(command -v php8.0)"  ]; then
                php8_0
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   8.0   </i></b>✅"
            fi
        fi
        if [[ $php_sel == *"7.4"* ]]; then
            if ! [ -x "$(command -v php7.4)"  ]; then
                php7_4
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   7.4   </i></b>✅"
            fi
        fi
        if [[ $php_sel == *"7.3"* ]]; then
            if ! [ -x "$(command -v php7.3)"  ]; then
                php7_3
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   7.3   </i></b>✅"
            fi
        fi
        if [[ $php_sel == *"7.2"* ]]; then
           if ! [ -x "$(command -v php7.2)"  ]; then
                    php7_2
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   7.2   </i></b>✅"
            fi
        fi
        if [[ $php_sel == *"7.1"* ]]; then
            if ! [ -x "$(command -v php7.1)"  ]; then
                    php7_1
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   7.1   </i></b>✅"
            fi
        fi
        if [[ $php_sel == *"7.0"* ]]; then
            if ! [ -x "$(command -v php7.0)"  ]; then
                    php7_0
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   7.0   </i></b>✅"
            fi
        fi
        if [[ $php_sel == *"5.6"* ]]; then
            if ! [ -x "$(command -v php5.6)"  ]; then
                    php5_6
            else
                zenity --window-icon ".res/done.png" --info --timeout 10 --width=190 --height=100 --title="Version Details" --text "<span foreground='black' font='13'> PHP Already Installed</span>\n\n<b><i>Version :   5.6   </i></b>✅"
            fi
        fi
}
NG(){
    (
        echo "10";
        echo "# Checking Package ..."; sleep 3
        pkgs='nginx'
        if ! dpkg -s $pkgs >/dev/null 2>&1; then
            echo "30";
            echo "# Updating Package ...";
            cd /tmp/
            wget http://nginx.org/keys/nginx_signing.key >/dev/null
            apt-key add nginx_signing.key >/dev/null
            sh -c "echo 'deb http://nginx.org/packages/ubuntu/ '$(lsb_release -cs)' nginx' > /etc/apt/sources.list.d/Nginx.list" >/dev/null
            apt-get update -y >/dev/null
            echo "50";
            echo "# Installing Nginx ...";
            apt-get install -y $pkgs >/dev/null
            echo "80";
            echo "Setting up ..."; sleep 3
            update-rc.d nginx defaults >/dev/null
            rm -rf /tmp/nginx*
            echo "100";
            echo "# Nginx Installed ..."; sleep 3
        fi
    ) |
         zenity --width=500 --window-icon ".res/nginx.png"  --progress \
            --title="Installing Nginx" \
            --text="Installing Nginx..." \
            --percentage=0 --auto-close
            zenity --window-icon ".res/done.png" --info --timeout 10 --width=200  --no-wrap --title="NginX" --text "<span foreground='black' font='13'>Nginx Installed Sucessfully  ✅  </span>"
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
mar(){
        (
            echo "10" ; sleep 3
            echo "# Updating mail logs" ; sleep 3
            echo "20" ; sleep 3
            echo "# Resetting cron jobs" ; sleep 3
            echo "50" ; sleep 3
            echo "This line will just be ignored" ; sleep 3
            echo "75" ; sleep 3
            echo "# Rebooting system" ; sleep 3
            echo "100" ; sleep 3
        ) |
        zenity --width=500 --window-icon ".res/progress.png"  --progress \
        --title="Installing NodeJs" \
        --text="NodeJs..." \
        --percentage=0
        if [[ $? -eq 1 ]]; then
            zenity --window-icon ".res/error.png" --width=200 --error \
            --text="installation Canceled   ❌"
            ins_del
        fi
}
DOCK_COMP(){
    (
        echo "10";
        echo "# Checking Package ...";
        echo "25";
        echo "# Downloading Docker-compose ...";
        curl -s -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null
        chmod +x /usr/local/bin/docker-compose
        echo "50";
        echo "# Installing Docker-compose ...";
        apt-get install -y docker-compose >/dev/null
        echo "100";
        echo "# Docker-compose Installed ..."; sleep 3
    ) |
        zenity --width=500 --window-icon ".res/docker.png"  --progress \
            --title="Installing Docker-Compose-" \
            --text="Installing Docker-Compose..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
}
DOCK_CHK(){
    if [ ! -x "$(command -v docker)" ]; then
        DOCK_IN
        DOCK_CHK
    elif [ ! -x "$(command -v docker-compose)" ]; then
        DOCK_COMP
        DOCK_CHK
    else
        DOCOM_VER=$(docker-compose --version | awk '{print $3}' | sed 's/.$//')
        DOCK_VER=$(docker --version | awk '{print $3}' | sed 's/.$//')
        zenity --window-icon ".res/done.png" --info --timeout 15 --width=300 --height=100 --title="Docker Installation" --text "<span foreground='black' font='13'>Docker Already Installed</span>\n\n<b><i>Docker Version : $DOCK_VER  ✅\n\nDocker-compose Version : $DOCOM_VER  ✅</i></b>"
    fi
}
DOCK_IN(){
    # optr=`zenity --list --radiolist --column="Select" --column="Actions" $(ls  /home/local/RAGE/  | awk -F'\n' '{print NR, $1}')`
    if [[ $? -eq 0 ]]; then
        (
            per='RAGE\'
            domain='RAGE\domain^users'
            path=' /home/local/RAGE/'"$optr"
            echo "10";
            echo "# Collecting Data ..."; sleep 5
            # cd $path
            #"Permission Changing"
            echo "23";
            echo "# Changing Project Permission ..."; sleep 5
            # chown -R $per''$optr:$domain projects/
            echo "32";
            echo "# Installing dependencies ...";
            apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common -y >/dev/null
            echo "40";
            echo "# Adding Docker Repo ...";
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  >/dev/null
            add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable"  -y  >/dev/null
            echo "53";
            echo "# Updating and Installing Docker-ce ...";
            apt-get update -y  >/dev/null
            apt-get install docker-ce docker-ce-cli containerd.io -y  >/dev/null
            systemctl start docker
            systemctl enable docker
            echo "60";
            echo "# Stoping PHP 5.6 ...";
            php5_6_stop
            echo "65";
            echo "# Stoping PHP 7.0 ...";
            php7_0_stop
            echo "70";
            echo "# Stoping PHP 7.1 ...";
            php7_1_stop
            echo "73";
            echo "# Stoping PHP 7.2 ...";
            php7_2_stop
            echo "75";
            echo "# Stoping PHP 7.3 ...";
            php7_3_stop
            echo "78";
            echo "# Stoping PHP 7.4 ...";
            php7_4_stop
            echo "78";
            echo "# Stoping PHP 8.0 ...";
            php8_0_stop
            echo "85";
            echo "# Stoping Nginx ...";
            nginx_stop
            echo "90";
            echo "# Stoping Apache ...";
            apache_stop
            echo "95";
            echo "# Configuring Docker Setup ...";
            sudo sed -i -e 's/SocketMode=.*/SocketMode=0666/g' /lib/systemd/system/docker.socket
            systemctl daemon-reload
            systemctl stop docker.socket
            systemctl start docker.socket
            echo "100"; sleep 5
            echo "# Docker Installed ...";
        ) |
            zenity --width=500 --window-icon ".res/docker.png"  --progress \
            --title="Docker Installation" \
            --text="Docker Installation..." \
            --percentage=0 --auto-close
            if [[ $? -eq 1 ]]; then
                zenity --window-icon ".res/error.png" --width=200 --error \
                --text="installation Canceled   ❌"
                ins_del
            fi
    else
        zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                        --text="Installtaion Canceled "
        ins_del
        exit 1 ;
    fi
}
RES(){
    RES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.res"
        if [[ ! -e "$RES_DIR" ]]; then
            curl -sLJo res.zip https://github.com/AShuuu-Technoid/Ubuntu_Software_Installtion/archive/refs/heads/res.zip >/dev/null
            mkdir .res >/dev/null
            unzip res.zip >/dev/null
            mv Ubuntu_Software_Installtion-res/* .res/ >/dev/null
            rm -rf Ubuntu_Software_Installtion-res >/dev/null
            rm -rf res.zip >/dev/null
      	fi
}
ins(){
    clear
    RES
    if [ `whoami` != root ]; then
            zenity --window-icon ".res/error.png" --width=350 --error \
            --text="Please Run This Scripts As <b>root</b> Or As <b>Sudo User</b>"
            exit
    else
            # apt-get install -y zenity >/dev/null
            ListType=$(zenity --window-icon ".res/rage.png" --width=400 --height=490 --checklist --list \
                --title='Ubuntu Software Installation'\
                --text="<b>Select Software to install :</b>\n <span foreground='red' font='10'>⚠️ NOTE : Don't select Domain-join in multi selection. ⚠️ </span>"\
                --column="Select" --column="Software List" \
                " " "Domain-Join" \
                " " "Chrome" \
                " " "NodeJs" \
                " " "MariaDB" \
                " " "PHP" \
                " " "Composer (php)" \
                " " "Nginx" \
                " " "Docker" \
                " " "Lando" \
                " " "Git"  \
                " " "VS Code" \
                " " "Meld" \
                " " "Screen Time" \
                " " "Rage Kiosk" \
                " " "Symantec Endpoint Protection"
                )
            if [[ $? -eq 1 ]]; then
                # they pressed Cancel or closed the dialog window
                zenity --window-icon ".res/error.png" --error --title="Declined" --width=200 \
                    --text="installation Canceled   ❌"
                ins_del
                exit 1
            fi
            if [[ -z "$ListType" ]]; then
                # they selected the short radio button
                zenity --width=200 --height=25 --timeout 15 --error \
                --text="Select Any One To Install ⚠️"
                ins
            fi
            if [[ $ListType == *"Domain-Join"* ]]; then
                # they selected the short radio button
                Flag="--Domain-Join"
                domain
            fi
            if [[ $ListType == *"Chrome"* ]]; then
                # they selected the short radio button
                Flag="--Chrome"
                chrm_chk
            fi
            if [[ $ListType == *"NodeJs"* ]]; then
                # they selected the short radio button
                Flag="--NodeJs"
                nj
            fi
            if [[ $ListType == *"MariaDB"* ]]; then
                # they selected the short radio button
                Flag="--MariaDB"
                MYS
            fi
            if [[ $ListType == *"PHP"* ]]; then
                # they selected the short radio button
                Flag="--PHP"
                php_ver
            fi
            if [[ $ListType == *"Composer"* ]]; then
                # they selected the short radio button
                Flag="--Composer"
                php_comp_chk
            fi
            if [[ $ListType == *"Nginx"* ]]; then
                # they selected the short radio button
                Flag="--Nginx"
                NG
            fi
            if [[ $ListType == *"Docker"* ]]; then
                # they selected the short radio button
                Flag="--Docker"
                DOCK_CHK
            fi
            if [[ $ListType == *"Lando"* ]]; then
                # they selected the short radio button
                Flag="--Lando"
                lan
            fi
            if [[ $ListType == *"Git"* ]]; then
                # they selected the short radio button
                Flag="--Git"
                git_main
            fi
            if [[ $ListType == *"VS Code"* ]]; then
                # they selected the short radio button
                Flag="--VS Code"
                vscd_chk
            fi
            if [[ $ListType == *"Meld"* ]]; then
                # they selected the short radio button
                Flag="--Meld"
                mld_chk
            fi
            if [[ $ListType == *"Screen Time"* ]]; then
                # they selected the short radio button
                Flag="--Screen Time"
                scntm_chk
            fi
            if [[ $ListType == *"Rage Kiosk"* ]]; then
                # they selected the short radio button
                Flag="--Rage Kiosk"
                rgk_ins_chk
            fi
            if [[ $ListType == *"Symantec Endpoint Protection"* ]]; then
                # they selected the short radio button
                Flag="--SEP"
                symc_chk
            fi

            # exit 0
    fi
}
ins
