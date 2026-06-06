# ======== Stage 1: Dependencies ========
FROM node:18-alpine AS deps

WORKDIR /app

RUN apk add --no-cache python3 make g++

COPY package*.json ./
RUN npm ci --only=production

# ======== Stage 2: Production ========
FROM node:18-alpine AS production

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# بنعمل الـ folder ونديه للـ appuser قبل ما نغير الـ user
RUN mkdir -p /etc/todos && chown -R appuser:appgroup /etc/todos

COPY --from=deps /app/node_modules ./node_modules
COPY src ./src
COPY package.json ./

USER appuser

EXPOSE 3000

CMD ["node", "src/index.js"]
