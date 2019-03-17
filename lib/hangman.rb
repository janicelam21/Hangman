class PlayGame
    require "yaml"

    def initialize
      @secret_word = ''
      @human_letter = ''
      @error_left = ''
      @error = 0 
      @word_array = ''
      @bad_letters = []
      @letter_already_guessed=[]
    end

    def start_game
      while true
        puts "|(n)ew game|"
        puts "|(l)oad saved game|"
        puts "|(q)uit|"
        input = gets.chomp.downcase
        if input == 'n'
          gen_word
          break
        elsif input == 'l'
          load_game
          break
        elsif input == 'q'
          quit_game
          break
        else
          "Invalid input - try again!"
        end
      end
    end

    def save_game
      Dir.mkdir("saves")unless Dir.exists?("saves")
      data = [@secret_word, @word_array, @bad_letters, @error]
      output = File.new('saves/saved.yaml','w')
      output.puts YAML.dump(data)
      output.close
      
      puts "-----|Game Saved!|-----"
    end

    def load_game
      if File.exists?("saves/saved.yaml")
        output = File.new("saves/saved.yaml",'r')
        data = YAML.load(output.read)
        @secret_word = data[0]
        @word_array = data[1]
        @bad_letters = data[2]
        @error = data[3]
        output.close
        puts "|Loading saved game...| \n\n"
        print "current stage: #{@word_array.join('')}"
        puts "\n\n"
        print "Guessed wrong letters: #{@bad_letters}"
        puts "\n\n"
        play
      else 
        puts "No saved game exists"
        start_game
      end
    end

    def quit_game
      puts "Thanks for playing! Have a nice day!!"
    end

    def input
      puts "Please select a letter (or type 'save' to save your game)"
      while true
        @human_letter = gets.chomp.downcase
        if @human_letter !~ /[a-zA-Z]/
          puts "Thats not a letter - try again"
        elsif @letter_already_guessed.include?(@human_letter)
          puts "You already guessed that! Guess again (or type 'save' to save your game) \n\n"
        else 
          @letter_already_guessed << @human_letter  
          break
        end
      end
      puts "\n"
    end

    def pick_random_word
      arr = []
      File.read("5desk.txt").split(' ') do |word|
          arr << word if word.length >= 5 && word.length <=12
      end
      @secret_word = arr.sample.downcase.split('')
    end
    
    def blank_word_array
      @word_array = Array.new(@secret_word.length, '_')
      puts @word_array.join('')
    end

    def gen_word
      pick_random_word
      blank_word_array
      puts "\n"
      play
    end


    def display_correct
      repl_secret_word = @secret_word.dup
      repl_secret_word.count(@human_letter).times do #only run loop as many times as letter appears in the secret word
        letter_index = repl_secret_word.index(@human_letter)  
        @word_array[letter_index] = @human_letter
        repl_secret_word[letter_index] = "_"
      end
      print @word_array.join('')
      puts "\n"
    end
    
    def display_incorrect
      @error +=1
      @error_left = 7 - @error
      puts "Wrong letter! You have #{@error_left} mistakes left! \n\n"
      print @word_array.join('')
      puts "\n\n"
    end

    def display_incorrect_letters
      @bad_letters << @human_letter
    end

    def game_over_lose
      if @error == 6
        true
      else
        false
      end
    end

    def game_over_win
      if @secret_word.join('') == @word_array.join('')
          true
      else
          false
      end
    end

    def play_again
      puts "Do you want to play again? y/n"
      again = gets.chomp.downcase
      if again == 'y'
        rev = PlayGame.new
        rev.start_game
      else
        quit_game
      end
    end


    def play
      while true 
        input
        puts "\n\n"
        if @secret_word.include?(@human_letter)
          display_correct
          puts "\n"
        elsif @human_letter == "save"
          save_game
          break
        else
          display_incorrect
          puts "\n"
          display_incorrect_letters
          #incorr_letters = display_incorrect_letters
          #puts "\n"
        end
        puts "Guessed Wrong letters: #{@bad_letters}"
        puts "\n\n"
    
        if game_over_lose
            puts "Game Over! The secret word was #{@secret_word.join('')}"
            play_again
            break
        end
        if game_over_win
            puts "You solved it!"
            play_again
            break
        end
      end
    end

end

playgame = PlayGame.new
puts playgame.start_game

