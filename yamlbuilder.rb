#!/usr/bin/env ruby
require 'yaml'
infile = File.open(ARGV[0])
str = infile.read
array = str.split("\n").each_slice(2).to_a
lines = array.map{ |p| [{"orig"=> {"jipa"=>p[0], "ipa"=>p[0], "en-uk"=>p[0]}, "translation"=>p[1]}]}

result = {"Text"=>  lines}
yaml = result.to_yaml(options = {:line_width => -1})

# re = /(.+\n)(.+\n)/
# re = /(.+?\\n)(.+?\\n)/
# subst = "  -\n    'orig':\n            'jipa': \\1            'ipa': \\1            'en-uk': \\1    'translation': \\2"
# result = "'Text':\n" + yaml.gsub(re, subst)
outfile = File.open(ARGV[1], "w") do |file|
  file.puts yaml
end
