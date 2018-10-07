defmodule Hangman do

  defdelegate new_game(word \\ Dictionary.random_word()),             to: Hangman.Game
  defdelegate tally(game),            to: Hangman.Tally
  defdelegate make_move(game, guess), to: Hangman.MakeMove

end
