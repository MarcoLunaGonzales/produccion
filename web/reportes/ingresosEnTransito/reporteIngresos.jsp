<%@ page import="com.cofar.util.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.*"%> 
<%@ page import = "java.util.*"%> 


<%
String fecha1=request.getParameter("fecha1");
String fecha2=request.getParameter("fecha2");


String values1[]=fecha1.split("/");
String values2[]=fecha2.split("/");

String fechaSQL1=values1[2]+"-"+values1[1]+"-"+values1[0];
String fechaSQL2=values2[2]+"-"+values2[1]+"-"+values2[0];



%>
<html>
    <title>
        Reporte De Rendimiento
    </title>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        
    </head>
    
    <body>
        <div align="center">
            <table width="100%">
                <tr>
                    <td colspan="3" align="center" >
                        <h4>Reporte De Rendimiento</h4>
                    </td>
                </tr>                    
                <tr>
                    <td align="left" width="20%"><img src="../../img/logo_cofar.png"></td>
                    <td align="left" class="outputText2" width="50%" >
                    
                    <td width="30%">                
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td colspan="2" align="right"><b>Fecha Inicio&nbsp;::&nbsp;</b><%=fecha1%><br><b>Fecha &nbsp;Final&nbsp;::&nbsp;</b><%=fecha2%></td>
                            </tr>
                            
                        </table>    
                    </td>        
                    
                </tr>
                
            </table>
        </div>
        
        
        
        <table class="tablaFiltroReporte" width="100%" align="center">
            
            
            <tr  class="tituloCampo">
                <td class="bordeNegroTdMod"><b>N</b></td>
                <td class="bordeNegroTdMod"><b>Producto<br/>Semiterminado</b></td>
                <td class="bordeNegroTdMod"><b>Lote</b></td>
                <td class="bordeNegroTdMod"><b>Cantidad Lote</b></td>
                <td class="bordeNegroTdMod"><b>Ingreso Acond.</b></td>
                <td class="bordeNegroTdMod"><b>%</b></td>
                
                <td class="bordeNegroTdMod"><b>Salida Acond. MC</b></td>
                <td class="bordeNegroTdMod" ><b>Ingreso APT. MC</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                
                <td class="bordeNegroTdMod"><b>Salida Acond. MM</b></td>
                <td class="bordeNegroTdMod" ><b>Ingreso APT. MM</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                
                <td class="bordeNegroTdMod" ><b>Salida FRV</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                <td class="bordeNegroTdMod" ><b>Salida<br/> Reacond.</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                <td class="bordeNegroTdMod" ><b>Salida<br/> Estabilidad</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                <td class="bordeNegroTdMod" ><b>Salida<br/> CC Quintanilla</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                
                <td class="bordeNegroTdMod" ><b>Salida<br/> Saldos</b></td>
                <td class="bordeNegroTdMod" ><b>%</b></td>
                
                <td class="bordeNegroTdMod" ><b>Rendimiento<br/>Total</b></td>
                
                <td class="bordeNegroTdMod" ><b>Lote<br/>Cerrado</b></td>
                
                
            </tr>
            
            <%
            Connection con=null;
            
            try{
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###.00");
                
                
                
                con=Util.openConnection(con);
                
                
                int fila=1;
                
                
                java.text.SimpleDateFormat format=new java.text.SimpleDateFormat("dd/MM/yyyy");
                
                
                //sacamos los lotes que ingresaron en el rango de fechas.
                String sqlLote="select DISTINCT(sd.COD_LOTE_PRODUCCION)"+
				" from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
				" where sa.FECHA_SALIDAACOND BETWEEN '"+fechaSQL1+" 00:00' and  '"+fechaSQL2+" 23:59' and  sa.COD_ESTADO_SALIDAACOND<>2";
	/*"select distinct(id.COD_LOTE_PRODUCCION) from INGRESOS_VENTAS i,  " +
                        " INGRESOS_DETALLEVENTAS id, PRESENTACIONES_PRODUCTO p where i.COD_INGRESOVENTAS=id.COD_INGRESOVENTAS and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA  " +
                        " and i.FECHA_INGRESOVENTAS BETWEEN '"+fechaSQL1+" 00:00:00' and '"+fechaSQL2+" 23:59:59' and i.COD_AREA_EMPRESA=1 and  " +
                        " i.COD_ALMACEN_VENTA in (54,56,57) and i.COD_ESTADO_INGRESOVENTAS not in (2)";*/
                Statement stLote=con.createStatement();
                ResultSet rsLote=stLote.executeQuery(sqlLote);
                
                System.out.println("SQL LOTE INGRESOS APT: "+sqlLote);
                
                String lotesBuscados="";
                while(rsLote.next()){
                    String codLote=rsLote.getString(1);
                    lotesBuscados+=(lotesBuscados.equals("")?"":",")+"'"+codLote+"'";
                }
                
                
            /*
             */
                lotesBuscados = "'8051154'";
                System.out.println("lotes buscados: "+lotesBuscados);
                //lotesBuscados="'9081453'";
                
                String sql="  select  (select cc.nombre_prod_semiterminado from COMPONENTES_PROD cc where cc.COD_COMPPROD=iad.COD_COMPPROD),iad.COD_LOTE_PRODUCCION, ";
                sql+=" sum(iad.CANT_TOTAL_INGRESO),iad.COD_COMPPROD from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND iad where iad.COD_INGRESO_ACOND=ia.COD_INGRESO_ACOND ";
                sql+=" and ia.COD_ESTADO_INGRESOACOND not in (1,2) and iad.COD_COMPPROD in(select  c.COD_COMPPROD  ";
                sql+=" from COMPONENTES_PRESPROD   c where c.COD_PRESENTACION in( ";
                sql+=" select  id.COD_PRESENTACION from INGRESOS_VENTAS i ,INGRESOS_DETALLEVENTAS id where  ";
                sql+=" id.COD_INGRESOVENTAS=i.COD_INGRESOVENTAS and i.COD_AREA_EMPRESA=1 ";
                sql+=" and id.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in(54,56) and i.FECHA_INGRESOVENTAS <= '"+fechaSQL2+" 23:59:59' ";
                sql+=" and i.COD_ESTADO_INGRESOVENTAS<>2 and id.COD_LOTE_PRODUCCION in ("+lotesBuscados+")";
                sql+=" ) ) group by iad.COD_COMPPROD,iad.COD_LOTE_PRODUCCION ";
                
                
                //sacamos todas las salidas dirigidas a los almacenes de cuarentena
                /*sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND),cod_presentacion, (select top 1 f.CANTIDAD_LOTE from PROGRAMA_PRODUCCION p,FORMULA_MAESTRA f where p.COD_COMPPROD=sad.COD_COMPPROD and p.COD_LOTE_PRODUCCION=sad.COD_LOTE_PRODUCCION and p.COD_ESTADO_PROGRAMA=6 and f.COD_COMPPROD=p.COD_COMPPROD and f.COD_FORMULA_MAESTRA=p.COD_FORMULA_MAESTRA) as cantidad_lote ";
                sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and sad.COD_SALIDA_ACOND in( ";
                sql+=" select  DISTINCT i.COD_SALIDA_ACOND from INGRESOS_VENTAS i,INGRESOS_DETALLEVENTAS id where id.COD_INGRESOVENTAS=i.COD_INGRESOVENTAS ";
                sql+=" and i.COD_AREA_EMPRESA=1 and id.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in(54,56) ";
                sql+=" and i.FECHA_INGRESOVENTAS <= '"+fechaSQL2+" 23:59:59' and id.COD_LOTE_PRODUCCION in ("+lotesBuscados+") ";
                sql+=" and i.COD_ESTADO_INGRESOVENTAS<>2 ) and sa.COD_ESTADO_SALIDAACOND<>2 group by COD_COMPPROD,COD_LOTE_PRODUCCION,cod_presentacion ";*/
                
                
                sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND), " +
                //"(select top 1 f.CANTIDAD_LOTE from FORMULA_MAESTRA f where f.COD_COMPPROD=sad.COD_COMPPROD and estado_sistema=1 and cod_estado_registro=1) as cantidad_lote ";
		             "(select sum(pp.CANT_LOTE_PRODUCCION) from PROGRAMA_PRODUCCION pp where pp.COD_LOTE_PRODUCCION=sad.COD_LOTE_PRODUCCION and pp.COD_COMPPROD= sad.COD_COMPPROD) as cantidad_lote";
                sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND ";
					/*"and sad.COD_SALIDA_ACOND in( ";
                sql+=" select  DISTINCT i.COD_SALIDA_ACOND from INGRESOS_VENTAS i,INGRESOS_DETALLEVENTAS id where id.COD_INGRESOVENTAS=i.COD_INGRESOVENTAS ";
                sql+=" and i.COD_AREA_EMPRESA=1 and id.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in(54,56) ";
                sql+=" and i.FECHA_INGRESOVENTAS <= '"+fechaSQL2+" 23:59:59' and id.COD_LOTE_PRODUCCION in ("+lotesBuscados+") ";
                sql+=" and i.COD_ESTADO_INGRESOVENTAS<>2 )*/
				sql+="	and sad.COD_LOTE_PRODUCCION in ("+lotesBuscados+") and sa.COD_ESTADO_SALIDAACOND<>2 group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                
                
                System.out.println("SQL ING 2: "+sql);
                
                Statement stPremios=con.createStatement();
                ResultSet rsPremios=stPremios.executeQuery(sql);
                
                //rsPremios.gets
                
                while(rsPremios.next()){
                    
                    int codigoSemi=rsPremios.getInt(2);
                    String lote=rsPremios.getString(3);
                    int cantidadSalida=rsPremios.getInt(4);
                    //int codPresentacion=rsPremios.getInt(5);
                    
                    int cantidadLote=rsPremios.getInt(5);
                    
                    
                    
                    
                    sql=" select sum(iad.CANT_TOTAL_INGRESO) ";
                    sql+=" from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND iad where  ";
                    sql+=" iad.COD_INGRESO_ACOND=ia.COD_INGRESO_ACOND and ia.COD_ESTADO_INGRESOACOND not in (1,2) ";
                    sql+=" and iad.COD_COMPPROD="+codigoSemi+" and iad.COD_LOTE_PRODUCCION='"+lote+"' and ia.COD_TIPOINGRESOACOND in (1)";
                    
                    System.out.println("SQL INGRESOS: "+sql);
                    int cantidadIngreso=0;
                    
                    PreparedStatement stSalidas=con.prepareStatement(sql);
                    ResultSet rsSalidas=stSalidas.executeQuery();
                    if(rsSalidas.next()){
                        cantidadIngreso=rsSalidas.getInt(1);
                    }
                    rsSalidas.close();
                    stSalidas.close();
                    
                    
                    
                    
                    sql=" select sum((p.cantidad_presentacion * id.CANTIDAD) + id.CANTIDAD_UNITARIA) ";
                    sql+=" from INGRESOS_VENTAS i,   INGRESOS_DETALLEVENTAS id,     PRESENTACIONES_PRODUCTO p ";
                    sql+=" where id.COD_INGRESOVENTAS = i.COD_INGRESOVENTAS and ";
                    sql+=" id.COD_PRESENTACION = p.cod_presentacion and  i.COD_AREA_EMPRESA = 1 and ";
                    sql+=" id.COD_AREA_EMPRESA = 1 and i.COD_ALMACEN_VENTA in (54, 56) and ";
                    sql+=" i.FECHA_INGRESOVENTAS <= '"+fechaSQL2+" 23:59:59'";
                    sql+=" and   i.COD_ESTADO_INGRESOVENTAS not in  (2)  and id.COD_LOTE_PRODUCCION='"+lote+"' ";
                    //sql+=" and id.COD_PRESENTACION="+codPresentacion;
                    sql+=" group by id.COD_LOTE_PRODUCCION ";
                    System.out.println(sql);
                    
                    PreparedStatement stApt=con.prepareStatement(sql);
                    ResultSet rsApt=stApt.executeQuery();
                    
                    int cantidadUnitariatotal=0;
                    if(rsApt.next()){
                        
                        
                        cantidadUnitariatotal=rsApt.getInt(1);
                    }
                    
                    
                    rsApt.close();
                    stApt.close();
                    
                    //muestras medicas
                    int cantidadIngresoMM=0;
                    
                    String sqlMM=" select sum(sad.CANT_TOTAL_SALIDADETALLEACOND),  " +
                            " (select sum((id.CANTIDAD*p.cantidad_presentacion)+id.CANTIDAD_UNITARIA)  from INGRESOS_VENTAS i, INGRESOS_DETALLEVENTAS id, " +
                            " PRESENTACIONES_PRODUCTO p where id.COD_INGRESOVENTAS = i.COD_INGRESOVENTAS and " +
                            " i.COD_AREA_EMPRESA = 1 and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA and id.COD_PRESENTACION=p.cod_presentacion " +
                            " and id.COD_AREA_EMPRESA = 1 and i.COD_ALMACEN_VENTA in (57) and i.FECHA_INGRESOVENTAS <= '"+fechaSQL2+"' and " +
                            " id.COD_LOTE_PRODUCCION in ('"+lote+"') and i.COD_ESTADO_INGRESOVENTAS <> 2)as cantidadAPT ";
                    sqlMM+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and sad.COD_SALIDA_ACOND in( ";
                    sqlMM+=" select  DISTINCT i.COD_SALIDA_ACOND from INGRESOS_VENTAS i,INGRESOS_DETALLEVENTAS id where id.COD_INGRESOVENTAS=i.COD_INGRESOVENTAS ";
                    sqlMM+=" and i.COD_AREA_EMPRESA=1 and id.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in(57) ";
                    sqlMM+=" and i.FECHA_INGRESOVENTAS <= '"+fechaSQL2+" 23:59:59' and id.COD_LOTE_PRODUCCION='"+lote+"' ";
                    sqlMM+=" and i.COD_ESTADO_INGRESOVENTAS<>2 ) and sa.COD_ESTADO_SALIDAACOND<>2 group by COD_COMPPROD,COD_LOTE_PRODUCCION,cod_presentacion ";
                   
                    System.out.println("INGRESOS APT MM:::::"+sqlMM);
                    
                    Statement stMM=con.createStatement();
                    ResultSet rsMM=stMM.executeQuery(sqlMM);
                    int cantidadMM=0;
                    if(rsMM.next()){
                        cantidadMM=rsMM.getInt(1);
                        cantidadIngresoMM=rsMM.getInt(2);
                    }
                    System.out.println("sql MM: "+sqlMM);
                    
                    //finm muestras medicas
                    
                    
                    
                    int cantidadSalida1=0;
                    int cantidadSalida2=0;
                    int cantidadSalida3=0;
                    int cantidadSalida4=0;
                    int cantSaldos=0;
                    
                    double porcentaje1=0.0d;
                    double porcentajeMM=0.0d;
                    double porcentaje2=0.0d;
                    double porcentaje3=0.0d;
                    double porcentaje4=0.0d;
                    double porcentaje5=0.0d;
                    double porcentaje6=0.0d;
                    double porcentaje7=0.0d;
                    double porcentajeSaldos=0.0d;
                    
                    
                    //FRV
                    sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                    sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) ";
                    sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and ";
                    sql+=" sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(2) and  COD_LOTE_PRODUCCION='"+lote+"' and COD_COMPPROD="+codigoSemi+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                    stApt=con.prepareStatement(sql);
                    rsApt=stApt.executeQuery();
                    if(rsApt.next()){
                        cantidadSalida1=rsApt.getInt(4);
                    }
                    
                    System.out.println("FRV "+sql);
                    
                    rsApt.close();
                    stApt.close();
                    
                    //REACONDICIONAMIENTO
                    sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                    sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) ";
                    sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and ";
                    sql+=" sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(5) and  COD_LOTE_PRODUCCION='"+lote+"' and COD_COMPPROD="+codigoSemi+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                    stApt=con.prepareStatement(sql);
                    rsApt=stApt.executeQuery();
                    if(rsApt.next()){
                        cantidadSalida2=rsApt.getInt(4);
                    }
                    System.out.println("REACOND "+sql);
                    rsApt.close();
                    stApt.close();
                    //ESTABILIDAD
                    
                    sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                    sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) ";
                    sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and ";
                    sql+=" sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(6) and  COD_LOTE_PRODUCCION='"+lote+"' and COD_COMPPROD="+codigoSemi+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                    stApt=con.prepareStatement(sql);
                    rsApt=stApt.executeQuery();
                    if(rsApt.next()){
                        cantidadSalida3=rsApt.getInt(4);
                    }
                    System.out.println("ESTABILIDAD "+sql);
                    rsApt.close();
                    stApt.close();
                    
                    
                    //CONTROL DE CALIDAD
                    sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                    sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) ";
                    sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and ";
                    sql+=" sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACEN_VENTA in (29) and  COD_LOTE_PRODUCCION='"+lote+"' and COD_COMPPROD="+codigoSemi+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                    stApt=con.prepareStatement(sql);
                    rsApt=stApt.executeQuery();
                    if(rsApt.next()){
                        cantidadSalida4=rsApt.getInt(4);
                    }
                    System.out.println("control de calidad "+sql);
                    rsApt.close();
                    stApt.close();
                    
                    //saldos
                    sql=" select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), ";
                    sql+=" sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) ";
                    sql+=" from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and ";
                    sql+=" sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(4) and  COD_LOTE_PRODUCCION='"+lote+"' and COD_COMPPROD="+codigoSemi+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                    stApt=con.prepareStatement(sql);
                    rsApt=stApt.executeQuery();
                    if(rsApt.next()){
                        cantSaldos=rsApt.getInt(4);
                    }
                    System.out.println("SALDOS: "+sql);
                    rsApt.close();
                    stApt.close();
                    
                    
                    //C.C
                    sql="  select  count(*),'IN' from INGRESOS_ACOND i,INGRESOS_DETALLEACOND id where id.COD_INGRESO_ACOND=i.COD_INGRESO_ACOND ";
                    sql+="   and i.COD_TIPOINGRESOACOND=5 and id.COD_LOTE_PRODUCCION='"+lote+"' and id.COD_COMPPROD="+codigoSemi;
                    sql+=" UNION ";
                    sql+="   select count(*),'SA' from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad  where  ";
                    
                    sql+=" sad.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND and sa.COD_TIPOSALIDAACOND=6 and COD_LOTE_PRODUCCION='"+lote+"' and  sad.COD_COMPPROD="+codigoSemi;
                    
                    
                    System.out.println("SALIDAS CIERRE: "+sql);
                    
                    
                    stApt=con.prepareStatement(sql);
                    rsApt=stApt.executeQuery();
                    int cantidadCerradoSalida=0;
                    int cantidadCerradoIngreso=0;
                    
                    while(rsApt.next()){
                        
                        if(rsApt.getString(2).equals("IN")){
                            cantidadCerradoIngreso=rsApt.getInt(1);
                        }
                        
                        if(rsApt.getString(2).equals("SA")){
                            cantidadCerradoSalida=rsApt.getInt(1);
                        }
                    }
                    
                    rsApt.close();
                    stApt.close();
                    
                    
                    
                    
                    
                    if(cantidadIngreso>0){
                        porcentaje1=(double)cantidadUnitariatotal/(double)cantidadLote;
                        porcentajeMM=(double)cantidadIngresoMM/(double)cantidadLote;
                        porcentaje2=(double)cantidadSalida1/(double)cantidadIngreso;
                        porcentaje3=(double)cantidadSalida2/(double)cantidadIngreso;
                        porcentaje4=(double)cantidadSalida3/(double)cantidadIngreso;
                        porcentaje5=(double)cantidadSalida4/(double)cantidadIngreso;
                        porcentajeSaldos=(double)cantSaldos/(double)cantidadIngreso;
                        
                        porcentaje1=porcentaje1*100.0d;
                        porcentajeMM=porcentajeMM*100.0d;
                        porcentaje2=porcentaje2*100.0d;
                        porcentaje3=porcentaje3*100.0d;
                        porcentaje4=porcentaje4*100.0d;
                        porcentaje5=porcentaje5*100.0d;
                        porcentajeSaldos=porcentajeSaldos*100.0d;
                        
                    }
                    double cantidadTotalRendimiento=0d;
                    if(cantidadLote>0.0d){
                        System.out.println("cant unit : " + cantidadUnitariatotal +"cantidad MM  "+ cantidadMM+"cantidad  3 "+cantidadSalida3 + " cantidad Sa 4  " + cantidadSalida4 + "  cantSaldos  "  + cantSaldos +" / " + cantidadLote );
                        cantidadTotalRendimiento=cantidadUnitariatotal+cantidadMM+cantidadSalida3+cantidadSalida4+cantSaldos;
                        porcentaje6=(double)cantidadTotalRendimiento/(double)cantidadLote;
                        porcentaje6=porcentaje6*100.0d;
                    }
                    
                    
                    
                    String loteCerrado=(cantidadCerradoIngreso>0)?"SI":"NO";
                    
                    if(loteCerrado.equals("NO")){
                        loteCerrado=(cantidadCerradoSalida>0)?"SI":"NO";
                    }
                    
                    if(loteCerrado.equals("NO")){
                        String sqlVeriLoteCerrado="select i.COD_INGRESO_ACOND from INGRESOS_DETALLEACOND id, INGRESOS_ACOND i where " +
                                " i.COD_INGRESO_ACOND=id.COD_INGRESO_ACOND and i.COD_ESTADO_INGRESOACOND not in (1,2) and " +
                                " id.COD_LOTE_PRODUCCION='"+lote+"' and id.loteCerrado=1";
                        System.out.println("sql veri lote "+sqlVeriLoteCerrado);
                        Statement stVeriLote=con.createStatement();
                        ResultSet rsVeriLote=stVeriLote.executeQuery(sqlVeriLoteCerrado);
                        if(rsVeriLote.next()){
                            loteCerrado="SI";
                        }
                    }
                    
                    
                    
                    if(cantidadLote>0)
                        porcentaje7=((double)cantidadIngreso/(double)cantidadLote)*100.0d;;
            
            
            %>
            <tr>
                
                <td class="bordeNegroTdMod"><b><%=fila%></b></td>
                <td class="bordeNegroTdMod"><%=rsPremios.getString(1)%></td>
                <td class="bordeNegroTdMod"><%=lote%></td>
                <td class="bordeNegroTdMod"><%=cantidadLote%></td>
                
                <td class="bordeNegroTdMod"><%=cantidadIngreso%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentaje7)%></td>
                
                <td class="bordeNegroTdMod"><%=cantidadSalida%></td>
                <td class="bordeNegroTdMod"><%=cantidadUnitariatotal%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentaje1)%></td>
                
                <td class="bordeNegroTdMod"><%=cantidadMM%></td>
                <td class="bordeNegroTdMod"><%=cantidadIngresoMM%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentajeMM)%></td>
                
                
                <td class="bordeNegroTdMod"><%=cantidadSalida1%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentaje2)%></td>
                
                
                <td class="bordeNegroTdMod"><%=cantidadSalida2%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentaje3)%></td>
                
                
                <td class="bordeNegroTdMod"><%=cantidadSalida3%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentaje4)%></td>
                
                <td class="bordeNegroTdMod"><%=cantidadSalida4%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentaje5)%></td>
                
                <td class="bordeNegroTdMod"><%=cantSaldos%></td>
                <td class="bordeNegroTdMod"><%=form.format(porcentajeSaldos)%></td>
                
                <td class="bordeNegroTdMod"><%=form.format(porcentaje6)%></td>
                
                <td class="bordeNegroTdMod"><%=loteCerrado%></td>
                
                <% fila++;%>
            </tr>
            <%}
            
            //}%>
            <%
            
            
            
            }catch(SQLException ex){
                ex.printStackTrace();
                
            } finally {
                con.close();
                
            }
            
            %>
            
            
            
            
        </table>
        
        
    </body>
</html>


