# Iniciar o Minikube
Write-Host "Iniciando Minikube..." -ForegroundColor Cyan
minikube start
if ($LASTEXITCODE -ne 0) { throw "Falha ao iniciar o Minikube" }

# Habilitar o Ingress
Write-Host "Habilitando o Ingress..." -ForegroundColor Cyan
minikube addons enable ingress
if ($LASTEXITCODE -ne 0) { throw "Falha ao habilitar o Ingress" }

# Aplicar os manifests
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

# Iniciar túnel do Minikube
Write-Host "Iniciando túnel do Minikube..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "minikube tunnel" -Verb RunAs

# Iniciar dashboard do Minikube
Write-Host "Iniciando dashboard do Minikube..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "minikube dashboard" -Verb RunAs

# Redirecionamento de portas
Write-Host "Redirecionando porta do RabbitMQ..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "kubectl port-forward service/rabbitmq 15672:15672 -n fasttechfoods" -Verb RunAs

Write-Host "Redirecionando porta do Prometheus..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "kubectl port-forward svc/prometheus 9090:9090 -n monitoring" -Verb RunAs

Write-Host "Redirecionando porta do Grafana..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "kubectl port-forward svc/grafana 3000:3000 -n monitoring" -Verb RunAs

Write-Host "Script finalizado com sucesso!" -ForegroundColor Green
