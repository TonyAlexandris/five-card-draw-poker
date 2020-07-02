require_relative 'hand'
require 'byebug'
class Player

    attr_reader :name, :game
    attr_accessor :chips, :folded, :hand, :already_held, :bet_so_far
    def initialize(name, chips, game)
        @name = name
        @chips = chips
        @already_held = []
        @folded = false
        @game = game
        @hand = nil
        @bet_so_far = 0
    end

    def get_bet
        begin
        amount_to_call = game.to_call - self.bet_so_far
        puts self.name + "'s turn"
        self.hand.render
        puts "To call is " + amount_to_call.to_s
        puts "You have " + self.chips.to_s
        puts "Enter a number to bet, or 0 to check/fold, " + self.name
        entry = gets.chomp
        nums = "0123456789"
        raise InvalidBet if entry.split("").any? {|char| !nums.include?(char)}
        bet = entry.to_i
        raise InvalidBet if game.players.any? {|player| bet > (player.chips + amount_to_call)}
        raise InvalidBet if bet != 0 && bet < amount_to_call
        if bet > amount_to_call
            raise InvalidBet if bet < (amount_to_call * 2)
        end
        rescue InvalidBet => e
            puts e.message
            retry
        end
        if bet == 0
            self.folded = true if game.to_call != 0
            return bet
        elsif bet >= (amount_to_call)
            self.chips -= bet
            self.bet_so_far += bet
            return bet
        end
    end

    def get_swap
        begin
        puts self.name + "'s turn"
        self.hand.render
        puts "Enter indices of cards to swap, up to 3.  Example: 023 swaps first, third, fourth, or stay to stay"
        entry = gets.chomp
        if entry != "stay"
            nums = "01234"
            if entry.length > 3 || entry.split("").any? {|num| !nums.include?(num)}
                raise InvalidSwap
            else
                swaps = entry.split("").map {|index| index.to_i}
                new_hand = []
                self.hand.held.each_with_index do |card, i|
                    new_hand << self.hand.held[i] if !swaps.include?(i)
                end
                self.hand = Hand.new(self.game.deck, new_hand)
            end
        end
        self.hand.render
        rescue InvalidSwap => e
            puts e.message
            retry
        end
    end

end

class InvalidBet < StandardError
    def message
        "Invalid bet. Hint: You can't raise with less than double."
    end
end


class InvalidSwap < StandardError
    def message
        "You can only swap up to 3 cards, or stay"
    end
end