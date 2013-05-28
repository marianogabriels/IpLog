require_relative "iplog/version"
require 'net/http'
require 'configliere'
require 'fileutils'

module Iplog

 class << self
   def configliere_setup(config_path=__dir__)
     Settings.read("#{config_path}/config.yaml")
     @@log_path = Settings[:log_path]
     @@uri = generate_uri
   end

   def run_script(test=false,sleep_time = 60)
     generate_uri
     configliere_setup unless test
     sleep_time = Settings[:sleep_time].to_i unless Settings[:sleep_time].empty?
     loop do
     add_ip_to_log if last_ip_from_log != current_ip(@@uri)
     sleep(sleep_time)
     end

   end

   def generate_uri
     uri = URI(Settings[:ip_source])
     uri.port = Settings[:port].to_i
     uri
   end

   def current_ip(uri)
     Net::HTTP.get(uri)
   end

   def last_ip_from_log
     IO.readlines(@@log_path).last.gsub(/\n/,"") if File.exists?(@@log_path)
   end

   def add_ip_to_log
     File.open(@@log_path, "a+"){|f| f << "#{current_ip(@@uri)}\n" } 
   end

 end
end
