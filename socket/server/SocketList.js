import { v4 as uuidv4 } from "uuid";

class SocketList {
  constructor() {
    this.list = [];
    // TODO: 保存到数据库
    this.msgList = [];
  }

  add(socket) {
    const index = this.list.findIndex((it) => it.id === socket.id);
    if (-1 !== index) {
      return;
    }
    // TODO: 发送历史消息给当前用户
    if (0 < this.msgList.length) {
      socket.emit("history", JSON.stringify(this.msgList));
    }
    this.list.push(socket);
    this.publish({
      type: "members",
      subType: "join",
      userId: socket.id,
      message: `${socket.id} 加入房间 ✨🎉`,
    });
  }

  remove(socket) {
    const next = this.list.filter((it) => it.id !== socket.id);
    if (next.length === this.list.length) {
      return;
    }
    this.list = next;
    this.publish({
      type: "members",
      subType: "leave",
      userId: socket.id,
      message: `${socket.id} 离开房间 📞☎`,
    });
  }

  publish(msg) {
    const msgInfo = { ...msg };
    if (!msg.msgId) {
      msgInfo.msgId = uuidv4();
    }
    if (!msg.time) {
      msgInfo.time = Date.now();
    }
    const stringifed = JSON.stringify(msgInfo);
    this.list.forEach((it) => {
      // debugger;
      it.emit("message", stringifed);
    });
    // TODO: 缓存历史消息
    if ("message" === msg.type) {
      // TODO: 限制历史消息数量
      this.msgList.push(stringifed);
    }
  }
}

export default SocketList;
