defmodule Hangman.MakeMove do

  def make_move(game, guess) do
    new_state = handle_guess(game, guess)

    { new_state, Hangman.tally(new_state) }
  end

  defp handle_guess(game, guess) do

    curr_state = game
    |> update_state(guess)

    %Hangman.Game{
      game |
      game_state: curr_state,
      turns_left: update_turn(game.turns_left, curr_state),
      used:       update_used(game, guess, curr_state),
      last_guess: update_last(game.last_guess, guess, curr_state)
    }
  end

  defp update_state(game, guess) do
    next_state = %Hangman.Game{
      game |
      used: [guess | game.used]
      |> Enum.sort()
    }

    get_state(
      is_used?(game.used, guess),
      game.letters,
      Hangman.tally(next_state).letters,
      game.turns_left,
      is_good?(game.letters, guess)
    )
  end


  # Utility Function

  defp get_state(true, _, _, _, _),              do: :already_used
  defp get_state(false, word, word, _, _),       do: :won
  defp get_state(false, _, _, 1, _),             do: :lost
  defp get_state(false, _, _, _, true),          do: :good_guess
  defp get_state(_, _, _, _, _),                 do: :bad_guess

  defp is_good?(letters, guess),                 do: guess in letters
  defp is_used?(used, guess),                    do: guess in used

  defp update_used(game, _guess, :already_used), do: game.used

  defp update_used(game, guess, _),              do: %Hangman.Game{
                                                        game |
                                                        used: [guess | game.used]
                                                        |> Enum.sort()
                                                      }.used


  defp update_turn(turn, :lost),                 do: turn - 1
  defp update_turn(turn, :bad_guess),            do: turn - 1
  defp update_turn(turn, _),                     do: turn

  defp update_last(last, _guess, :already_used), do: last
  defp update_last(_last, guess, _),             do: guess


end
