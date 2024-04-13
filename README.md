# ppgen
Passphrase generator using text word file database

Sample words.txt taken from https://github.com/dwyl/english-words.git

```
$ ./ppgen.rb -h

ppgen.rb [options]
    -p, --pplen WORDS                Number of words in passphrase, def=4
    -l, --wordlen CHARS              Maximum length of words for passphrase, def=6
    -n, --num NUM                    Number of passphrases to generate, def=20
    -s, --seed SEED                  Random number generator seed
    -w, --words WORDS                List of word(s) to include in passphrase
    -c, --random-caps
    -C, --random-case PERCENT        Percentage of case switches to include in passphrase, def=0%
    -S, --special-char PERCENT       Percentage of special characters to include in passphrase, def=0%
    -T, --space-special NUM          Replace spaces with special characters
    -U, --specials STRING            List of special characters, def [!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]
    -N, --numbers PERCENT            Percentage of digits to include in passphrase, def=0%
    -O, --space-numbers NUM          Replace up to num spaces with numbers
    -f, --data FILES                 Array of extra word files in addition to ["ppgen-master/data/words.txt"]
    -v, --verbose                    Verbose output
    -D, --debug                      Turn on debugging output
    -h, --help                       Help
This is help text

$ ./ppgen.rb --pplen 4 --wordlen 8 --num 25 --debug --random-caps
INFO 2024-04-13 13:15:23 -0400: Loading corpus from ppgen-master/data/words.txt
INFO 2024-04-13 13:15:23 -0400: Loaded 354983 unique words
seed=133177273618255052214803008488114992619
SPHENE sithens ACHKAN ELOINE
newfish padella fundi UNHOODED
UPBRIM apoplexy REVENGE BURIAN
BOODLERS biffed binh ARRAYER
SULLIAGE ZOOGLEA AMEBEAN SUBWAY'S
bandura KYMOGRAM LETE RAMMED
oologist lactase nacre AGATE
EPHOI diobolon PANOCHAS BALKIER
DIABASE elaenia BLAZONER inset
WOODHUNG upfurl mouzah outbrags
arsenism subindex parrots FRIZED
FUNNING WAXIEST IDIC eelier
ZYDECO GAUZILY guinde TAPIST
joey burelly floormen SLEEKEST
foredone igdrasil INDRENCH tlo
advising ENVIER obtusion STEERMAN
kivas limpet WAXWINGS freshman
AFFLATE MALACTIC gasteria IODATES
HAREMLIK BAREHEAD hemera RHIZOGEN
blear BURFISH TILLAGE MUFFIN'S
motivic PILAUS dragoon DISCED
ondy ABROACH view ballote
BOSHES ISLANDRY splet menarche
METWAND MODENA vitiates ESPIGLE
LOOKOUTS NONAGON BERRIER STADIUM


```
