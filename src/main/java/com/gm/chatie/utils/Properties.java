package com.gm.chatie.utils;

import com.gm.chatie.exception.ChatieException;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class Properties extends java.util.Properties{
    private static Properties ourInstance = new Properties();

    public static Properties getInstance() {
        return ourInstance;
    }

    private Properties() {
    }


    @Override
    public String getProperty(String key) {
        if (super.size() == 0){
            try {
                generateProperties();
            } catch (ChatieException e) {
                return "";
            }
        }
        return super.getProperty(key)==null?"":super.getProperty(key);
    }

    private void generateProperties() throws ChatieException {
        try {
            super.load(Properties.class.getResourceAsStream("/chatie.properties"));
        } catch (IOException e) {
            throw new ChatieException(e);
        }
    }
}
