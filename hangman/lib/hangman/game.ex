defmodule Hangman.Game do

  defstruct(
    game_state:      :initializing,
    turns_left:      7,
    word:   [],
    guessed: []
  )

  # API

  def new_game() do
    new_word = new_word()
    %Hangman.Game{
      word: new_word
    }
  end

  def tally(game) do

    displayed = show_letter(game.word, game.guessed)

    %Hangman.Game{
      game_state: game.game_state,
      turns_left: game.turns_left,
      guessed: game.guessed,
      word: displayed
    }
  end

  # Utility Functions

  defp new_word() do
    Dictionary.random_word()
  end

  defp show_letter(word, guessed) do
    String.codepoints(word)
    |> Enum.map( &display &1, &1 in guessed )
  end

  defp display(letter, true), do: letter
  defp display(_, false),     do: "_"

end
