defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "spawn bucket", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "remove bucket on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    KV.Registry.create(registry, "fake")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "remove bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket, :shutdown)

    KV.Registry.create(registry, "fake")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "unexpected bucket crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    Agent.stop(bucket, :shutdown)
    catch_exit(KV.Bucket.put(bucket, "milk", 3))
  end
end
