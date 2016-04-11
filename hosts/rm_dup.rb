items = {}

ARGF.lines do |line|
  item = line.strip.split(/\s+/)
  ip, host_name = item[0], item[1]
  items[host_name] = ip
end

items.each {|key, value| puts "#{value}\t#{key}" }
