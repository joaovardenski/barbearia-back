import express from "express";

const app = express();

app.get("/hello", (req, res) => {
  return res.status(200).send({
    message: "Olá, mundo!",
  });
});

app.listen(3000, () => {
  console.log("Server ouvindo na porta 3000");
});
