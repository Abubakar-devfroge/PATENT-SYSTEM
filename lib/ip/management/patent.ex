defmodule Ip.Management.Patent do
  use Ash.Resource,
    otp_app: :ip,
    domain: Ip.Management,
    data_layer: AshPostgres.DataLayer,
    # This is to enforce security policies globally
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "patents"
    repo Ip.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true

      accept [
        :title,
        :description,
        :visibility
      ]

      change set_attribute(:status, :submitted)
      change relate_actor(:user)
    end

    update :update do
      primary? true

      # Accepts the following so as to update
      accept [
        :title,
        :description,
        :status,
        :visibility
      ]
    end
  end

  policies do
    # Anyone logged in can create a patent
    policy action_type(:create) do
      authorize_if actor_present()
    end

    # Users can read their own patents at any stage, OR anyone can read it if it is approved AND public
    policy action_type(:read) do
      authorize_if relates_to_actor_via(:user)
      authorize_if expr(status == :approved and visibility == :public)
    end

    # ONLY the creator/owner can modify or delete their records
    policy action_type([:update, :destroy]) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  validations do
    validate string_length(:title, max: 120), message: "must not be more than 20 words"
    validate string_length(:description, max: 1500), message: "must not be more than 250 words"
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      public? true
    end

    attribute :description, :string do
      allow_nil? false
      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:draft, :submitted, :under_review, :approved, :rejected]
      default :draft
      public? true
    end

    attribute :visibility, :atom do
      constraints one_of: [:public, :private]
      # Safe by default
      default :private
      public? true
    end

    attribute :application_number, :integer do
      generated? true
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :user, Ip.Accounts.User do
      allow_nil? false
      attribute_writable? true
    end
  end
end
