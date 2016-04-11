require "resolv"

$keeping_ip = "";
$keeping_host_name = "";
$repeat_host_count = 0;

def dns_item?(line)
  item = line.strip.split(/\s+/)
  return false if item[0] == "127.0.0.1" || item[0] == "255.255.255.255"

  item[0] =~ Resolv::IPv4::Regex ? true : false
end

def host2domain(host_name)
  host_name.split(".", 2)[1]
end


def change_domain?(ip, host_name)
  if $keeping_ip == ""
    $keeping_ip = ip 
    $keeping_host_name = host_name
    return false
  end
  if $keeping_ip == ip && host2domain($keeping_host_name) == host2domain(host_name)
    $repeat_host_count = $repeat_host_count + 1
    return false
  end

  $output_ip = $keeping_ip
  $output_name = $repeat_host_count > 0 ? "*." + host2domain($keeping_host_name) : $keeping_host_name
  $repeat_host_count = 0

  $keeping_ip = ip
  $keeping_host_name = host_name
  true
end

ARGF.lines do |line|
  next if line.start_with?('#')
  next unless dns_item?(line)

  item = line.strip.split(/\s+/)
  ip, host_name = item[0], item[1]


  if change_domain?(ip, host_name)
    puts "#{$output_ip}\t#{$output_name}"  
  end
end

