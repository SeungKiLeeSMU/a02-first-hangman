defmodule Hangman.Tally do

  def tally(game) do
    displayed = show_letter(game.letters, game.used)

    %Hangman.Game{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    displayed,
      used:       Enum.sort(game.used)
    }
  end

  # Utility Functions
  defp show_letter(letters, used) do
    letters
    |> Enum.map( &display &1, &1 in used )
  end

  defp display(letter, true), do: letter
  defp display(_, false),     do: "_"

end
