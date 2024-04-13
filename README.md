# ppgen
Passphrase generator using text word file database

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
    -f, --data FILES                 Array of extra word files in addition to ["/home/mccauley/steeve/steeve/ppgen-master/data/words.txt"]
    -v, --verbose                    Verbose output
    -D, --debug                      Turn on debugging output
    -h, --help                       Help
This is help text

Sample words.txt taken from https://github.com/dwyl/english-words.git

$ ./ppgen.rb --pplen 4 --wordlen 6 --num 25 --debug
INFO 2024-04-13 11:24:43 -0400: Loading corpus from /home/mccauley/steeve/steeve/ppgen-master/data/words.txt
INFO 2024-04-13 11:24:43 -0400: Loaded 354983 unique words
seed=79171473528676992265993447293981554969
pepsi kerns seimas rayed
fremt worts fugio jger
camper fiddle bornan tarots
augury babel palate gowan
jiffs gutti poles sarpo
uhuru imbues kimbo lehay
wrive rotch malars righty
capite paua ataunt dbrn
lipped readd ohv none
dat soke tweeds mishap
kat warded roused funori
finity randie tacso rough
wjc gentry unseen seqrch
appast dromon pursy grush
forked lye donkey awedly
gozell scivvy tabet kalpas
atli guiac dioxid shelly
netman yirred dougl renish
thing sixes no night
alchem regrip tuba pulka
octine soss dynast crops
finary balian cotter koi
vulgus serum achree suety
bimong shap nigre ghast
ons calvin felons cark
```
