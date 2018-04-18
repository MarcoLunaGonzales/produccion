<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
int codPersonal=(Integer.valueOf(request.getParameter("codPersonal"))/4);
boolean administrador=(Integer.valueOf(request.getParameter("codTipoPermiso"))==12);//permisos de adeministrador
out.println("<table id='tablaLotesProcesar' cellpadding='0px' cellspacing='0px' style='width:100%'>"+
                " <thead><tr><td class='tableHeaderClass prim' style='width:30%'><span class='textHeaderClass'>Producto</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Nro Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Programa<br>Producción</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Tipo<br>Produccion</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lavado<br>Ampollas<br>Dosificado</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Inspeccion<br>Ampollas<br>Dosificadas</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Limpieza<br>de<br>Capsulas</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Timbrado<br>Empaque<br>Primario</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Entrega<br>Material<br>Secundario</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Timbrado<br>Empaque<br>Secundario</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Encunado<br>Desencunado</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Proceso<br>Acondicionamiento</span></td>"+
                " <td class='tableHeaderClass "+(administrador?"":"ult")+"' style='width:10%'><span class='textHeaderClass'>Devolucion<br>de<br>Material</span></td>"+
                (administrador?" <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Rendimiento<br>Final</span></td>"+
                " <td class='tableHeaderClass ult' style='width:10%'><span class='textHeaderClass'>Habilitar<br>Registro</span></td>":"")+
                " </tr></thead><tbody>");
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta="select pp.COD_TIPO_PROGRAMA_PROD, pp.COD_PROGRAMA_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,"+
                       " pp.CANT_LOTE_PRODUCCION,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA,epp.NOMBRE_ESTADO_PROGRAMA_PROD"+
                       " ,cp.COD_PROD,p.nombre_prod,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD ,cp.COD_FORMA" +
                       " ,isnull(cpr.COD_RECETA_ESTERILIZACION_CALOR,0) AS COD_RECETA_ESTERILIZACION_CALOR" +
                       " ,ISNULL(lha.cod_programa_prod,0) as permisoLote,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                       " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA fm on"+
                       " pp.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp"+
                       " on cp.COD_COMPPROD=fm.COD_COMPPROD inner join ESTADOS_PROGRAMA_PRODUCCION epp"+
                       " on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA"+
                       " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                       " inner join PRODUCTOS p on p.cod_prod=cp.COD_PROD" +
                       " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and ppp.COD_TIPO_PRODUCCION=1 " +
                       " LEFT OUTER JOIN COMPONENTES_PROD_RECETA cpr ON cpr.COD_COMPROD = pp.COD_COMPPROD" +
                       " LEFT OUTER JOIN LOTES_HABILITADOS_ACOND lha on lha.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                       " and pp.COD_PROGRAMA_PROD=lha.COD_PROGRAMA_PROD and pp.COD_TIPO_PROGRAMA_PROD=lha.COD_TIPO_PROGRAMA_PROD and pp.COD_COMPPROD=lha.COD_COMPPROD" +
                       " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                       " where pp.COD_ESTADO_PROGRAMA in (2,5,6,7)  and ppp.COD_PROGRAMA_PROD>=183 "+
                       (codProgramaProd.equals("0")?"":" and pp.cod_programa_prod="+codProgramaProd)+
                       (codLote.equals("")?"":" and pp.cod_lote_produccion='"+codLote+"'")+
                       " order by cp.nombre_prod_semiterminado,pp.COD_PROGRAMA_PROD";
    System.out.println("consulta buscar lotes "+consulta);
    ResultSet res=st.executeQuery(consulta);
    boolean loteHabilitado=false;
    while(res.next())
    {
        loteHabilitado=(res.getInt("permisoLote")>0);
        out.println("<tr>" +
                        "<td class='tableCell' style='width:30%'><span class='textHeaderClassBody'>"+res.getString("nombre_prod_semiterminado")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("COD_LOTE_PRODUCCION")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("CANT_LOTE_PRODUCCION")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></td>" +
                        (res.getInt("COD_FORMA")==2?
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\" iniciarTransaccionAcondicionamiento(1,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/lavado.gif' alt='Limpieza'></a><center>":"")+"</td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(2,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/ins.jpg' alt='Inspeccion de Ampollas'></a>":"")+"<center></td>":"<td class='tableCell'>&nbsp;</td><td class='tableCell'>&nbsp;</td>")+
                        (res.getInt("COD_FORMA")==6?"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(10,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/capsula.jpg' alt='Limpieza de Capsulas'></a>":"")+"<center></td>":"<td class='tableCell'>&nbsp;</td>")+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(3,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/timEmpPrim.jpg' alt='Timbrado Envase Primario'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(4,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/entEmpSec.jpg' alt='Seguimiento Preparado'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(5,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/timEmpSec.jpg' alt='Seguimiento Preparado'></a>":"")+"<center></td>" +
                        (res.getInt("COD_FORMA")==2?"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(6,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/enc.jpg' alt='Dosificado'></a>":"")+"<center></td>":"<td class='tableCell'>&nbsp;</td>")+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(7,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/acond.jpg' alt='Control Llenado Volumen'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(loteHabilitado||administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(8,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/devolucion.jpg' alt='Control Llenado Volumen'></a>":"")+"<center></td>" +
                        (administrador?"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(administrador?"<a onclick=\"iniciarTransaccionAcondicionamiento(9,'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getString("COD_LOTE_PRODUCCION")+"')\"><img src='../../img/rendimiento.jpg' alt='Control Dosificado'></a>":"")+"<center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><button onclick=\"cambiarEstadoLote('"+res.getString("COD_LOTE_PRODUCCION")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"','"+res.getInt("COD_COMPPROD")+"',"+loteHabilitado+");\" class='small button succes radius "+(loteHabilitado?"buttonMas":"buttonMenos")+"'>"+(loteHabilitado?"SI":"NO")+" </button><center></td>":"")+
                        "</tr>");
            

    }
        
    
    out.println("</tbody></table>");
    
    res.close();
    st.close();
    con.close();
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
%>
