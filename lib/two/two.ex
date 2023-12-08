defmodule Adventofcode.Two.One do
  @doc """
  iex> Adventofcode.Two.One.file_to_value("path/to/two.txt")
  """

  def file_to_value(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_game/1)
  end

  # Parse the list of strings into a tuple {game_id, game_data}
  def parse_game(game_list) do
    [game_str, game_data] = String.split(game_list, ": ")
    game_int = String.slice(game_str, 5..-1) |> String.to_integer()
    {game_int, extract_rounds(game_data)}
  end

  # Split the game_data into a list of rounds
  # process the rounds into maps
  def extract_rounds(game_data) do
    game_data
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&process_round/1)
  end

  def process_round(round) do
    round
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{"red" => 0, "blue" => 0, "green" => 0}, fn color_count_str, acc ->
      [count_str, color] = String.split(color_count_str, " ")
      count = String.to_integer(count_str)
      Map.update(acc, color, count, &(&1 + count))
    end)
  end

  # -------------
  # For each list of rounds ->
  # Find the "minimum number required per color" (i.e. the max for each color ) "color_cap"
  # Store each color_cap in a map
  # Multiply the color_caps for each list of rounds
  # Sum the power of each list of rounds together
  # -------------

  # Sum the powers of each game to get the result
  # def sum_tuples(tuples) do
  #   Enum.reduce(tuples, 0, fn {_, second_value}, acc -> acc + second_value end)
  # end
end
