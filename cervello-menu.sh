#! /usr/bin/env bash
# IP config menu script

####################
#([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])

# I want 1-254
# can spread 
# 1-99    [1-9][0-9]
# 100-199 1[0-9]{2}
# 200-249 2[0-4]00-9]
# 250-254 25[0-4]
# [1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4]
#((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$

rx='(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$'
rx_init='([1-2]?[0-5]|1[1-2]{2}|2'

echo "Cervello Configurator"

while true
do
          echo "1. Config Parameters"
          echo "2. Display Parameters"
          read -p "Menu:  " MainMenu
          if [[ "$MainMenu" == "1" ]]
           then
		          echo "1. Config IP"
              echo "2. Configure SNMP"
              echo "3. Configure IP Route"
              echo "4. Configure DNS"

              read -p "Menu:  " ConfigMenu
                    if [[ "$ConfigMenu" == "1" ]]
                    then
            
            
                  # user input:
                  read -p 'Enter IP: ' IP_STRING
                  if [[ $IP_STRING =~ ^$rx ]]; then
                    echo "success"
                    
                    
                  else
                    echo "Not a valid IP address"
                    exit 0
                  fi
                
                  ########################
                 if [[ "$ConfigMenu" == "3" ]]
                  then
                  read -p 'Enter subnet: ' SUBNET_STRING
                  if [[ $SUBNET_STRING =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
                    echo "success"
                  else
                    echo "Not a valid IP address"
                    exit 0
                  fi

                  
                  read -p 'Enter deafault gateway: ' DEFAULT_GATEWAY
                  if [[ $DEFAULT_GATEWAY =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then 
                      echo "success"
                  else
                    echo "Not a valid IP address"
                    exit 0
                  fi
                fi
                if [[ "$ConfigMenu" == "4" ]]
                  then
                  read -p 'Enter DNS addresses (for multiple addresses, separate with comma - 8.8.8.8,1.1.1.1):' DNS_STR
                  if [[ $DNS_STR =~ ^(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?),)*((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
                    echo "success"
                  else
                    echo "Not a valid IP address, for multiple addresses, separate with comma."
                    exit 0
                  fi

                fi
      
      
            
      
                  # Get current netplan config
                  cd /etc/netplan
                  CONFIG_FILE=$(ls | sort -V | tail -n 1)
                  echo "Working netplan config file is: $CONFIG_FILE"
                  cd ~/
                  CONF_PATH="/etc/netplan/$CONFIG_FILE"
                  # To grab:
                  VERSION_STRING="$(grep -oP 'version:\s\K\w+' $CONF_PATH)"
                  RENDERER="$(grep -oP 'renderer:\s\K\w+' $CONF_PATH)"
   # Create new netplan config 
cd ~/
rm ~/$CONFIG_FILE
touch ~/$CONFIG_FILE
cat <<EOT >> ~/$CONFIG_FILE
network:
  version: SEDLOOKUP1
  renderer: SEDLOOKUP2
  ethernets:
    enp03s:
      dhcp4: no
      addresses: [SEDLOOKUP3/SED_Subnet]
      gateway4: SEDLOOKUP4
      nameservers:
        addresses: [SEDLOOKUP5]
EOT
                  # replace version in new config file
                  sed -i "s/SEDLOOKUP1/$VERSION_STRING/g" ~/01-network-manager-all.yaml
                  # replace renderer in new config file
                  sed -i "s/SEDLOOKUP2/$RENDERER/g" ~/01-network-manager-all.yaml
                  # replace IP address in new config file
                  sed -i "s/SEDLOOKUP3/$IP_STRING/g" ~/01-network-manager-all.yaml
                  # replace subnet in new config
                  sed -i "s/SED_Subnet/$SUBNET_STRING/g" ~/01-network-manager-all.yaml
                  # replace default gateway
                  sed -i "s/SEDLOOKUP4/$DEFAULT_GATEWAY/g" ~/01-network-manager-all.yaml
                  # replace DNS addresses 
                  sed -i "s/SEDLOOKUP5/$DNS_STR/g" ~/01-network-manager-all.yaml
                  printf "\n"
                  echo "The following configuration file is:"
                  echo "$CONFIG_FILE"
                  printf "\n"
                  echo "And it contains the following:"
                  printf "\n"
                  echo "---"
                  cat ~/01-network-manager-all.yaml
                  echo "---"
                  echo "In the following step, this script will replace the existing $CONFIC_FILE in the netplan directory, currently there is no backup to the existing config file"
                  # Moving netplan config
                  read -p "Are all settings correct? (y/n)" -n 1 -r
                  echo
                  if [[ ! $REPLY =~ ^[Yy]$ ]]
                  then
                      exit 1
                  fi
                
                if [[ "$ConfigMenu" == "2" ]]
                then
                  mv ~/$CONFIG_FILE ~/test/$CONFIG_FILE
                  apt update
                  apt install snmpd
                  apt-get install snmpd snmp snmp-mibs-downloader          
                  snmpconf
                       
                       
                       
                  #!/bin/bash
                  # Define the filename
                  echo -e "\n"
                  read -p "enter Community name " COMU
                  sed -i "s/public/$COMU/" /etc/snmp/snmp.conf
                  service snmpd restart   
                  echo -e "\n"

                  read -p "SNMP V3? (y = yes) " SNMPMenu
                    if [[ "$SNMPMenu" == "y" ]]
                      then
                         apt-get -y install snmp snmpd libsnmp-dev
                         net-snmp-config --create-snmpv3-user -ro
                    fi  
          fi
          
	  else
	      if [[ "$MainMenu" == "2" ]]
	       then
         		  echo "1. Display IP"
              echo "2. Display SNMP"
              echo "3. Display IP Route"
              
              read -p "Menu: " DisplayMenu
	        
          if [[ "$DisplayMenu" == "1" ]]
          then
              apt-get install net-tools
              ifconfig | grep -i mask
          fi

`         if [[ "$DisplayMenu" == "3" ]]
          then 
             netstat -nr 
          fi

          if [[ "$DisplayMenu" == "2" ]]
          then
              cat /etc/snmp/snmp.conf
              echo -e "\n"
              cat /etc/snmp/snmpd.conf
          fi
        fi 
    
    fi
         
done