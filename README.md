# IP — Patent Management System

A platform for digitizing, tracking, and managing patent applications, built with **Elixir**, the **Ash Framework**, and **Phoenix LiveView**.

## Key Features

- **Declarative resource design** — patent entities, workflows, and lifecycles modeled with the Ash Framework
- **Role-based access control** — data-access rules enforced at the query level via Ash policies
- **Interactive dashboard** — real-time UI powered by Phoenix LiveView
- **Secure authentication** — registration, sign-in, and password confirmation via `AshAuthentication`

## Prerequisites

- **Elixir** v1.15 or later & **Erlang/OTP** v26 or later
- **PostgreSQL** v14 or later, running and accessible

## Getting Started

```sh
mix setup        # install dependencies and set up the database
mix phx.server   # start the Phoenix endpoint
```

Then visit [localhost:4000](http://localhost:4000) in your browser.

## Status

This project is in early development.

## Stack

Elixir · Ash Framework · Phoenix LiveView · PostgreSQL · Tailwind CSS
