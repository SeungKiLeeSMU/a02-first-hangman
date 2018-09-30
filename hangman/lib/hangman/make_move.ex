defmodule Hangman.MakeMove do

  def make_move(game, guess) do
    new_state = handle_guess(game, guess)

    { new_state, Hangman.tally(new_state) }
  end

  defp handle_guess(game, guess) do

    # I need the new state to do the rest of operations. Dedicate a funciton for retrieving state
    curr_state = game
    |> update_state(guess)

    IO.puts curr_state

    %Hangman.Game{
      game |
      game_state: curr_state,
      # Only - if :bad_guess -> need state
      turns_left: update_turn(game.turns_left, curr_state),
      # Don't add if :already
      used: update_used(game, guess, curr_state),
      # Don't update if :already
      last_guess: update_last(game.last_guess, guess, curr_state)
    }
  end

  defp update_state(game, guess) do
    temp_game = %Hangman.Game{
      game |
      used: [guess | game.used]
      |> Enum.sort()
    }
    # IO.puts "is_used: #{is_used?(game.used, guess)}"
    # IO.puts "letters: #{game.letters}"
    # IO.puts "tally: #{Hangman.tally(game).letters}"
    # IO.puts "is_good: #{is_good?(game.letters, guess)}"

    get_state(
      is_used?(game.used, guess),
      game.letters,
      Hangman.tally(temp_game).letters,
      game.turns_left,
      is_good?(game.letters, guess)
    )
  end

  defp get_state(true, _, _, _, _),        do: :already_used
  defp get_state(false, word, word, _, _), do: :won
  defp get_state(false, _, _, 1, _),       do: :lost
  defp get_state(false, _, _, _, true),    do: :good_guess
  defp get_state(_, _, _, _, _),           do: :bad_guess

  defp update_used(game, guess, :already_used) do
    game.used
  end

  defp update_used(game, guess, _) do
    %Hangman.Game{
      game |
      used: [guess | game.used]
      |> Enum.sort()
    }.used
  end

  defp add_to_used(game, guess) do
    %Hangman.Game{
      game |
      used: [guess | game.used]
      |> Enum.sort()
      # |> Enum.uniq()
    }
  end

  defp is_good?(letters, guess),                 do: guess in letters
  defp is_used?(used, guess),                    do: guess in used

  defp update_turn(turn, :lost),                    do: turn - 1
  defp update_turn(turn, :bad_guess),            do: turn - 1
  defp update_turn(turn, _),                     do: turn

  defp update_last(last, _guess, :already_used), do: last
  defp update_last(_last, guess, _),             do: guess

  # delegate to Utility
  # defdelegate add_to_used(game, guess),        to: Hangman.Utility
  # defdelegate is_good?(letters, guess),        to: Hangman.Utility
  # defdelegate is_used?(used, guess),           to: Hangman.Utility
  # defdelegate update_turn(turn, state),        to: Hangman.Utility
  # defdelegate update_last(guess, last, state), to: Hangman.Utility
end

'''
updated_game = add_to_used(game, guess)

curr_game = handle_guess(
  is_used?(game.used, guess),
  game.letters,
  temp_state.letters,
  game.turns_left,
  is_good?(game.letters, guess)
)

%Hangman.Game{
  game |
  game_state: curr_game,
  turns_left: update_turn(game.turns_left, curr_game),
  # letters:    Hangman.tally(game).letters,
  last_guess: update_last(guess, game.last_guess, curr_game)
}
'''
