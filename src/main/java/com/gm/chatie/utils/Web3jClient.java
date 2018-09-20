package com.gm.chatie.utils;

import com.gm.chatie.common.Property;
import com.gm.chatie.exception.ChatieException;
import com.gm.chatie.solidity.Chatie;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.infura.InfuraHttpService;

import java.math.BigInteger;

public class Web3jClient {
    private static Web3jClient ourInstance = new Web3jClient();
    private Web3j web3j;
    private Credentials credentials;
    private Chatie chatie;

    public static Web3jClient getInstance() {
        return ourInstance;
    }

    private Web3jClient() {
    }

    public Web3j getWeb3j() {
        if(web3j!=null){
            setupWeb3j();
        }
        return web3j;
    }

    public Credentials getCredentials() throws ChatieException {
        if (credentials == null) setupCredentials();
        return credentials;
    }

    public Chatie getContract() throws ChatieException {
        if (web3j == null) setupWeb3j();
        if (credentials == null) setupCredentials();
        if (chatie == null) setupContract();
        return chatie;
    }

    private void setupContract() {
        chatie = Chatie.load(EthereumDetails.getInstance().getProp(Property.CONTRACT_ADDRESS), web3j, credentials, BigInteger.ONE, BigInteger.valueOf(3000000));
    }

    private void setupWeb3j(){
        EthereumDetails etherprop = EthereumDetails.getInstance();
        web3j = Web3j.build(new InfuraHttpService(etherprop.getProp(Property.INFURA_URL)));
    }

    private void setupCredentials() throws ChatieException {
        try {
            if (web3j == null) setupWeb3j();
            if (credentials == null){
                credentials =  Credentials.create(EthereumDetails.getInstance().getProp(Property.PRIVATE_KEY));
            }

        }catch (Exception e){
            throw  new ChatieException(e);
        }
    }
}
