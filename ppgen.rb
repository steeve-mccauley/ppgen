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
	:word_file =>"#{MD}/data/words.txt",
	:logger=> $log,
	:pp_length => 4,
	:max_word_length => 6,
	:num => 20,
	:seed => nil,
	:pp_hint => []
}

$opts = OParser.parse($opts, "#{MD}/data/help.txt") { |opts|
	opts.on('-p', '--pplen WORDS', Integer, "Number of words in passphrase, def=#{$opts[:pp_length]}") { |length|
		$opts[:pp_length]=length
	}

	opts.on('-l', '--wordlen CHARS', Integer, "Maximum length of words for passphrase, def=#{$opts[:max_word_length]}") { |chars|
		$opts[:max_word_length]=chars
	}

	opts.on('-n', '--num NUM', Integer, "Number of passphrases to generate, def=#{$opts[:num]}") { |num|
		$opts[:num]=num
	}

	opts.on('-s', '--seed SEED', Integer, "Random number generator seed") { |seed|
		$opts[:seed]=seed
	}

	opts.on('-w', '--words WORDS', Array, "List of word(s) to include in passphrase") { |pp_hint|
		$opts[:pp_hint]=pp_hint
	}
}

begin
	ppgen=Pp_generator.new($opts[:word_file], $opts)

	ppgen.loop_ppgen($opts[:num])
rescue => e
	$log.error e.to_s
end

