/*
 * ServletArbol.java
 *
 * Created on 20 de mayo de 2008, 16:53
 */

package com.cofar.servlet;
import com.cofar.web.ManagedAccesoSistema;
import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Wilmer Manzaneda Chavez
 * @version
 */
public class ServletUsuariosCronos extends HttpServlet {
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    private Connection con;
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
        String driver=config.getServletContext().getInitParameter("driver");
        String uri=config.getServletContext().getInitParameter("uri");
        String user=config.getServletContext().getInitParameter("user");
        String password=config.getServletContext().getInitParameter("password");
        String database=config.getServletContext().getInitParameter("database");
        String host=config.getServletContext().getInitParameter("host");
        try {
            String url="";
            Class.forName(driver);
            if(!uri.equalsIgnoreCase("none")){
                url="jdbc:odbc:"+uri;
                System.out.println("url:"+url);
                con=DriverManager.getConnection(url,user,password);
            }else{
                url="jdbc:sqlserver://"+host+";user="+user+";password="+password+";databaseName="+database;
                System.out.println("url:"+url);
                con=DriverManager.getConnection(url);
            }
            
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch(SQLException e1){
            e1.printStackTrace();
        }
    }
    
    /**
     * Este metodo nos genera un organigrama
     */
    public void organigramaempresaDos(HttpServletRequest request, HttpServletResponse response) throws IOException{
/*        String codigo=request.getParameter("codigo");
        String nombreAreaEmpresaPrincipal="gabriela";
        codigo=(codigo==null)?"":codigo;*/
        String codTipoAlmacenVenta="";
        //Object obj=request.getSession().getAttribute("ManagedAccesoSistema");
        String codPersonal=request.getParameter("codigo");
        //String codPersonal="7";
        System.out.println("codPersonal**********:"+codPersonal);
        try {
            String codigo="0";
            String nombre_ventana="";
            String sql1=" select  nombre_ventana ";
            sql1+=" from  ventanas_compras  ";
            sql1+=" where codigo_ventana="+codigo;
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
            generaMenuXml(codigo,codPersonal,writer);
            writer.write("</tree>");
            writer.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void  generaMenuXml(String codigo, String codigoPersonal,PrintWriter writer) throws IOException{
        
        try {
            String sql1="select codigomenubloque,nombrebloque";
            sql1+=" from bloquesmenu_compras";
            sql1+=" order by orden asc " ;
            
            System.out.println("generaMenuXml:"+sql1);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql1);
            rs1.last();
            int row=0;
            row=rs1.getRow();
            //System.out.println("row:"+row);
            rs1.first();
            for(int i=1;i<=row;i++){
                String codBloque=rs1.getString(1);
                String nombreBloque=rs1.getString(2);
                
                writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\""+nombreBloque+"\" nodeLink=\"../filiales/navegador_filiales.jsf\"  nodeName=\""+codBloque+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/folder.gif\"  />\n");
                
                String sql2=" select v.codigo_ventana,v.nombre_ventana ";
                sql2+=" from ventanas_compras v,usuarios_accesos_modulos u";
                sql2+=" where v.codigo_ventana=u.codigo_ventana and u.cod_modulo=1 ";
                sql2+=" and u.cod_personal="+codigoPersonal;
                sql2+=" and v.codigo_bloque="+codBloque;
                sql2+=" order by v.nombre_ventana ";
                System.out.println("Usuarios Acceso:"+sql2);
                //int filas=obtenerCantidad(codVentana);
                Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2=st2.executeQuery(sql2);
                while(rs2.next()){
                    String codVentana=rs2.getString(1);
                    String nombreVentana=rs2.getString(2);
                    writer.write("<treeNode hasChildNodes=\"false\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\"../filiales/navegador_filiales.jsf\"  nodeName=\""+codVentana+"\" nodeParent=\""+codBloque+"\" nodeIcon=\"../img/b.bmp\"  />\n");
                }
                if(rs2!=null){
                    rs2.close();
                    st2.close();
                }
                rs1.next();
            }
            if(rs1!=null){
                rs1.close();
                st1.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        
    }
    
    
    public void  generaMenuXmlVentas(String codigo, String cod_perfil,PrintWriter writer) throws IOException{
        
        try {
            String sql1="select cod_ventana, nombre_ventana,url_ventana ";
            sql1+=" from ventanas_ventas";
            sql1+=" where cod_ventanapadre="+codigo+"" +
                    " order by orden asc";
            System.out.println("generaMenuXml:"+sql1);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql1);
            rs1.last();
            int row=0;
            row=rs1.getRow();
            //System.out.println("row:"+row);
            rs1.first();
            for(int i=1;i<=row;i++){
                String codVentana=rs1.getString("cod_ventana");
                String nombreVentana=rs1.getString("nombre_ventana");
                String urlVentana=rs1.getString("url_ventana");
                String sql2=" select * ";
                sql2+=" from perfil_acceso_ventana";
                sql2+=" where cod_perfil="+cod_perfil;
                sql2+=" and  cod_ventana="+codVentana;
                System.out.println("Usuarios Acceso:"+sql2);
                int filas=obtenerCantidad(codVentana);
                Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2=st2.executeQuery(sql2);
                rs2.last();
                int row2=0;
                row2=rs2.getRow();
                //System.out.println("row:"+row2);
                rs2.first();
                if(rs2!=null){
                    rs2.close();
                    st2.close();
                }
                if(row2>0){
                    if(filas>0)
                        writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/folder.gif\"  />\n");
                    else
                        writer.write("<treeNode hasChildNodes=\"false\"  nodeLabel=\""+nombreVentana+"\" nodeLink=\""+urlVentana+"\" nodeName=\""+codVentana+"\" nodeParent=\""+codigo+"\" nodeIcon=\"../img/b.bmp\"  />\n");
                }
                rs1.next();
                generaMenuXml(codVentana,cod_perfil,writer);
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
            String sql=" select  count(*)";
            sql+=" from ventanas_ventas ";
            sql+=" where cod_ventanapadre="+codigo;
            // System.out.println("sql1_areadependiente"+sql1);
            Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1=st1.executeQuery(sql);
            
            if(rs1.next()){
                rows=rs1.getInt(1);
            }
            
            if(rs1!=null){
                rs1.close();
                st1.close();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
        
        
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
        System.out.println("entrooooooooooooooooooooooooooooooooooo");
        organigramaempresaDos(request,response);
        
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        organigramaempresaDos(request,response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
    
}
