defmodule Hangman.Utility do

  defp add_to_used(game, guess) do
    %Hangman.Game{
      game |
      used: [guess | game.used]
      |> Enum.sort()
      |> Enum.uniq()
    }
  end

  defp is_good?(letters, guess), do: guess in letters
  defp is_used?(used, guess),    do: guess in used

  defp update_turn(turn, :bad_guess), do: turn-1
  defp update_turn(turn, _),          do: turn

  defp update_last(guess, last, :already_used), do: last
  defp update_last(guess, last, _), do: guess

end
