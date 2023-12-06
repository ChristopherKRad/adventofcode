defmodule Adventofcode.One.Two do
  @doc """
  iex> Adventofcode.One.Two.file_to_value("path/to/one.txt")
  """

  @regex ~r/(?=(\d)|(one)|(two)|(three)|(four)|(five)|(six)|(seven)|(eight)|(nine))/i
  @number_map %{
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def file_to_value(file_path) do
    file_path
    # Take the file
    |> File.stream!()
    # Trim each row of the file into a list of strings
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
    # Pass each string through the "calibration" to extract the digits
    |> Enum.map(&calibrate/1)

    # Add them up!
    |> Enum.sum()
  end

  def calibrate(string) do
    # Scan the full string for all values in the number_map 
    Regex.scan(@regex, string)
    |> Enum.flat_map(fn matches ->
      Enum.filter(matches, fn match -> match != "" end)
    end)
    # Convert those values into integers
    |> Enum.map(fn match ->
      @number_map[match]
    end)
    # 'Concat' the first and last if match > 2 elements, duplicate if match < 2
    |> case do
      # This case is prob not necessary
      [] ->
        0

      [single_digit] ->
        single_digit * 11

      digits ->
        first_digit = List.first(digits) * 10
        last_digit = List.last(digits)
        first_digit + last_digit
    end
  end
end
