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
    int COD_MODULO_ATLAS = 6;
    try{
        String codPersonal=request.getParameter("codPersonal");
        String codPerfil=request.getParameter("codPerfil");
        String codEstadoRegistro = request.getParameter("codEstadoRegistro");
        String[] codAreaEmpresa =  request.getParameter("codAreaEmpresa").split(",");
        String[] codAlmacenAcond = request.getParameter("codAlmacenAcond").split(",");
        con = Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("UPDATE USUARIOS_MODULOS");
                                consulta.append(" set COD_PERFIL = ").append(codPerfil)
                                            .append(" , COD_ESTADO_REGISTRO = ").append(codEstadoRegistro);
                               consulta.append(" WHERE COD_PERSONAL=").append(codPersonal);
                                        consulta.append(" and COD_MODULO=6");
        System.out.println("consulta UPDATE usuario"+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("Se GUARDO LA EDICION DE USUARIO");
        consulta=new StringBuilder("DELETE USUARIOS_ACCESOS_MODULOS ");
                    consulta.append("where COD_PERSONAL=").append(codPersonal);
                    consulta.append(" and COD_MODULO=6");
        System.out.println("consulta delete accesos "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se elimino usuarios accesos modulos");
        
        consulta=new StringBuilder("INSERT INTO USUARIOS_ACCESOS_MODULOS(COD_PERSONAL, COD_MODULO, CODIGO_VENTANA,CODIGO_ESTADO_VENTANA, COD_PERFIL)");
                    consulta.append(" select ").append(codPersonal).append(" ,6,pava.COD_VENTANA,1,pava.COD_PERFIL");
                    consulta.append(" from PERFIL_ACCESO_VENTANA_ATLAS pava");
                    consulta.append(" where pava.COD_PERFIL=").append(codPerfil);
        System.out.println("consulta registrar accesos "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se registro la ventana");
        
        consulta=new StringBuilder(" DELETE USUARIOS_AREA_PRODUCCION");
                                consulta.append(" where cod_personal=").append(codPersonal);
        System.out.println("consulta delete area produccion "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("Se GUARDO LA EDICION DE USUARIO");
        
        consulta=new StringBuilder("INSERT INTO USUARIOS_AREA_PRODUCCION(COD_PERSONAL, COD_AREA_EMPRESA,COD_TIPO_PERMISO)");
                    consulta.append(" VALUES (");
                        consulta.append(codPersonal);
                        consulta.append(",?");
                        consulta.append(",1");
                    consulta.append(")");
        System.out.println("consulta registrar usuario area produccion "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(String codArea : codAreaEmpresa){
            if(codArea.length()>0){
                pst.setString(1, codArea);
                if(pst.executeUpdate()>0)System.out.println("se registro el area produccion");
            }
        }
        
        consulta = new StringBuilder(" delete usuarios_alamacen_acond")
                            .append(" where cod_personal =").append(codPersonal);
        System.out.println("consulta delete usuarios "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println("se eliminaron anteriores almacenes");
        
        consulta = new StringBuilder("INSERT INTO usuarios_alamacen_acond(cod_personal, cod_almacen)")
                            .append(" values(")
                                    .append(codPersonal).append(",")
                                    .append("?")//codAlmacen
                            .append(")");
        System.out.println("consulta registrar usuario almacen acond "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        for(String codAlmacen :  codAlmacenAcond){
            if(codAlmacen.length() > 0 ){
                pst.setString(1, codAlmacen);System.out.println("p1: "+codAlmacen);
                if(pst.executeUpdate() > 0)System.out.println("se registro almacen acond");
            }
        }
        
        ManagedAccesoSistema managed = (ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
        consulta = new StringBuilder(" exec PAA_REGISTRO_USUARIOS_MODULOS_LOG ")
                            .append(codPersonal).append(",")
                            .append(COD_MODULO_ATLAS).append(",")
                            .append(managed.getUsuarioModuloBean().getCodUsuarioGlobal()).append(",")
                            .append("1,")
                            .append("?");
        System.out.println("consulta registrar log transaccion "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        pst.setString(1,"edicion perfil : "+request.getParameter("justificacion"));
        if(pst.executeUpdate() > 0)System.out.println("se registro log");
        con.commit();
        mensaje="1";
    }
    catch(SQLException ex){
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    catch(Exception ex){
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el perfil";
    }
    finally{
        con.close();
    }
    out.clear();
    out.println(mensaje);
%>


