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
    assert String.length(new_game.word) > 0
  end

  test "New Game Letters Guessed is Empty" do
    new_game = Hangman.new_game()
    assert new_game.guessed == []
  end

  test "Tally Updated Correctly" do
    current_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 6,
      word:       "balmer",
      guessed:    ["a", "b", "c"]
    }

    return_state = %Hangman.Game{
      game_state: :Drinking,
      turns_left: 6,
      word:       ["b", "a", "_", "_", "_", "_"],
      guessed:    ["a", "b", "c"]
    }

    assert Hangman.tally(current_state) == return_state
  end
end
