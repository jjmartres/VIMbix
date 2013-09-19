class VIMbix < Sinatra::Base

  module VERSION
    MAJOR    = 1
    MINOR    = 0
    TINY     = 8

    STRING   = [MAJOR, MINOR, TINY].join('.')
  end
end
