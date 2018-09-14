package com.gm.chatie.exception;

public class ChatieException extends  Exception{
    public ChatieException() {
        super();
    }

    public ChatieException(String message) {
        super(message);
    }

    public ChatieException(String message, Throwable cause) {
        super(message, cause);
    }

    public ChatieException(Throwable cause) {
        super(cause);
    }

    protected ChatieException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
