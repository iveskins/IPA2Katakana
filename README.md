# IPA2Katakana
a ruby script that takes a yaml file with lines of english text, and a japanese translation, and outputs a static webpage containing the english text annotated with IPA transcription, and a modified IPA that replaces english vowels with special vowel approximations in Katakana script. it also adds annotation on word syllable stress. It relies on expeak to generate IPA and stress. It relies on the CodyRobbins::Syllabify gem with a modified definitions file also.
![example](Selection_060.png?raw=true "For Example")


 How to use.
Install espeak-ng (or espeak and change the "transcr_output = %x(speak-ng.." bit)
install the ruby GEM CodyRobbins::Syllabify
replace the en.yml file of that Gems config e.g (/var/lib/gems/2.3.0/gems/syllabify-1.0.1/languages/en.yml)
with the modified version in this repo

make a text file with 
one line english
一つ日本　(and one japanes )

e.g sop.txt
then run the ruby yamlbuilder.rb (yourfile.txt)
to get a yaml template
ruby english2japvowelv50.rb (your.yaml) (output.html)
