<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@ page language="java"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<html>
    
    <head>
        <meta http-equiv='Expires' content='0'>
        <meta http-equiv='Last-Modified' content='0'>
        <meta http-equiv='Cache-Control' content='no-cache, mustrevalidate'>
        <meta http-equiv='Pragma' content='no-cache'>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
        <script src="../../js/general.js"></script>
        <script type="text/javascript">
            onerror=function(){
                alert('Ocurrio un error, intente de nuevo');
                window.location.reload();
            }
            function registrarUsuarioModulo(){
                var codAreaEmpresa = new Array();
                var selectAreaEmpresa = document.getElementsByName("codAreaEmpresa");
                for(var i = 0 ; i < selectAreaEmpresa.length ; i++){
                    if(selectAreaEmpresa[i].checked){
                        codAreaEmpresa.push(selectAreaEmpresa[i].value);
                    }
                }
                var codAlmacenAcond = new Array();
                var selectAlmacenAcond = document.getElementsByName("codAlmacenAcond");
                for(var i = 0 ; i < selectAlmacenAcond.length ; i++){
                    if(selectAlmacenAcond[i].checked){
                        codAlmacenAcond.push(selectAlmacenAcond[i].value);
                    }
                }
                if(!(validarRegistroNoVacio(document.getElementById("nombreUsuario"))))
                    return false;
                bloquearPantalla();
                ajax=creaAjax();
                ajax.open("POST" ,  "ajaxGuardarUsuarioModulo.jsf?nombreUsuario="+encodeURIComponent(document.getElementById("nombreUsuario").value)+
                                    "&codPersonal="+document.getElementById("codPersonal").value+
                                    "&usuarioExistente="+document.getElementById("usuarioExistente").value+
                                    "&codPerfil="+document.getElementById("codPerfil").value+
                                    "&a="+(new Date()).getTime().toString(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            desBloquearPantalla();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registro el usuario');
                            window.location.href='navegadorUsuariosModulos.jsf?confirm='+(new Date()).getTime().toString();
                            return true;
                        }
                        else
                        {
                            alert("Ocurrio un error al momento de registrar el usuario "+ajax.responseText.split("\n").join(""));
                            desBloquearPantalla();
                            return false;
                        }

                    }
                };
                ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                ajax.send("codAreaEmpresa="+codAreaEmpresa+
                            "&codAlmacenAcond="+codAlmacenAcond);
            }
            function verificarUsuario(){
                var codPersonal = document.getElementById("codPersonal").value;
                bloquearPantalla();
                ajax=creaAjax();
                ajax.open("GET" ,  "ajaxVerificarUsuarioCreado.jsf?codPersonal="+codPersonal+
                                    "&a="+(new Date()).getTime().toString(),true);
                ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        eval("var datosUsuario={"+ajax.responseText+"}");
                        document.getElementById("divNombreUsuario").innerHTML = datosUsuario.nombreUsuario;
                        document.getElementById("nombreUsuario").value = datosUsuario.nombreUsuario;
                        document.getElementById("usuarioExistente").value = datosUsuario.usuarioExistente;
                        document.getElementById("divContraseniaUsuario").innerHTML =datosUsuario.contrasenia;
                        desBloquearPantalla();
                    }
                };
                ajax.send(null);
            }
        </script>
    </head>
    <body onload="verificarUsuario()">
        <span class="outputTextTituloSistema">Registrar Usuario Modulo Atlas</span>
        
        <form method="post" action="" name="upform"  >
            <div align="center">
                <table border="0" style="border:solid #cccccc 1px"  class="tablaFiltroReporte" align="center" width="33%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <td  colspan="3" >
                                Introduzca Datos
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputTextBold">Personal</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select class="inputText chosen" id="codPersonal" onchange='verificarUsuario()'>
                                    <option value="0" disabled="true">--Seleccione una opción--</option>
                                    <%
                                    Connection con=null;
                                    try
                                    {
                                        con=Util.openConnection(con);
                                        StringBuilder consulta=new StringBuilder("select p.COD_PERSONAL,p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+isnull(p.nombre2_personal,'') as nombrePersonal");
                                                                consulta.append(" from PERSONAL p");
                                                                consulta.append(" where p.cod_estado_persona = 1");
                                                                consulta.append(" and p.cod_personal not in(");
                                                                                            consulta.append(" select um.cod_personal");
                                                                                            consulta.append(" from USUARIOS_MODULOS um");
                                                                                            consulta.append(" where um.cod_modulo = 6");
                                                                      consulta.append(" )");
                                                                consulta.append(" order by 2");
                                        System.out.println("consulta personal sin usuario "+consulta.toString());
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("nombrePersonal")+"</option>");
                                        }
                                    %>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Usuario</td>
                            <td class="outputTextBold">::</td>
                            <td><div id="divNombreUsuario"></div>
                                <input name="nombreUsuario" id="nombreUsuario" type="hidden"/>
                                <input name="usuarioExistente" id="usuarioExistente" type="hidden"/>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Contraseña</td>
                            <td class="outputTextBold">::</td>
                            <td><div id="divContraseniaUsuario"></div></td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Perfil</td>
                            <td class="outputTextBold">::</td>
                            <td>
                                <select id="codPerfil" class="inputText chosen">
                                    <%
                                        consulta=new StringBuilder(" select cod_perfil,nombre_perfil");
                                                    consulta.append(" from PERFILES_USUARIOS_ATLAS");
                                                    consulta.append(" where cod_estado_registro=1");
                                                    consulta.append(" order by nombre_perfil");
                                        System.out.println("consulta perfiles "+consulta.toString());
                                        res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getInt("cod_perfil")+"'>"+res.getString("nombre_perfil")+"</option>");
                                        }

                                    %>
                                </select>
                            </td>
                                
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div style="width:100%;height: 300px; overflow-y: auto; border: 1px solid #ccc;">
                                    <table class="tablaFiltroReporte" cellpading="0px" cellspacing="0px" style="width:100%">
                                        <thead><tr><td></td><td>Areas Habilitadas</td></tr></thead>
                                        <tbody>
                                            <%
                                                consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA")
                                                                    .append(" from areas_empresa ae ")
                                                                    .append(" where ae.COD_ESTADO_REGISTRO=1")
                                                                    .append(" order by ae.NOMBRE_AREA_EMPRESA");
                                                res = st.executeQuery(consulta.toString());
                                                while(res.next()){
                                                    out.println("<tr>");
                                                        out.println("<td><input value='"+res.getInt("COD_AREA_EMPRESA")+"' id='codAreaEmpresa"+res.getInt("COD_AREA_EMPRESA")+"' type='checkbox' name='codAreaEmpresa'/></td>");
                                                        out.println("<td><label for='codAreaEmpresa"+res.getInt("COD_AREA_EMPRESA")+"'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</label></td>");
                                                    out.println("</tr>");
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                    <table class="tablaFiltroReporte" cellpading="0px" cellspacing="0px" style="width:100%">
                                        <thead><tr><td></td><td>Almacenes Acondicionamiento Habilitados</td></tr></thead>
                                        <tbody>
                                            <%
                                                consulta = new StringBuilder("select aa.COD_ALMACENACOND,aa.NOMBRE_ALMACENACOND")
                                                                        .append(" from ALMACENES_ACOND aa")
                                                                        .append(" where aa.COD_ESTADO_REGISTRO=1")
                                                                        .append(" order by aa.NOMBRE_ALMACENACOND");
                                                res = st.executeQuery(consulta.toString());
                                                while(res.next()){
                                                    out.println("<tr>");
                                                        out.println("<td><input value='"+res.getInt("COD_ALMACENACOND")+"' id='codAlmacenAcond"+res.getInt("COD_ALMACENACOND")+"' type='checkbox' name='codAlmacenAcond'/></td>");
                                                        out.println("<td><label for='codAlmacenAcond"+res.getInt("COD_ALMACENACOND")+"'>"+res.getString("NOMBRE_ALMACENACOND")+"</label></td>");
                                                    out.println("</tr>");
                                                }
                                            %>
                                        </tbody>
                                    </table>
                            </td>
                        </tr>

                        <%  

                            } catch(Exception e) 
                            {
                                e.printStackTrace();
                            }  
                            finally
                            {
                                con.close();
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3">
                                <a class="btn" onclick="registrarUsuarioModulo()">Guardar</a>
                                <a class="btn" onclick="window.location.href='navegadorUsuariosModulos.jsf?cancel='+(new Date()).getTime().toString()">Cancelar</a>
                            </td>
                        </tr>
                    </tfoot>
                </table>

            </div>
            <br>
            <script src="../../js/chosen.js"></script>
        </form>
        
    </body>
</html>