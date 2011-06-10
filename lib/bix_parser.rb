# encoding: utf-8

require 'unicode_utils'
require 'xml/libxml'

include LibXML # gem install libxml-ruby

module BIXParser
    
    class Item
        attr_accessor :number
        attr_accessor :title
        attr_accessor :data
        attr_accessor :wordlist
    end
    
    class Book
        attr_accessor :hymns_array
        
        def initialize
            @hymns_array = Array.new
        end        
    end
    
    class ParseBookix < Book
        include XML::SaxParser::Callbacks
        
        #<book>
        #<item
        #  meter="8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7"
        #  number="1"
        #  title="Tell Me the Story of Jesus">
        #
        #Tell me the story of Jesus;
        #Write on my heart every word.
        #Stay, let me say, “I will follow
        #Him who has suffered for me.”
        #
        #</item>
        #...        
        #</book>        
        
        attr_accessor :in_hymn
        attr_accessor :hymn_data
        attr_accessor :item
        
        def initialize
            super
            @in_hymn = false
            @hymn_data = Array.new
            @item = nil            
        end                
            
        def on_start_element_ns (name, attributes, prefix, uri, namespaces) 
            if name == 'item'
                @in_hymn = true
                @item = Item.new
                @item.number = attributes['number']
                @item.title = attributes['title']
            end
        end
            
        def on_end_element_ns (name, prefix, uri) 
            if name == 'item'
                @in_hymn = false
                @item.wordlist = BIXParser::gather_words(hymn_data)
                @item.data = hymn_data
                @hymn_data = Array.new
                @hymns_array << item
            end
        end
            
        def on_characters (chars)
            @hymn_data << chars if @in_hymn
        end
    end
        
    class ParseBookIndex < Book
        include XML::SaxParser::Callbacks

        #<item>
        #1. Tell Me the Story of Jesus
        #
        #Tell me the story of Jesus;
        #Write on my heart every word.
        #Stay, let me say, “I will follow
        #Him who has suffered for me.”
        #
        #meter? 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7
        #</item>        
    end
    
    class ParseHymns < Book
        include XML::SaxParser::Callbacks
        
        #<hymn>
        #1. Tell Me the Story of Jesus
        #
        #Tell me the story of Jesus;
        #Write on my heart every word.
        #Stay, let me say, “I will follow
        #Him who has suffered for me.”
        #</hymn>
        
        def parse_hymn(data)
            
            data_lines = data.split(/\r?\n/)
            
            in_hymn = false
            hymn_data = Array.new
            item = nil
            
            for line in data_lines
                if line =~ /<hymn>/u
                    in_hymn = true
                    item = Item.new
                    next
                end
                if line =~ /<\/hymn>/u
                    in_hymn = false
                    item.wordlist = BIXParser::gather_words(hymn_data)
                    hymn_data.delete_at(0) if hymn_data[0] =~ /^\r?\n$/
                    hymn_data[-1].chomp!
                    item.data = hymn_data.join
                    @hymns_array << item
                    hymn_data = Array.new
                    item = nil
                    next
                end
                if in_hymn
                    if line =~ /((\d+)\.(.+))/u
                        item.number = $2
                        item.title = $3.strip
                    else
                        hymn_data.push("#{line}\n")
                    end
                end
            end
            
            return @hymns_array
        end
                
    end
    
    def gather_words(data)
        word_hash = Hash.new(0)
        data.each do |text|
            words = text.downcase.scan(/\p{Word}+/)
            for word in words
                dcWord = UnicodeUtils.downcase(word)
                word_hash[dcWord] += 1
            end
        end
        return word_hash.keys.to_a.sort.join(' ').insert(0,' ').insert(-1,' ')
    end    
    
end
    