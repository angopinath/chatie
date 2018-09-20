package com.gm.chatie.pojo;

import java.math.BigInteger;

public class User {
    private BigInteger uid;
    private String name;

    public User(BigInteger uid, String name) {
        this.uid = uid;
        this.name = name;
    }

    public BigInteger getUid() {
        return uid;
    }

    public void setUid(BigInteger uid) {
        this.uid = uid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
