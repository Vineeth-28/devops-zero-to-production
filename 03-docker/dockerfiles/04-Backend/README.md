# 🐳 Docker Backend - Production

## 🎯 Objective

Build and run a Node.js backend using a production-oriented Docker image.

---

## 📁 Dockerfile

```dockerfile
FROM node:22-alpine

WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY package*.json ./

RUN npm install --omit=dev

COPY . .

USER appuser

EXPOSE 3000

CMD ["npm", "start"]