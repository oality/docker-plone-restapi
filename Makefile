#!/usr/bin/make

SHELL := /usr/bin/env bash

up:
	docker-compose up --scale api=2


clean:
	docker-compose down

build:
	docker-compose build --no-cache --pull


instance-run:
	docker run --rm -p 8080:8080 --name instance -v data:/data oality/plone.restapi
