<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>

<%
    int codPersonal = Integer.valueOf(request.getParameter("codPersonal"));
    Connection con = null;
    String datosUsuario = "";
    try
    {
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select um.NOMBRE_USUARIO,um.CONTRASENA_USUARIO")
                                                .append(" ,STUFF((select ','+ mer.NOMBRE_MODULO")
                                                .append(" from USUARIOS_MODULOS um1")
                                                        .append(" inner join MODULOS_ERP mer on mer.COD_MODULO = um1.COD_MODULO")
                                                .append(" where um1.COD_PERSONAL = um.COD_PERSONAL")
                                        .append(" FOR XML PATH('') ),1,1,'') as nombreModulo")
                                        .append(" from USUARIOS_MODULOS um ")
                                                .append(" inner join personal p on p.COD_PERSONAL = um.COD_PERSONAL")
                                        .append(" where um.COD_PERSONAL =").append(codPersonal);
        System.out.println("consulta verificar usuario creado: "+consulta.toString());
        Statement st = con.createStatement();
        ResultSet res = st.executeQuery(consulta.toString());
        if(res.next()){
            datosUsuario="nombreUsuario:'"+res.getString("NOMBRE_USUARIO")+"',usuarioExistente:1,contrasenia:'La misma que tiene en el/los sistema(s):<b>"+res.getString("nombreModulo")+"</b>'";
        }
        else{
            consulta = new StringBuilder("select isnull(p.AP_PATERNO_PERSONAL,'') as AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL")
                                .append(" from personal p where p.COD_PERSONAL=").append(codPersonal);
            System.out.println("consulta datos personal: "+consulta.toString());
            res = st.executeQuery(consulta.toString());
            String nombrePersonal = "";
            String apellidoPersonal = "";
            if(res.next()){
                 nombrePersonal = res.getString("NOMBRES_PERSONAL").toLowerCase();
                 apellidoPersonal = res.getString("AP_PATERNO_PERSONAL").toLowerCase();
                 if(apellidoPersonal.trim().length() == 0)apellidoPersonal = res.getString("AP_MATERNO_PERSONAL").toLowerCase();
                 System.out.println("nombre:"+nombrePersonal+" ap:"+apellidoPersonal);
            }
            consulta = new StringBuilder("select count(*) as cantidadCoincidencias")
                                        
                                .append(" from USUARIOS_MODULOS um ")
                                .append(" where um.NOMBRE_USUARIO = ?");
            System.out.println("consulta verificar usuario :"+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            String nombreUsuarioNuevo = nombrePersonal.substring(0, 1)+apellidoPersonal;
            pst.setString(1,nombreUsuarioNuevo);System.out.println("p1:"+nombreUsuarioNuevo);
            res= pst.executeQuery();
            res.next();
            if(res.getInt("cantidadCoincidencias") > 0){
                System.out.println("tiene coincidencias probando otro usuario:");
                nombreUsuarioNuevo =nombrePersonal.substring(0, 1)+"."+apellidoPersonal;
                pst.setString(1,nombreUsuarioNuevo);System.out.println("p1:"+nombreUsuarioNuevo);
                res= pst.executeQuery();
                res.next();
                if(res.getInt("cantidadCoincidencias") > 0){
                    System.out.println("tiene coincidencias probando otro usuario:");
                    nombreUsuarioNuevo =nombrePersonal+apellidoPersonal;
                    pst.setString(1,nombreUsuarioNuevo);System.out.println("p1:"+nombreUsuarioNuevo);
                    res= pst.executeQuery();
                    res.next();
                    if(res.getInt("cantidadCoincidencias") > 0){
                        nombreUsuarioNuevo = "no asignable consulte con sistemas";
                    }
                }
                
            }
            datosUsuario="nombreUsuario:'"+nombreUsuarioNuevo+"',usuarioExistente:0,contrasenia:'la contraseña sera el nro de C.I. de la persona, ejemplo 2415365 LP'";
        }
        con.commit();
    }
    catch(SQLException ex) 
    {
        ex.printStackTrace();
        datosUsuario ="nombreUsuario:'',contrasenaUsuario:''";
    }
    catch(Exception ex) 
    {
        ex.printStackTrace();
        datosUsuario ="nombreUsuario:'',contrasenaUsuario:''";
    }
    finally
    {
        con.close();
    }
    out.clear();
    System.out.println(datosUsuario);
    out.println(datosUsuario);
%>


