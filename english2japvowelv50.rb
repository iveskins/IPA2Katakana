#!/usr/bin/env ruby
require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'syllabify'
require 'erb'
require 'yaml'
infile = File.open(ARGV[0])
data = YAML.load_file infile



lines = data["Text"] #array
lines.each do |line|
  string = line["orig"]["ipa"]
  transcr_output = %x(speak-ng -q --ipa=3 --sep=͡  "#{string}").strip.split(" ")
  # puts transcr_output
  line["orig"]["ipa"] = transcr_output
  line["orig"]["jipa"] = transcr_output
  line["orig"]["ipasyl"] = transcr_output
end
lines.each do |line|
  string = line["orig"]["en-uk"]
  split_output = string.strip.split(/\s|\.(?=\S)/) # match white-space and .'s not followed by white-space  eg "St.John" -> "st", "John" because espeak does this too
  # puts split_output
  line["orig"]["en-uk"] = split_output
end
lines.each do |line| # one line from file
  string = line["orig"]["ipasyl"] #array of words
  syllablwords = []
  string.each do |word|  #for evey word in the line
    trans = CodyRobbins::Syllabify.new(:en, word)  #make syllables objects for that word
    syllablwords << trans
  end
  line["orig"]["ipasyl"] = syllablwords
  line["orig"]["ipasylflat"] = []
end
# make plain array from CodyRobbins::Syllabify objects .. I could use some BaskinRobbins::ice-cream.now
lines.each do |line| # one line from file
    words = line["orig"]["ipasyl"] #array of syllable arrays
     lineassylls = []
     words.each do |word|  #for evey word in the line
      wordsassylls = []
          word.syllables.each do |syll|
            stressmark = '●'
            if syll.stress.nil?; stresclass = 'un'; elsif syll.stress == "ˈ"; stresclass = 'primary'; elsif syll.stress == "ˌ"; stresclass = 'second'; end
            wordsassylls << {:onset => syll.onset, :nucleus => syll.nucleus, :coda => syll.coda, :stress => stresclass}
          end
          lineassylls << wordsassylls
     end
     line["orig"]["ipasylflat"] << lineassylls
end
#replace the vowels with katakana

re = /(a͡ʊ)|(a͡ɪ)|(e͡ɪ)|(e͡ə)|(i͡ə)|(ʊ͡ə)|(o͡ʊ)|(ɔ͡ɪ)|(ɛ͡ə)|(ʌ͡ɹ)|(ə͡ɹ)|(ə͡ʊ)|(a͡U)|(a͡I)|(ə͡l)|(ɑː)|(iː)|(ɔː)|(uː)|(ɜː)|(əː)|(ɑ)|(ɒ)|(ɐ)|(æ)|(ʌ)|(ə)|(ɔ)|(ɛ)|(ɝ)|(ɚ)|(ɪ)|(i)|(ʊ)|(u)|(U)|(ø)|(y)|(a)|(e)|(i)|(o)|(j)/
# this is a list of approximations in katakana of the english vowel sounds.. The idea is that a Japanese person could look at these and with no training get an approximation of the right sound .. and with a little more training get a getter sound .. and it not take lots of time to lear all the IPA symbols
nuclei = {
"a͡ʊ"      => 'ア~ォゥ',
"a͡ɪ"      => 'ア~ェ',
"e͡ɪ"      => 'エ~ィ',
"e͡ə"      => 'エ~ァ',
"i͡ə"      => 'イエァ',
"ʊ͡ə"      => 'ウ~ァ',
"o͡ʊ"      => 'オ~ゥ',
"ɔ͡ɪ"      => 'オ~ェ',
"ɛ͡ə"      => 'エ~ァ',
"ʌ͡ɹ"      => 'アr',
"ə͡ɹ"      => 'ァr',
"ə͡ʊ"      => 'アオゥ',
"a͡U"      => 'アオゥ',
"a͡I"      => 'ア~ェ',
"ə͡l"      => 'ァッｌ',
"ɑː"       => 'アァ',
"iː"       => 'イィ',
"ɔː"       => 'アォ',
"uː"       => 'ウゥ',
"ɜː"       => 'アァ',
"əː"       => 'アァ',
"ɑ"        => 'ア',
"ɒ"        => 'アォ',
"ɐ"        => 'アッ',
"æ"        => 'アェ',
"ʌ"        => 'アォ',
"ə"        => 'アッ',
"ɔ"        => 'オァ',
"ɛ"        => 'エ',
"ɝ"        => 'アｒ',
"ɚ"        => 'アｒ',
"ɪ"        => 'イェ',
"i"        => 'イッ',
"ʊ"        => 'ウ',
"u"        => 'ウッ',
"U"        => 'ウ',
"ø"        => 'エ',
"y"        => 'ッィ',
"a"        => 'アァ',
"e"        => 'エ',
"i"        => 'イ',
"o"        => '？',
"j"        => 'y'
}
#replace the vowels with special sauce katakana
lines.each do |line| # one line from file
  wordsassylls = line["orig"]["ipasylflat"] #array of words and sub array of syllables
  wordsassylls.map {|words| words.map{|syllables| syllables.map{|syllable| syllable[:nucleus] = syllable[:nucleus].gsub(re, nuclei)}}}
end

#replace the other hard to read IPA characters that are in the coda or onset of syllables
reconsonant = /(ɹ)|(j)/
consonant  = {
  "ɹ"        => 'r',
  "j"        => 'y'
}
lines.each do |line| # one line from file
  wordsassylls = line["orig"]["ipasylflat"] #array of words and sub array of syllables
  wordsassylls.map {|words| words.map{|syllables| syllables.map{|syllable| unless syllable[:onset].nil?; unless syllable[:onset].empty?; syllable[:onset] = syllable[:onset].gsub(reconsonant, consonant) ;end ; end }}} # replace the ipa j with an easy to read y ect in the onset(part of the syllable before the nucleus)
end
lines.each do |line| # one line from file
  wordsassylls = line["orig"]["ipasylflat"] #array of words and sub array of syllables
  wordsassylls.map {|words| words.map{|syllables| syllables.map{|syllable| unless syllable[:coda].nil?; unless syllable[:coda].empty?; syllable[:coda] = syllable[:coda].gsub(reconsonant, consonant) ;end ; end }}} # replace the ipa j with an easy to read y ect in the coda(part of the syllable after the nucleus)
end

body_section = lines

body_section_build = ERB.new(File.read("outtemp.html.erb"))
body_section = body_section_build.result(binding)


template = ERB.new(File.read("template.html.erb"))
html_content = template.result(binding)
outfile = File.open(ARGV[1], "w") do |file|
  file.puts html_content
end



__END__
