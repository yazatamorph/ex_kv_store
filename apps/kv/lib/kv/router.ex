defmodule KV.Router do
  def route(bucket, mod, func, args) do
    first = :binary.first(bucket)

    entry =
      Enum.find(table(), fn {enum, _node} ->
        first in enum
      end) || no_entry_error(bucket)

    case elem(entry, 1) do
      node when node == node() ->
        apply(mod, func, args)

      other_node ->
        {KV.RouterTasks, other_node}
        |> Task.Supervisor.async(KV.Router, :route, [bucket, mod, func, args])
        |> Task.await()
    end
  end

  defp no_entry_error(bucket) do
    raise "Could not find entry for #{inspect(bucket)} in table #{inspect(table())}"
  end

  def table do
    Application.fetch_env!(:kv, :routing_table)
  end
end
