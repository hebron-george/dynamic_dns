#/home/pi/.rvm/rubies/ruby-2.6.0/bin/ruby

def update_ip_address!
	current_ip  = get_current_ip
	previous_ip = get_previous_ip

	if current_ip != previous_ip
		log_ip_change(previous_ip, current_ip)
		update_dns!(current_ip)
	else
		log_no_change
	end	
end

def get_current_ip
	`curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`.strip
end

def get_previous_ip

end

def log(message)

end

def log_ip_change(previous_ip, current_ip)

end

def log_no_change

end

def log_error(message)

end

def update_dns!(new_ip)
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

end

def ensure_valid_variables!(host, domain_name, ddns_password, ip_address)
	if host.nil? || domain_name.nil? || ddns_password.nil? || ip_address.nil?
		log_error("Missing env vars: Host: #{host}, Domain Name: #{domain_name}, DDNS Pass: #{ddns_password}, New IP Address: #{ip_address}")
		exit
	end
end

update_ip_address!

