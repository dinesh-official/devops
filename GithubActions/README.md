| Feature            | Repo Secrets / Variables       | Environment Secrets / Variables        |
| ------------------ | ------------------------------ | -------------------------------------- |
| Scope              | Global (all workflows)         | Per environment (dev / staging / prod) |
| Setup location     | Settings → Secrets & Variables | Settings → Environments                |
| YAML usage         | Manual mapping required        | Auto injected via `environment:`       |
| Multi-env support  | ❌ No separation                | ✅ Full separation                      |
| Duplication        | ❌ High (repeat in files)       | ✅ None                                 |
| Security control   | Basic                          | Advanced (approvals, restrictions)     |
| Risk of mistakes   | ❌ High (prod used in dev)      | ✅ Low                                  |
| Scalability        | ❌ Poor                         | ✅ Excellent                            |
| Maintenance effort | ❌ High                         | ✅ Very low                             |
| Best for           | Small/simple projects          | Production / multi-env setups          |




# 🧱 1. `.env.template` (ONLY file you edit for structure)

Create in repo root:

```env id="envfull01"
# =========================
# PUBLIC / CONFIG
# =========================
NEXTAUTH_URL=${NEXTAUTH_URL}
PORT=${PORT}
ALLOWED_CORPORATE_DOMAINS=${ALLOWED_CORPORATE_DOMAINS}
NEXT_PUBLIC_APP_ENV=${NEXT_PUBLIC_APP_ENV}
NEXT_PUBLIC_PARTNER_API_BASE=${NEXT_PUBLIC_PARTNER_API_BASE}

SUPER_ADMIN_EMAIL=${SUPER_ADMIN_EMAIL}
SUPER_ADMIN_NAME=${SUPER_ADMIN_NAME}

MAX_LOGIN_ATTEMPTS=${MAX_LOGIN_ATTEMPTS}
LOGIN_LOCKOUT_MINUTES=${LOGIN_LOCKOUT_MINUTES}
SESSION_MAX_AGE=${SESSION_MAX_AGE}

SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_SECURE=${SMTP_SECURE}
MAIL_FROM=${MAIL_FROM}

# =========================
# SECRETS
# =========================
DATABASE_URL=${DATABASE_URL}
NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
SUPER_ADMIN_PASSWORD=${SUPER_ADMIN_PASSWORD}

SMTP_USER=${SMTP_USER}
SMTP_PASSWORD=${SMTP_PASSWORD}
```

👉 Add new env → edit ONLY this file

---

# 🧱 2. GitHub Environment setup (VERY IMPORTANT)

Go to:

```text id="envsetup"
Settings → Environments → production
```

### Add Variables (vars):

```
NEXTAUTH_URL
PORT
ALLOWED_CORPORATE_DOMAINS
NEXT_PUBLIC_APP_ENV
NEXT_PUBLIC_PARTNER_API_BASE
SUPER_ADMIN_EMAIL
SUPER_ADMIN_NAME
MAX_LOGIN_ATTEMPTS
LOGIN_LOCKOUT_MINUTES
SESSION_MAX_AGE
SMTP_HOST
SMTP_PORT
SMTP_SECURE
MAIL_FROM
```

---

### Add Secrets:

```
DATABASE_URL
NEXTAUTH_SECRET
SUPER_ADMIN_PASSWORD
SMTP_USER
SMTP_PASSWORD
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
ECR_REGISTRY
```

---

# 🧱 3. FINAL `.github/workflows/deploy.yml`

👉 This file will be SAME for all your services

```yaml id="deployfull01"
name: partners-docs deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production   # 🔥 KEY LINE (auto injects vars + secrets)

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      # ✅ Generate .env from template
      - name: Generate .env
        run: envsubst < .env.template > .env

      # (Optional debug — remove after testing)
      # - run: cat .env

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id:     ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region:            ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        uses: aws-actions/amazon-ecr-login@v2

      - name: Build, Tag & Push Docker Image
        env:
          REGISTRY:   ${{ secrets.ECR_REGISTRY }}
          REPOSITORY: prod-partners-docs
          IMAGE_TAG:  latest
        run: |
          docker build -f Dockerfile -t $REGISTRY/$REPOSITORY:$IMAGE_TAG .
          docker push $REGISTRY/$REPOSITORY:$IMAGE_TAG

      - name: Deploy to Amazon ECS
        uses: aws-actions/amazon-ecs-deploy-task-definition@v2
        with:
          task-definition:      partners-docs-task.json
          cluster:              prod-cluster
          service:              prod-partners-docs
          force-new-deployment: true

      # 🔐 Cleanup (optional but recommended)
      - name: Delete .env
        run: rm -f .env
```

---

# 🔥 What you just achieved

### ❌ Before

* Edit 10 YAML files for every env change

### ✅ Now

* Add env → only in:

```text id="onlyoneplace"
GitHub → Environments → production
```

* Structure change → only:

```text id="onlytemplate"
.env.template
```

👉 ZERO YAML changes

---

# 🧠 Flow (understand this once)

```text id="flowfinal"
GitHub Environment (vars + secrets)
        ↓
Automatically injected into job
        ↓
envsubst reads them
        ↓
.env generated
        ↓
Docker uses it
        ↓
Deploy to ECS
```

---

