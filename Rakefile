require 'rubygems'
require 'less'
require 'rake'


SOURCE = "."
LESS = File.join( SOURCE, "assets", "css")
CONFIG = {
  'less'   => File.join(LESS),
  'css'    => File.join(LESS),
  'input'  => "main.less",
  'output' => "main.css"
}

desc "Compile Less"
task :less do
  less   = CONFIG['less']

  input  = File.join( less, CONFIG['input'] )
  output = File.join( CONFIG['css'], CONFIG['output'] )

  source = File.open( input, "r" ).read

  parser = Less::Parser.new( :paths => [less] )
  tree = parser.parse( source )

  File.open( output, "w+" ) do |f|
    f.puts tree.to_css( :compress => true )
  end
end

desc 'Build'
task :build => [:less] do
  sh 'jekyll'
end


desc ''
task :server do
  sh 'jekyll --server --auto'
end


task :default => :build