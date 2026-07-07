defmodule IpWeb.Navigation do
  use IpWeb, :html

  # import Phoenix.LiveView.JS

  attr :current_user, :map, default: nil
  slot :inner_block

  def navbar(assigns) do
    ~H"""
    <div class="min-h-screen flex flex-col bg-white">
      <!-- NAVBAR -->
      <header class="h-16 flex items-center px-4 sm:px-6 lg:px-8">
        <div class="flex-1 flex items-center gap-2 sm:gap-4">
          <.link navigate={~p"/"} class="flex items-center gap-2 sm:gap-4 group">
            <img
              src={~p"/images/ip.png"}
              alt="PMS logo"
              class="h-22 sm:h-12 w-auto"
              fetchpriority="high"
              oncontextmenu="return false"
            />
            
    <!-- divider -->
            <span class="h-6 sm:h-10 w-px bg-gray-200"></span>

            <h1 class="text-base sm:text-xl font-semibold tracking-tight text-slate-700 group-hover:text-gray-700 transition-colors duration-200">
              Trace
            </h1>
          </.link>
        </div>
        <!-- RIGHT: NAV -->
        <nav class="flex items-center gap-3">
          <%= if @current_user do %>
            <div class="relative ml-2">
              <button
                type="button"
                class="flex rounded-full bg-white text-sm focus:outline-none focus:ring-2 focus:ring-green-200 focus:ring-offset-2"
                id="user-menu-button"
                aria-haspopup="true"
                aria-expanded="false"
                phx-click={JS.toggle(to: "#user-menu")}
              >
                <span class="sr-only">Open user menu</span>

                <div class="h-10 w-10 rounded-full overflow-hidden">
                  <img
                    class="w-full opacity-[.88]"
                    src={~p"/images/male.svg"}
                    alt="User avatar"
                  />
                </div>
              </button>

              <div
                id="user-menu"
                class="absolute right-0 z-10 mt-2 hidden w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black/5"
                role="menu"
                aria-orientation="vertical"
                aria-labelledby="user-menu-button"
                tabindex="-1"
              >
                <.link
                  navigate={~p"/"}
                  class="block px-4 py-2 text-base font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-800"
                  role="menuitem"
                  tabindex="-1"
                >
                  Profile
                </.link>

                <.link
                  href={~p"/sign-out"}
                  class="block px-4 py-2 text-base font-medium text-gray-500 hover:bg-gray-100 hover:text-gray-800"
                  role="menuitem"
                  tabindex="-1"
                >
                  Sign out
                </.link>
              </div>
            </div>
          <% else %>
            <.link
              navigate={~p"/sign-in"}
              class="text-sm font-semibold text-white bg-slate-800 px-4 py-2 rounded-md hover:bg-slate-600"
            >
              Sign in
            </.link>
          <% end %>
        </nav>
      </header>
      
    <!-- MAIN CONTENT -->
      <main class="flex-1 px-4 sm:px-6 lg:px-8 py-6">
        {render_slot(@inner_block)}
      </main>
    </div>
    """
  end
end
