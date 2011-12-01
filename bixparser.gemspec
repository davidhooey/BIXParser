$:.unshift(File.join(File.dirname(__FILE__), '/lib'))

require 'bixparser/version'

Gem::Specification.new do |s|
    s.name          = 'bixparser'
    s.version       = BIXParser::VERSION
    s.authors        = ['David Hooey']
    s.email         = ['davidhooey@gmail.com']
    s.homepage      = ''
    s.summary       = 'Parse Bookix and original HymnXX.dat files for the HymnsUpdate site.'
    s.description   = 'This gem is used by the HymnsUpdate Rails site to process and parse the Bookix and HymnXX.dat files. The resulting parse is then saved to the database.'
    s.files         = ['lib/bixparser.rb','lib/bixparser/version.rb']
    s.test_files    = ['test/test_bixparser.rb','test/parse.rb','test/data/HymnsEN.dat','test/data/Hymns.English.Hymns Old and New 1987.bookix']
end
