defmodule Adventofcode.One.One do
  @doc """
  iex> Adventofcode.One.One.file_to_list("path/to/one.txt")
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
    |> Enum.map(&extract_ints/1)
    |> Enum.sum()
  end

  defp extract_ints(string) do
    digits = String.graphemes(string) |> Enum.filter(&String.match?(&1, ~r/\d/))

    case digits do
      [] ->
        0

      [_single_digit] ->
        String.to_integer(Enum.join(digits) <> Enum.join(digits))

      _ ->
        first_digit = Enum.fetch!(digits, 0)
        last_digit = List.last(digits)
        String.to_integer(first_digit <> last_digit)
    end
  end
end
