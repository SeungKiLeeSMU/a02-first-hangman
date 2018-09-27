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
    assert String.length(new_game.word_to_guess) > 0
  end

  test "New Game Letters Guessed is Empty" do
    new_game = Hangman.new_game()
    assert new_game.letters_guessed == []
  end

  test "Tally Updated Correctly" do
    current_state = %Hangman.Game{
      game_state:      :Drinking,
      turns_left:      6,
      word_to_guess:   "Balmer Index",
      letters_guessed: "bac" |> String.codepoints()
    }

    return_state = %Hangman.Game{
      game_state:      :Drinking,
      turns_left:      6,
      letters_guessed: "bac" |> String.codepoints()
    }

    check_state = Hangman.Game.tally(current_state)

    assert check_state == return_state
  end
end
