require 'minitest/autorun'
require 'yaml'
$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
require 'aliyun_oss/oss'
require_relative 'config'

class TestObjectACL < Minitest::Test
  def setup
    AliyunOSS::Common::Logging.set_log_level(Logger::DEBUG)
    client = AliyunOSS::OSS::Client.new(TestConf.creds)
    @bucket = client.get_bucket(TestConf.bucket)

    @prefix = "tests/object_acl/"
  end

  def get_key(k)
    "#{@prefix}#{k}"
  end

  def test_put_object
    key = get_key('put')

    @bucket.put_object(key, acl: AliyunOSS::OSS::ACL::PRIVATE)
    acl = @bucket.get_object_acl(key)

    assert_equal AliyunOSS::OSS::ACL::PRIVATE, acl

    @bucket.put_object(key, acl: AliyunOSS::OSS::ACL::PUBLIC_READ)
    acl = @bucket.get_object_acl(key)

    assert_equal AliyunOSS::OSS::ACL::PUBLIC_READ, acl
  end

  def test_append_object
    key = get_key('append-1')

    @bucket.append_object(key, 0, acl: AliyunOSS::OSS::ACL::PRIVATE)
    acl = @bucket.get_object_acl(key)

    assert_equal AliyunOSS::OSS::ACL::PRIVATE, acl

    key = get_key('append-2')

    @bucket.put_object(key, acl: AliyunOSS::OSS::ACL::PUBLIC_READ)
    acl = @bucket.get_object_acl(key)

    assert_equal AliyunOSS::OSS::ACL::PUBLIC_READ, acl
  end
end
