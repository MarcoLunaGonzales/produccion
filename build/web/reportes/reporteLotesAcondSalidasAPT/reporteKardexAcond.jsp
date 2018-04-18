<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "org.joda.time.DateTime"%> 
<%@ page import = "java.util.*"%> 
<%@ page import = "java.text.*"%> 
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 

<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
<html>
    <body>
        <form method="post" action="">   
            <%
            Connection con=null; 
            String codAlmancenAcondF=request.getParameter("almacen");
            String codLote=request.getParameter("codLote");
            
            SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
            %>
            <div align="center">                
                <table width="100%">
                    <tr>
                        <td colspan="3" align="center" >
                            <h4>Kardex de Movimiento Acondicionamiento</h4>
                        </td>
                    </tr>                    
                    <tr>
                        <td align="left" width="20%"><img src="../../img/logo_cofar.png"></td>
                        <td align="left" class="outputText2" width="50%" ><span style="font-weight:bold">Lote:</span><span class="outputText2"><%=(codLote)%></span>
                            <%
                            try{
                                int saldoCantidadUnitaria=0;
                                con=Util.openConnection(con);
                                ManagedAccesoSistema obj=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                                String codPersonal=obj.getUsuarioModuloBean().getCodUsuarioGlobal();
                                String sqlD="delete from kardex_item_movimiento_acondicionamiento where cod_personal="+codPersonal;
                                System.out.println("SQL_DDDDDDDDDDDD:"+sqlD);
                                Statement stD=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                int result=stD.executeUpdate(sqlD);
                                /*****************************************************/
                                /* INSERT DE LOS INGRESOS*/
                                /*****************************************************/
                                String sql_4="select ia.COD_INGRESO_ACOND,ia.fecha_ingresoacond,ida.CANT_TOTAL_INGRESO,ida.COD_LOTE_PRODUCCION";
                                sql_4+=" ,ia.NRO_INGRESOACOND,ia.NRO_DOC_INGRESOACOND,ia.COD_TIPOINGRESOACOND,ti.NOMBRE_TIPOINGRESOACOND";
                                sql_4+=" ,ia.OBS_INGRESOACOND from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND ida,TIPOS_INGRESOACOND ti";
                                sql_4+=" where ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND and ia.COD_TIPOINGRESOACOND = ti.COD_TIPOINGRESOACOND";
                                sql_4+=" and ia.COD_ESTADO_INGRESOACOND not in (1,2) and ida.COD_LOTE_PRODUCCION = '"+codLote+"' and ida.CANT_TOTAL_INGRESO<>0";
                                sql_4+=" and ia.COD_ALMACENACOND ="+codAlmancenAcondF+" ";
                                System.out.println("SQL_4444444444444444444444444:"+sql_4);
                                Statement st_4=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_4=st_4.executeQuery(sql_4);
                                String codIngresoAcond="";
                                java.util.Date fechaIngresoAcond;
                                String horaIngresoAcond="";
                                String fechaIngresoAcondAux="";
                                int cantidadTotalIngresoAcond=0;
                                String loteIngresoAcond="";
                                String nroIngresoAcond="";
                                String nroDocIngresoAcond="";
                                String codTipoIngresoAcond="";
                                String nombreTipoIngresoAcond="";
                                String obsIngresoAcond="";
                                while(rs_4.next()){
                                    codIngresoAcond=rs_4.getString("COD_INGRESO_ACOND");
                                    fechaIngresoAcond=rs_4.getDate("fecha_ingresoacond");
                                    horaIngresoAcond=rs_4.getTime("fecha_ingresoacond").toString();
                                    fechaIngresoAcondAux=f.format(fechaIngresoAcond)+" "+horaIngresoAcond;
                                    cantidadTotalIngresoAcond=rs_4.getInt("CANT_TOTAL_INGRESO");
                                    loteIngresoAcond=rs_4.getString("COD_LOTE_PRODUCCION");
                                    nroIngresoAcond=rs_4.getString("NRO_INGRESOACOND");
                                    nroDocIngresoAcond=rs_4.getString("NRO_DOC_INGRESOACOND");
                                    codTipoIngresoAcond=rs_4.getString("COD_TIPOINGRESOACOND");
                                    nombreTipoIngresoAcond=rs_4.getString("NOMBRE_TIPOINGRESOACOND");
                                    obsIngresoAcond=rs_4.getString("OBS_INGRESOACOND");
                                    System.out.println("fechaIngresoAcond:"+fechaIngresoAcond);
                                    String sql_4_1=" insert into kardex_item_movimiento_acondicionamiento(cod_personal,codigo,fecha,tipo_ingreso_salida";
                                    sql_4_1+=",nro_ingreso_salida,nro_doc_ingreso_salida,nro_lote,tipo_ingreso,obs_ingreso_salida,ingreso_unidades,salida_unidades)";
                                    sql_4_1+=" values("+codPersonal+","+codIngresoAcond+",'"+fechaIngresoAcondAux+"','Ingreso',"+nroIngresoAcond;
                                    sql_4_1+=","+nroDocIngresoAcond+",'"+loteIngresoAcond+"','"+nombreTipoIngresoAcond+"','"+obsIngresoAcond+"',"+cantidadTotalIngresoAcond+",0)";
                                    System.out.println("SQL_4_1111111111111111111111111111111111:"+sql_4_1);
                                    Statement st_4_1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    result=st_4_1.executeUpdate(sql_4_1);
                                }
                                /*****************************************************/
                                /* INSERT DE LAS SALIDAS*/
                                /*****************************************************/
                                String sql_5="select sa.COD_SALIDA_ACOND,sa.FECHA_SALIDAACOND,sda.CANT_TOTAL_SALIDADETALLEACOND";
                                sql_5+=",sda.COD_LOTE_PRODUCCION,sa.NRO_SALIDAACOND,sa.COD_TIPOSALIDAACOND,ts.NOMBRE_TIPOSALIDAACOND,sa.OBS_SALIDAACOND";
                                sql_5+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sda,TIPOS_SALIDAACOND ts";
                                sql_5+=" where sa.COD_SALIDA_ACOND = sda.COD_SALIDA_ACOND and sa.COD_TIPOSALIDAACOND = ts.COD_TIPOSALIDAACOND";
                                sql_5+=" and sa.COD_ESTADO_SALIDAACOND <> 2 and sda.COD_LOTE_PRODUCCION = '"+codLote+"'";
                                sql_5+=" and sa.COD_ALMACENACOND ="+codAlmancenAcondF+" ";
                                System.out.println("SQL_555555555555555555555555555:"+sql_5);
                                Statement st_5=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_5=st_5.executeQuery(sql_5);
                                while(rs_5.next()){
                                    codIngresoAcond=rs_5.getString("COD_SALIDA_ACOND");
                                    fechaIngresoAcond=rs_5.getDate("FECHA_SALIDAACOND");
                                    horaIngresoAcond=rs_5.getTime("FECHA_SALIDAACOND").toString();
                                    fechaIngresoAcondAux=f.format(fechaIngresoAcond)+" "+horaIngresoAcond;
                                    cantidadTotalIngresoAcond=rs_5.getInt("CANT_TOTAL_SALIDADETALLEACOND");
                                    loteIngresoAcond=rs_5.getString("COD_LOTE_PRODUCCION");
                                    nroIngresoAcond=rs_5.getString("NRO_SALIDAACOND");
                                    codTipoIngresoAcond=rs_5.getString("COD_TIPOSALIDAACOND");
                                    nombreTipoIngresoAcond=rs_5.getString("NOMBRE_TIPOSALIDAACOND");
                                    obsIngresoAcond=rs_5.getString("OBS_SALIDAACOND");
                                    String sql_5_1=" insert into kardex_item_movimiento_acondicionamiento(cod_personal,codigo,fecha,tipo_ingreso_salida";
                                    sql_5_1+=",nro_ingreso_salida,nro_doc_ingreso_salida,nro_lote,tipo_ingreso,obs_ingreso_salida,ingreso_unidades,salida_unidades)";
                                    sql_5_1+=" values("+codPersonal+","+codIngresoAcond+",'"+fechaIngresoAcondAux+"','Salida',"+nroIngresoAcond+",0";
                                    sql_5_1+=",'"+loteIngresoAcond+"','"+nombreTipoIngresoAcond+"','"+obsIngresoAcond+"',0,"+cantidadTotalIngresoAcond+")";
                                    System.out.println("SQL_5_1111111111111111111111111111111111:"+sql_5_1);
                                    Statement st_5_1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    result=st_5_1.executeUpdate(sql_5_1);
                                }
                                String sql_2="select ISNULL(sum(ida.CANT_TOTAL_INGRESO),0) from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND ida,COMPONENTES_PROD cp";
                                sql_2+=" where ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND and ida.COD_COMPPROD = cp.COD_COMPPROD";
                                sql_2+=" and ida.COD_LOTE_PRODUCCION='"+codLote+"' ";
                                sql_2+=" and ia.COD_ESTADO_INGRESOACOND not in (1,2) and ia.COD_ALMACENACOND="+codAlmancenAcondF;
                                System.out.println("SQL IIIIIIIIIINGRESOS:"+sql_2);
                                Statement st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_2=st_2.executeQuery(sql_2);
                                while(rs_2.next()){
                                    int ingresosUnitarios=rs_2.getInt(1);
                                    System.out.println("ingresosUnitariossssssssssssssssssss:"+ingresosUnitarios);
                                    String sql_3="select ISNULL(sum(sda.CANT_TOTAL_SALIDADETALLEACOND),0) from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sda,COMPONENTES_PROD cp";
                                    sql_3+=" where sa.COD_SALIDA_ACOND = sda.COD_SALIDA_ACOND and cp.COD_COMPPROD = sda.COD_COMPPROD";
                                    sql_3+=" and sda.COD_LOTE_PRODUCCION='"+codLote+"' ";
                                    sql_3+=" and sa.COD_ESTADO_SALIDAACOND <> 2 and sa.COD_ALMACENACOND = "+codAlmancenAcondF;
                                    System.out.println("SQL SSSSSSSSSSSALIDAS:"+sql_3);
                                    Statement st_3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet rs_3=st_3.executeQuery(sql_3);
                                    if(rs_3.next()){
                                        int salidasUnitarios=rs_3.getInt(1);
                                        System.out.println("salidasUnitariossssssssssssssssss:"+salidasUnitarios);
                                        saldoCantidadUnitaria=ingresosUnitarios-salidasUnitarios;
                                        System.out.println("saldoCantidadUnitariaaaaaaaaaaaaaaaaaaa:"+saldoCantidadUnitaria);
                                    }
                                }
                                                     
                            %>                            
                                                   
                        </td>
                        <td width="30%">                
                            <table border="0" class="outputText2" width="100%" >
                                <tr>
                                    
                                </tr>
                                <tr>
                                    <%
                                    String nombreAlmacenAcond="";
                                    try{
                                        
                                        String sql_aux1=" select COD_ALMACENACOND,NOMBRE_ALMACENACOND from ALMACENES_ACOND where COD_ALMACENACOND="+codAlmancenAcondF;
                                        Statement st_aux1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs_aux1 = st_aux1.executeQuery(sql_aux1);
                                        while (rs_aux1.next()){
                                            nombreAlmacenAcond=rs_aux1.getString("NOMBRE_ALMACENACOND");
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    } 
                                    %>                                        
                                    <td colspan="2" align="right"><h5><%=nombreAlmacenAcond%></h5></td>                                    
                                </tr>
                            </table>    
                        </td>                        
                    </tr>
                    <tr>
                        <td colspan="3">
                            <table class="tablaFiltroReporte"  width="100%">
                                <tr  class="tituloCampo"> 
                                    <td class="bordeNegroTdMod"><b>Fecha</b></td>
                                    <td class="bordeNegroTdMod"><b>Hora</b></td>
                                    <td class="bordeNegroTdMod"><b>Tipo</b></td>
                                    <td class="bordeNegroTdMod"><b>Nº Ing./Sal.</b></td>
                                    <td class="bordeNegroTdMod"><b>Nº Documento</b></td>
                                    <td class="bordeNegroTdMod"><b>Nº Lote</b></td>
                                    <td class="bordeNegroTdMod"><b>Motivo</b></td>
                                    <td class="bordeNegroTdMod"><b>Observaciones</b></td>
                                    <td class="bordeNegroTdMod"><b>Entrada Unidades</b></td>
                                    <td class="bordeNegroTdMod"><b>Salida Unidades</b></td>
                                    <td class="bordeNegroTdMod"><b>Saldo Unidades</b></td>
                                </tr>
                                <%                     
                                saldoCantidadUnitaria=0;
                                String sql_6="select cod_personal,codigo,fecha,tipo_ingreso_salida,nro_ingreso_salida";
                                sql_6+=",nro_doc_ingreso_salida,nro_lote,tipo_ingreso,obs_ingreso_salida,ingreso_unidades,salida_unidades";
                                sql_6+=" from kardex_item_movimiento_acondicionamiento where cod_personal ="+codPersonal+" order by fecha asc";
                                System.out.println("SQL_66666666666666666666:"+sql_6);
                                Statement st_6=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_6=st_6.executeQuery(sql_6);
                                int ingresoTotalUnidades=0;
                                int salidaTotalUnidades=0;
                                while(rs_6.next()){
                                    rs_6.getString(1);
                                    rs_6.getString(2);
                                    String fechaK=rs_6.getString(3);
                                    String fechaAux[]=fechaK.split(" ");
                                    String fechaAux1[]=fechaAux[0].split("-");
                                    String tipoIngresoSalidaK=rs_6.getString(4);
                                    String nroIngresoSalidaK=rs_6.getString(5);
                                    String nroDocIngresoSalidaK=rs_6.getString(6);
                                    String nroLoteK=rs_6.getString(7);
                                    String tipoK=rs_6.getString(8);
                                    String obsIngresoSalida=rs_6.getString(9);
                                    int ingresoUnidades=rs_6.getInt(10);
                                    int salidaUnidades=rs_6.getInt(11);
                                    ingresoTotalUnidades=ingresoTotalUnidades+ingresoUnidades;
                                    salidaTotalUnidades=salidaTotalUnidades+salidaUnidades;
                                    saldoCantidadUnitaria=(saldoCantidadUnitaria+ingresoUnidades)-salidaUnidades;
                                %>
                                <tr>
                                    <td class="bordeNegroTdMod"><%=fechaAux1[2]+"/"+fechaAux1[1]+"/"+fechaAux1[0]%></td>
                                    <td class="bordeNegroTdMod"><%=fechaAux[1]%></td>
                                    <td class="bordeNegroTdMod"><%=tipoIngresoSalidaK%></td>
                                    <td class="bordeNegroTdMod" align="right"><%=nroIngresoSalidaK%></td>
                                    <td class="bordeNegroTdMod" align="right"><%=nroDocIngresoSalidaK%></td>
                                    <td class="bordeNegroTdMod"><%=nroLoteK%></td>
                                    <td class="bordeNegroTdMod"><%=tipoK%></td>
                                    <td class="bordeNegroTdMod"><%=obsIngresoSalida%>&nbsp;</td>
                                    <td class="bordeNegroTdMod" align="right" ><%=ingresoUnidades%></td>
                                    <td class="bordeNegroTdMod" align="right"><%=salidaUnidades%></td>
                                    <td class="bordeNegroTdMod" align="right"><%=saldoCantidadUnitaria%></td>
                                </tr>
                                <%
                                }
                                %>
                                <tr>                                    
                                    <td class="bordeNegroTdMod" colspan="8" align="right" ><b>Total</b>&nbsp;&nbsp;</td>
                                    <td class="bordeNegroTdMod" align="right"><b><%=ingresoTotalUnidades%></b></td>
                                    <td class="bordeNegroTdMod" align="right"><b><%=salidaTotalUnidades%></b></td>
                                    <td class="bordeNegroTdMod" align="right"><b><%=saldoCantidadUnitaria%></b></td>
                                </tr>
                                <%
                                } catch(Exception e) {
                                    e.printStackTrace();
                                }
                                %>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>
    </body>
</html>