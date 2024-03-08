#! /bin/bash
#
# francisation linux
#
echo -e "\n==== Francisation paquets linux ====\n" 

## remplacement des archives -> fr 
## ne semble pas nécessaire finalement et évite de devoir mettre à jour toute la distrib pour être cohérent


## echo 'deb http://fr.archive.ubuntu.com/ubuntu/ trusty main restricted universe
## deb http://security.ubuntu.com/ubuntu/ trusty-security main restricted universe
## deb http://fr.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe' >  /etc/apt/sources.list

## apt-get update
## apt-get install firefox # Risque d'avoir un paquet lanque d'une version supérieure si on le fait pas

# extrait list des paquet "en"
langPkgList=$(dpkg-query -W --showformat='${Package} ${Status} \n' | sed -re '/-en( |-).* .* installed/!d' | cut -d' ' -f1)

# installation paquets "fr" et supression paquet "en" correspondant

for langPack2 in $langPkgList; do
  echo -en "\n--> remplacement packet langue $langPack2 par "
  langPack3=$(echo $langPack2 | sed -re 's/-en(-|$)|-en-us(-|$)/-fr\1/g') 
  echo -e "$langPack3 \n"
  apt-get -y install $langPack3 
  
  if [ $? = 0 ]; then
      echo -e "\n--> installation $langPack3 Ok\n"
      apt-get -y remove $langPack2;
  else 
    echo -e "\n--> Echec installation $langPack3\n"
  fi;
done;

# paquet français pour thunderbird seulement si thunderbird est déjà installé
apt-get --assume-no install thunderbird-locale-fr

# fuseau horaire
echo 'Europe/Paris' > /etc/timezone