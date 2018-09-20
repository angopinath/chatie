package com.gm.chatie.executor;

import com.gm.chatie.exception.ChatieException;
import com.gm.chatie.pojo.Chat;
import com.gm.chatie.pojo.Message;
import com.gm.chatie.pojo.User;

import java.math.BigInteger;
import java.util.List;

public interface Executor {
    public boolean createAccount(BigInteger uid, String username, byte[] password) throws ChatieException;
    public boolean authenticate(BigInteger uid, byte[] password) throws ChatieException;
    public List<Chat> syncMessages(BigInteger uid) throws ChatieException;
    public boolean sendMessage(BigInteger uid, BigInteger fuid, String msg) throws ChatieException;
    public List<Message> getMessages(BigInteger uid, BigInteger fuid) throws ChatieException;
    public List<User> searchAccounts(BigInteger uid) throws ChatieException;
    public boolean sendFriendRequest(BigInteger uid, BigInteger fuid) throws ChatieException;
    public boolean acceptFriendRequest(BigInteger uid, BigInteger fuid) throws ChatieException;
    public boolean clearMessages(BigInteger uid, BigInteger fuid) throws ChatieException;

}
