defmodule Hangman.Game do

  defstruct(
    game_state:      :initializing,
    turns_left:      7,
    word_to_guess:   [],
    letters_guessed: []
  )

  # API

  def new_game() do
    word = new_word()
    %Hangman.Game{
      word_to_guess: word
    }
  end

  def tally(game) do
    %Hangman.Game{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters_guessed: game.letters_guessed
    }
  end

  # Utility Functions

  defp new_word() do
    Dictionary.random_word()
  end


end
