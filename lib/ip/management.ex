defmodule Ip.Management do
  use Ash.Domain,
    otp_app: :ip

  resources do
    resource Ip.Management.Patent
  end
end
