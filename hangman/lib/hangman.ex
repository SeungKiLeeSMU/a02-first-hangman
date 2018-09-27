defmodule Hangman do

  defdelegate new_game(), to: Hangman.Game
  defdelegate tally(),    to: Hangman.Game

end
