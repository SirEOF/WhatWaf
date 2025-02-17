#!/bin/bash


CURRENT_WHATWAF_VERSION=$(cat ./lib/settings.py | grep 'VERSION = ' | cut -d' ' -f 3 | cut -d'"' -f 2)


function helpPage {
  echo -e "\n./setup.sh {install|remove}\n";
}

function banner {
    echo -e "	                          ,------.   ";
    echo -e "	                         '  .--.  '  ";
    echo -e "	,--.   .--.   ,--.   .--.|  |  |  |  ";
    echo -e "	|  |   |  |   |  |   |  |'--'  |  |  ";
    echo -e "	|  |   |  |   |  |   |  |    __.  |  ";
    echo -e "	|  |.'.|  |   |  |.'.|  |   |   .'   ";
    echo -e "	|         |   |         |   |___|    ";
    echo -e "	|   ,'.   |hat|   ,'.   |af .---.    ";
    echo -e "	'--'   '--'   '--'   '--'   '---'    ";
    echo -e "\"/><sCRIPT>ALeRt(\\\"WhatWaf?<|>v$CURRENT_WHATWAF_VERSION\\\");</scRiPT>";
}

function install {
  home="$HOME/.whatwaf";
  exec_dir="$home/.install/bin";
  exec_filename="$exec_dir/whatwaf"
  copy_dir="$home/.install/etc";
  mkdir $home;
  mkdir $home/.install
  mkdir $exec_dir;
  mkdir $copy_dir;
  chmod +x ./trigger.py
  echo "copying files over..";
  rsync -drq . $copy_dir
  echo "creating executable";
  cat << EOF > $exec_filename
#!/bin/bash
# this is the execution script for whatwaf
# created by the whatwaf installer on $(date +%F)
# this execution script was designed with version $CURRENT_WHATWAF_VERSION
# installation. If you have any issues with this execution script or this
# installation please report them here: https://github.com/Ekultek/WhatWaf/issues/new
cd $copy_dir
exec python whatwaf.py \$@
EOF
  echo "editing file stats";
  chmod +x $exec_filename;
  echo "export PATH=\"$PATH:$exec_dir\"" >> $HOME/.bash_profile;
  echo "installed, you need to run: source ~/.bash_profile if you notice that the installation does not work as expected";
}

function uninstall {
  rm -rf ~/.trigger
  echo "home directory removed, manually remove the export PATH pertaining to $HOME/.whatwaf/bin"
}

function main {
  echo "deprecated in favor of setup.py (USAGE: python setup.py install) this script will be removed by version 3.0";
  echo "to continue with this type of installation press enter, otherwise CNTRL-C";
  read;
  banner;
  if [[ "$1" == "install" ]]; then
    echo -e " Installing:";
    install;
    echo -e "Successfully installed WhatWaf v$CURRENT_WHATWAF_VERSION";
  elif [[ "$1" == "remove" ]]; then
    echo -e " Uninstalling:";
    uninstall;
    echo -e "Successfully uninstalled WhatWaf";
  else
    helpPage;
  fi;
}

main $@;
