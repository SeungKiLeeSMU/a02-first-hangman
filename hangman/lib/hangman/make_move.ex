defmodule Hangman.MakeMove do

  # return the updated game and tally of the updated game
  @spec make_move( struct(), binary() ) :: { map(), map() }
  def make_move(game, guess) do
    updated_game = handle_guess(game, guess)

    { updated_game, updated_game |> Hangman.tally() }
  end

  # return the state of current game
  @spec handle_guess( struct(), binary() ) :: map()
  defp handle_guess(game, guess) do
    guess = String.downcase(guess)

    curr_state = game
    |> update_state(guess, is_valid?(guess) )

    %Hangman.Game{ game |
                   game_state: curr_state,
                   turns_left: update_turn(game.turns_left, curr_state),
                   used:       update_used(game, guess, curr_state),
                   last_guess: update_last(game.last_guess, guess, curr_state)
                 }
  end

  defp is_valid?(guess) do
    String.match?(guess, ~r/^[a-z]$/)
  end

  @spec update_state( struct(), binary() , boolean() ) :: atom()
  # Raise Error if input is not valid.
  defp update_state(_game, _guess, false) do
    raise ArgumentError,
    message: "Invalid Letter. Please choose an alphabet."
  end

  # Retrieve game_state atom
  defp update_state(game, guess, true) do
    next_state = %Hangman.Game{ game |
                                used: [guess | game.used]
                                |> Enum.sort()
                              }

    get_state( is_used?(game.used, guess),
               game.letters,
               Hangman.tally(next_state).letters,
               game.turns_left,
               is_good?(game.letters, guess)
             )
  end


  # Utility Functions

  ############################################################################
  # DUPLICATE CHECK
  # (1) used == true                                          -> :already_used
  # GAME OVER CHECK
  # (2) not used & game.letters == tally.letters              -> :won
  # (3) if the game != tally & turns_left == 1                -> :lost
  # GOOD GUESS CHECK
  # (4) Not already used, game not over, and guess in letters -> :good_guess
  # (5) if it's not a good, it is                             -> :bad_guess
  #############################################################################

  @spec get_state( boolean(), [binary()], [binary()], 1..7, boolean() ) :: atom()
  defp get_state(true, _   , _   , _, _   ),     do: :already_used
  defp get_state(_   , word, word, _, _   ),     do: :won
  defp get_state(_   , _   , _   , 1, _   ),     do: :lost
  defp get_state(_   , _   , _   , _, true),     do: :good_guess
  defp get_state(_   , _   , _   , _, _   ),     do: :bad_guess

  # Booleans to check for :good_guess and
  @spec is_good?( [binary()], binary() ) :: boolean()
  defp is_good?(letters, guess),                 do: guess in letters
  defp is_used?(used, guess),                    do: guess in used

  # add the guess to used if the game_state != :already_used
  @spec update_used( struct(), binary(), atom() ) :: [binary()]
  defp update_used(game, _, :already_used),      do: game.used
  defp update_used(game, guess, _),              do: %Hangman.Game{ game |
                                                      used: [guess | game.used]
                                                      |> Enum.sort() }.used

  # decrement the turns iff :lost or it is :bad_guess
  @spec update_turn( 1..7, atom() ) :: 0..7
  defp update_turn(turn, :lost),                 do: turn - 1
  defp update_turn(turn, :bad_guess),            do: turn - 1
  defp update_turn(turn, _),                     do: turn

  # change last_guess to input iff game_state is not :already_used
  @spec update_last( binary(), binary(), atom() ) :: binary()
  defp update_last(last, _guess, :already_used), do: last
  defp update_last(_last, guess, _),             do: guess

end
