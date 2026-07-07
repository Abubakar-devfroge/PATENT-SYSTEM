defmodule Ip.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Ip.Accounts.User, _opts, _context) do
    Application.fetch_env(:ip, :token_signing_secret)
  end
end
