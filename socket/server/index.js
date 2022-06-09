import express from "express";
import cors from "cors";
import { createServer } from "http";
import { Server } from "socket.io";
import SocketList from "./SocketList.js";

const PORT = process.env.PORT || 3001;

const app = express();
app.use(cors());

const httpServer = createServer(app);

const socketList = new SocketList();
const io = new Server(httpServer, {
  /* options */
  cors: {
    origin: "*",
  },
  allowEIO3: true,
});

io.on("connection", (socket) => {
  // TODO: 通过 Redis 或者 Kafaka 消息队列多进程处理
  socketList.add(socket);
  socket.on("message", (arg, callback) => {
    // TODO: 通过 Redis 或者 Kafaka 消息队列多进程处理
    const msg = JSON.parse(arg);
    socketList.publish(msg);
    // callback("got it");
  });
  socket.on("disconnect", (reason) => {
    // TODO: 通过 Redis 或者 Kafaka 消息队列多进程处理
    socketList.remove(socket);
  });
});

httpServer.listen(PORT);
