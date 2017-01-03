defmodule Day5 do
  def door_md5 id, index do
    :crypto.hash(:md5, "#{id}#{index}")
    |> Base.encode16(case: :lower)
  end

  @doc """

  ## Examples

      iex> Day5.build_password("abc", 8)
      "18f47a30"
  """
  def build_password code, length do
    default = %{ next_index: 0, pass: "", code: nil }

    Enum.reduce(1..length, default, fn(_, acc) ->
      next_password = next_password(code, acc.next_index)
      %{ next_password | pass: acc.pass <> next_password.pass }
    end).pass
  end

  def next_password code, index do
    password = door_md5(code, index)

    case password do
      "00000" <> _rest -> results(password, code, index)
      _ -> next_password(code, index + 1)
    end
  end

  def results password, code, index do
    %{ next_index: index + 1,
       pass: find_password_index(password, 5),
       code: code }
  end

  def find_password_index string, index do
    string
    |> String.graphemes
    |> List.to_tuple
    |> elem(index)
  end
end
