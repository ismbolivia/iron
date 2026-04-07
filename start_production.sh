#!/bin/bash
export RAILS_ENV=production
export SECRET_KEY_BASE=037697f4a321c77852f8f5dc91e8cd43ac411f2a17259d5ff993d66ee06680962606d5ed6c0bb4eeb324184b8436317b33cca81e724d498f789782d702887636
export DATABASE_HOST=localhost
export DATABASE_USERNAME=sejas
export DATABASE_PASSWORD=sejas
export NODE_OPTIONS=--openssl-legacy-provider
export RAILS_SERVE_STATIC_FILES=true

cd /home/devcode/sistemas/iron
exec /home/devcode/.rbenv/shims/bundle exec puma -C /home/devcode/sistemas/iron/config/puma.rb
