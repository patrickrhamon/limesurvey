#!/bin/bash

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

composer install
