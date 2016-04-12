defmodule Vivi do
  defp format_doc_arg({:\\, _, [left, right]}) do
    format_doc_arg(left) <> " \\\\ " <> Macro.to_string(right)
  end

  defp format_doc_arg({var, _, _}) do
    Atom.to_string(var)
  end

  defp doc_to_string(doc) do
    {{fun, _arity}, _line, _kind, args, _text} = doc
    params = args |> Enum.map(&format_doc_arg/1) |> Enum.join(", ")

    "#{Atom.to_string(fun)} (#{params})"
  end

  def module_functions(module_name) do
    docs = :"Elixir.#{module_name}"
            |> Code.get_docs(:docs)
    case docs do
      nil -> [module_name]
      _ -> Enum.map(docs, fn doc -> module_name <> "." <> doc_to_string(doc) end)
    end
  end

  def print_module_functions(module_name) do
    module_name
    |> module_functions
    |> Enum.each(&IO.puts/1)
  end
end

