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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/mensajejs.css" />
            <script type="text/javascript" src='../../reponse/js/websql.js' ></script>
            <script type="text/javascript" src='../../reponse/js/utiles.js' ></script>
            <script type="text/javascript" src='../../reponse/js/scriptIndirectos.js' ></script>
            <style>
                .buttonIndirectos
                {
                    margin-top:10em;
                    cursor:hand;
                    font-weight:bold;
                    -webkit-transform:rotate(90deg);
                    position:fixed;
                    margin-left:-2.5em;
                    color:white;
                    padding:0.5em;
                    border-top-right-radius:14px;
                    border-top-left-radius:14px;
                    background: linear-gradient(to bottom, rgba(203,96,179,1) 0%,rgba(173,18,131,1) 50%,rgba(222,71,172,1) 100%);
                }
            </style>
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
                function volverLogin()
                {
                    bloquearIndirectos();
                    window.location.href='../loginIndirectos.jsf?data='+(new Date()).getTime().toString();
                }
            </script>
        </head>
        
        
        <body>
            <div class="buttonIndirectos" onclick="window.location.href='../../registroTiemposAlmacen/navegadorProgramaProduccion.jsf?ca=76&p='+codPersonalIndirecta+'&data='+(new Date()).getTime().toString();"><span style="">DIRECTOS</span></div>
            <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load3.GIF"  style="z-index:151; "><%--margin-top:2%;position:fixed;--%>
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
                           int codPersonal=Integer.valueOf(request.getParameter("p"));
                           int administrador=0;
                           String nombrePersonal="";
                           int codProgramaProd=0;
                           String personalSession="";
                           String pendiente="";
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
                                if(administrador==0)
                                {
                                        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                                        consulta="select cp.NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION,ap.NOMBRE_ACTIVIDAD,"+
                                                " s.FECHA_INICIO,cp.COD_CAMPANIA_PROGRAMA_PRODUCCION,ap.COD_ACTIVIDAD"+
                                                " from SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL s "+
                                                " inner join ACTIVIDADES_PRODUCCION ap on s.COD_ACTIVIDAD_PROGRAMA=ap.COD_ACTIVIDAD"+
                                                " inner join CAMPANIA_PROGRAMA_PRODUCCION cp on "+
                                                " cp.COD_CAMPANIA_PROGRAMA_PRODUCCION=s.COD_CAMPANIA_PROGRAMA_PRODUCCION"+
                                                " where isnull(s.REGISTRO_CERRADO,0)=0 and s.COD_PERSONAL='"+codPersonal+"'"+
                                                " and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'"+
                                                " order by s.FECHA_INICIO desc";
                                        System.out.println("consulta verificar registros pendientes anteriores "+consulta);
                                        res=st.executeQuery(consulta);
                                        sdf=new SimpleDateFormat("dd/MM/yyyy");
                                        if(res.next())
                                        {
                                            pendiente="fechaSistemaGeneral='"+sdf.format(new Date())+"';";
                                            sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                            pendiente+="confirmJs('Tiene un registro pendiente:<br>" +
                                                      "<b>Campaña:</b>"+res.getString("NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION")+"<br><b>Actividad:</b>"+res.getString("NOMBRE_ACTIVIDAD")+"" +
                                                      "<br>Desea cerrar la actividad?',function(result)" +
                                                      "{if(result){terminarTiempoCampania('"+res.getString("COD_CAMPANIA_PROGRAMA_PRODUCCION")+"','"+res.getInt("COD_ACTIVIDAD")+"','"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"');}});";
                                        }
                                        else
                                        {
                                            sdf=new SimpleDateFormat("yyyy/MM/dd");
                                                consulta="select top 1 s.COD_PROGRAMA_PROD,s.COD_LOTE_PRODUCCION,s.COD_FORMULA_MAESTRA,"+
                                                        " s.COD_COMPPROD,s.COD_TIPO_PROGRAMA_PROD,"+
                                                        " pp.NOMBRE_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,cp.nombre_prod_semiterminado"+
                                                        " ,s.FECHA_INICIO,ap.NOMBRE_ACTIVIDAD,s.COD_ACTIVIDAD_PROGRAMA"+
                                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s inner join"+
                                                        " PROGRAMA_PRODUCCION_PERIODO pp on pp.COD_PROGRAMA_PROD=s.COD_PROGRAMA_PROD"+
                                                        " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=s.COD_TIPO_PROGRAMA_PROD"+
                                                        " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=s.COD_COMPPROD" +
                                                        " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=s.COD_ACTIVIDAD_PROGRAMA"+
                                                        " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD =afm.COD_ACTIVIDAD"+
                                                        " where s.COD_PERSONAL='"+codPersonal+"'"+
                                                        " and s.REGISTRO_CERRADO=0"+
                                                        " and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'"+
                                                        " order by s.FECHA_INICIO DESC";
                                                    System.out.println("consulta verificar registro cerrado "+consulta);
                                                    res=st.executeQuery(consulta);
                                                    sdf=new SimpleDateFormat("dd/MM/yyyy");
                                                    if(res.next())
                                                    {
                                                        pendiente="fechaSistemaGeneral='"+sdf.format(new Date())+"';";
                                                        sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                                        pendiente+="confirmJs('Tiene un registro pendiente:<br>" +
                                                                  "<b>Lote:</b>"+res.getString("COD_LOTE_PRODUCCION")+"<br><b>Actividad:</b>"+res.getString("NOMBRE_ACTIVIDAD")+"" +
                                                                  "<br>Desea cerrar la actividad?',function(result)" +
                                                                  "{if(result){terminarTiempoDirecto('"+res.getString("COD_LOTE_PRODUCCION")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getInt("COD_FORMULA_MAESTRA")+"'," +
                                                                  "'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_ACTIVIDAD_PROGRAMA")+"','"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"');}});";
                                                    }
                                                    else
                                                    {
                                                        sdf=new SimpleDateFormat("yyyy/MM/dd");
                                                        consulta="select ap.NOMBRE_ACTIVIDAD,s.COD_AREA_EMPRESA,s.COD_ACTVIDAD,s.COD_PROGRAMA_PROD,s.FECHA_INICIO"+
                                                                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s"+
                                                                 " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=s.COD_ACTVIDAD"+
                                                                 " where s.COD_PERSONAL='"+codPersonal+"'"+
                                                                 " and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00' AND (s.REGISTRO_CERRADO=0 or s.REGISTRO_CERRADO is null)";
                                                        System.out.println("consulta pendiente indirecta "+consulta);
                                                        res=st.executeQuery(consulta);
                                                        sdf=new SimpleDateFormat("dd/MM/yyyy");
                                                        if(res.next())
                                                        {
                                                                pendiente="fechaSistemaGeneral='"+sdf.format(new Date())+"';";
                                                                sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                                                pendiente+="confirmJs('Tiene un registro pendiente:<br>" +
                                                                          "<b>Actividad Indirecta:</b>"+res.getString("NOMBRE_ACTIVIDAD")+"" +
                                                                          "<br>Desea cerrar la actividad?',function(result)" +
                                                                          "{if(result){terminarTiempoIndirectoPendiente('"+res.getString("COD_PROGRAMA_PROD")+"','"+res.getInt("COD_AREA_EMPRESA")+"','"+res.getInt("COD_ACTVIDAD")+"','"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"','"+codPersonal+"');}});";
                                                        }
                                                    }
                                        }

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
                                <li onclick="sqlConnection.terminarSessionUsuario(function(){volverLogin();});"><span class="textHeaderClass">Salir</span></li>

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

          <script src="../../reponse/js/mensajejs.js"></script>
          <script>
              <%=(pendiente)%>;
              sqlConnection.verificarUsuarioLogin(null,function(){alertJs("NO INICIO SESSION",function(){volverLogin();})}); </script>
    </html>
</f:view>


