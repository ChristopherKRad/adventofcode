defmodule Adventofcode.Two.One do
  @doc """
  iex> Adventofcode.Two.One("path/to/two.txt")
  """

  def file_to_value(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    # Turn every row into a list
    |> Enum.map(&parse_game/1)
    |> filter_out_nil()
    |> sum_game_ids()
  end

  # Take every row and turn it into a tuple with the game's int val, and the game's data
  def parse_game(game_list) do
    [game_str, game_data] = String.split(game_list, ": ")
    game_int = String.slice(game_str, 5..-1) |> String.to_integer()
    game_tuple = {game_int, extract_to_map(game_data)}
    parse_tuple(game_tuple)
  end

  # Take the string in game_data and turn that into a map with rgb as the keys
  def extract_to_map(game_data) do
    game_data
    # Split the string at every `,` and `;`
    |> String.split(~r/[,;]/)
    # Trim whitespace from each element
    |> Enum.map(&String.trim/1)
    # Create a map with both the color and count & feed the values into the accumulator
    |> Enum.reduce(%{"red" => 0, "blue" => 0, "green" => 0}, fn color_count_str, acc ->
      # Split the color string by space
      [count_str, color] = String.split(color_count_str, " ")
      count = String.to_integer(count_str)
      # Update the map with the color count added up for each color
      Map.update(acc, color, count, &(&1 + count))
    end)
  end

  def parse_tuple({game_number, color_counts}) do
    max_counts = %{"red" => 12, "green" => 13, "blue" => 14}

    colors_within_limit =
      Enum.all?(color_counts, fn {color, count} ->
        max_count = Map.fetch!(max_counts, color)
        count <= max_count
      end)

    if colors_within_limit, do: {game_number, color_counts}, else: nil
  end

  def filter_out_nil(game_tuples) do
    Enum.filter(game_tuples, &(!is_nil(&1)))
  end

  def sum_game_ids(game_tuples) do
    Enum.reduce(game_tuples, 0, fn {id, _}, acc -> acc + id end)
  end
end
