require_relative 'io.rb'
require_relative 'board.rb'

module Interface  
  include EntradaSaida
  include Tabuleiro
  
class UI
  attr_accessor :Jogo_Level
  attr_accessor :Jogo_Tipo
  
  def initialize(pboDebug)
    @DEBUG = pboDebug
    @board = nil
    @io = EntradaSaida::IO.new(@DEBUG)
    @Jogo_Tipo = ['Humano vs CPU', 'CPU vs CPU', 'Humano vs Humano']
    @Jogo_Level = ['Fácil', 'Médio', 'Difícil']
    #@nivel_dificuldade = 2 #'0-Fácil', '1-Médio', '2-Difícil'#
  end

  def JogarJogoDaVelha
    start_game()
  end
  
  def Jogo_Tipo(pinOpcao)
    #Tipos de jogos disponíveis
    return @Jogo_Tipo[pinOpcao].to_s
  end
  
  def Jogo_Dificuldade(pinOpcao)
    #niveis disponíveis
    return @Jogo_Level[pinOpcao].to_s
  end
  
  def start_game
    # Getting Game Type
    tipo_jogo = 0
    tipo_jogo = @io.getGameType() #pegando escolha do usuário
    @io.write "Você escolheu a opção '" + Jogo_Tipo(tipo_jogo) + "'"
    
    nivel_dificuldade = 2 #dificuldade padrão
    if (tipo_jogo == 0 || tipo_jogo == 1)
      #Caso haja algum CPU envolvido, na partida é possível escolher o nível de dificuldade!
      nivel_dificuldade = @io.GetGameLevel()
      @io.write "Você escolheu o nível '" + Jogo_Dificuldade(nivel_dificuldade) + "'"
    end
    
    # Começando
    @io.write "\n\nVamos começar:\n\n"    
    @board = Tabuleiro::Board.new(@DEBUG, tipo_jogo, nivel_dificuldade) #criando classe responsável pelo jogo
    @board.reset_slots
    @board.start_the_game()
    
    if (tipo_jogo != 1) #CPUs não precisam de adeus
      if (@board.Vencedor!=0)
        @io.write "\n\n\nPARABÉNS JOGADOR#{@board.Vencedor}!!!"
      else
        @io.write "\n\n\nBOA SORTE NA PRÓXIMA!!!"
      end
    end
  end
  
end

#game = Game.new
#game.start_game
end