defmodule IpWeb.PatentLive.Show do
  use IpWeb, :live_view
  on_mount {IpWeb.LiveUserAuth, :live_user_optional}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <%!-- 1. Dynamic title text --%>
        <%= if @current_user && @current_user.id == @patent.user_id do %>
          APPLICATION NO: {@patent.application_number}
        <% else %>
          Patent Details
        <% end %>

        <%!-- 2. Keep the slot structural, but hide the text inside it if they aren't the owner --%>
        <:subtitle>
          <%= if @current_user && @current_user.id == @patent.user_id do %>
            This is a patent record from your database.
          <% end %>
        </:subtitle>

        <:actions>
          <.button navigate={~p"/patents"}>
            <.icon name="hero-arrow-left" /> Back
          </.button>

          <%= if @current_user && @current_user.id == @patent.user_id do %>
            <.button variant="primary" navigate={~p"/patents/#{@patent}/edit?return_to=show"}>
              <.icon name="hero-pencil-square" /> Edit Patent
            </.button>
          <% end %>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@patent.title}</:item>

        <:item title="Abstract">{@patent.description}</:item>

        <%!-- 1. The slot is a direct child. We evaluate title and inner content dynamically inside it --%>
        <:item title={
          if @current_user && @current_user.id == @patent.user_id, do: "Status", else: "Submitter"
        }>
          <%= if @current_user && @current_user.id == @patent.user_id do %>
            <span class="inline-flex items-center px-2 py-1 text-xs font-medium rounded-md bg-blue-50 text-blue-700 ring-1 ring-inset ring-blue-700/10">
              {@patent.status}
            </span>
          <% else %>
            <span class="text-sm text-gray-600">
              {@patent.user.email}
            </span>
          <% end %>
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Show Patent")
      |> assign_new(:current_user, fn -> nil end)

    # CHANGE THIS: Pass the resource first, the ID second, and options last
    patent =
      Ash.get!(
        Ip.Management.Patent,
        id,
        actor: socket.assigns[:current_user],
        # 👈 Pass your preloads cleanly here instead
        load: [:user]
      )

    {:ok, assign(socket, :patent, patent)}
  end
end
