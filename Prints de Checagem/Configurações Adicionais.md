# CloudWatch Alarm preso em `In Alarm`

O alarm provavelmente está preso em `In Alarm` por causa das métricas antigas acumuladas no `ErrorCount`.

Isso é comum quando:

- O projeto sobe
- O CloudWatch recebe vários erros logo no boot
- E a janela do alarm continua considerando esses dados

---

# Exemplo do que basicamente ocorre

## 1. EC2 sobe primeiro

A EC2 executa:

```text
user-data.sh
```

automaticamente no boot.

---

## 2. O script começa a gerar logs

Algo como:

```bash
echo "ERROR: simulated application failure" >> /var/log/app.log
```

talvez em loop.

---

## 3. CloudWatch Agent já está ativo

Então ele envia rapidamente:

```text
ERROR
ERROR
ERROR
```

para o CloudWatch Logs.

---

## 4. Metric Filter detecta

Seu filtro:

```text
ERROR
```

transforma logs em:

```text
ErrorCount
```

---

## 5. Só depois o alarm termina de ser criado

Quando o CloudWatch Alarm finalmente começa a avaliar:

```text
ErrorCount já está alto
```

Então ele imediatamente conclui:

```text
threshold > 1
```

---

# Resultado

O alarm já nasce em:

```text
In Alarm
```

---

# Como corrigir o problema

## PASSO 1 — Delete o alarm

Vá em:

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

## PASSO 2 — Recrie

Rode:

```bash
Destroy AWS Infrastructure
```

---

## PASSO 3 — Espere aparecer

```text
Dados insuficientes
```

ou:

```text
OK
```

---

## PASSO 4 — Dispare manualmente

Execute no prompt da sua máquina:

```bash
aws cloudwatch put-metric-data \
  --namespace AppMetrics \
  --metric-name ErrorCount \
  --value 10 \
  --region us-east-1
```

---

# Agora o fluxo será novo

```text
OK
↓
In Alarm
```

E o SNS enviará o email.