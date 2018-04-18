/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author DASISAQ-
 */
public class NewClass222 {
         private static Logger LOGGER=LogManager.getRootLogger();
    
    public static void main(String[] args) {
     
        Double a=new Double(8912.595);
        BigDecimal decimal=new BigDecimal(a.toString());
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_HALF_EVEN));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_CEILING));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_DOWN));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_FLOOR));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_HALF_DOWN));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_HALF_UP));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_UP));
        LOGGER.debug("b");
        a=new Double(8912.585);
        decimal=new BigDecimal(a);
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_HALF_EVEN));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_CEILING));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_DOWN));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_FLOOR));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_HALF_DOWN));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_HALF_UP));
        LOGGER.debug(decimal.setScale(2, BigDecimal.ROUND_UP));
        
        
    }
}
