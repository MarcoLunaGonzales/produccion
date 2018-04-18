/*
 * Util.java
 * Created on 11 de febrero de 2008, 16:53
 *
 */

package com.cofar.util;

import com.cofar.web.ManagedAccesoSistema;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Map;
import java.util.Properties;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.dbcp.BasicDataSource;



/**
 * @author Wilmer Manzaneda Chavez
 */
public class Util {
    
    /** Creates a new instance of Util */
    private static BasicDataSource datasource=null;
    private static String driver=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("driver");
    // private static String url=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("url");
    private static String user=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("user");
    private static String password=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("password");
    private static String host=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("host");
    private static String database=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("database");
    private static String uri=FacesContext.getCurrentInstance().getExternalContext().getInitParameter("uri");
    
    
    
    
    public Util() {
        
        
    }
    public static Connection openConnectionMySql()throws SQLException
    {
        Connection conMySql=null;
        try
        {
            BasicDataSource basicDataSource=new BasicDataSource();
            basicDataSource.setUrl("jdbc:mysql://www.cofar.com.bo/cofar_visitamedica");
            basicDataSource.setDriverClassName("com.mysql.jdbc.Driver");
            basicDataSource.setUsername("cofar_marco");
            basicDataSource.setPassword("4868422");
            basicDataSource.setInitialSize(6);
            basicDataSource.setMaxActive(2000);
            basicDataSource.setMaxWait(60000);
            conMySql=basicDataSource.getConnection();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return conMySql;
    }
    /**
     * Metodo que realiza la conexion a la base de datos
     * nos retorna una conexion
     * @param Connecticon este parametro se refiere a la conexion actual
     * @return Connection con
     */
    public static Connection openConnection(Connection connection) throws SQLException{
        if(connection!=null){
            if(connection.isClosed()){
                connection=getConnectionPool();
            }
        } else{
            connection=getConnectionPool();
        }
        return connection;
    }
    /**
     * Metodo que realiza la conexion a la base de datos
     * nos retorna una conexion
     * @return Connection con
     */
    private static Connection getConnectionPool()
    {
        Connection con=null;
        try
        {
            if(datasource==null)
            {
                BasicDataSource basicDataSource=new BasicDataSource();
                basicDataSource.setUrl("jdbc:sqlserver://"+host+";databaseName="+database);
                basicDataSource.setDriverClassName(driver);
                basicDataSource.setUsername(user);
                basicDataSource.setPassword(password);
                basicDataSource.setInitialSize(6);
                basicDataSource.setMaxActive(2000);
                basicDataSource.setMaxWait(60000);
                datasource=basicDataSource;
            }
            System.out.println("conexion "+datasource.getNumActive());
            con=datasource.getConnection();
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            st.close();
        } 
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        return con;
    }
    private  static Connection getConnection(){
        Connection con=null;
        try {
            String url="";
            Class.forName(driver);
            if(!uri.equalsIgnoreCase("none")){
                url="jdbc:odbc:"+uri;
                //System.out.println("url:"+url);
                con=DriverManager.getConnection(url,user,password);
            }else{
                url="jdbc:sqlserver://"+host+";user="+user+";password="+password+";databaseName="+database;
                //System.out.println("url:"+url);
                con=DriverManager.getConnection(url);
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                st1.executeUpdate("set DATEFORMAT ymd");
                //System.out.println("pasosososososo");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch(SQLException e1){
            e1.printStackTrace();            
        }
        return con;
    }
    /**
     * metodo que nos retorna un objeto
     * que se encuentra en session
     * @param namebean es el nombre del objeto que queremos que
     *  nos retorne
     */
    public static Object getSessionBean(String namebean){
        Map map=FacesContext.getCurrentInstance().getExternalContext().getSessionMap();
        return map.get(namebean);
    }
    /**
     * metodo que nos retorna un objeto
     * que se encuentra en session
     * @param nameobjectsession es el nombre del objeto que queremos que
     *  nos retorne
     */
    
    public static Object getSession(String nameobjectsession){
        HttpServletRequest request   =(HttpServletRequest )FacesContext.getCurrentInstance().getExternalContext().getRequest();
        return  request.getSession().getAttribute(nameobjectsession);
    }
    /**
     * metodo que nos retorna un String
     * que se encuentra en session
     * @param nameobjectsession es el nombre del objeto que queremos que
     *  nos retorne
     */
    
    public static String getParameter(String name){
        HttpServletRequest request   =(HttpServletRequest )FacesContext.getCurrentInstance().getExternalContext().getRequest();
        return  request.getParameter(name);
    }
    public static Date converterStringDate(String fecha){
        String values[]=fecha.split("/");
        if(values.length==0){
            throw new java.lang.IllegalArgumentException();
        }
        String format=values[2]+"-"+values[1]+"-"+values[0];
        Date date=java.sql.Date.valueOf(format);
        return date;
        
    }

  public static void setSession(String name,Object obj){
        HttpServletRequest request   =(HttpServletRequest )FacesContext.getCurrentInstance().getExternalContext().getRequest();
        request.setAttribute(name,obj);
    }
    public static void removeSession(String name){
        HttpServletRequest request   =(HttpServletRequest )FacesContext.getCurrentInstance().getExternalContext().getRequest();
        request.getSession().removeAttribute(name);
    }
    public static String enviarCorreo(String codPersonal,String mensaje,String asunto,String enviadoPor){
         try {
             ManagedAccesoSistema bean1 = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
             String consulta = " select nombre_correopersonal from correo_personal c where c.cod_personal in ("+ codPersonal +") ";
             System.out.println("consulta--------------> " + consulta);
             String[] codPersonaArray = codPersonal.split(",");
             Connection con = null;
             con = Util.openConnection(con);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet rs = st.executeQuery(consulta);
             rs.last();
             InternetAddress emails[] = new InternetAddress[rs.getRow()];
             rs.beforeFirst();
             int i = 0;
             while(rs.next()){
             emails[i]=new InternetAddress(rs.getString("nombre_correopersonal")); 
             i++;
             }
             Properties props = new Properties();
             props.put("mail.smtp.host", "mail.cofar.com.bo");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "false");
             props.setProperty("mail.user", "traspasos@cofar.com.bo");
             props.setProperty("mail.password", "n3td4t4");
             Session mailSession = Session.getInstance(props, null);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject(asunto);
             msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", enviadoPor));
             msg.addRecipients(Message.RecipientType.TO, emails);
             
             String contenido = " <html> <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body>" + mensaje +
                     " </body> </html> " ;

            msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
    public static String redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public static double redondeoProduccionSuperior(double numero, int decimales) 
    {
        BigDecimal decimal=new BigDecimal(String.valueOf(numero));
        return decimal.setScale(decimales,RoundingMode.HALF_UP).doubleValue();
    }
    public static Timestamp fechaParametro(java.util.Date fecha){
        if(fecha != null){
            return new Timestamp(fecha.getTime());
        }
        else{
            return null;
        }
    }
}
