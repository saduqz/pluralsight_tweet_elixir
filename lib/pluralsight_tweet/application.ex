defmodule PluralsightTweet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: PluralsightTweet.Worker.start_link(arg)

      %{
        id: PluralsightTweet.TweetServer,
        start: {PluralsightTweet.TweetServer, :start_link, []}
      }

      # {PluralsightTweet.TweetServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PluralsightTweet.Supervisor]
    process = Supervisor.start_link(children, opts)

    PluralsightTweet.Scheduler.schedule_file(
      "* * * * *",
      Path.join(
        "#{:code.priv_dir(:pluralsight_tweet)}",
        "sample.txt"
      )
    )

    process
  end
end
