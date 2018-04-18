

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
String consulta ="select CP.COD_FORMA,pp.COD_PROGRAMA_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,"+
                 " pp.CANT_LOTE_PRODUCCION,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA,epp.NOMBRE_ESTADO_PROGRAMA_PROD,"+
                 " cp.COD_PROD,p.nombre_prod,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD,cp.COD_FORMA,"+
                 " isnull(sll.COD_SEGUIMIENTO_LIMPIEZA_LOTE,0)as registroLImpieza,"+
                  " isnull(srl.COD_SEGUIMIENTO_REPESADA_LOTE,0) as registroRepesada,"+
                  " isnull(sl.COD_SEGUIMIENTO_LAVADO_LOTE,0) as registroLavado,"+
                  " isnull(sdl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,0)as registroDespiro,"+
                  " isnull(sppl.COD_PROGRAMA_PROD,0) as registroPreparado,"+
                  " isnull(sdll.COD_SEGUIMIENTO_DOSIFICADO_LOTE,0) as registroDosificado,"+
                  " isnull(scll.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE,0) as registroControl,"+
                  " isnull(scdl.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE,0) as registroControlDosificado,"+
                  " isnull(srdl.COD_SEGUIMIENTO_RENDIMIENTO_LOTE,0) as registroRendimiento,"+
                  " isnull(sechl.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE,0) as registroEsterilizacion" +
                  " ,isnull(sgl.COD_SEGUIMIENTO_GRAFADO_LOTE,0) as registroGrafado" +
                  " ,isnull(cpr.COD_RECETA_ESTERILIZACION_CALOR,0) as recetaCalor"+
                  " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA fm on pp.COD_FORMULA_MAESTRA =fm.COD_FORMULA_MAESTRA"+
                  " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD"+
                  " inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD= pp.COD_ESTADO_PROGRAMA"+
                  " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA"+
                  " inner join PRODUCTOS p on p.cod_prod = cp.COD_PROD"+
                  " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD"+
                  " left outer join SEGUIMIENTO_LIMPIEZA_LOTE sll on sll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sll.COD_LOTE=pp.COD_LOTE_PRODUCCION "+
                  " left outer join SEGUIMIENTO_REPESADA_LOTE srl on srl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and srl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_LAVADO_LOTE sl on sl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_DESPIROGENIZADO_LOTE sdl on sdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sdl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_PREPARADO_LOTE sppl on sppl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sppl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_DOSIFICADO_LOTE sdll on sdll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sdll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_CONTROL_LLENADO_LOTE scll on scll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and scll.cod_lote=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE scdl on scdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and scdl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE srdl on srdl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and srdl.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                  " left outer join SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE sechl on sechl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and sechl.COD_LOTE=pp.COD_LOTE_PRODUCCION" +
                  " left outer join SEGUIMIENTO_GRAFADO_LOTE sgl on sgl.COD_LOTE=pp.COD_LOTE_PRODUCCION and sgl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                  " LEFT OUTER JOIN COMPONENTES_PROD_RECETA cpr ON cpr.COD_COMPROD =pp.COD_COMPPROD"+
                  " where pp.COD_ESTADO_PROGRAMA in (2, 5, 6, 7) and cp.COD_FORMA in (2,25,27)" +
                  " and ppp.COD_PROGRAMA_PROD >= 183 and pp.cod_lote_produccion = '"+lote+"'"+
                  " order by cp.nombre_prod_semiterminado,pp.COD_PROGRAMA_PROD";
System.out.println("consulta lotes "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
out.println("<table id='dataLote' class='tablaDetalle' cellpadding='0' cellspacing='0' style='width:80%' > <tr bgcolor='#cccccc'>");
out.println("<thead><tr><td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2' ><b>Lote</b></td> " +
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Producto</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Cant.<br>Lote</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Programa<br>Produccion</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Area</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Limpieza</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Repesada</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Lavado</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Despiro.</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Preparado</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Dosificado</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Grafado de<br>Frascos</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Control<br>Llenado<br>Volumen</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Control<br>Dosif</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Rend.Dosif</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Est.<br>Calor<br>Humedo</b></td>"+
        " <td  style='border-bottom: solid #666666 1px; border-left: solid #666666 1px;border-top: solid #666666 1px;' bgcolor='#f2f2f2'  align='center' class='outputText2'><b>Imprimir</b></td>"+

        " </tr></thead>");
out.println("<tbody>");
String codLoteCabecera="";
int cantidadLote=0;
String nombreProducto="";
int codCompProd=0;
String innerHTML="";
while(res.next())
{
    if(codLoteCabecera.equals(res.getString("COD_LOTE_PRODUCCION")))
    {
        cantidadLote+=res.getInt("CANT_LOTE_PRODUCCION");
        nombreProducto+=","+res.getString("nombre_prod_semiterminado");
        consulta="select case  when c.NRO_COMPPROD_DIAGRAMA_PREPARADO=1 then c.COD_COMPROD1 ELSE c.COD_COMPROD2 end "+
                 " from COMPONENTES_PROD_MIX c where "+
                 " (c.COD_COMPROD1="+codCompProd+" and c.COD_COMPROD2="+res.getInt("COD_COMPPROD")+")"+
                 " or (c.COD_COMPROD2="+res.getInt("COD_COMPPROD")+" and c.COD_COMPROD1="+codCompProd+")";
        System.out.println("cnsulta lote mix "+consulta.toString());
        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet resDetalle=stDetalle.executeQuery(consulta);
        if(resDetalle.next())codCompProd=resDetalle.getInt(1);
        innerHTML="<tr><td class='outputText2' >"+codLoteCabecera+"</td>" +
            "<td  class='outputText2'>"+nombreProducto+"</td>" +
            "<td  class='outputText2'>"+cantidadLote+"</td>" +
            "<td  class='outputText2'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>" +
            "<td  class='outputText2'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
            "<td>"+(res.getInt("registroLImpieza")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",1,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/limpieza.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroRepesada")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",2,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../sistemaTouch/reponse/img/repesada.jpg' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroLavado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",3,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/lavado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroDespiro")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",4,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/despirogenizado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroPreparado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",5,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../sistemaTouch/reponse/img/preparado.jpg' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroDosificado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",6,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/dosificado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroGrafado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",12,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/grafado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroControl")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",7,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/controllenado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroControlDosificado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",8,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/controlDosificado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroRendimiento")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",9,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/rendimiento.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+((res.getInt("recetaCalor")>0&&res.getInt("registroEsterilizacion")>0)?"<a href='#' onclick=\"verReporte("+codCompProd+",10,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/esterilizacion.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td><a href='#' onclick=\"verReporte("+codCompProd+",11,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/impresora2.jpg' alt='Limpieza'></a>"+"</td>"+
            "</tr>";
    }
    else
    {
        cantidadLote=res.getInt("CANT_LOTE_PRODUCCION");
        codLoteCabecera=res.getString("COD_LOTE_PRODUCCION");
        nombreProducto=res.getString("nombre_prod_semiterminado");
        codCompProd=res.getInt("COD_COMPPROD");
        innerHTML="<tr><td class='outputText2' >"+codLoteCabecera+"</td>" +
            "<td  class='outputText2'>"+nombreProducto+"</td>" +
            "<td  class='outputText2'>"+cantidadLote+"</td>" +
            "<td  class='outputText2'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>" +
            "<td  class='outputText2'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>" +
            "<td>"+(res.getInt("registroLImpieza")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",1,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/limpieza.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroRepesada")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",2,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../sistemaTouch/reponse/img/repesada.jpg' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroLavado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",3,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/lavado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroDespiro")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",4,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/despirogenizado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroPreparado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",5,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../sistemaTouch/reponse/img/preparado.jpg' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroDosificado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",6,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/dosificado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroGrafado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",12,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/grafado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroControl")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",7,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/controllenado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroControlDosificado")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",8,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/controlDosificado.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+(res.getInt("registroRendimiento")>0?"<a href='#' onclick=\"verReporte("+codCompProd+",9,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/rendimiento.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td>"+((res.getInt("recetaCalor")>0&&res.getInt("registroEsterilizacion")>0)?"<a href='#' onclick=\"verReporte("+codCompProd+",10,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/esterilizacion.gif' alt='Limpieza'></a>":"&nbsp")+"</td>"+
            "<td><a href='#' onclick=\"verReporte("+codCompProd+",11,"+res.getInt("COD_PROGRAMA_PROD")+",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("recetaCalor")>0?1:0)+",'"+res.getInt("COD_FORMA")+"')\"><img src='../../img/impresora2.jpg' alt='Limpieza'></a>"+"</td>"+
            "</tr>";
    }
    
}
out.println(innerHTML);      
out.println("</tbody>");
out.println("</table>");
%>