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
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author levi
 * @version
 */
public class ServletUsuarios extends HttpServlet {

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
  /*  private Connection con;
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxx");
        String driver=config.getServletContext().getInitParameter("driver");
        //String url=config.getServletContext().getInitParameter("url");
        String user=config.getServletContext().getInitParameter("user");
        String password=config.getServletContext().getInitParameter("password");
        String database=config.getServletContext().getInitParameter("database");
        String host=config.getServletContext().getInitParameter("host");
        try {
            String url="jdbc:sqlserver://"+host+";user="+user+";password="+password+";databaseName="+database;


            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            con=DriverManager.getConnection("jdbc:odbc:rrhh","sa","n3td4t4");


        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch(SQLException e1){
            e1.printStackTrace();
        }
    }
    /*public Connection connect(Connection con){
        if(con==null){

        }

    }*/

    private Connection con;
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
        
    }
    /**
     * Este metodo nos genera un organigrama
     */
    public void organigramaempresaDos(HttpServletRequest request, HttpServletResponse response) throws IOException{
        String codTipoAlmacenVenta="", codigoPersonal="";
        
        Object obj=request.getSession().getAttribute("ManagedAccesoSistema");
        if(obj!=null)
        {
            ManagedAccesoSistema var=(ManagedAccesoSistema)obj;
            codigoPersonal=var.getUsuarioModuloBean().getCodUsuarioGlobal();
            
        }

        try {
            String codigo="1";
            response.setContentType("text/xml");
            PrintWriter writer=response.getWriter();
            writer.write("<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n");
            writer.write("<tree>\n");
            writer.write("<iconElement iconMas=\"../img/1.gif\" iconMenos=\"../img/2.gif\" iconFin=\"../img/3.gif\" />\n");
            writer.write("<treeNode hasChildNodes=\"true\"  nodeLabel=\"MINKAPROD\" nodeLink=\"../filiales/navegador_filiales.jsf\" nodeName=\""+codigo+"\" nodeParent=\"root\" nodeIcon=\"../img/folder.gif\"  />\n");
            //generaMenuXml(codigo,codigoPersonal,codTipoAlmacenVenta,writer);
            generar(codigoPersonal,writer);
            writer.write("</tree>");
            writer.close();

        } 
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void generar(String codigoPersonal,PrintWriter writer)
    {
        try
        {
            con=Util.openConnection(con);
            StringBuilder consulta=new StringBuilder(" select va.COD_VENTANA,va.NOMBRE_VENTANA,va.URL_VENTANA,va.COD_VENTANAPADRE,");
                            consulta.append(" (select COUNT(*) from VENTANAS_ATLAS va1 where va1.COD_VENTANAPADRE=va.COD_VENTANA) as cantidadPadre");
                            consulta.append(" from USUARIOS_MODULOS um")
                                            .append(" inner join PERFIL_ACCESO_VENTANA_ATLAS pav on pav.COD_PERFIL = um.COD_PERFIL")
                                            .append(" inner join VENTANAS_ATLAS va on va.COD_VENTANA = pav.COD_VENTANA")
                                    .append(" where um.COD_MODULO = 6 ")
                                    .append(" and um.COD_PERSONAL = '").append(codigoPersonal).append("'");
                            consulta.append(" group by va.COD_VENTANA,va.NOMBRE_VENTANA,va.URL_VENTANA,va.COD_VENTANAPADRE,va.ORDEN ");
                            consulta.append(" ORDER BY case when va.COD_VENTANAPADRE=1 and va.ORDEN > 0 then va.ORDEN else 10000");
                            consulta.append(" end,va.NOMBRE_VENTANA");
            System.out.println("consulta ventanas "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            while(res.next())
            {
                writer.write("<treeNode hasChildNodes=\""+(res.getInt("cantidadPadre")>0?"true":"false")+"\"  nodeLabel=\""+res.getString("NOMBRE_VENTANA")+
                        "\" nodeLink=\""+res.getString("URL_VENTANA")+"\" nodeName=\""+res.getInt("COD_VENTANA")+"\" nodeParent=\""+res.getInt("COD_VENTANAPADRE")+"\" nodeIcon=\"../img/"+(res.getInt("cantidadPadre")>0?"folderCerrado.jpg":"b.bmp")+"\" nodoPadre=\""+(res.getInt("cantidadPadre") > 0 ? "true" : "false")+"\"  />\n");
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public void  generaMenuXml(String codigo, String codigoPersonal,String codTipoAlmacenVenta,PrintWriter writer) throws IOException{
        try {
            String sql1="select cod_ventana, nombre_ventana,url_ventana ";
            sql1+=" from ventanas_atlas";
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
                sql2+=" from usuarios_accesos_modulos";
                sql2+=" where cod_modulo=6 ";
                sql2+=" and cod_personal="+codigoPersonal;
                sql2+=" and codigo_ventana="+codVentana;
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
                generaMenuXml(codVentana,codigoPersonal,codTipoAlmacenVenta,writer);

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
            sql+=" from ventanas_atlas ";
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
