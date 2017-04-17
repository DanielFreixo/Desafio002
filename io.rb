require_relative 'ui.rb'

module EntradaSaida

class IO  
  def initialize(pboDebug)
    @debug = pboDebug
  end
      
  def entre_com_uma_opcao(pinMin, pinMax)
    begin
      #Limita a escolha do usuário a um inteiro nos valores definidos entre Min e Max onde Min<=Max;
      escolha = 0
      entrada_do_usuario = gets.chomp
      puts "Escolheu:" + entrada_do_usuario.to_s
      begin
       escolha = Integer(entrada_do_usuario)
       if !(escolha >= pinMin && escolha <= pinMax)
          puts "Opção fora dos limites permitidos: #{pinMin} à #{pinMax}!"
          escolha = nil
       end
      rescue ArgumentError, TypeError
       puts "Escolha uma opção válida!"
       escolha = nil
      end
    end until escolha != nil
    return escolha
  end
  
  def getGameType
    #Permite ao usuário escolher o tipo de jogo ou sair
    puts "Escolha Tipo de Jogo:\n  0 - Humano vs CPU\n  1 - CPU vs CPU\n  2 - Humano vs Humano\n  3 - Sair\n"  
    puts "Enter [0-3]:"
    escolha = nil    
    escolha = entre_com_uma_opcao(0,3)
    if (escolha > 2)
      puts "Obrigado volte sempre!"
      exit
    end
    return escolha
  end
  
  def GetGameLevel
    #Permite que o usuário escolha o nível de dificuldade da partida ao enfrentar o computador(CPU)
    puts "Escolha Nivel do Jogo:\n  0-Fácil\n  1-Médio\n  2-Dificil\n"  
    puts "Enter [0-2]:"
    escolha = entre_com_uma_opcao(0,2)    
    if (escolha >= 0 && escolha < 3)
      return escolha
    end
    return 2
  end  

public
  def write(pstString)
    #Método genérico para saída de informações para o usuário.
    puts pstString 
  end  
end

end
