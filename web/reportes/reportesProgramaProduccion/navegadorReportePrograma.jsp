<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 

<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%! Connection con=null;


%>
<%! public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";

try{
con=Util.openConnection(con);
String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
System.out.println("PresentacionesProducto:sql:"+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
String codigo=rs.getString(1);
nombreproducto=rs.getString(2);
}
} catch (SQLException e) {
e.printStackTrace();
    }
    return "";
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <h3 align="center">Reporte Programa de Producción</h3>
        <br>
        <form>
            <table align="center" width="90%">
                
                <%
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                String codPresentacion="";
                String nombrePresentacion="";
                String linea_mkt="";
                String agenciaVenta="";
                float cantidadTotal=0f;
                float cantidadTotalUnitaria=0f;
                double procesoMC=0;
                double cantLote=0;
                double cantidadProduccion=0.0d;
                
                try{
                    String fechaInicio="";
                    String lote="";
                    String codAreaEmpresa="";
                    String pilar="";
                    String aux="";
                    String vistaActivos="";
                    con=Util.openConnection(con);
                    String almacenQuintanilla="";
                    String almacenCuarentena="";
                    String almacenAcond="";
                    String tipoMercaderia=request.getParameter("tipo_mercaderia");
                    if(tipoMercaderia.equals("0")){
                        almacenQuintanilla="27";
                        almacenCuarentena="54";
                        almacenAcond="1";
                    }else{
                        almacenQuintanilla="32";
                        almacenCuarentena="57";
                        almacenAcond="3";
                    }
                    
                    String trimestral=request.getParameter("trimestral");
                    
                    aux=request.getParameter("codAreaEmpresa");
                    float saldoCantidad=0;
                    float saldoCantidadUnitaria=0;
                    float saldoCantidadCuar=0;
                    float saldoCantidadUnitariaCuare=0;
                    
                    if(aux!=null){
                        try{
                            
                            if(aux.equals("0")){
                                aux="80,81,82,95";
                            }
                            
                            
                            String sql_aux="select f.COD_AREA_FABRICACION,ae.NOMBRE_AREA_EMPRESA from AREAS_FABRICACION f,AREAS_EMPRESA ae" ;
                            sql_aux+=" where ae.COD_AREA_EMPRESA=f.COD_AREA_FABRICACION and ae.COD_AREA_EMPRESA in ("+aux+")" ;
                            System.out.println("almacen:"+sql_aux);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs=st.executeQuery(sql_aux);
                            agenciaVenta="";
                            while (rs.next()){
                                
                                agenciaVenta=agenciaVenta+","+rs.getString(2);
                                System.out.println("agenciaVenta:"+agenciaVenta);
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                        codAreaEmpresa=aux;
                    }
                    if(codAreaEmpresa.equals("0")){
                        codAreaEmpresa="80,81,82,95";
                    }
                    aux=request.getParameter("fecha_inicio");
                    System.out.println("aux:"+aux);
                    if(aux!=null){
                        System.out.println("entro");
                        fechaInicio=aux;
                    }
                
                %> 
                <tr>
                    <td align="left" class="outputText2" width="25%" >   
                    <td colspan="3" align="center" >
                        Area de Fabricación : <%=agenciaVenta%>
                    </td>
                    <td align="left" class="outputText2" width="25%" >   
                </tr>
                <tr>
                    <td align="left" width="25%"><img src="../img/cofar.png"></td>
                    <td align="left" class="outputText2" width="50%" >                        
                        
                    </td>
                    <td width="25%">                
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td align="right"><b>A Fecha&nbsp;::&nbsp;</b><%=fechaInicio%>
                            </tr>
                        </table>    
                    </td>                        
                </tr>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="90%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                
                
                <%
                String array[]=fechaInicio.split("/");
                System.out.println("fechaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa:"+array[0]+" "+array[1]+" "+array[2]);
                fechaInicio=array[2]+"/"+array[1]+"/"+array[0];
                String sql="";
                int ingresos=0,salidas=0;
                int ingresos_unitarios=0,salidas_unitarios=0;
                
                
                %>
                <tr class="tablaFiltroReporte">
                    <td align="center" class="bordeNegroTd" colspan="4"><b>&nbsp;</b></td>
                    
                    <%
                    try{
                        
                        String sqlNombreAlmacen="select nombre_almacen_venta from almacenes_ventas " +
                                "where cod_estado_registro=1 and cod_almacen_venta=27" ;
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs=st.executeQuery(sqlNombreAlmacen);
                        while (rs.next()){
                            agenciaVenta="";
                            agenciaVenta=rs.getString(1);
                    %>
                    <td align="center" class="bordeNegroTd" colspan="1"><b><%=agenciaVenta%></b></td>
                    <%
                        }
                        
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    %>
                    <td align="center" class="bordeNegroTd" >&nbsp;</td>
                    <td align="center" class="bordeNegroTd" colspan="3">PROCESO&nbsp;</td>
                    <td align="center" class="bordeNegroTd" colspan="3">&nbsp;</td>
                    <td align="center" class="bordeNegroTd" colspan="4">PROGRAMACIÓN&nbsp;</td>
                    <td align="center" class="bordeNegroTd" colspan="2">&nbsp;</td>
                    
                </tr>
                <tr class="tablaFiltroReporte">
                    <td align="center" class="bordeNegroTd"><b>Código Anterior</b></td>
                    <td align="center" class="bordeNegroTd"><b>Cant.Presentación</b></td>
                    <td align="center" class="bordeNegroTd"><b>Presentación</b></td>
                    <td align="center" class="bordeNegroTd"><b>Tamaño de Lote</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>Unidades STOCK</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Stock Reposición Unidad</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>Cuarentena Unidades</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Unidades Acond</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>Unidades en Proceso</b></td>
                    <td  align="center" class="bordeNegroTd"><b>PROCESO MC</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>STOCK FINAL AP</b></td>
                    <td  align="center" class="bordeNegroTd"><b>LOTES A PRODUCIR</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>MM</b></td>
                    <td  align="center" class="bordeNegroTd"><b>MERCADERIA CORRIENTE</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>LICITACIÓN</b></td>
                    <td  align="center" class="bordeNegroTd"><b>TOTAL</b></td>
                    
                    <td  align="center" class="bordeNegroTd"><b>LOTES PROGRAMADOS</b></td>
                    <td  align="center" class="bordeNegroTd"><b>STOCK FINAL DP</b></td>
                    
                </tr>
                
                <%
                String sql_4="select cod_presentacion, cantidad_presentacion, nombre_producto_presentacion, cod_anterior  " ;
                
                
                sql_4+=" ,(select stock_minimo from STOCK_PRESENTACIONES pdc where pdc.cod_presentacion=p.cod_presentacion and cod_area_empresa=1) ";
                sql_4+=" ,(select stock_reposicion from STOCK_PRESENTACIONES pdc where pdc.cod_presentacion=p.cod_presentacion and cod_area_empresa=1) ";
                sql_4+=" ,(select stock_maximo from STOCK_PRESENTACIONES pdc where pdc.cod_presentacion=p.cod_presentacion and cod_area_empresa=1) ,COD_PROD";
                sql_4+= " from presentaciones_producto p where cod_tipomercaderia=1 " ;
                sql_4+=" and p.cod_presentacion in (select cpp.COD_PRESENTACION from COMPONENTES_PRESPROD cpp,COMPONENTES_PROD cp where cp.COD_COMPPROD=cpp.COD_COMPPROD" ;
                sql_4+=" and cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+"))";
                
                
                
                sql_4+=" and cod_estado_registro=1 order by nombre_producto_presentacion";
                System.out.println("SQL_4444444444444444444:"+sql_4);
                Statement st_4=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4=st_4.executeQuery(sql_4);
                while (rs_4.next()){
                    codPresentacion=rs_4.getString(1);
                    int cantPresentacion=rs_4.getInt(2);
                    String nombre=rs_4.getString("nombre_producto_presentacion");
                    String codigoAnterior=rs_4.getString("cod_anterior");
                    int stockminimo2=0;
                    int stockreposicion=0;
                    int stockMaximo=0;
                    
                    stockminimo2=rs_4.getInt(5);
                    stockreposicion=rs_4.getInt(6);
                    stockMaximo=rs_4.getInt(7);
                    String codProd=rs_4.getString(8);
                
                
                
                %>
                <tr >
                    <td class="bordeNegroTd"><%=codigoAnterior%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=cantPresentacion%>&nbsp;</td>
                    <td class="bordeNegroTd"><%=nombre%>&nbsp;</td>
                    
                    
                    
                    
                    
                    
                    <%
                    String sql_fm=" select DISTINCT(fm.CANTIDAD_LOTE) from FORMULA_MAESTRA fm,FORMULA_MAESTRA_DETALLE_ES fe,COMPONENTES_PROD cp";
                    sql_fm+=" where cp.COD_COMPPROD = fm.COD_COMPPROD and fe.COD_PRESENTACION_PRODUCTO = '"+codPresentacion+"' " +
                            " and fe.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA and fm.COD_ESTADO_REGISTRO =1 and cp.cod_prod='"+codProd+"'";
                    sql_fm="SELECT max(FM.CANTIDAD_LOTE) FROM COMPONENTES_PRESPROD CPPR  INNER JOIN FORMULA_MAESTRA FM ON CPPR.COD_COMPPROD = FM.COD_COMPPROD " +
                            " WHERE CPPR.COD_PRESENTACION =" + codPresentacion + " AND FM.COD_ESTADO_REGISTRO=1 ";
                    
                    System.out.println("sql_fm:"+sql_fm);
                    Statement st_fm=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_fm=st_fm.executeQuery(sql_fm);
                    int sw=0;
                    while (rs_fm.next()){
                        sw++;
                        cantLote=rs_fm.getDouble(1);
                    
                    %>
                    <td class="bordeNegroTd" align="right" ><%=form.format(cantLote)%>&nbsp;</td>
                    <%
                    }
                    if (sw==0){
                        cantLote=0;
                    %>
                    <td class="bordeNegroTd" align="right"><%=form.format(cantLote)%>&nbsp;</td>
                    <%
                    }
                    
                    cantidadTotal=0;
                    cantidadTotalUnitaria=0;
                    
                    
                    
                    String sql_2="select sum(id.cantidad),sum(id.cantidad_unitaria) " +
                            " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                            " where id.cod_ingresoventas=iv.cod_ingresoventas "+
                            " and id.cod_presentacion="+codPresentacion+" " +
                            " and iv.fecha_ingresoventas<='"+fechaInicio+ " 23:59:59'" +
                            " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                            " and iv.cod_almacen_venta='"+almacenQuintanilla+"'";
                    System.out.println("SQL INGRESOS:    "+sql_2);
                    Statement st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_2=st_2.executeQuery(sql_2);
                    while (rs_2.next()){
                        ingresos=rs_2.getInt(1);
                        ingresos_unitarios=rs_2.getInt(2);
                        String sql_3="select sum(cantidad_total),sum(cantidad_unitariatotal)" +
                                " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp  " +
                                " where sd.cod_salidaventas=sa.cod_salidaventa " +
                                " and sd.cod_presentacion="+codPresentacion+""+
                                " and sa.fecha_salidaventa<='"+fechaInicio+ " 23:59:59' " +
                                " and pp.cod_presentacion=sd.cod_presentacion and sa.cod_estado_salidaventa<>2 " +
                                " and sa.cod_almacen_venta='"+almacenQuintanilla+"'";
                        System.out.println("SQL SALIDAS:   "+sql_3);
                        Statement st_3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_3=st_3.executeQuery(sql_3);
                        if(rs_3.next()){
                            salidas=rs_3.getInt(1);
                            salidas_unitarios=rs_3.getInt(2);
                            String values[]=new String[5];
                            System.out.println("---------------------"+ingresos+"-"+salidas+"="+(ingresos-salidas));
                            System.out.println("---------------------"+ingresos_unitarios+"-"+salidas_unitarios+"="+(ingresos_unitarios-salidas_unitarios));
                            saldoCantidad=ingresos-salidas;
                            saldoCantidadUnitaria=ingresos_unitarios-salidas_unitarios;
                            if(saldoCantidadUnitaria<0){
                                float varAux=saldoCantidad * cantPresentacion;
                                varAux=varAux+saldoCantidadUnitaria;
                                saldoCantidad=varAux/cantPresentacion;
                                int aux_1=(int)saldoCantidad;
                                saldoCantidadUnitaria=(int)varAux%cantPresentacion;
                                saldoCantidad=Float.valueOf(aux_1);
                            }
                            if(saldoCantidadUnitaria>=cantPresentacion){
                                int saldoC=(int)(saldoCantidad+(saldoCantidadUnitaria/cantPresentacion));
                                int saldoCU=(int)(saldoCantidadUnitaria%cantPresentacion);
                                saldoCantidad=saldoC;
                                saldoCantidadUnitaria=saldoCU;
                            }
                            cantidadTotal=cantidadTotal+saldoCantidad;
                            cantidadTotalUnitaria=cantidadTotalUnitaria+saldoCantidadUnitaria;
                            
                            saldoCantidadUnitaria=(saldoCantidad*cantPresentacion)+saldoCantidadUnitaria;
                            if(trimestral.equals("1")){
                                saldoCantidadUnitaria=saldoCantidadUnitaria*2;
                            }
                    
                    %>
                    
                    <td class="bordeNegroTd" align="right"><%=form.format(saldoCantidadUnitaria)%></td>
                    <%
                    
                        }
                    }
                    
                    
                    float cantidadCaja1=stockminimo2;
                    float cantidadUnidad1=stockminimo2*cantPresentacion;
                    float cantidadReposicion=stockreposicion;
                    float cantidadUnitariaReposicion=stockreposicion*cantPresentacion;
                    float stockMaximoCantidad=stockMaximo;
                    float stockMaximoCantidadUnitaria=stockMaximo*cantPresentacion;
                    //cantidadUnitariaReposicion=cantidadReposicion*cantPresentacion+cantidadUnitariaReposicion;
                    %>
                    
                    <td class="bordeNegroTd" align="right"><%=form.format(cantidadUnitariaReposicion)%></td>
                    <%  
                    
                    
                    
                    
                    sql_2="select sum(id.cantidad),sum(id.cantidad_unitaria) " +
                            " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                            " where id.cod_ingresoventas=iv.cod_ingresoventas "+
                            " and id.cod_presentacion="+codPresentacion+" " +
                            " and iv.fecha_ingresoventas<='"+fechaInicio+ " 23:59:59'" +
                            " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                            " and iv.cod_almacen_venta='"+almacenCuarentena+"'";
                    System.out.println("SQL INGRESOS:    "+sql_2);
                    st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rs_2=st_2.executeQuery(sql_2);
                    while (rs_2.next()){
                        ingresos=rs_2.getInt(1);
                        ingresos_unitarios=rs_2.getInt(2);
                        String sql_3="select sum(cantidad_total),sum(cantidad_unitariatotal)" +
                                " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp  " +
                                " where sd.cod_salidaventas=sa.cod_salidaventa " +
                                " and sd.cod_presentacion="+codPresentacion+""+
                                " and sa.fecha_salidaventa<='"+fechaInicio+ " 23:59:59' " +
                                " and pp.cod_presentacion=sd.cod_presentacion and sa.cod_estado_salidaventa<>2 " +
                                " and sa.cod_almacen_venta='"+almacenCuarentena+"'";
                        System.out.println("SQL SALIDAS:   "+sql_3);
                        Statement st_3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_3=st_3.executeQuery(sql_3);
                        if(rs_3.next()){
                            salidas=rs_3.getInt(1);
                            salidas_unitarios=rs_3.getInt(2);
                            String values[]=new String[5];
                            System.out.println("---------------------"+ingresos+"-"+salidas+"="+(ingresos-salidas));
                            System.out.println("---------------------"+ingresos_unitarios+"-"+salidas_unitarios+"="+(ingresos_unitarios-salidas_unitarios));
                            saldoCantidadCuar=ingresos-salidas;
                            saldoCantidadUnitariaCuare=ingresos_unitarios-salidas_unitarios;
                            if(saldoCantidadUnitariaCuare<0){
                                float varAux=saldoCantidadCuar * cantPresentacion;
                                varAux=varAux+saldoCantidadUnitariaCuare;
                                saldoCantidadCuar=varAux/cantPresentacion;
                                int aux_1=(int)saldoCantidadCuar;
                                saldoCantidadUnitariaCuare=(int)varAux%cantPresentacion;
                                saldoCantidadCuar=Float.valueOf(aux_1);
                            }
                            if(saldoCantidadUnitariaCuare>=cantPresentacion){
                                int saldoC=(int)(saldoCantidadCuar+(saldoCantidadUnitariaCuare/cantPresentacion));
                                int saldoCU=(int)(saldoCantidadUnitariaCuare%cantPresentacion);
                                saldoCantidadCuar=saldoC;
                                saldoCantidadUnitariaCuare=saldoCU;
                            }
                            cantidadTotal=cantidadTotal+saldoCantidadCuar;
                            cantidadTotalUnitaria=cantidadTotalUnitaria+saldoCantidadUnitariaCuare;
                            saldoCantidadUnitariaCuare=saldoCantidadCuar*cantPresentacion+saldoCantidadUnitariaCuare;
                    %>
                    
                    <td class="bordeNegroTd" align="right"><%=form.format(saldoCantidadUnitariaCuare)%></td>
                    <%
                    
                        }
                    }
                    %>
                    <%
                    cantidadTotalUnitaria=0;
                    int ingresosUnitarios=0;
                    int salidasUnitarios=0;
                    
                    String sqlLotes="select DISTINCT(sd.COD_LOTE_PRODUCCION) from SALIDAS_ACOND s, SALIDAS_DETALLEACOND sd,COMPONENTES_PRESPROD cp " +
                            "where s.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND and cp.cod_presentacion = "+codPresentacion+" and s.COD_ESTADO_SALIDAACOND<>2 and sd.COD_ESTADOENTREGA=1 " +
                            "and s.COD_ALMACENACOND='"+almacenAcond+"' and cp.COD_COMPPROD = sd.COD_COMPPROD";
                    Statement stLotes=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsLotes=stLotes.executeQuery(sqlLotes);
                    String lotesProduccionCerrados="";
                    while(rsLotes.next()){
                        lotesProduccionCerrados=lotesProduccionCerrados+"'"+rsLotes.getString(1)+"',";
                    }
                    lotesProduccionCerrados=lotesProduccionCerrados+"'0'";
                    
                    String sql_0="select sda.CANT_TOTAL_SALIDADETALLEACOND,COD_ESTADOENTREGA,COD_LOTE_PRODUCCION from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sda,COMPONENTES_PRESPROD cp";
                    sql_0+=" where sa.COD_SALIDA_ACOND = sda.COD_SALIDA_ACOND and cp.COD_COMPPROD = sda.COD_COMPPROD";
                    sql_0+=" and cp.cod_presentacion = "+codPresentacion+" and sa.FECHA_SALIDAACOND <= '"+fechaInicio+" 23:59:59'";
                    sql_0+=" and sa.COD_ESTADO_SALIDAACOND <> 2 " ;
                    sql_0+="and sda.COD_LOTE_PRODUCCION not in ("+lotesProduccionCerrados+") " ;
                    sql_0+="and sa.COD_ALMACENACOND ='"+almacenAcond+"'";
                    // sql_0+=" and sda.COD_ESTADOENTREGA<>2";
                    System.out.println("sql_0:"+sql_0);
                    
                    Statement st_0=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_0=st_0.executeQuery(sql_0);
                    int cantidadTotalSalidas=0;
                    String loteEntrega="'0'";
                    while(rs_0.next()){
                        int cantidadTotalSalidasUnitario=rs_0.getInt(1);
                        int codEstado=rs_0.getInt(2);
                        loteEntrega=rs_0.getString(3);
                        if(codEstado==0){
                            cantidadTotalSalidas=cantidadTotalSalidas+cantidadTotalSalidasUnitario;
                            
                        }
                    }
                    
                    
                    System.out.println("TOTALLLLLLLLLL:"+cantidadTotalSalidas);
                    
                    sql_2="select ISNULL(sum(ida.CANT_TOTAL_INGRESO),0) from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND ida,COMPONENTES_PRESPROD cp";
                    sql_2+=" where ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND and ida.COD_COMPPROD = cp.COD_COMPPROD";
                    sql_2+=" and cp.cod_presentacion = "+codPresentacion+" and ia.fecha_ingresoacond<='"+fechaInicio+" 23:59:59'";
                    sql_2+=" and ia.COD_ESTADO_INGRESOACOND<>2 and ia.COD_ALMACENACOND='"+almacenAcond+"'";
                    sql_2+=" AND COD_LOTE_PRODUCCION not in ("+lotesProduccionCerrados+")";
                    System.out.println("SQL IIIIIIIIIINGRESOS:"+sql_2);
                    st_2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    rs_2=st_2.executeQuery(sql_2);
                    int saldoCantidadUnitariaAcond=0;
                    while(rs_2.next()){
                        ingresosUnitarios=rs_2.getInt(1);
                        
                        saldoCantidadUnitariaAcond=ingresosUnitarios-cantidadTotalSalidas;
                        cantidadTotalUnitaria=cantidadTotalUnitaria+saldoCantidadUnitariaAcond;
                    %>                
                    <td class="bordeNegroTd" align="right"><%=form.format(saldoCantidadUnitariaAcond)%></td>
                    <%
                    }
                    /*Calculo del la cantidad que se esta produciendo para un componente */

                    String consulta =" SELECT PREP.cod_presentacion,PREP.NOMBRE_PRODUCTO_PRESENTACION,SUM(FM.CANTIDAD_LOTE) CANTIDAD_PRODUCCION FROM PROGRAMA_PRODUCCION_PERIODO PPRP INNER JOIN  PROGRAMA_PRODUCCION PPR ON PPRP.COD_PROGRAMA_PROD=PPR.COD_PROGRAMA_PROD " +
                            " INNER JOIN FORMULA_MAESTRA FM ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA INNER JOIN PRESENTACIONES_PRODUCTO PREP ON PREP.cod_presentacion = PPR.COD_PRESENTACION " +
                            " WHERE PPR.COD_ESTADO_PROGRAMA IN (2,5) AND PREP.cod_presentacion ='"+codPresentacion+"' AND PPRP.COD_ESTADO_PROGRAMA=2  GROUP BY PREP.cod_presentacion,PREP.NOMBRE_PRODUCTO_PRESENTACION ";

                    consulta = " SELECT PRESPR.NOMBRE_PRODUCTO_PRESENTACION,CP.cod_presentacion,SUM(FM.CANTIDAD_LOTE) CANTIDAD_PRODUCCION ,PPR.COD_ESTADO_PROGRAMA " +
                            " FROM PROGRAMA_PRODUCCION PPR INNER JOIN FORMULA_MAESTRA FM ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA  " +
                            " INNER JOIN COMPONENTES_PRESPROD CP ON CP.COD_COMPPROD = PPR.COD_COMPPROD " +
                            " INNER JOIN PRESENTACIONES_PRODUCTO PRESPR ON PRESPR.cod_presentacion = CP.COD_PRESENTACION " +
                            " INNER JOIN PROGRAMA_PRODUCCION_PERIODO PPRP ON PPRP.COD_PROGRAMA_PROD = PPR.COD_PROGRAMA_PROD " +
                            " WHERE PPR.COD_ESTADO_PROGRAMA IN (2,5,1) AND CP.cod_presentacion ='"+codPresentacion+"' " +
                            " AND PPRP.COD_ESTADO_PROGRAMA IN (2,5,1) " +
                            " GROUP BY PRESPR.NOMBRE_PRODUCTO_PRESENTACION,CP.cod_presentacion,PPR.COD_ESTADO_PROGRAMA ";
                            
                     System.out.println("SQL PROGRAMA PRODUCCION"+consulta);
                     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                     ResultSet rs=st.executeQuery(consulta);
                     if(rs.next()){
                         cantidadProduccion=rs.getDouble("CANTIDAD_PRODUCCION");
                     }

                    double lotes_producir=0;
                    double g=saldoCantidadUnitariaCuare+saldoCantidadUnitariaAcond+0;
                    double h=saldoCantidadUnitaria+(saldoCantidadUnitariaCuare+saldoCantidadUnitariaAcond)+cantidadProduccion-cantidadUnitariaReposicion;
                    
                    if(cantLote!=0){
                       lotes_producir=h/cantLote;
                       System.out.println("la cantidad de division: "+h+"/"+cantLote + "="+   lotes_producir);
                    }
                     
                    System.out.println("h:"+h);
                    System.out.println("cantLote:"+cantLote);
                    try{
                                if (String.valueOf(lotes_producir).lastIndexOf(".") > -1) {
                                    String valorEntero = String.valueOf(lotes_producir).substring(0, String.valueOf(lotes_producir).lastIndexOf("."));
                                    String valorDecimal = String.valueOf(lotes_producir).substring(String.valueOf(lotes_producir).lastIndexOf(".") + 1);
                                    valorEntero = valorEntero.equals("") ? "0" : valorEntero;
                                    valorDecimal = valorDecimal.equals("") ? "0" : valorDecimal;
                                    System.out.println("el valor de la fraccion" + valorDecimal);
                                    if (Double.valueOf(valorDecimal) > 0) {
                                        //lotes_producir=lotes_producir<0?(lotes_producir*(-1))+1:lotes_producir+1;
                                        //lotes_producir=lotes_producir<0?(lotes_producir*(-1))+1:lotes_producir+1;
                                        lotes_producir=Double.valueOf(valorEntero.replace("-",""))+1;
                                    }
                            }
      }catch(Exception e){
          e.printStackTrace();
      }
                    
                    %>
                    
                    
                    <td class="bordeNegroTd" align="right"><%=form.format(cantidadProduccion)%></td>
                    <td class="bordeNegroTd" align="right"><%=form.format(g)%>&nbsp;</td>
                    <td class="bordeNegroTd" bgcolor="#f2f2f2" align="right" ><%=form.format(h)%>&nbsp;</td>     
                    <%
                    if(h>=0){
                    %>
                    <td class="bordeNegroTd" bgcolor="#f2f2f2" align="right"><%=form.format(0)%>&nbsp;</td>
                    <%
                    } else{
                    %>
                    <td class="bordeNegroTd" bgcolor="#f2f2f2" align="right"><%=form.format(lotes_producir)%>&nbsp;</td>     
                    <%
                    }
                    %>
                    <td class="bordeNegroTd" align="right">0&nbsp;</td>
                    <td class="bordeNegroTd" align="right">0&nbsp;</td>
                    <td class="bordeNegroTd" align="right">0&nbsp;</td>
                    <td class="bordeNegroTd" align="right">0&nbsp;</td>
                    <td class="bordeNegroTd" align="right">0&nbsp;</td>
                    <td class="bordeNegroTd" bgcolor="#f2f2f2" align="right">0&nbsp;</td>     
                    
                    
                    
                    
                    <%
                    }
                    %>
                </tr>
                
                <%
                
                
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                %>
            </table>
            
            
            
        </form>
    </body>
</html>