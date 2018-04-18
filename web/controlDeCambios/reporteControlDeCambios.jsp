<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.util.*"%>
<%@ page import="com.cofar.bean.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="org.joda.time.DateTime"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
<style type="text/css">
    body{
        
        text-align:center;
    }
    table
    {
        font-weight:bold ;
        background-color:white !important;
        width:90%;
        border-top:1px solid black;
        border-left:1px solid black;
    }
    table tr td
    {
        padding:0.5em;
        border-bottom:1px solid black;
        border-right:1px solid black;
        
         font-family:Verdana, Arial, Helvetica, sans-serif;
        font-size:12px;
    }
    .normal
    {
        font-weight: normal !important;
        border-right:none;
    }
    .normalUnico
    {
        font-weight: normal !important;
        border-right:none;
    }
    
    .celdaSelect
    {
        border:1px solid black;
        width:14px;
        height:14px;
        margin-left:0px;
        margin-right:0px;
    }
</style>

<html>
    <body bgcolor="white"  >
        <table class="cabecera" cellpadding="0" cellspacing="0">
            <tr>
                <td rowspan="3"  style="width:15%"><center><img src="../img/cofar.png" /></center></td>
                <td>
                    <span class="outputText2" style="font-size:16px"><center>ASEGURAMIENTO DE CALIDAD</center></span>
                </td>
                <td style="width:15%">
                    <span class="outputText2" style="font-weight:normal">Pagina 13 de 16</span>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="outputText2" style="font-size:14px"><center>ASC-5-003/R01</center></span>
                </td>
                <td>
                    <span class="outputText2" style="font-weight:normal">Vigencia: 27/07/12</span>
                </td>
            </tr>
            <tr>
                <td >
                    <span class="outputText2" style="font-size:14px"><center>REGISTRO DE CONTROL DE CAMBIOS</center></span>
                </td>
                <td >
                    <span class="outputText2" style="font-weight:normal">Revisión N°. 07</span>
                </td>
            </tr>
            <tr>
                <td style="padding:1px !important;border-bottom:none !important" bgcolor="#cccccc" colspan="3">
                     <span class="outputText2">1. Información diligenciada por Funcionario</span>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0">
<%
            try {
                Connection con = null;
                con = Util.openConnection(con);
                String codControlCambios=request.getParameter("codControlCambios");
            String consulta = "select rcc.COORELATIVO,rcc.COD_REGISTRO_CONTROL_CAMBIOS,p.COD_PERSONAL,"+
                              " (p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal) as nombrePersonal,"+
                              " ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,rcc.COD_VERSION_FM,rcc.COD_VERSION_PROD,"+
                              " rcc.AMERITA_CAMBIO,rcc.CAMBIO_DEFINITIVO,rcc.CLASIFICACION_DEL_CAMBIO,"+
                              " rcc.PROPOSITO_DEL_CAMBIO,rcc.CAMBIO_PROPUESTO,rcc.FECHA_REGISTRO" +
                              " ,cpv.nombre_prod_semiterminado"+
                              " from REGISTRO_CONTROL_CAMBIOS rcc"+
                              " left outer join PERSONAL p on p.COD_PERSONAL = rcc.COD_PERSONAL_REGISTRA"+
                              " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA =rcc.COD_AREA_EMPRESA" +
                              " left outer join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION=rcc.COD_VERSION_FM"+
                              " left outer join COMPONENTES_PROD_VERSION cpv on (cpv.COD_VERSION=rcc.COD_VERSION_PROD or (cpv.COD_COMPPROD=fmv.COD_COMPPROD))"+
                              " where rcc.COD_REGISTRO_CONTROL_CAMBIOS='"+codControlCambios+"'";
            System.out.println("consulta cabecera "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            while(res.next())
            {
                out.println("<tr><td class='normal' colspan='2' align='left' style='border-bottom:none'><span class='outputText2'>Funcionario:"+res.getString("nombrePersonal")+"</span></td>" +
                            "<td class='normal' colspan='3' align='left' style='border-bottom:none'><span class='outputText2'>Área:"+res.getString("NOMBRE_AREA_EMPRESA")+"</span></td>" +
                            "<td  colspan='2' style='border-bottom:none'><span style='font-weight:normal' class='outputText2'>Fecha:"+sdf.format(res.getTimestamp("FECHA_REGISTRO"))+"</span></td></tr>" +
                            "<tr><td colspan='7' align='left'><span style='font-weight:normal' class='outputText2'>Producto: "+res.getString("nombre_prod_semiterminado")+"</span></td></tr>"+
                            "<tr><td colspan='5' class='normal' align='left'><span style='font-weight:normal' class='outputText2'>Cambio Propuesto:</span></td>" +
                            "<td colspan='2'><span class='outputText2' style='font-weight:normal'>Correlativo:"+res.getString("COORELATIVO")+"</span></td></tr>" +
                            "<tr><td colspan='7' align='center'><span style='font-weight:normal' class='outputText2'>"+res.getString("CAMBIO_PROPUESTO")+"</span></td></tr>"+
                            
                            "<tr><td colspan='7' align='left'><span style='font-weight:normal' class='outputText2'>Proposito del cambio:</span></td></tr>" +
                            "<tr><td colspan='7'  align='center'><span  style='font-weight:normal' class='outputText2'>"+res.getString("PROPOSITO_DEL_CAMBIO")+"</span></td></tr>" +
                            "<tr><td style='padding:1px !important;' bgcolor='#cccccc' colspan='7'><span class='outputText2'>2. Información diligenciada por Comité Técnico</span></td></tr>"+
                            "<tr><td align='left' class='normal' style='border-bottom:none'><span  class='outputText2'>Clasificación del cambio:</span></td>" +
                            "<td class='normal' style='border-bottom:none'><span  class='outputText2'>M</span></td>" +
                            "<td class='normal' style='border-bottom:none'><div class='celdaSelect'><span  class='outputText2'>"+(res.getString("CLASIFICACION_DEL_CAMBIO").equals("M")?"√":"&nbsp;")+"</span></div></td>" +
                            "<td class='normal' style='border-bottom:none' class='normal'><span  class='outputText2'>m</span></td>" +
                            "<td class='normal' style='border-bottom:none'><div class='celdaSelect'><span  class='outputText2'>"+(res.getString("CLASIFICACION_DEL_CAMBIO").equals("m")?"√":"&nbsp;")+"</span></div></td>" +
                            "<td  colspan='4' style='border-bottom:none'>&nbsp;</td></tr>" +
                            "<tr><td align='left' class='normal' style='border-bottom:none'><span  class='outputText2'>Amerita el cambio:</span></td>" +
                            "<td style='border-bottom:none' class='normal'><span  class='outputText2'>SI</span></td>" +
                            "<td style='border-bottom:none' class='normal'><div class='celdaSelect'><span  class='outputText2'>"+(res.getInt("AMERITA_CAMBIO")>0?"√":"&nbsp;")+"</span></div></td>" +
                            "<td style='border-bottom:none' class='normal'><span  class='outputText2'>NO</span></td>" +
                            "<td style='border-bottom:none' class='normal' ><div class='celdaSelect'><span  class='outputText2'>"+(res.getInt("AMERITA_CAMBIO")==0?"√":"&nbsp;")+"</span><div></td>" +
                            "<td  colspan='2' style='border-bottom:none'>&nbsp;</td></tr>" +
                            "<tr><td align='left' class='normal' style='border-bottom:none'><span  class='outputText2'>Cambio Definitivo:</span></td>" +
                            "<td style='border-bottom:none' class='normal'><span  class='outputText2'>&nbsp;</span></td>" +
                            "<td style='border-bottom:none' class='normal'><div class='celdaSelect'><span  class='outputText2'>"+(res.getInt("CAMBIO_DEFINITIVO")>0?"√":"&nbsp;")+"</span></div></td>" +
                            "<td  colspan='4' style='border-bottom:none'>&nbsp;</td></tr>"+
                            "<tr><td align='left' class='normal'><span  class='outputText2'>Cambio Provisional:</span></td>" +
                            "<td class='normal'><span  class='outputText2'>&nbsp;</span></td>" +
                            "<td class='normal'><div class='celdaSelect'><span  class='outputText2'>"+(res.getInt("CAMBIO_DEFINITIVO")==0?"√":"&nbsp;")+"</span></div></td>" +
                            "<td  colspan='4'>&nbsp;</td></tr>" +
                            "<tr><td bgcolor='#cccccc' style='width:25%' ><span class='outputText2'>REQUERIMIENTO</span></td>" +
                            "<td bgcolor='#cccccc' style='width:4em' ><span class='outputText2'>SI</span></td>" +
                            "<td bgcolor='#cccccc' style='width:4em' ><span class='outputText2'>NO</span></td>" +
                            "<td bgcolor='#cccccc' colspan='2' ><span class='outputText2'>ACTIVIDAD</span></td>" +
                            "<td bgcolor='#cccccc' ><span class='outputText2'>RESPONSABLE</span></td>" +
                            "<td bgcolor='#cccccc' ><span class='outputText2'>FECHA<BR>LIMITE</span></td></tr>");//
            }
            consulta="select ecc.NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS,rccd.APLICA,rccd.ACTIVIDAD,"+
                     " isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal,'')as nombrePersonal,"+
                     " rccd.FECHA_LIMITE"+
                     " from REGISTRO_CONTROL_CAMBIOS_DETALLE rccd inner join ESPECIFICACIONES_CONTROL_CAMBIOS ecc"+
                     " on rccd.COD_ESPECIFICACION_CONTROL_CAMBIOS=ecc.COD_ESPECIFICACION_CONTROL_CAMBIOS"+
                     " left outer join personal p on p.COD_PERSONAL=rccd.COD_RESPONSABLE"+
                     " where rccd.COD_REGISTRO_CONTROL_CAMBIOS='"+codControlCambios+"'"+
                     " order by ecc.NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS";
            System.out.println("consulta detalle"+consulta);
            res=st.executeQuery(consulta);
            while(res.next())
            {
                out.println("<tr><td align='left' ><span style='font-weight:normal'  class='outputText2'>"+res.getString("NOMBRE_ESPECIFICACION_CONTROL_CAMBIOS")+"</span></td>" +
                            "<td  ><span class='outputText2'>"+(res.getInt("APLICA")>0?"√":"")+"&nbsp</span></td>" +
                            "<td ><span class='outputText2'>"+(res.getInt("APLICA")==0?"√":"")+"&nbsp</span></td>" +
                            "<td colspan='2' style='font-weight:normal' align='left' ><span class='outputText2'>"+res.getString("ACTIVIDAD")+"&nbsp;</span></td>" +
                            "<td style='font-weight:normal' align='left' ><span class='outputText2' >"+(res.getString("nombrePersonal"))+"&nbsp;</span></td>" +
                            "<td <span style='font-weight:normal' class='outputText2'>"+(res.getTimestamp("FECHA_LIMITE")!=null?sdf.format(res.getTimestamp("FECHA_LIMITE")):"")+"&nbsp;</span></td></tr>");
            }
            /*consulta="select seo.COD_SUB_ESPECIFICACION_OOS,eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,seo.NOMBRE_SUB_ESPECIFICACION_OOS,isnull(rod.DESCRIPCION, '') as DESCRIPCION"+
                     " from ESPECIFICACIONES_OOS eo left outer join SUB_ESPECIFICACIONES_OOS seo on eo.COD_ESPECIFICACION_OOS = seo.COD_ESPECIFICACION_OOS"+
                     " left outer join REGISTRO_OOS_DETALLE rod on rod.COD_ESPECIFICACION_OOS = eo.COD_ESPECIFICACION_OOS and rod.COD_SUB_ESPECIFICACION_OOS = " +
                     " isnull( seo.COD_SUB_ESPECIFICACION_OOS, 0) and rod.COD_REGISTRO_OOS = '"+codRegistroOOS+"'"+
                     " WHERE eo.COD_TIPO_ESPECIFICACION_OOS = '1' order by eo.NRO_ORDEN,seo.NRO_ORDEN";
             System.out.println("consulta especificaicones investigcacion  "+consulta);
             
             
             res=st.executeQuery(consulta);
             while(res.next())
             {
                 out.println("<tr><td>"+res.getString("NOMBRE_ESPECIFICACION_OOS")+"</td><td colspan='2'>"+(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0?"":res.getString("DESCRIPCION"))+"</td></tr>");
             }
             out.println("<tr><td colspan='3' style='font-weight:bold !important'><center>EVALUACION PRELIMINAR</center></td></tr>");
             consulta="select eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,seo.NOMBRE_SUB_ESPECIFICACION_OOS,seo.COD_SUB_ESPECIFICACION_OOS,isnull(rod.DESCRIPCION, '') as DESCRIPCION" +
                     ",eo.FECHA_CUMPLIMIENTO as conf,rod.FECHA_CUMPLIMIENTO"+
                      " from ESPECIFICACIONES_OOS eo left outer join SUB_ESPECIFICACIONES_OOS seo on eo.COD_ESPECIFICACION_OOS = seo.COD_ESPECIFICACION_OOS"+
                      " left outer join REGISTRO_OOS_DETALLE rod on rod.COD_ESPECIFICACION_OOS ="+
                      " eo.COD_ESPECIFICACION_OOS and rod.COD_SUB_ESPECIFICACION_OOS = isnull("+
                      " seo.COD_SUB_ESPECIFICACION_OOS, 0) and rod.COD_REGISTRO_OOS = '"+codRegistroOOS+"'"+
                      " WHERE eo.COD_TIPO_ESPECIFICACION_OOS = '2' order by eo.NRO_ORDEN,seo.NRO_ORDEN";
             System.out.println("consulta eval preliminar "+consulta);
             res=st.executeQuery(consulta);
             int codEspecificacionCabecera=0;
             while(res.next())
             {
                 if(codEspecificacionCabecera!=res.getInt("COD_ESPECIFICACION_OOS"))out.println("<tr><td "+(res.getInt("conf")>0?" rowspan='2'":"")+">"+res.getString("NOMBRE_ESPECIFICACION_OOS")+
                         "</td><td "+(res.getInt("conf")>0?" rowspan='2' ":"colspan='2'")+" >"+(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0?"&nbsp;":"&nbsp;"+res.getString("DESCRIPCION"))+"</td>" +
                         (res.getInt("conf")>0?"<td style='width:14% !important'>FECHA DE CUMPLIMIENTO</td></tr><tr><td>"+(res.getTimestamp("FECHA_CUMPLIMIENTO")!=null?sdf.format(res.getTimestamp("FECHA_CUMPLIMIENTO")):"&nbsp;"):"</td>")+"</tr>");
                 if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)out.println("<tr><td >"+res.getString("NOMBRE_SUB_ESPECIFICACION_OOS")+"</td><td colspan='2'>"+res.getString("DESCRIPCION")+"&nbsp;</td></tr>");
                 codEspecificacionCabecera=res.getInt("COD_ESPECIFICACION_OOS");
             }
             out.println("<tr><td colspan='3' style='font-weight:bold !important'><center>ERROR DE FACE I:ERROR RELACIONADO CON EL LABORATORIO</center></td></tr>");
             consulta="select eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,seo.NOMBRE_SUB_ESPECIFICACION_OOS,seo.COD_SUB_ESPECIFICACION_OOS,isnull(rod.DESCRIPCION, '') as DESCRIPCION" +
                     ",eo.FECHA_CUMPLIMIENTO as conf,rod.FECHA_CUMPLIMIENTO"+
                      " from ESPECIFICACIONES_OOS eo left outer join SUB_ESPECIFICACIONES_OOS seo on eo.COD_ESPECIFICACION_OOS = seo.COD_ESPECIFICACION_OOS"+
                      " left outer join REGISTRO_OOS_DETALLE rod on rod.COD_ESPECIFICACION_OOS ="+
                      " eo.COD_ESPECIFICACION_OOS and rod.COD_SUB_ESPECIFICACION_OOS = isnull("+
                      " seo.COD_SUB_ESPECIFICACION_OOS, 0) and rod.COD_REGISTRO_OOS = '"+codRegistroOOS+"'"+
                      " WHERE eo.COD_TIPO_ESPECIFICACION_OOS = '3' order by eo.NRO_ORDEN,seo.NRO_ORDEN";
             System.out.println("consulta eval preliminar "+consulta);
             res=st.executeQuery(consulta);
             codEspecificacionCabecera=0;
             while(res.next())
             {
                 if(codEspecificacionCabecera!=res.getInt("COD_ESPECIFICACION_OOS"))out.println("<tr><td "+(res.getInt("conf")>0?" rowspan='2'":"")+">"+res.getString("NOMBRE_ESPECIFICACION_OOS")+
                         "</td><td "+(res.getInt("conf")>0?" rowspan='2' ":"colspan='2'")+" >"+(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0?"&nbsp;":"&nbsp;"+res.getString("DESCRIPCION"))+"</td>" +
                         (res.getInt("conf")>0?"<td style='width:14% !important'>FECHA DE CUMPLIMIENTO</td></tr><tr><td>"+(res.getTimestamp("FECHA_CUMPLIMIENTO")!=null?sdf.format(res.getTimestamp("FECHA_CUMPLIMIENTO")):"&nbsp;"):"</td>")+"</tr>");
                 if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)out.println("<tr><td >"+res.getString("NOMBRE_SUB_ESPECIFICACION_OOS")+"</td><td colspan='2'>"+res.getString("DESCRIPCION")+"&nbsp;</td></tr>");
                 codEspecificacionCabecera=res.getInt("COD_ESPECIFICACION_OOS");
             }
             out.println("<tr><td colspan='3' style='font-weight:bold !important'><center>ERROR DE FACE II:ERROR RELACIONADO CON EL PROCESO DE PRODUCCION</center></td></tr>");
             consulta="select eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,seo.NOMBRE_SUB_ESPECIFICACION_OOS,seo.COD_SUB_ESPECIFICACION_OOS,isnull(rod.DESCRIPCION, '') as DESCRIPCION" +
                     ",eo.FECHA_CUMPLIMIENTO as conf,rod.FECHA_CUMPLIMIENTO"+
                      " from ESPECIFICACIONES_OOS eo left outer join SUB_ESPECIFICACIONES_OOS seo on eo.COD_ESPECIFICACION_OOS = seo.COD_ESPECIFICACION_OOS"+
                      " left outer join REGISTRO_OOS_DETALLE rod on rod.COD_ESPECIFICACION_OOS ="+
                      " eo.COD_ESPECIFICACION_OOS and rod.COD_SUB_ESPECIFICACION_OOS = isnull("+
                      " seo.COD_SUB_ESPECIFICACION_OOS, 0) and rod.COD_REGISTRO_OOS = '"+codRegistroOOS+"'"+
                      " WHERE eo.COD_TIPO_ESPECIFICACION_OOS = '4' order by eo.NRO_ORDEN,seo.NRO_ORDEN";
             System.out.println("consulta error proceso de produccion "+consulta);
             res=st.executeQuery(consulta);
             codEspecificacionCabecera=0;
             while(res.next())
             {
                 if(codEspecificacionCabecera!=res.getInt("COD_ESPECIFICACION_OOS"))out.println("<tr><td "+(res.getInt("conf")>0?" rowspan='2'":"")+">"+res.getString("NOMBRE_ESPECIFICACION_OOS")+
                         "</td><td "+(res.getInt("conf")>0?" rowspan='2' ":"colspan='2'")+" >"+(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0?"&nbsp;":"&nbsp;"+res.getString("DESCRIPCION"))+"</td>" +
                         (res.getInt("conf")>0?"<td style='width:14% !important'>FECHA DE CUMPLIMIENTO</td></tr><tr><td>"+(res.getTimestamp("FECHA_CUMPLIMIENTO")!=null?sdf.format(res.getTimestamp("FECHA_CUMPLIMIENTO")):"&nbsp;"):"</td>")+"</tr>");
                 if(res.getInt("COD_SUB_ESPECIFICACION_OOS")>0)out.println("<tr><td >"+res.getString("NOMBRE_SUB_ESPECIFICACION_OOS")+"</td><td colspan='2'>"+res.getString("DESCRIPCION")+"&nbsp;</td></tr>");
                 codEspecificacionCabecera=res.getInt("COD_ESPECIFICACION_OOS");
             }*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
        </table>
    </body>
</html>



