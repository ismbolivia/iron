# Copilot / AI agent instructions for Iron

This repository is a Ruby on Rails (5.2) monolith with React + Webpacker and Postgres. The file links below point to canonical locations used throughout the project — use them as primary sources when making changes.

- **Big picture:** Rails monolith. Backend: Rails controllers and models under `app/controllers` and `app/models`. Frontend: Rails views plus React components via Webpacker (`package.json`, `webpacker`). DB: PostgreSQL (`config/database.yml`, `docker-compose.yml`). Dockerized by `Dockerfile` and `docker-compose.yml`.
- **Key files:** [Gemfile](Gemfile), [package.json](package.json), [Dockerfile](Dockerfile), [docker-compose.yml](docker-compose.yml), [entrypoint.sh](entrypoint.sh), [config/routes.rb](config/routes.rb), [config/application.rb](config/application.rb), [config/database.yml](config/database.yml).

- **Run / dev workflows**
  - Docker (recommended):

```bash
docker-compose up --build
# web server available on localhost:3000, db on port 5434 (mapped)
```

  - Local (if you have Ruby/Postgres installed):

```bash
bundle install
yarn install
bundle exec rails db:create db:migrate
bundle exec rails server -b 0.0.0.0
```

- **Database & migrations:** The container `entrypoint.sh` runs `rake db:create db:migrate` (see [entrypoint.sh](entrypoint.sh)). Use `bundle exec rails db:prepare` / `db:migrate` locally. `config/database.yml` reads DB creds from env vars used by `docker-compose.yml`.

- **Auth / authorization:** Authentication uses `devise` (routes created via `devise_for :users`) and authorization uses `cancancan`. See `app/controllers/application_controller.rb` for global before_actions (`authenticate_user!`, permitted params) and CanCan rescue handling.

- **Routing & patterns:** Most API surface is conventional Rails `resources` in [config/routes.rb](config/routes.rb). Expect numerous custom GET endpoints (e.g., `/price_list_item`, `/clients_sales_pdf`). When adding endpoints, follow the existing `resources` and `member/collection` usage.

- **Frontend / JS:** Webpacker + React (`react-rails`) — JS dependencies live in [package.json](package.json). Webpack version is v4 in this repo; node setup in `Dockerfile` targets Node 16. When changing JS, run `yarn install` and rebuild webpacker as needed.

- **Common libraries & patterns:**
  - Image uploads: `carrierwave` + `mini_magick`.
  - PDF generation: `wicked_pdf` + `wkhtmltopdf-binary`.
  - Background / optional: `redis` is referenced but commented; no active config.
  - Custom validators under `lib/validators` are autoloaded (see `config/application.rb`).

- **Testing & debugging:** Tests are under `test/` (Rails system/unit tests). Run with `bundle exec rails test`. Use `byebug` for in-code breakpoints (development/test groups in `Gemfile`).

- **When editing code:**
  - Follow controller/service responsibilities: controllers orchestrate request/response, push complex logic into models or `lib/` helpers where appropriate.
  - Preserve DB migrations order and never edit applied migrations — add new migrations instead.
  - Respect existing naming conventions (Spanish/English mixed identifiers occur across controllers and routes).

- **External integrations & env:** Postgres is required (Docker uses `postgres:12`). Several env vars control DB connectivity: `DATABASE_HOST`, `DATABASE_USERNAME`, `DATABASE_PASSWORD` (see [docker-compose.yml](docker-compose.yml) and [config/database.yml](config/database.yml)).

- **Examples to follow:**
  - Nested resources: `resources :sales do resources :sale_details end` in [config/routes.rb](config/routes.rb).
  - Devise setup: `devise_for :users` and permitted params handled in `ApplicationController`.

- **What NOT to do:**
  - Do not assume modern Rails newer than 5.2 — APIs and generator behavior may differ.
  - Do not run destructive DB commands in production without backups; `entrypoint.sh` runs migrations automatically in containers.

If anything here is unclear or you want more detail (examples of controller refactors, preferred code layout for new services, or additional commands), tell me which area to expand. I'll iterate on this file.
