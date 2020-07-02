require_relative 'card'

class Deck
    CARDSYMBOLS = [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "J",
    "Q",
    "K",
    "A"]

    CARDSUITS = ["D".colorize(:red), "C".colorize(:black), "H".colorize(:red), "S".colorize(:black)]

    attr_reader :cards
    def initialize
        @cards = []
        CARDSYMBOLS.each do |symbol|
            suit = 0
            4.times do 
                @cards << Card.new(symbol, CARDSUITS[suit % 4])
                suit += 1
            end
        end
        @cards.shuffle!
    end

    def pop
        cards.pop
    end

    def print_deck
        cards.each do |card|
            print card.symbol + " of " + card.suit
            puts
        end
    end
end