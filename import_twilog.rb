#!/usr/bin/ruby -Ku
# -*- encoding:utf-8 -*-
# Twilogからインポート
#
require 'csv'
require './dbot'
menchk_usr=true
rtchk_usr=true
urlchk_usr=true
alnumchk_usr=true

csvfile = ARGV[0]
outfile = ARGV[1]

if csvfile.nil? or outfile.nil?
  puts "error:few arguments"
  puts "arg1:csvfile, arg2:dbfilename"
  exit 1
end

db=WordsDB.new(outfile)
db.initdb

CSV.foreach(csvfile){|stat,time,tweet|
  menchk   = (/@\S*/ =~ tweet).nil? or (not menchk_usr)
  rtchk    = (/^RT\s/ =~ tweet).nil? or (not rtchk_usr)
  urlchk   = (/http(s)?:\/\// =~ tweet).nil? or (not urlchk_usr)
  alnumchk = (/\w/ =~ tweet).nil? or (not alnumchk_usr)

  if menchk and rtchk and urlchk and alnumchk
    puts "now importing \"#{tweet}\""
    db.insert("#{tweet}")
  else
    puts "skip \"#{tweet}\""
  end
}
db.close
