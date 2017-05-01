# IPA2Katakana
a ruby script that takes a yaml file with lines of english text, and a japanese translation, and outputs a static webpage containing the english text annotated with IPA transcription, and a modified IPA that replaces english vowels with special vowel approximations in Katakana script. it also adds annotation on word syllable stress. It relies on expeak to generate IPA and stress. It relies on the CodyRobbins::Syllabify gem with a modified definitions file also.