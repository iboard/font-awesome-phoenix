defmodule FontAwesomePhoenix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :font_awesome_phoenix,
      version: "1.0.0",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      xref: [exclude: [Phoenix.HTML, Phoenix.HTML.Tag]]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.22", only: :dev},
      {:phoenix_html, "~> 2.11"}
    ]
  end

  defp description do
    """
    HTML helper functions to build Font Awesome icon tags.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Nick Veys", "Gabe Cook"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/code-lever/font-awesome-phoenix"
      }
    ]
  end
end
