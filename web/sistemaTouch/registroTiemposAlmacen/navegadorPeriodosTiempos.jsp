package sistemaTouch.registroTiemposIndirectosProduccion_1;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/mensajejs.css" />
            <script>
               
                var codPersonalIndirecta=0;
                var codAreaEmpresaIndirecta=0;
                var codProgramaProdIndirecta=0;
                function bloquearIndirectos()
                {
                    document.getElementById('formsuper').style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='visible';
                }
                function desBloquearIndirectos()
                {
                    document.getElementById('formsuper').style.visibility='hidden';
                    document.getElementById('divImagen').style.visibility='hidden';
                }
                 function cambiarUsuario()
                {

                    bloquearIndirectos();
                    document.getElementById("codUsuarioNuevo").value='';
                    document.getElementById("contrasenaUsuario").value='';
                    document.getElementById("changeUsuario").style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='hidden';
                }
            </script>
        </head>
        
        
        <body>
            <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../reponse/img/load3.GIF"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
            <div class="divHeaderLogin"  align="center">
                   <table style="margin-bottom:0em !important;background:none !important;border:none !important" cellpadding="0" cellspacing="0">
                       <tr>
                       <td style="width:50%" align="left">
                       <span class="textHeaderClass">Programa Produccion::</span>
                       </td>
                       <td style="padding-bottom:0em !important;padding-top:1em !important;width:50%" align="right">
                       <select  id="codProgProd">
                           <%
                           String codPersonalr=request.getParameter("p");
                           System.out.println("cod personal "+codPersonalr);
                           int codPersonal=(Integer.valueOf(codPersonalr)/4);
                           int administrador=0;
                           String nombrePersonal="";
                           int codProgramaProd=0;
                           String personalSession="";
                            try
                            {
                                Connection con=null;
                                con=Util.openConnection(con);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery("SELECT top 1 PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES,isnull(epp.NOMBRE_ESTADO_PROGRAMA_PROD,'') as nombreEstado"+
                                                              " FROM PROGRAMA_PRODUCCION_PERIODO PP left outer join ESTADOS_PROGRAMA_PRODUCCION epp on"+
                                                              " pp.COD_ESTADO_PROGRAMA=epp.COD_ESTADO_PROGRAMA_PROD"+
                                                              " WHERE PP.COD_ESTADO_PROGRAMA <> 4 and ISNULL(PP.COD_TIPO_PRODUCCION, 1) not in (2) order by pp.COD_PROGRAMA_PROD desc");
                                
                                while(res.next())
                                {
                                    codProgramaProd=res.getInt("COD_PROGRAMA_PROD");
                                    out.println("<option value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                }
                                res=st.executeQuery("select (p.AP_PATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)as nombrePersonal " +
                                                    ",isnull(adm.COD_PERSONAL,0) as registrado from PERSONAL  p LEFT OUTER JOIN ADMINISTRADORES_TABLETA adm on" +
                                                    " adm.COD_PERSONAL=p.COD_PERSONAL and adm.COD_FORMA=2" +
                                                    " where p.COD_PERSONAL='"+codPersonal+"'");
                                if(res.next())
                                {
                                    nombrePersonal=res.getString("nombrePersonal");
                                    administrador=res.getInt("registrado");
                                }
                                
                                String consulta="SELECT um.COD_PERSONAL,um.NOMBRE_USUARIO FROM USUARIOS_MODULOS um inner join PERSONAL p "+
                                        " on p.COD_PERSONAL=um.COD_PERSONAL and p.COD_ESTADO_PERSONA=1"+
                                        " where (p.COD_AREA_EMPRESA=81 or p.cod_personal in (select a.COD_PERSONAL from ADMINISTRADORES_TABLETA a where a.COD_AREA_EMPRESA in (81))" +
                                        " or p.cod_personal in (select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap where pap.COD_AREA_EMPRESA=81)) and um.COD_MODULO=6 order by um.NOMBRE_USUARIO";
                                res=st.executeQuery(consulta);

                                while(res.next())
                                {
                                    personalSession+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("NOMBRE_USUARIO")+"</option>";
                                }
                                st.close();
                                con.close();
                                out.println("<script>codPersonalIndirecta='"+codPersonal+"';codAreaEmpresaIndirecta='"+request.getParameter("ca")+"';codProgramaProdIndirecta='"+codProgramaProd+"';</script>");
                            }
                            catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                           catch(Exception ex)
                           {
                               ex.printStackTrace();
                           }
                           %>
                       </select>
                       </td>
                       
                       </tr>


                 </table>
                 <nav>
                          <li class="parent"><span class="textHeaderClass" id="nombreUsuarioPersonal"><%=(nombrePersonal)%></span>
                             <ul>
                                <%--li onclick="cambiarUsuario();"><span class="textHeaderClass">Cambiar Usuario</span></li--%>
                                <li onclick="window.location.href='loginIndirectos.jsf?data='+(new Date()).getTime().toString();"><span class="textHeaderClass">Salir</span></li>

                             </ul>
                          </li>
                       </nav>
            </div>
            <%
            out.println("<iframe style=\"margin-top:4em;width:100%;height:92%\" src=\"navegadorActividadesIndirectas.jsf?ca="+request.getParameter("ca")+"&p="+codPersonal+"&data="+(new Date()).getTime()+"\"></iframe>");
            %>
            
            
        </body>
         <div style="z-index:160; position:fixed;top:4em; width:100%;visibility:hidden" id="changeUsuario">
             <center>
                <table cellpadding="0" cellspacing="0" >
                    <thead>
                        <tr  style="background:none !important;">
                            <td colspan="3" class="divHeaderClass" style="padding:1em;">
                                <span class="textHeaderClass">Login</span>
                            </td>
                        </tr>
                    </thead>
                    <tr>
                        <td style="padding:0.5em !important;border-left: solid #a80077 1px;">
                            <span class="textHeaderClassBody">Usuario</span>
                        </td>
                        <td style="padding:0.5em;">
                            <span class="textHeaderClassBody">::</span>
                        </td>
                        <td style="padding:0.5em;border-right: solid #a80077 1px;">
                            <select id="codUsuarioNuevo"><%=(personalSession)%></select>

                        </td>
                    </tr>
                    <tr>
                        <td style="padding:0.5em;border-left: solid #a80077 1px;">
                            <span class="textHeaderClassBody">Contraseña</span>
                        </td>
                        <td style="padding:0.5em;">
                            <span class="textHeaderClassBody">::</span>
                        </td>
                        <td style="padding:0.5em;border-right: solid #a80077 1px;">
                            <input type="password" value="" id="contrasenaUsuario" placeholder="Contraseña"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-right:1.5em;padding-left:1.5em;border: solid #a80077 1px;border-top:none;border-bottom-left-radius: 10px;
                            border-bottom-right-radius: 10px;" colspan="3" align="center" >
                            <button class="buttonAction" style="height:2.2em;border-top-left-radius: 10px;
                            border-top-right-radius: 10px;
                            border-bottom-left-radius: 10px;
                            border-bottom-right-radius: 10px;
                            font-weight:bold; width: 12em" onclick="consultarCambioUsuario();">Aceptar</button>
                        <button class="buttonAction" style="height:2.2em;border-top-left-radius: 10px;
                            border-top-right-radius: 10px;
                            border-bottom-left-radius: 10px;
                            border-bottom-right-radius: 10px;
                            font-weight:bold; width: 12em" onclick="var a=Math.random();window.location.href='../login.jsf?cencel'+a;">Cancelar</button></td>
                    </tr>
                </table>
             </center>
         </div>
        <div  id="formsuper"  class="formSuper" />

          <script src="../reponse/js/mensajejs.js"></script>
    </html>
</f:view>


