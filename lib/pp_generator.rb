#
#
#

class Pp_generator
	attr_reader :wordfile, :seed, :log, :pp_hint, :pass_phrase, :random_case

	SPECIAL_CHARS = %q{!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~}.split(//)

	DEF_OPTS={
		:pp_length=>4,
		:max_word_length=>6,
		:seed=>nil,
		:pp_hint => [],
		:random_case => 0,
		:special_char => 0
	}

	def initialize(wordfile, opts=DEF_OPTS)
		@log=opts[:logger]||Logger.new
		load_words(wordfile)
		reseed(opts[:seed])

		@pp_length = opts[:pp_length]|| DEF_OPTS[:pp_length]
		raise "passphrase length is too small" if @pp_length < 2
		@pp_hint = opts[:pp_hint]|| DEF_OPTS[:pp_hint]
		raise "Too many hints for given passphrase length" if @pp_length <= @pp_hint.length
		@max_word_length = opts[:max_word_length]||DEF_OPTS[:max_word_length]
		@random_case = opts[:random_case]||DEF_OPTS[:random_case]
		@special_char = opts[:special_char]||DEF_OPTS[:special_char]
	end

	def load_words(wordfile)
		@wordfile=wordfile
		@words=File.read(@wordfile).split(/\n+/)
		@nwords=@words.length
	rescue => e
		puts "Failed to load #{@wordfile}"
		raise e
	end

	def reseed(seed=nil)
		seed=Random.new_seed if seed.nil?
		@r=Random.new(seed)
		@seed=@r.seed
	end

	def massage_passphrase(pp)
		pplen = pp.length
		return nil if @random_case == 0 && @special_char == 0
		mp = String.new(pp)
		if @random_case > 0
			# percentage of pass phrase to flip case
			nchars = (pplen.to_f*@random_case/100).ceil
			nchars.times {
				# take random index from the string
				idx = Random.rand(pplen)
				mp[idx]=mp[idx].swapcase
			}
		end
		if @special_char > 0
			nchars = (pplen.to_f*@special_char/100).ceil
			nchars.times {
				# take random index from the string
				idx = Random.rand(pplen)
				mp[idx]=SPECIAL_CHARS[Random.rand(SPECIAL_CHARS.length)]
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
				puts "#{pp} [#{mp}]"
			end
		}
	end
end

