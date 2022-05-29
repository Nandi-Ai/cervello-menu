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
#((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)

AskForSubnetMask ()

{
    while true
                   do
                        read -p 'Enter CIDR number for Subnet Mask (1-32): ' CIDR
                          if [[ "$CIDR" > 0 && "$CIDR" < 33 ]]; then
                              read -p "You chose $CIDR, Are you sure? (y = yes): " CHECK
                             if [[ "$CHECK" == "y" ]]; then
                                  break
                             fi
                          else
                              echo "CIDR number should be between 1 and 32"
                          fi
                    done      
                    
                    #echo "$CIDR"  > subnet.txt
                    #####################
                    echo "    cidr: $CIDR" >> interfaces.yaml
                    ####################
}

#LINKNAME = $(ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO\|/' | awk '{print $2}')
#echo "$LINKNAME">linkname.txt

rx='(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$'
rx_init='([1-2]?[0-5]|1[1-2]{2}|2'

  red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

GATEWAY=$(ip route | grep default | awk '{print $3}')
IP_STRING=$(cut -d "/" -f1 <<< $(ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO\|:' | awk '{print $2}'))
CIDR=$(cut -d "/" -f2 <<< $(ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO\|:' | awk '{print $2}'))
echo "Cervello Configurator"

# countInterfaces=$(ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO\|/' | awk '{print $2}' | sed -n '$=')
countInterfaces=$(nmcli device status | awk '/ethernet/{print $1}')
PS3="Which interface do u want to config?"
select interface in ${countInterfaces[@]}
do  
     echo "Selected number: $interface"
done
interfaceName=$(ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO\|/' | awk '{print $2}' | sed -n "${interfaceMenu}p")
########################
echo -e "\n  - name: $interfaceName" >> interfaces.yaml
#############################      
while true
do
     echo -e "${red}"
     echo "1. Config Parameters"
     echo "2. Display Parameters"
     read -p "Menu:  " MainMenu
     if [[ "$MainMenu" == "1" ]]
     then
          echo -e "${green}"
	  echo "1. Config IP"
          echo "2. Configure SNMP"
          echo "3. Configure IP Route"
          echo "4. Configure DNS"
          echo "5. Configure Default Gateway"
          read -p "Menu:  " ConfigMenu
          if [[ "$ConfigMenu" == "1" ]]
          then
               while true    
               do
                    # user input:
                    read -p 'Enter IP: ' IP_STRING
                    if [[ $IP_STRING =~ ^$rx ]]; then
                         echo "success"
                         read -p "$IP_STRING are you sure? (y =yes)"  CHECK
                         if [[ "$CHECK" == "y" ]]; then
                              break
                         fi
                    else
                         echo "Not a valid IP address"
                    fi
               done
               #echo "$IP_STRING" > ip.txt
               ####################
               echo "    ip: $IP_STRING" >> interfaces.yaml
               ######################
               AskForSubnetMask
               fi
               if [[ "$ConfigMenu" == "5" ]]
               then
                    while true    
                    do
                         # user input:
                              read -p 'Enter Default Gateway: ' DEFAULT_GATEWAY
                              if [[ $DEFAULT_GATEWAY =~ ^$rx ]]; then
                                   echo "success"
                                   read -p "$DEFAULT_GATEWAY are you sure? (y =yes)"  CHECK
                                   if [[ "$CHECK" == "y" ]]; then
                                        break
                                   fi
                              else
                                   echo "Not a valid IP address"
                              fi
                         done
                         #echo "$IP_STRING" > ip.txt
                         ####################
                         echo "    gateway: $DEFAULT_GATEWAY" >> interfaces.yaml
                         ######################
                    fi
                    
                    
                    
                    if [[ "$ConfigMenu" == "3" ]]
                    then
                         #echo "routes:" >> routes.yaml
                         AskForSubnetMask            
                         while true
                         do
                              read -p 'Enter deafault gateway: ' GATEWAY
                              if [[ $GATEWAY =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then 
                                   echo "success"
                                   read -p "You chose $GATEWAY, Are you sure? (y = yes): " CHECK
                                   if [[ "$CHECK" == "y" ]]; then
                                        break
                                   fi
                              else
                                   echo "Not a valid IP address"
                              fi
                         done
                         #echo "$GATEWAY" > gateway4
                         echo "    gateway: $GATEWAY" >> interfaces.yaml
                         echo "  - gw: $GATEWAY" >> routes.yaml
                         while true
                         do
                              read -p 'Enter network address: ' NET_STR
                              if [[ $NET_STR =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then 
                                   echo "success"
                                   read -p "You chose $NET_STR, Are you sure? (y =yes)"  CHECK
                                   if [[ "$CHECK" == "y" ]]; then
                                        break
                                   fi
                              else
                                   echo "Not a valid IP address"
                              fi
                         done
                         #echo "$to" > to.txt
                         echo "    net: $NET_STR" >> routes.yml
                    fi
                    if [[ "$ConfigMenu" == "4" ]]
                    then
                         while true
                         do
                              read -p 'Enter DNS addresses (for multiple addresses, separate with comma - 8.8.8.8,1.1.1.1):' DNS_STR
                              if [[ $DNS_STR =~ ^(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?),)*((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; then
                                   read -p "You chose $DNS_STR, Are you sure? (y =yes)"  CHECK
                                   if [[ "$CHECK" == "y" ]]; then
                                        break
                                   fi
                              else
                                   echo "Not a valid IP address, for multiple addresses, separate with comma."
                              fi
                         done
                         #echo "dns=$DNS_STR" >> dns.txt
                         echo "    nameserver: $DNS_STR" >> interfaces.yaml
                    fi
                    

                    if [[ "$ConfigMenu" == "2" ]]
                    then
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
                    echo -e "${cyan}"
                    if [[ "$MainMenu" == "2" ]]
                    then
                         echo "1. Display IP"
                         echo "2. Display SNMP"
                         echo "3. Display IP Route"
                         
                         read -p "Menu: " DisplayMenu     
                         if [[ "$DisplayMenu" == "1" ]]
                         then
                              ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO' | awk '{print $2}'
                         fi
                         if [[ "$DisplayMenu" == "3" ]]
                              then 
                                   netstat -nr 
                              fi
                              if [[ "$DisplayMenu" == "2" ]]
                              then
                                   grep -v '^#' /etc/snmp/snmpd.conf | grep .
                                   grep -v '^#' /etc/snmp/snmp.conf | grep .
                              fi
                         fi 
                    fi
                    # echo "  - name: $interfaceName" > interfaces.yaml
                         # echo "    ip: $IP_STRING" > interfaces.yaml
                         # echo "    cidr: $CIDR" > interfaces.yaml
                         # echo "    gateway: $GATEWAY" > interfaces.yaml
                         # echo "    nameserver: $DNS_STR" > interfaces.yaml
          done
