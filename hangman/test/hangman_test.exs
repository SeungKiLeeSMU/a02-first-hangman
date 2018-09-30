defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "New Game Game State" do
    new_game = Hangman.new_game()
    assert new_game.game_state == :initializing
  end

  test "New Game Turns Left" do
    new_game = Hangman.new_game()
    assert new_game.turns_left == 7
  end

  test "New Game Word to Guess Exists" do
    new_game = Hangman.new_game()
    assert new_game.letters |> length() > 0
  end

  test "New Game Letters Guessed is Empty" do
    new_game = Hangman.new_game()
    assert new_game.used == []
  end

  test "Tally Updated Correctly" do
    current_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 6,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c"] |> Enum.sort(),
      last_guess: "c"
    }

    return_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 6,
      letters:    ["b", "a", "_", "_", "_", "_"],
      used:       ["a", "b", "c"]
    }

    assert Hangman.tally(current_state) == return_state
  end

  test "Guess updates used" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k"] |> Enum.sort(),
      last_guess: "k"
    }

    return_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m"] |> Enum.sort(),
      last_guess: "m"
    }

    {cmp_state, cmp_tally} = Hangman.make_move(curr_state, "m")
    assert {cmp_state, cmp_tally} == {return_state, Hangman.tally(return_state)}
  end


end
