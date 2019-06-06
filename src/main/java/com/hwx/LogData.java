package com.hwx;

public class LogData {
    private String errortime;
    private String path;
    private String level;
    private String exceptionclass;
    private String exceptiondata;
    private String causedbyclass;
    private String causedbydata;
    private String errordata;

    public LogData(String path, String errortime, String level, String exceptionclass, String exceptiondata, String causedbyclass, String causedbydata, String errordata) {
        this.errortime = errortime;
        this.level = level;
        this.exceptionclass = exceptionclass;
        this.exceptiondata = exceptiondata;
        this.causedbyclass = causedbyclass;
        this.causedbydata = causedbydata;
        this.errordata = errordata;
        this.path = path;
    }


    @Override
    public String toString() {
        return   "errortime =" + errortime +
                ", level =" + level +
                ", exceptionclass =" + exceptionclass +
                ", exceptiondata =" + exceptiondata  +
                ", causedbyclass =" + causedbyclass  +
                ", causedbydata =" + causedbydata  +
                ", errordata =" +  errordata +
                ", path =" + path ;
    }

    public String getKey() {
        String key ;

        if (causedbyclass != null && causedbyclass.length() != 0) {
            key = level + ":" + causedbyclass;
        } else {
            key = level + ":" + exceptionclass;
        }
        return key;
    }

    public String getPath() {
        return path;
    }

    public String getErrordata() {
        return errordata;
    }

    public String getErrortime() {
        return errortime;
    }

    public String getLevel() {
        return level;
    }

    public String getExceptionclass() {
        return exceptionclass;
    }

    public String getExceptiondata() {
        return exceptiondata;
    }

    public String getCausedbyclass() {
        return causedbyclass;
    }

    public String getCausedbydata() {
        return causedbydata;
    }
}
