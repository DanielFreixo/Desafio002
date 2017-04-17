require_relative 'io.rb'

module Tabuleiro
  include EntradaSaida

class Board  
  def initialize(pboDebug, pinTipoJogo, pinNivelDificuldade)
    @debug = pboDebug #permite exibir mensagens para o desenvolvedor quando ativado
    @slots = ["0", "1", "2", "3", "4", "5", "6", "7", "8"] #posições disponíveis no tabuleiro
    @hum = "O" # the user's marker / Player 1 #marcação do jogador 1
    @com = "X" # the computer's marker / Player 2 #marcação do jogador 2
    @Jogo_Tipo = ['Humano vs CPU', 'CPU vs CPU', 'Humano vs Humano'] #Tipos disponiveis de jogos
    @Jogo_Level = ['Fácil', 'Médio', 'Dificil'] #Nível de dificuldades da jogo/partida
    @tipo_jogo = pinTipoJogo #Indice escolhido pelo usuário
    @nivel_dificuldade = pinNivelDificuldade #Nível de dificuldade escolhida pelo usuário para jogar contra o CPU
    @io = EntradaSaida::IO.new(@DEBUG) #classe para saída e entrada de informações com o usuário
    @vencedor = 0 #Quem venceu a partida!!! 0-velha 1-jogador1 2-jogador2
  end
  
  def Jogador1
    #marcação do jogador 1
    return @hum 
  end
  
  def Jogador2
    #marcação do jogador 2
    return @com
  end
  
  def Vencedor
    #Identificador do vencedor
    return @vencedor
  end
  
  def reset_slots
    #Limpa posições do tabuleiro e vencedor
    @slots = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @vencedor = 0
  end
    
  def to_s
    #retorna o tabuleiro atual
    " #{@slots[0]} | #{@slots[1]} | #{@slots[2]} \n===+===+===\n #{@slots[3]} | #{@slots[4]} | #{@slots[5]} \n===+===+===\n #{@slots[6]} | #{@slots[7]} | #{@slots[8]} \n"
  end
  
  def print_slots
    #exibe para o usuário o tabuleiro atual
    @io.write to_s
  end
  
  def print_board_before_turn(jogador, pstMarca)
    #Exibe tabuleiro para o próximo Jogador
    @io.write "\n\nÉ a vez do Player #{jogador} '#{pstMarca}'"
    print_slots
    if (@tipo_jogo != 1) 
      #Só exibe solicitação de entrada caso o jogador seja humano!
      @io.write "Enter [0-8]:"
    end
  end
  
  def get_human_spot(pstMarca)
    spot = nil
    until spot
      #spot = gets.chomp.to_i
      spot = @io.entre_com_uma_opcao(0,8) 
      if (@slots[spot] != "X" && @slots[spot] != "O")
        @slots[spot] = pstMarca
      else
        @io.write "Este Local já foi escolhido anteriormente!"
        spot = nil
      end
    end
  end

  def getNetPlayer(pstMarca)
    #Pega a marcação oposta do jogador atual
    if (pstMarca == "O")
      return "X"
    else
      return "O"
    end    
  end
  
  def eval_board(pstMarca)
    spot = nil
    until spot
      if (@slots[4] == "4" && @nivel_dificuldade == 2) #facilitando dependendo do nivel de dificuldade     
        spot = 4
        @slots[spot] = pstMarca
      else
        spot = get_best_move(@slots, pstMarca, getNetPlayer(pstMarca))
        if (@slots[spot] != "X" && @slots[spot] != "O")
          @slots[spot] = pstMarca
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(slots, pstMarca, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    slots.each do |s|
      if (s != "X" && s != "O")
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      slots[as.to_i] = pstMarca
      if (game_is_over())
        best_move = as.to_i
        slots[as.to_i] = as
      else
        slots[as.to_i] = next_player
        if (game_is_over())
          best_move = as.to_i
          slots[as.to_i] = as
        else
          slots[as.to_i] = as
        end
      end
    end
    if best_move
      if (@nivel_dificuldade == 0) #Fácil!
        #Se nivel fácil retorne um valor aleatório disponível no tabuleiro
        n = rand(0..available_spaces.count)
        return available_spaces[n].to_i
      else
        #caso haja um movimento bom verifica se utilizará de sorte 
        if (@nivel_dificuldade == 1) #Medio!
          @io.write "Testando sua sorte" if @debug
          if (rand(0..100) > 50) #50% de receber um movimento fácil aleatório
            @io.write "SORTE!" if @debug
            #Sortiará uma posição qualquer
            n = rand(0..available_spaces.count)
            return available_spaces[n].to_i
          else
            #escolherá a melhor posição
            @io.write "Falta de sorte =(" if @debug
          end
        end
      end
      return best_move
    else
      #posição aleatória qualquer!
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

public
  def game_is_over()
    #verificando se o tabuleiro apresenta as marcações do vitoriozo
    b = @slots.clone
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie()
    #verificar se todos os slots estão marcados e que não há nenhum ganhador
    b = @slots.clone
    b.all? { |s| s == "X" || s == "O" } && !game_is_over()
  end
  
  def start_the_game
    reset_slots
    # start by printing the board
    print_slots
    if (@tipo_jogo != 1) #Se só estão jogando computadores não precisa 
      @io.write "Enter [0-8]:"
    end
    # loop through until the game was won or tied
    @vencedor = 0
    until game_is_over() || tie()
      @vencedor = 1
      if (@tipo_jogo != 1)
        get_human_spot(@hum)
      else
        eval_board(@hum)
      end
      if !game_is_over() && !tie()        
        if (@tipo_jogo != 2)
          if (@tipo_jogo == 1) #Se for CPUvsCPU exibe antes da jogada do 2o CPU
            print_board_before_turn(2, @com)
          end
          eval_board(@com)
        else
          print_board_before_turn(2, @com)
          get_human_spot(@com)
        end
        @vencedor = 2
      end
#     if (@tipo_jogo == 1) #Espaço entre tabuleiros caso seja CPUvsCPU
#       @io.write "\n"
#     end
      print_board_before_turn(1, @hum)
    end
    if (tie() && !game_is_over())
      @vencedor = 0
      @io.write "Game over - Deu velha!"
    else
      @io.write "Game over - Player #{@vencedor} Venceu!!" 
    end    
  end  
end

end