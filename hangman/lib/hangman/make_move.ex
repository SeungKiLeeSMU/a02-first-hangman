defmodule Hangman.MakeMove do

  def make_move(game, guess) do
    new_state = update_game_state(game, guess)
    { new_state, Hangman.tally(new_state) }
  end

  # Utility function
  defp update_game_state(game, guess) do

    updated_game = add_to_used(game, guess)

    temp_state = Hangman.tally(game)

    IO.puts "Here #{temp_state.letters}"

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

  end

  defp handle_guess(true, _, _, _, _), do: :already_used
  defp handle_guess(_, word, word, _, _), do: :won
  defp handle_guess(false, word, letter, 1, false), do: :lost
  defp handle_guess(false, _, _, _, true), do: :good_guess
  defp handle_guess(_), do: :bad_guess

  # delegate to Utility
  defdelegate add_to_used(game, guess),        to: Hangman.Utility
  defdelegate is_good?(letters, guess),        to: Hangman.Utility
  defdelegate is_used?(used, guess),           to: Hangman.Utility
  defdelegate update_turn(turn, state),        to: Hangman.Utility
  defdelegate update_last(guess, last, state), to: Hangman.Utility
end
