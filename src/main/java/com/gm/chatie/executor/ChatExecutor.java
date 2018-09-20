package com.gm.chatie.executor;

import com.gm.chatie.exception.ChatieException;
import com.gm.chatie.pojo.Chat;
import com.gm.chatie.pojo.Message;
import com.gm.chatie.pojo.User;
import com.gm.chatie.utils.Web3jClient;
import org.web3j.tuples.generated.Tuple2;
import org.web3j.tuples.generated.Tuple4;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ChatExecutor implements Executor {

    private Web3jClient web3jClient;

    public ChatExecutor(Web3jClient web3jClient) {
        this.web3jClient = web3jClient;
    }

    @Override
    public boolean createAccount(BigInteger uid, String username, byte[] password) throws ChatieException {
        try {
            web3jClient.getContract().createAccount(uid,username,new String(password, StandardCharsets.UTF_8)).send();
            return true;
        } catch (Exception e) {
            throw new ChatieException(e);
            
        }
    }

    @Override
    public boolean authenticate(BigInteger uid, byte[] password) throws ChatieException {
        try {
            return web3jClient.getContract().authenticate(uid,new String(password, StandardCharsets.UTF_8)).send();
        } catch (Exception e) {
            throw new ChatieException(e);
            
        }
    }

    @Override
    public List<Chat> syncMessages(BigInteger uid) throws ChatieException {
        try {
            Tuple4<List<BigInteger>, List<byte[]>, List<BigInteger>, List<BigInteger>> items = web3jClient.getContract().syncMessages(uid).send();
            int size=items.getValue1().size();
            List<Chat> chats = new ArrayList<Chat>();
            for (int i=0;i<size;i++){
                chats.add(new Chat(new User(items.getValue1().get(i),new String(items.getValue2().get(i),StandardCharsets.UTF_8)),items.getValue3().get(i),items.getValue4().get(i)));
            }
            return chats;
        } catch (Exception e) {
            throw new ChatieException(e);
        }
    }

    @Override
    public boolean sendMessage(BigInteger uid, BigInteger fuid, String msg) throws ChatieException {
        try {
            web3jClient.getContract().sendMessage(uid,fuid,msg).send();
            return true;
        } catch (Exception e) {
            throw new ChatieException(e);
            
        }
    }

    @Override
    public List<Message> getMessages(BigInteger uid, BigInteger fuid) throws ChatieException {
        try {
            List<String> messages=web3jClient.getContract().getMessages(uid,fuid).send();
            return  messages.stream().map(s -> {
                String[] array= s.split("|");
                return new Message(Integer.parseInt(array[0]),array[1],new User(new BigInteger(array[2]),null),Integer.parseInt(array[3]));
            }).collect(Collectors.toList());
        } catch (Exception e) {
            throw new ChatieException(e);

        }
    }

    @Override
    public List<User> searchAccounts(BigInteger uid) throws ChatieException {
        List<User> users = new ArrayList<User>();
        try {
            Tuple2<BigInteger, String> items = web3jClient.getContract().searchAccount(uid).send();
            users.add(new User(items.getValue1(),items.getValue2()));
            return users;
        } catch (Exception e) {
            throw new ChatieException(e);

        }
    }

    @Override
    public boolean sendFriendRequest(BigInteger uid, BigInteger fuid) throws ChatieException {
        try {
            web3jClient.getContract().sendFriendRequest(uid,fuid).send();
            return true;
        } catch (Exception e) {
            throw new ChatieException(e);
            
        }
    }

    @Override
    public boolean acceptFriendRequest(BigInteger uid, BigInteger fuid) throws ChatieException {
        try {
            web3jClient.getContract().acceptFriendRequest(uid,fuid).send();
            return true;
        } catch (Exception e) {
            throw new ChatieException(e);
            
        }
    }

    @Override
    public boolean clearMessages(BigInteger uid, BigInteger fuid) throws ChatieException {
        try {
            web3jClient.getContract().clearMessages(uid,fuid).send();
            return true;
        } catch (Exception e) {
            throw new ChatieException(e);
            
        }
    }
}
