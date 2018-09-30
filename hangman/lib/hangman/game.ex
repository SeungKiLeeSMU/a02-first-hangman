defmodule Hangman.Game do

  defstruct game_state: :initializing,
            turns_left: 7,
            letters:    [],
            used:       [],
            last_guess: ""

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

  def make_move(game, guess) do
    new_state = update_game_state(game, guess)
    { new_state, Hangman.tally(new_state) }
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



  '''
  handle_guess(
    guess in used: bool,
    letter,
    tally(game).letter,

  )
  '''


  # already used
  # need guess, used
  defp handle_guess(true, _, _,) do
    :already_used
  end

  # # won
  # # need letters, tally(game).letters -> current
  # defp handle_guess(word == tally(game).letters) do
  #   :won
  # end

  # # lost
  # # need turns, prev_game, curr_game
  # defp handle_guess(turns == 1, tally(prev_game).letters != tally(game).letters) do
  #   :lost
  # end

  # # good
  # # need guess, letters
  # defp handle_guess(guess in word) do
  #   :good_guess
  # end

  # # bad
  # defp handle_guess(_) do
  #   :bad_guess
  # end

  # MAKE MOVE UTIL
  defp update_game_state(game, guess) do
    


    # update(already used)
    #   -> if guess in used
    #   -> :already

    # update(won)
    #   -> word == tally(game)
    #   -> :won

    # update(lost)
    #   -> turn == 1
    #   -> tally(now) == tally(next)
    #   -> :lost

    # update(good)
    #   -> if in word
    #   -> add to word
    #   -> :good

    # update(bad)
    #   -> else
    #   -> :bad

    # curr_game = eval_guess(
    #   game.letters,
    #   tally(game).letters,
    #   game.turns_left,
    #   is_used?(game.used, guess),
    #   is_good?(game.letters, guess)
    # )
    # curr_turn    = update_turn(game.turns_left, curr_game)
    # curr_display = update_letters(game, guess, curr_game)
    # curr_used    = add_to_used(game, guess)

    %Hangman.Game{
      game |
      # game_state: curr_game,
      # turns_left: curr_turn,
      # letters:    curr_display,
      used:       [guess | game.used] |> Enum.sort(),
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
    %Hangman.Game{
      game | used: [guess | game.used] |> Enum.sort()
    }
  end

  # last_guess
  defp update_last_guess(game, guess) do
    %Hangman.Game{
      game | last_guess: guess
    }
  end
end
