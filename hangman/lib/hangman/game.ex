defmodule Hangman.Game do

  # Game Struct
  defstruct game_state: :initializing,
            turns_left: 7,
            letters:    [],
            used:       [],
            last_guess: ""

  # Initialize New Game
  @spec new_game(binary()) :: map()
  def new_game(word \\ Dictionary.random_word()) do
    new_word = word |> String.codepoints()

    %Hangman.Game{ letters: new_word }
  end

end
