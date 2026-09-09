# =========================================================================
# Multi-Stage Dockerfile - .NET Framework (Windows Container)
# Automated Legacy Modernization Container Pipeline
# =========================================================================

# Stage 1: Build & Package Environment
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS builder
WORKDIR /app
COPY . .
RUN nuget restore
RUN msbuild /p:Configuration=Release /p:OutputPath=/app/publish

# Stage 2: Hardened Runtime Container
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
WORKDIR /inetpub/wwwroot

USER ContainerUser

COPY --from=builder /app/publish .

EXPOSE 80
