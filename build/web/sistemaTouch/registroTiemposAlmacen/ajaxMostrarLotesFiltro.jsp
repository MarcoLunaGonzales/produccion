<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
int codPersonal=(Integer.valueOf(request.getParameter("codPersonal")));
boolean administrador=(Integer.valueOf(request.getParameter("administrador"))>0);
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    String consulta="select pp.COD_TIPO_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,"+
                    "pp.CANT_LOTE_PRODUCCION,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA,epp.NOMBRE_ESTADO_PROGRAMA_PROD,"+
                    " cp.COD_PROD,p.nombre_prod,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD,cp.COD_FORMA,tpp.NOMBRE_TIPO_PROGRAMA_PROD" +
                    " ,pediente.pendiente,registrado.registrado"+
                    " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA fm on pp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA"+
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD"+
                    " inner join ESTADOS_PROGRAMA_PRODUCCION epp on epp.COD_ESTADO_PROGRAMA_PROD = pp.COD_ESTADO_PROGRAMA"+
                    " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA"+
                    " inner join PRODUCTOS p on p.cod_prod = cp.COD_PROD"+
                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD ="+
                    " pp.COD_PROGRAMA_PROD " +//and ppp.COD_TIPO_PRODUCCION = 1
                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                    " outer apply(select count(*) as pendiente from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp "+
                    " where spp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and spp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                    " and spp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and spp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                    " and spp.COD_COMPPROD=pp.COD_COMPPROD"+
                    " and (spp.REGISTRO_CERRADO=0 or spp.REGISTRO_CERRADO is null)"+
                    " and spp.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'" +
                    (administrador?"":" and spp.COD_PERSONAL='"+codPersonal+"'") +
                    " )as pediente"+
                    " outer apply(select count(*) as registrado from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp "+
                    " where spp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and spp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                    " and spp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and spp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                    " and spp.COD_COMPPROD=pp.COD_COMPPROD"+
                    " and spp.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00' " +
                    (administrador?"":" and spp.COD_PERSONAL='"+codPersonal+"'") +
                    " ) as registrado"+
                    " where pp.COD_ESTADO_PROGRAMA in (2, 5, 6, 7) and ppp.COD_PROGRAMA_PROD >= 183" +
                    " and cast(pp.COD_PROGRAMA_PROD as varchar)+' '+cast(pp.COD_COMPPROD as varchar)+' '+"+
                    "cast(pp.COD_FORMULA_MAESTRA as varchar)+' '+cast(pp.COD_TIPO_PROGRAMA_PROD as varchar)+' '+pp.COD_LOTE_PRODUCCION" +
                    " not in(select cast(cpp.COD_PROGRAMA_PROD as varchar)+' '+cast(cppd.COD_COMPPROD as varchar)+' '+"+
                    " cast(cppd.COD_FORMULA_MAESTRA as varchar)+' '+cast(cppd.COD_TIPO_PROGRAMA_PROD as varchar)+' '+cppd.COD_LOTE_PRODUCCION"+
                    " from CAMPANIA_PROGRAMA_PRODUCCION cpp inner join CAMPANIA_PROGRAMA_PRODUCCION_DETALLE cppd on"+
                    " cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION=cppd.COD_CAMPANIA_PROGRAMA_PRODUCCION)" +
                    (Integer.valueOf(codProgramaProd)>0?" and pp.cod_programa_prod ='"+codProgramaProd+"'":"")+
                    (codLote.equals("")?"":" and pp.COD_LOTE_PRODUCCION='"+codLote+"'")+
                    " order by cp.nombre_prod_semiterminado,pp.COD_PROGRAMA_PROD";
    System.out.println("consulta buscar lotes "+consulta);
    ResultSet res=st.executeQuery(consulta);
    String innerHTML="";
    
    
    String producto="";
    Double cantlote=0d;
    String nroLote="";
    String area="";
    String estado="";
    String codAreaEmpresa="";
    String nombreAreaEmpresa="";
    String nombreProgramaProd="";
    String codLoteCabecera="";
    String codProgramaProdLista="";
    int contLote=0;
    String codComprod="";
    Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet resDetalle=null;
    int codForma=0;
    //boolean[] cabeceras=new boolean[9];
    while(res.next())
    {
        codProgramaProdLista=res.getString("COD_PROGRAMA_PROD");
        nombreProgramaProd=res.getString("NOMBRE_PROGRAMA_PROD");
        codAreaEmpresa=res.getString("COD_AREA_EMPRESA");
        nombreAreaEmpresa=res.getString("NOMBRE_AREA_EMPRESA");
        cantlote=res.getDouble("CANT_LOTE_PRODUCCION");
        codComprod=res.getString("COD_COMPPROD");
        producto=res.getString("nombre_prod_semiterminado");
        estado=res.getString("NOMBRE_ESTADO_PROGRAMA_PROD");
        innerHTML+="<tr class='"+(res.getInt("pendiente")>0?"enRegistro":(res.getInt("registrado")>0?"registrado":"sinRegistro"))+"' onclick=\"mostrarActividadesProduccion('"+res.getString("COD_LOTE_PRODUCCION")+"','"+res.getInt("COD_PROGRAMA_PROD")+"','"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"')\">" +
                "<td  style='width:30%'><span class=''>"+producto+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+res.getString("COD_LOTE_PRODUCCION")+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+cantlote+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+nombreProgramaProd+"</span></td>" +
                "</tr>";
            
            
        
        
    }
    consulta="select cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION,cpp.NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION,cppd.COD_LOTE_PRODUCCION" +
             " ,PP.CANT_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,tpp.ABREVIATURA,registrado.registrado,pendiente.pendiente"+
             " from CAMPANIA_PROGRAMA_PRODUCCION cpp inner JOIN CAMPANIA_PROGRAMA_PRODUCCION_DETALLE cppd"+
             " on cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION=cppd.COD_CAMPANIA_PROGRAMA_PRODUCCION"+
             (Integer.valueOf(codProgramaProd)>0?" and cpp.COD_PROGRAMA_PROD ='"+codProgramaProd+"'":"")+
             (codLote.equals("")?"":" and cppd.COD_LOTE_PRODUCCION='"+codLote+"'")+
             " inner join PROGRAMA_PRODUCCION pp on pp.COD_PROGRAMA_PROD=cpp.COD_PROGRAMA_PROD"+
             " and pp.COD_FORMULA_MAESTRA=cppd.COD_FORMULA_MAESTRA"+
             " and pp.COD_COMPPROD=cppd.COD_COMPPROD"+
             " and pp.COD_TIPO_PROGRAMA_PROD=cppd.COD_TIPO_PROGRAMA_PROD"+
             " and pp.COD_LOTE_PRODUCCION=cppd.COD_LOTE_PRODUCCION" +
             " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=cpp.COD_PROGRAMA_PROD"+
             " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
             " outer apply(select count(*) as pendiente from SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL s "+
             " where s.COD_CAMPANIA_PROGRAMA_PRODUCCION=cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION"+
             " and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00' and (s.REGISTRO_CERRADO=0 or s.REGISTRO_CERRADO is null)"+
             (administrador?"":" and s.COD_PERSONAL='"+codPersonal+"'")+")pendiente"+
             " outer apply(select count(*) as registrado from SEGUIMIENTO_CAMPANIA_PROGRAMA_PRODUCCION_PERSONAL s "+
             " where s.COD_CAMPANIA_PROGRAMA_PRODUCCION=cpp.COD_CAMPANIA_PROGRAMA_PRODUCCION and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'"+
             (administrador?"":" and s.COD_PERSONAL='"+codPersonal+"'")+" )registrado";
    System.out.println("consulta campanias "+consulta);
    res=st.executeQuery(consulta);
    while(res.next())
    {
        String lotesCampania="";
        String tamanosLote="";
        int codCampania=res.getInt("COD_CAMPANIA_PROGRAMA_PRODUCCION");
        innerHTML+="<tr class='"+(res.getInt("pendiente")>0?"enRegistro":(res.getInt("registrado")>0?"registrado":"sinRegistro"))+"' onclick=\"mostrarActividadesCampania('"+codCampania+"')\">" +
                "<td  style='width:30%'><span class=''>"+res.getString("NOMBRE_CAMPANIA_PROGRAMA_PRODUCCION")+"</span></td>";
        String nombrePrograma=res.getString("NOMBRE_PROGRAMA_PROD");
        lotesCampania=res.getString("COD_LOTE_PRODUCCION");
        tamanosLote=res.getString("CANT_LOTE_PRODUCCION");
        String tiposProduccion=res.getString("ABREVIATURA");
        while(res.next())
        {
            if(codCampania==res.getInt("COD_CAMPANIA_PROGRAMA_PRODUCCION"))
            {
                lotesCampania+="<br>"+res.getString("COD_LOTE_PRODUCCION");
                tamanosLote+="<br>"+res.getString("CANT_LOTE_PRODUCCION");
                tiposProduccion+="<br>"+res.getString("ABREVIATURA");
            }
            else
            {
                res.previous();
                break;
            }
            
        }
        innerHTML+="<td  style='width:10%'><span class=''>"+lotesCampania+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+tamanosLote+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+tiposProduccion+"</span></td>" +
                "<td  style='width:10%'><span class=''>"+nombreProgramaProd+"</span></td>" +
                "</tr>";
    }
             
    innerHTML+="</table>";
    out.println("<table id='tablaLotesProcesar' cellpadding='0px' cellspacing='0px' style='width:95%'>"+
                "<thead> <tr><td class='tableHeaderClass' style='width:30%'><span class='textHeaderClass'>Producto</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Cantidad<br>Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Tipo Produccion</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Programa<br>Producción</span></td>"+
                
                " </tr></thead><tbody>");
    out.println(innerHTML+"</tbody>");
    
    stDetalle.close();
    res.close();
    st.close();
    con.close();
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
%>
