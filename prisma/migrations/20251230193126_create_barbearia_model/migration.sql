-- CreateEnum
CREATE TYPE "BarbeariaStatus" AS ENUM ('ATIVA', 'INATIVA');

-- CreateTable
CREATE TABLE "Barbearia" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "localizacao" TEXT NOT NULL,
    "contato" TEXT NOT NULL,
    "situacao" "BarbeariaStatus" NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Barbearia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Barbearia_nome_key" ON "Barbearia"("nome");

-- CreateIndex
CREATE UNIQUE INDEX "Barbearia_localizacao_key" ON "Barbearia"("localizacao");
