

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
    
  
</style>

<html>
    <body bgcolor="white"  >
        <table class="cabecera" cellpadding="0" cellspacing="0">
            <tr>
                <td rowspan="3" style="width:15%"><center><img src="../img/cofar.png" /></center></td>
                <td>
                    <span class="outputText2" style="font-size:16px"><center>CONTROL DE CALIDAD</center></span>
                </td>
                <td style="width:15%">
                    <span class="outputText2">Pagina 1 de 1</span>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="outputText2" style="font-size:14px"><center>CC-5-150</center></span>
                </td>
                <td>
                    <span class="outputText2">Vigencia: 00/00/00</span>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="outputText2" style="font-size:14px"><center>REGISTRO OOS</center></span>
                </td>
                <td>
                    <span class="outputText2">REVISION: 00</span>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" style="margin-top:1em;font-weight:normal !important;" >
            
<%
            try {
                Connection con = null;
                con = Util.openConnection(con);
                String codRegistroOOS=request.getParameter("codRegistroOOS");
            String consulta = "select pp.cod_lote_produccion, ro.CORRELATIVO_OOS,ro.FECHA_DETECCION,ro.FECHA_ENVIO_ASC,"+
                              " (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)as nombrePersonal"+
                              " ,ro.COD_LOTE,cp.nombre_prod_semiterminado,ro.PROVEEDOR"+
                              " from REGISTRO_OOS ro inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD=ro.COD_PROGRAMA_PROD"+
                              " and pp.COD_LOTE_PRODUCCION=ro.COD_LOTE"+
                              " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                              " left outer join personal p on p.COD_PERSONAL=ro.COD_PERSONAL_DETECTA"+
                              " where ro.COD_REGISTRO_OOS='"+codRegistroOOS+"'";
            System.out.println("consulta cabecera "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta);
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            while(res.next())
            {
                out.println("<tr><td>N° CORRELATIVO OOS</td><td colspan='2'><center>"+res.getString("CORRELATIVO_OOS")+"</center></td></tr>"+
                        "<tr><td>FECHA DE DETECCION OOS</td><td colspan='2'><center>"+(res.getTimestamp("FECHA_DETECCION")!=null?sdf.format(res.getTimestamp("FECHA_DETECCION")):"")+"</center></td></tr>"+
                        "<tr><td>FECHA DE ENVIO A ASC</td><td colspan='2'> <center>"+(res.getTimestamp("FECHA_ENVIO_ASC")!=null?sdf.format(res.getTimestamp("FECHA_ENVIO_ASC")):"")+"</center></td></tr>"+
                        "<tr><td>NOMBRE DE LA PERSONA DETECTA OOS</td><td colspan='2'><center>"+res.getString("nombrePersonal")+"</center></td></tr>"+
                        "<tr><td>MATERIAL/PRODUCTO</td><td colspan='2'><center>"+res.getString("nombre_prod_semiterminado")+"</center></td></tr>"+
                        "<tr><td>LOTE</td><td colspan='2'><center>"+res.getString("cod_lote_produccion")+"</center></td></tr>"+
                        "<tr><td>PROVEEDOR (Si aplica)</td><td <td colspan='2'><center>"+res.getString("PROVEEDOR")+"&nbsp;</center></td></tr>" +
                       "<tr><td colspan='3' style='font-weight:bold !important'><center>INVESTIGACION DE RESULTADO FUERA DE ESPECIFICACION(OOS)</center></td></tr>");
            }
            consulta="select seo.COD_SUB_ESPECIFICACION_OOS,eo.COD_ESPECIFICACION_OOS,eo.NOMBRE_ESPECIFICACION_OOS,seo.NOMBRE_SUB_ESPECIFICACION_OOS,isnull(rod.DESCRIPCION, '') as DESCRIPCION"+
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
             }
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
        </table>
    </body>
</html>



