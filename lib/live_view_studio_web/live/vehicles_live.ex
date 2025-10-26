defmodule LiveViewStudioWeb.VehiclesLive do
  alias LiveViewStudio.Vehicles
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudioWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        query: "",
        vehicles: [],
        matches: [],
        loading: false
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <form phx-submit="search" phx-change="suggest">
        <input
          type="text"
          name="query"
          value={@query}
          placeholder="Make or model"
          autofocus
          autocomplete="off"
          list="matches"
        />

        <button>
          <img src="/images/search.svg" />
        </button>
      </form>
      <datalist id="matches">
        <option :for={m_m <- @matches} value={m_m}>
          <%= m_m %>
        </option>
      </datalist>
      <CustomComponents.loading_indicator visible={@loading} />

      <div class="vehicles">
        <ul>
          <li :for={vehicle <- @vehicles}>
            <span class="make-model">
              <%= vehicle.make_model %>
            </span>
            <span class="color">
              <%= vehicle.color %>
            </span>
            <span class={"status #{vehicle.status}"}>
              <%= vehicle.status %>
            </span>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:run_search, query})
    {:noreply, assign(socket, query: query, vehicles: [], loading: true)}
  end

  def handle_event("suggest", %{"query" => prefix}, socket) do
    matches = Vehicles.suggest(prefix)
    {:noreply, assign(socket, matches: matches)}
  end

  def handle_info({:run_search, query}, socket) do
    vehicles = Vehicles.search(query)
    {:noreply, assign(socket, query: query, vehicles: vehicles, loading: false)}
  end
end
