# Sistema de Gerenciamento para Barbearia / Agendamentos

## 📊 Modelagem do Banco de Dados

Este documento descreve a estrutura do banco de dados do sistema de gerenciamento de agendamentos para barbearias, incluindo controle de usuários, serviços, horários, agendamentos, avaliações e pagamentos.

---

## 🏢 Barbearias

Armazena as informações da barbearia.

| Campo        | Descrição |
|-------------|----------|
| id | Identificador único da barbearia |
| nome | Nome da barbearia |
| localizacao | Endereço ou localização |
| contato | Telefone ou meio de contato |
| situacao | Status da barbearia (ativa, inativa) |
| criado_em | Data de criação |
| atualizado_em | Data da última atualização |

---

## 👤 Usuários

Armazena todos os usuários do sistema (clientes, barbeiros e administradores).

| Campo | Descrição |
|-----|----------|
| id | Identificador único do usuário |
| barbearia_id (FK) | Barbearia à qual o usuário pertence |
| nome | Nome completo |
| telefone | Telefone de contato |
| email | Email do usuário |
| senha | Senha criptografada |
| permissao | Perfil do usuário (`admin`, `barbeiro`, `cliente`) |
| criado_em | Data de criação |
| atualizado_em | Data da última atualização |

---

## ✂️ Serviços

Serviços oferecidos pela barbearia.

| Campo | Descrição |
|------|----------|
| id | Identificador do serviço |
| barbearia_id (FK) | Barbearia responsável |
| nome | Nome do serviço |
| duracao_minutos | Duração do serviço em minutos |
| valor | Valor do serviço |
| situacao | Ativo ou inativo |
| criado_em | Data de criação |
| atualizado_em | Data da última atualização |

---

## 🔗 Serviços dos Barbeiros

Relaciona quais serviços cada barbeiro executa (N:N).

| Campo | Descrição |
|------|----------|
| id | Identificador |
| barbeiro_id (FK) | Usuário com permissão de barbeiro |
| servico_id (FK) | Serviço associado |

---

## 🕒 Horários de Trabalho

Define o horário padrão de trabalho do barbeiro.

| Campo | Descrição |
|------|----------|
| id | Identificador |
| barbeiro_id (FK) | Barbeiro |
| dia_semana | Dia da semana (0 = Domingo, 6 = Sábado) |
| hora_inicio | Horário de início |
| hora_fim | Horário de término |
| slot_minutos | Intervalo de cada slot em minutos |

---

## 🚫 Horários Bloqueados

Bloqueios de agenda (folgas, feriados, imprevistos).

| Campo | Descrição |
|------|----------|
| id | Identificador |
| barbearia_id (FK) | Barbearia relacionada |
| barbeiro_id (FK, opcional) | Barbeiro específico (NULL = geral) |
| data_hora_inicio | Início do bloqueio |
| data_hora_fim | Fim do bloqueio |
| motivo | Motivo do bloqueio |

---

## 📅 Agendamentos

Registra os agendamentos realizados pelos clientes.

| Campo | Descrição |
|------|----------|
| id | Identificador do agendamento |
| cliente_id (FK) | Usuário cliente |
| barbearia_id (FK) | Barbearia |
| barbeiro_id (FK) | Barbeiro |
| servico_id (FK) | Serviço agendado |
| data_hora_inicio | Data e hora de início |
| data_hora_fim | Data e hora de término |
| status | Status (`agendado`, `confirmado`, `concluido`, `cancelado`, `no_show`) |
| criado_em | Data de criação |
| atualizado_em | Data da última atualização |

---

## ⭐ Avaliações

Avaliações feitas pelos clientes após o atendimento.

| Campo | Descrição |
|------|----------|
| id | Identificador |
| agendamento_id (FK) | Agendamento avaliado |
| cliente_id (FK) | Cliente |
| barbeiro_id (FK) | Barbeiro |
| nota | Nota (1 a 5) |
| comentario | Comentário do cliente |
| criado_em | Data da avaliação |

---

## 💰 Pagamentos

Controle simples de pagamentos (sem integração com gateway).

> Todo agendamento considera que o pagamento foi realizado, mas esta tabela permite controle financeiro e relatórios.

| Campo | Descrição |
|------|----------|
| id | Identificador do pagamento |
| agendamento_id (FK) | Agendamento relacionado |
| valor | Valor pago |
| forma_pagamento | Forma de pagamento (`dinheiro`, `pix`, `cartao`) |
| status | status ENUM(`pendente`,`pago`,`estornado`) |
| pago_em | Data do pagamento |

---

## 📌 Observações Gerais

- Todos os horários são calculados com base na duração do serviço.
- Bloqueios e agendamentos ocupam a agenda igualmente.
- O controle de permissões é feito pelo campo `permissao` na tabela `usuarios`.
- A modelagem permite fácil evolução para:
  - Integração com gateway de pagamento
  - Multi-barbearia (SaaS)
  - Relatórios financeiros avançados

---
