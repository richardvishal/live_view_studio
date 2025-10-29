defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    donations = Donations.list_donations()

    {:ok, socket, donations: donations}
  end
end
