require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @attempt = params[:word].upcase
    @letters = params[:letters]
    @decision = grid_test?(@attempt, @letters) & dict_test?(@attempt)
    if !grid_test?(@attempt, @letters)
      @message = "Sorry but #{@attempt} can't be built out of #{@letters}"
    elsif !dict_test?(@attempt)
      @message = "Sorry but #{@attempt} doesn't seem to be a valid Englsih word"
    else
      @message = "Congratulations! #{@attempt} is a valid English word!"
    end
  end

  private

  def grid_test?(word, grid)
    word_array = word.upcase.split("")
    grid = grid.split("")
    decision = true
    word_array.each do |letter|
      decision = false unless grid.include?(letter)
      grid.delete_at(grid.index(letter)) if grid.include?(letter)
    end
    decision
  end

  def dict_test?(word)
    decision = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word.downcase}").read)
    decision["found"]
  end
end
