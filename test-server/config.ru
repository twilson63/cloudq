require 'cloudq'

log = File.new('cloudq.log', 'a+')
$stdout.reopen(log)
$stderr.reopen(log)

run Cloudq::App
