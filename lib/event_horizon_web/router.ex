defmodule EventHorizonWeb.Router do
  use EventHorizonWeb, :router

  import Phoenix.LiveDashboard.Router
  import EventHorizonWeb.UserAuth
  import EventHorizonWeb.Api.SiteAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {EventHorizonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
    plug :ensure_site_authenticated
  end

  ## Event API
  scope "/api", EventHorizonWeb do
    pipe_through :api

    post "/events", Api.EventController, :create
    options "/events", Api.EventController, :options
  end

  ## Guest-only routes
  scope "/", EventHorizonWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/user/log_in", UserSessionController, :new
    post "/user/log_in", UserSessionController, :create
    get "/user/reset_password", UserResetPasswordController, :new
    post "/user/reset_password", UserResetPasswordController, :create
    get "/user/reset_password/:token", UserResetPasswordController, :edit
    put "/user/reset_password/:token", UserResetPasswordController, :update
  end

  ## Authenticated Routes
  scope "/", EventHorizonWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", RedirectController, :index

    live_session :default, on_mount: {EventHorizonWeb.UserAuth, :ensure_authenticated} do
      live "/sites", SiteLive.Index, :index
      live "/sites/new", SiteLive.Index, :new
      live "/sites/:id/edit", SiteLive.Index, :edit

      live "/sites/:id", SiteLive.Show, :show
      live "/sites/:id/show/edit", SiteLive.Show, :edit
    end

    get "/user/settings", UserSettingsController, :edit
    put "/user/settings", UserSettingsController, :update
    get "/user/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live_dashboard "/dashboard", metrics: EventHorizonWeb.Telemetry
  end

  ## Unauthenticated routes
  scope "/", EventHorizonWeb do
    pipe_through [:browser]

    delete "/user/log_out", UserSessionController, :delete
    get "/user/confirm", UserConfirmationController, :new
    post "/user/confirm", UserConfirmationController, :create
    get "/user/confirm/:token", UserConfirmationController, :edit
    post "/user/confirm/:token", UserConfirmationController, :update
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
