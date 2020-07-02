require 'colorize'

class Card

    VALUES = {
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "10" => 9,
    "J" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13,
    }


    attr_reader :symbol, :value, :suit
    def initialize(symbol, suit)
        @symbol = symbol
        @value = VALUES[symbol]
        @suit = suit
    end

end