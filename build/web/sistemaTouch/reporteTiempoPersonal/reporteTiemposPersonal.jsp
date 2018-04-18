<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@page import="java.text.DateFormat" %>
<%@page import="java.text.ParseException" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
      <style>
          .d{
              cursor:crosshair
          }
      </style>

<script src="../../reponse/js/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />

<link rel="STYLESHEET" type="text/css" href="../reponse/css/border-radius.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/gold.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/timePickerCSs.css" />
<script src="../reponse/js/jscal2.js"></script>
<script src="../reponse/js/en.js"></script>
<script src="../reponse/js/websql.js"></script>
<style>
    .bold
    {
        font-weight:bold;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    .normal
    {
        font-weight:400;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }

</style>
<script type="text/javascript">
    
    
</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>

<section class="main">

        <div class="row"  style="margin-top:5px" >
                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >
                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >

                                   <label  class="inline">REPORTE DE TIEMPOS DE PERSONAL</label>
                            </div>
                        </div>
  <%
        String codLote=request.getParameter("codLote");
        out.println("<title>REPORTE DE TIEMPOS DE PERSONAL</title>");
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));
        String fechaInicio=request.getParameter("fechaInicio");
        String fechaFinal=request.getParameter("fechaFinal");
        int codAreaEmpresa=Integer.valueOf(request.getParameter("codArea"));
        String nombrePersonal=request.getParameter("nombrePersonal");
        %>
        <div class="row divContentClass">
                           <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns " >
                               <center>
                                   <table cellpadding="0" cellspacing="0" class="" style="margin-top:1em" >
                                       <tr>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Personal</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Fecha Inicio</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Fecha Final</span></td>
                                       </tr>
                                       <tr>
                                       <td class="tableCell" ><span class="textHeaderClassBody"><%=(nombrePersonal)%></span></td>
                                       <td class="tableCell"><span class="textHeaderClassBody"><%=(fechaInicio)%></span></td>
                                       <td class="tableCell"><span class="textHeaderClassBody"><%=(fechaFinal)%></span></td>
                                       
                                       </tr>
                                   </table>
                                    <table cellpadding="0" cellspacing="0" style="margin-top:1em;width:100%">
                                       <tr>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Personal</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Lote</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Producto</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Actividad</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Fecha Inicio</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Fecha Final</span></td>
                                           <td class="tableHeaderClass" ><span class="textHeaderClass">Horas Hombre</span></td>
                                       </tr>
        <%
        try
        {
            String[] fechaArray=fechaInicio.split("/");
            fechaInicio=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
            fechaArray=fechaFinal.split("/");
            fechaFinal=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta=" select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal,"+
                            " p.COD_PERSONAL,ap.NOMBRE_ACTIVIDAD,sppp.FECHA_INICIO,sppp.HORAS_HOMBRE,sppp.FECHA_FINAL" +
                            " ,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,cp.nombre_prod_semiterminado" +
                            " ,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD"+
                            " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp inner join personal p"+
                            " on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                            " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=sppp.COD_ACTIVIDAD_PROGRAMA"+
                            " and afm.COD_FORMULA_MAESTRA=sppp.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA=96"+
                            " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD" +
                            " inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD=sppp.COD_PROGRAMA_PROD"+
                            " and pp.COD_LOTE_PRODUCCION=sppp.COD_LOTE_PRODUCCION and pp.COD_TIPO_PROGRAMA_PROD=sppp.COD_TIPO_PROGRAMA_PROD"+
                            " and pp.COD_FORMULA_MAESTRA=sppp.COD_FORMULA_MAESTRA and pp.COD_COMPPROD=sppp.COD_COMPPROD"+
                            " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                            " WHERE sppp.COD_PERSONAL in ("+
                            (codPersonal>0?codPersonal:" select P1.COD_PERSONAL from personal P1 inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p1.COD_PERSONAL"+
                            " where pa.cod_area_empresa in ("+codAreaEmpresa+") AND p1.COD_ESTADO_PERSONA = 1 union"+
                            " select P2.COD_PERSONAL from personal p2 where p2.cod_area_empresa in ("+codAreaEmpresa+") and p2.COD_ESTADO_PERSONA = 1")+
                            ") and sppp.FECHA_INICIO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59'"+
                            " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,sppp.FECHA_INICIO";
            System.out.println("consulta cargar seguimiento "+consulta);
            ResultSet res=st.executeQuery(consulta);
            int codPersonalCabecera=0;
            double sumaHorasHombre=0;
            int contPersonalRegistros=0;
            String nombrePersonalCabecera="";
            String innerHTML="";
            SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
            Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet resDetalle=null;
            while(res.next())
            {
                if(codPersonalCabecera!=res.getInt("COD_PERSONAL"))
                {
                    if(codPersonalCabecera>0)
                    {
                        consulta="select pp.HORA_INICIO,pp.HORA_FIN from PERSONAL_PERMISOS pp where "+
                                        " pp.COD_PERSONAL='"+codPersonalCabecera+"'"+
                                        " and pp.FECHA_PERMISO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59'";
                        System.out.println("consulta cargar permisos "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        double cantidadHoras=0;
                        double horaIni=0;
                        double horafin=0;
                        while(resDetalle.next())
                        {
                            String[] aux=resDetalle.getString("HORA_INICIO").split(":");
                            horaIni=Double.valueOf(aux[0])+(Double.valueOf(aux[1])/60d);
                            aux=resDetalle.getString("HORA_FIN").split(":");
                            horafin=Double.valueOf(aux[0])+(Double.valueOf(aux[1])/60d);
                            cantidadHoras+=(horafin-horaIni);
                        }
                        consulta="select count(pp.TURNO_PERMISO)  as contTurnos"+
                                 " from PERSONAL_PERMISOS_TURNO pp where pp.COD_PERSONAL='"+codPersonalCabecera+"'"+
                                 " and pp.FECHA_PERMISO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59'";
                        System.out.println("permisos turnos"+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        if(resDetalle.next())
                        {
                            cantidadHoras+=(resDetalle.getDouble("contTurnos")*4);
                        }
                        consulta="select pp.FECHA_INICIO,pp.FECHA_FIN from PERSONAL_PERMISOS_DIA pp"+
                                 " where pp.COD_PERSONAL = '"+codPersonalCabecera+"' "+
                                 " and pp.FECHA_INICIO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59:59' ";
                        System.out.println("personal permiso dias "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        while(resDetalle.next())
                        {
                            Date fechaInicial=resDetalle.getTimestamp("FECHA_INICIO");
                            Date fechaFinal1=resDetalle.getTimestamp("FECHA_FIN");
                            DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM);
                            long fechaInicialMs = fechaInicial.getTime();
                            long fechaFinalMs = fechaFinal1.getTime();
                            long diferencia = fechaFinalMs - fechaInicialMs;
                            cantidadHoras+=(diferencia / (1000 * 60 * 60));
                        }
                        out.println("<tr><td rowspan='"+contPersonalRegistros+"' class='tableCell'>" +
                                    "<span class='textHeaderClassBody'>"+nombrePersonalCabecera+"</span></td>"+innerHTML);
                        if(cantidadHoras>0)
                        {
                            out.println("<tr ><td  class='tableCell' align='right' colspan='6' bgcolor='#f2c7e8' style='border-right:none !important;border-bottom:none !important'><span class='textHeaderClassBody' align='right'>Horas Trabajadas:</span></td>" +
                                " <td class='tableCell' align='right' bgcolor='#f2c7e8' style='border-left:none !important;border-bottom:none !important'><span class='textHeaderClassBody'>"+format.format(sumaHorasHombre)+"</span></td></tr>");
                            out.println("<tr ><td  class='tableCell' align='right' colspan='6' bgcolor='#f2c7e8' style='border-right:none !important;border-bottom:none !important;border-top:none !important'><span class='textHeaderClassBody' align='right'>Horas Permiso:</span></td>" +
                                " <td class='tableCell' align='right' bgcolor='#f2c7e8' style='border-left:none !important;border-bottom:none !important;border-top:none !important'><span class='textHeaderClassBody'>"+format.format(cantidadHoras)+"</span></td></tr>");
                        }
                        out.println("<tr ><td  class='tableCell' align='right' colspan='6' bgcolor='#f2c7e8' style='border-right:none !important'><span class='textHeaderClassBody' align='right'>Total Horas:</span></td>" +
                                " <td class='tableCell' align='right' bgcolor='#f2c7e8' style='border-left:none !important'><span class='textHeaderClassBody'>"+format.format(sumaHorasHombre+cantidadHoras)+"</span></td></tr>");
                        
                    }
                    nombrePersonalCabecera=res.getString("nombrePersonal");
                    contPersonalRegistros=0;
                    sumaHorasHombre=0;
                    codPersonalCabecera=res.getInt("COD_PERSONAL");
                    innerHTML="";
                }
                contPersonalRegistros++;
                innerHTML+=(innerHTML.equals("")?"":"<tr>")+
                        "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("COD_LOTE_PRODUCCION")+"</span></td>" +
                        "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("nombre_prod_semiterminado")+"</span></td>" +
                        "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getString("NOMBRE_ACTIVIDAD")+"</span></td>" +
                        "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"<br>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                        "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>"+sdfDias.format(res.getTimestamp("FECHA_FINAL"))+"<br>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span></td>" +
                        "<td class='tableCell' align='right'><span class='textHeaderClassBody' style='font-weight:normal'>"+format.format(res.getDouble("HORAS_HOMBRE"))+"</span></td>" +
                        "</tr>";
                sumaHorasHombre+=res.getDouble("HORAS_HOMBRE");
            }
           
            if(codPersonalCabecera>0)
            {
                consulta="select pp.HORA_INICIO,pp.HORA_FIN from PERSONAL_PERMISOS pp where "+
                                        " pp.COD_PERSONAL='"+codPersonalCabecera+"'"+
                                        " and pp.FECHA_PERMISO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59'";
                        System.out.println("consulta cargar permisos "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        double cantidadHoras=0;
                        double horaIni=0;
                        double horafin=0;
                        while(resDetalle.next())
                        {
                            String[] aux=resDetalle.getString("HORA_INICIO").split(":");
                            horaIni=Double.valueOf(aux[0])+(Double.valueOf(aux[1])/60d);
                            aux=resDetalle.getString("HORA_FIN").split(":");
                            horafin=Double.valueOf(aux[0])+(Double.valueOf(aux[1])/60d);
                            cantidadHoras+=(horafin-horaIni);
                        }
                        consulta="select count(pp.TURNO_PERMISO)  as contTurnos"+
                                 " from PERSONAL_PERMISOS_TURNO pp where pp.COD_PERSONAL='"+codPersonalCabecera+"'"+
                                 " and pp.FECHA_PERMISO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59'";
                        System.out.println("permisos turnos"+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        if(resDetalle.next())
                        {
                            cantidadHoras+=(resDetalle.getDouble("contTurnos")*4);
                        }
                        consulta="select pp.FECHA_INICIO,pp.FECHA_FIN from PERSONAL_PERMISOS_DIA pp"+
                                 " where pp.COD_PERSONAL = '"+codPersonalCabecera+"' "+
                                 " and pp.FECHA_INICIO BETWEEN '"+fechaInicio+" 00:00' and '"+fechaFinal+" 23:59:59' ";
                        System.out.println("personal permiso dias "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        while(resDetalle.next())
                        {
                            Date fechaInicial=resDetalle.getTimestamp("FECHA_INICIO");
                            Date fechaFinal1=resDetalle.getTimestamp("FECHA_FIN");
                            DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM);
                            long fechaInicialMs = fechaInicial.getTime();
                            long fechaFinalMs = fechaFinal1.getTime();
                            long diferencia = fechaFinalMs - fechaInicialMs;
                            cantidadHoras+=(diferencia / (1000 * 60 * 60));
                        }
                        out.println("<tr><td rowspan='"+contPersonalRegistros+"' class='tableCell'>" +
                                    "<span class='textHeaderClassBody'>"+nombrePersonalCabecera+"</span></td>"+innerHTML);
                        if(cantidadHoras>0)
                        {
                            out.println("<tr ><td  class='tableCell' align='right' colspan='6' bgcolor='#f2c7e8' style='border-right:none !important;border-bottom:none !important'><span class='textHeaderClassBody' align='right'>Horas Trabajadas:</span></td>" +
                                " <td class='tableCell' align='right' bgcolor='#f2c7e8' style='border-left:none !important;border-bottom:none !important'><span class='textHeaderClassBody'>"+format.format(sumaHorasHombre)+"</span></td></tr>");
                            out.println("<tr ><td  class='tableCell' align='right' colspan='6' bgcolor='#f2c7e8' style='border-right:none !important;border-bottom:none !important;border-top:none !important'><span class='textHeaderClassBody' align='right'>Horas Permiso:</span></td>" +
                                " <td class='tableCell' align='right' bgcolor='#f2c7e8' style='border-left:none !important;border-bottom:none !important;border-top:none !important'><span class='textHeaderClassBody'>"+format.format(cantidadHoras)+"</span></td></tr>");
                        }
                        out.println("<tr ><td  class='tableCell' align='right' colspan='6' bgcolor='#f2c7e8' style='border-right:none !important'><span class='textHeaderClassBody' align='right'>Total Horas:</span></td>" +
                                " <td class='tableCell' align='right' bgcolor='#f2c7e8' style='border-left:none !important'><span class='textHeaderClassBody'>"+format.format(sumaHorasHombre+cantidadHoras)+"</span></td></tr>");
            }
                    

            %>

                                    </table>
                               </center>
                            </div>
                        </div>
                        
        </div>
        </div>
            <%
            res.close();
            st.close();
            con.close();
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
            %>
    <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
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
    <script src="../../reponse/js/timePickerJs.js"></script>
</html>
