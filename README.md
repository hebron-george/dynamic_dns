# Intro

This is a simple project to get the PI's public IP address and update my DynamicDNS record. 

## Requirements

This project assumes you're using Namecheap's Dynamic DNS service.

You will need the following values:

- Host (i.e. sub domain)
- Domain
- Dynamic DNS Password

## Getting Started

Create a Cron job that runs every hour and sends the current public address to Namecheap.

```
0 * * * * HOST=www DYNAMIC_DNS_DOMAIN_NAME=example.com DDNS_PASSWORD=some_password ruby path/to/dynamic_dns/app.rb >> path/to/dynamic_dns/logs/cron.log 2>&1
```

## Logs

You can check the `previous_ip` file that gets generated in the project root when run to see what the IP was changed to.

You can check `path/to/dynamic_dns/logs/cron.log` for logs output by the program.

