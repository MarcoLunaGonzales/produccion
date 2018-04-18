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
<%@page  import="java.text.SimpleDateFormat" %>
<%@page  import="java.util.Date" %>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/mensajejs.css" />
            <style>
                #tablaLotesProcesar
                {
                    border-collapse:separate;
                    border-spacing:0 5px;
                    width:95%;
                }
                #tablaLotesProcesar tbody
                {
                    padding:1em;
                }
                
                #tablaLotesProcesar  tbody tr td
                {
                    cursor:hand;
                    font-weight:bold;

                }
                .sinRegistro td
                {
                    border:1px solid #777777;
                    color:#777777;
                    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #ffffff), color-stop(1, #dfdfdf));
                    background:-moz-linear-gradient(top, #ffffff 5%, #dfdfdf 100%);
                    background:-webkit-linear-gradient(top, #ffffff 5%, #dfdfdf 100%);
                    background:-o-linear-gradient(top, #ffffff 5%, #dfdfdf 100%);
                    background:-ms-linear-gradient(top, #ffffff 5%, #dfdfdf 100%);
                    background:linear-gradient(to bottom, #ffffff 5%, #dfdfdf 100%);
                    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffff', endColorstr='#dfdfdf',GradientType=0);
                    background-color:#ffffff;
                }
                .registrado td
                {
                    text-shadow:
                   -1px -1px 0 #2f6627,
                    1px -1px 0 #2f6627,
                   -1px 1px 0 #2f6627,
                    1px 1px 0 #2f6627;
                    color:white;
                    border:1px solid #33820e;
                    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #75d147), color-stop(1, #399e06));
                    background:-moz-linear-gradient(top, #75d147 5%, #399e06 100%);
                    background:-webkit-linear-gradient(top, #75d147 5%, #399e06 100%);
                    background:-o-linear-gradient(top, #75d147 5%, #399e06 100%);
                    background:-ms-linear-gradient(top, #75d147 5%, #399e06 100%);
                    background:linear-gradient(to bottom, #75d147 5%, #399e06 100%);
                    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#75d147', endColorstr='#399e06',GradientType=0);
                    background-color:#75d147;
                }
                 .enRegistro td
                {
                    text-shadow:
                   -1px -1px 0 #fa8925,
                    1px -1px 0 #fa8925,
                   -1px 1px 0 #fa8925,
                    1px 1px 0 #fa8925;
                    color:white;
                    border: 1px solid #fa8925;
                    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #ffc477), color-stop(1, #fa8925));
                    background:-moz-linear-gradient(top, #ffc477 5%, #fa8925 100%);
                    background:-webkit-linear-gradient(top, #ffc477 5%, #fa8925 100%);
                    background:-o-linear-gradient(top, #ffc477 5%, #fa8925 100%);
                    background:-ms-linear-gradient(top, #ffc477 5%, #fa8925 100%);
                    background:linear-gradient(to bottom, #ffc477 5%, #fa8925 100%);
                    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffc477', endColorstr='#fa8925',GradientType=0);
                    background-color:#ffc477;
                }
                #tablaLotesProcesar tbody tr td:first-child
                {
                    border-top-left-radius:1em;
                    border-bottom-left-radius:1em;
                    padding:1em;
                }
                #tablaLotesProcesar tbody tr td:last-child
                {
                    border-top-right-radius:1em;
                    border-bottom-right-radius:1em;
                    padding:1em;
                }
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
            <script src="../reponse/js/variables.js"></script>
            <script src="../reponse/js/utiles.js"></script>
            <script src="../reponse/js/scripts.js"></script>
            <script src="../reponse/js/websql.js"></script>
            <script language="javascript" type="text/javascript">
                var administrador=0;
                var codPersonal=0;
                var central=0;
                var sizeModal=0;
               var myVar=null;
               var div1=null;
               function mostrarActividadesCampania(codCampania)
               {
                   codCampaniaGeneral=codCampania;
                   document.getElementById("divLotesProduccion").style.display='none';
                   document.getElementById("frameFransacciones").style.display='';
                   document.getElementById("frameFransacciones").src=
                              "registroCampania/actividadesCampania.jsf?codCampania="+codCampania+
                              "&codPersonal="+codPersonalGeneral+
                              "&data="+(new Date()).getTime().toString()+
                              "&admin="+(administradorSistema?1:0);
                    iniciarProgresoSistema();
                    document.getElementById("frameFransacciones").onload=terminarProgresoSistema;
               }
               function mostrarActividadesProduccion(codLote,codProgramaProd,codComprod,codTipoProgramaProd,fila)
               {
                    codProgramaProdGeneral=codProgramaProd;
                    codLoteGeneral=codLote;
                    codComprodGeneral=codComprod;
                    codTipoProgramaProdGeneral=codTipoProgramaProd;
                    document.getElementById("divLotesProduccion").style.display='none';
                    document.getElementById("frameFransacciones").style.display='';
                    document.getElementById("frameFransacciones").src="actividadesProduccion.jsf?codLote="+codLote+
                              "&codTipoProgramaProd="+codTipoProgramaProd+
                              "&codComprod="+codComprod+
                              "&data="+(new Date()).getTime().toString()+
                              "&codProgramaProd="+codProgramaProd+
                              "&codPersonal="+codPersonalGeneral+
                              "&admin="+(administradorSistema?1:0);
                    iniciarProgresoSistema();
                    document.getElementById("frameFransacciones").onload=terminarProgresoSistema;

               }
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
                function registroOm(codHojaOm,codComprod,codLote,codAreaEmpresa,codProgramaProdLista,codPersonal)
                {
                    var ventana='';
                    switch(codHojaOm)
                    {
                        case 2:ventana=(administrador>0?'inspeccionAmpollasDosificadas/revisionInspeccionAmpollasDosificadas.jsf':'inspeccionAmpollasDosificadas/registroInspeccionAmpollasDosificadas.jsf');
                               break;
                        case 7:ventana=(administrador>0?'devolucionMaterialAcond/registroAprobacionGeneracionSolicitudDevolucion.jsf':'devolucionMaterialAcond/registroDevolucionMaterialAcond.jsf');
                               break;
                        case 11:ventana='asignacionTareasOM/registroTareasOM.jsf';
                               break;

                        default: ventana='';
                               break
                    }
                    console.log(ventana);
                    ventana+="?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"&codPersonal="+codPersonal+"&admin="+administrador+"&data="+(new Date()).getTime().toString();
                    window.open(ventana,("registro touch "+(new Date()).getTime().toString()),'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
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
                function actualizarDatos()
                {

                    ajax=nuevoAjax();
                    mostrarBloqueo();
                    ajax.open("GET","ajaxActualizarInformacion.jsf?a="+Math.random()+
                              "&central="+((new Date()).getTime().toString()) ,true);
                    ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            document.getElementById("changeUsuario").style.visibility='hidden';
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se actualizo la informacion');
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            document.getElementById("changeUsuario").style.visibility='hidden';
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            document.getElementById("changeUsuario").style.visibility='hidden';
                            return false;
                        }

                          // ocultarModal();
                        }
                    }

                    ajax.send(null);


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
                              "&central="+(central?1:0)+
                              "&codPersonal="+(codPersonalGeneral)+"&administrador="+(administradorSistema?1:0),true);
                    ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            div_lotes.innerHTML=ajax.responseText;
                            document.getElementById("divLotesProduccion").style.display='';
                            document.getElementById("frameFransacciones").style.display='none';
                            document.getElementById('formsuper').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            document.getElementById("changeUsuario").style.visibility='hidden';
                          // ocultarModal();
                        }
                    }

                    ajax.send(null);


                }
                function cambiarEstadoLote(codLote,codProgramaProd,loteHabilitado)
                {

                    ajax=nuevoAjax();
                    var peticion="ajaxCambiarEstadoLote.jsf?codLote="+codLote+
                        "&codProgramaProd="+codProgramaProd+
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
                        "&mat="+Math.random()+"&time="+(new Date()).getTime();
                    console.log(peticion);
                    ajax.open("GET",peticion,true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) {
                            eval(ajax.responseText);
                            if(codPersonal==0)
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
                    mostrarBloqueo();
                    document.getElementById("codUsuarioNuevo").value='';
                    document.getElementById("contrasenaUsuario").value='';
                    document.getElementById("changeUsuario").style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='hidden';
                }
                function verificarHorasTrabajadas()
                {
                    mostrarBloqueo();
                    ajax=nuevoAjax();
                    var peticion="ajaxCalcularHorasRegistradas.jsf?codPersonal="+codPersonalGeneral+
                                  "&mat="+Math.random()+"&time="+(new Date()).getTime();
                    ajax.open("GET",peticion,true);
                    ajax.onreadystatechange=function()
                    {
                        if (ajax.readyState==4) {
                            terminarProgresoSistema();
                            mensajeJs(ajax.responseText.split("\n").join(""));
                            
                        }
                    }

                    ajax.send(null);
                }
                function volverLogin()
                {
                    iniciarProgresoSistema();
                    window.location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();
                }

            </script>
<style>
    button
    {
        position:inherit !important;
    }
</style>
        </head>

           <body >
               <div class="buttonIndirectos" onclick="window.location.href='../registroTiemposIndirectosProduccion/'+(administradorSistema?'registroAdministrador/navegadorPeriodosTiemposAdministrador.jsf':'registroTiempoPersonalIndirecto/navegadorPeriodosTiempos.jsf')+'?ca=76&p='+codPersonalGeneral+'&data='+(new Date()).getTime().toString();"><span style="">INDIRECTOS</span></div>
               <div class="divHeaderLogin">
                  
                   <table id="tablaBuscarLote" cellpadding="0" cellspacing="0">
                       <tr>
                       <td>
                       <span class="textHeaderClass">Prog. Prod</span>
                       </td><td>
                       <select  id="codProgProd">
                           <option value="0">-TODOS-</option>
                           <%
                           String codPersonal=request.getParameter("p");
                           int administrador=0;
                           String pendiente="";
                           String nombrePersonal="";
                           String personalSession="";
                            try
                            {
                                Connection con=null;
                                con=Util.openConnection(con);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery("select ppp.COD_PROGRAMA_PROD,REPLACE(REPLACE(ppp.NOMBRE_PROGRAMA_PROD,'PROGRAMA','PROG.'),'DE ','') AS NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO ppp where ppp.COD_ESTADO_PROGRAMA<>4 and ppp.COD_PROGRAMA_PROD>=183 order by ppp.COD_PROGRAMA_PROD");
                                while(res.next())
                                {
                                    out.println("<option value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                                }
                                String consulta="select isnull((p.AP_PATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL + ' ' + pt.NOMBRES_PERSONAL))  as nombrePersonal,"+
                                                " isnull(adt.COD_PERSONAL, 0) as registrado"+
                                                " from USUARIOS_MODULOS u left outer join personal p on u.COD_PERSONAL=p.COD_PERSONAL "+
                                                " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=u.COD_PERSONAL"+
                                                " left outer join ADMINISTRADORES_TABLETA adt on adt.COD_PERSONAL=u.COD_PERSONAL"+
                                                " and adt.COD_AREA_EMPRESA=76"+
                                                " where u.COD_PERSONAL='"+codPersonal+"' and u.COD_MODULO=10";
                                res=st.executeQuery(consulta);

                                if(res.next())
                                {
                                    nombrePersonal=res.getString("nombrePersonal");
                                    administrador=res.getInt("registrado");
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
                                                                          "{if(result){terminarTiempoIndirecto('"+res.getString("COD_PROGRAMA_PROD")+"','"+res.getInt("COD_AREA_EMPRESA")+"','"+res.getInt("COD_ACTVIDAD")+"','"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"','"+codPersonal+"');}});";
                                                        }
                                                    }
                                        }

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
                       <td >
                           <input type="tel" id="codLote" style="height:2em !important"/>
                       </td>
                       <td>
                           <div id="buttonBuscar" onclick="buscarLote();"  alt="buscar">
                                 <img src="../reponse/img/lupa.gif" style="width:2.1em" alt="Buscar" ><span class="textHeaderClass">Buscar&nbsp;&nbsp;</span>
                           </div>
                       </td>
                       <%--td>
                           <div id="buttonMas buttonBuscar " onclick="actualizarDatos();" style="padding:0.5em" alt="buscar">
                             <span class="textHeaderClass">Actualizar</span>
                           </div>
                       </td--%>
                       </tr>


                 </table>
                 <nav>
                          <li class="parent"><span class="textHeaderClass" id="nombreUsuarioPersonal"><%=(nombrePersonal)%></span>
                             <ul>
                                <%--li><span class="textHeaderClass">Cambiar Contraseña</span></li--%>
                                <%--li onclick="cambiarUsuario();"><span class="textHeaderClass">Cambiar Usuario</span></li--%>
                                <li onclick="verificarHorasTrabajadas();"><span class="textHeaderClass">Verificar Horas</span></li>
                                <li onclick="sqlConnection.terminarSessionUsuario(volverLogin());"><span class="textHeaderClass">Salir</span></li>

                             </ul>
                          </li>
                       </nav>
               </div>
                   <div style="margin-top:2%;position:fixed;width:100%;z-index:200;visibility:hidden" id="divImagen">
                 <center><img src="../reponse/img/load2.gif"  style="z-index:205; "><%--margin-top:2%;position:fixed;--%>
                 </center>
                 
               </div>
                 <section class="main" style="margin-top:5em;width:100%;" >

                         <div  style="width:100%" id="divLotesProduccion" align="center"><%--class="large-12 medium-12 small-12 columns"--%>
                         <table cellpadding="0px" cellspacing="0px" style="width:100%" id="tablaLotesProcesar">
                             <thead>
                             <tr><td class="tableHeaderClass" style="width:30%"><span class="textHeaderClass">Producto</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Lote</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Nro Lote</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Programa Produccion</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Area</span></td>
                             
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Timbrado<br>Empaque<br>Primario</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Entrega<br>Material<br>Secundario</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Timbrado<br>Empaque<br>Secundario</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Proceso<br>Acondicionamiento</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Devolucion<br>de<br>Material</span></td>
                             <td class="tableHeaderClass" style="width:10%"><span class="textHeaderClass">Control<br>Llenado<br>Volumen</span></td>
                             </thead>
                         </table>


                     </div>
                     <iframe width="100%" height="85%" id="frameFransacciones" style="display:none" src="">

                     </iframe>
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
                                    font-weight:bold; width: 12em" onclick="var a=Math.random();window.location.href='../login.jsf?codArea=102&cencel'+a;">Cancelar</button></td>
                            </tr>
                        </table>
                         </center>
                     </div>
                     <div  id="formsuper"  class="formSuper" />
            </section>




            <script>
              codPersonalGeneral=<%=(codPersonal)%>
              administradorSistema=<%=(administrador>0?"true":"false")%>;
        </script>
        
        </body>
        
        <script src="../reponse/js/mensajejs.js"></script>
        <script type="text/javascript"><%=(pendiente)%></script>
        <script>sqlConnection.verificarUsuarioLogin(null,function(){alertJs("NO INICIO SESSION",function(){volverLogin();})}); </script>
    </html>

</f:view>

