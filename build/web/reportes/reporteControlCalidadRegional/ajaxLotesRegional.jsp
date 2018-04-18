

<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>

<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codComprod=request.getParameter("codComprod")!=null?request.getParameter("codComprod"):"";
String lote=request.getParameter("lote")!=null?request.getParameter("lote"):"";
System.out.println("lote"+lote);
String consulta ="select era.NOMBRE_ESTADO_RESULTADO_ANALISIS,datosPrograma.COD_FORMA,era.COD_ESTADO_RESULTADO_ANALISIS,ra.COD_LOTE,cp.nombre_prod_semiterminado,datosPrograma.COD_PROD"+
                        ",fechaVencimiento.FECHA_VENC"+
        " from RESULTADO_ANALISIS ra inner join COMPONENTES_PROD cp"+
" on cp.COD_COMPPROD=ra.COD_COMPROD inner join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS"+
        " outer apply(select top 1 sd.FECHA_VENC from SALIDAS_DETALLEACOND sd where sd.COD_LOTE_PRODUCCION=ra.cod_lote"+
        " and sd.COD_COMPPROD=ra.COD_COMPROD"+
        " order by sd.FECHA_VENC desc"+
        " ) as fechaVencimiento "+
" outer apply( select TOP 1 cpv.COD_FORMA,cpv.COD_PROD from PROGRAMA_PRODUCCION p  inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=p.COD_COMPPROD"+
" and cpv.COD_VERSION=p.COD_COMPPROD_VERSION where p.COD_LOTE_PRODUCCION=ra.COD_LOTE and p.COD_COMPPROD=ra.COD_COMPROD"+
") as datosPrograma"
+ " where  ra.COD_ESTADO_RESULTADO_ANALISIS=1"+//where ra.COD_ESTADO_RESULTADO_ANALISIS in (1,2)
/*" and ra.COD_COMPROD in(select  cpp.COD_COMPPROD from PRESENTACIONES_PRODUCTO pp inner join COMPONENTES_PRESPROD cpp on cpp.COD_PRESENTACION=pp.cod_presentacion"+
" where pp.prod_institucional=1 and cpp.COD_ESTADO_REGISTRO=1)"+        */
" and cast(ra.COD_COMPROD as varchar)+'$'+ra.COD_LOTE not in(select cast(cpc.COD_COMPPROD as varchar)+'$'+cpc.LOTE from CERTIFICADOS_PDF_CCC cpc)";
if(!lote.equals(""))
    {
    consulta+=" and ra.COD_LOTE = '"+lote+"'";
    }
if(!codComprod.equals("0"))
{
    consulta+=" and ra.COD_COMPROD='"+codComprod+"'";
}
consulta+=" order by cp.nombre_prod_semiterminado,ra.COD_LOTE";
System.out.println("consulta lotes "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<table id='dataLote' class='outputText0' cellpadding='0' cellspacing='0' style='width:80%' > <tr bgcolor='#cccccc'>");
out.println("" +
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2' ><b>Lote</b></td> " +
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Producto</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Fecha Vencimiento</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Certificado</b></td>"+
        " </tr>");
SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
while(rs.next())
{
    out.println("<tr>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2' ><input type='hidden' value='"+rs.getString("COD_FORMA")+"'/><span>"+rs.getString("COD_LOTE")+"</span></td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'><input type='hidden' value='"+rs.getString("COD_PROD")+"'/>"+rs.getString("nombre_prod_semiterminado")+"</td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'><input type='hidden' value='"+rs.getString("COD_PROD")+"'/>"+(rs.getTimestamp("FECHA_VENC")!=null?sdf.format(rs.getTimestamp("FECHA_VENC")):"")+"</td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'><a href='#' onclick=\"verReporte('"+rs.getString("COD_LOTE")+"',"+rs.getInt("COD_FORMA")+","+rs.getInt("COD_PROD")+")\"><img src='../../img/pdf.jpg'/></a></td>"+
            "</tr>");
}
consulta="select cpc.NOMBRE_ARCHIVO,cp1.nombre_prod_semiterminado,cpc.LOTE,fechaVencimiento.FECHA_VENC"+
        " from CERTIFICADOS_PDF_CCC cpc"+
        " inner join COMPONENTES_PROD cp1 on cp1.COD_COMPPROD=cpc.COD_COMPPROD"+
        " outer apply(select top 1 sd.FECHA_VENC from SALIDAS_DETALLEACOND sd where sd.COD_LOTE_PRODUCCION=cpc.LOTE"+
        " and sd.COD_COMPPROD=cpc.COD_COMPPROD"+
        " order by sd.FECHA_VENC desc"+
        " ) as fechaVencimiento"+
        " where cpc.COD_COMPPROD in(select  cpp.COD_COMPPROD from PRESENTACIONES_PRODUCTO pp inner join COMPONENTES_PRESPROD cpp on cpp.COD_PRESENTACION=pp.cod_presentacion"+
        " where pp.prod_institucional=1 and cpp.COD_ESTADO_REGISTRO=1)"+     
        (codComprod.equals("0")?"":" and cpc.COD_COMPPROD="+codComprod)+
        (lote.equals("")?"":" and cpc.LOTE='"+lote+"'")+
        " order by cp1.nombre_prod_semiterminado,cpc.LOTE";
rs=st.executeQuery(consulta);
while(rs.next())
{
     out.println("<tr>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2' ><span>"+rs.getString("LOTE")+"</span></td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'>"+rs.getString("nombre_prod_semiterminado")+"</td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'>"+(rs.getTimestamp("FECHA_VENC")!=null?sdf.format(rs.getTimestamp("FECHA_VENC")):"&nbsp;")+"</td>" +
            "<td style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;;padding:5px' bgcolor='#f2f2f2' class='outputText2'><a href='#' onclick=\"verCertificadoPDf('"+rs.getString("NOMBRE_ARCHIVO")+"')\"><img src='../../img/pdf.jpg'/></a></td>"+
            "</tr>");
}
con.close();
out.println("</table>");
%>