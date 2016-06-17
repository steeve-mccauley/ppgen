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
	:logger=> $log,
	:pp_length => 4,
	:max_word_length => 6,
	:num => 20,
	:seed => nil
}

$opts = OParser.parse($opts, "#{MD}/data/help.txt") { |opts|
	opts.on('-p', '--pplen WORDS', Integer, "Number of words in passphrase, def=#{$opts[:pp_length]}") { |words|
		$opts[:pp_length]=words
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
}

ppgen=Pp_generator.new($opts[:words], $opts) 

ppgen.loop_ppgen($opts[:num])

