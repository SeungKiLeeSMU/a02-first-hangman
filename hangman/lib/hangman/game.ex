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
    }
  end

  def make_move(%Hangman.Game{game_state: :won}, _guess) do
    "Winner Winner Chicken Dinner. You're the MAN."
    |> IO.puts
  end

  def make_move(%Hangman.Game{game_state: :lost}, _guess) do
    "You are a LOSER. Just give up."
    |> IO.puts
  end

  def make_move(game, guess) do
    update_game_state(game, guess)
  end


  # Utility Functions
  defp new_word() do
    Dictionary.random_word()
    |> String.codepoints()
  end

  defp show_letter(letters, used) do
    # String.codepoints(letters)
    letters
    |> Enum.map( &display &1, &1 in used )
  end

  defp display(letter, true), do: letter
  defp display(_, false),     do: "_"

  defp update_game_state(game, guess) do

    curr_game = eval_guess(
      game.letters,
      tally(game).letters,
      game.turns_left,
      is_used?(game.used, guess),
      is_good?(game.letters, guess)
    )
    curr_turn    = update_turn(game.turns_left, curr_game)
    curr_display = update_letters(game, guess, curr_game)
    curr_used    = add_to_used(game, guess)

    %Hangman.Game{
      game |
      game_state: curr_game,
      turns_left: curr_turn,
      letters:    curr_display,
      used:       curr_used,
      last_guess: guess
    }

  end


    # How do I update each field?
    # <game_state>
    # Specific
    #         -> lost
    #         -> won
    #         -> already used
    #         -> bad guess
    #         -> good guess
    # General

  defp is_good?(letters, guess), do: guess in letters
  defp is_used?(used, guess),    do: guess in used

  # If turns = 0, you've lost
  defp eval_guess(_, _, 0, _, _),       do: :lost
  # If your letter == game letter
  defp eval_guess(word, word, _, _, _), do: :won
  # If the guess is in used
  defp eval_guess(_, _, _, true, _),    do: :already_used
  # If the guess is in letter, good
  defp eval_guess(_, _, _, _, true),    do: :good_guess
  # else, bad
  defp eval_guess(_, _, _, _, false),   do: :bad_guess

  # <turns_left>
  # decrement by 1 if :bad_guess
  defp update_turn(turn, :bad_guess), do: turn-1
  defp update_turn(turn, _),          do: turn

  # <letters>
  # add the guess to used, and run show_letter function
  # Show letter in string if you've won
  defp update_letters(game, guess, :won) do
    new_used = guess
    |> add_to_used(game)

    new_used.used
    |> show_letter(game.letters)
    |> Enum.join()
  end

  defp update_letters(game, guess, _) do
    new_used = guess
    |> add_to_used(game)

    new_used.used
    |> show_letter(game.letters)
  end

  # <used>
  # prepend the guess to used and sort
  defp add_to_used(game, guess) do
    [guess | game.used] |> Enum.sort()
  end

end
