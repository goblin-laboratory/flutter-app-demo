import React from "react";
import { List } from "antd";
import "./index.css";

function MsgItem({ userId, info }) {
  if ("members" === info.type) {
    return (
      <div className="memberMsg">
        <span>{info.userId} </span>
        {userId === info.userId && <>(我) </>}
        {"join" === info.subType ? (
          <span>加入聊天室 ✨🎉</span>
        ) : (
          <span>离开聊天室 📞☎</span>
        )}
      </div>
    );
  }
  if ("message" === info.type) {
    return (
      <div className="textMsg">
        <span className="userInfo">
          {info.userId}
          {userId === info.userId && <>(我)</>}&nbsp;:&nbsp;
        </span>
        <span>{info.message}</span>
      </div>
    );
  }
  return null;
}

function MsgList({ userId, list }) {
  return (
    <List
      className="msgList"
      size="small"
      bordered={false}
      split={false}
      dataSource={list}
      renderItem={(item) => (
        <List.Item>
          <MsgItem info={item} userId={userId} />
        </List.Item>
      )}
    />
  );
}

export default React.memo(
  MsgList,
  (p, n) => p.list === n.list && p.userId === n.userId
);
