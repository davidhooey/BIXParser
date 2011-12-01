# encoding: utf-8

SCRIPT_PATH = File.dirname(__FILE__)
$:.unshift(File.join(SCRIPT_PATH, '../lib'))

DATA_PATH = SCRIPT_PATH + '/data/'

require 'bixparser'

include BIXParser

class PrintHymns
    
    attr_accessor :string_data
    
    def initialize(file)
        @string_data = String.new
        data_file = File.new(DATA_PATH + file, 'r:UTF-8')
        data_file.each_line do |line|
             @string_data << line
        end
    end
    
    def hymn_parser
        hymn_parser = BIXParser::ParseHymns.new
        hymn_parser.parse_hymn(@string_data)
        print_hymns(hymn_parser.hymns_array, "parse_hymns.txt")
    end
    
    def bookix_parser
        bookix_parser = BIXParser::ParseBookix.new
        bookix_parser.parse_bookix(@string_data)
        print_hymns(bookix_parser.hymns_array, "parse_bookix.txt")
    end
    
    def print_hymns(hymns_array, outfile)
        outfile = File.new(outfile, 'w')
        hymns_array.each do |hymn|
            outfile.write("#{hymn.number}. #{hymn.title}\n\n")
            outfile.write("#{hymn.data}\n\n")
            outfile.write("#{hymn.wordlist}\n\n")
            outfile.write("#{'-'*40}\n\n")
        end
        outfile.close        
    end
    
end

ph = PrintHymns.new("HymnsEN.dat")
ph.hymn_parser

ph = PrintHymns.new("Hymns.English.Hymns Old and New 1987.bookix")
ph.bookix_parser
