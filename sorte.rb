#!/usr/bin/env ruby-local-exec

require "trollop"

opts = Trollop::options do
  banner <<-END
Sort a directory of mp3s into folders base on their tags:

artist/album

Usage: ./sorte [options]
where options are:
END
  opt :dry, "Dry run", :default => false
end