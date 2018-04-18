<%@page import="com.cofar.web.ManagedAccesoSistema"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>

<%
    String mensaje="";
    Connection con=null;
    int COD_TIPO_TRANSACCION_REGISTRO_NUEVO = 3;
    String codigosPerfiles=request.getParameter("codigosPerfiles");
    try
    {
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        StringBuilder consulta = new StringBuilder("select STUFF((select ','+ pua.NOMBRE_PERFIL from PERFILES_USUARIOS_ATLAS pua where pua.COD_PERFIL in (").append(codigosPerfiles).append(") FOR XML PATH('')),1,1,'') as nomnbrePerfilUnion");
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res = st.executeQuery(consulta.toString());
        String nombrePerfilesUnion = "";
        if(res.next())nombrePerfilesUnion = res.getString(1);
        consulta=new StringBuilder("INSERT INTO PERFILES_USUARIOS_ATLAS(NOMBRE_PERFIL,COD_ESTADO_REGISTRO)");
                            consulta.append("values(");
                                    consulta.append("?,");
                                    consulta.append("1");
                            consulta.append(")");
        System.out.println("consulta registrar perfil "+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
        pst.setString(1, "perfil union "+nombrePerfilesUnion);
        if(pst.executeUpdate()>0)System.out.println("Se registor el perfil");
        res=pst.getGeneratedKeys();
        int codPerfil=0;
        if(res.next())codPerfil=res.getInt(1);
        consulta=new StringBuilder(" insert into PERFIL_ACCESO_VENTANA_ATLAS(COD_PERFIL,COD_VENTANA)");
                    consulta.append(" select distinct ?,pava.COD_VENTANA");
                    consulta.append(" from PERFIL_ACCESO_VENTANA_ATLAS pava");
                    consulta.append(" where pava.COD_PERFIL in (").append(codigosPerfiles).append(")");
        System.out.println("consulta registrar ventanas perfil "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        pst.setInt(1,codPerfil);
        if(pst.executeUpdate()>0)System.out.println("Se registraron las ventanas");
        
        consulta = new StringBuilder("INSERT INTO PERFILES_PERMISOS_ATLAS(COD_TIPO_PERMISO_ESPECIAL_ATLAS,COD_PERFIL)")
                            .append(" select distinct ppa.COD_TIPO_PERMISO_ESPECIAL_ATLAS,").append(codPerfil)
                            .append(" from PERFILES_PERMISOS_ATLAS ppa")
                            .append(" where ppa.COD_PERFIL in (").append(codigosPerfiles).append(")");
        System.out.println("consulta registrar tipos permisos perfil "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println(" se registro la union de permisos");
        
        
        consulta = new StringBuilder("exec PAA_REGISTRO_PERFIL_ATLAS_LOG ")
                                .append(codPerfil).append(",")
                                .append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",")
                                .append(COD_TIPO_TRANSACCION_REGISTRO_NUEVO).append(",")
                                .append("?");
        System.out.println("consulta registrar log "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        pst.setString(1, "union de perfiles: "+nombrePerfilesUnion);
        pst.executeUpdate();
        
        con.commit();
        mensaje="1";
 
    }
    catch(SQLException ex) 
    {
        con.rollback();
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    catch(Exception ex) 
    {
        con.rollback();
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


