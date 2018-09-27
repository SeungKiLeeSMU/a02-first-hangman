defmodule Hangman.Game do

  defstruct(
    game_state: :initializing,
    turns_left: 7,
    word_to_guess: [],
    letters_guessed: []
  )

  def new_game() do
    word = Dictionary.random_word()
    %Hangman.Game{
      word_to_guess: word
    }
  end

end
