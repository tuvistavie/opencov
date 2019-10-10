defmodule Opencov.Project do
  use Opencov.Web, :model

  import Ecto.Query
  import EctoEnum

  defenum TribeEnum, ["vp", "merchant", "shopex", "payment"]

  schema "projects" do
    field :name, :string
    field :token, :string
    field :current_coverage, :float
    field :base_url, :string
    field :tribe, TribeEnum

    belongs_to :user, Opencov.User
    has_many :builds, Opencov.Build
    has_one :badge, Opencov.Badge

    timestamps()
  end

  def with_token(query, token) do
    query |> where(token: ^token)
  end

  def visibility_choices do
    ~w(public private internal)
  end
end
