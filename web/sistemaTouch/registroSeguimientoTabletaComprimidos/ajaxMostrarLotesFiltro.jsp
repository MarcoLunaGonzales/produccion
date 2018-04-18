<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%
String codAreaEmpresaUsuario=request.getParameter("codAreaEmpresa");
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
int codPersonal=(Integer.valueOf(request.getParameter("codPersonal"))/4);
boolean administrador=(Integer.valueOf(request.getParameter("administrador"))>0);
try
{

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta="select pp.COD_PROGRAMA_PROD,cp.COD_COMPPROD,cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,"+
                       " pp.CANT_LOTE_PRODUCCION,ae.NOMBRE_AREA_EMPRESA,ae.COD_AREA_EMPRESA,epp.NOMBRE_ESTADO_PROGRAMA_PROD"+
                       " ,cp.COD_PROD,p.nombre_prod,ppp.NOMBRE_PROGRAMA_PROD,pp.COD_PROGRAMA_PROD ,cp.COD_FORMA" +
                       " ,isnull(cpr.COD_RECETA_ESTERILIZACION_CALOR,0) AS COD_RECETA_ESTERILIZACION_CALOR" +
                       (administrador?"":",isnull(toml1.COD_PERSONAL,0) as permisoLimpieza,"+
                       " isnull(tareaLavado.COD_PERSONAL,0) as permisoLavado,ISNULL(toml4.COD_PERSONAL,0) as permisoDespirogenizado"+
                       " ,ISNULL(toml5.COD_PERSONAL,0) as permisoPreparado,ISNULL(tareaDosificado.COD_PERSONAL,0) as permisoDosificado"+
                       " ,ISNULL(tareaLLenado.COD_PERSONAL,0) as permisoControlLlenado,ISNULL(toml8.COD_PERSONAL,0) as permisoControlDosificado"+
                       " ,ISNULL(toml9.COD_PERSONAL,0) as permisoRendimiento,ISNULL(toml10.COD_PERSONAL,0) as permisoEsterilizacion")+
                       ", cp.COD_FORMA"+
                       " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA fm on"+
                       " pp.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp"+
                       " on cp.COD_COMPPROD=fm.COD_COMPPROD inner join ESTADOS_PROGRAMA_PRODUCCION epp"+
                       " on epp.COD_ESTADO_PROGRAMA_PROD=pp.COD_ESTADO_PROGRAMA"+
                       " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                       " inner join PRODUCTOS p on p.cod_prod=cp.COD_PROD" +
                       " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and ppp.COD_TIPO_PRODUCCION=1 " +
                       " LEFT OUTER JOIN COMPONENTES_PROD_RECETA cpr ON cpr.COD_COMPROD = pp.COD_COMPPROD" +
                       (administrador?"":
                       " LEFT OUTER JOIN TAREAS_OM_PERSONAL_LOTE toml1 on toml1.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                       " and toml1.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and toml1.COD_TAREA_OM in (1)"+
                       " and toml1.COD_PERSONAL='"+codPersonal+"'"+
                       " outer apply(select top 1 toml3.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE toml3 where toml3.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml3.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       "  and toml3.COD_TAREA_OM in (3, 4) and toml3.COD_PERSONAL = '"+codPersonal+"' ) as tareaLavado"+
                       "  LEFT OUTER JOIN TAREAS_OM_PERSONAL_LOTE toml4 on toml4.COD_LOTE ="+
                       "  pp.COD_LOTE_PRODUCCION and toml4.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml4.COD_TAREA_OM in (5) and toml4.COD_PERSONAL = '"+codPersonal+"'"+
                       " LEFT OUTER JOIN TAREAS_OM_PERSONAL_LOTE toml5 on toml5.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml5.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml5.COD_TAREA_OM in (6) and toml5.COD_PERSONAL = '"+codPersonal+"'"+
                       " outer APPLY(select top 1 toml6.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE toml6 where toml6.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml6.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml6.COD_TAREA_OM in (7,8,9,10) and toml6.COD_PERSONAL = '"+codPersonal+"' ) tareaDosificado"+
                       " outer apply(select top 1  toml7.COD_PERSONAL from TAREAS_OM_PERSONAL_LOTE toml7 where toml7.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml7.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml7.COD_TAREA_OM in (11,12,13) and toml7.COD_PERSONAL = '"+codPersonal+"' ) tareaLLenado"+
                       " LEFT OUTER JOIN TAREAS_OM_PERSONAL_LOTE toml8 on toml8.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml8.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml8.COD_TAREA_OM in (14) and toml8.COD_PERSONAL = '"+codPersonal+"'"+
                       " LEFT OUTER JOIN TAREAS_OM_PERSONAL_LOTE toml9 on toml9.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml9.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml9.COD_TAREA_OM in (15) and toml9.COD_PERSONAL = '"+codPersonal+"'" +
                       " LEFT OUTER JOIN TAREAS_OM_PERSONAL_LOTE toml10 on toml10.COD_LOTE ="+
                       " pp.COD_LOTE_PRODUCCION and toml10.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD"+
                       " and toml10.COD_TAREA_OM in (16) and toml10.COD_PERSONAL = '"+codPersonal+"'")+
                       " where pp.COD_ESTADO_PROGRAMA in (2,5,6,7) and cp.COD_FORMA in (1,35,36,37,38,39,40,41) and ppp.COD_PROGRAMA_PROD>=183"+
                       (codProgramaProd.equals("0")?"":" and pp.cod_programa_prod="+codProgramaProd)+
                       (codLote.equals("")?"":" and pp.cod_lote_produccion='"+codLote+"'")+
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
    int codRecetaCalorHUmedo=0;
    boolean[] permisos=new boolean[10];
    int codForma=0;
    //boolean[] cabeceras=new boolean[9];
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
                innerHTML+="<tr>" +
                        "<td class='tableCell' style='width:30%'><span class='textHeaderClassBody'>"+producto+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+codLote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+cantlote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreProgramaProd+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreAreaEmpresa+"</span></td>" +
                        (codAreaEmpresaUsuario.equals("40")?"":"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[0]?"<a onclick=\"registroOM(1,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/limpieza.gif' alt='Limpieza'></a>":"")+"<center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[1]&&administrador?"<a onclick=\"registroOM(2,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../reponse/img/repesada.jpg' alt='Repesada'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[2]?"<a onclick=\"registroOM(3,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>")+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[3]?"<a onclick=\"registroOM(4,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>" +
                        (codAreaEmpresaUsuario.equals("40")?"":"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[4]?"<a onclick=\"registroOM(5,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[5]?"<a onclick=\"registroOM(6,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[5]?"<a onclick=\"registroOM(7,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"
                        )+
                        "</tr>";
            }

            codLoteCabecera=res.getString("COD_LOTE_PRODUCCION")+" "+res.getString("COD_PROGRAMA_PROD");
            codRecetaCalorHUmedo=res.getInt("COD_RECETA_ESTERILIZACION_CALOR");
            producto="";
            cantlote=0d;
             nroLote="";
            area="";
            estado="";
            codLote=res.getString("COD_LOTE_PRODUCCION");
            contLote=0;
            codComprod="";
            codForma=res.getInt("COD_FORMA");
        }
        contLote++;
        if(administrador||codForma!=2)
        {
            for(int i=0;i<10;i++)
            {
                permisos[i]=true;
            }
        }
        else
        {
            permisos[0]=(res.getInt("permisoLimpieza")>0);
            permisos[1]=false;
            permisos[2]=(res.getInt("permisoLavado")>0);
            permisos[3]=(res.getInt("permisoDespirogenizado")>0);
            permisos[4]=(res.getInt("permisoPreparado")>0);
            permisos[5]=(res.getInt("permisoDosificado")>0);
            permisos[6]=(res.getInt("permisoControlLlenado")>0);
            permisos[7]=(res.getInt("permisoControlDosificado")>0);
            permisos[8]=(res.getInt("permisoRendimiento")>0);
            permisos[9]=(res.getInt("permisoEsterilizacion")>0);
       }
        /*for(int i=0;i<9;i++)
        {
            cabeceras[i]=(cabeceras[i]||permisos[i]);
        }*/
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
                innerHTML+="<tr>" +
                        "<td class='tableCell' style='width:30%'><span class='textHeaderClassBody'>"+producto+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+codLote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+cantlote+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreProgramaProd+"</span></td>" +
                        "<td class='tableCell' style='width:10%'><span class='textHeaderClassBody'>"+nombreAreaEmpresa+"</span></td>" +
                        (codAreaEmpresaUsuario.equals("40")?"":"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[0]?"<a onclick=\"registroOM(1,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/limpieza.gif' alt='Limpieza'></a>":"")+"<center></td>" +
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[1]&&administrador?"<a onclick=\"registroOM(2,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../reponse/img/repesada.jpg' alt='Repesada'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[2]?"<a onclick=\"registroOM(3,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[3]?"<a onclick=\"registroOM(4,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>")+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[4]?"<a onclick=\"registroOM(5,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"+
                        (codAreaEmpresaUsuario.equals("40")?"":"<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[5]?"<a onclick=\"registroOM(6,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[5]?"<a onclick=\"registroOM(7,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"+
                        "<td class='tableCell' style='width:10%;align-items:center;' ><center>"+(permisos[5]?"<a onclick=\"registroOM(8,"+codForma+","+codComprod+",'"+codLote+"',"+codAreaEmpresa+","+codProgramaProdLista+","+codPersonal+")\"><img src='../../img/dosificado.gif' alt='Dosificado'></a>":"")+"<center></td>"
                        )+
                        "</tr>";
            }
    innerHTML+="</table>";
    out.println("<table id='tablaLotesProcesar' cellpadding='0px' cellspacing='0px' style='width:100%'>"+
                " <tr><td class='tableHeaderClass' style='width:30%'><span class='textHeaderClass'>Producto</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Nro Lote</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Programa<br>Producción</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Area</span></td>"+
                (codAreaEmpresaUsuario.equals("40")?"":" <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Limpieza<br>Ambientes</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Repesada</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Preparado</span></td>"+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Granulado</span></td>")+
                " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Secado</span></td>"+
                (codAreaEmpresaUsuario.equals("40")?"":
                    " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Tamizado/<br></span></td>"+
                    " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Mezcla<br>Seco</span></td>"+
                    " <td class='tableHeaderClass' style='width:10%'><span class='textHeaderClass'>Tableteado</span></td>"
                    )+
                " </tr>");
    out.println(innerHTML);
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
