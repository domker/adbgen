#!/bin/bash

# Generator skonsolidowanego pliku blokady reklam HOSTS
# z możliwością generowania archiwum ZIP (tylko smartfony Xiaomi z MIUI Polska/MIUI.eu) dla TWRP.
# Używasz na własną odpowiedzialność! - oryginalne pliki hosts dostępne w katalogu 'stock_hosts'.
# Github: https://github.com/domker/adbgen

# Jeżeli chcesz pominąć jakąś listę blokowania, aby nie znalazła się w pliku hosts to jej adres URL zastąp w pliku "urllist.txt" wyrazem "blank" (z wyjątkiem pierwszych 3 adresów URL)

clear
echo "#### adbgen.sh by Domker_ ####"

if [ ! -d cache ]; then mkdir cache; fi
cd cache


##### FUNKCJE #####

dl_lists() {
#pobieranie list blokowania do cache i generowanie sum kontrolnych
i=1

if [ -f localchcksums.sha1 ]; then rm -v localchcksums.sha1; fi
if [ ! -f ../urllist.txt ]; then echo "Brakuje pliku urllist.txt z adresami list blokowania!" && exit 1; fi

echo "Pobieranie list blokowania i generowanie sum kontrolnych:"

while read url; do
    echo "== $url =="
    curl -sL -o $i.txt "$url" && echo "Pobrano!" || echo "Nie pobrano!"
    sha1sum $i.txt | awk '{print $1}' >> localchcksums.sha1
    i=$((i+1))
done < ../urllist.txt

}

clean_lists() {
#czyszczenie list ze zbędnych elementów i konsolidacja

echo "== Zmiana formatu na hosts dla list Disconnect =="
sed -i -e '1,4d; s/^/0.0.0.0 /' 1.txt 2.txt 3.txt && echo "OK!"


echo "== Usuwanie nagłówków hosts =="
sed -i '1,83d' 4.txt
sed -i '1,27d' 5.txt
sed -i '1,6d' 6.txt
sed -i '1,24d' 7.txt
sed -i '1,34d' 9.txt
sed -i '1,39d' 10.txt
sed -i '1,39d' 11.txt && echo "OK!"


echo "== Łączenie wszystkich list =="
cat *.txt > hosts_joined.dirty && echo "OK!"
rm -v *.txt

echo "== Usuwanie wszystkich komentarzy z listy =="
sed -i 's/#.*$//;/^$/d' hosts_joined.dirty && echo "OK!"

echo "== Zamiana 127.0.0.1 na 0.0.0.0 (zero-host) - optymalizacja =="
sed -i 's/^127.0.0.1/0.0.0.0/g' hosts_joined.dirty && echo "OK!"

echo "== Usuwanie zduplikowanych wpisów =="
awk '!a[$0]++' hosts_joined.dirty > hosts_joined.txt && echo "OK!"
rm -v hosts_joined.dirty

}

gen_hosts() {
#generowanie finalnego pliku hosts
local tmpheader=`mktemp` || exit 1
local header_urls=`while read url; do echo "# $url"; done < ../urllist.txt`

cat > $tmpheader <<EOF
Wygenerowano przy pomocy adbgen.sh (made by Domker_) dnia: `date '+%d-%m-%Y %H:%M:%S'`
$header_urls

127.0.0.1 localhost
::1 localhost

EOF

echo "== Połączenie nagłówka i listy blokowania w finalny plik hosts =="
cat $tmpheader hosts_joined.txt > ../hosts && echo "OK!"
rm -v $tmpheader hosts_joined.txt

echo "Plik hosts został wygenerowany w lokalizacji '$(dirname $PWD)'!"

}

chck_lists() {
#sprawdzanie, czy pliki na serwerach się zmieniły
i=1

if [ ! -f localchcksums.sha1 ]; then echo "Nie można sprawdzić aktualności plików - brak pliku localchcksums.sha1" && exit 1; fi

echo "Sprawdzanie, czy nowe listy pojawiły się na serwerach - czekaj:"

while read url; do
    if [  "$url" != "blank" ]; then
        echo "..."
        curl -sL "$url" | sha1sum - | awk '{print $1}' >> remotechcksums.sha1
    fi
    i=$((i+1))
done < ../urllist.txt

cmp -s localchcksums.sha1 remotechcksums.sha1 && echo "Pliki na serwerach są takie same!" || echo "Wykryto zmiany na serwerze/-ach, można wygenerować nowy plik hosts!"
rm remotechcksums.sha1

}


twrp_zip() {
#tworzenie pliku zip do flashowania hosts w TWRP
if [ ! -f ../hosts ]; then echo "Najpierw wygeneruj plik hosts! ( sh adbgen.sh g LUB ./adbgen.sh g )" && exit 1; fi
if [ ! -f ../template_$1.zip ]; then echo "W katalogu ze skryptem brakuje pliku szablonu template_$1.zip!" && exit 1; fi

echo "== Tworzenie pliku zip (wersja $1) z hosts dla TWRP =="
cp ../template_$1.zip tmp.zip
mkdir -p system/etc
cp ../hosts system/etc/hosts
zip -urv tmp.zip system/etc/hosts
mv -v tmp.zip ../Blokada_reklam_$1_`date '+%Y-%m-%d'`_unsigned.zip && echo "Utworzono plik w lokalizacji '$(dirname $PWD)'! Pamiętaj o wyłączeniu weryfikacji podpisów w TWRP." && rm -R system/

}

##### KONIEC FUNKJE #####

##### MAIN #####

opt=$1
case $opt in
    d)
        dl_lists
        ;;
    g)
        dl_lists; clean_lists; gen_hosts
        ;;
    c)
        chck_lists
        ;;
    zv1)
        twrp_zip v1
        ;;
    zv2)
        twrp_zip v2
        ;;
    zr)
        rm -v ../Blokada_reklam_v*unsigned.zip 2>/dev/null && echo "Usunięto wszystkie pliki zip blokady reklam!" || echo "Brak plików zip blokady reklam do usunięcia!"
        ;;
    *)
        cat <<EOF
        
Użycie: sh adbgen.sh [ OPCJA ]
    lub ./adbgen.sh [ OPCJA ]

d - tylko pobierz listy do katalogu cache
g - wygeneruj plik hosts
c - sprawdź, czy listy blokowania są aktualne
zv1 - przygotuj plik "zip" z hosts dla TWRP (dla starszych smartfonów Xiaomi)
zv2 - przygotuj plik "zip" z hosts dla TWRP (dla nowszych smartfonów Xiaomi: m. in. Mi 10, Mi 9, Mi 9 SE, Mi 9T/Redmi K20, Mi 9T Pro/Redmi K20 Pro, Redmi Note 7, Redmi Note 7 Pro, Redmi 7A, Redmi 7, Redmi Y3, Mi A2, Mi A2 Lite, Mi A3, Mi A1, Mi CC9, Mi CC9e, Mi CC9 Meitu, Redmi 6 (Android Pie), Redmi 6A (Android Pie))
zr - usuń wszystkie utworzone wcześniej pliki zip blokady reklam

EOF
        exit 1
        ;;
esac
