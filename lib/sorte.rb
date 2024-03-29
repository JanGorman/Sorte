require "trollop"
require "mp3info"

opts = Trollop::options do
  banner <<-END
Sort a directory of mp3s into folders base on their tags:

artist/album

Usage: sorte.rb [options]
where options are:
END
  opt :dry, "Dry run", :default => false
  opt :verbose, "Verbose", :default => false
  opt :dir, "The directory", :type => String, :default => "."
end

def make_dir(dir)
  FileUtils.mkdir_p(dir) unless File.exists?(dir)
end

if opts[:dry]
  puts "\n"
  puts "#" * 15
  puts "Dry Run".center 15
  puts "#" * 15
  puts "\n"
end

Dir.glob("#{opts[:dir]}/*.{mp,MP}3") do |f|
  begin
    Mp3Info.open(f) do |info|
      dir = "#{opts[:dir]}/#{info.tag.artist}/#{info.tag.album}"
      if !opts[:dry]
        if opts[:verbose]
          puts "Create directory #{dir}"
        end
        make_dir dir
        FileUtils.mv f, "#{dir}/#{File.basename f}", :verbose => opts[:verbose]
      else
        puts "Create directory #{dir}"
        puts "Move file #{f} to directory #{dir}"
      end
    end
  rescue Mp3InfoError => e
    # Ignore `bad VBR header (Mp3InfoError)`
  end
end