defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

  attr :expiration, :integer, default: 24
  slot :legal
  slot :inner_block, required: true

  def promo(assigns) do
    assigns = assign(assigns, :minutes, assigns.expiration * 60)

    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires in <%= @expiration %> hours!
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    <%= @minutes %>
    """
  end

  attr :visible, :boolean, default: false

  def loading_indicator(assigns) do
    ~H"""
    <div :if={@visible} class="relative flex justify-center my-10">
      <div class="absolute w-12 h-12 border-8 border-gray-300 rounded-full">
      </div>
      <div class="absolute w-12 h-12 border-8 border-indigo-400 rounded-full border-t-transparent animate-spin">
      </div>
    </div>
    """
  end

  attr :url, :string, required: true
  attr :count, :integer, required: true
  attr :params, :map, required: true

  def paginator(assigns) do
    ~H"""
    <div class="pagination">
      <.link
        :if={@params.page > 1}
        patch={"/#{@url}?#{ URI.encode_query(%{@params | page: @params.page - 1})}"}
      >
        Previous
      </.link>
      <.link
        :for={
          {page_number, current_page?} <-
            pages(@params, @count)
        }
        class={if current_page?, do: "active"}
        patch={"/#{@url}?#{ URI.encode_query(%{@params | page: page_number})}"}
      >
        <%= page_number %>
      </.link>

      <.link
        :if={
          more_pages?(
            @params,
            @count
          )
        }
        patch={"/#{@url}?#{ URI.encode_query(%{@params | page: @params.page + 1}) }"}
      >
        Next
      </.link>
    </div>
    """
  end

  defp more_pages?(options, count) do
    options.page * options.per_page < count
  end

  defp pages(options, count) do
    page_count = ceil(count / options.per_page)

    for page_number <- (options.page - 2)..(options.page + 2), page_number > 0 do
      if page_number <= page_count do
        {page_number, page_number == options.page}
      end
    end
  end
end
