defmodule Adventofcode.One.Two do
  @doc """
  iex> Adventofcode.One.Two.file_to_value("path/to/one.txt")
  """

  def file_to_value(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    |> calibrate
  end

  def calibrate(list) do
    list
    |> Enum.map(&parse_string/1)
  end

  @number_words %{
    "oneight" => 18,
    "twone" => 21,
    "threeight" => 38,
    "fiveight" => 58,
    "sevenine" => 79,
    "eightwo" => 82,
    "eighthree" => 83,
    "nineight" => 98,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "zero" => 0
  }
  def parse_string(string) do
    Enum.reduce(@number_words, string, fn {word, number}, acc ->
      String.replace(acc, word, Integer.to_string(number))
    end)
    |> String.replace(~r/[^\d]/, "")
    |> extract_ints()
  end

  defp extract_ints(ints) do
    digits = String.graphemes(ints)

    case digits do
      [_single_digit] ->
        String.to_integer(Enum.join(digits) <> Enum.join(digits))

      _ ->
        first_digit = Enum.fetch!(digits, 0)
        last_digit = List.last(digits)
        String.to_integer(first_digit <> last_digit)
    end
  end
end
