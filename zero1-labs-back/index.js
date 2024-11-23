const express = require("express");
const bodyParser = require("body-parser");
const { OpenAI } = require("openai");
require("dotenv").config();

// AI Agen with cypher testnet configuration: https://chatgpt.com/g/g-6741c2c42fb48191a41caa29e68e89f4-zero1-helper
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const app = express();
const PORT = 3000;

app.use(bodyParser.json());

app.post("/ask", async (req, res) => {
  const { question } = req.body;

  if (!question) {
    return res.status(400).json({ error: "Question is required." });
  }

  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: question }],
    });

    res.json({ answer: response.data.choices[0].message.content });
  } catch (error) {
    console.error("OpenAI API error:", error.message);
    res.status(500).json({ error: "Failed to process the request." });
  }
});

app.listen(PORT, () => {
  console.log(`run`);
});
