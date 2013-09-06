defmodule Exmeck.Mixfile do
  use Mix.Project

  def project do
    [ app: :exmeck,
      version: "0.0.2",
      elixir: "~> 0.10.2",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      {:meck, [github: "eproxus/meck", tag: "0.8.1"]},
      {:uuid, "0.4.4", [github: "avtobiff/erlang-uuid", tag: "v0.4.4"]},
    ]
  end
end
