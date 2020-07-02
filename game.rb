require_relative 'deck'
require_relative 'hand'
require_relative 'player'

class Game
    
    attr_accessor :pot, :to_call, :deck, :players
    def initialize(player_array)
        @deck = Deck.new
        @players = []
        player_array.each {|name| @players << Player.new(name, 50, self)}
        @pot = 0
        @to_call = 0
    end

    def play
        until players.length == 1
            self.pot = 0
            self.to_call = 0
            players.each do |player|
                player.already_held = []
                player.folded = false
                player.bet_so_far = 0
            end
            players.each {|player| player.hand = Hand.new(deck, player.already_held)}
            standings
            play_round
            @players.rotate!
            @players.each do |player|
                puts player.name + " is out of the game!" if player.chips == 0
            end
            @players.reject! {|player| player.chips == 0}
            self.deck = Deck.new
        end
        puts "You win, " + @players[0].name
    end

    def standings
        players.each do |player|
            puts player.name + " has " + player.chips.to_s
        end
    end

    def play_round
        betting_round(players)
        still_in = players.select {|player| !player.folded}
        if still_in.length == 1
            still_in[0].chips += self.pot
            puts still_in[0].name + " wins the hand!"
        else
            switch_cards(still_in)
            self.to_call = 0
            players.each {|player| player.bet_so_far = 0}               
            betting_round(still_in)
            staying = still_in.select {|player| !player.folded}
            if staying.length == 1
                staying[0].chips += self.pot
                puts staying[0].name + " wins the hand!"
            else
                showdown(staying)
            end
        end
    end

    def betting_round(players)     
        bets = []
        after_first_round = false
        loop do
            players.each do |player|
                break if after_first_round && players.all? {|player| player.bet_so_far == self.to_call || player.folded == true}
                still_in = players.select {|player| player.folded == false}
                break if still_in.length == 1                
                if player.folded == false
                    bet = player.get_bet
                    bets << bet
                    self.to_call = bet if bet > self.to_call
                end
            end
            after_first_round = true
            still_in = players.select {|player| player.folded == false}
            break if still_in.length == 1
            break if after_first_round && players.all? {|player| player.bet_so_far == self.to_call || player.folded == true}
        end
        self.pot += bets.sum
    end

    def switch_cards(players)
        players.each do |player|
            player.get_swap
        end
    end

    def showdown(players)
        players.each do |player|
            puts player.name
            player.hand.render
            puts player.hand.hand_type
        end
        highest_hand = 0
        players.each do |player|
            highest_hand = player.hand.hand_value if player.hand.hand_value > highest_hand
        end
        winners = players.select {|player| player.hand.hand_value >= highest_hand}
        if winners.length == 1
            winners[0].chips += self.pot
            puts winners[0].name + " wins the hand!"
        elsif winners.length == 2
            result = winners[0].hand.leading_card_value <=> winners[1].hand.leading_card_value
            if result == -1
                winners[1].chips += self.pot
                puts winners[1].name + " wins the hand!"
            elsif result == 1              
                winners[0].chips += self.pot
                puts winners[0].name + " wins the hand!"
            else
                winners[0].chips += self.pot / 2
                winners[1].chips += self.pot / 2
                puts "Split Pot"
            end
        else
            winners.each {|winner| winner.chips += self.pot / winners.length}
            puts "Split Pot, not fair but implementation incomplete"
        end
    end

end
a = Game.new(["tom","dick","harry"])
a.play