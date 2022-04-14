FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["HelloAspnetCore.csproj", "./"]
RUN dotnet restore "HelloAspnetCore.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloAspnetCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloAspnetCore.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloAspnetCore.dll"]
