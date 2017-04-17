require_relative 'ui.rb'

module Main
  include Interface

class Game
  attr_reader :ui
  
  def initialize(pboDebug)
    @debug = pboDebug
    @ui = Interface::UI.new(@debug)    
  end
  
  def start_game
    #iniciar Jogo da Velha
    @ui.JogarJogoDaVelha()
  end

end

end

game = Main::Game.new(true)
game.start_game

