defmodule Hangman.Game do

  defstruct(
    game_state: :initializing,
    turns_left: 7,
    letters:    [],
    used:       [],
    last_guess: ""
  )

  # API

  def new_game() do
    new_word = new_word()

    %Hangman.Game{
      letters: new_word
    }
  end

  def tally(game) do
    displayed = show_letter(game.letters, game.used)

    %Hangman.Game{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    displayed,
      used:       Enum.sort(game.used)
      last_guess: game.last_guess
    }
  end

  # Check if the guess is correct
  # update the game state
  def make_move(game, guess) do

  end

  '''
  Specific
          -> won
          -> lost
          -> already used
          -> good guess
  General -> bad guess
  '''


  # Utility Functions
  defp new_word() do
    Dictionary.random_word()
  end

  defp show_letter(letters, used) do
    String.codepoints(letters)
    |> Enum.map( &display &1, &1 in used )
  end

  defp display(letter, true), do: letter
  defp display(_, false),     do: "_"

  defp add_guess_to_used(game, guess) do
    %Hangman.Game{
      game.used : Enum.sort([guess | game.used])
    }
  end

  defp set_last_guess(game, guess) do
    %Hangman.Game{
      game.last_guess : guess
    }
  end

end
