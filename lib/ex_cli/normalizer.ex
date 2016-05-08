defmodule ExCLI.Normalizer do
  @moduledoc false

  def normalize(args) do
    case do_normalize(args, []) do
      {:error, _reason, _details} = err ->
        err
      result ->
        {:ok, result}
    end
  end

  defp do_normalize([], acc) do
    acc
    |> Enum.map(fn {type, value} ->
      {type, normalize_name(value)}
    end)
    |> Enum.reverse
  end
  defp do_normalize(["--" <> option | rest], acc) do
    do_normalize(rest, [{:option, option} | acc])
  end
  defp do_normalize(["-" <> "" | rest], _acc) do
    {:error, :empty_option, []}
  end
  defp do_normalize(["-" <> option | rest], acc) do
    options = String.split(option, "", trim: true)
    |> Enum.map(&({:option, &1}))
    |> Enum.reverse
    do_normalize(rest, options ++ acc)
  end
  defp do_normalize([arg | rest], acc) do
    do_normalize(rest, [{:arg, arg} | acc])
  end

  defp normalize_name(name) do
    name |> String.replace("-", "_") |> String.to_atom
  end
end