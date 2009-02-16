require 'reek'

desc "Find smelly code, without params the whole project is scanned, but file can selected with param files='app/models/model.rb app/helpers/helper.rb'. To suppress detailed output use 'verbose=false'."
task :reek do
  VERBOSE = ENV['verbose'] && ENV['verbose'] == "false" ? false : true
  files_to_check = ENV['files'] ? ENV['files'].split(' ') : FileList['app/models/*.rb','app/controllers/*.rb','app/helpers/*.rb']
  statistics = Hash.new

  puts "================================================================="
  puts "  Running reek! "
  puts "  #{files_to_check.size} #{files_to_check.size > 1 ? "files" : "file" }to check..."

  files_to_check.each do |file_name|
    results = Reek::analyse(file_name)
    statistics[results.length] ||= []
    statistics[results.length] << file_name
    unless results.length.zero? or not VERBOSE
      puts "================================================================="
      puts " * #{file_name}, #{results.length} warnings:"
      puts "-----------------------------------------------------------------"
      puts results
    end
    print "." unless VERBOSE
  end
  print "\n" unless VERBOSE
  
  unless files_to_check.size < 5
    statistics = statistics.sort.reverse
    puts "================================================================="
    puts " Top worst files:"
    10.times do |i|
      break if statistics[i].nil?
      puts "  * #{statistics[i][0]} errors:"
      statistics[i][1].each do |file_name|
        puts "     #{file_name} "
      end
    end
    if statistics.last[0] == 0
      puts "-----------------------------------------------------------------"
      puts " #{ statistics.last[1].size } files without warnings out of #{files_to_check.size} (#{ ((statistics.last[1].size.to_f/files_to_check.size.to_f) * 100).round }%)"
    end
  end
  
  puts "================================================================="
end
