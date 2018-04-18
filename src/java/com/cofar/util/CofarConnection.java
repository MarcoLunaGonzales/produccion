/*
 * CofarConnection.java
 *
 * Created on 28 de julio de 2008, 14:58
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.util;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author gabriela
 */
public class CofarConnection {
    
    /** Creates a new instance of CofarConnection */
    public CofarConnection() {
    }
    
    public static Connection getConnectionJsp(){
        Connection con=null;
        try{
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url="jdbc:sqlserver://172.16.10.21:1433;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS";
            con=DriverManager.getConnection(url);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st1.executeUpdate("set DATEFORMAT ymd");
            /*Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            con=DriverManager.getConnection("jdbc:odbc:rrhh","sa","n3td4t4");*/
            
        } catch(ClassNotFoundException e) {
            System.out.print("xxxxxxxxxxxxxxxxxxxxxxxxxxxx"+con);
            e.printStackTrace();
        } catch(SQLException e2) {
            e2.printStackTrace();
        }
        return con;
    }
    public static void main(String[] args) {
        Connection con=CofarConnection.getConnectionJsp();
        System.out.println("con:"+con);
    }
}
