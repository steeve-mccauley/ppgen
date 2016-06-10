#!/usr/bin/env ruby
#
#

require 'optparse'
require 'logger'

require './lib/pp_generator'

ME=File.basename($0, ".rb")
MD=File.dirname(File.expand_path($0))

TMP="/var/tmp/#{ME}/#{ENV['USER']}"
DST="#{TMP}/backup"
LOG="#{TMP}/#{ME}.log"
CFG=File.join(MD, ME+".json")

class Logger
	def die(msg)
		$stdout = STDOUT
		self.error(msg)
		exit 1
	end

	def puts(msg)
		self.info(msg)
	end

	def write(msg)
		self.info(msg)
	end
end

def set_logger(stream, level=Logger::INFO)
	log = Logger.new(stream)
	log.level = level
	log.datetime_format = "%Y-%m-%d %H:%M:%S"
	log.formatter = proc do |severity, datetime, progname, msg|
		"#{severity} #{datetime}: #{msg}\n"
	end
	log
end

$log=set_logger(STDERR, Logger::WARN)

$opts = {
	:words=>"#{MD}/data/words.txt"
}

def parse_opts(gopts)
	begin
		optparser = OptionParser.new { |opts|
			opts.banner = "#{ME}.rb [options]\n"

			opts.on('-v', '--verbose', "Verbose output") {
				gopts[:verbose]=true
				$log.level = Logger::INFO
			}

			opts.on('-D', '--debug', "Turn on debugging output") {
				$log.level = Logger::DEBUG
			}

			opts.on('-h', '--help', "Help") {
				$stdout.puts ""
				$stdout.puts opts
				$stdout.puts <<HELP

HELP
				exit 0
			}
		}
		optparser.parse!
	rescue OptionParser::InvalidOption => e
		$log.die "Invalid option: "+e.message
	rescue => e
		e.backtrace.each { |tr|
			puts tr
		}
		$log.die "Exception: "+e.message
	end

	gopts
end

$opts=parse_opts($opts)

ppgen=Pp_generator.new($opts[:words], :logger=>$log)

#ppgen.reseed(1960)
#puts ppgen.seed

ppgen.loop_ppgen(20)
$log.info "Seed = #{ppgen.seed}"

