require 'test/unit'
require_relative '../lib/iplog.rb'
require 'net/http'

class IplogTests < Test::Unit::TestCase
include Iplog
  Iplog.configliere_setup("#{File.dirname(__FILE__)}")
  Settings.read("#{__dir__}/config.yaml")

  def testrun_script
    Iplog.run_script(true)
  end

  def test_Iplog
    assert_equal(Iplog.methods.include?(:current_ip),true) 
  end

  def test_method_current_ip
    uri = URI("http://127.0.0.1")
    uri.port = 4567
    assert_equal(Iplog.current_ip(uri),"127.0.0.1")
  end

  def test_correct_add_last_ip
    FileUtils.rm(Settings[:log_path]) if File.exists?(Settings[:log_path])
    assert_equal(Iplog.last_ip_from_log, nil)
    Iplog.add_ip_to_log
    assert_equal(Iplog.last_ip_from_log,"127.0.0.1")
    FileUtils.rm(Settings[:log_path])
  end

end
