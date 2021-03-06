defmodule Credo.CLI.Output.Formatter.JSON do
  alias Credo.Issue
  alias Credo.CLI.Output.UI

  def print_issues(issues) do
    json_issues = Enum.map(issues, &to_json/1)

    result = %{
      "issues" => json_issues
    }

    UI.puts(Poison.encode!(result, pretty: true))
  end

  def to_json(
        %Issue{
          check: check,
          category: category,
          message: message,
          filename: filename,
          priority: priority
        } = issue
      ) do
    check_name =
      check
      |> to_string()
      |> String.replace(~r/^(Elixir\.)/, "")

    column_end =
      if issue.column && issue.trigger do
        issue.column + String.length(to_string(issue.trigger))
      end

    %{
      "check" => check_name,
      "category" => to_string(category),
      "filename" => to_string(filename),
      "line_no" => issue.line_no,
      "column" => issue.column,
      "column_end" => column_end,
      "trigger" => issue.trigger,
      "message" => message,
      "priority" => priority
    }
  end
end
