#! /usr/bin/env ruby

AWS::S3::Base.establish_connection!(:access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'])
Bucket.create("heroku_libs")

class MyObj << AWS::S3::S3Object
  set_current_bucket_to "heroku_libs"
end

result = MyObj.store('sqlite-autoconf-3071000.tgz', open('/tmp/sqlite-autoconf-3071000.tgz'), :access => :public_read)
