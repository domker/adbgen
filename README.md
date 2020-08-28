# adbgen

#### Generator listy ad-block w formacie pliku hosts
Umożliwia pobranie predefiniowanych list blokowania reklam i ich konsolidację.
Można również wygenerować plik hosts w archiwum ZIP dla flashowania przy pomocy TWRP. (tylko smartfony Xiaomi z MIUI Polska/MIUI.eu, nie używać w przypadku MIUI Global)



1. Android (przy użyciu [Termux](https://play.google.com/store/apps/details?id=com.termux))

    * Instalacja i konfiguracja Termux
      
      Pobierz ze sklepu Google Play: https://play.google.com/store/apps/details?id=com.termux
      
      Po zainstalowaniu wpisz w Termux: `pkg upgrade` i potwierdź klawiszem <kbd>&#9166;</kbd>, potem <kbd>Y</kbd> i znowu <kbd>&#9166;</kbd>
    * Dodanie [aliasu](https://pl.wikipedia.org/wiki/Alias_(Unix)) (aby łatwiej nawigować do katalogu `Download`)
      
      Skopiuj do Termux polecenia (wklejasz przytrzymując obojętnie gdzie w okienku terminala):
      ```sh
      cd ../usr/etc/
      echo "alias godl='cd /storage/emulated/0/Download'" >> bash.bashrc
      exit
      ```
      (ścieżka do katalogu `Download` może się w niektórych smartfonach Xiaomi różnić - jeżeli jest inna to zmodyfikuj ją odpowiednio w poleceniu)
      
      Następnie uruchom ponownie Termux i sprawdź wpisując `godl` <kbd>&#9166;</kbd>, a następnie `basename $(pwd)` <kbd>&#9166;</kbd>, czy jesteś w katalogu `Download`.
      
    * Instalacja zależności dla skryptu `adbgen.sh`
    
      Skopiuj do Termux polecenie:
      ```sh
      pkg install zip 
      ```
    * Pobieranie i rozpakowywanie skryptu `adbgen.sh` z repozytorium GitHub
    
      Polecenie:
      ```sh
      godl && curl -# -L -o adbgen.zip "https://github.com/domker/adbgen/archive/master.zip" && unzip adbgen.zip && cd adbgen-master && chmod +x adbgen.sh
      ```
    * Używanie skryptu
    
      `./adbgen.sh [OPCJA]`
      
      > **d** - tylko pobierz listy do katalogu cache\
      > **g** - wygeneruj plik hosts\
      > **c** - sprawdź, czy listy blokowania są aktualne\
      > **zv1** - przygotuj plik "zip" z hosts dla TWRP (dla starszych smartfonów Xiaomi)\
      > **zv2** - przygotuj plik "zip" z hosts dla TWRP - dla nowszych smartfonów Xiaomi: m. in. Mi 10, Mi 9, Mi 9 SE, Mi 9T/Redmi K20, Mi 9T Pro/Redmi K20 Pro, Redmi Note 7, Redmi Note 7 Pro, Redmi 7A, Redmi 7, Redmi Y3, Mi A2, Mi A2 Lite, Mi A3, Mi A1, Mi CC9, Mi CC9e, Mi CC9 Meitu, Redmi 6 (Android Pie), Redmi 6A (Android Pie)

2. Linux

    * Instalowanie zależności skryptu
    
      Debian (Mint, Ubuntu itp.)
      
      `sudo apt install curl zip unzip`
      
      Arch Linux (Manjaro itp.)
      
      `sudo pacman -S curl zip unzip`
      
      OpenSuse
      
      `sudo zypper install curl zip unzip`
      
      Fedora
      
      `sudo dnf install curl zip unzip`
      
    * Pobieranie i rozpakowywanie skryptu `adbgen.sh` z repozytorium GitHub
      
      `curl -# -L -o adbgen.zip "https://github.com/domker/adbgen/archive/master.zip" && unzip adbgen.zip && cd adbgen-master && chmod +x adbgen.sh`
    
    * Używanie skryptu - tak jak w przypadku Androida powyżej

3. Windows

    Brak wersji skryptu pod Windows - można użyć przy pomocy WSL2 w Windows 10.
    
    
 ### UWAGI!
 
 - Generowane pliki zip dla TWRP są niepodpisane i przy ich flashowaniu trzeba odznaczyć pole weryfikacji sygnatury zip.
 - Skrypt można dowolnie pobierać i modyfikować. Używasz skryptu na własną odpowiedzialność.
 - W katalogu `stock_hosts` znajdują się oryginalne pliki hosts dla starszych i nowszych smartfonów Xiaomi
 - Jeżeli chcesz korzystać z opcji sprawdzania, czy na serwerach są nowe listy blokowania to nie usuwaj katalogu `cache` tworzonego przez skrypt
 - Możesz wykluczać listy blokowania (oprócz pierwszych trzech) w pliku `urllist.txt` wstawiając zamiast adresu URL słowo `blank`
