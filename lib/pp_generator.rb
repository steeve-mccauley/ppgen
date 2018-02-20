#
#
#

class Pp_generator
	attr_reader :wordfiles, :seed, :log, :pp_hint, :pass_phrase, :random_case, :special_char, :numbers, :space_special, :space_numbers

	@@SPECIAL_CHARS = %q{!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~}.split(//)
	@@NUMBERS=%w/0 1 2 3 4 5 6 7 8 9/

	DEF_OPTS={
		:pp_length=>4,
		:max_word_length=>6,
		:seed=>nil,
		:pp_hint => [],
		:random_case => 0,
		:special_char => 0,
		:numbers => 0,
		:space_special => 0,
		:space_numbers => 0
	}

	def self.get_specials
		@@SPECIAL_CHARS.join
	end

	def self.set_specials(specials)
		@@SPECIAL_CHARS=specials.split(//)
	end

	def get_def(opts, key)
		return opts[key] if opts.key?(key)
		default=DEF_OPTS[key]
		raise "option #{key} not foundin DEF_OPTS" if default.nil?
		return default
	end

	def initialize(wordfiles, opts=DEF_OPTS)
		@log=opts[:logger]||Logger.new
		load_words(wordfiles)
		reseed(opts[:seed])

		@pp_length = get_def(opts, :pp_length) #opts[:pp_length]|| DEF_OPTS[:pp_length]
		raise "passphrase length is too small" if @pp_length < 2
		@pp_hint = get_def(opts, :pp_hint) #opts[:pp_hint]|| DEF_OPTS[:pp_hint]
		raise "Too many hints for given passphrase length" if @pp_length <= @pp_hint.length
		@max_word_length = get_def(opts, :max_word_length) #opts[:max_word_length]||DEF_OPTS[:max_word_length]
		@random_case = get_def(opts, :random_case) #opts[:random_case]||DEF_OPTS[:random_case]
		@special_char = get_def(opts, :special_char) #opts[:special_char]||DEF_OPTS[:special_char]
		@numbers = get_def(opts, :numbers) #opts[:numbers]||DEF_OPTS[:numbers]

		@space_special=get_def(opts, :space_special)
		@space_numbers=get_def(opts, :space_numbers)
	end

	def load_words(wordfiles)
		@wordfiles=wordfiles
		@words=[]
		@wordfiles.each { |wordfile|
			words=nil
			begin
				@log.info "Loading corpus from #{wordfile}"
				words=File.read(wordfile)
				words=words.split(/[\s\n]+/)
				words.uniq!
				words.delete("")
				@words.concat(words)
				@log.info "Loaded #{words.length} unique words"
			rescue => e
				@log.error("Failed to read #{wordfile}")
			end
		}
		@nwords=@words.length
	rescue => e
		puts "Failed to load #{@wordfiles.inspect}"
		raise e
	end

	def reseed(seed=nil)
		seed=Random.new_seed if seed.nil?
		@r=Random.new(seed)
		@seed=@r.seed
	end

	def len_percent(pplen, pc)
		return 0 if pc == 0
		(pplen.to_f*pc/100).ceil
	end

	def array_rand(array)
		array[Random.rand(array.length)]
	end

	##
	# find_spaces find indeces of spaces in string mp, return random array of indeces
	#
	def find_spaces(mp, limit)
		spaces = []
		return spaces if limit <= 0
		pos = -1
		while (pos = mp.index(/\s/, pos+1))
			spaces << pos
		end
		spaces.shuffle.slice(0, limit)
	end

	def massage_passphrase(pp)
		pplen = pp.length
		return nil if @random_case == 0 && @special_char == 0 && @numbers == 0 && @space_numbers == 0 && @space_special == 0
		mp = String.new(pp)

		# percentage of pass phrase to flip case
		len_percent(pplen, @random_case).times {
			# take random index from the string
			idx = Random.rand(pplen)
			mp[idx]=mp[idx].swapcase
			@log.debug "rc idx=#{idx}"
		}

		if @space_special > 0
			find_spaces(mp, @space_special).each { |idx|
				rc=array_rand(@@SPECIAL_CHARS)
				mp[idx] = rc
			}
		else
			len_percent(pplen, @special_char).times {
				# take random index from the string
				idx = Random.rand(pplen)
				mp[idx]=array_rand(@@SPECIAL_CHARS) # @@SPECIAL_CHARS[Random.rand(@@SPECIAL_CHARS.length)]
			}
		end

		if @space_numbers > 0
			find_spaces(mp, @space_numbers).each { |idx|
				rc=array_rand(@@NUMBERS)
				mp[idx] = rc
			}
		else
			len_percent(pplen, @numbers).times {
				# take random index from the string
				idx = Random.rand(pplen)
				mp[idx]=array_rand(@@NUMBERS) # @@NUMBERS[Random.rand(@@NUMBERS.length)]
			}
		end
		mp
	end

	def gen_passphrase
		@pass_phrase=Array.new(@pp_hint)
		while true do
			idx=@r.rand(@nwords)
			word=@words[idx]
			next if @max_word_length > 0 && word.length > @max_word_length
			@pass_phrase << word
			break if @pass_phrase.length == @pp_length
		end
		@pass_phrase.join(" ")
	end

	def loop_ppgen(num)
		puts "seed="+@seed.to_s
		num.times { |n|
			pp = gen_passphrase
			mp = massage_passphrase(pp)
			if mp.nil?
				puts pp
			else
				puts "#{mp}\n\t[#{pp}]"
			end
		}
	end
end

