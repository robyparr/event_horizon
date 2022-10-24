defmodule EventHorizonWeb.Router do
  use EventHorizonWeb, :router

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
    plug :accepts, ["json"]
    plug :ensure_site_authenticated
  end

  scope "/", EventHorizonWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", EventHorizonWeb do
    pipe_through :api

    post "/events", Api.EventController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EventHorizonWeb.Telemetry
    end
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

  ## Authentication routes

  scope "/", EventHorizonWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/user/log_in", UserSessionController, :new
    post "/user/log_in", UserSessionController, :create
    get "/user/reset_password", UserResetPasswordController, :new
    post "/user/reset_password", UserResetPasswordController, :create
    get "/user/reset_password/:token", UserResetPasswordController, :edit
    put "/user/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", EventHorizonWeb do
    pipe_through [:browser, :require_authenticated_user]

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
  end

  scope "/", EventHorizonWeb do
    pipe_through [:browser]

    delete "/user/log_out", UserSessionController, :delete
    get "/user/confirm", UserConfirmationController, :new
    post "/user/confirm", UserConfirmationController, :create
    get "/user/confirm/:token", UserConfirmationController, :edit
    post "/user/confirm/:token", UserConfirmationController, :update
  end
end
