<%@page import="com.cofar.web.ManagedAccesoSistema"%>
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
            function nuevoAjax()
            {	
                var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }

                return xmlhttp;
            }
            function  crearPerfilUnionUsuarios()
            {
                if(!alMenosUno("tablaPerfiles"))
                    return false;
                var tabla=document.getElementById("tablaPerfiles").getElementsByTagName("tbody")[0];
                var codigosPerfiles=new Array();
                for(var i=0;i<tabla.rows.length;i++)
                {
                    if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                    {
                        codigosPerfiles.push(tabla.rows[i].cells[0].getElementsByTagName("input")[0].value);
                    }
                }
                ajax=creaAjax();
                ajax.open("GET","ajaxCrearNuevoPerfilUsuario.jsf?codigosPerfiles="+codigosPerfiles+
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
                            alert('Se creo el perfil');
                            window.location.reload();
                            return true;
                        }
                        else
                        {
                            alert("Ocurrio un error al momento de eliminar el perfil; "+ajax.responseText.split("\n").join(""));
                            return false;
                        }

                    }
                }
                ajax.send(null);
                
            }
            function eliminarPerfil(codPerfil)
            {
                if(!confirm('Esta seguro de eliminar el perfil?'))
                    return false;
                ajax = nuevoAjax();
                ajax.open("GET","ajaxEliminarPerfilesUsuarios.jsf?codPerfil="+codPerfil+
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
                            alert('Se elimino el perfil');
                            window.location.reload();
                            return true;
                        }
                        else
                        {
                            alert("Ocurrio un error al momento de eliminar el perfil; "+ajax.responseText.split("\n").join(""));
                            return false;
                        }
                        ajax.send(null);
                    }
                }
            }
              function editarPerfil(codPerfil)
              {
                  window.location.href='editarPerfilUsuario.jsf?codPerfil='+codPerfil+
                                                  '&random='+(new Date()).getTime().toString();
                  
              }
              function verReportePerfil(codPerfil){
                var direccion ="reportePerfilUsuario.jsf?codPerfil="+codPerfil+"&data="+(new Date()).getTime().toString();
                window.open(direccion,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
             }
             function verReportePerfilHistorico(codPerfil){
                var direccion ="reportePerfilUsuarioHistorico.jsf?codPerfil="+codPerfil;
                abrirVentana(direccion);
             }
        </script>
        <style type="text/css">
            .tablaFiltroReporte tr:nth-child(odd){
                background-color: #f4ebef;
            }
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
        <form action="navegadorPerfilesUsuarios.jsf" method="post" id="form" name="form">
            <br>
            <%
                boolean mostrarPersonalNoActivo = (request.getParameter("personalNoActivo")!= null);
                boolean mostrarPerfilesNoActivo = (request.getParameter("perfilNoActivo")!= null);
            %>
            <center>
                <span class="outputTextTituloSistema">Listado de Perfiles</span>
                <input type="checkbox" name="personalNoActivo" id="personalNoActivo" <%=(mostrarPersonalNoActivo ? "checked= true" : "")%> onchange="bloquearPantalla();form.submit();"/><label for="personalNoActivo" class="outputTextBold">Mostrar Usuarios No Activos</label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" name="perfilNoActivo" id="perfilNoActivo" <%=(mostrarPerfilesNoActivo ? "checked= true" : "")%> onchange="bloquearPantalla();form.submit();"/><label for="perfilNoActivo" class="outputTextBold">Mostrar Perfiles No Activos</label>
            </center>
            <br>
            <%
                ManagedAccesoSistema managed = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
                Connection con=null;
                boolean permisoTransaccion = false;
                try
                {
                    con=Util.openConnection(con);
                    StringBuilder consulta = new StringBuilder("select count(*) as permiso ")
                                        .append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpea ")
                                        .append(" where cpea.COD_PERSONAL =").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal())
                                                .append(" and cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS = 21");
                    System.out.println("consulta verificar permiso "+consulta.toString());
                    Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res = st.executeQuery(consulta.toString());
                    res.next();
                    permisoTransaccion = res.getInt("permiso")>0;
            %>
            <table align="center" class="tablaFiltroReporte" id="tablaPerfiles" cellpadding="0" cellspacing="0">
                <thead>
                    <tr class="headerClassACliente">
                        <td>&nbsp;</td>
                        <td><b>Perfil</b></td>
                        <td><b>Estado Registro</b></td>
                        <td><b>Usuarios por Perfil</b></td>
                        <%
                            if(permisoTransaccion){
                                out.println("<td><b>Editar</b></td>");
                            }
                        %>
                        <td><b>Reporte</b></td>
                        <td><b>Reporte Historico</b></td>
                        
                    </tr>
                </thead>
                <tbody>
                <%      
                
                    
                    consulta=new StringBuilder(" select pua.cod_perfil,pua.nombre_perfil,er.nombre_estado_registro");
                                                    consulta.append(" ,detalleUsuarios.cantidadUsuarios");
                                                    consulta.append(",isnull(STUFF((select p=p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal +'('+er.NOMBRE_ESTADO_REGISTRO+')'")
                                                                .append(" FROM USUARIOS_MODULOS um ")
                                                                        .append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO = um.COD_ESTADO_REGISTRO")
                                                                        .append(" inner join personal p on p.COD_PERSONAL = um.COD_PERSONAL")
                                                                .append(" where um.COD_PERFIL = pua.COD_PERFIL and um.COD_MODULO = 6");
                                                                if(!mostrarPersonalNoActivo){
                                                                    consulta.append(" and um.COD_ESTADO_REGISTRO=1");
                                                                }
                                                                consulta.append(" FOR XML PATH('') ")
                                                            .append(" ),1,0,'') ,'')as usuariosHabilitados");
                                            consulta.append(" from PERFILES_USUARIOS_ATLAS pua");
                                                    consulta.append(" inner join estados_referenciales er on pua.cod_estado_registro=er.cod_estado_registro");
                                                    consulta.append(" left join");
                                                    consulta.append(" (");
                                                        consulta.append(" select uam.COD_PERFIL,count(distinct uam.COD_PERSONAL) as cantidadUsuarios");
                                                        consulta.append(" from USUARIOS_ACCESOS_MODULOS uam");
                                                        consulta.append(" where uam.COD_MODULO=6");
                                                        consulta.append(" group by uam.COD_PERFIL");
                                                    consulta.append(" )  as detalleUsuarios on detalleUsuarios.COD_PERFIL=pua.COD_PERFIL");
                                                    if(!mostrarPerfilesNoActivo){
                                                        consulta.append(" where pua.COD_ESTADO_REGISTRO = 1");
                                                    }
                                            consulta.append(" order by  pua.nombre_perfil");
                    System.out.println("consulta cargar perfiles "+consulta.toString());
                    res= st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        out.println("<tr>");
                                out.println("<td><input type='checkbox' id='checkPerfil"+res.getInt("cod_perfil")+"' name='codigo' value='"+res.getInt("cod_perfil")+"'/></td>");
                                out.println("<td><label for='checkPerfil"+res.getInt("cod_perfil")+"'>"+res.getString("nombre_perfil")+"</label></td>");
                                out.println("<td>"+res.getString("nombre_estado_registro")+"</td>");
                                out.println("<td align='center'>"+res.getString("usuariosHabilitados")+"</td>");
                                if(permisoTransaccion){
                                    out.println("<td align='center'><a class='btn' onclick='editarPerfil("+res.getInt("cod_perfil")+")'>Editar</a></td>");
                                }
                                out.println("<td align='center'><a class='btn' onclick='verReportePerfil("+res.getInt("cod_perfil")+")'>Reporte</a></td>");
                                out.println("<td align='center'><a class='btn' onclick='verReportePerfilHistorico("+res.getInt("cod_perfil")+")'>Historico</a></td>");
                                
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
            <%
            if(permisoTransaccion)
            {
                out.println("<div align='center'>");
                    out.println("<a class='btn' onclick='redireccionar(\"agregarPerfilUsuario.jsf\")'>Agregar</a>");
                    out.println("<a class='btn' onclick='crearPerfilUnionUsuarios()'>Unir perfiles</a>");
                out.println("</div>");
            }
            %>
        </form>
    </body>
</html>
