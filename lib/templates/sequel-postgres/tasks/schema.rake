task :test_db do
  require "lib/fxc"
  require FXC::ROOT/:spec/:db_helper
end

desc "Dump the test schema"
task :schema, :format, :needs => [:test_db] do |t,args|
  args.with_defaults(:format => "html")
  descs = DB.tables.inject([]) do |arr, table|
    arr << "\\dd #{table};\\d+ #{table}"
  end
  commands = descs.join(";")
  if args.format.to_s == "html"
    f = File.open("doc/schema.html","w+") 
    command = %Q{echo '\\H #{commands}'|PGDATA=#{ENV['PGDATA']} PGHOST=#{ENV['PGHOST']} PGPORT=#{ENV['PGPORT']} psql fxc|tail -n +2}
  else
    command = %Q{echo '#{commands}'|PGDATA=#{ENV['PGDATA']} PGHOST=#{ENV['PGHOST']} PGPORT=#{ENV['PGPORT']} psql fxc}
    f = $stdout
  end
  f.puts %x{#{command}}
  unless f == $stdout
    f.close
    puts "Saved doc/schema.html"
  end

end
