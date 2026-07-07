defmodule IpWeb.PatentLive.Form do
  use IpWeb, :live_view
  on_mount {IpWeb.LiveUserAuth, :live_user_required}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage patent records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="patent-form"
        phx-change="validate"
        phx-submit="save"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:title]} type="text" label="Title" /><.input
            field={@form[:description]}
            type="textarea"
            label="Abstract (Not more than 250 words)"
          />
          <.input
            field={@form[:visibility]}
            type="select"
            label="Visibility"
            options={
              Ash.Resource.Info.attribute(Ip.Management.Patent, :visibility).constraints[:one_of]
            }
          />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input field={@form[:title]} type="text" label="Title" /><.input
            field={@form[:description]}
            type="textarea"
            label="Abstract (Not more than 250 words)"
          /><.input
            field={@form[:status]}
            type="select"
            label="Status"
            options={Ash.Resource.Info.attribute(Ip.Management.Patent, :status).constraints[:one_of]}
          />

          <.input
            field={@form[:visibility]}
            type="select"
            label="Visibility"
            options={
              Ash.Resource.Info.attribute(Ip.Management.Patent, :visibility).constraints[:one_of]
            }
          />
        <% end %>

        <.button phx-disable-with="Saving..." variant="primary">Apply</.button>
        <.button navigate={return_path(@return_to, @patent)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    patent =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(Ip.Management.Patent, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(patent), do: "New", else: "Edit"
    page_title = action <> " " <> "Patent"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(patent: patent)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"patent" => patent_params}, socket) do
    {:noreply, assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, patent_params))}
  end

  def handle_event("save", %{"patent" => patent_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: patent_params) do
      {:ok, patent} ->
        socket =
          socket
          |> put_flash(:info, "Patent #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, patent))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp assign_form(%{assigns: %{patent: patent}} = socket) do
    form =
      if patent do
        AshPhoenix.Form.for_update(patent, :update,
          as: "patent",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Ip.Management.Patent, :create,
          as: "patent",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _patent), do: ~p"/patents"
  defp return_path("show", patent), do: ~p"/patents/#{patent.id}"
end
