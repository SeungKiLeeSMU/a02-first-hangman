defmodule Hangman.Tally do

  # Winning or Losing will just return the current game state with all letters
  @spec tally( struct() ) :: struct()
  def tally( game = %Hangman.Game{ game_state: :won } ), do: game
  def tally( game = %Hangman.Game{ game_state: :lost} ), do: game

  # Display the letters with underscore if the the letter is not guessed.
  def tally(game) do
    displayed = show_letter(game.letters, game.used)

    # Return the struct with updated letter and sorted used
    %Hangman.Game{ game |
                   letters: displayed,
                   used:    game.used |> Enum.sort()
                 }
  end

  # Utility Function - check if the letter is in used
  @spec show_letter( [binary()], [binary()] ) :: [binary()]
  defp show_letter(letters, used) do
    letters
    |> Enum.map( &display &1, &1 in used )
  end

  @spec display( [binary()], boolean() ) :: binary()
  defp display(letter, true),     do: letter
  defp display(_, false),         do: "_"

end
