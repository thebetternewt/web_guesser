require 'sinatra'
require 'sinatra/reloader'

set :secret_number, rand(100)

@@turns_left = 5

def check_guess(guess)
  if guess.nil?
    ['Guess a number!', 'white']
  elsif guess - settings.secret_number > 5
    ['Way too high!', 'red']
  elsif guess > settings.secret_number
    ['Too high!', 'lightCoral']
  elsif guess - settings.secret_number < -5
    ['Way too low.', 'red']
  elsif guess < settings.secret_number
    ['Too low.', 'lightCoral']
  elsif guess == settings.secret_number
    @@turns_left = 5
    settings.secret_number = rand(100)
    ['You guessed it! Generating new number... Guess again!', 'green']
  else
    ["Error! Are you sure that's a number?", 'yellow']
  end
end

def out_of_turns
  message = "You're out of turns! The SECRET NUMBER was " \
            "#{settings.secret_number}. Generating new number... " \
            'Guess again!'
  background_color = 'white'
  settings.secret_number = rand(100)
  [message, background_color]
end

get '/' do
  cheat = params['cheat']

  turns_left = @@turns_left
  if @@turns_left.zero?
    message, background_color = out_of_turns
    @@turns_left = 4
  else
    guess = (params['guess'] ? params['guess'].to_i : nil)
    message, background_color = check_guess(guess)
    @@turns_left -= 1
  end
  erb :index, locals: { number: settings.secret_number,
                        turns: turns_left,
                        guess: guess,
                        message: message,
                        background_color: background_color,
                        cheat_mode: cheat }
end
