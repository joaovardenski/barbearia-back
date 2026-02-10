import prisma from "../src/database/prisma";
import { FormaPagamento, UserRole, AgendamentoStatus } from "../generated/prisma/enums";
import { faker } from "@faker-js/faker";
import bcrypt from "bcryptjs";

async function main() {
  console.log("🌱 Iniciando seed...");

  const SENHA_PADRAO = await bcrypt.hash("123456", 10);

  const barbearia = await prisma.barbearia.upsert({
    where: { nome: "Barbearia Alpha" },
    update: {},
    create: {
      nome: "Barbearia Alpha",
      localizacao: faker.location.streetAddress(),
      contato: faker.phone.number(),
    },
  });

  const admin = await prisma.usuario.upsert({
    where: { email: "admin@barbearia.com" },
    update: {},
    create: {
      nome: "Administrador",
      email: "admin@barbearia.com",
      senha: SENHA_PADRAO,
      permissao: UserRole.admin,
      barbearia_id: barbearia.id,
    },
  });

  const barbeiros = await Promise.all(
    Array.from({ length: 3 }).map((_, i) =>
      prisma.usuario.create({
        data: {
          nome: faker.person.fullName(),
          email: `barbeiro${i + 1}@barbearia.com`,
          senha: SENHA_PADRAO,
          permissao: UserRole.barbeiro,
          barbearia_id: barbearia.id,
        },
      })
    )
  );

  const clientes = await Promise.all(
    Array.from({ length: 10 }).map(() =>
      prisma.usuario.create({
        data: {
          nome: faker.person.fullName(),
          email: faker.internet.email(),
          senha: SENHA_PADRAO,
          permissao: UserRole.cliente,
          barbearia_id: barbearia.id,
        },
      })
    )
  );

  const servicos = await Promise.all(
    [
      { nome: "Corte", duracao: 30, valor: 40 },
      { nome: "Barba", duracao: 30, valor: 30 },
      { nome: "Corte + Barba", duracao: 60, valor: 65 },
    ].map((s) =>
      prisma.servico.create({
        data: {
          nome: s.nome,
          duracao_minutos: s.duracao,
          valor: s.valor,
          barbearia_id: barbearia.id,
        },
      })
    )
  );

  await prisma.servicoBarbeiro.createMany({
    data: barbeiros.flatMap((barbeiro) =>
      servicos.map((servico) => ({
        barbeiro_id: barbeiro.id,
        servico_id: servico.id,
      }))
    ),
    skipDuplicates: true,
  });

  /* ============================
   * HORÁRIOS DE TRABALHO
   * ============================ */
  await prisma.horarioTrabalho.createMany({
    data: barbeiros.flatMap((barbeiro) =>
      Array.from({ length: 5 }).map((_, dia) => ({
        barbeiro_id: barbeiro.id,
        dia_semana: dia + 1, // segunda a sexta
        hora_inicio: "09:00",
        hora_fim: "18:00",
        slot_minutos: 30,
      }))
    ),
    skipDuplicates: true,
  });

  for (let i = 0; i < 8; i++) {
    const cliente = faker.helpers.arrayElement(clientes);
    const barbeiro = faker.helpers.arrayElement(barbeiros);

    const servico = faker.helpers.arrayElement(servicos);

    const dataBase = faker.date.soon({ days: 15 });
    dataBase.setHours(faker.number.int({ min: 9, max: 16 }), 0, 0);

    const inicio = dataBase;
    const fim = new Date(
      inicio.getTime() + servico.duracao_minutos * 60000
    );

    const agendamento = await prisma.agendamento.create({
      data: {
        cliente_id: cliente.id,
        barbeiro_id: barbeiro.id,
        servico_id: servico.id,
        barbearia_id: barbearia.id,
        data_hora_inicio: inicio,
        data_hora_fim: fim,
        status: AgendamentoStatus.concluido,
      },
    });

    await prisma.pagamento.create({
      data: {
        agendamento_id: agendamento.id,
        valor: servico.valor,
        forma_pagamento: faker.helpers.arrayElement(Object.values(FormaPagamento)),
      },
    });

    await prisma.avaliacao.create({
      data: {
        agendamento_id: agendamento.id,
        cliente_id: cliente.id,
        barbeiro_id: barbeiro.id,
        nota: faker.number.int({ min: 4, max: 5 }),
        comentario: faker.lorem.sentence(),
      },
    });
  }

  console.log("✅ Seed finalizado com sucesso!");
}

main()
  .catch((e) => {
    console.error("❌ Erro no seed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
