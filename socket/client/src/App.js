import React from "react";
import io from "socket.io-client";
import { Form, Button, Input, Badge, Divider, notification } from "antd";
import "./App.css";
import MsgList from "./MsgList";

function App() {
  const ref = React.useRef();
  const inputRef = React.useRef();
  const [connected, setConnected] = React.useState(false);
  const [id, setId] = React.useState("");
  const [list, setList] = React.useState([]);
  const [form] = Form.useForm();

  const onHistory = React.useCallback((str) => {
    const list = JSON.parse(str).map((it) => JSON.parse(it));
    console.log(str);
    // TODO: 重新连接去重处理
    setList((prev) => [...prev, ...list]);
  }, []);

  const onMessage = React.useCallback((msg) => {
    // TODO: 节流，防止过度渲染
    console.log(msg);
    setList((prev) => [...prev, JSON.parse(msg)]);
  }, []);

  const connect = React.useCallback(() => {
    // TODO: 防抖处理，规避 React.StrictMode 导致 App render twice 问题
    if (!ref.current) {
      console.log("new socket.io client");
      ref.current = io("http://192.168.16.119:3001/");
      ref.current.on("connect", () => {
        console.log("socket.io connected");
        setConnected(ref.current.connected);
        setId(ref.current.id);
      });
      ref.current.on("disconnect", () => {
        console.log("socket.io disconnect");
        setConnected(ref.current.connected);
      });
      ref.current.on("error", (error) => {
        console.log("socket.io error");
        setConnected(ref.current.connected);
      });
      ref.current.on("message", onMessage);
      ref.current.on("history", onHistory);
    } else if (!ref.current.connected) {
      console.log("socket.io error");
      ref.current.connect();
    }
  }, [onMessage, onHistory]);

  const onSubmit = React.useCallback(
    ({ text }) => {
      if (!ref.current || !ref.current.connected) {
        notification.error({ message: "socket.io 连接异常" });
        return;
      }
      const msg = {
        type: "message",
        userId: ref.current.id,
        message: text,
      };
      ref.current.emit("message", JSON.stringify(msg), () => {
        notification.success({ message: "消息发送成功" });
        form.resetFields();
        inputRef.current.focus();
      });
    },
    [form]
  );

  React.useEffect(() => {
    connect();
    return () => {
      if (ref.current) {
        console.log("close socket.io client");
        ref.current.close();
      }
      ref.current = null;
    };
  }, [connect]);

  return (
    <div className="app">
      <header className="header">Socket.io 同步消息</header>
      <main className="main">
        {/* {list.map((it) => (
          <div key={it.msgId}>{it.message}</div>
        ))} */}
        <MsgList userId={id} list={list} />
      </main>
      <Form
        form={form}
        className="footer"
        layout="vertical"
        onFinish={onSubmit}
      >
        <Form.Item
          name="text"
          rules={[{ required: true, message: "请输入消息" }]}
        >
          <Input.TextArea ref={inputRef} rows="5" placeholder="请输入消息" />
        </Form.Item>
        <div className="form-footer">
          <div className="status">
            {connected ? (
              <Badge status="success" text="连接正常" />
            ) : (
              <Badge status="error" text="正在连接..." />
            )}
            {id && (
              <>
                <Divider type="vertical" />
                {id}
              </>
            )}
          </div>
          <Button type="primary" htmlType="submit">
            提交
          </Button>
        </div>
      </Form>
    </div>
  );
}

export default React.memo(App, () => true);
