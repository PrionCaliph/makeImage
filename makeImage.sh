#!/bin/bash
#makeImage.sh  - copy image from another device
#run chmod +x makeImage.sh before excecuting
#make image from source

C='\033[1;36m'
R='\033[1;31m'
Y='\033[1;33m'
NC='\033[0m'



PV=$(dpkg -s pv | grep Status)
OK='Status: install ok installed'

if [ "$PV" = "$OK" ]; then echo "${C}pv is already installed :)${NC}"
	else echo "${Y}Will install pv ...${NC}" && sudo apt install --install-recommends -qq -y pv && PV=$(dpkg -s pv | grep Status)
	 	if [ "$PV" = "$OK" ]; then echo "${C}pv installed successfully :)!${NC}"
			else echo "${R}Wasn't able to install pv :(${NC}"
		fi
fi

GZ=$(dpkg -s pigz | grep Status)
if [ "$GZ" = "$OK" ]; then echo "${C}pigz is already installed :)${NC}"
	else echo "${Y}Will install pigz ...${NC}" && sudo apt install --install-recommends -qq -y pigz && PV=$(dpkg -s pigz | grep Status)
	 	if [ "$GZ" = "$OK" ]; then echo "${C}pigz installed successfully :)!${NC}"
			else echo "${R}Wasn't able to install pigz :(${NC}"
		fi
fi

echo "${Y}Dependencies satisfied!${NC}"


echo -n "${Y}Enter source: ${NC}"
read SOURCE; INF=${SOURCE}

echo -n "${Y}Enter output location: ${NC}"
read LOCAT; OUTF=$LOCAT 

echo -n "${Y}Enter name (abc.img): ${NC}" 
read NAME; OUTF=${OUTF}${NAME}

echo "${C}check if and of"
echo "\t if = ${Y}$INF"
echo "${C}\t of = ${Y}$OUTF"


echo -n "${Y}Press enter to continue...${NC}"
read keyPress
	if [ -z $keyPress ]; then echo "${C}Will write $INF to $OUTF${NC}"
	fi

mkdir -p $LOCAT
echo "Started $NAME"
pv "$INF" | sudo dd of="$OUTF"


#echo "${Y}Making image without empty space...${NC}" 
#(pv "$INF" | sudo dd ) | pigz > $OUTF.gz 

#echo -n "${Y}Press enter to decompress image "
#read keyPress; if [ -z $keyPress ]; then echo "${Y}Decompressing image...${NC}"
#	(pv $OUTF.gz | pigz --decompress) > $OUTF
#	echo "${C}Image decompressed :)"
#	else echo "${C}Ard${NC}"
#fi
#
sudo chown $(echo ${SUDO_USER:-${USER}}):$(echo ${SUDO_USER:-${USER}}) $OUTF.gz
sudo chown $(echo ${SUDO_USER:-${USER}}):$(echo ${SUDO_USER:-${USER}}) $OUTF
ls -l $LOCAT |grep $NAME
