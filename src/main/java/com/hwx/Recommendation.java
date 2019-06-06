package com.hwx;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Map;
import java.io.File;
import java.util.Scanner;


public class Recommendation {

    @Override
    public String toString() {
        return "key=" + key + ",level=" + level + ", exceptionclass=" + exceptionclass + ",resolution=" + resolution;
    }

    private String key;
    private String level;
    private String exceptionclass;
    private String exceptiondata;
    private String causedbyclass;
    private String causedbydata;
    private String resolution;


    public Recommendation(String key, String level, String exceptionclass, String exceptiondata, String causedbyclass, String causedbydata, String resolution) {
        this.key = key;
        this.level = level;
        this.exceptionclass = exceptionclass;
        this.exceptiondata = exceptiondata;
        this.causedbyclass = causedbyclass;
        this.causedbydata = causedbydata;
        this.resolution = resolution;
    }


    public String getKey() {
        return key;
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

    public String getResolution() {
        return resolution;
    }


}
