# 🧱 Proyecto Ruby - API de Ejemplo

Este proyecto es una API simple en **Ruby puro** que expone endpoints para manejar usuarios y productos.  
Incluye ejemplos de:

- Controladores con **Sinatra**
- Arquitectura en capas (Controller / Service / Repository)
- Ejecución de tareas asincrónicas (con `rufus-scheduler`)
- Manejo de excepciones personalizado

---

## 🧰 Requisitos

- Ruby (>= 3.0)
- Bundler
- (Opcional) Docker y Docker Compose

---

## 🚀 Levantar el proyecto sin Docker

1. Instalar dependencias
    ```bash
    bundle install
    ```
2. Levantar el servidor
    ```bash
    bundle exec ruby main.rb
    ```
    Por defecto corre en http://localhost:4567

---

## 🐳 Levantar con Docker

    Ejecutar directamente docker-compose up

---

## 🧪 Endpoints

- POST /products
- GET /products/:id
- POST /login
