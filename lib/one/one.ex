defmodule One do
  @doc """
  iex> One.file_to_list("path/to/one.txt")
  """

  def file_to_list(file_path) do
    file_path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
  end

  def calibrate(list) do
    list
    |> Enum.map(&extract_ints/1)

    # |> Enum.sum()
  end

  defp extract_ints(string) do
    digits = String.graphemes(string) |> Enum.filter(&String.match?(&1, ~r/\d/))

    case digits do
      [] ->
        0

      [_single_digit] ->
        String.to_integer(Enum.join(digits) <> Enum.join(digits))

      _ ->
        min_digit = Enum.min(digits)
        max_digit = Enum.max(digits)
        String.to_integer(min_digit <> max_digit)
    end
  end
end
