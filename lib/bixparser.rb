# encoding: utf-8

require 'unicode_utils'
require "rexml/document"

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
        
        def gather_words(data)
            word_hash = Hash.new(0)
            data.each do |text|
                # Need to convert from ASCII-8BIT to UTF-8.
                # It seems Ruby 1.9 uses ASCII-8BIT intenally.
                # See https://github.com/cfis/libxml-ruby/pull/7
                # http://stackoverflow.com/questions/2148729/libxml-converts-accented-characters-into-backlash-x-escapes-json-is-not-happy
                utf8_text = text.force_encoding('UTF-8')
                dc_text = UnicodeUtils.downcase(utf8_text)
                # I'm hoping UnicodeUtils.each_word will split on CKJ characters.
                UnicodeUtils.each_word(dc_text) do |word|
                    unless word.scan( /\p{Word}+/u ).empty?
                        word_hash[word] += 1
                    end
                end
                #words = dcText.scan(/w+/)
                #for word in words
                #    word_hash[word] += 1
                #end
            end
            return word_hash.keys.to_a.sort.join(' ').insert(0,' ').insert(-1,' ')
        end            
    end
        
    class ParseBookix < Book
        include REXML
        
        #<book>
        #<item
        #  Copyright="©"
        #  author="Sam Jones"
        #  composer="May Whittle Moody (1870-)"
        #  meter="10, 10, 10, 10, 10, 10, 10, 10"
        #  number="3"
        #  title="Tell Me Again">
        #
        #Tell me again of God’s wonderful love:
        #How Jesus left those fair mansions above,
        #Suffered and died for my sins on the tree;
        #He made atonement for you and for me.
        #...
        #</item>
        #</book>        
        
        attr_accessor :item
        
        def initialize
            super
            @item = nil
        end
        
        def parse_bookix(data)
            xml_data = Document.new(data)
            xml_data.elements.each("book/item") do |element|
                @item = Item.new
                @item.number = element.attributes['number']
                @item.title = element.attributes['title']
                @item.data = element.text.strip.gsub('&nbsp;',' ')
                item_attributes = Array.new
                element.attributes.keys.each do |k|
                    if k != 'number' and k != 'title'
                        if not element.attributes[k].nil?
                            if element.attributes[k].strip.length > 0
                                item_attributes << "\n#{k}: #{element.attributes[k].strip}"
                            end
                        end
                    end
                end
                if item_attributes.size != 0
                    @item.data << "\n #{item_attributes.join}"
                end                                
                data_array = element.text.strip.gsub('&nbsp;',' ').split("\n")
                @item.wordlist = gather_words(data_array)
                @item.title = data_array[0] if @item.title == nil
                @hymns_array << @item
            end
        end
        
    end
            
    class ParseHymns < Book
        
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
                    item.wordlist = gather_words(hymn_data)
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
        
end
    