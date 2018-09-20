package com.gm.chatie.pojo;

import java.math.BigInteger;

public class Chat {
    private User user;
    private BigInteger unreadcount;
    private BigInteger friendStatus;

    public Chat(User user, BigInteger unreadcount, BigInteger friendStatus) {
        this.user = user;
        this.unreadcount = unreadcount;
        this.friendStatus = friendStatus;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public BigInteger getUnreadcount() {
        return unreadcount;
    }

    public void setUnreadcount(BigInteger unreadcount) {
        this.unreadcount = unreadcount;
    }

    public BigInteger getFriendStatus() {
        return friendStatus;
    }

    public void setFriendStatus(BigInteger friendStatus) {
        this.friendStatus = friendStatus;
    }
}
