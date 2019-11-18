defmodule FlyiinAssignmentWeb.Router do
  use FlyiinAssignmentWeb, :router

  # alias FlyiinAssignmentWeb.FindCheapestOffer 

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FlyiinAssignmentWeb do
    pipe_through :browser

    get "/findCheapestOffer", FindCheapestOffer, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", FlyiinAssignmentWeb do
  #   pipe_through :api
  # end
end
