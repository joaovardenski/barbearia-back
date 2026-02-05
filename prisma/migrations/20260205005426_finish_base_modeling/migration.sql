/*
  Warnings:

  - You are about to drop the `Barbearia` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('admin', 'barbeiro', 'cliente');

-- CreateEnum
CREATE TYPE "ServicoStatus" AS ENUM ('ATIVO', 'INATIVO');

-- CreateEnum
CREATE TYPE "AgendamentoStatus" AS ENUM ('agendado', 'confirmado', 'concluido', 'cancelado', 'no_show');

-- CreateEnum
CREATE TYPE "FormaPagamento" AS ENUM ('dinheiro', 'pix', 'cartao');

-- CreateEnum
CREATE TYPE "PagamentoStatus" AS ENUM ('pendente', 'pago', 'estornado');

-- DropTable
DROP TABLE "Barbearia";

-- CreateTable
CREATE TABLE "barbearias" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "localizacao" TEXT NOT NULL,
    "contato" TEXT NOT NULL,
    "situacao" "BarbeariaStatus" NOT NULL DEFAULT 'ATIVA',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "barbearias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usuarios" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "telefone" TEXT,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "permissao" "UserRole" NOT NULL DEFAULT 'cliente',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "barbearia_id" INTEGER NOT NULL,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "servicos" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "duracao_minutos" INTEGER NOT NULL,
    "valor" DECIMAL(10,2) NOT NULL,
    "situacao" "ServicoStatus" NOT NULL DEFAULT 'ATIVO',
    "barbearia_id" INTEGER NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "servicos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "servicos_barbeiros" (
    "id" SERIAL NOT NULL,
    "barbeiro_id" TEXT NOT NULL,
    "servico_id" INTEGER NOT NULL,

    CONSTRAINT "servicos_barbeiros_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "horarios_trabalho" (
    "id" SERIAL NOT NULL,
    "barbeiro_id" TEXT NOT NULL,
    "dia_semana" INTEGER NOT NULL,
    "hora_inicio" TEXT NOT NULL,
    "hora_fim" TEXT NOT NULL,
    "slot_minutos" INTEGER NOT NULL DEFAULT 30,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "horarios_trabalho_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "horarios_bloqueados" (
    "id" SERIAL NOT NULL,
    "barbearia_id" INTEGER NOT NULL,
    "barbeiro_id" TEXT,
    "data_hora_inicio" TIMESTAMP(3) NOT NULL,
    "data_hora_fim" TIMESTAMP(3) NOT NULL,
    "motivo" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "horarios_bloqueados_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "agendamentos" (
    "id" TEXT NOT NULL,
    "cliente_id" TEXT NOT NULL,
    "barbearia_id" INTEGER NOT NULL,
    "barbeiro_id" TEXT NOT NULL,
    "servico_id" INTEGER NOT NULL,
    "data_hora_inicio" TIMESTAMP(3) NOT NULL,
    "data_hora_fim" TIMESTAMP(3) NOT NULL,
    "status" "AgendamentoStatus" NOT NULL DEFAULT 'agendado',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "agendamentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "avaliacoes" (
    "id" SERIAL NOT NULL,
    "agendamento_id" TEXT NOT NULL,
    "cliente_id" TEXT NOT NULL,
    "barbeiro_id" TEXT NOT NULL,
    "nota" INTEGER NOT NULL,
    "comentario" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "avaliacoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pagamentos" (
    "id" SERIAL NOT NULL,
    "agendamento_id" TEXT NOT NULL,
    "valor" DECIMAL(10,2) NOT NULL,
    "forma_pagamento" "FormaPagamento" NOT NULL,
    "status" "PagamentoStatus" NOT NULL DEFAULT 'pago',
    "pago_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pagamentos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "barbearias_nome_key" ON "barbearias"("nome");

-- CreateIndex
CREATE UNIQUE INDEX "barbearias_localizacao_key" ON "barbearias"("localizacao");

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "servicos_barbeiros_barbeiro_id_servico_id_key" ON "servicos_barbeiros"("barbeiro_id", "servico_id");

-- CreateIndex
CREATE UNIQUE INDEX "horarios_trabalho_barbeiro_id_dia_semana_key" ON "horarios_trabalho"("barbeiro_id", "dia_semana");

-- CreateIndex
CREATE UNIQUE INDEX "avaliacoes_agendamento_id_key" ON "avaliacoes"("agendamento_id");

-- CreateIndex
CREATE UNIQUE INDEX "pagamentos_agendamento_id_key" ON "pagamentos"("agendamento_id");

-- AddForeignKey
ALTER TABLE "usuarios" ADD CONSTRAINT "usuarios_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "barbearias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "servicos" ADD CONSTRAINT "servicos_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "barbearias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "servicos_barbeiros" ADD CONSTRAINT "servicos_barbeiros_barbeiro_id_fkey" FOREIGN KEY ("barbeiro_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "servicos_barbeiros" ADD CONSTRAINT "servicos_barbeiros_servico_id_fkey" FOREIGN KEY ("servico_id") REFERENCES "servicos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "horarios_trabalho" ADD CONSTRAINT "horarios_trabalho_barbeiro_id_fkey" FOREIGN KEY ("barbeiro_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "horarios_bloqueados" ADD CONSTRAINT "horarios_bloqueados_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "barbearias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "horarios_bloqueados" ADD CONSTRAINT "horarios_bloqueados_barbeiro_id_fkey" FOREIGN KEY ("barbeiro_id") REFERENCES "usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamentos" ADD CONSTRAINT "agendamentos_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamentos" ADD CONSTRAINT "agendamentos_barbearia_id_fkey" FOREIGN KEY ("barbearia_id") REFERENCES "barbearias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamentos" ADD CONSTRAINT "agendamentos_barbeiro_id_fkey" FOREIGN KEY ("barbeiro_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agendamentos" ADD CONSTRAINT "agendamentos_servico_id_fkey" FOREIGN KEY ("servico_id") REFERENCES "servicos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avaliacoes" ADD CONSTRAINT "avaliacoes_agendamento_id_fkey" FOREIGN KEY ("agendamento_id") REFERENCES "agendamentos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avaliacoes" ADD CONSTRAINT "avaliacoes_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "avaliacoes" ADD CONSTRAINT "avaliacoes_barbeiro_id_fkey" FOREIGN KEY ("barbeiro_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagamentos" ADD CONSTRAINT "pagamentos_agendamento_id_fkey" FOREIGN KEY ("agendamento_id") REFERENCES "agendamentos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
