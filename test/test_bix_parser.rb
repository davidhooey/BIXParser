# encoding: utf-8

SCRIPT_PATH = File.dirname(__FILE__)
$:.unshift(File.join(SCRIPT_PATH, '../lib'))

DATA_PATH = SCRIPT_PATH + '/../data/'

require 'test/unit'
require 'bix_parser'

include BIXParser
include LibXML

class TestBookixParser < Test::Unit::TestCase
    
    # English
    EN_RANGE = 412
    attr_accessor :hymn_array_en_hymns
    attr_accessor :hymn_array_en_bookix
    attr_accessor :hymn_array_en_bookindex

    # French
    FR_RANGE = 301
    attr_accessor :hymn_array_fr_hymns
    attr_accessor :hymn_array_fr_bookix
    attr_accessor :hymn_array_fr_bookindex
    
    # Russian
    RU_RANGE = 373
    attr_accessor :hymn_array_ru_hymns
    attr_accessor :hymn_array_ru_bookix
    attr_accessor :hymn_array_ru_bookindex    
    
    def setup
        # English Setup
        @hymn_array_en_hymns = parse_hymns(DATA_PATH + 'HymnsEN.dat')
        @hymn_array_en_bookix = parse_bookix(DATA_PATH + 'Hymns.English.Hymns Old and New 1987.bookix')
        
        # French Setup
        @hymn_array_fr_hymns = parse_hymns(DATA_PATH + 'HymnsFR.dat')
        @hymn_array_fr_bookix = parse_bookix(DATA_PATH + 'Hymns.Cantiques 1998.bookix')
        
        # Russian Setup
        @hymn_array_ru_hymns = parse_hymns(DATA_PATH + 'HymnsRU.dat')
        @hymn_array_ru_bookix = parse_bookix(DATA_PATH + 'Hymns.Песни Старые и новые 2005.bookix')
    end
    
    def parse_hymns(file)
        hymn_parser = BIXParser::ParseHymns.new
        hymn_parser.parse_hymn(File.new(file, 'r').read)
        return hymn_parser.hymns_array
    end
    
    def parse_bookix(file)
        #io = File.open(file,'r:UTF-8')
        #bookix_parser = XML::SaxParser.io(io, :encoding => XML::Encoding::UTF_8)
        data = File.new(file, 'r').read.gsub('&nbsp;',' ').force_encoding('UTF-8')
        bookix_parser = XML::SaxParser.string(data)
        parse_bookix = BIXParser::ParseBookix.new
        bookix_parser.callbacks = parse_bookix
        bookix_parser.parse
        #io.close
        return parse_bookix.hymns_array
    end
    
    def parse_bookindex(file)
    end
    
    def hymn_array_numbers(array,range)
        count = 0
        array.each do |n|
            count += 1 if (1..range).include?(n.number.to_i)
        end
        return count
    end

    def hymn_array_title(array)
        count = 0
        array.each do |t|
            count += 1 if t.title != nil
        end
        return count
    end

    def hymn_array_data(array)
        count = 0
        array.each do |d|
            count += 1 if d.data != nil
        end
        return count
    end

    def hymn_array_wordlist(array)
        count = 0
        array.each do |w|
            count += 1 if w.wordlist != nil
        end
        return count
    end

        
    # English Tests
    def test_en_hymns_count
        assert_equal(EN_RANGE, @hymn_array_en_hymns.size)
    end
    
    def test_en_hymns_number_exists
        assert_equal(EN_RANGE, hymn_array_numbers(@hymn_array_en_hymns,EN_RANGE))
    end

    def test_en_hymns_title_exists
        assert_equal(EN_RANGE, hymn_array_title(@hymn_array_en_hymns))
    end

    def test_en_hymns_data_exists
        assert_equal(EN_RANGE, hymn_array_data(@hymn_array_en_hymns))
    end

    def test_en_hymns_wordlist_exists
        assert_equal(EN_RANGE, hymn_array_wordlist(@hymn_array_en_hymns))
    end
    
    def test_en_bookix_count
        assert_equal(EN_RANGE, @hymn_array_en_bookix.size)
    end    

    def test_en_bookix_count
        assert_equal(EN_RANGE, @hymn_array_en_bookix.size)
    end
    
    def test_en_bookix_number_exists
        assert_equal(EN_RANGE, hymn_array_numbers(@hymn_array_en_bookix,EN_RANGE))
    end

    def test_en_bookix_title_exists
        assert_equal(EN_RANGE, hymn_array_title(@hymn_array_en_bookix))
    end

    def test_en_bookix_data_exists
        assert_equal(EN_RANGE, hymn_array_data(@hymn_array_en_bookix))
    end

    def test_en_bookix_wordlist_exists
        assert_equal(EN_RANGE, hymn_array_wordlist(@hymn_array_en_bookix))
    end


    # French Tests
    def test_fr_hymns_count
        assert_equal(FR_RANGE, @hymn_array_fr_hymns.size)
    end
    
    def test_fr_hymns_number_exists
        assert_equal(FR_RANGE, hymn_array_numbers(@hymn_array_fr_hymns,FR_RANGE))
    end
    
    def test_fr_hymns_title_exists
        assert_equal(FR_RANGE, hymn_array_title(@hymn_array_fr_hymns))
    end
    
    def test_fr_hymns_data_exists
        assert_equal(FR_RANGE, hymn_array_data(@hymn_array_fr_hymns))
    end
    
    def test_fr_hymns_wordlist_exists
        assert_equal(FR_RANGE, hymn_array_wordlist(@hymn_array_fr_hymns))
    end
    
    def test_fr_bookix_count
        assert_equal(FR_RANGE, @hymn_array_fr_bookix.size)
    end
    
    def test_fr_bookix_number_exists
        assert_equal(FR_RANGE, hymn_array_numbers(@hymn_array_fr_bookix,FR_RANGE))
    end
    
    def test_fr_bookix_title_exists
        assert_equal(FR_RANGE, hymn_array_title(@hymn_array_fr_bookix))
    end
    
    def test_fr_bookix_data_exists
        assert_equal(FR_RANGE, hymn_array_data(@hymn_array_fr_bookix))
    end
    
    def test_fr_bookix_wordlist_exists
        assert_equal(FR_RANGE, hymn_array_wordlist(@hymn_array_fr_bookix))
    end

    
    # Russian Tests
    def test_ru_hymns_count
        assert_equal(RU_RANGE, @hymn_array_ru_hymns.size)
    end
    
    def test_ru_hymns_number_exists
        assert_equal(RU_RANGE, hymn_array_numbers(@hymn_array_ru_hymns,RU_RANGE))
    end
    
    def test_ru_hymns_title_exists
        assert_equal(RU_RANGE, hymn_array_title(@hymn_array_ru_hymns))
    end
    
    def test_ru_hymns_data_exists
        assert_equal(RU_RANGE, hymn_array_data(@hymn_array_ru_hymns))
    end
    
    def test_ru_hymns_wordlist_exists
        assert_equal(RU_RANGE, hymn_array_wordlist(@hymn_array_ru_hymns))
    end
    
    def test_ru_bookix_count
        assert_equal(RU_RANGE, @hymn_array_ru_bookix.size)
    end
    
    def test_ru_bookix_number_exists
        assert_equal(RU_RANGE, hymn_array_numbers(@hymn_array_ru_bookix,RU_RANGE))
    end
    
    def test_ru_bookix_title_exists
        assert_equal(RU_RANGE, hymn_array_title(@hymn_array_ru_bookix))
    end
    
    def test_ru_bookix_data_exists
        assert_equal(RU_RANGE, hymn_array_data(@hymn_array_ru_bookix))
    end
    
    def test_ru_bookix_wordlist_exists
        assert_equal(RU_RANGE, hymn_array_wordlist(@hymn_array_ru_bookix))
    end

end
