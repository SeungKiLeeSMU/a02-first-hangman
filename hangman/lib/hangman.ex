defmodule Hangman do

  defdelegate new_game(),             to: Hangman.Game
  defdelegate tally(game),            to: Hangman.Tally
  defdelegate make_move(game, guess), to: Hangman.MakeMove

end
