defmodule Adventofcode.Two.Two do
  @doc """
  iex> Adventofcode.Two.One.file_to_value("path/to/two.txt")
  """

  def file_to_value(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_game/1)
    |> sum_game_powers()
  end

  # Parse the list of strings into a tuple {game_id, game_data}
  def parse_game(game_list) do
    [game_str, game_data] = String.split(game_list, ": ")
    game_int = String.slice(game_str, 5..-1) |> String.to_integer()
    {game_int, extract_rounds(game_data)}
  end

  # Split the game_data into a list of rounds
  def extract_rounds(game_data) do
    game_data
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&process_round/1)
  end

  # Process the rounds into maps
  def process_round(round) do
    round
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{"red" => 0, "blue" => 0, "green" => 0}, fn color_n_count, acc ->
      [count_str, color] = String.split(color_n_count, " ")
      count = String.to_integer(count_str)
      Map.update(acc, color, count, &(&1 + count))
    end)
  end

  # -------------
  # Games are now formatted as follows: {id, [%{round1}, %{round2}, ...]}
  # -------------

  def sum_game_powers(games) do
    Enum.map(games, fn {_game_id, rounds} ->
      rounds
      |> max_color_counts_per_game()
      |> calculate_color_cap_power()
    end)
    # Add up the result!
    |> Enum.sum()
  end

  # Iterate through each round, and gather the max color count per game
  defp max_color_counts_per_game(rounds) do
    Enum.reduce(rounds, %{"red" => 0, "blue" => 0, "green" => 0}, fn round, acc ->
      Map.merge(acc, round, fn _key, v1, v2 -> max(v1, v2) end)
    end)
  end

  # Gather the 'power' for each game
  defp calculate_color_cap_power(color_counts) do
    Enum.reduce(color_counts, 1, fn {_color, count}, acc -> acc * count end)
  end
end
