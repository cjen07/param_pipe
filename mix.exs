defmodule ParamPipe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :param_pipe,
      version: "0.1.4",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
      parameterized pipe in elixir: |n>
    """
  end

  defp package do
    [
      files: ["lib/param_pipe.ex", "mix.exs", "README.md"],
      maintainers: ["Chen Wang"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cjen07/param_pipe"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
