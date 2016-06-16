#!/usr/bin/env ruby
#
#

require './lib/logger'
require './lib/pp_generator'
require './lib/o_parser'

ME=File.basename($0, ".rb")
MD=File.dirname(File.expand_path($0))

TMP="/var/tmp/#{ME}/#{ENV['USER']}"
DST="#{TMP}/backup"
LOG="#{TMP}/#{ME}.log"
CFG=File.join(MD, ME+".json")

$log=Logger.set_logger(STDERR, Logger::WARN)

$opts = {
	:words=>"#{MD}/data/words.txt",
	:logger=> $log
}

$opts = OParser.parse($opts, "this is help text") { |opts|
	opts.on('-n', '--nwords NUM', Integer, "") { |num|
		$opts[:num]=num
	}
}

ppgen=Pp_generator.new($opts[:words], :logger=>$log)

#ppgen.reseed(1960)
#puts ppgen.seed

ppgen.loop_ppgen(20)
$log.info "Seed = #{ppgen.seed}"

