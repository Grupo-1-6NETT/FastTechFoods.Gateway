# Fast Tech Foods - Gateway

Este � um micro servi�o desenvolvido em .NET Core 8 para gerenciar os endpoints da aplica��o Fast Tech Foods. 
Este projeto � parte da solu��o para o Hackathon da Fase 5 do curso de p�s gradua��o 6NETT na FIAP.

## �ndice
- [Pr�-requisitos](#pr�-requisitos)
- [Overview](#overview)
- [Configura��o do Projeto](#configura��o-do-projeto)
- [Eventos](#eventos)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)

## Pr�-requisitos

- [Kubernetes](https://kubernetes.io/pt-br/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start)
- [Docker](https://www.docker.com/get-started/) e [Docker Compose](https://docs.docker.com/compose/install/) (necess�rio para executar o projeto)
- [.NET SDK 8.0](https://dotnet.microsoft.com/download/dotnet/8.0) (somente para executar local)

## Overview
**Containers**
![Containers](FastTechFoods-Container.jpg)

**Fluxo do Pedido**
![Fluxo Pedido](FastTechFoods-fluxo-pedido.jpg)

## Configura��o do Projeto

**1. Clone o reposit�rio:**

   ```bash
   git clone https://github.com/Grupo-1-6NETT/FastTechFoods.Gateway.git
   cd FastTechFoods.Gateway
   ```

**2. Adicione configura��es necess�rias**

Um arquivo `.env` com as vari�veis de ambiente deve ser adicionado na ra�z do projeto. 

J� na pasta `~/k8s/shared/postgres` devem ser adicionados os seguintes arquivos:

- postgre-secret.yaml
- rabbitmq-secret.yaml

**3. Suba os pods**

Abra uma janela do PowerShell e, na pasta `~/k8s`, execute o script `runall.ps1`. Note que ser� necess�rio permiss�es elevadas.

Ou se preferir, execute os seguintes comandos. Certifique-se de estar na pasta `k8`:

Note que alguns comandos exigem que a janela do PS permane�a aberta. Pode ser necess�rio abrir mais de uma janela.

```
minikube start
minikube addons enable ingress

kubectl apply -f .\fasttechfoods-namespace.yaml
kubectl apply -f .\monitoring-namespace.yaml
kubectl apply -f .\auth\ -n fasttechfoods
kubectl apply -f .\catalog\ -n fasttechfoods
kubectl apply -f .\orders\ -n fasttechfoods
kubectl apply -f .\kitchen\ -n fasttechfoods
kubectl apply -f .\shared\ingress\ -n fasttechfoods
kubectl apply -f .\shared\postgres\ -n fasttechfoods
kubectl apply -f .\shared\rabbitmq\ -n fasttechfoods
kubectl apply -f .\shared\monitoring\

minikube tunnel

kubectl port-forward service/rabbitmq 15672:15672 -n fasttechfoods
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
kubectl port-forward svc/grafana 3000:3000 -n monitoring
```

**4. Abra o minikube dashboard**

```
minikube dashboard
```


---
## Eventos
|Evento|Fila padr�o|Descri��o|
|---|---|---|
|AddItem|additem|Adiciona um item no card�pio|
|DeleteItem|deleteitem|Remove um item do card�pio|
|UpdateItem|updateitem|Atualiza um item no card�pio|

---
## Tecnologias Utilizadas
- **ASP.NET Core 8** - Framework principal para desenvolvimento do servi�o
- **Entity Framework Core** - ORM para manipula��o do banco de dados
- **Postgres** - Banco de dados
- **RabbitMQ** - Message Broker
- **MassTransit** - Transporte de mensagens
- **Docker** - Cria��o de conteiners
- **Kubernets** e **Minikube** - Orquestra��o de containers
- **Prometheus** e **Grafana** - Monitoramento
