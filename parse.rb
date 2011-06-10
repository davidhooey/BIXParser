APP_ROOT = File.dirname(__FILE__)

$:.unshift(File.join(APP_ROOT, 'lib'))

require 'bix_parser'

include BIXParser
include LibXML

#hymn_parser = BIXParser::ParseHymns.new
#hymn_parser.parse_hymn(File.new('HymnsRU.dat', 'r').read)
#hymn_parser.hymns_array.each do |i|
#    puts "#{i.number}. #{i.title}"
#    #puts i.data
#    #puts i.wordlist
#end

bookix_parser = XML::SaxParser.file("Hymns.English.Hymns Old and New 1987.bookix")
bookix_parser.callbacks = BIXParser::ParseBookix.new
bookix_parser.parse
bookix_parser.hymns_data.each do |i|
    puts "#{i.number}. #{i.title}"
    #puts i.data
    #puts i.wordlist
end

