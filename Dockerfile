FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ThirdApi.csproj", "./"]
RUN dotnet restore "./ThirdApi.csproj"
COPY . .
RUN dotnet build "ThirdApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ThirdApi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ThirdApi.dll"]