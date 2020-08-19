# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

require "./about_dice_project"
require "./about_scoring_project"

class Game
  def initialize(player_number = 2, final_score = 2000)
    @players = Array.new(player_number){Player.new}
    @current_player = @players.first
    @final_score = final_score
  end

  def run_game
    until @players.select { |player| player.has_finish_the_game?(@final_score) }.any?
      @current_player.play(@players.index(@current_player) +1)
      @current_player = @players[(@players.index(@current_player) + 1) % @players.size] 
    end
  end
end

class Player
  attr_accessor :player_score

  def initialize
    @player_score = 0
    @dice_set = DiceSet.new # to refactor
  end

  def dices
    @dice_set.values
  end

  def in_the_game?
    @player_score >= 300
  end

  def play(player_number)
    puts "Turn of player #{player_number}"
    turn_score = play_turn
    if in_the_game? or turn_score >= 300
      @player_score += turn_score
      puts "You scored #{turn_score} - Total score #{@player_score}"
    end
  end

  def play_turn
    number_of_dice_to_play = 5
    turn_score = 0
    stop_turn = false
    until number_of_dice_to_play.zero? || stop_turn 
      @dice_set.roll(number_of_dice_to_play)
      puts @dice_set
      scored =  score(@dice_set.values)
      if scored.zero?
        puts "Scored 0! End of turn"
        stop_turn = true
        turn_score = 0
      else
        puts "Scored #{scored}"
        turn_score += scored
        remaining_dices = number_of_remaining_dices(dices)
        if remaining_dices.zero? 
          number_of_dice_to_play = 5
          puts "Well done! All your dices gave points! Play again!"
        else
          puts "Want to play #{number_of_remaining_dices(dices)} dices again ?[y/n]"
          input = gets
          stop_turn = input.strip.downcase.eql?("n")
          number_of_dice_to_play = remaining_dices
        end
      end
    end
    return turn_score
  end

  def has_finish_the_game?(final_score)
    @player_score >= final_score    
  end
  
end

g = Game.new
g.run_game