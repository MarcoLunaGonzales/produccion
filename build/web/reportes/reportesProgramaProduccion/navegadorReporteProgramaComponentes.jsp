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
                //String codPresentacion="";
                //String nombrePresentacion="";
                String linea_mkt="";
                String agenciaVenta="";
                float cantidadTotal=0f;
                float cantidadTotalUnitaria=0f;
                double procesoMC=0;
                double cantLote=0;
                double cantidadProduccion=0.0d;
                
                
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
                    tipoMercaderia="0";
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
                    trimestral="0";
                    aux="0";
                    aux=request.getParameter("codAreaEmpresa");
                    aux="0";
                    float saldoCantidad=0;
                    float saldoCantidadUnitaria=0;
                    float saldoCantidadCuar=0;
                    float saldoCantidadUnitariaCuare=0;

                    float saldoCantUnitariaPresentacion =0;
                    float saldoCantUnitariaCuarentena =0;
                    float saldoCantUnitariaAcondicionamiento=0;
                    float saldoCantUnitariaProduccion=0;
                    float cantUnitariaReposicion=0;
                    float cantLotePresentacion =0;
                    


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
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        codAreaEmpresa=aux;
                    }
                    if(codAreaEmpresa.equals("0")){
                        codAreaEmpresa="80,81,82,95";
                    }
                    //aux=request.getParameter("fecha_inicio");
                    //aux="2011/02/15";
                    //System.out.println("aux:"+aux);
                    //if(aux!=null){
                    //    System.out.println("entro");
                    //    fechaInicio=aux;
                    //}
                    fechaInicio="15/02/2011";
               
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
                    <td align="center" class="bordeNegroTd"><b>Nombre Producto Semiterminado</b></td>
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
                try{
                String consulta = "select cp.COD_COMPPROD,cp.nombre_prod_semiterminado,cpp.COD_PRESENTACION, prp.NOMBRE_PRODUCTO_PRESENTACION " +
                         " from COMPONENTES_PRESPROD cpp,COMPONENTES_PROD cp, PRESENTACIONES_PRODUCTO prp " +
                         " where cp.COD_COMPPROD=cpp.COD_COMPPROD and cpp.COD_PRESENTACION =prp.cod_presentacion and cp.COD_AREA_EMPRESA in ("+aux+") " +
                         " order by cp.nombre_prod_semiterminado,prp.NOMBRE_PRODUCTO_PRESENTACION asc ";
                System.out.println("consulta"+consulta);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){
                    String codCompProd = rs.getString("COD_COMPPROD");
                    String nombreProductoSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String codPresentacion = rs.getString("COD_PRESENTACION");
                    String nombreProductoPresentacion = rs.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    String consultaPresentaciones =" select cod_presentacion, cantidad_presentacion, nombre_producto_presentacion, cod_anterior  , " +
                            " (select stock_minimo from STOCK_PRESENTACIONES pdc where pdc.cod_presentacion=p.cod_presentacion and cod_area_empresa=1) stock_minimo , " +
                            " (select stock_reposicion from STOCK_PRESENTACIONES pdc where pdc.cod_presentacion=p.cod_presentacion and cod_area_empresa=1) stock_reposicion , " +
                            " (select stock_maximo from STOCK_PRESENTACIONES pdc where pdc.cod_presentacion=p.cod_presentacion and cod_area_empresa=1) stock_maximo , " +
                            " COD_PROD from presentaciones_producto p where cod_tipomercaderia=1   and p.cod_presentacion in ("+codPresentacion+")  " +
                            " and cod_estado_registro=1  order by nombre_producto_presentacion ";
                     System.out.println("consulta presentaciones " + consultaPresentaciones);
                     Statement stPresentaciones=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                     ResultSet rsPresentaciones=stPresentaciones.executeQuery(consultaPresentaciones);
                                while(rsPresentaciones.next()){
                                int cantPresentacion = rsPresentaciones.getInt("cantidad_presentacion");
                                String codAnteriorPresentacion = rsPresentaciones.getString("cod_anterior");
                                String stockMinimoPresentacion = rsPresentaciones.getString("stock_minimo");
                                float stockReposicionPresentacion = rsPresentaciones.getFloat("stock_reposicion");
                                String stockMaximoPresentacion = rsPresentaciones.getString("stock_maximo");
                                out.print("<tr class='tablaFiltroReporte'>");
                                out.print("<td class='bordeNegroTd'>"+nombreProductoSemiterminado+"&nbsp;</td>");
                                out.print("<td class='bordeNegroTd'>"+codAnteriorPresentacion+"&nbsp;</td>");
                                out.print("<td class='bordeNegroTd'>"+cantPresentacion+"&nbsp;</td>");
                                out.print("<td class='bordeNegroTd'>"+nombreProductoPresentacion+"&nbsp;</td>");
                                //hallar el lote de presentacion

                                String consultaCantidadLotePresentacion="SELECT isnull(max(FM.CANTIDAD_LOTE),'0') CANTIDAD_LOTE FROM COMPONENTES_PRESPROD CPPR  INNER JOIN FORMULA_MAESTRA FM ON CPPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                " WHERE CPPR.COD_PRESENTACION =" + codPresentacion + " AND FM.COD_ESTADO_REGISTRO=1 ";
                                System.out.println("cantidad de lotes presentacion: " + consultaCantidadLotePresentacion);
                                Statement stLote=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rsLote=stLote.executeQuery(consultaCantidadLotePresentacion);
                                String cantidadLotePresentacion ="0";
                                if(rsLote.next()){
                                    cantidadLotePresentacion = rsLote.getString("CANTIDAD_LOTE");
                                }
                                cantLotePresentacion = Float.valueOf(cantidadLotePresentacion);
                                out.print("<td class='bordeNegroTd'>"+cantidadLotePresentacion+"&nbsp;</td>");

                                //hallar Unidades en Stock de Presentacion
                                String consultaIngresosPresentacion="select sum(id.cantidad) cantidad,sum(id.cantidad_unitaria) cantidadUnitaria " +
                                " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                                " where id.cod_ingresoventas=iv.cod_ingresoventas "+
                                " and id.cod_presentacion="+codPresentacion+" " +
                                " and iv.fecha_ingresoventas<='"+fechaInicio+ " 23:59:59'" +
                                " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                                " and iv.cod_almacen_venta='"+almacenQuintanilla+"'";
                                System.out.println("SQL INGRESOS:    "+consultaIngresosPresentacion);
                                
                                Statement stIngresosPresentacion=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rsIngresosPresentacion=stIngresosPresentacion.executeQuery(consultaIngresosPresentacion);

                                if(rsIngresosPresentacion.next()){
                                    float ingresosPresentacion = rsIngresosPresentacion.getFloat("cantidad");
                                    float ingresosUnitariosPresentacion = rsIngresosPresentacion.getFloat("cantidadUnitaria");

                                String consultaSalidasPresentacion="select sum(cantidad_total) salidas,sum(cantidad_unitariatotal) salidasUnitarias" +
                                " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp  " +
                                " where sd.cod_salidaventas=sa.cod_salidaventa " +
                                " and sd.cod_presentacion="+codPresentacion+""+
                                " and sa.fecha_salidaventa<='"+fechaInicio+ " 23:59:59' " +
                                " and pp.cod_presentacion=sd.cod_presentacion and sa.cod_estado_salidaventa<>2 " +
                                " and sa.cod_almacen_venta='"+almacenQuintanilla+"'";
                                System.out.println("SQL SALIDAS:   "+consultaSalidasPresentacion);
                                Statement stSalidasPresentacion=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rsSalidasPresentacion=stSalidasPresentacion.executeQuery(consultaSalidasPresentacion);
                                        if(rsSalidasPresentacion.next()){
                                            float salidasPresentacion = rsSalidasPresentacion.getFloat("salidas");
                                            float salidasUnitariasPresentacion = rsSalidasPresentacion.getFloat("salidasUnitarias");

                                            float saldoCantidadPresentacion = ingresosPresentacion-salidasPresentacion;
                                            float saldoCantidadUnitariasPresentacion = ingresosUnitariosPresentacion- salidasUnitariasPresentacion;
                                            //tratamiento para hallar las cantidades unitarias totales

                                            if(saldoCantidadUnitariasPresentacion<0){
                                                float unidadesPresentacion=saldoCantidadPresentacion * cantPresentacion;
                                                unidadesPresentacion=unidadesPresentacion+saldoCantidadUnitariasPresentacion; //se resta la cantidad unitaria
                                                saldoCantidadPresentacion=Float.valueOf((int)(unidadesPresentacion/cantPresentacion));
                                                saldoCantidadUnitariasPresentacion=(int)unidadesPresentacion%cantPresentacion;
                                            }
                                            if(saldoCantidadUnitariasPresentacion>=cantPresentacion){
                                                saldoCantidadPresentacion=(int)(saldoCantidadPresentacion+(saldoCantidadUnitariasPresentacion/cantPresentacion));
                                                saldoCantidadUnitariasPresentacion=(int)(saldoCantidadUnitariasPresentacion%cantPresentacion);
                                            }

                                            //cantidadTotal=cantidadTotal+saldoCantidad;
                                            //cantidadTotalUnitaria=cantidadTotalUnitaria+saldoCantidadUnitaria;

                                            Float saldoCantidadUnitariaPresentacion = (saldoCantidadPresentacion*cantPresentacion)+saldoCantidadUnitariasPresentacion;

                                            if(trimestral.equals("1")){
                                            saldoCantidadUnitariaPresentacion=saldoCantidadUnitariaPresentacion*2;
                                            }
                                            saldoCantUnitariaPresentacion = saldoCantidadUnitariaPresentacion;
                                            out.print("<td class='bordeNegroTd' align='right'>"+saldoCantidadUnitariaPresentacion+"</td>");
                                        }
                                }

                            //hallar cantidades de reposicion
                                //form.format(cantidadUnitariaReposicion)
                                            Float cantidadUnitariaReposicion =  stockReposicionPresentacion*cantPresentacion;
                                            cantUnitariaReposicion = cantidadUnitariaReposicion;
                                            out.print("<td class='bordeNegroTd' align='right'>"+cantidadUnitariaReposicion+"</td>");

                            //hallar cantidades en cuarentena

                            String consultaIngresosCuarentena ="select sum(id.cantidad) ingresosCuarentena,sum(id.cantidad_unitaria) ingresosUnitariosCuarentena " +
                                    " from ingresos_detalleventas id,ingresos_ventas iv,PRESENTACIONES_PRODUCTO pp " +
                                    " where id.cod_ingresoventas=iv.cod_ingresoventas "+
                                    " and id.cod_presentacion="+codPresentacion+" " +
                                    " and iv.fecha_ingresoventas<='"+fechaInicio+ " 23:59:59'" +
                                    " and pp.cod_presentacion=id.cod_presentacion and iv.cod_estado_ingresoventas<>2 " +
                                    " and iv.cod_almacen_venta='"+almacenCuarentena+"'";
                                    System.out.println("SQL INGRESOS CUARENTENA:    "+consultaIngresosCuarentena);
                            Statement stIngresosCuarentena=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsIngresosCuarentena=stIngresosCuarentena.executeQuery(consultaIngresosCuarentena);
                            if(rsIngresosCuarentena.next()){
                                float ingresosCuarentena = rsIngresosCuarentena.getFloat("ingresosCuarentena");
                                float ingresosUnitariosCuarentena = rsIngresosCuarentena.getFloat("ingresosUnitariosCuarentena");
                                String consultaSalidasCuarentena="select sum(cantidad_total) cantidadCuarentena,sum(cantidad_unitariatotal) cantidadUnitariaCuarentena" +
                                             " from salidas_detalleventas sd,salidas_ventas sa,PRESENTACIONES_PRODUCTO pp  " +
                                             " where sd.cod_salidaventas=sa.cod_salidaventa " +
                                             " and sd.cod_presentacion="+codPresentacion+""+
                                             " and sa.fecha_salidaventa<='"+fechaInicio+ " 23:59:59' " +
                                             " and pp.cod_presentacion=sd.cod_presentacion and sa.cod_estado_salidaventa<>2 " +
                                             " and sa.cod_almacen_venta='"+almacenCuarentena+"'";
                                Statement stSalidasCuarentena=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rsSalidasCuarentena=stSalidasCuarentena.executeQuery(consultaSalidasCuarentena);
                                if(rsSalidasCuarentena.next()){
                                    float salidasCuarentena = rsSalidasCuarentena.getFloat("cantidadCuarentena");
                                    float salidasUnitariasCuarentena = rsSalidasCuarentena.getFloat("cantidadUnitariaCuarentena");

                                    float saldoCantidadCuarentena =ingresosCuarentena-salidasCuarentena;
                                    float saldoCantidadUnidadesCuarentena = ingresosUnitariosCuarentena - salidasUnitariasCuarentena;


                                            if(saldoCantidadUnidadesCuarentena<0){
                                                float unidadesCuarentena=saldoCantidadCuarentena * cantPresentacion;
                                                unidadesCuarentena=unidadesCuarentena+saldoCantidadUnidadesCuarentena; //se resta la cantidad unitaria
                                                saldoCantidadCuarentena=Float.valueOf((int)(unidadesCuarentena/cantPresentacion));
                                                saldoCantidadUnidadesCuarentena=(int)unidadesCuarentena%cantPresentacion;
                                            }
                                            if(saldoCantidadUnidadesCuarentena>=cantPresentacion){
                                                saldoCantidadCuarentena=(int)(saldoCantidadCuarentena+(saldoCantidadUnidadesCuarentena/cantPresentacion));
                                                saldoCantidadUnidadesCuarentena=(int)(saldoCantidadUnidadesCuarentena%cantPresentacion);
                                            }

                                            Float saldoCantidadUnitariaCuarentena = (saldoCantidadCuarentena*cantPresentacion) + saldoCantidadUnidadesCuarentena;

                                            //cantidadTotal=cantidadTotal+saldoCantidadCuar;
                                            //cantidadTotalUnitaria=cantidadTotalUnitaria+saldoCantidadUnitariaCuare;

                                            saldoCantUnitariaCuarentena = saldoCantidadUnitariaCuarentena;
                                            out.print("<td class='bordeNegroTd' align='right'>"+saldoCantidadUnitariaCuarentena+"</td>");
                                }
                            }
                            //hallar saldo en acondicionamiento


                            String consultaLotesCerrados="select DISTINCT(sd.COD_LOTE_PRODUCCION) from SALIDAS_ACOND s, SALIDAS_DETALLEACOND sd,COMPONENTES_PRESPROD cp " +
                            "where s.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND and cp.cod_presentacion = "+codPresentacion+" and s.COD_ESTADO_SALIDAACOND<>2 and sd.COD_ESTADOENTREGA=1 " +
                            "and s.COD_ALMACENACOND='"+almacenAcond+"' and cp.COD_COMPPROD = sd.COD_COMPPROD";
                             Statement stLotes=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                             ResultSet rsLotes=stLotes.executeQuery(consultaLotesCerrados);

                             String lotesProduccionCerrados="";
                                while(rsLotes.next()){
                                    lotesProduccionCerrados=lotesProduccionCerrados+"'"+rsLotes.getString(1)+"',";
                                }
                             lotesProduccionCerrados=lotesProduccionCerrados+"'0'";

                    String consultaSalidasAcondicionamiento="select sda.CANT_TOTAL_SALIDADETALLEACOND,COD_ESTADOENTREGA,COD_LOTE_PRODUCCION from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sda,COMPONENTES_PRESPROD cp";
                    consultaSalidasAcondicionamiento+=" where sa.COD_SALIDA_ACOND = sda.COD_SALIDA_ACOND and cp.COD_COMPPROD = sda.COD_COMPPROD";
                    consultaSalidasAcondicionamiento+=" and cp.cod_presentacion = "+codPresentacion+" and sa.FECHA_SALIDAACOND <= '"+fechaInicio+" 23:59:59'";
                    consultaSalidasAcondicionamiento+=" and sa.COD_ESTADO_SALIDAACOND <> 2 " ;
                    consultaSalidasAcondicionamiento+="and sda.COD_LOTE_PRODUCCION not in ("+lotesProduccionCerrados+") " ;
                    consultaSalidasAcondicionamiento+="and sa.COD_ALMACENACOND ='"+almacenAcond+"'";
                    // sql_0+=" and sda.COD_ESTADOENTREGA<>2";
                    System.out.println("consultaSalidasAcondicionamiento:"+consultaSalidasAcondicionamiento);

                    Statement stSalidasAcondicionamiento=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsSalidasAcondicionamiento=stSalidasAcondicionamiento.executeQuery(consultaSalidasAcondicionamiento);

                    int cantidadTotalSalidas=0;

                    while(rsSalidasAcondicionamiento.next()){
                        int cantidadTotalSalidasUnitario=rsSalidasAcondicionamiento.getInt("CANT_TOTAL_SALIDADETALLEACOND");
                        int codEstado=rsSalidasAcondicionamiento.getInt("COD_ESTADOENTREGA");
                        String loteEntrega=rsSalidasAcondicionamiento.getString("COD_LOTE_PRODUCCION");
                        if(codEstado==0){
                            cantidadTotalSalidas=cantidadTotalSalidas+cantidadTotalSalidasUnitario;
                        }
                    }

                    System.out.println("total salida Acondicionamiento:"+cantidadTotalSalidas);

                    String consultaIngresosAcondicionamiento =" select ISNULL(sum(ida.CANT_TOTAL_INGRESO),0) CANT_TOTAL_INGRESOS from INGRESOS_ACOND ia,INGRESOS_DETALLEACOND ida,COMPONENTES_PRESPROD cp";
                    consultaIngresosAcondicionamiento+=" where ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND and ida.COD_COMPPROD = cp.COD_COMPPROD";
                    consultaIngresosAcondicionamiento+=" and cp.cod_presentacion = "+codPresentacion+" and ia.fecha_ingresoacond<='"+fechaInicio+" 23:59:59'";
                    consultaIngresosAcondicionamiento+=" and ia.COD_ESTADO_INGRESOACOND<>2 and ia.COD_ALMACENACOND='"+almacenAcond+"'";
                    consultaIngresosAcondicionamiento+=" AND COD_LOTE_PRODUCCION not in ("+lotesProduccionCerrados+")";

                    System.out.println("consulta Ingresos Acondicionamiento:"+consultaIngresosAcondicionamiento);

                    Statement stIngresosAcondicionamiento=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsIngresosAcondicionamiento=stIngresosAcondicionamiento.executeQuery(consultaIngresosAcondicionamiento);
                    int saldoCantidadUnitariaAcond=0;
                    if(rsIngresosAcondicionamiento.next()){
                        int ingresosUnitarios=rsIngresosAcondicionamiento.getInt("CANT_TOTAL_INGRESOS");
                        saldoCantidadUnitariaAcond=ingresosUnitarios-cantidadTotalSalidas;
                        cantidadTotalUnitaria=cantidadTotalUnitaria+saldoCantidadUnitariaAcond;
                        saldoCantUnitariaAcondicionamiento = saldoCantidadUnitariaAcond;
                        out.print("<td class='bordeNegroTd' align='right'>"+form.format(saldoCantidadUnitariaAcond)+"</td>");
                    }


                    //cantidad en produccion

                    String consultaProduccion =" SELECT PREP.cod_presentacion,PREP.NOMBRE_PRODUCTO_PRESENTACION,SUM(FM.CANTIDAD_LOTE) CANTIDAD_PRODUCCION FROM PROGRAMA_PRODUCCION PPR " +
                            " INNER JOIN FORMULA_MAESTRA FM ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA INNER JOIN PRESENTACIONES_PRODUCTO PREP ON PREP.cod_presentacion = PPR.COD_PRESENTACION " +
                            " WHERE PPR.COD_ESTADO_PROGRAMA IN (2,5) AND PREP.cod_presentacion ='"+codPresentacion+"' GROUP BY PREP.cod_presentacion,PREP.NOMBRE_PRODUCTO_PRESENTACION ";
                     System.out.println("SQL PROGRAMA PRODUCCION"+consultaProduccion);
                     Statement stProduccion=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                     ResultSet rsProduccion=stProduccion.executeQuery(consultaProduccion);
                     if(rsProduccion.next()){
                         cantidadProduccion=rsProduccion.getDouble("CANTIDAD_PRODUCCION");
                     }


                    double lotes_producir=0;
                    double procesosMC=saldoCantUnitariaCuarentena + saldoCantUnitariaAcondicionamiento+0;
                    double totalCantidadUnitariaMenosReposicion=saldoCantUnitariaPresentacion +(saldoCantUnitariaCuarentena+saldoCantUnitariaAcondicionamiento)+cantidadProduccion-cantUnitariaReposicion;

                    if(cantLotePresentacion!=0){
                        lotes_producir=totalCantidadUnitariaMenosReposicion/cantLotePresentacion;
                    }

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

                    out.print("<td class='bordeNegroTd' align='right'>"+cantidadProduccion+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+form.format(procesosMC)+"&nbsp;</td>");


                    out.print("<td class='bordeNegroTd' bgcolor='#f2f2f2' align='right' >"+form.format(totalCantidadUnitariaMenosReposicion)+"&nbsp;</td>");
                    out.print("<td class='bordeNegroTd' bgcolor='#f2f2f2' align='right'>"+(totalCantidadUnitariaMenosReposicion>=0?form.format(0):form.format(lotes_producir))+"&nbsp;</td>");


                    out.print("<td class='bordeNegroTd' align='right'>0&nbsp;</td>");
                    out.print("<td class='bordeNegroTd' align='right'>0&nbsp;</td>");
                    out.print("<td class='bordeNegroTd' align='right'>0&nbsp;</td>");
                    out.print("<td class='bordeNegroTd' align='right'>0&nbsp;</td>");
                    out.print("<td class='bordeNegroTd' align='right'>0&nbsp;</td>");
                    out.print("<td class='bordeNegroTd' bgcolor='#f2f2f2' align='right'>0&nbsp;</td>");
                    out.print("</tr>");

                    }
                }
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               
            </table>
            
            
            
        </form>
    </body>
</html>