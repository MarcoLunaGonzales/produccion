<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>



<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script type="text/javascript" src="../../js/md5.js"></script>
        <script type="text/javascript">
            onerror = function(e){
                alert('Ocurrio un error, recargue la pagina');
            }
            function mostrarMensajeHint(mensaje,input)
            {
                if(document.getElementById("mensajeHintSistema")==null)
                {
                    var span=document.createElement("span");
                    span.className='hint';
                    span.id='mensajeHintSistema';
                    input.parentNode.appendChild(span);
                }
                input.parentNode.style.position='relative';
                document.getElementById("mensajeHintSistema").style.left=input.offsetLeft;
                document.getElementById("mensajeHintSistema").style.top=input.offsetTop+18;
                document.getElementById("mensajeHintSistema").style.display='inline';
                document.getElementById("mensajeHintSistema").innerHTML=mensaje;
                try
                {
                    if(document.getElementById("mensajeHintSistema").addEventListener){
                        document.getElementById("mensajeHintSistema").addEventListener("click",function(){ocultarMensajeHint();},true);
                        input.addEventListener("click",function(){ocultarMensajeHint();},true);
                        input.addEventListener("change",function(){ocultarMensajeHint();},true);
                        input.addEventListener("keypress",function(){ocultarMensajeHint();},true);
                    }
                    else
                    {
                        document.getElementById("mensajeHintSistema").attachEvent("onclick",function(){ocultarMensajeHint();});
                        input.attachEvent("onclick",function(){ocultarMensajeHint();});
                        input.attachEvent("onkeypress",function(){ocultarMensajeHint();});
                        input.attachEvent("onchange",function(){ocultarMensajeHint();});
                    }
                }
                catch(e){alert("datos no soportados favor comuniquese con sistemas "+e.toString());}
            }
            function ocultarMensajeHint()
            {
                try
                {
                    var mensaje=document.getElementById("mensajeHintSistema");
                    mensaje.parentNode.removeChild(mensaje);
                }
                catch(e){}
            }
            function guardar_modificaciones(){
                var contraseniaNueva = document.getElementById("contrasena");
                var contraseniaIntroducida = md5(document.getElementById("contrasenaAnt").value);
                var password = document.getElementById('contraAnterior').value;
                
                if(contraseniaIntroducida != password){
                    mostrarMensajeHint('La contraseña introducida no es correcta',document.getElementById("contrasenaAnt"));
                    return false;
                }
                
                var regex = /[a-z]/;
                if(!regex.test(contraseniaNueva.value)){
                    mostrarMensajeHint('La nueva contraseña debe tener al menos una letra minuscula',contraseniaNueva);
                    return false;
                }
                regex = /[A-Z]/;
                if(!regex.test(contraseniaNueva.value)){
                    mostrarMensajeHint('La nueva contraseña debe tener al menos una letra mayuscula',contraseniaNueva);
                    return false;
                }
                regex = /[0-9]/;
                if(!regex.test(contraseniaNueva.value)){
                    mostrarMensajeHint('La nueva contraseña debe tener al menos un numero',contraseniaNueva);
                    return false;
                }
                
                regex = /[-_$@.%#&*]/;
                if(!regex.test(contraseniaNueva.value)){
                    mostrarMensajeHint('La nueva contraseña debe tener al menos uno de los siguientes caracteres: -_$@.%#&*',contraseniaNueva);
                    return false;
                }
                
                if(contraseniaNueva.value != document.getElementById("contrasenaNueva").value){
                    mostrarMensajeHint('La verificación de la nueva contraseña no coinciden',document.getElementById("contrasenaNueva"));
                    return false;
                }
                
                if(contraseniaNueva.value.length < 6){
                    mostrarMensajeHint('La contraseña nueva debe tener al menos 6 caracteres',contraseniaNueva);
                    return false;
                }
                document.getElementById("contraseniaNueva").value = md5(contraseniaNueva.value);
                document.getElementById("upform").submit();
            }
        </script>
        <style type="text/css">
            .hint
            {
                font-weight: bold;
                display:none;
                position: absolute;
                border: 1px solid #eed3d7;
                color:#b94a48;
                width: 250px;
                text-align:left;
                z-index: 1000;
                font-size: 12px;
                background: #f2dede url(pointer.gif) no-repeat -10px 5px;
            }
            .tablaFiltroReporte
{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 12px;
                border:1px solid #bbbbbb;
            }
            .tablaFiltroReporte tr td
            {
                padding: 5px;
            }
            .tablaFiltroReporte thead tr td
            {
                color: white;
                border-bottom:1px solid #bbbbbb;
                text-align: center;
                font-weight: bold;
            }
            .tablaFiltroReporte tfoot tr td
            {
                text-align: center;
            }

        </style>
    </head>
    <body>
        
        <%
            Connection con=null;
        con=Util.openConnection(con);
        %>
        
        <br>
        <center>
            <h3>Modificar Usuario Contraseña</h3>
        </center>
        <form method="post" action="guardarModificacionContraseniaUsuario.jsp" style="top:1px" name="form1" id="upform">
            <div align="center">
                
                    <%
                    Object obj=request.getSession().getAttribute("ManagedAccesoSistema");
                    ManagedAccesoSistema var=(ManagedAccesoSistema)obj;
                    String codigoUsuario=var.getUsuarioModuloBean().getCodUsuarioGlobal();
                    System.out.println("codigoUsuario:"+ codigoUsuario);
                    try{
                        String sql_aux=" select top 1 p.ap_paterno_personal+' '+p.ap_materno_personal+' '+p.nombres_personal+' '+p.nombre2_personal as nombrePersonal," +
                                " um.nombre_usuario,um.contrasena_usuario" +
                                " from usuarios_modulos um,personal p"+
                                " where um.cod_personal = p.cod_personal and p.cod_personal='"+codigoUsuario+"' and um.COD_MODULO = 6";
                        System.out.println("consulta datos usuario: "+sql_aux);
                        Statement st_aux = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_aux = st_aux.executeQuery(sql_aux);
                        while (rs_aux.next()){
                            String nombrePersonal = rs_aux.getString("nombrePersonal");
                            String nombreUsuario = rs_aux.getString("nombre_usuario");
                            String contrasenaUsuario = rs_aux.getString("contrasena_usuario");
                            
                    %>
                    <input type="hidden" value="<%=contrasenaUsuario%>" name="contraAnterior" id="contraAnterior"/>
                    <input type="hidden" value="<%=nombreUsuario%>" id="nombreUsuario" name="nombreUsuario"/>
                    <table border="0" cellpadding="0" cellspacing="0" class="tablaFiltroReporte" align="center" width="33%">
                        <thead>
                            <tr class="headerClassACliente">
                                <td  colspan="3">
                                    <div class="outputText2" align="center">
                                        Introduzca Datos
                                    </div>
                                </td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="outputTextBold">Nombre</td>
                                <td class="outputTextBold">::</td>
                                <td><span class="outputText2"><%=(nombrePersonal)%></span></td>
                            </tr>
                            <tr>
                                <td class="outputTextBold">Usuario</td>
                                <td class="outputTextBold">::</td>
                                <td ><span class="outputText2"><%=nombreUsuario%></span></td>
                            </tr>
                            <tr>
                                <td class="outputTextBold">Contraseña Actual</td>
                                <td class="outputTextBold">::</td>
                                <td ><input name="contrasenaAnt" placeHolder="Contraseña Actual" id="contrasenaAnt" value="" type="password" class="inputText" size="35"/></td>
                            </tr>
                            <tr>
                                <td class="outputTextBold"> Nueva Contraseña</td>
                                <td class="outputTextBold">::</td>
                                <td ><input name="contrasena" placeHolder="Nueva Contraseña" id="contrasena" value="" type=password class="inputText" size="35"/></td>
                            </tr>
                            <tr>
                                <td class="outputTextBold">Repita la nueva Contraseña</td>
                                <td class="outputTextBold">::</td>
                                <td ><input name="contrasenaNueva" placeHolder="Repita la Nueva Contraseña" id="contrasenaNueva" value="" type=password class="inputText" size="35"/></td>
                            </tr> 
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3">
                                    <input type="button"   class="btn" size="35" value="Cambiar Contraseña" name="reporte" onclick="guardar_modificaciones()">
                                </td>
                            </tr>
                        </tfoot>
                    
                    <%  
                        }
                    } catch(Exception e) {
                    }  
                    con.close();
                    %>
                </table>
                <input type="hidden" value="<%=codigoUsuario%>" name="codPersonal" id="codPersonal">
                <input type="hidden" value="" name="contraseniaNueva" id="contraseniaNueva">
            </div>
            <br>
        </form>
    </body>
</html>