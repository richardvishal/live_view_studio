defmodule LiveViewStudioWeb.BingoLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        number: nil,
        numbers: all_numbers()
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Bingo Boss 📢</h1>
    <div id="bingo">
      <div class="users">
        <ul></ul>
      </div>
      <div class="number">
        <%= @number %>
      </div>
    </div>
    """
  end

  # Returns a list of all valid bingo numbers in random order.
  #
  # Example: ["B 4", "N 40", "O 73", "I 29", ...]
  def all_numbers() do
    ~w(B I N G O)
    |> Enum.zip(Enum.chunk_every(1..75, 15))
    |> Enum.flat_map(fn {letter, numbers} ->
      Enum.map(numbers, &"#{letter} #{&1}")
    end)
    |> Enum.shuffle()
  end
end
