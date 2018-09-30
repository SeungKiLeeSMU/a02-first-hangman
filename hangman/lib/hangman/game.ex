defmodule Hangman.Game do

  # Game Struct
  defstruct game_state: :initializing,
            turns_left: 7,
            letters:    [],
            used:       [],
            last_guess: ""

  # API
  def new_game() do
    new_word = new_word()

    %Hangman.Game{
      letters: new_word
    }
  end

  # Utility Function
  defp new_word() do
    Dictionary.random_word()
    |> String.codepoints()
  end

end
