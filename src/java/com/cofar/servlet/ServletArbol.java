/*
 * ServletArbol.java
 *
 * Created on 20 de mayo de 2008, 16:53
 */

package com.cofar.servlet;
import com.cofar.util.Util;
import com.cofar.web.ManagedAccesoSistema;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.sql.DataSource;

/**
 *
 * @author Wilmer Manzaneda Chavez
 * @version
 */
public class ServletArbol extends HttpServlet {
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    private Connection con;
    
    private String driver="";
    private String uri="";
    private String user="";
    private String password="";
    private String database="";
    private String host="";
    
    private DataSource source;
    
    SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
    
    public void connect() {
        try {
            
            
            con=Util.openConnection(con);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
        /*
         
        try {
            String url="";
         
         
            if(!uri.equalsIgnoreCase("none")){
         
                System.out.println("uri:"+url);
         
         
                try {
         
                       InitialContext  initCtx = new InitialContext();
                       source=(DataSource) initCtx.lookup("java:comp/env/"+uri);
                       con=source.getConnection();
         
         
         
         
                } catch (NamingException e) {
                    e.printStackTrace();
                }
         
         
         
         
         
            }else{
                 Class.forName(driver);
         
                url="jdbc:sqlserver://"+host+";user="+user+";password="+password+";databaseName="+database;
                System.out.println("url:"+url);
                con=DriverManager.getConnection(url);
         
         
         
         
         
            }
         
         
         
         
         
         
         
         
         
         
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch(SQLException e1){
            e1.printStackTrace();
        }
         */
        
    }
    
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
        driver=config.getServletContext().getInitParameter("driver");
        uri=config.getServletContext().getInitParameter("uri");
        user=config.getServletContext().getInitParameter("user");
        password=config.getServletContext().getInitParameter("password");
        database=config.getServletContext().getInitParameter("database");
        host=config.getServletContext().getInitParameter("host");
        if(con==null)
            connect();
        
        
        
        
    }
    /**
     * Este metodo nos genera un organigrama
     */
    public void organigramaempresaDos(HttpServletRequest request, HttpServletResponse response) throws IOException{
        
        if(con==null)
            connect();
        
        String codTipoAlmacenVenta="", codigoPersonal="";
        Object obj=request.getSession().getAttribute("ManagedAccesoSistema");
        if(obj!=null){
            ManagedAccesoSistema var=(ManagedAccesoSistema)obj;
            System.out.println("Tipo"+var.getCodigoTipoAlmacenVentaGlobal());;
            System.out.println("Usuario"+ var.getUsuarioModuloBean().getCodUsuarioGlobal());
            codTipoAlmacenVenta=var.getCodigoTipoAlmacenVentaGlobal();
            codigoPersonal=var.getUsuarioModuloBean().getCodUsuarioGlobal();
        }
        try {
            String codigo="1";
            String nombre_ventana="";
            String sql1=" select  nombre_ventana ";
            sql1+=" from  ventanas_ventas  ";
            sql1+=" where cod_ventana="+codigo;
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql1);
            while (rs1.next()){
                nombre_ventana=(rs1.getString("nombre_ventana"));
            }
            if(rs1!=null){
                rs1.close();
                st1.close();
            }
            response.setContentType("text/xml");
            PrintWriter writer=response.getWriter();
            
            
            writer.write("<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n");
            writer.write("<tree>\n");
            writer.write("<iconElement iconMas=\"../img/1.gif\" iconMenos=\"../img/2.gif\" iconFin=\"../img/3.gif\" />\n");
            writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\""+nombre_ventana+"\" nodeLink=\"../filiales/navegador_filiales.jsf\" nodeName=\""+codigo+"\" nodeParent=\"root\" nodeIcon=\"../img/folder.gif\"  />\n");
            
            
            generaMenuXml(codigo,codigoPersonal,codTipoAlmacenVenta,writer);
            writer.write("</tree>");
            writer.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void  generaMenuXml(String codigo, String codigoPersonal,String codTipoAlmacenVenta,PrintWriter writer) throws IOException{
        
        
        
        try {
            String sql1="select cod_ventana, nombre_ventana,url_ventana ";
            sql1+=" from ventanas_ventas v";
            sql1+=" where cod_ventanapadre="+codigo;
            sql1+=" and v.COD_VENTANA in(select u.CODIGO_VENTANA from usuarios_accesos_modulos u where cod_modulo=4 and cod_personal="+codigoPersonal+")";
            
            //System.out.println(sql1);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql1);
            
            
            
            
            String sql="";
            while(rs1.next()){
                
                String codVentana=rs1.getString("cod_ventana");
                String nombreVentana=rs1.getString("nombre_ventana");
                String urlVentana=rs1.getString("url_ventana");
                int filas=0;
                sql=" select  count(*) from ventanas_ventas where cod_ventanapadre="+codVentana;
                
                Statement stCount=con.createStatement();
                ResultSet rsCount=stCount.executeQuery(sql);
                if(rsCount.next())
                    filas=rsCount.getInt(1);
                rsCount.close();
                stCount.close();
                
                if(filas>0)
                    writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/folder.gif\"  />\n");
                else
                    writer.write("<treeNode hasChildNodes=\"false\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/b.bmp\"  />\n");
                
                generaMenuXml(codVentana,codigoPersonal,codTipoAlmacenVenta,writer);
                
                
                /*
                String sql2=" select * ";
                sql2+=" from usuarios_accesos_modulos ";
                sql2+=" where cod_modulo=4 ";
                sql2+=" and cod_personal="+codigoPersonal;
                sql2+=" and codigo_ventana="+codVentana;
                 
                 
                Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2=st2.executeQuery(sql2);
                rs2.last();
                int row2=0;
                row2=rs2.getRow();
                 
                rs2.first();
                if(rs2!=null){
                    rs2.close();
                    st2.close();
                }
                System.out.println("row2:"+row2);
                if(row2>0){
                 
                    String bandera="0";
                    String sql3=" select  * ";
                    sql3+=" from VENTANASVENTAS_TIPOSALMACENVENTA";
                    sql3+=" where  cod_ventana="+codVentana;
                    sql3+=" and  cod_tipoalmacenventa="+codTipoAlmacenVenta;
                    Statement st3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs3=st3.executeQuery(sql3);
                    rs3.last();
                    int row3=0;
                    row3=rs3.getRow();
                 
                    rs3.first();
                 
                 
                 
                    if(filas>0) {
                        if(bandera.equals("1")) {
                 
                 
                            writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/folder.gif\"  />\n");
                        }
                    }else{
                        if(bandera.equals("1")) {
                 
                            writer.write("<treeNode hasChildNodes=\"false\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/b.bmp\"  />\n");
                        }
                    }
                }
                 */
                
                
                
                
                
            }
            
            
            if(rs1!=null){
                rs1.close();
                st1.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
    }
    
    
    public int   obtenerCantidad(String codigo) throws IOException{
        int rows=0;
        try {
            String sql=" select  count(*) from ventanas_ventas where cod_ventanapadre="+codigo;
            Statement st1=con.createStatement();
            ResultSet rs1=st1.executeQuery(sql);
            if(rs1.next())
                rows=rs1.getInt(1);
            rs1.close();
            st1.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }
    
    
    public void  generarMenuXmlOpcion(String codigo,PrintWriter writer,HttpServletRequest request) throws IOException{
        
        Object personal=request.getSession().getAttribute("codigoPersonal");
        
        if(personal!=null){
            try {
                
                
                String  codigoPersonal=request.getSession().getAttribute("codigoPersonal").toString();
                
                String sql1="select cod_ventana, nombre_ventana,url_ventana ";
                sql1+=" from ventanas_ventas v";
                sql1+=" where cod_ventanapadre="+codigo;
                sql1+=" and v.COD_VENTANA in(select u.CODIGO_VENTANA from usuarios_accesos_modulos u where cod_modulo=4 and cod_personal="+codigoPersonal+")";
                
                
                PreparedStatement st1=con.prepareStatement(sql1);
                
                ResultSet rs1=st1.executeQuery();
                
                
                
                
                
                while(rs1.next()){
                    
                    String codVentana=rs1.getString("cod_ventana");
                    String nombreVentana=rs1.getString("nombre_ventana");
                    String urlVentana=rs1.getString("url_ventana");
                    int filas=0;
                    String sql=" select  count(*) from ventanas_ventas where cod_ventanapadre="+codVentana;
                    
                    PreparedStatement stCount=con.prepareStatement(sql);
                    ResultSet rsCount=stCount.executeQuery();
                    if(rsCount.next())
                        filas=rsCount.getInt(1);
                    rsCount.close();
                    stCount.close();
                    
                    if(filas>0)
                        writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/folder.gif\"  />\n");
                    else
                        writer.write("<treeNode hasChildNodes=\"false\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/b.bmp\"  />\n");
                    
                    
                }
                
                
                if(rs1!=null){
                    rs1.close();
                    st1.close();
                }
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            
            
        }
        
        
        
        
    }
    
    
    public void  generaCadenaAreasEmpresa(String codigo,PrintWriter writer) throws IOException{
        
        try {
            String sql1=" select  adi.cod_area_inferior,ae.nombre_area_empresa ";
            sql1+=" from areas_dependientes_inmediatas adi, areas_empresa ae ";
            sql1+=" where adi.cod_area_empresa="+codigo;
            sql1+=" and  adi.cod_area_inferior=ae.cod_area_empresa";
            //System.out.println("sql1_areadependiente"+sql1);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql1);
            writer.write("<ul>");
            
            while (rs1.next()){
                writer.write("<li>");
                String codigoarea=rs1.getString(1);
                String nombrearea=rs1.getString(2);
                /*writer.write("<span>"+codigoarea+"("+ nombrearea+")</span>");*/
                writer.write("<a href=\"detalle?codigo="+codigoarea+"\" >("+ nombrearea+")</a>");
                generaCadenaAreasEmpresa(codigoarea,writer);
                //System.out.println("cod_area_inferior INFERIOR"+rs1.getString("cod_area_inferior"));
                writer.write("</li>");
            }
            writer.write("</ul>");
            if(rs1!=null){
                rs1.close();
                st1.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String organigramaempresa=request.getParameter("organigramaempresa");
        
        System.out.println("INICIO "+f.format(new java.util.Date()));
        
        organigramaempresaDos(request,response);
        
        System.out.println("FIN "+f.format(new java.util.Date()));
        
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        System.out.println("INICIO "+f.format(new java.util.Date()));
        organigramaempresaDos(request,response);
        System.out.println("FIN "+f.format(new java.util.Date()));
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
    
}
