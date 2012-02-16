#! /usr/bin/env ruby


###
# BEFORE YOU RUN THIS
# make sure you run "vulcan create" and you have 
# S3_KEY and S3_SECRET set in your environment (in your .rvmrc perhaps, or just using env)
###


require "tmpdir"
require 'aws/s3'

Dir.mktmpdir("sqlite") do |dir|
  puts `curl http://www.sqlite.org/sqlite-autoconf-3071000.tar.gz | tar -xvzf -`
  begin
    puts `vulcan build -s sqlite-autoconf-3071000 -p /tmp/sqlite3 -c "./configure --prefix=/tmp/sqlite3 && make && make install" 2 >&1`
  rescue
    puts "Vulcan build failed -- did you run vulcan create first?"
  end
  puts "Connecting to S3..."
  AWS::S3::Base.establish_connection!(:access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'])
  puts "Creating bucket..."
  begin
    Bucket.create("heroku_libs")
  rescue
    puts "Bucket created (or it already existed)."
  end
  puts "Uploading..."
  class MyObj < AWS::S3::S3Object
    set_current_bucket_to "heroku_libs"
  end

  result = MyObj.store('sqlite-autoconf-3071000.tgz', open('/tmp/sqlite-autoconf-3071000.tgz'), :access => :public_read)
  puts result.to_s
end
