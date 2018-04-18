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
        <head></head>
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
        <link rel="STYLESHEET" type="text/css" href="../reponse/css/mensajejs.css" />
        <script src="../reponse/js/variables.js"></script>
        <script src="../reponse/js/utiles.js"></script>
        <script src="../reponse/js/scripts.js"></script>
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
                              "&admin=0";
                    window.parent.iniciarProgresoSistema();

               }
        </script>
        <body>
<%
String codPersonal=request.getParameter("codPersonal");
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codComprod=request.getParameter("codComprod");
String codActividadPrograma=request.getParameter("codActividad");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
boolean ocultarBotonInicio=false;
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta="select ap.NOMBRE_ACTIVIDAD from ACTIVIDADES_FORMULA_MAESTRA afm inner join ACTIVIDADES_PRODUCCION ap on "+
                    " afm.COD_ACTIVIDAD=ap.COD_ACTIVIDAD"+
                    " where afm.COD_ACTIVIDAD_FORMULA='"+codActividadPrograma+"' and afm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
    System.out.println("consilta nomre "+consulta);
    ResultSet res=st.executeQuery(consulta);
    out.println("<div class='row'><div class='large-12 medium-12 small-12 columns'>" +
                "<table class='tablaLoteAlmacen'  cellpadding='0' cellspacing='0'><thead><tr>"+
                "<td><span class='textHeaderClass'>Actividad</span></td>" +
                "</tr></thead><tbody><tr>");
    if(res.next())
    {
        out.println("<td><span class='textHeaderClassBody'>"+res.getString("NOMBRE_ACTIVIDAD")+"</span></td>");
    }
    out.println("</tr><tr><td colspan='4'><center>");
    consulta="select s.FECHA_INICIO,s.FECHA_FINAL,s.REGISTRO_CERRADO"+
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where "+
                    " s.COD_ACTIVIDAD_PROGRAMA='"+codActividadPrograma+"'"+
                    " and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                    " and s.COD_LOTE_PRODUCCION='"+codLote+"'"+
                    " and s.COD_COMPPROD='"+codComprod+"'"+
                    " and s.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                    " and s.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                    " and s.COD_PERSONAL='"+codPersonal+"'"+
                    " order by s.FECHA_INICIO asc";
    System.out.println("consulta buscar lotes "+consulta);
    res=st.executeQuery(consulta);
    SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
    out.println("<script>fechaSistemaGeneral='"+sdfDias.format(new Date())+"'</script>");
    out.println(" <table style='width:100%;margin-top:8px' id='dataTiemposAlmacen' cellpadding='0px' cellspacing='0px'>"+
                " <tr><td class='tableHeaderClass' style='text-align:center;'><span class='textHeaderClass'>Fecha</span></td>"+
                " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Hora Inicio</span></td>"+
                " <td class='tableHeaderClass' style='text-align:center'><span class='textHeaderClass'>Hora Final</span></td>"+
                "</tr>");
    
    while(res.next())
    {
        ocultarBotonInicio=(ocultarBotonInicio||res.getInt("REGISTRO_CERRADO")==0);
        out.println("<tr>"+
                    "<td class='tableCell' align='center'>" +
                    "<span class='textHeaderClassBodyNormal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                    " <td class='tableCell'  align='center'>" +
                    " <span class='textHeaderClassBodyNormal'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span>"+
                    " </td>" +
                    " <td class='tableCell' align='center' >" +
                    "<button class='"+(res.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"terminarTiempoDirectoPersonal(this,'"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                    "<span class='textHeaderClassBodyNormal'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span>"+
                    "</td>" +
                    
                    "</tr>");
        
    }
    out.println("</table>");
    res.close();
    st.close();
    con.close();
%>

<div class="row" style="margin-top:0px;">
    <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
        <div class="row">
            <div class="large-6 medium-6 small-12 columns">
                <button class="small button succes radius buttonIniciar" style="visibility:<%=(ocultarBotonInicio?"hidden":"visible")%>" onclick="nuevoRegistroTiemposGeneral('dataTiemposAlmacen',this)" >Iniciar</button>
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
</body>
</f:view>