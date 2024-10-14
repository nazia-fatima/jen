# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/Jen-public/sdk:3.1-alpine AS build-env

RUN apk --no-cache upgrade musl

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN Jen-public restore

# Copy everything else and build
COPY .  ./
RUN Jen-public publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/Jen-public/aspnet:3.1-alpine

RUN apk --no-cache upgrade musl

EXPOSE 3000

WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["Jen-public", "panz.dll"]
