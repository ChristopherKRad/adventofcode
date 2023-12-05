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
end
