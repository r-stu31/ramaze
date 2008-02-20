#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'logger'

module Ramaze

  # Informer for the Stdlib Logger

  class Logger < ::Logger

    # integration to Informing

    def inform(tag, *args)
      __send__(tag, args.join("\n"))
    end

    def dev(*args)
      debug(*args)
    end
  end
end
