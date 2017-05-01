#!/usr/bin/env ruby
infile = File.open(ARGV[0])
str = infile.read
re = /(.+\n)(.+\n)/
subst = "  -\n    'orig':\n            'jipa': \\1            'ipa': \\1            'en-uk': \\1    'translation': \\2"
result = "'Text':\n" + str.gsub(re, subst)
outfile = File.open(ARGV[1], "w") do |file|
  file.puts result
end
