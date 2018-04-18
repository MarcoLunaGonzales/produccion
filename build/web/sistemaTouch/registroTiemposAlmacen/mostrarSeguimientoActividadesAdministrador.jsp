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
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<f:view>
    <html>
        <head>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/mensajejs.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/timePickerCSs.css" />
            <script src="../reponse/js/utiles.js"></script>
            <script src="../reponse/js/scripts.js"></script>
            <script src="../reponse/js/variables.js"></script>
            <script src="../reponse/js/componentesJs.js"></script>
            
            <script src="../reponse/js/websql.js"></script>
            <script type="text/javascript">
                function mostrarActividadesProduccionS(codLote,codProgramaProd,codComprod,codTipoProgramaProd)
               {
                    window.location.href="actividadesProduccion.jsf?codLote="+codLote+
                              "&codTipoProgramaProd="+codTipoProgramaProd+
                              "&codComprod="+codComprod+
                              "&data="+(new Date()).getTime().toString()+
                              "&codProgramaProd="+codProgramaProd+
                              "&codPersonal="+window.parent.codPersonalGeneral+
                              "&admin=1";
                    window.parent.iniciarProgresoSistema();
                    
               }
                function guardarSeguimientoAdmin()
                {
                    var tabla=document.getElementById("dataTiemposAlmacen");
                    var dataTiempos=new Array()
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        dataTiempos[dataTiempos.length]=tabla.rows[i].cells[0].getElementsByTagName("select")[0].value;
                        dataTiempos[dataTiempos.length]=tabla.rows[i].cells[1].getElementsByTagName("input")[0].value;
                        dataTiempos[dataTiempos.length]=tabla.rows[i].cells[2].getElementsByTagName("input")[0].value;
                        dataTiempos[dataTiempos.length]=tabla.rows[i].cells[3].getElementsByTagName("input")[0].value;
                        dataTiempos[dataTiempos.length]=tabla.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML;
                        dataTiempos[dataTiempos.length]=(tabla.rows[i].cells[3].getElementsByTagName("button").length>0?(tabla.rows[i].cells[3].getElementsByTagName("button")[0].className=='buttonFinishActive'?1:0):1);
                    }
                    window.parent.iniciarProgresoSistema();
            var peticion="ajaxGuardarTiemposDirectos.jsf?codProgramaProd="+window.parent.codProgramaProdGeneral+
                         "&codLote="+window.parent.codLoteGeneral+
                         "&codFormulaMaestra="+window.parent.codFormulaMaestraGeneral+
                         "&codComprod="+window.parent.codComprodGeneral+
                         "&codTipoProgramaProd="+window.parent.codTipoProgramaProdGeneral+
                         "&codActividad="+window.parent.codActividadGeneral+
                         "&dataTiempos="+dataTiempos+
                         "&data="+(new Date()).getTime().toString();
                         ajax=nuevoAjax();
                         ajax.open("GET",peticion,true);
                         ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                         ajax.onreadystatechange=function(){
                            if (ajax.readyState==4) {
                                if(ajax.responseText==null || ajax.responseText=='')
                                {
                                    window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                                    if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                                    {
                                        sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                                    }
                                    window.parent.terminarProgresoSistema();
                                    return false;
                                }
                                if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                                {
                                    window.parent.terminarProgresoSistema();
                                    window.parent.mensajeJs("Se registraron los tiempos",function()
                                    {
                                        mostrarActividadesProduccionS(window.parent.codLoteGeneral,window.parent.codProgramaProdGeneral,
                                        window.parent.codComprodGeneral, window.parent.codTipoProgramaProdGeneral);
                                    })
                                    return true;
                                }
                                else
                                {
                                    window.parent.terminarProgresoSistema();
                                    window.parent.alertJs(ajax.responseText.split("\n").join(""));
                                    return false;
                                }
                            }
                        }

                        ajax.send(null);
                }
           </script>
        </head>
        <body>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codComprod=request.getParameter("codComprod");
String codActividadPrograma=request.getParameter("codActividad");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
//formato de fecha y numero
SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
DecimalFormat format = (DecimalFormat)nf;
format.applyPattern("#,##0.00");
out.println("<script>fechaSistemaGeneral='"+sdfDias.format(new Date())+"'</script>");
boolean ocultarBotonInicio=false;
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     String consulta="select p.COD_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,cp.nombre_prod_semiterminado,"+
                    " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,p.CANT_LOTE_PRODUCCION,p.COD_FORMULA_MAESTRA"+
                    " from PROGRAMA_PRODUCCION p inner join TIPOS_PROGRAMA_PRODUCCION tpp on"+
                    " p.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD"+
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=p.COD_COMPPROD"+
                    " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                    " where p.COD_PROGRAMA_PROD='"+codProgramaProd+"' and p.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                    " and p.COD_LOTE_PRODUCCION='"+codLote+"'";
    System.out.println("consulta buscar lotes "+consulta);
    ResultSet res=st.executeQuery(consulta);
    out.println("<div class='row'><div class='large-12 medium-12 small-12 columns'>" +
                "<table class='tablaLoteAlmacen'  cellpadding='0' cellspacing='0'><thead><tr>"+
                "<td><span class='textHeaderClass'>Lote</span></td>" +
                "<td><span class='textHeaderClass'>Programa<br>Produccion</span></td>" +
                "<td><span class='textHeaderClass'>Producto</span></td>" +
                "<td><span class='textHeaderClass'>Tipo<br>Produccion</span></td>" +
                "</tr></thead><tbody><tr>");
    if(res.next())
    {
        out.println("<td><span class='textHeaderClassBody'>"+codLote+"</span></td>"+
                    "<td><span class='textHeaderClassBody'>"+codLote+"</span></td>"+
                    "<td><span class='textHeaderClassBody'>"+res.getString("nombre_prod_semiterminado")+"</span></td>"+
                    "<td><span class='textHeaderClassBody'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></td>");
    }
    out.println("</tr><tr><td colspan='4'>");
     consulta="select personal.COD_PERSONAL,personal.nombrePersonal"+
                    " from ( select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal " +
                    " from PERSONAL p "+
                    " union select pt.COD_PERSONAL,(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal) as nombrePersonal"+
                    " from PERSONAL_TEMPORAL pt) personal"+
                    " where personal.cod_personal in ( select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap where pap.COD_AREA_EMPRESA=76)"+
                    " or personal.cod_personal in (select s.COD_PERSONAL from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where "+
                    " s.COD_LOTE_PRODUCCION='"+codLote+"'"+
                    " and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                    " and s.COD_COMPPROD='"+codComprod+"'"+
                    " and s.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                    " and s.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                    " and s.COD_ACTIVIDAD_PROGRAMA='"+codActividadPrograma+"') order by personal.nombrePersonal";
    res =st.executeQuery(consulta);
    String personalSelect="";
    while(res.next())
    {
        personalSelect+="<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("nombrePersonal")+"</option>";
    }
    out.println("<script>operariosRegistroGeneral=\""+personalSelect+"\"</script>");
    consulta="select ap.NOMBRE_ACTIVIDAD from ACTIVIDADES_FORMULA_MAESTRA afm inner join ACTIVIDADES_PRODUCCION ap on "+
                    " afm.COD_ACTIVIDAD=ap.COD_ACTIVIDAD"+
                    " where afm.COD_ACTIVIDAD_FORMULA='"+codActividadPrograma+"' and afm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
    System.out.println("consilta nomre "+consulta);
    res=st.executeQuery(consulta);
    out.println("<div class='row'><div class='large-12 medium-12 small-12 columns'>" +
                "<table class='tablaLoteAlmacen'  cellpadding='0' cellspacing='0'><thead><tr>"+
                "<td><span class='textHeaderClass'>Actividad</span></td>" +
                "</tr></thead><tbody><tr>");
    if(res.next())
    {
        out.println("<td><span class='textHeaderClassBody'>"+res.getString("NOMBRE_ACTIVIDAD")+"</span></td>");
    }
    out.println("</tr><tr><td colspan='4'><center>");
    consulta="select s.FECHA_INICIO,s.FECHA_FINAL,s.REGISTRO_CERRADO,s.COD_PERSONAL,s.HORAS_HOMBRE"+
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where "+
                    " s.COD_ACTIVIDAD_PROGRAMA='"+codActividadPrograma+"'"+
                    " and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                    " and s.COD_LOTE_PRODUCCION='"+codLote+"'"+
                    " and s.COD_COMPPROD='"+codComprod+"'"+
                    " and s.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                    " and s.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                    " order by s.FECHA_INICIO asc";
    System.out.println("consulta mostrar seguimiento personal "+consulta);
    res=st.executeQuery(consulta);
    out.println(" <table style='width:100%;margin-top:8px' class='' id='dataTiemposAlmacen' cellpadding='0px' cellspacing='0px'>"+
                " <tr>" +
                "<td class='tableHeaderClass prim' style='text-align:center;'><span class='textHeaderClass'>Personal</span></td>"+
                "<td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Fecha</span></td>"+
                " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Hora Inicio</span></td>"+
                " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Hora Final</span></td>"+
                " <td class='tableHeaderClass ult' style='text-align:center'><span class='textHeaderClass'>Horas Hombre</span></td>"+
                "</tr>");
    
    while(res.next())
    {
        ocultarBotonInicio=(ocultarBotonInicio||res.getInt("REGISTRO_CERRADO")==0);
        out.println("<tr onclick='seleccionarFila(this)'>"+
                    "<td class='tableCell' align='center'>" +
                    "<select id='tablaLoteAlmacenCelda"+res.getRow()+"'>"+personalSelect+"</select>" +
                    "<script>tablaLoteAlmacenCelda"+res.getRow()+".value='"+res.getInt("COD_PERSONAL")+"';</script>" +
                    "</td>" +
                    "<td class='tableCell' align='center' style='text-align:center'>" +
                    "<input type='tel' onclick='seleccionarDatePickerJs(this);' style='width:7em' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'/></td>" +
                    " <td class='tableCell'  align='center'>" +
                    "<input type='tel' onclick='seleccionarHora(this);' id='fechaInicio"+res.getRow()+"' onkeyup='calcularHorasFilaInicio(this)' onfocus='calcularHorasFilaInicio(this)' style='width:5em' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'/></td>" +
                    " </td>" +
                    " <td class='tableCell' align='center' >" +
                    "<input type='tel' style='width:5em;display:"+(res.getInt("REGISTRO_CERRADO")>0?"table-cell":"none")+"' onclick='seleccionarHora(this);' id='fechaFinal"+res.getRow()+"' onfocus='calcularHorasFilaFinal(this)'  value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'/>" +
                    "<button class='"+(res.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"terminarTiempoDirectoAdmin(this)\">Terminar</button>"+
                    "</td>" +
                    " <td class='tableCell'  align='center'>" +
                    " <span class='textHeaderClassBodyNormal'>"+format.format(res.getDouble("HORAS_HOMBRE"))+"</span>"+
                    " </td>" +
                    "</tr>");
        
    }
    out.println("</table>");
    res.close();
    st.close();
    con.close();
%>
<div class="row" style="margin-top:0px;">
    <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
      <div class="large-1 medium-1 small-2 columns">
          <button  class="small button succes radius buttonMas" onclick="componentesJs.crearRegistroTablaFecha('dataTiemposAlmacen')">+</button>
      </div>
      <div class="large-1 medium-1 small-2 columns">
            <button  class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataTiemposAlmacen');">-</button>
      </div>
      <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
</div>
<div class="row" style="margin-top:0px;">
    <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
        <div class="row">
            <div class="large-6 medium-6 small-12 columns">
                <button class="small button succes radius buttonAction"  onclick="guardarSeguimientoAdmin()" >Guardar</button>
            </div>
                <div class="large-6 medium-6 small-12  columns">
                    <button class="small button succes radius buttonAction" onclick="mostrarActividadesProduccionS('<%=(codLote)%>','<%=(codProgramaProd)%>','<%=(codComprod)%>','<%=(codTipoProgramaProd)%>');" >Cancelar</button>

                </div>
        </div>
    </div>
</div>
<%
out.println("</center></td></tr></tbody></table>");
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
catch(Exception e)
{
    e.printStackTrace();
}
%>
<script src="../reponse/js/timePickerJs.js"></script>
<script src="../reponse/js/dataPickerJs.js"></script>
<script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');</script>

</body>
</f:view>
