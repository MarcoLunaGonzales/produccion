<%@page import="com.cofar.web.ManagedAccesoSistema"%>
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
    int COD_TIPO_TRANSACCION_EDICION = 1;
    int COD_MODULO_ATLAS = 6;
    String mensaje="";
    Connection con=null;
    try
    {
        String[] codigosVentanas=(request.getParameter("codigosVentana")).split(",");
        String[] codigosPermiso = (request.getParameter("codigosPermiso")).split(",");
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        String codPerfil=request.getParameter("codPerfil");
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("UPDATE PERFILES_USUARIOS_ATLAS");
                            consulta.append(" set NOMBRE_PERFIL=?");
                            consulta.append(" ,COD_ESTADO_REGISTRO=").append(request.getParameter("codEstadoRegistro"));
                            consulta.append(" where COD_PERFIL=").append(codPerfil);
        System.out.println("consulta update perfil "+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
        pst.setString(1,request.getParameter("nombrePerfil"));
        if(pst.executeUpdate()>0)System.out.println("Se registro el perfil");
        consulta=new StringBuilder("DELETE PERFIL_ACCESO_VENTANA_ATLAS");
                consulta.append(" WHERE COD_PERFIL=").append(codPerfil);
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.print("se eliminaron las ventanas de perfil");
        consulta=new StringBuilder(" insert into PERFIL_ACCESO_VENTANA_ATLAS(COD_PERFIL,COD_VENTANA)");
                    consulta.append(" values(");
                            consulta.append(codPerfil).append(",");
                            consulta.append("?");
                    consulta.append(")");
        pst=con.prepareStatement(consulta.toString());
        for(String codVentana:codigosVentanas)
        {
            pst.setString(1, codVentana);
            if(pst.executeUpdate()>0)System.out.println("Se registro la ventana "+codVentana);
        }
        
        consulta = new StringBuilder("DELETE PERFILES_PERMISOS_ATLAS ")
                            .append(" where COD_PERFIL =").append(codPerfil);
        System.out.println("consulta eliminar perfil usuario "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println("se elimino detalle");
        consulta = new StringBuilder("INSERT INTO PERFILES_PERMISOS_ATLAS(COD_TIPO_PERMISO_ESPECIAL_ATLAS, COD_PERFIL)")
                    .append("VALUES (")
                        .append("?,")//codigo de permiso
                        .append(codPerfil)
                    .append(")");
        pst = con.prepareStatement(consulta.toString());
        for(String codPermiso:codigosPermiso){
            pst.setString(1,codPermiso);
            if(pst.executeUpdate()>0)System.out.println("se registro permiso "+codPermiso);
        }
        consulta = new StringBuilder("DELETE CONFIGURACION_PERMISOS_ESPECIALES_ATLAS")
                            .append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpe")
                                    .append(" inner join USUARIOS_MODULOS um on um.COD_PERSONAL = cpe.COD_PERSONAL")
                                                    .append(" and um.COD_MODULO=6")
                            .append(" where um.COD_PERFIL =").append(codPerfil);
        System.out.println("consulta eliminar configuracion permiso "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println("se elimino la configuracion de personal con perfil");
            
        consulta = new StringBuilder(" insert into CONFIGURACION_PERMISOS_ESPECIALES_ATLAS(COD_PERSONAL,COD_TIPO_PERMISO_ESPECIAL_ATLAS)")
                                .append(" select um.COD_PERSONAL,ppa.COD_TIPO_PERMISO_ESPECIAL_ATLAS ")
                                .append(" from PERFILES_PERMISOS_ATLAS ppa")
                                        .append(" inner join USUARIOS_MODULOS um on um.COD_PERFIL = ppa.COD_PERFIL")
                                                .append("  and COD_MODULO = 6")
                                .append(" where ppa.COD_PERFIL=").append(codPerfil);
            System.out.println("consulta registrar permisos atlas "+consulta.toString());
            pst = con.prepareStatement(consulta.toString());
            if(pst.executeUpdate() > 0)System.out.println("se registraron permisos");
        consulta = new StringBuilder("exec PAA_REGISTRO_PERFIL_ATLAS_LOG ")
                                .append(codPerfil).append(",")
                                .append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",")
                                .append(COD_TIPO_TRANSACCION_EDICION).append(",")
                                .append("?");
        System.out.println("consulta registrar log "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        pst.setString(1,"edicion perfil : "+request.getParameter("justificacion"));
        pst.executeUpdate();
        con.commit();
        mensaje="1";
 
    }
    catch(SQLException ex) 
    {
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    catch(Exception ex) 
    {
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    finally
    {
        con.close();
    }
    out.clear();
    out.println(mensaje);
%>


