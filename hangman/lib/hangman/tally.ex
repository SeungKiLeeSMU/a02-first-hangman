defmodule Hangman.Tally do

  def tally( game = %Hangman.Game{ game_state: :won } ) do
    # %Hangman.Game{
    #   game |
    #   letters: game.letters
    #   |> Enum.join()
    # }
    game
  end

  def tally( game = %Hangman.Game{ game_state: :lost} ), do: game

  def tally(game) do
    displayed = show_letter(game.letters, game.used)

    %Hangman.Game{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    displayed,
      used:       game.used |> Enum.sort()
    }
  end

  # Utility Function
  defp show_letter(letters, used) do
    letters
    |> Enum.map( &display &1, &1 in used )
  end

  defp display(letter, true),     do: letter
  defp display(_, false),         do: "_"

end
