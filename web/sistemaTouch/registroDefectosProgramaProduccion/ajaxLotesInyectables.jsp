<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,sum(pp.CANT_LOTE_PRODUCCION) as cantidadLote,"+
                            " epp.NOMBRE_ESTADO_PROGRAMA_PROD,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA," +
                            " pp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA,pp.COD_PROGRAMA_PROD"+
                            " from PROGRAMA_PRODUCCION pp inner join PROGRAMA_PRODUCCION_PERIODO ppp"+
                            " on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                            " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                            " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA" +
                            " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                            " where pp.cod_estado_programa in (2,5,6,7) AND  cp.COD_AREA_EMPRESA=81 and ppp.COD_ESTADO_PROGRAMA<>4 and ISNULL(ppp.COD_TIPO_PRODUCCION,1) in (1)"+
                            (codProgramaProd.equals("0")?"":" and pp.COD_PROGRAMA_PROD='"+codProgramaProd+"'")+
                            (codLote.equals("")?"":" and pp.COD_LOTE_PRODUCCION  like '%"+codLote+"%'")+
                            "group by cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,epp.NOMBRE_ESTADO_PROGRAMA_PROD,ae.COD_AREA_EMPRESA"+
                            " ,ae.NOMBRE_AREA_EMPRESA,pp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.COD_FORMULA_MAESTRA,pp.COD_PROGRAMA_PROD"+
                            " order by cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION";
    System.out.println("consulta buscar lotes inyectables"+consulta);
    ResultSet res=st.executeQuery(consulta);
    out.println("<table cellpadding='0px' cellspacing='0px' style='width:100%'>"+
                " <tr><td class='tableHeaderClass' style='width:30%'><span class='textHeaderClass'>Producto</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Nro Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Tipo<br>Programa</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Area</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Estado</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Defectos</span></td>"+
                " </tr>");
    while(res.next())
    {
                  out.println("<tr>" +
                        "<td class='tableCell' style='width:30%'><span class='textHeaderClassBody'>"+res.getString("nombre_prod_semiterminado")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getDouble("cantidadLote")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("COD_LOTE_PRODUCCION")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")+"</span></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"var a=Math.random();window.location.href='navegadorPersonalAcond.jsf?" +
                        "codLote="+res.getString("COD_LOTE_PRODUCCION")+"&codTipoPP="+res.getString("COD_TIPO_PROGRAMA_PROD")+
                        "&codCompProd="+res.getString("COD_COMPPROD")+"&codProgProd="+res.getString("COD_PROGRAMA_PROD")+"&codFormula="+res.getString("COD_FORMULA_MAESTRA")+"&cod='+a\"><img src='../../img/detalle.jpg' alt='Defectos Despirogenizado'></a><center></td>" +
                        "</tr>");
    }
    out.println("</table>");
    res.close();
    st.close();
    con.close();
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
%>
