satat_vps_changes_activate(){
  set -euo pipefail

  if [ "$#" -ne 1 ]; then
    echo "Script requires:"
    echo "1. Target Hostname"
    return 1
  fi

  TARGET_HOSTNAME=$1
  ssh root@$TARGET_HOSTNAME "systemctl restart sshd && ufw enable"
}

satat_vps_firewall_configure(){
  set -euo pipefail

  if [ "$#" -ne 2 ]; then
    echo "Script requires:"
    echo "1. Target Hostname"
    echo "2. Port"
    return 1
  fi

  TARGET_HOSTNAME=$1
  PORT=$2

  ssh root@$TARGET_HOSTNAME "apt-get install -y ufw"
  ssh root@$TARGET_HOSTNAME "ufw reset"
  ssh root@$TARGET_HOSTNAME "ufw default deny incoming"
  ssh root@$TARGET_HOSTNAME "ufw default allow outgoing"
  ssh root@$TARGET_HOSTNAME "ufw allow $PORT"
}

satat_vps_ssh_configure(){
  set -euo pipefail

  if [ "$#" -ne 2 ]; then
    echo "Script requires:"
    echo "1. Target Hostname"
    echo "2. PORT"
    return 1
  fi

  TARGET_HOSTNAME=$1
  PORT=$2

  ssh root@$TARGET_HOSTNAME "apt-get install -y rsync"
  ssh root@$TARGET_HOSTNAME "echo \"
  Port $PORT
  PermitRootLogin no
  MaxAuthTries 1
  LoginGraceTime 10s
  ChallengeResponseAuthentication no
  KerberosAuthentication no
  GSSAPIAuthentication no
  X11Forwarding no
  PermitUserEnvironment no
  AllowAgentForwarding no
  AllowTcpForwarding no
  PermitTunnel no
  DebianBanner no
  PermitEmptyPasswords no
  PasswordAuthentication no
  UsePAM no
  \" > /etc/ssh/sshd_config"
}

satat_vps_system_update(){
  set -euo pipefail

  if [ "$#" -ne 1 ]; then
    echo "Script requires:"
    echo "1. Target Hostname"
    return 1
  fi

  TARGET_HOSTNAME=$1

  ssh root@$TARGET_HOSTNAME "apt-get update -y"
  ssh root@$TARGET_HOSTNAME "apt-get upgrade -y"
}

satat_vps_user_add(){
  set -euo pipefail

  if [ "$#" -ne 2 ]; then
    echo "Script requires:"
    echo "1. Target Hostname"
    echo "2. Username"
    return 1
  fi

  TARGET_HOSTNAME=$1
  USERNAME=$2

  ssh root@$TARGET_HOSTNAME "useradd -m $USERNAME"
  ssh root@$TARGET_HOSTNAME "usermod -aG sudo $USERNAME"
  ssh root@$TARGET_HOSTNAME "passwd $USERNAME"
  ssh root@$TARGET_HOSTNAME "chsh -s /bin/bash $USERNAME"
}
