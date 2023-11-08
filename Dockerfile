FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["GrafanaPrometheus/GrafanaPrometheus.csproj", "GrafanaPrometheus/"]
RUN dotnet restore "GrafanaPrometheus/GrafanaPrometheus.csproj"
COPY . .
WORKDIR "/src/GrafanaPrometheus"
RUN dotnet build "GrafanaPrometheus.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GrafanaPrometheus.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GrafanaPrometheus.dll"]
