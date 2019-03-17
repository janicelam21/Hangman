
class Human
    def initialize
      @@human_letter = ''
    end

    def input
      puts "Please select a letter (or type 'save' to save your game)"
      @@human_letter = gets.chomp.downcase
    end

end


class Computer < Human 
    def initialize
        @error_left = ''
        @error = 0
        @secret_word = ''
        @@word_array = ''
        @@bad_letters = []

    end

    def pick_random_word
        arr = []
        File.read("5desk.txt").split(' ') do |word|
            arr << word if word.length >= 5 && word.length <=12
        end
        #puts arr
        @secret_word = arr.sample.downcase.split('')
    end

    def display_word_blank
        @@word_array = Array.new(@secret_word.length, '_')
        print @@word_array.join('')
        puts "\n"
    end

    def display_correct
        repl_secret_word = @secret_word.dup
        repl_secret_word.count(@@human_letter).times do #only run loop as many times as letter appears in the secret word
          letter_index = repl_secret_word.index(@@human_letter)  
          @@word_array[letter_index] = @@human_letter
          repl_secret_word[letter_index] = "_"
        end
        print @@word_array.join('')
        puts "\n"
    end
        
    def display_incorrect
        @error +=1
        @error_left = 6 - @error
        puts "Wrong letter! You have #{@error_left} mistakes left!"
        print @@word_array.join('')
    end

    def game_over_lose
        if @error == 6
          true
        else
          false
        end
    end

    def game_over_win
        if @secret_word.join('') == @@word_array.join('')
            true
        else
            false
        end
    end

    def display_incorrect_letters
       @@bad_letters << @@human_letter
    end
end




class PlayGame
    require "yaml"

    def initialize
        @human = Human.new
        @computer = Computer.new
        @computer_word = ''
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
        File.open("saves/saved.yaml","w") do |file|
            file.puts(@computer_word, @computer.display_correct, @computer.display_incorrect_letters, @computer.display_incorrect)
        end
        puts "-----|Game Saved!|-----"
    end

    def load_game
        if File.exists?("saves/saved.yaml")
            saved_game = File.readlines("saves/saved.yaml").map(&:chomp)
            
            #puts "|Loading saved game...|"
            #saved_game.play
        else 
            puts "No saved game exists"
            start_game
        end
    end

    def quit_game
        puts "Thanks for playing! Have a nice day!!"
    end

    def gen_word
        @computer_word = @computer.pick_random_word
        @computer.display_word_blank
        #print @computer_word.join('')
        puts "\n"
        play
    end

    def play
        while true 
        letter = @human.input
        if @computer_word.include?(letter)
          @computer.display_correct
          puts "\n"
        elsif letter == "save"
          save_game
          break
        else
          @computer.display_incorrect
          puts "\n"
          incorr_letters = @computer.display_incorrect_letters
          puts "\n"
        end
        puts "Guessed Wrong letters: #{incorr_letters}"
        puts "\n"

        if @computer.game_over_lose
            puts "Game Over! The secret word was #{@computer_word.join('')}"
            break
        end
        if @computer.game_over_win
            puts "Game Over! You win!"
            break
        end
      end
    end

end

playgame = PlayGame.new
puts playgame.start_game

