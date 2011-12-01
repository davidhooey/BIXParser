# encoding: utf-8

SCRIPT_PATH = File.dirname(__FILE__)
$:.unshift(File.join(SCRIPT_PATH, '../lib'))

DATA_PATH = SCRIPT_PATH + '/data/'

require 'test/unit'
require 'bixparser'

include BIXParser
include REXML

class TestBookixParser < Test::Unit::TestCase
    
    # English
    EN_RANGE = 412
    attr_accessor :hymn_array_en_hymns
    attr_accessor :hymn_array_en_bookix
    EN_COPYRIGHT = [3,4,5,9,11,14,19,20,21,27,28,29,30,31,32,34,35,36,37,38,39,40,41,42,43,44,46,
                    50,51,52,53,55,56,57,61,62,63,64,65,66,67,68,69,70,71,72,73,75,76,77,78,79,
                    80,81,83,84,91,92,93,94,97,98,99,101,103,104,105,106,107,108,110,111,114,
                    115,116,121,122,123,126,127,129,130,131,133,134,135,136,140,142,143,144,
                    145,147,148,149,150,151,152,154,155,156,157,159,161,162,164,168,169,172,
                    173,174,176,177,178,179,180,181,182,184,185,186,188,189,190,191,192,193,
                    194,195,196,197,198,199,200,201,202,203,204,205,206,207,209,210,211,212,213,
                    215,216,217,218,219,221,222,223,226,227,229,230,232,233,235,236,237,239,
                    241,242,245,246,248,249,250,251,252,253,254,257,258,259,260,261,262,264,265,
                    266,267,268,269,270,272,273,274,275,278,279,280,281,282,283,284,285,286,
                    287,288,290,291,292,293,295,296,297,299,300,302,306,307,309,311,312,313,
                    315,316,317,318,319,320,322,323,325,326,328,329,331,332,333,335,336,338,339,
                    340,341,342,343,344,345,346,347,348,349,350,352,353,354,355,356,357,358,
                    359,360,361,364,365,366,367,368,369,370,371,373,374,375,376,380,381,382,383,
                    385,386,387,388,389,390,391,393,394, 396,398,399,401,402,403,405,406,407,
                    408,410,411,412]
    
    # French
    FR_RANGE = 301
    attr_accessor :hymn_array_fr_hymns
    attr_accessor :hymn_array_fr_bookix
    FR_COPYRIGHT = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,22,25,26,27,28,29,30,31,32,33,34,
                    35,36,37,38,39,40,41,42,43,44,45,46,47,48,51,52,53,54,55,56,57,58,59,60,62,64,
                    65,66,67,68,69,71,73,74,75,76,77,78,79,80,81,82,84,85,89,90,91,92,93,94,95,96,
                    97,98,99,100,102,104,106,108,109,110,111,112,113,114,115,116,117,118,119,120,
                    121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,
                    140,141,142,143,144,145,146,147,149,150,151,152,153,155,156,157,158,159,160,
                    161,162,163,164,165,166,167,168,170,171,172,173,175,176,177,178,179,180,181,
                    182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,201,
                    202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,
                    221,222,223,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,
                    241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,
                    260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,
                    280,281,282,283,284,285,286,287,288,289,291,292,293,294,295,296,297,298,299,
                    300,301]
    
    # Russian
    RU_RANGE = 373
    attr_accessor :hymn_array_ru_hymns
    attr_accessor :hymn_array_ru_bookix
    RU_COPYRIGHT = []
    
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
        hymn_parser.parse_hymn(File.new(file, 'r:UTF-8').read)
        return hymn_parser.hymns_array
    end
    
    def parse_bookix(file)
        string_data = String.new
        xml_file = File.new(file,'r:UTF-8')
        xml_file.each_line do |line|
            string_data << line
        end
        bookix_parser = ParseBookix.new
        bookix_parser.parse_bookix(string_data)
        return bookix_parser.hymns_array
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
    
    def hymn_array_copyright(array, copyright_array)
        count = 0
        puts copyright_array.size
        array.each do |hymn|
            if hymn.data =~ /©/
                count += 1 if copyright_array.include?(hymn.number.to_i)
            end
        end
        return count        
    end


    #
    # English Tests
    #
    
    # English: hymns Format
    
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
    
    # English: bookix Format
    
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

    def test_en_bookix_copyright
        assert_equal(EN_COPYRIGHT.size, hymn_array_copyright(@hymn_array_en_bookix, EN_COPYRIGHT))
    end

    #
    # French Tests
    #
    
    # French: hymns Format
    
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
    
    # French: bookix Format
    
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
    
    def test_fr_bookix_copyright
        assert_equal(FR_COPYRIGHT.size, hymn_array_copyright(@hymn_array_fr_bookix, FR_COPYRIGHT))
    end    

    
    #
    # Russian Tests
    #
    
    # Russian: hymn Format
    
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
    
    # Russian: bookix Format
    
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
