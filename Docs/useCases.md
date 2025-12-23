# Sistema de Gerenciamento para Barbearia / Agendamentos

## Visão Geral
Este documento descreve os **casos de uso** do sistema de gerenciamento de agendamentos para barbearias, contemplando três perfis de usuários: **Cliente**, **Administrador** e **Funcionário / Barbeiro**.

O sistema permite o controle de serviços, horários, agendamentos e relatórios, oferecendo uma experiência completa tanto para o cliente final quanto para a gestão da barbearia.

---

## 👤 Cliente

### Autenticação
- Cadastro
- Login
- Recuperação de senha  
- Autenticação via Google

### Dashboard
- Visualizar próximo agendamento
- Visualizar total de agendamentos realizados

### Agenda
- Visualizar serviços oferecidos
- Visualizar barbeiros disponíveis
- Visualizar horários disponíveis de acordo com a agenda do barbeiro
- Agendar um serviço

### Meus Agendamentos
- Visualizar agendamentos futuros
- Visualizar histórico de agendamentos
- Visualizar detalhes do agendamento
- Reagendar agendamento
- Cancelar agendamento (1 dia de antecedência)

### Perfil
- Alterar nome
- Alterar foto de perfil (opcional)
- Excluir conta

### Avaliação
- Avaliar atendimento após a conclusão do serviço

---

## 👨‍💼 Administrador

### Autenticação
- Login
- Recuperação de senha
- Autenticação via Google

### Dashboard
- Visualizar total de agendamentos
- Visualizar taxa de ocupação da barbearia
- Visualizar faturamento (por período)

### Gerenciamento
- Gerenciar funcionários (criar, editar, ativar/desativar)
- Gerenciar serviços da barbearia
- Definir horários padrão de funcionamento
- Gerenciar feriados e exceções de funcionamento

### Agenda
- Visualizar agenda de todos os barbeiros

### Relatórios
- Relatórios de ocupação
- Relatórios financeiros
- Relatórios por barbeiro

---

## ✂️ Funcionário / Barbeiro

### Dashboard
- Visualizar próximo atendimento
- Visualizar total de atendimentos realizados

### Serviços
- Associar serviços disponíveis ao seu perfil

### Agenda
- Bloquear horários específicos
- Definir horário de trabalho (entrada e saída)
- Criar agendamentos manuais para clientes

### Atendimentos
- Confirmar atendimento
- Concluir atendimento
- Marcar atendimento como *no-show*

### Relatórios
- Relatório de atendimentos realizados
- Visualizar avaliações recebidas

---

## Observações Gerais
- O sistema deve respeitar regras de disponibilidade, duração dos serviços e bloqueios de agenda.
- Agendamentos possuem status (ex: agendado, confirmado, concluído, cancelado, no-show).
- O acesso às funcionalidades é controlado por **perfil de usuário**.
