# 🚀 Guess Game - Kubernetes (K3D + Helm)

## 🏗️ Arquitetura e Componentes

A aplicação foi migrada de Docker Compose para Kubernetes visando escalabilidade e resiliência. A arquitetura atual conta com os seguintes componentes:

1. **Frontend (React + Nginx)**: Roda como um `Deployment` no cluster. Foi configurado um **Ingress** (usando o Traefik, nativo do K3D) para expor a aplicação diretamente na porta 80 do cluster, permitindo acesso sem necessidade de `port-forward`. O Nginx interno também atua como proxy reverso roteando requisições `/api` para o backend.
2. **Backend (Flask)**: Roda como um `Deployment` isolado na porta 5000. Este componente possui **Horizontal Pod Autoscaler (HPA)** configurado. Se o uso de CPU ultrapassar 70%, o Kubernetes escalará de 1 até 5 réplicas automaticamente. Foram definidos `requests` e `limits` de CPU/Memória para possibilitar a coleta de métricas pelo HPA.
3. **Database (PostgreSQL)**: Roda como um `Deployment` na porta 5432, isolado na rede interna do cluster.

Todos os manifestos estão empacotados em um **Helm Chart** chamado `guess-game` localizado no diretório `/k8s/guess-game`. O uso do Helm facilita a parametrização das configurações (através do arquivo `values.yaml`).

---

## 🛠️ Como Executar

### 1. Pré-requisitos

Verifique se possui o docker instalado e rodando:

- [Docker](https://docs.docker.com/get-docker/)
- [K3D](https://k3d.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

### 2. Criação do Cluster K3D

Para que o Ingress funcione e exponha a porta 80 do cluster para a porta 8080 do `localhost`, crie o cluster com o comando abaixo:

```bash
k3d cluster create guess-game-cluster -p "8080:80@loadbalancer" --api-port 127.0.0.1:53504
kubectl config set-cluster k3d-guess-game-cluster --server=https://localhost:53504
```

### 3. Deploy da Aplicação com Helm

Com o cluster em pé, instale o Helm Chart (certifique-se de estar na raiz do repositório):

```bash
helm install meu-jogo ./k8s/guess-game
```

As imagens do frontend e backend estão configuradas no `values.yaml` para usar as tags `demo-game-frontend:v1.0.0` e `demo-game-backend:v1.0.0` diretamente do meu docker Hub (nathancamini).

### 4. Acesso e Verificação da Saúde da Aplicação

Aguarde alguns segundos para que os Pods fiquem com status `Running`:

```bash
kubectl get pods
```

Se todos os pods estiverem `Running`, acesse o jogo diretamente em seu navegador através da URL:
**http://localhost:8080**

### 5. Encerrando o Ambiente

```bash
k3d cluster delete guess-game-cluster
```
