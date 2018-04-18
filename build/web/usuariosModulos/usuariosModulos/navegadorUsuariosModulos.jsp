<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function detalleAreas(codPersonal)
            {
                window.location.href='agregarEditarUsuariosAreaProduccion.jsf?codPersonal='+codPersonal+'&data='+(new Date()).getTime().toString();
                
            }
            function editarUsuarioModulo(codPerfil)
            {
                window.location.href='editarUsuarioModulo.jsf?codPersonal='+codPerfil+
                                      '&random='+(new Date()).getTime().toString();
            }
            function verReporteHistorico(codPersonal){
                var ventana = "reporteUsuarioModuloHistorico.jsf?codPersonal="+codPersonal;
                abrirVentana(ventana);
            }
            function eliminarUsuarioModulo(codPerfil)
            {
                if(!confirm('Esta seguro de eliminar el usuario?'))
                    return false;
                ajax=creaAjax();
                ajax.open("GET","ajaxEliminarUsuarioModulo.jsf?codPersonal="+codPerfil+
                                            "&a="+(new Date()).getTime().toString(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se elimino el usuario');
                            window.location.reload();
                            return true;
                        }
                        else
                        {
                            alert("Ocurrio un error al momento de eliminar el usuario; "+ajax.responseText.split("\n").join(""));
                            return false;
                        }

                    }
                }
                ajax.send(null);
            }
        </script>
        <style type="text/css">
            .tablaFiltroReporte{
                border-collapse: collapse;
            }
            .tablaFiltroReporte tr:nth-child(odd){
                background-color: #f4ebef;
            }
            .tablaFiltroReporte tr td{
                border-left: 1px solid #ccc;
            }
            p{
                margin:1px;
                border-bottom: 1px solid #ccc;
                font-size: 10px;
            }
        </style>
    </head>
    <body>
        <form method="post" action="registrar_usuario_perfil.jsp" name="upform"  >
            <span class="outputTextTituloSistema">Listado de Usuarios ATLAS </span>
            
            
            <table width="80%" align="center" class="tablaFiltroReporte" id="tablaUsuariosModulos" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <td><b>Nombre</b></td>
                        <td><b>Cargo</b></td>
                        <td><b>Usuario</b></td>
                        <td><b>Perfil</b></td>
                        <td><b>Estado</b></td>
                        <td><b>Areas Habilitadas</b></td>
                        <td><b>Almacenes Acondicionamiento Habilitado</b></td>
                        <td><b>Editar</b></td>
                        <td><b>Historico</b></td>
                    </tr>
                </thead>
                <tbody>
                
                <%
                    Connection con=null;
                    String codPerfil="";
                try
                {
                    StringBuilder consulta=new StringBuilder("select distinct p.COD_PERSONAL,(p.ap_paterno_personal+' '+p.ap_materno_personal+' '+p.nombres_personal+' '+p.nombre2_personal) as nombrePersonal,");
                                                    consulta.append(" pua.NOMBRE_PERFIL,um.CONTRASENA_USUARIO,um.NOMBRE_USUARIO,c.DESCRIPCION_CARGO,pua.cod_perfil");
                                                    consulta.append(" ,isnull(STUFF((select p= ae.NOMBRE_AREA_EMPRESA from USUARIOS_AREA_PRODUCCION uap inner join areas_empresa ae on ae.COD_AREA_EMPRESA = uap.COD_AREA_EMPRESA where uap.COD_PERSONAL = um.COD_PERSONAL FOR XML PATH ('')),1,0,''),'') as nombreAreaEmpresa");
                                                    consulta.append(" ,isnull(STUFF((select p=aa.NOMBRE_ALMACENACOND from usuarios_alamacen_acond uaa inner join ALMACENES_ACOND aa on aa.COD_ALMACENACOND = uaa.cod_almacen where uaa.cod_personal = um.COD_PERSONAL order by aa.NOMBRE_ALMACENACOND FOR XML PATH ('')),1,0,''),'') as nombreAlmacenAcond");
                                                    consulta.append(" ,er.NOMBRE_ESTADO_REGISTRO");
                                             consulta.append(" from PERFILES_USUARIOS_ATLAS pua ");
                                                 consulta.append(" inner join USUARIOS_MODULOS um on pua.COD_PERFIL=um.COD_PERFIL");
                                                 consulta.append(" inner join PERSONAL p on p.COD_PERSONAL=um.COD_PERSONAL");
                                                 consulta.append(" inner join CARGOS c on c.CODIGO_CARGO=p.CODIGO_CARGO");
                                                 consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO = um.COD_ESTADO_REGISTRO");
                                             consulta.append(" where um.COD_MODULO=6");
                                             consulta.append(" order by 2");
                    con=Util.openConnection(con);
                    System.out.println(consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        out.println("<tr>");
                            out.println("<td>"+res.getString("nombrePersonal")+"</td>");
                            out.println("<td>"+res.getString("DESCRIPCION_CARGO")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_USUARIO")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_PERFIL")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_ESTADO_REGISTRO")+"</td>");
                            out.println("<td>"+res.getString("nombreAreaEmpresa")+"</td>");
                            out.println("<td>"+res.getString("nombreAlmacenAcond")+"</td>");
                            out.println("<td><a class='btn' href='#' onclick='editarUsuarioModulo("+res.getInt("COD_PERSONAL")+")'>Editar<a></td>");
                            out.println("<td><a class='btn' href='#' onclick='verReporteHistorico("+res.getInt("COD_PERSONAL")+")'>Reporte Historico<a></td>");
                        out.println("</tr>");
                    }
                                                
                   
                } 
                catch(Exception e) 
                {
                    e.printStackTrace();
                }
                finally
                {
                    con.close();
                }
                %>
                </tbody>
            </table>

            <br>
            <div align="center">
                <a class="btn" onclick="window.location.href='agregarUsuarioModulo.jsf?data='+(new Date()).getTime().toString()">Agregar</a>
            </div>
        </form>
    </body>
</html>
