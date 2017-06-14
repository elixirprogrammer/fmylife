defmodule Fmylife.StoryView do
  use Fmylife.Web, :view
  alias Fmylife.Like
  import Kerosene.HTML

  def time_ago_in_words(time) do
    ts = NaiveDateTime.to_erl(time) |> :calendar.datetime_to_gregorian_seconds
    diff = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time) - ts
    rel_from_now(:calendar.seconds_to_daystime(diff))
  end

  defp rel_from_now({0, {0, 0, sec}}) when sec < 30,
    do: "just now"
  defp rel_from_now({0, {0, min, _}}) when min < 2,
    do: "1 minute ago"
  defp rel_from_now({0, {0, min, _}}),
    do: "#{min} minutes ago"
  defp rel_from_now({0, {1, _, _}}),
    do: "1 hour ago"
  defp rel_from_now({0, {hour, _, _}}) when hour < 24,
    do: "#{hour} hours ago"
  defp rel_from_now({1, {_, _, _}}),
    do: "1 day ago"
  defp rel_from_now({day, {_, _, _}}) when day < 0,
    do: "just now"
  defp rel_from_now({day, {_, _, _}}),
    do: "#{day} days ago"

  def liked?(conn, story_id) do
    current_user = Coherence.current_user(conn)
    case conn.assigns.current_user do
      nil -> "btn btn-info btn-xs"
      _ ->
        case Like.liked?(current_user.id, story_id) do
          nil -> "btn btn-info btn-xs"
          _ -> "btn btn-info btn-xs active"
        end
    end
  end

  def disliked?(conn, story_id) do
    current_user = Coherence.current_user(conn)
    case conn.assigns.current_user do
      nil -> "btn btn-primary btn-xs"
      _ ->
        case Like.disliked?(current_user.id, story_id) do
          nil -> "btn btn-primary btn-xs"
          _ -> "btn btn-primary btn-xs active"
        end
    end
  end
end
