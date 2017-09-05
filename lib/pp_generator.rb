#
#
#

class Pp_generator
	attr_reader :wordfile, :seed, :log, :pp_hint, :pass_phrase

	DEF_OPTS={
		:pp_length=>4,
		:max_word_length=>6,
		:seed=>nil,
		:pp_hint => []
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
			puts gen_passphrase
		}
	end
end

