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
    [m_name|m_ending] = String.split(module_name, ".", parts: 2)
    m_ending = case m_ending do
      [val] -> val
      [] -> ""
    end
    docs = :"Elixir.#{m_name}"
            |> Code.get_docs(:docs)
    results = case docs do
      nil -> [module_name]
      _ -> Stream.map(docs, fn doc -> doc_to_string(doc) end)
      |> Stream.filter(fn doc -> if m_ending != "" do
                                   String.starts_with?(String.downcase(doc), String.downcase(m_ending))
                                 else doc
                                 end
                       end)
      |> Enum.map(fn doc -> m_name <> "." <> doc end)
    end
    results
  end

  def print_module_functions(module_name) do
    module_name
    |> module_functions
    |> Enum.each(&IO.puts/1)
  end
end

