#/home/pi/.rvm/rubies/ruby-2.6.0/bin/ruby

def update_ip_address!
	current_ip  = get_current_ip
	previous_ip = get_previous_ip

	if current_ip != previous_ip
		update_dns!(previous_ip, current_ip)
	else
		log_no_change
	end	
end

def get_current_ip
	`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`.strip
end

def get_previous_ip
	File.open("previous_ip").read
end

def log(message)
	current_time = Time.now
	message = current_time.to_s + "\t" + message.to_s

	File.open("logs/dynamic_dns.log", "a+") { |f| f.puts(message) }
end

def log_ip_change(previous_ip, current_ip)
	log("Old IP used to be: #{previous_ip} \t New IP is: #{current_ip}")
end

def log_no_change
	log("Job ran with no IP address change")
end

def log_error(message)
	log("Error: #{message}")
end

def update_previous_ip!(new_ip)
	log_ip_change(previous_ip, current_ip)
	File.open('previous_ip', 'w').write(new_ip)
end

def update_dns!(previous_ip, new_ip)
	host = '@'
	domain_name   = ENV['DYNAMIC_DNS_DOMAIN_NAME']
	ddns_password = ENV['DDNS_PASSWORD']

	ensure_valid_variables!(host, domain_name, ddns_password, new_ip)
	
	url = "https://dynamicdns.park-your-domain.com/update?host=#{host}&domain=#{domain_name}&password=#{ddns_password}&ip=#{new_ip}"
	require 'net/https'

	url  = URI.parse(url)
	http = Net::HTTP.new(url.host, url.port)
	req  = Net::HTTP::Get.new(url.path)

	http.use_ssl = url.port == 443
	res = http.start { |http| http.request(req) }
	update_previous_ip!(previous_ip, new_ip)
end

def ensure_valid_variables!(host, domain_name, ddns_password, ip_address)
	if host.nil? || domain_name.nil? || ddns_password.nil? || ip_address.nil?
		log_error("Missing env vars: Host: #{host}, Domain Name: #{domain_name}, DDNS Pass: #{ddns_password}, New IP Address: #{ip_address}")
		exit
	end
end

update_ip_address!

