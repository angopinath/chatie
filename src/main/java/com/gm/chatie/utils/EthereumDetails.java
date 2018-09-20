package com.gm.chatie.utils;

import java.io.IOException;
import java.util.Properties;

public class EthereumDetails {
    private static EthereumDetails ourInstance = new EthereumDetails();
    private Properties prop = new Properties();

    public static EthereumDetails getInstance() {
        return ourInstance;
    }

    private EthereumDetails() {
    }

    public String getProp(String key) {
        if ( prop.size() == 0 ){
            try {
                prepareProp();
            } catch (IOException e) {
                return "";
            }
        }
        return prop.getProperty(key) == null ? "" : prop.getProperty(key);
    }

    private void prepareProp() throws IOException {
        prop.load(EthereumDetails.class.getResourceAsStream("/ether.properties"));
    }
}
