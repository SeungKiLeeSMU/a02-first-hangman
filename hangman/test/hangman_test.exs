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

  test "tally() Updated Correctly" do
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
      used:       ["a", "b", "c"],
      last_guess: "c"
    }

    assert Hangman.tally(current_state) == return_state
  end

  test "make_move() updates Tally" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k"] |> Enum.sort(),
      last_guess: "k"
    }

    return_state = %Hangman.Game{
      game_state: :good_guess,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m"] |> Enum.sort(),
      last_guess: "m"
    }

    { cmp_state, cmp_tally } = curr_state |> Hangman.make_move("m")
    assert { cmp_state, cmp_tally } == { return_state, return_state |> Hangman.tally() }
  end

  test "Check for Guessing Value that is Already Used" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k"] |> Enum.sort(),
      last_guess: "k"
    }

    return_state = %Hangman.Game{
      game_state: :already_used,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k"] |> Enum.sort(),
      last_guess: "k"
    }

    { cmp_state, cmp_tally } = curr_state |> Hangman.make_move("a")
    assert { cmp_state, cmp_tally } == { return_state, return_state |> Hangman.tally() }
  end

  test "Checks for Victory!" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l", "e"] |> Enum.sort(),
      last_guess: "e"
    }

    return_state = %Hangman.Game{
      game_state: :won,
      turns_left: 5,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l", "e", "r"] |> Enum.sort(),
      last_guess: "r"
    }

    { cmp_state, cmp_tally } = curr_state |> Hangman.make_move("r")
    assert { cmp_state, cmp_tally } == { return_state, return_state |> Hangman.tally() }
  end

  test "Checks for Defeat :(" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 1,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l", "e"] |> Enum.sort(),
      last_guess: "e"
    }

    return_state = %Hangman.Game{
      game_state: :lost,
      turns_left: 0,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l", "e", "t"] |> Enum.sort(),
      last_guess: "t"
    }

    { cmp_state, cmp_tally } = curr_state |> Hangman.make_move("t")
    assert { cmp_state, cmp_tally } == { return_state, return_state |> Hangman.tally() }
  end

  test "Checks for Good Guess" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 3,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l"] |> Enum.sort(),
      last_guess: "l"
    }

    return_state = %Hangman.Game{
      game_state: :good_guess,
      turns_left: 3,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l", "e"] |> Enum.sort(),
      last_guess: "e"
    }

    { cmp_state, cmp_tally } = curr_state |> Hangman.make_move("e")
    assert { cmp_state, cmp_tally } == { return_state, return_state |> Hangman.tally() }
  end

  test "Checks for Bad Guess" do
    curr_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 3,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l"] |> Enum.sort(),
      last_guess: "l"
    }

    return_state = %Hangman.Game{
      game_state: :bad_guess,
      turns_left: 2,
      letters:    "balmer" |> String.codepoints(),
      used:       ["b", "a", "c", "k", "m", "l", "t"] |> Enum.sort(),
      last_guess: "t"
    }

    { cmp_state, cmp_tally } = curr_state |> Hangman.make_move("t")
    assert { cmp_state, cmp_tally } == { return_state, return_state |> Hangman.tally() }
  end

end
