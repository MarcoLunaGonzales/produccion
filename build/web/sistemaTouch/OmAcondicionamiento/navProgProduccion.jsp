<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>

    <html>
        <head>
            <title>OM ACONDICIONAMIENTO</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <script src="../reponse/js/variables.js"></script>
            <script src="../reponse/js/websql.js"></script>
            <script src="../reponse/js/utiles.js"></script>
            <script language="javascript" type="text/javascript">
                var codTipoPermiso=0;
                var codPersonal=0;
                var codAreaEmpresaUsuario=0;
                var sizeModal=0;
               var myVar=null;
               var div1=null;
                function verModal()
                {

                     div1=document.getElementById('divBuscar');
                     sizeModal=parseInt(div1.offsetWidth);

                     div1.style.left=-sizeModal;
                     div1.style.visibility='visible';
                      clearInterval(myVar);
                     myVar=setInterval(function(){showModal()},40);
                }
                function  ocultarModal()
                {

                    //sizeModal=parseInt(div1.offsetWidth);

                     clearInterval(myVar);
                    myVar=setInterval(function(){hideModal()},40);
                    document.getElementById('divBuscar').blur();
                    document.getElementById('divBuscar').focus();

                    window.scrollY='0px';

                }
                function hideModal()
                {
                    if(sizeModal>0)
                    {
                        div1.style.left=sizeModal-div1.offsetWidth;

                    }
                    else
                    {
                        div1.style.visibility='hidden';

                        clearInterval(myVar);
                    }
                    sizeModal-=60;
                }
                function showModal()
                {

                    if(sizeModal>0)
                    {
                        div1.style.left=-sizeModal;

                    }
                    else
                    {


                        div1.style.left=0;
                        clearInterval(myVar);

                    }
                    sizeModal-=60;
                }
               
                function openPopup(url){
                    //alert(url);
                    var a=Math.random();
                    var name="registro touch"+Math.random();
                    window.open(url+'&a='+a+'&admin='+administrador,name,'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                function nuevoAjax()
                {	var xmlhttp=false;
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
                
                function iniciarTransaccionAcondicionamiento(codHoja,codComprod,codTipoProgramaProd,codProgramaProd,codLoteProduccion)
                {
                    var urlHoja
                    switch(codHoja)
                    {
                        case 1:urlHoja="lavadoAmpollasDosificadas/registroLavadoAmpollasDosificadas.jsf";
                                break;
                        case 2:urlHoja=('inspeccionAmpollasDosificadas/registroInspeccionAmpollasDosificadas.jsf');//codTipoPermiso==12?'inspeccionAmpollasDosificadas/revisionInspeccionAmpollasDosificadas.jsf':
                               break;
                        case 3:urlHoja="controlTimbradoEnvasePrimario/registroControlTimbradoEnvasePrimario.jsf";
                                break;
                        case 4:urlHoja="entregaMaterialEmpaqueSecundario/registroEntregaMaterialEmpaqueSecundario.jsf";
                                break;
                        case 5:urlHoja="controlTimbradoEmpaqueSecundario/registroControlTimbradoEmpaqueSecundario.jsf";
                                break;
                        case 6:urlHoja="encunadoDesencunadoAmpollas/registroEncunadoDesencunado.jsf";
                                break;
                        case 7:urlHoja="procesoAcondicionamiento/registroProcesoAcondicionamiento.jsf";
                                break;
                        case 8:urlHoja=(codTipoPermiso==12?'devolucionMaterialAcond/registroAprobacionGeneracionSolicitudDevolucion.jsf':'devolucionMaterialAcond/registroDevolucionMaterialAcond.jsf');
                                break;
                        case 9:urlHoja="rendimientoFinal/registroRendimientoFinal.jsf";
                                break;
                        case 10:urlHoja="limpiezaCapsulas/registroLimpiezaCapsulas.jsf";
                                break;
                    }
                    urlHoja+="?codCompProd="+codComprod+"&codLote="+codLoteProduccion+"&codAreaEmpresa="+codAreaEmpresaUsuario+
                              "&codTipoProgramaProd="+codTipoProgramaProd+
                             "&codProgramaProd="+codProgramaProd+"&codPersonal="+codPersonalGeneral+"&codTipoPermiso="+codTipoPermiso+"&data="+(new Date()).getTime().toString();
                   window.open(urlHoja,("registro touch "+(new Date()).getTime().toString()),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                function buscarLote()
                {

                    ajax=nuevoAjax();
                    var div_lotes=document.getElementById("divLotesProduccion");
                    var lote=document.getElementById("codLote");
                    var codProgProd=document.getElementById('codProgProd').value;
                    iniciarProgresoSistema();
                    ajax.open("GET","ajaxMostrarLotesFiltro.jsf?codLote="+lote.value+
                              "&codProgramaProd="+codProgProd+"&a="+Math.random()+
                              "&codAreaEmpresaUsuario="+codAreaEmpresaUsuario+
                              "&codPersonal="+(codPersonal)+
                              "&codTipoPermiso="+(codTipoPermiso),true);
                    ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            div_lotes.innerHTML=ajax.responseText;
                            terminarProgresoSistema();
                            document.getElementById("changeUsuario").style.visibility='hidden';
                          // ocultarModal();
                        }
                    }

                    ajax.send(null);


                }
                function cambiarEstadoLote(codLote,codProgramaProd,codTipoProgramaProd,codCompProd,loteHabilitado)
                {
                    
                    ajax=nuevoAjax();
                    var peticion="ajaxCambiarEstadoLote.jsf?codLote="+codLote+
                        "&codProgramaProd="+codProgramaProd+
                        "&codTipoProgramaProd="+codTipoProgramaProd+
                        "&codCompProd="+codCompProd+
                        "&loteHabilitado="+(loteHabilitado?1:0)+
                        "&mat="+Math.random()+"&time="+(new Date()).getTime();
                    ajax.open("GET",peticion,true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) {
                            if(ajax.responseText==null || ajax.responseText=='')
                            {
                                alert('No se puede conectar con el servidor, verfique su conexión a internet');
                                document.getElementById('formsuper').style.visibility='hidden';
                                document.getElementById('divImagen').style.visibility='hidden';
                                return false;
                            }
                            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                            {
                                buscarLote();
                                return true;
                            }
                            else
                            {
                                alert(ajax.responseText.split("\n").join(""));
                                document.getElementById('formsuper').style.visibility='hidden';
                                document.getElementById('divImagen').style.visibility='hidden';
                                return false;
                            }
                        }
                    }

                    ajax.send(null);
                }
                function consultarCambioUsuario()
                {
                    ajax=nuevoAjax();
                    var peticion="ajaxCambiarUsuario.jsf?nombreUsuario="+document.getElementById("codUsuarioNuevo").value+
                        "&contrasena="+document.getElementById("contrasenaUsuario").value+
                        "&codAreaEmpresaUsuario="+codAreaEmpresaUsuario+
                        "&mat="+Math.random()+"&time="+(new Date()).getTime();
                    //console.log(peticion);
                    ajax.open("GET",peticion,true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) {
                            eval(ajax.responseText);
                            if(codPersonalGeneral==0)
                            {
                                alert('Usuario/Contraseña Incorrecto');

                            }
                            else
                            {

                                if(parseInt(document.getElementById("tablaLotesProcesar").rows.length)>1)
                                {
                                    buscarLote();
                                }
                                document.getElementById("changeUsuario").style.visibility='hidden';
                                document.getElementById('formsuper').style.visibility='hidden';
                            }
                        }
                    }

                    ajax.send(null);
                }
                function cambiarUsuario()
                {
                    iniciarProgresoSistema();
                    document.getElementById("codUsuarioNuevo").value='';
                    document.getElementById("contrasenaUsuario").value='';
                    document.getElementById("changeUsuario").style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='hidden';
                }
                sqlConnection.crearTabla();

            </script>
<style>
    button
    {
        position:inherit !important;
    }
</style>
        </head>

           <body >

               <div class="divHeaderLogin">
                   <table style="margin-bottom:0em !important;background:none !important;border:none !important" cellpadding="0" cellspacing="0">
                       <tr>
                       <td>
                       <span class="textHeaderClass">Prog. Prod</span>
                       </td><td style="padding-bottom:0em !important;padding-top:1em !important">
                       <select  id="codProgProd">
                           <option value="0">-TODOS-</option>
                           <%
                           String codAreaEmpresaUsuario=request.getParameter("codAreaEmpresa");
                           String codPersonal=request.getParameter("p");
                           int codTipoPermiso=0;
                           String nombrePersonal="";
                           String personalSession="";
                           
                                    try
                                    {
                                        Connection con=null;
                                        con=Util.openConnection(con);
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet res=st.executeQuery("select ppp.COD_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO ppp where ppp.COD_ESTADO_PROGRAMA<>4 and ppp.COD_PROGRAMA_PROD>=183 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (1) order by ppp.COD_PROGRAMA_PROD");
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                        }
                                        res=st.executeQuery("select (p.AP_PATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)as nombrePersonal " +
                                                            ",isnull(cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS,0) as codTipoPermiso"+
                                                            " from PERSONAL  p"+
                                                            " left outer join CONFIGURACION_PERMISOS_ESPECIALES_ATLAS cpea on cpea.COD_PERSONAL=p.COD_PERSONAL and cpea.COD_TIPO_PERMISO_ESPECIAL_ATLAS in (11,12)" +
                                                            " where p.COD_PERSONAL='"+codPersonal+"'");

                                        if(res.next())
                                        {
                                            nombrePersonal=res.getString("nombrePersonal");
                                            codTipoPermiso=res.getInt("codTipoPermiso");
                                        }
                                        String consulta="SELECT um.COD_PERSONAL,um.NOMBRE_USUARIO FROM USUARIOS_MODULOS um inner join PERSONAL p "+
                                                        " on p.COD_PERSONAL=um.COD_PERSONAL and p.COD_ESTADO_PERSONA=1"+
                                                        " where (p.COD_AREA_EMPRESA=102 or p.cod_personal in (select a.COD_PERSONAL from ADMINISTRADORES_TABLETA a where a.COD_AREA_EMPRESA in (102))" +
                                                        " or p.cod_personal in (select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap where pap.COD_AREA_EMPRESA=102)) and um.COD_MODULO=6 order by um.NOMBRE_USUARIO";
                                        res=st.executeQuery(consulta);

                                        while(res.next())
                                        {
                                            personalSession+="<option value='"+res.getString("COD_PERSONAL")+"'>"+res.getString("NOMBRE_USUARIO")+"</option>";
                                        }
                                        st.close();
                                        con.close();
                                    }
                                    catch(SQLException ex)
                                    {
                                        ex.printStackTrace();
                                    }
                           
                           %>
                              

                       </select>
                       </td>
                       <td >
                       <span class="textHeaderClass">Lote</span>
                       </td>
                       <td style="padding-bottom:0em !important;">
                           <input type="tel" id="codLote" />
                       </td>
                       <td>
                           <div id="buttonBuscar" onclick="buscarLote();"  alt="buscar">
                                 <img src="../reponse/img/lupa.gif" style="width:2.1em" alt="Buscar" ><span class="textHeaderClass">Buscar&nbsp;&nbsp;</span>
                           </div>
                       </td>
                       <td>
                           <%--div id="buttonMas buttonBuscar " onclick="actualizarDatos();" style="padding:0.5em" alt="buscar">
                             <span class="textHeaderClass">Actualizar</span>
                           </div--%>
                       </td>
                       </tr>


                 </table>
                 <nav>
                          <li class="parent"><span class="textHeaderClass" id="nombreUsuarioPersonal"><%=(nombrePersonal)%></span>
                             <ul>
                                <li><span class="textHeaderClass">Cambiar Contraseña</span></li>
                                <li onclick="cambiarUsuario();"><span class="textHeaderClass">Cambiar Usuario</span></li>
                                <li onclick="window.location.href='../login.jsf?codArea=84,102'"><span class="textHeaderClass">Salir</span></li>

                             </ul>
                          </li>
                       </nav>
               </div>
                   <div style="margin-top:2%;position:fixed;width:100%;z-index:200;visibility:hidden" id="divImagen">
                 <center><img src="../reponse/img/load2.gif"  style="z-index:205; "><%--margin-top:2%;position:fixed;--%>
                 </center>
               </div>
                 <section class="main" style="margin-top:4em;width:100%;" >

                         <div  style="width:100%" id="divLotesProduccion"><%--class="large-12 medium-12 small-12 columns"--%>
                         <table cellpadding="0px" cellspacing="0px" style="width:100%" id="tablaLotesProcesar">
                             <tr><td class="tableHeaderClass" style="width:30%"><span class="textHeaderClass">Producto</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Lote</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Nro Lote</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Programa Produccion</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Area</span></td>
                             <%
                             if(codAreaEmpresaUsuario.equals("102"))
                                 out.println("<td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lavado<br>Ampollas<br>Dosificadas</span></td>"+
                                             "<td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Revisado<br>Ampollas<br>Dosificadas</span></td>");
                             %>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Timbrado<br>Empaque<br>Primario</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Entrega<br>Material<br>Secundario</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Timbrado<br>Empaque<br>Secundario</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Proceso<br>Acondicionamiento</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Devolucion<br>de<br>Material</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Control<br>Llenado<br>Volumen</span></td>
                         </table>
                                 

                     </div>
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
                                    <input  type="text" value="" autocomplete="off" list="languages" id="codUsuarioNuevo" placeHolder="USUARIO">
                                    <datalist id="languages">
                                    <%
                                    Connection con=null;
                                    try
                                    {
                                        con=Util.openConnection(con);
                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        StringBuilder consulta=new StringBuilder("select u.NOMBRE_USUARIO");
                                                                consulta.append(" from USUARIOS_MODULOS u ");
                                                                        consulta.append(" inner join PERSONAL_AREA_PRODUCCION pap on pap.COD_PERSONAL=u.COD_PERSONAL");
                                                                consulta.append(" where u.COD_MODULO=10");
                                                                        consulta.append(" and pap.COD_AREA_EMPRESA in (84,102)");
                                                                consulta.append(" order by u.NOMBRE_USUARIO");
                                        System.out.println("consulta usuarios "+consulta.toString());
                                        ResultSet res=st.executeQuery(consulta.toString());
                                        while(res.next())
                                        {
                                            out.println("<option value='"+res.getString("NOMBRE_USUARIO")+"'/>");
                                        }
                                        st.close();
                                        con.close();
                                    }
                                    catch(SQLException ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                    finally
                                    {
                                        con.close();
                                    }
                                    %>
                                </datalist>
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
                                    <input type="password" value="" id="contrasenaUsuario"/>
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
                                    font-weight:bold; width: 12em" onclick="var a=Math.random();window.location.href='../login.jsf?codArea=84,102&cencel'+a;">Cancelar</button></td>
                            </tr>
                        </table>
                         </center>
                     </div>
                     <div  id="formsuper"  style="
                            padding: 50px;
                            background-color: #cccccc;
                            position:fixed;
                            z-index: 150;
                            left:0px;
                            top: 0px;
                            border :2px solid #3C8BDA;
                            width:100%;
                            height:100%;
                            filter: alpha(opacity=70);
                            visibility:hidden;
                            opacity: 0.8;" >

                      </div>

            </section>





        </body>
        <script>
              codPersonalGeneral=<%=(codPersonal)%>;
              codAreaEmpresaUsuario='84,102';
              codTipoPermiso=<%=(codTipoPermiso)%>
        </script>
    </html>

</f:view>

