<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>



<html>
    <head>
        
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            function editarUsuarioAreaProduccion(codPersonal)
            {
                var areas=document.getElementsByName("codAreaUsuario");
                var codigosArea=new Array();
                for(var i=0;i<areas.length;i++)
                {
                    if(areas[i].checked)
                    {
                        codigosArea.push(areas[i].value);
                    }
                }
                ajax=creaAjax();
                ajax.open("POST","ajaxAgregarEditarUsuariosAreaProduccion.jsf?codPersonal="+codPersonal+
                                            "&a="+(new Date()).getTime().toString(),true);
                ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se informacion se guardo correctamente');
                            window.location.href='navegadorUsuariosModulos.jsf?ok='+(new Date()).getTime().toString();
                            return true;
                        }
                        else
                        {
                            alert("Ocurrio un error al momento de registrar los defectos "+ajax.responseText.split("\n").join(""));
                            return false;
                        }

                    }
                };
                ajax.send("codigosArea="+codigosArea);
            }
        </script>
    </head>
    <body>
        <form id="form" >
            <span class="outputTextTituloSistema">Listado de Areas Habilitadas usuario</span>
            <%
                Connection con=null;
                    String codPersonal=request.getParameter("codPersonal");
                try
                {
                    StringBuilder consulta=new StringBuilder("select p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal,");
                                                    consulta.append(" um.NOMBRE_USUARIO");
                                            consulta.append(" from USUARIOS_MODULOS um");
                                                    consulta.append(" inner join personal p on p.COD_PERSONAL=um.COD_PERSONAL");
                                            consulta.append(" where um.COD_MODULO=6");
                                            consulta.append(" and um.COD_PERSONAL=").append(codPersonal);
                    con=Util.openConnection(con);
                    System.out.println(consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    res.next();
                    out.println("<table align='center' class='tablaFiltroReporte'  cellpadding='0' cellspacing='0'>");
                        out.println("<thead>");
                            out.println("<tr>");
                                out.println("<td colspan='3' align='center'>DATOS DE USUARIO</td>");
                            out.println("</tr>");
                        out.println("</thead>");
                        out.println("<tbody>");
                            out.println("<tr>");
                                out.println("<td class='outputTextBold'>Persona</td>");
                                out.println("<td class='outputTextBold'>::</td>");
                                out.println("<td class='outputText2'>"+res.getString("nombrePersonal")+"</td>");
                            out.println("<tr>");
                            out.println("<tr>");
                                out.println("<td class='outputTextBold'>Usuario</td>");
                                out.println("<td class='outputTextBold'>::</td>");
                                out.println("<td class='outputText2'>"+res.getString("NOMBRE_USUARIO")+"</td>");
                            out.println("<tr>");
                        out.println("</tbody>");
                    out.println("</table>");
            %>
            <br>
            <table align="center" class="tablaFiltroReporte" id="tablaAreasUsuario" cellpadding="0" cellspacing="0">
                <thead>
                    <tr >
                        <td></td>
                        <td>Area<br><input onkeyup="buscarCeldaAgregar(this,1)" class="inputText"/></td>
                    </tr>
                </thead>
                <tbody>
                
                <%
                    
                    consulta=new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,isnull(uap.COD_AREA_EMPRESA,0) as registradoAe");
                                consulta.append(" from AREAS_EMPRESA ae ");
                                        consulta.append(" left outer join USUARIOS_AREA_PRODUCCION uap on uap.COD_AREA_EMPRESA=ae.COD_AREA_EMPRESA");
                                                consulta.append(" and uap.COD_PERSONAL=").append(codPersonal);
                                consulta.append(" where ae.COD_FILIAL in (1,2)");
                                consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                    res=st.executeQuery(consulta.toString());
                    while(res.next())
                    {
                        out.println("<tr class='seleccionado'>");
                                out.println("<td><input name='codAreaUsuario' onclick='seleccionarRegistro(this)' type='checkbox' value='"+res.getInt("COD_AREA_EMPRESA")+"' "+(res.getInt("registradoAe")>0?"checked":"")+"/></td>");
                                out.println("<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>");
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
            <div id="bottonesAcccion" align="center" class="barraBotones">
                <a class="btn" onclick="editarUsuarioAreaProduccion(<%=(codPersonal)%>)">Guardar</a>
                <a class="btn" onclick="window.location.href='navegadorUsuariosModulos.jsf?cancel='+(new Date()).getTime().toString()">Cancelar</a>
            </div>
        </form>
    </body>
</html>
