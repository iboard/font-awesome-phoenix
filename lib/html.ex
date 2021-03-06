defmodule FontAwesomePhoenix.HTML do
  @moduledoc """
  HTML helper functions for creating Font Awesome tags in Phoenix Framework templates.
  """
  use Phoenix.HTML

  @doc """
  Creates a Font Awesome icon tag.  The given `names` should be the icon name along with
  any icon modifiers such as `4x`, `fw` or `li` in a space-delimited string or a list of strings.

  ## Options:

    * `:align_tag` - Where to align the tag next to any given text, default is `:left`
    * `:class` - Additional classes to add to the icon
    * `:data` - Keyword list of data tag items to add to the tag
    * `:text` - Additional text to add next to the icon

  ## Examples:

      iex> #{__MODULE__}.fa_icon("globe")
      {:safe, [?<, "i", " class=\\"fa fa-globe\\"", ?>, "", ?<, ?/, "i", ?>]}

      iex> #{__MODULE__}.fa_icon(["globe", "4x", "li"])
      {:safe,
        [?<, "i", " class=\\"fa fa-globe fa-4x fa-li\\"", ?>, "", ?<, ?/, "i",
          ?>]}

      iex> #{__MODULE__}.fa_icon("home", text: "Back to Home!")
      {:safe,
        [?<, "i", " class=\\"fa fa-home\\"", ?>, "", ?<, ?/, "i", ?>,
          " Back to Home!"]}

      iex> #{__MODULE__}.fa_icon("user-plus", text: "New User", align_tag: :right)
      {:safe,
        ["New User ", ?<, "i", " class=\\"fa fa-user-plus\\"", ?>, "", ?<, ?/,
          "i", ?>]}

      iex> #{__MODULE__}.fa_icon("location-arrow", data: [gps_enabled: true])
      {:safe,
        [?<, "i",
          " class=\\"fa fa-location-arrow\\" data-gps-enabled=\\"true\\"", ?>,
          "", ?<, ?/, "i", ?>]}

      iex> #{__MODULE__}.fa_icon("camera-retro 4x", class: "myclass")
      {:safe,
        [?<, "i", " class=\\"fa fa-camera-retro fa-4x myclass\\"", ?>, "", ?<,
          ?/, "i", ?>]}

      iex> #{__MODULE__}.fa_icon("at") do
      ...>   EEx.eval_string("<%= \\"stuff\\" %>")
      ...> end
      {:safe,
        [?<, "i", " class=\\"fa fa-at\\"", ?>, "stuff", ?<, ?/, "i", ?>]}

      iex> #{__MODULE__}.fa_icon("at", class: "x", data: [mood: :happy]) do
      ...>   Phoenix.HTML.Tag.content_tag(:em, "@")
      ...> end
      {:safe,
        [?<, "i", " class=\\"fa fa-at x\\" data-mood=\\"happy\\"", ?>,
          [?<, "em", "", ?>, "@", ?<, ?/, "em", ?>], ?<, ?/, "i", ?>]}
  """
  @spec fa_icon(String.t() | [String.t()], Keyword.t() | none) :: {:safe, [String.t()]}
  def fa_icon(names, opts, do: block) when is_binary(names) or is_list(names) do
    data = Keyword.get(opts, :data, [])
    content_tag(:i, block, class: tag_class_string(names, opts), data: data)
  end

  def fa_icon(names, do: block) when is_binary(names) or is_list(names) do
    content_tag(:i, block, class: tag_class_string(names))
  end

  def fa_icon(names, opts) when is_binary(names) or is_list(names) do
    data = Keyword.get(opts, :data, [])

    content_tag(:i, "", class: tag_class_string(names, opts), data: data)
    |> add_text(text(opts), align_tag(opts))
  end

  def fa_icon(names) when is_binary(names) or is_list(names) do
    content_tag(:i, "", class: tag_class_string(names))
  end

  defp add_text({:safe, tag_strings}, text, align) do
    text
    |> String.trim()
    |> html_escape
    |> _add_text(tag_strings, align)
  end

  defp _add_text({:safe, ""}, safe_tag, _), do: {:safe, safe_tag}
  defp _add_text({:safe, text}, safe_tag, :left), do: {:safe, safe_tag ++ [" " <> text]}
  defp _add_text({:safe, text}, safe_tag, :right), do: {:safe, [text <> " "] ++ safe_tag}

  defp align_tag(opts), do: Keyword.get(opts, :align_tag) || :left

  defp extra_classes(opts) do
    (Keyword.get(opts, :class) || "")
    |> String.split(" ")
    |> Enum.filter(&(String.length(&1) > 0))
  end

  defp fa_classes(names) when is_binary(names) do
    names
    |> String.split(" ")
    |> fa_classes
  end

  defp fa_classes(names) when is_list(names) do
    names
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.map(&"fa-#{&1}")
  end

  defp tag_class_string(names, opts \\ []) do
    (~w(fa) ++ fa_classes(names) ++ extra_classes(opts))
    |> Enum.map(&String.trim/1)
    |> Enum.join(" ")
  end

  defp text(opts), do: Keyword.get(opts, :text) || ""
end
