#! /usr/bin/env bash

#Why is it placing this one?
selectedIf="eth0"
###########################

# subnet validation
# ISSUE: set validation to follow binary CIDR conversion
# CHECK: UNCHECKED
validSubnet()
{
subNetSTR ="(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?),)*((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
if [[  $1 > 0 && $1 < 33  ]]; then
    echo "Valid Subnet Mask"
    return 0
else 
    if [[ $1 =~ ^$subNetSTR ]]; then
        echo "Valid Subnet Mask"
        return 0
        else
            echo "Invalid Subnet Mask/CIDR number should be between 1 and 32"
        return 1
        fi
    fi

}
###########################

# IP validation
# ISSUE: Not Kosher IP validation
# CHECK: UNCHECKED
validIP () 
{
rx='(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$'
if [[ $1 =~ ^$rx ]]; then
    echo "Valid IP"
    return 0
else
    echo "Invalid IP"
return 1
fi
}
############################

# Get user input for subnet mask / CIDR (1-32)
AskForSubnetMask ()
{
while true
    do
                # user input:
        read -p 'Enter Subnet/CIDR: ' Subnet_INPUT
        if validSubnet $Subnet_INPUT ; then
            read -p "$Subnet_INPUT are you sure? (y = yes)"  CHECK
                if [[ "$CHECK" == "y" ]]; then
                    break
                fi
                else
                    echo "No# Menu - Level X - Display t a valid Subnet Mask"
#! /usr/bin/env bash

#Why is it placing this one?
selectedIf="eth0"
###########################

# subnet validation
# ISSUE: set validation to follow binary CIDR conversion
# CHECK: UNCHECKED
validSubnet()
{
subNetSTR ="(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?),)*((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
if [[  $1 > 0 && $1 < 33  ]]; then
    echo "Valid Subnet Mask"
    return 0
else 
    if [[ $1 =~ ^$subNetSTR ]]; then
        echo "Valid Subnet Mask"
        return 0
        else
            echo "Invalid Subnet Mask/CIDR number should be between 1 and 32"
        return 1
        fi
    fi

}
###########################

# IP validation
# ISSUE: Not Kosher IP validation
# CHECK: UNCHECKED
validIP () 
{
rx='(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$'
if [[ $1 =~ ^$rx ]]; then
    echo "Valid IP"
    return 0
else
    echo "Invalid IP"
return 1
fi
}
############################

# Get user input for subnet mask / CIDR (1-32)
AskForSubnetMask ()
{
while true
    do
                # user input:
        read -p 'Enter Subnet/CIDR: ' Subnet_INPUT
        if validSubnet $Subnet_INPUT ; then
            read -p "$Subnet_INPUT are you sure? (y = yes)"  CHECK
                if [[ "$CHECK" == "y" ]]; then
                    break
                fi
                else
                    echo "Not a valid Subnet Mask"
        fi
    done
                    
                    #echo "$CIDR"  > subnet.txt
                    #####################
echo "    cidr: $Subnet_INPUT" >> interfaces.yaml
                    ####################
}
############################

# Configure Gateway
configureGateway ()
{
while true    
    do
        # user input:
        read -p 'Enter Gateway IP: ' DEFAULT_GATEWAY
        if validIP $DEFAULT_GATEWAY ; then
            read -p "$DEFAULT_GATEWAY are you sure? (y = yes)"  CHECK
                if [[ "$CHECK" == "y" ]]; then
                    break
                fi
            else
                echo "Not a valid IP address"
            fi
    done
echo "    gateway: $DEFAULT_GATEWAY" >> interfaces.yaml
}
############################

# Set route
configureNetwork()
{
     while true
     do
          read -p 'Enter network address: ' NET_STR
          if validIP $NET_STR ; then
               read -p "You chose $NET_STR, Are you sure? (y =yes)"  CHECK
               if [[ "$CHECK" == "y" ]]; then
                    break
               fi
          else
               echo "Not a valid IP address"
          fi
     done
     echo "    net: $NET_STR" >> routes.yml
}
############################

# This SNMP editor is worrysome
# editSNMP()
# {
    #  snmpconf
    #  echo -e "\n"
    #  read -p "enter Community name " COMU
    #  sed -i "s/public/$COMU/" /etc/snmp/snmp.conf
    #  service snmpd restart   
    #  echo -e "\n"
# 
    #  read -p "SNMP V3? (y = yes) " SNMPMenu
    #  if [[ "$SNMPMenu" == "y" ]]
    #  then
        #   apt-get -y install snmp snmpd libsnmp-dev
        #   net-snmp-config --create-snmpv3-user -ro
    #  fi  
# }
############################

# DNS configuration
configureDNS()
{
while true
    do  
        read -p 'Enter DNS addresses (for multiple addresses, separate with comma - 8.8.8.8,1.1.1.1):' DNS_STR
        if [[ $DNS_STR =~ ^((([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)),)*(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$ ]]; then
            read -p "You chose $DNS_STR, Are you sure? (y =yes)"  CHECK
            if [[ "$CHECK" == "y" ]]; then
                    break
            fi
        else
            echo "Not a valid IP address, for multiple addresses, separate with comma."
        fi
    done
          echo "    nameserver: $DNS_STR" >> interfaces.yaml
}

# Interface selection
selectInterface()
{
	local PS3="Which interface do u want to config? "
	countInterfaces=$(nmcli device status | awk '/ethernet/{print $1}')
	select interface in ${countInterfaces[@]}
	do  
        echo "Selected interface: $interface"
        selectedIf=$interface
    # return ${interface}   # insert global value insetead return
        break 
	done
}
############################


# ---
# Menu - Level 1 - Configuration
configMenu () {
  while true; do
    local PS3='############## \n Network Configuration: '
    options=("Network Configuration (IP, SNMP, Route, DNS, Gateway" "Configure SNMP" "Configure IP Route" "Configure DNS" "Configure Default Gateway" "Quit")
        select opt in "${options[@]}"
        do
            case $opt in
                "Config IP")
                    configureIP   
                    AskForSubnetMask
                    break
                    ;;
                "Configure SNMP")
                    editSNMP
                    break
                    ;;
                "Configure IP Route")
                    configureNetwork
                    configureGateway
                    echo "  - gw: $DEFAULT_GATEWAY" >> routes.yaml
                    break
                    ;;
                "Configure DNS")
                    configureDNS
                    break
                    ;;
                "Configure Default Gateway")
                    configureGateway
                    break
                    ;;
                "Quit")
                    break 2
                    ;;
                *) echo invalid option;;
            esac
        done
    done
}
############################

# Menu - Level 2 - Display 
displayMenu() 
{        
     echo "IP:"
     ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO' | awk '{print $2}'
     echo "########"
     while true; do
        echo "YES/NO - continue TEST"
        select opt in "Yes" "No"; do
            case $REPLY in
                1) break 1 ;;
                2) break 2;;
            esac
     done    
done
}
############################

# Need to sort out
#TODO
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
############################

# Menu - Level 0
PS3='Please enter your choice: '
options=("Config Parameters" "Display Parameters" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Config Parameters")
	      selectInterface
           #######################
           # TESTING: pulling selected interface to new temporary
           # variabl
           userSetInterface=$interface
           ######################
              configMenu
          ;;
          "Display Parameters")   
               displayMenu
           # TESTING: Testing the user set interface variable: 
           echo "TESTING set interface is $userSetInterface"
          ;;       
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done        fi
    done
                    
                    #echo "$CIDR"  > subnet.txt
                    #####################
echo "    cidr: $Subnet_INPUT" >> interfaces.yaml
                    ####################
}
############################

# Configure Gateway
configureGateway ()
{
while true    
    do
        # user input:
        read -p 'Enter Gateway IP: ' DEFAULT_GATEWAY
        if validIP $DEFAULT_GATEWAY ; then
            read -p "$DEFAULT_GATEWAY are you sure? (y = yes)"  CHECK
                if [[ "$CHECK" == "y" ]]; then
                    break
                fi
            else
                echo "Not a valid IP address"
            fi
    done
echo "    gateway: $DEFAULT_GATEWAY" >> interfaces.yaml
}
############################

# Set route
configureNetwork()
{
     while true
     do
          read -p 'Enter network address: ' NET_STR
          if validIP $NET_STR ; then
               read -p "You chose $NET_STR, Are you sure? (y =yes)"  CHECK
               if [[ "$CHECK" == "y" ]]; then
                    break
               fi
          else
               echo "Not a valid IP address"
          fi
     done
     echo "    net: $NET_STR" >> routes.yml
}
############################

# This SNMP editor is worrysome
# editSNMP()
# {
    #  snmpconf
    #  echo -e "\n"
    #  read -p "enter Community name " COMU
    #  sed -i "s/public/$COMU/" /etc/snmp/snmp.conf
    #  service snmpd restart   
    #  echo -e "\n"
# 
    #  read -p "SNMP V3? (y = yes) " SNMPMenu
    #  if [[ "$SNMPMenu" == "y" ]]
    #  then
        #   apt-get -y install snmp snmpd libsnmp-dev
        #   net-snmp-config --create-snmpv3-user -ro
    #  fi  
# }
############################

# DNS configuration
configureDNS()
{
while true
    do  
        read -p 'Enter DNS addresses (for multiple addresses, separate with comma - 8.8.8.8,1.1.1.1):' DNS_STR
        if [[ $DNS_STR =~ ^((([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)),)*(([1-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-4])\.)(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2})((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$ ]]; then
            read -p "You chose $DNS_STR, Are you sure? (y =yes)"  CHECK
            if [[ "$CHECK" == "y" ]]; then
                    break
            fi
        else
            echo "Not a valid IP address, for multiple addresses, separate with comma."
        fi
    done
          echo "    nameserver: $DNS_STR" >> interfaces.yaml
}

# Interface selection
selectInterface()
{
	local PS3="Which interface do u want to config? "
	countInterfaces=$(nmcli device status | awk '/ethernet/{print $1}')
	select interface in ${countInterfaces[@]}
	do  
        echo "Selected interface: $interface"
        selectedIf=$interface
    # return ${interface}   # insert global value insetead return
        break 
	done
}
############################


# ---
# Menu - Level 1 - Configuration
configMenu () {
configureIP
#   editSNMP - need to fix
configureDNS
configureGateway
while true; do
    echo "YES/NO - continue TEST"
    select opt in "Yes" "No"; do
        case $REPLY in
            1) break 1 ;;
            2) break ;;
        esac
    done    
done
}
############################

# Menu - Level 2 - Display 
displayMenu() 
{        
echo "IP:"
ip addr show | grep -v 'forever\|valid\|link\|::\|lo:\|host\|NO' | awk '{print $2}'
echo "########"
while true; do
    echo "YES/NO - continue TEST"
    select opt in "Yes" "No"; do
        case $REPLY in
            1) break 1 ;;
            2) break 2;;
        esac
    done    
done
}
############################

# Need to sort out
#TODO
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
############################

# Menu - Level 0
PS3='Please enter your choice: '
options=("Config Parameters" "Display Parameters" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Config Parameters")
	      selectInterface
           #######################
           # TESTING: pulling selected interface to new temporary
           # variabl
           userSetInterface=$interface
           ######################
              configMenu
          ;;
          "Display Parameters")   
               displayMenu
           # TESTING: Testing the user set interface variable: 
           echo "TESTING set interface is $userSetInterface"
          ;;       
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
 done
