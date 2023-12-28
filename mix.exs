defmodule KVStore.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        kv_store_1: [
          version: "0.1.0",
          applications: [kv_server: :permanent, kv: :permanent],
          cookie: "democookie"
        ],
        kv_store_2: [
          version: "0.1.0",
          applications: [kv: :permanent],
          cookie: "democookie"
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end
end
