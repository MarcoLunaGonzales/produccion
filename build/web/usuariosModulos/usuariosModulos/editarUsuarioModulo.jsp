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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
        <script src="../../js/general.js"></script>
        <script>
            function editarUsuarioModulo(codPersonal){
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
                ajax=creaAjax();
                ajax.open("POST","ajaxGuardarEdicionUsuarioModulo.jsf?codPerfil="+document.getElementById("codPerfil").value+
                                "&codPersonal="+codPersonal+
                                "&codEstadoRegistro="+document.getElementById("codEstadoRegistro").value+
                                "&a="+(new Date()).getTime().toString(),true);
                bloquearPantalla();
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
                            "&codAlmacenAcond="+codAlmacenAcond+
                            "&justificacion="+encodeURIComponent(document.getElementById("justificacion").value));
            }
        </script>
    </head>
    <body>
        <span class="outputTextTituloSistema">Editar Usuario Modulo Atlas</span>
        
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
                            <td class="outputText2">
                                
                                <%
                                String codPersonal=request.getParameter("codPersonal");
                                Connection con=null;
                                try
                                {
                                    con=Util.openConnection(con);
                                    StringBuilder consulta=new StringBuilder("select p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal as nombrePersonal,");
                                                                    consulta.append(" um.NOMBRE_USUARIO,um.CONTRASENA_USUARIO,um.COD_PERFIL,um.COD_ESTADO_REGISTRO");
                                                            consulta.append(" from USUARIOS_MODULOS um");
                                                                    consulta.append(" inner join personal p on p.COD_PERSONAL=um.COD_PERSONAL");
                                                                    consulta.append(" inner join USUARIOS_ACCESOS_MODULOS uam on uam.COD_PERSONAL=um.COD_PERSONAL");
                                                                    consulta.append(" and um.COD_MODULO=uam.COD_MODULO");
                                                            consulta.append(" where um.COD_PERSONAL=").append(codPersonal);
                                                                    consulta.append(" and um.COD_MODULO=6");
                                    System.out.println("consulta usuario"+consulta.toString());
                                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet res=st.executeQuery(consulta.toString());
                                    res.next();
                                    out.println(res.getString("nombrePersonal"));
                                    int codPerfil=res.getInt("COD_PERFIL");
                                    int codEstadoRegistro = res.getInt("COD_ESTADO_REGISTRO");
                                %>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Usuario</td>
                            <td class="outputTextBold">::</td>
                            <td class="outputText2"><%=(res.getString("NOMBRE_USUARIO"))%></td>
                        </tr>
                        <tr>
                            <td class="outputTextBold">Estado</td>
                            <td class="outputTextBold">::</td>
                            <td class="outputText2">
                                <select id="codEstadoRegistro">
                                    <option value="1">Activo</option>
                                    <option value="2">No Activo</option>
                                </select>
                                <script>
                                    document.getElementById("codEstadoRegistro").value=<%=(codEstadoRegistro)%>;
                                </script>
                            </td>
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
                                <script>
                                    document.getElementById("codPerfil").value=<%=(codPerfil)%>;
                                </script>
                            </td>
                                
                        </tr>
                        <tr>
                            <td class="outputTextBold">Observación/Justificación</td>
                            <td class="outputTextBold">::</td>
                            <td >
                                <textarea  style="width:100%" id="justificacion" class="inputText"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div style="width:100%;height: 300px; overflow-y: auto; border: 1px solid #ccc;">
                                    <table class="tablaFiltroReporte" cellpading="0px" cellspacing="0px" style="width:100%">
                                        <thead><tr><td></td><td>Areas Habilitadas</td></tr></thead>
                                        <tbody>
                                            <%
                                                consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,isnull(uap.COD_AREA_EMPRESA,0) as habilitado")
                                                                    .append(" from areas_empresa ae ")
                                                                            .append(" left outer join USUARIOS_AREA_PRODUCCION uap on uap.COD_AREA_EMPRESA = ae.COD_AREA_EMPRESA")
                                                                            .append(" and uap.COD_PERSONAL = ").append(codPersonal)
                                                                    .append(" where ae.COD_ESTADO_REGISTRO=1")
                                                                    .append(" order by case when uap.COD_AREA_EMPRESA > 0 then 0 else 1 end,ae.NOMBRE_AREA_EMPRESA");
                                                System.out.println("consulta areas habilitadas : "+consulta.toString());
                                                res = st.executeQuery(consulta.toString());
                                                while(res.next()){
                                                    out.println("<tr>");
                                                        out.println("<td><input value='"+res.getInt("COD_AREA_EMPRESA")+"' id='codAreaEmpresa"+res.getInt("COD_AREA_EMPRESA")+"' type='checkbox' name='codAreaEmpresa' "+(res.getInt("habilitado") > 0 ? "checked" : "")+"/></td>");
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
                                                consulta = new StringBuilder("select aa.COD_ALMACENACOND,aa.NOMBRE_ALMACENACOND,isnull(ua.cod_almacen,0) as habilitado")
                                                                        .append(" from ALMACENES_ACOND aa")
                                                                                .append(" left outer join usuarios_alamacen_acond ua on ua.cod_almacen = aa.COD_ALMACENACOND")
                                                                                .append(" and ua.cod_personal =").append(codPersonal)
                                                                        .append(" where aa.COD_ESTADO_REGISTRO=1")
                                                                        .append(" order by case when ua.cod_almacen > 0 then 0 else 1 end, aa.NOMBRE_ALMACENACOND");
                                                System.out.println("consulta almacen habilitado: "+consulta.toString());
                                                res = st.executeQuery(consulta.toString());
                                                while(res.next()){
                                                    out.println("<tr>");
                                                        out.println("<td><input "+(res.getInt("habilitado") > 0 ? "checked" : "")+" value='"+res.getInt("COD_ALMACENACOND")+"' id='codAlmacenAcond"+res.getInt("COD_ALMACENACOND")+"' type='checkbox' name='codAlmacenAcond'/></td>");
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
                </table>

            </div>
            <br>
            <center>
                <a class="btn" onclick="editarUsuarioModulo(<%=(codPersonal)%>)">Guardar</a>
                <a class="btn" onclick="window.location.href='navegadorUsuariosModulos.jsf?cancel='+(new Date()).getTime().toString()">Cancelar</a>
            </center>
            <script src="../../js/chosen.js"></script>
        </form>
        <script type="text/javascript" scr="../../chosen.js"/> 
    </body>
</html>