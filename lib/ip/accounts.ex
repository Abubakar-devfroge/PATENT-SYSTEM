defmodule Ip.Accounts do
  use Ash.Domain, otp_app: :ip, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Ip.Accounts.Token
    resource Ip.Accounts.User
  end
end
