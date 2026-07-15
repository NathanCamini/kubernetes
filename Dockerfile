FROM python:3.12-slim

ENV FLASK_APP=run.py

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia o requirements para dentro do container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código Python para o container
COPY . .

# Porta padrão do Flask
EXPOSE 5000

# Executa o servidor do Flask
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]