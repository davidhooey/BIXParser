Gem::Specification.new do |s|
    s.name          = 'bixparser'
    s.version       = '1.0.4'
    s.authors       = ['David Hooey']
    s.email         = ['davidhooey@gmail.com']
    s.homepage      = ''
    s.summary       = 'Parse Bookix and original HymnXX.dat files for the HymnsUpdate site.'
    s.description   = 'This gem is used by the HymnsUpdate Rails site to process and parse the Bookix and HymnXX.dat files. The resulting parse is then saved to the database.'
    s.files         = ['lib/bixparser.rb']
    s.test_files    = ['test/test_bixparser.rb','test/parse.rb']
    s.require_path  = 'lib'
    s.add_runtime_dependency 'unicode_utils'
end
