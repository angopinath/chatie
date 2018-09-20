package com.gm.chatie.pojo;

public class Message {
    private int msgId;
    private String message;
    private User sender;
    private long createdAt;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public User getSender() {
        return sender;
    }

    public void setSender(User sender) {
        this.sender = sender;
    }

    public long getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(long createdAt) {
        this.createdAt = createdAt;
    }

    public Message(int msgId, String message, User sender, long createdAt) {
        this.msgId = msgId;
        this.message = message;
        this.sender = sender;
        this.createdAt = createdAt;
    }

    public int getMsgId() {
        return msgId;
    }

    public void setMsgId(int msgId) {
        this.msgId = msgId;
    }
}
