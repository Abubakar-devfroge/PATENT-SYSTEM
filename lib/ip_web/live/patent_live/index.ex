defmodule IpWeb.PatentLive.Index do
  use IpWeb, :live_view
  on_mount {IpWeb.LiveUserAuth, :live_user_optional}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <%= if @current_user do %>
        <.header>
          Listing Patents
          <:actions>
            <.button variant="primary" navigate={~p"/patents/new"}>
              <.icon name="hero-plus" /> New Patent
            </.button>
          </:actions>
        </.header>
      <% end %>

      <div class="border border-gray-200 bg-white rounded-sm shadow-sm">
        <.table
          id="patents"
          rows={@streams.patents}
          row_click={fn {_id, patent} -> JS.navigate(~p"/patents/#{patent}") end}
        >
          <:col :let={{_id, patent}} label="Title">{patent.title}</:col>

          <:col :let={{_id, patent}} label="Abstract">{patent.description}</:col>

          <:col :let={{_id, patent}} label="Status / Author">
            <%= if @current_user && @current_user.id == patent.user_id do %>
              <%!-- ONLY the owner/creator can see the status --%>
              <span>
                {patent.status}
              </span>
            <% else %>
              <%!-- Anyone else (public or another logged-in user) sees the creator's email --%>
              <span class="text-sm text-gray-600">
                {patent.user.email}
              </span>
            <% end %>
          </:col>

          <:action :let={{_id, patent}}>
            <div class="sr-only">
              <.link navigate={~p"/patents/#{patent}"}>Show</.link>
            </div>
            <%= if @current_user && @current_user.id == patent.user_id do %>
              <.link navigate={~p"/patents/#{patent}/edit"}>Edit</.link>
            <% end %>
          </:action>

          <:action :let={{id, patent}}>
            <%= if @current_user && @current_user.id == patent.user_id do %>
              <.link
                phx-click={JS.push("delete", value: %{id: patent.id}) |> hide("##{id}")}
                data-confirm="Are you sure?"
              >
                Delete
              </.link>
            <% end %>
          </:action>
        </.table>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Patents")
      |> assign_new(:current_user, fn -> nil end)

    # 1. Build an Ash query that requests the associated user record
    patents_query =
      Ip.Management.Patent
      |> Ash.Query.load(:user)

    # 2. Execute the query using the assigned current_user as the security actor
    patents = Ash.read!(patents_query, actor: socket.assigns[:current_user])

    {:ok, stream(socket, :patents, patents)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    patent = Ash.get!(Ip.Management.Patent, id, actor: socket.assigns.current_user)
    Ash.destroy!(patent, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :patents, patent)}
  end
end
