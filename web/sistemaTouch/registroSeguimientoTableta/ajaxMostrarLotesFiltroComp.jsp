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
    String consulta="select pp.COD_PROGRAMA_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,"+
                       " pp.CANT_LOTE_PRODUCCION,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA,epp.NOMBRE_ESTADO_PROGRAMA_PROD"+
                       " ,cp.COD_PROD,p.nombre_prod,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD ,cp.COD_FORMA"+
                       " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA fm on"+
                       " pp.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp"+
                       " on cp.COD_COMPPROD=fm.COD_COMPPROD inner join ESTADOS_PROGRAMA_PRODUCCION epp"+
                       " on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA"+
                       " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                       " inner join PRODUCTOS p on p.cod_prod=cp.COD_PROD" +
                       " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                       " where pp.COD_ESTADO_PROGRAMA in (2,5,6,7) and cp.COD_FORMA in (1,35,36,37,38,39,40,41)"+
                       (codProgramaProd.equals("0")?"":" and pp.cod_programa_prod="+codProgramaProd)+
                       (codLote.equals("")?"":" and pp.cod_lote_produccion='"+codLote+"'")+
                       " order by cp.nombre_prod_semiterminado,pp.COD_PROGRAMA_PROD";
    System.out.println("consulta buscar lotes "+consulta);
    ResultSet res=st.executeQuery(consulta);
    out.println("<table cellpadding='0px' cellspacing='0px' style='width:100%'>"+
                " <tr><td class='tableHeaderClass' style='width:30%'><span class='textHeaderClass'>Producto</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Nro Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Programa<br>Producción</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Area</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Desp.<br>Linea</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Repesada</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Limpieza<br>Amb.</span></td>"+
                " </tr>");
    
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
    while(res.next())
    {
        if(!codLoteCabecera.equals(res.getString("COD_LOTE_PRODUCCION")+" "+res.getString("COD_PROGRAMA_PROD")))
        {
            if(!codLoteCabecera.equals(""))
            {
                if(contLote>1)
                {
                    String[]  codProd=codComprod.split(",");
                    if(codProd.length==2)
                    {
                        consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD_MIX cpm inner join COMPONENTES_PROD cp"+
                                        " on cp.COD_COMPPROD=cpm.COD_COMPROD_MIX"+
                                        " where ((cpm.COD_COMPROD1='"+codProd[0]+"' and cpm.COD_COMPROD2='"+codProd[1]+"') or"+
                                        " (cpm.COD_COMPROD1='"+codProd[1]+"' and cpm.COD_COMPROD2='"+codProd[0]+"'))";
                        System.out.println("consulta buscar mix "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        if(resDetalle.next())
                        {
                            codComprod=resDetalle.getString("COD_COMPPROD");
                            producto=resDetalle.getString("nombre_prod_semiterminado");
                        }
                        else
                        {
                            codComprod="";
                            producto="No definido("+producto+")";
                            
                        }

                    }
                    if(codProd.length>2)
                    {
                        codComprod="";
                        producto="No definido("+producto+")";
                    }

                }
                out.println("<tr>" +
                        "<td class='tableCell' style='width:30%'><span class='textHeaderClassBody'>"+producto+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+codLote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+cantlote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreProgramaProd+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreAreaEmpresa+"</span></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"openPopup('registroDespejeLinea/registroDespejeLinea.jsf?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"')\"><img src='../../img/dosificado.gif' alt='Despeje de Linea'></a><center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"openPopup('registroRepesada/registroRepesada.jsf?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"')\"><img src='../reponse/img/repesada.jpg' alt='Repesada'></a><center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"openPopup('registroLimpiezaAmbientes/registroLimpiezaAmbientes.jsf?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"')\"><img src='../../img/limpieza.gif' alt='Limpieza'></a><center></td>" +
                        "</tr>");
            }

            codLoteCabecera=res.getString("COD_LOTE_PRODUCCION")+" "+res.getString("COD_PROGRAMA_PROD");
            
            producto="";
            cantlote=0d;
             nroLote="";
            area="";
            estado="";
            codLote=res.getString("COD_LOTE_PRODUCCION");
            contLote=0;
            codComprod="";
        }
        contLote++;
        codProgramaProdLista=res.getString("COD_PROGRAMA_PROD");
        nombreProgramaProd=res.getString("NOMBRE_PROGRAMA_PROD");
        codAreaEmpresa=res.getString("COD_AREA_EMPRESA");
        nombreAreaEmpresa=res.getString("NOMBRE_AREA_EMPRESA");
        cantlote= cantlote+res.getDouble("CANT_LOTE_PRODUCCION");
        codComprod+=(contLote>1?",":"")+res.getString("COD_COMPPROD");
        producto+=(contLote>1?",":"")+res.getString("nombre_prod_semiterminado");
        estado=res.getString("NOMBRE_ESTADO_PROGRAMA_PROD");
        
    }
    if(!codLoteCabecera.equals(""))
            {
                if(contLote>1)
                {
                    String[]  codProd=codComprod.split(",");
                    if(codProd.length==2)
                    {
                        consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD_MIX cpm inner join COMPONENTES_PROD cp"+
                                        " on cp.COD_COMPPROD=cpm.COD_COMPROD_MIX"+
                                        " where ((cpm.COD_COMPROD1='"+codProd[0]+"' and cpm.COD_COMPROD2='"+codProd[1]+"') or"+
                                        " (cpm.COD_COMPROD1='"+codProd[1]+"' and cpm.COD_COMPROD2='"+codProd[0]+"'))";
                        System.out.println("consulta buscar mix "+consulta);
                        resDetalle=stDetalle.executeQuery(consulta);
                        if(resDetalle.next())
                        {
                            codComprod=resDetalle.getString("COD_COMPPROD");
                            producto=resDetalle.getString("nombre_prod_semiterminado");
                        }
                        else
                        {
                            codComprod="";
                            producto="No definido("+producto+")";

                        }

                    }
                    if(codProd.length>2)
                    {
                        codComprod="";
                        producto="No definido("+producto+")";
                    }

                }
                out.println("<tr>" +
                        "<td class='tableCell' style='width:30%'><span class='textHeaderClassBody'>"+producto+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+codLote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+cantlote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreProgramaProd+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreAreaEmpresa+"</span></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"openPopup('registroDespejeLinea/registroDespejeLinea.jsf?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"')\"><img src='../../img/dosificado.gif' alt='Despeje de Linea'></a><center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"openPopup('registroRepesada/registroRepesada.jsf?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"')\"><img src='../reponse/img/repesada.jpg' alt='Repesada'></a><center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center><a onclick=\"openPopup('registroLimpiezaAmbientes/registroLimpiezaAmbientes.jsf?codComprod="+codComprod+"&codLote="+codLote+"&codAreaEmpresa="+codAreaEmpresa+"&cod_prog="+codProgramaProdLista+"')\"><img src='../../img/limpieza.gif' alt='Limpieza'></a><center></td>" +
                        "</tr>");
            }
    out.println("</table>");
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
