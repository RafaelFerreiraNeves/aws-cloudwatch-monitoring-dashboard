# AWS Plataforma de observabilidade 

Plataforma de observabilidade orientada a eventos utilizando serviços da AWS com infraestrutura provisionada via Terraform.

Plataforma de observabilidade desenvolvida na AWS utilizando Terraform para provisionamento da infraestrutura.

O projeto simula um ambiente monitorado em cloud, coletando logs de uma instância EC2, transformando esses logs em métricas no CloudWatch e acionando alarmes automáticos com notificações por email.

A arquitetura utiliza serviços como CloudWatch Logs, Metric Filters, CloudWatch Alarms, EventBridge, Lambda, SNS e CloudWatch Dashboard para demonstrar conceitos de monitoramento, observabilidade, automação e infraestrutura como código (IaC).

O objetivo do projeto é demonstrar na prática como funciona um fluxo completo de observabilidade em ambientes cloud utilizando serviços da AWS.

---

# Arquitetura do Projeto

```text
EC2
↓
CloudWatch Agent
↓
CloudWatch Logs
↓
Metric Filters
↓
CloudWatch Alarm
↓
EventBridge
↓
Lambda Notification Service
↓
SNS / Email
↓
CloudWatch Dashboard
```

---

# Objetivo do Projeto

Este projeto simula uma aplicação monitorada em ambiente cloud e demonstra na prática:

- Observabilidade
- Monitoramento centralizado
- Logs estruturados
- Métricas customizadas
- Alarmes automáticos
- Arquitetura orientada a eventos
- Automação serverless
- Dashboards operacionais
- Infraestrutura como código (IaC)

---

# Serviços AWS Utilizados

- EC2
- CloudWatch Agent
- CloudWatch Logs
- CloudWatch Metric Filters
- CloudWatch Alarms
- CloudWatch Dashboard
- EventBridge
- Lambda
- SNS
- IAM
- Terraform

---

# Estrutura do Projeto

```text
aws-observability-platform/
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── iam.tf
│   ├── ec2.tf
│   ├── cloudwatch.tf
│   ├── alarm.tf
│   ├── sns.tf
│   ├── lambda.tf
│   ├── eventbridge.tf
│   ├── dashboard.tf
│   ├── outputs.tf
│   └── destroy.yaml
│
├── lambda/
│   └── lambda_function.py
│
├── app/
│   └── user-data.sh
│
└── README.md
```

---

# Como o Projeto Funciona

## 1. EC2 inicia

A instância EC2 é criada via Terraform.

Durante o boot:

```text
user-data.sh
```

é executado automaticamente.

---

## 2. Simulação de erros

O script gera logs simulando falhas da aplicação:

```bash
echo "ERROR: simulated application failure" >> /var/log/app.log
```

---

## 3. CloudWatch Agent coleta os logs

O CloudWatch Agent envia os logs para:

```text
CloudWatch Logs
```

---

## 4. Metric Filter detecta erros

O filtro monitora a palavra:

```text
ERROR
```

e converte os logs em métricas customizadas:

```text
AppMetrics / ErrorCount
```

---

## 5. CloudWatch Alarm monitora métricas

Quando:

```text
ErrorCount > 1
```

o alarm muda para:

```text
In Alarm
```

---

## 6. EventBridge captura o evento

O EventBridge detecta a mudança de estado do alarm.

---

## 7. Lambda é executada automaticamente

A Lambda recebe o evento do alarm e gera logs automáticos.

---

## 8. SNS envia email

O SNS envia notificações automáticas por email quando o alarm dispara.

---

## 9. Dashboard exibe métricas

O CloudWatch Dashboard exibe:

- CPU
- Memória RAM
- Uso de disco
- ErrorCount

---

# Fluxo Completo

```text
EC2
↓
CloudWatch Agent
↓
CloudWatch Logs
↓
Metric Filters
↓
CloudWatch Alarm
↓
EventBridge
↓
Lambda
↓
SNS
↓
Email
↓
Dashboard
```

---

# Problema comum — Alarm preso em In Alarm

O alarm pode permanecer em:

```text
In Alarm
```

porque o CloudWatch continua considerando métricas antigas dentro da janela de avaliação.

Isso normalmente acontece quando:

- A EC2 sobe
- O `user-data.sh` começa a gerar erros imediatamente
- O CloudWatch Agent envia logs rapidamente
- O Metric Filter incrementa o `ErrorCount`
- O alarm é criado quando a métrica já está acima do threshold

---

# Como corrigir

## 1. Delete o alarm

```text
CloudWatch
↓
Alarms
↓
high-error-alarm
↓
Delete
```

---

## 2. Recrie via Terraform

```bash
terraform apply
```

---

## 3. Aguarde o estado

```text
OK
```

ou:

```text
Dados insuficientes
```

---

## 4. Dispare manualmente

```bash
aws cloudwatch put-metric-data \
  --namespace AppMetrics \
  --metric-name ErrorCount \
  --value 10 \
  --region us-east-1
```

---

# Resultado esperado

```text
OK
↓
In Alarm
```

O SNS enviará email automaticamente.

---

# Destruir Infraestrutura

```bash
terraform destroy
```

---

# Possíveis Melhorias Futuras

- Integração com Slack
- Integração com Discord
- Monitoramento de aplicações reais
- ECS/Fargate
- Auto Scaling
- Grafana
- Prometheus
- AWS X-Ray
- OpenTelemetry
- Secrets Manager
- SSM Parameter Store

---

# Conceitos Demonstrados

- Observabilidade
- Event-Driven Architecture
- Monitoring
- Logging
- Serverless
- Alerting
- Infrastructure as Code
- Cloud Automation
- DevOps
- SRE

---

# Autor

Rafael Ferreira Neves

---

# Licença

Projeto desenvolvido para fins educacionais e portfólio DevOps/Cloud.
