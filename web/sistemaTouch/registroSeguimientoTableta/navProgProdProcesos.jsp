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
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <script src="../reponse/js/websql.js"></script>
            <script language="javascript" type="text/javascript">
                var administrador=0;
                var codPersonal=0;
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
                function registroOM(codHoja,codForma,codCompProd,codLoteProduccion,codAreaEmpresa,codProgramaProd,codPersonal)
                {
                   var ventana='';
                   switch(codHoja)
                   {
                        case 3:ventana=(codForma==2?"registroEtapaLavado/registroEtapaLavado.jsf":"registroEtapaLavadoColirios/registroEtapaLavadoColirios.jsf");
                               break;
                        case 6:ventana=(codForma==2?"registroDosificado/registroDosificado.jsf":"registroDosificadoColirios/registroDosificadoColirios.jsf");
                               break;
                        case 7:ventana=(codForma==2?"registroControlLlenadoVolumen/registroControlLlenadoVolumen.jsf":"registroControlLlenadoVolumenColirios/registroControlLlenadoVolumenColirios.jsf");
                               break;
                        case 8:ventana=(codForma==2?"registroControlDosificado/registroControlDosificado.jsf":"registroControlDosificadoColirios/registroControlDosificadoColirios.jsf");
                               break;
                        case 10:ventana=(codForma==2?"registroRendimientoDosificado/registroRendimientoDosificado.jsf":"registroRendimientoDosificadoColirios/registroRendimientoDosificadoColirios.jsf");
                               break;
                        case 12:ventana="asignacionTareasOM/registroTareasOM.jsf";
                                break;
                        case 13:ventana="registroGrafadoFrascos/registroGrafadoFrascos.jsf";
                                break;
                        default: ventana='';
                            break;
                   }
                   openPopup(ventana+"?codComprod="+codCompProd+"&codLote="+codLoteProduccion+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProd+"&codPersonal="+codPersonal);
                    
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
                function mostrarBloqueo()
                {
                    document.getElementById('formsuper').style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='visible';
                }
                function buscarLote()
                {

                    ajax=nuevoAjax();
                    var div_lotes=document.getElementById("divLotesProduccion");
                    var lote=document.getElementById("codLote");
                    var codProgProd=document.getElementById('codProgProd').value;
                    mostrarBloqueo();
                    ajax.open("GET","ajaxMostrarLotesFiltro.jsf?codLote="+lote.value+
                              "&codProgramaProd="+codProgProd+"&a="+Math.random()+
                              "&codPersonal="+(codPersonal)+"&administrador="+administrador,true);
                    ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            div_lotes.innerHTML=ajax.responseText;
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            document.getElementById("changeUsuario").style.visibility='hidden';
                          
                        }
                    }

                    ajax.send(null);
                    

                }
                function cambiarUsuario()
                {
                    
                    mostrarBloqueo();
                    
                    document.getElementById("contrasenaUsuario").value='';
                    document.getElementById("changeUsuario").style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='hidden';
                }
                

                function consultarCambioUsuario()
                {
                    ajax=nuevoAjax();
                    var peticion="ajaxCambiarUsuario.jsf?nombreUsuario="+document.getElementById("nombreUsuarioCambio").value+
                        "&contrasena="+document.getElementById("contrasenaUsuario").value+
                        "&mat="+Math.random()+"&time="+(new Date()).getTime();
                    console.log(peticion);
                    ajax.open("GET",peticion,true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) {
                            eval(ajax.responseText);
                            if(codPersonal==0)
                            {
                                alert('Usuario/Contraseņa Incorrecto');

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

                function consultarCambioPassword()
                {

                    if(document.getElementById("contrasena2Cambio").value!=document.getElementById("contrasena3Cambio").value)
                    {
                        alert('La contraseņa nueva no coincide,intente de nuevo');
                        return null;
                    }
                    ajax=nuevoAjax();
                    var peticion="ajaxCambiarPassword.jsf?nombreUsuario="+document.getElementById("codUsuarioChange").value+
                        "&contrasena="+document.getElementById("contrasena1Cambio").value+
                        "&contrasenaNueva="+document.getElementById("contrasena2Cambio").value+
                        "&mat="+Math.random()+"&time="+(new Date()).getTime();
                    ajax.open("GET",peticion,true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) {

                            if(parseInt(ajax.responseText)==0)
                            {
                                alert('Usuario/Contraseņa Incorrecto');

                            }
                            else
                            {
                                alert('Cambio de contraseņa exitoso');
                                document.getElementById("changePassword").style.visibility='hidden';
                                document.getElementById("codUsuarioNuevo").value=document.getElementById("codUsuarioChange").value;
                                document.getElementById("contrasenaUsuario").value=document.getElementById("contrasena2Cambio").value;
                                //document.getElementById('formsuper').style.visibility='hidden';
                                consultarCambioUsuario();
                            }
                        }
                    }

                    ajax.send(null);

                }

                function cambiarPasword()
                {
                    mostrarBloqueo();
                    document.getElementById("codUsuarioChange").value='';
                    document.getElementById("contrasena1Cambio").value='';
                    document.getElementById("contrasena2Cambio").value='';
                    document.getElementById("contrasena3Cambio").value='';
                    document.getElementById("changePassword").style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='hidden';
                }
                sqlConnection.crearTabla();
                sqlConnection.mostrarDatosPendientesRegistro();
            </script>
            
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
                           String codPersonal=request.getParameter("p");
                           int administrador=0;
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
                                                    ",isnull(adm.COD_PERSONAL,0) as registrado from PERSONAL  p LEFT OUTER JOIN ADMINISTRADORES_TABLETA adm on" +
                                                    " adm.COD_PERSONAL=p.COD_PERSONAL and adm.COD_FORMA=2" +
                                                    " where p.COD_PERSONAL='"+(Integer.valueOf(codPersonal)/4)+"'");
                                if(res.next())
                                {
                                    nombrePersonal=res.getString("nombrePersonal");
                                    administrador=res.getInt("registrado");
                                }
                                String consulta="";
                                if(nombrePersonal.equals(""))
                                {
                                    consulta="select pt.COD_PERSONAL,(pt.AP_PATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL) as nombrePersonal from PERSONAL_TEMPORAL pt where pt.COD_PERSONAL='"+(Integer.valueOf(codPersonal)/4)+"'";
                                    System.out.println("cond "+consulta);
                                    res=st.executeQuery(consulta);
                                    if(res.next())
                                    {
                                        nombrePersonal=res.getString("nombrePersonal");
                                    }
                                }
                                consulta="select u.NOMBRE_USUARIO"+
                                         " from USUARIOS_MODULOS u inner join PERSONAL_AREA_PRODUCCION pap on "+
                                         " u.COD_PERSONAL=pap.COD_PERSONAL"+
                                         " where pap.COD_AREA_EMPRESA=81 and u.cod_modulo=10";
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    personalSession+="<option value='"+res.getString("NOMBRE_USUARIO")+"'/>";
                                }


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
                       <td style="padding-bottom:0em !important;padding-top:1em !important">
                           <input type="tel" id="codLote" style="height:2em !important"/>
                       </td>
                       <td>
                           <div id="buttonBuscar" onclick="buscarLote();"  alt="buscar">
                                 <img src="../reponse/img/lupa.gif" style="width:2.1em" alt="Buscar" ><span class="textHeaderClass">Buscar&nbsp;&nbsp;</span>
                           </div>
                       </td>
                       </tr>
                       
                   
                 </table>
                 <nav>
                          <li class="parent"><span class="textHeaderClass" id="nombreUsuarioPersonal"><%=(nombrePersonal)%></span>
                             <ul>
                                <li onclick="cambiarPasword();"><span class="textHeaderClass">Cambiar Contraseņa</span></li>
                                <li onclick="cambiarUsuario();"><span class="textHeaderClass">Cambiar Usuario</span></li>
                                <li onclick="window.location.href='../login.jsf'"><span class="textHeaderClass">Salir</span></li>
                                
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
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Limpieza<br>Ambientes</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Repesada</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Procesos<br>Lavado</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Proceso<br>Despi.</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Proceso<br>Preparado</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Dosificado</span></td>
                             <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Control<br>Llenado<br>Volumen/Peso</span></td>
                             <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Control<br>Dosificado</span></td>
                             <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Est.<br>Calor<br>Humedo</span></td>
                             <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Rend.<br>Dosif.</span></td>
                             <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Asig.<br>Tareas</span></td>
                         </table>
                                 
                     </div>
                     <div style="z-index:160; position:fixed;top:4em; width:100%;visibility:hidden" id="changePassword">
                         <center>
                        <table cellpadding="0" cellspacing="0" >
                            <thead>
                                <tr  style="background:none !important;">
                                    <td colspan="3" class="divHeaderClass" style="padding:1em;">
                                        <span class="textHeaderClass">Cambio Contraseņa</span>
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
                                    <select id="codUsuarioChange"><%=(personalSession)%></select>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding:0.5em;border-left: solid #a80077 1px;">
                                    <span class="textHeaderClassBody">Contraseņa</span>
                                </td>
                                <td style="padding:0.5em;">
                                    <span class="textHeaderClassBody">::</span>
                                </td>
                                <td style="padding:0.5em;border-right: solid #a80077 1px;">
                                    <input type="password" value="" id="contrasena1Cambio"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding:0.5em;border-left: solid #a80077 1px;">
                                    <span class="textHeaderClassBody">Contraseņa Nueva</span>
                                </td>
                                <td style="padding:0.5em;">
                                    <span class="textHeaderClassBody">::</span>
                                </td>
                                <td style="padding:0.5em;border-right: solid #a80077 1px;">
                                    <input type="password" value="" id="contrasena2Cambio"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding:0.5em;border-left: solid #a80077 1px;">
                                    <span class="textHeaderClassBody">Contraceņa nueva</span>
                                </td>
                                <td style="padding:0.5em;">
                                    <span class="textHeaderClassBody">::</span>
                                </td>
                                <td style="padding:0.5em;border-right: solid #a80077 1px;">
                                    <input type="password" value="" id="contrasena3Cambio"/>
                                </td>
                            </tr>
                            
                            <tr>
                                <td style="padding-right:1.5em;padding-left:1.5em;border: solid #a80077 1px;border-top:none;border-bottom-left-radius: 10px;
                                    border-bottom-right-radius: 10px;" colspan="3" align="center" >
                                    <button class="buttonAction" style="height:2.2em;border-top-left-radius: 10px;
                                    border-top-right-radius: 10px;
                                    border-bottom-left-radius: 10px;
                                    border-bottom-right-radius: 10px;
                                    font-weight:bold; width: 12em" onclick="consultarCambioPassword();">Aceptar</button>
                                <button class="buttonAction" style="height:2.2em;border-top-left-radius: 10px;
                                    border-top-right-radius: 10px;
                                    border-bottom-left-radius: 10px;
                                    border-bottom-right-radius: 10px;
                                    font-weight:bold; width: 12em" onclick="var a=Math.random();window.location.href='../login.jsf?cencel'+a;">Cancelar</button></td>
                            </tr>
                        </table>
                         </center>
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
                                    <input type="text" list="languages" id="nombreUsuarioCambio"/>
                                    <datalist id="languages">
                                      <%=(personalSession)%>
                                    </datalist>
                                    
                                </td>
                            </tr>
                            <tr>
                                <td style="padding:0.5em;border-left: solid #a80077 1px;">
                                    <span class="textHeaderClassBody">Contraseņa</span>
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
                                    font-weight:bold; width: 12em" onclick="var a=Math.random();window.location.href='../login.jsf?cencel'+a;">Cancelar</button></td>
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
              /*document.getElementById("divPendientes").onclick=function(){
                    openPopup('datosPendientesRegistro/navegadorHojasPendienteRegistro.jsf?a=fecha');};*/
              codPersonal=<%=(codPersonal)%>;
              administrador=<%=(administrador)%>
        </script>
    </html>
    
</f:view>

