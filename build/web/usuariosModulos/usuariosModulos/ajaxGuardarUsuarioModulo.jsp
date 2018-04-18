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
    try
    {
        String codPersonal=request.getParameter("codPersonal");
        String nombreUsuario=request.getParameter("nombreUsuario");
        String contrasenaUsuario=request.getParameter("contrasenaUsuario");
        String codPerfil=request.getParameter("codPerfil");
        boolean usuarioExistente = request.getParameter("usuarioExistente").equals("1");
        String[] codAreaEmpresa =  request.getParameter("codAreaEmpresa").split(",");
        String[] codAlmacenAcond = request.getParameter("codAlmacenAcond").split(",");
        System.out.println("consulta crear almacen "+codAreaEmpresa);
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("INSERT INTO USUARIOS_MODULOS(COD_PERSONAL, COD_MODULO, NOMBRE_USUARIO,");
                                consulta.append(" CONTRASENA_USUARIO, FECHA_VENCIMIENTO,COD_ESTADO_REGISTRO,COD_PERFIL)");
                                if(usuarioExistente){
                                    consulta.append("select top 1 um.COD_PERSONAL")
                                                    .append(",").append(COD_MODULO_ATLAS)
                                                    .append(",um.NOMBRE_USUARIO")
                                                    .append(",um.CONTRASENA_USUARIO")
                                                    .append(",um.FECHA_VENCIMIENTO")
                                                    .append(",1")
                                                    .append(",").append(codPerfil)
                                            .append(" from USUARIOS_MODULOS um")
                                            .append(" where um.COD_PERSONAL = ").append(codPersonal);
                                }
                                else{
                                    consulta.append("select top 1 p.COD_PERSONAL")
                                                    .append(",").append(COD_MODULO_ATLAS)
                                                    .append(",?")//nombre usuario
                                                    .append(",LOWER(convert(varchar(max),HashBytes('MD5',p.CI_PERSONAL),2))")
                                                    .append(",DATEADD(day,7,getdate())")
                                                    .append(",1")
                                                    .append(",").append(codPerfil)
                                            .append(" from personal p")
                                            .append(" where p.COD_PERSONAL =").append(codPersonal);
                                }
        System.out.println("consulta registrar usuarios"+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString());
        if(!usuarioExistente)
        {
            pst.setString(1,nombreUsuario);System.out.println("p1:"+nombreUsuario);
        }
        if(pst.executeUpdate()>0)System.out.println("Se registro el usuarios");
        
        consulta = new StringBuilder("delete USUARIOS_ACCESOS_MODULOS ")
                            .append(" where COD_PERSONAL=").append(codPersonal)
                                    .append(" and COD_MODULO= 6");
        System.out.println("consulta eliminar accesos anteriores: "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println("se eliminaron anteriores acceso");
        
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
        consulta = new StringBuilder("delete usuarios_alamacen_acond")
                        .append(" where COD_PERSONAL=").append(codPersonal);
        System.out.println("consulta eliminar almacen acond "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println("se elimino acceso almacen");
        
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
                            .append(3).append(",")
                            .append("'nueva habilitacion de usuario'");
        System.out.println("consulta registrar log transaccion "+consulta.toString());
        pst = con.prepareStatement(consulta.toString());
        if(pst.executeUpdate() > 0)System.out.println("se registro log");
                            
        con.commit();
        mensaje="1";
 
    }
    catch(SQLException ex) {
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el usuario";
    }
    catch(Exception ex) {
        ex.printStackTrace();
        mensaje="Ocurrio un error al momento de registrar el usuario";
    }
    finally
    {
        con.close();
    }
    out.clear();
    out.println(mensaje);
%>


