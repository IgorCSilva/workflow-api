defmodule WorkflowApiWeb.Router do
  use WorkflowApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WorkflowApiWeb do
    pipe_through :api

    post "/function/create", FunctionController, :create
    get "/function/list", FunctionController, :list

    post "/module/create", ModuleController, :create
    get "/module/list", ModuleController, :list
    put "/module/update-functions/:id", ModuleController, :update_functions

    get "/modules", WorkflowApiController, :modules
    get "/modules-functions", WorkflowApiController, :modules_functions
    get "/module-functions/:module_name", WorkflowApiController, :module_functions

    get "/sequences", WorkflowApiController, :sequences
    get "/get-sequence/:sequence_name", WorkflowApiController, :get_sequence

    post "/set-sequence/:sequence_name", WorkflowApiController, :set_sequence

    post "/execute-sequence/:sequence_name", WorkflowApiController, :execute_sequence
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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: WorkflowApiWeb.Telemetry
    end
  end
end
