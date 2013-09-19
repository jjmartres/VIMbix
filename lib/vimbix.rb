require "rubygems"
require "bundler"
Bundler.require :default

class VIMbix < Sinatra::Base
  set :root, Dir[File.dirname(__FILE__) + "/.." ]*""
end

Dir[File.dirname(__FILE__) + "/vimbix/*.rb"].each { |file| require file }
