#
#
#

class Pp_generator
	attr_reader :wordfile, :seed, :log

	DEF_OPTS={
		:pp_length=>4,
		:max_word_length=>6,
		:seed=>nil
	}

	def initialize(wordfile, opts=DEF_OPTS)
		@log=opts[:logger]||Logger.new
		load_words(wordfile)
		reseed(opts[:seed])

		@pp_length = opts[:pp_length]|| DEF_OPTS[:pp_length]
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
		pp=[]
		while true do
			idx=@r.rand(@nwords)
			word=@words[idx]
			next if word.length > @max_word_length
			pp << word
			break if pp.length == @pp_length
		end
		pp.join(" ")
	end

	def loop_ppgen(num)
		num.times { |n|
			puts gen_passphrase
		}
	end
end

