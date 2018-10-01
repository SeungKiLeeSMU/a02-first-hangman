defmodule Hangman.Game do

  # Game Struct
  defstruct game_state: :initializing,
            turns_left: 7,
            letters:    [],
            used:       [],
            last_guess: ""

  # Initialize New Game
  @spec new_game() :: map()
  def new_game() do
    new_word = new_word()

    %Hangman.Game{ letters: new_word }
  end

  # Utility Funciton - a random word converted to a list
  @spec new_word() :: [binary()]
  defp new_word() do
    Dictionary.random_word()
    |> String.codepoints()
  end

end
