#!/bin/bash

# ================= COLORS =================
R="\e[1;31m"  # Red
G="\e[1;32m"  # Green
Y="\e[1;33m"  # Yellow
C="\e[1;36m"  # Cyan
W="\e[1;37m"  # White
N="\e[0m"     # Reset

# ================= HEADER =================
display_header() {
    clear
    cat << "EOF"
=================================================================
  ███████╗ █████╗ ███╗   ███╗      ██████╗  ███████╗ ██╗   ██╗
  ██╔════╝██╔══██╗████╗ ████║      ██╔══██╗ ██╔════╝ ██║   ██║
  ███████╗███████║██╔████╔██║ ████ ██║  ██║ █████╗   ██║   ██║
  ╚════██║██╔══██║██║╚██╔╝██║ ╚══╝ ██║  ██║ ██╔══╝    ██╗ ██╔╝
  ███████║██║  ██║██║ ╚═╝ ██║      ██████╔╝ ███████╗   ╚███╔╝ 
  ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝      ╚═════╝  ╚══════╝    ╚══╝  

                      SAM89x VM Manager
                    Powered by hopingboyz
=================================================================
EOF
}

# ================ MENU ===================
print_menu() {
    echo -e "${C}[1] IDX Tool Setup${N}"
    echo -e "${C}[3] Exit${N}\n"
}

# ================ MAIN LOOP ===============
while true; do
    display_header
    print_menu
    read -p "Select Option [1-3]: " op
    echo

    case $op in
        1)
            clear
            display_header
            echo -e "${Y}Starting IDX Tool Setup...${N}\n"

            # ================= IDX TOOL LOGIC =================
            mkdir -p ~/vps123
            cd ~/vps123 || { echo "vps123 folder not found!"; read -p "Press Enter..."; continue; }

            echo -e "${Y}Cleaning old files...${N}"
            rm -rf myapp flutter

            if [ ! -d ".idx" ]; then
                echo -e "${G}Creating .idx directory...${N}"
                mkdir .idx
                cd .idx || exit

                echo -e "${C}Creating dev.nix configuration...${N}"
                cat <<EOF > dev.nix
{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = with pkgs; [
    unzip
    openssh
    git
    qemu_kvm
    sudo
    cdrkit
    cloud-utils
    qemu
  ];

  env = { EDITOR = "nano"; };

  idx = {
    extensions = ["Dart-Code.flutter" "Dart-Code.dart-code"];
    workspace = { onCreate = { }; onStart = { }; };
    previews = { enable = false; };
  };
}
EOF
                echo -e "${G}IDX Tool Setup Complete!${N}"
            else
                echo -e "${Y}IDX Tool already set up — skipping.${N}"
            fi

            read -p "Press Enter to return to menu..."
            ;;
        2)
            clear
            display_header
            echo -e "${Y}Running VPS Maker (VM Script)...${N}\n"

            # ================= VM SCRIPT =================
            # Run the VM script in a temporary directory
            TMPDIR=$(mktemp -d)
            pushd "$TMPDIR" >/dev/null || exit
            curl -fsSL https://raw.githubusercontent.com/Sam89x/vms/main/vm.sh -o vm.sh
            chmod +x vm.sh
            bash vm.sh
            popd >/dev/null
            rm -rf "$TMPDIR"

            read -p "Press Enter to return to menu..."
            ;;
        3)
            clear
            echo -e "${R}Exiting VPS Manager... Goodbye!${N}\n"
            exit 0
            ;;
        *)
            echo -e "${R}Invalid option! Please select 1, 2, or 3.${N}"
            sleep 1
            ;;
    esac
done
