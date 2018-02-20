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

$log=Logger.set_logger(STDERR, Logger::INFO)

PPGEN_CASE=(ENV['PPGEN_CASE']||0).to_i
PPGEN_NUMBERS=(ENV['PPGEN_NUMBERS']||0).to_i
PPGEN_SPECIAL=(ENV['PPGEN_SPECIAL']||0).to_i

$opts = {
	:word_files =>["#{MD}/data/words.txt"],
	:logger=> $log,
	:pp_length => 4,
	:max_word_length => 6,
	:num => 20,
	:seed => nil,
	:random_case => PPGEN_CASE,
	:special_char => PPGEN_SPECIAL,
	:numbers => PPGEN_NUMBERS,
	:space_special => 0,
	:space_numbers => 0,
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

	opts.on('-C', '--random-case PERCENT', Integer, "Percentage of case switches to include in passphrase, def=#{$opts[:random_case]}%") { |random_case|
		raise "Enter percentage as positive integer between 0 and 100" if random_case < 0 || random_case > 100
		$opts[:random_case] = random_case
	}

	opts.on('-S', '--special-char PERCENT', Integer, "Percentage of special characters to include in passphrase, def=#{$opts[:special_char]}%") { |special_char|
		raise "Enter percentage as positive integer between 0 and 100" if special_char < 0 || special_char > 100
		$opts[:special_char] = special_char
	}

	opts.on('-T', '--space-special NUM', Integer, "Replace spaces with special characters") { |num|
		$opts[:space_special]=num
	}

	opts.on('-U', '--specials STRING', String, "List of special characters, def [#{Pp_generator.get_specials}]") { |specials|
		Pp_generator.set_specials(specials)
	}

	opts.on('-N', '--numbers PERCENT', Integer, "Percentage of digits to include in passphrase, def=#{$opts[:numbers]}%") { |numbers|
		raise "Enter percentage as positive integer between 0 and 100" if numbers < 0 || numbers > 100
		$opts[:numbers] = numbers
	}

	opts.on('-O', '--space-numbers NUM', Integer, "Replace up to num spaces with numbers") { |num|
		$opts[:space_numbers]=num
	}

	opts.on('-f', '--data FILES', Array, "Array of extra word files in addition to #{$opts[:word_files]}") { |word_files|
		word_files.each { |word_file|
			begin
				word_file=File.expand_path(word_file)
				word_file=File.realpath(word_file)
				$opts[:word_files] << word_file
				$opts[:word_files].uniq!
			rescue => e
				$log.die "Word file #{word_file}: "+e.message
			end
		}
	}
}

begin
	ppgen=Pp_generator.new($opts[:word_files], $opts)

	ppgen.loop_ppgen($opts[:num])
rescue => e
	$log.error e.to_s
	e.backtrace.each { |m| puts m }
end

