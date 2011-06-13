# encoding: utf-8

SCRIPT_PATH = File.dirname(__FILE__)
$:.unshift(File.join(SCRIPT_PATH, '../lib'))

require 'bix_parser'

include BIXParser
include LibXML

#hymn_parser = BIXParser::ParseHymns.new
#hymn_parser.parse_hymn(File.new('HymnsRU.dat', 'r').read)
#hymn_parser.hymns_array.each do |i|
#    puts "#{i.number}. #{i.title}"
#    #puts i.data
#    puts i.wordlist
#end


io = File.open("Hymns.English.Hymns Old and New 1987.bookix",'r:UTF-8')
bookix_parser = XML::SaxParser.io(io, :encoding => XML::Encoding::UTF_8)
parse_bookix = BIXParser::ParseBookix.new
bookix_parser.callbacks = parse_bookix
bookix_parser.parse
parse_bookix.hymns_array.each do |i|
    puts "#{i.number}. #{i.title}"
    #puts i.data
    puts i.wordlist
end
