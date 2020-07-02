
require_relative 'deck'

class Hand
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

    HANDS = {
    "StraightFlush" => 9,
    "Quads" => 8,
    "FullHouse" => 7,
    "Flush" => 6,
    "Straight" => 5,
    "Triple" => 4,
    "TwoPair" => 3,
    "Pair" => 2,
    "HighCard" => 1,
    }
    
    attr_reader :held, :tracker
    attr_accessor :hand_type, :hand_value, :leading_card_value
    def initialize(deck, already_held)
        until already_held.length == 5
            already_held << deck.pop
        end
        @held = sort_hand(already_held)
        @hand_type = "HighCard"
        @leading_card_value = @held[4].value
        @tracker = self.track
        pairs
        triple
        straight
        flush
        fullhouse
        quads
        straightflush
        @hand_value = HANDS[@hand_type]
    end

    def render
        held.each {|card| print card.symbol + " of " + card.suit + "       "}
        puts
    end

    def sort_hand(hand)
        return hand if hand.length <= 1
        pivot = [hand[0]]
        left = hand[1..-1].select {|card| card.value <= hand[0].value}
        right = hand[1..-1].select {|card| card.value > hand[0].value}
        sort_hand(left).concat(pivot).concat(sort_hand(right))
    end

    def track
        tracker = Hash.new(0)
        held.each {|card| tracker[card.symbol] += 1}
        tracker
    end

    def pairs
        pairs_seen = 0
        tracker.keys.each do |symbol|
            if tracker[symbol] == 2 && pairs_seen == 0
                self.hand_type = "Pair"
                self.leading_card_value = VALUES[symbol]
                pairs_seen += 1
            elsif tracker[symbol] == 2 && pairs_seen == 1
                self.hand_type = "TwoPair"
                self.leading_card_value = VALUES[symbol] if VALUES[symbol] > leading_card_value
            end
        end
    end

    def triple
        if tracker.has_value?(3)
            self.hand_type = "Triple"
            self.leading_card_value = VALUES[tracker.key(3)]
        end
    end

    def straight
        count = 0
        held.each_with_index do |card, i|
            if i > 0
                count += 1 if card.value == (held[i - 1].value + 1)
            end
        end
        if count == 4
            self.hand_type = "Straight"
            self.leading_card_value = held[4].value
            return true
        end
        false
    end

    def flush
        count = 0
        held.each_with_index do |card, i|
            if i > 0
                count += 1 if card.suit == (held[i - 1].suit)
            end
        end
        if count == 4
            self.hand_type = "Flush"
            self.leading_card_value = held[4].value
            return true
        end
        false       
    end

    def fullhouse
        if tracker.values == [3, 2] || tracker.values == [2, 3]
            self.hand_type = "FullHouse"
            self.leading_card_value = VALUES[tracker.key(3)]
        end
    end

    def quads
        if tracker.has_value?(4)
            self.hand_type = "Quads"
            self.leading_card_value = VALUES[tracker.key(4)]
        end
    end

    def straightflush
        a = straight
        b = flush
        if a && b
            self.hand_type = "StraightFlush"
            self.leading_card_value = held[4].value
        end
    end

end

#q = nil
#count = 0
#until q == "FullHouse"
#    a = Deck.new
#    b = Hand.new(a)
#    b.render
#    q = b.hand_type
#    print b.hand_type
#    puts
#    print b.leading_card_value
#    puts
#    count += 1
#    puts count
#end