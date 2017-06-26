require 'sinatra'
require 'sinatra/reloader'

set :secret_number, rand(101)

def check_guess(guess)
  if guess - settings.secret_number > 5
    "Way too high!"
  elsif guess > settings.secret_number
    "Too high!"
  elsif guess - settings.secret_number < -5
    "Way too low."
  elsif guess < settings.secret_number
    "Too low."
  elsif guess == settings.secret_number
    "You guessed it!"
  else
    "That's not a number!"
  end
end

get '/' do
  guess = params['guess'].to_i
  message = check_guess(guess)
  erb :index, locals: { number: settings.secret_number, guess: guess, message: message
  }
end

