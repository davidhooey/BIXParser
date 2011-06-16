# encoding: utf-8

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
#    puts i.wordlist
#end



#io = File.open("Hymns.English.Hymns Old and New 1987.bookix",'r:UTF-8')
#io = File.open("./test/Hymns.Cantiques 1998.bookix",'r:UTF-8')
#bookix_parser = XML::SaxParser.io(io, :encoding => XML::Encoding::UTF_8)

data = File.new('Hymns.English.Hymns Old and New 1987.bookix', 'r:UTF-8').read.gsub('&nbsp;',' ').force_encoding('UTF-8')
parse_bookix = XML::SaxParser.string(data)

parse_bookix = BIXParser::ParseBookix.new
bookix_parser.callbacks = parse_bookix
bookix_parser.parse
parse_bookix.hymns_array.each do |i|
    puts "#{i.number}. #{i.title}"
    #puts i.data
    puts i.wordlist
end

