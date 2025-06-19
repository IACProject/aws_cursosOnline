const express = require("express");
const winston = require("winston");

const app = express();
const port = 4000;

const logger = winston.createLogger({
    level: "info",
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.printf(({ timestamp, level, message }) => {
            return `${timestamp} [${level}]: ${message}`;
        })
    ),
    transports: [
        new winston.transports.File({ filename: "logs/app.log" }),
        new winston.transports.Console(),
    ],
})


app.get("/", (req, res) => {
    logger.info("Recurso GET");
    res.send("Hola desde app");
});

app.listen(port, () => {
    logger.info(`Servidor escuchando en http://localhost:${port}`);
});