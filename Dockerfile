# ---------- Build Stage ----------
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy source
COPY . .

# Install dependencies
RUN flutter pub get

# Build Flutter web
RUN flutter build web

# ---------- Runtime Stage ----------
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build to nginx
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
