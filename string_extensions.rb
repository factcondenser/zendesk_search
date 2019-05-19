module StringExtensions
  refine String do
    def bold
      "\e[1m#{self}\e[22m"
    end

    def colorize(color_code)
      "\e[#{color_code}m#{self}\e[0m"
    end

    def green
      colorize(32)
    end

    def yellow
      colorize(33)
    end

    def light_blue
      colorize(36)
    end
  end
end
