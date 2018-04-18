<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "org.joda.time.DateTime"%>
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%! Connection con=null;
%>
<%
con=Util.openConnection(con);    
%>
<%!
public double redondear( double numero, int decimales ) {
    return Math.round(numero*Math.pow(10,decimales))/Math.pow(10,decimales);
}
%>
<%!
public double compara(int unidad1,int unidad2){
    String nombre_material="",nombre_unidad_medida="",nombre_unidad_medida2="";
    
    double valor_equivalencia=1;
    try{
        String sql="select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
        sql+=" from equivalencias";
        sql+=" where cod_unidad_medida="+unidad1;
        sql+=" and cod_unidad_medida2="+unidad2;
        sql+=" and cod_estado_registro=1";
        System.out.println("sql:1***********"+sql);
        Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql);
        int sw=0;
        double equivalencia=0;
        while (rs.next()){
            equivalencia=rs.getDouble(3);
            sw=1;
        }
        if(sw==1){
            valor_equivalencia=1/equivalencia;
        }else{
            String sql2="select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
            sql2+=" from equivalencias";
            sql2+=" where cod_unidad_medida="+unidad2;
            sql2+=" and cod_unidad_medida2="+unidad1;
            sql2+=" and cod_estado_registro=1";
            System.out.println("sql:2***********"+sql2);
            Statement st2= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs2 = st2.executeQuery(sql2);
            sw=0;
            while (rs2.next()){
                sw=1;
                equivalencia=rs2.getDouble(3);
            }
            if(sw==1){
                valor_equivalencia=equivalencia;
            }
        }
    } catch(SQLException e) {
        e.printStackTrace();
    }
    System.out.println("valor_equivalencia:"+valor_equivalencia);
    return valor_equivalencia;
}
%>
<!--<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>                        
        </script>
    </head>
    <body>
<form name="form1" action="">-->
<%  
try{
    String sql="";
    String sql2="";
    String cod_prog_prod=request.getParameter("codigo1");
    String cod_grupos=request.getParameter("codigo2");
    String cod_items=request.getParameter("codigo3");
    String fechaInicio=request.getParameter("fecha_inicio");
    String fechaFinal=request.getParameter("fecha_final");
    String fechaInicioPromedio=request.getParameter("fecha_inicio_promedio");
    String fechaFinalPromedio=request.getParameter("fecha_final_promedio");
    
//System.out.println("codProgramaProd:"+codProgramaProd);
    System.out.println("fechaInicio:"+fechaInicio);
    System.out.println("fechaFinal:"+fechaFinal);
    
    System.out.println("fechaInicioPromedio:"+fechaInicioPromedio);
    System.out.println("fechaFinalPromedio:"+fechaFinalPromedio);
    int sw_promedio=0;
    int meses_promedio=0;
    if(!fechaInicioPromedio.equals("") && !fechaFinalPromedio.equals("")){
        sw_promedio=1;
        String fechaInicioPromVector[]=fechaInicioPromedio.split("/");
        String fechaFinalPromVector[]=fechaFinalPromedio.split("/");
        fechaInicioPromedio=fechaInicioPromVector[2]+"/"+fechaInicioPromVector[1]+"/"+fechaInicioPromVector[0];
        fechaFinalPromedio=fechaFinalPromVector[2]+"/"+fechaFinalPromVector[1]+"/"+fechaFinalPromVector[0];
        int mes_inicio=Integer.parseInt(fechaInicioPromVector[1]);
        int mes_final=Integer.parseInt(fechaFinalPromVector[1]);
        if((mes_inicio-mes_final)>0){
            mes_final=mes_final+13;
        }else{
            mes_final=mes_final+1;
        }
        meses_promedio=mes_final-mes_inicio;
    }
    
    Date fechaActual=new Date();
    SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
    String fecha_existencia=f.format(fechaActual);
    String items=" and m.cod_material in (";
    
    
    String sql4="select ppd.COD_MATERIAL,sum(ppd.CANTIDAD) from PROGRAMA_PRODUCCION_DETALLE ppd";
    sql4+=" where ppd.COD_PROGRAMA_PROD in ("+cod_prog_prod+") and ppd.cod_material in ("+cod_items+") group by ppd.cod_material";
    System.out.println("sql4:"+sql4);
    Statement st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs4 = st4.executeQuery(sql4);
    while(rs4.next()){
        items+=rs4.getString(1)+",";
        System.out.println("item44:"+items);
    }
    items+="0)";
    System.out.println("item:"+items);
/* AQ_auxiliarconsultas2.SQL.Clear;
AQ_auxiliarconsultas2.SQL.Add('delete from reporte_explosion_materiales where cod_persona='+inttostr(codigo_personal)+'";
    AQ_auxiliarconsultas2.ExecSQL;*/
    
    /* --------------------   APROBADOS ----------------------*/
    String sql_exp="";
    sql_exp="select m.cod_material,m.stock_minimo_material,m.stock_maximo_material,m.stock_seguridad,m.cod_unidad_medida,m.nombre_material,u.nombre_unidad_medida,";
    sql_exp+=" (select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
    sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
//if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='"+lcb_almacen.KeyValue+"'";
    sql_exp+=" and ia.fecha_ingreso_almacen<='"+fecha_existencia+"' )as aprobados,";
    /* --------------------   SALIDAS ----------------------*/
    sql_exp+=" (select SUM(sadi.cantidad)";
    sql_exp+=" from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa";
    sql_exp+=" WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and";
    sql_exp+=" sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and";
    sql_exp+=" sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA ";
//
//if(lcb_almacen.KeyValue<>null)then sql_exp+=" and sa.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
//else sql_exp+="and (sa.cod_almacen=1 or sa.cod_almacen=2)";
    sql_exp+=" and sad.cod_material=m.cod_material and sa.fecha_salida_almacen<='"+fecha_existencia+"')as salidas,";
    /* --------------------   DEVOLUCIONES ----------------------*/
    sql_exp+="(select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad";
    sql_exp+=" where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<='"+fecha_existencia+"' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1";
//if(lcb_almacen.KeyValue<>null)then sql_exp+="and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+' and d.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
    sql_exp+=" and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=m.cod_material)as devoluciones,";
    /* --------------------   CUARENTENA ----------------------*/
    sql_exp+=" (select SUM(iade.cantidad_restante)";
    sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
    sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
//if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
//else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
    sql_exp+=" and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"')as cuarentena,";
    /* --------------------   RECHAZADO ----------------------*/
    sql_exp+=" (select SUM(iade.cantidad_restante)";
    sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
    sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
//if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
//else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
    sql_exp+=" and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"')as rechazado,";
    /* --------------------   VENCIDO ----------------------*/
    sql_exp+=" (select SUM(iade.cantidad_restante)";
    sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
    sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
//if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
//else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
    sql_exp+=" and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"'  )as vencido,";
    /* --------------------   OBSOLETO ----------------------*/
    sql_exp+=" (select SUM(iade.cantidad_restante)";
    sql_exp+=" from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
    sql_exp+=" WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
//if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
//else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
    sql_exp+=" and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<='"+fecha_existencia+"')as obsoleto,";
    sql_exp+=" (select sum (rd.CANTIDAD ) from RESERVA r,RESERVA_DETALLE rd " ;
    sql_exp+=" where r.NRO_OP=rd.NRO_OP and rd.COD_MATERIAL = m.COD_MATERIAL) as reserva" ;
    sql_exp+=" from materiales m,grupos g,capitulos c,UNIDADES_MEDIDA u" ;
    sql_exp+=" where m.cod_grupo=g.cod_grupo and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and u.cod_unidad_medida=m.cod_unidad_medida  ";
    sql_exp+=items;
    sql_exp+=" order by m.nombre_material";
    System.out.println("sql_expAjax:"+sql_exp);
/*AQ_stockmateriales.SQL.Add(sql_1+sql_2);
if(rbt_con.Checked=true)then sql_exp+="and  m.movimiento_item=1";
if(rbt_sin.Checked=true)then sql_exp+="and  m.movimiento_item=2";
sql_exp+=" and m.nombre_material like ''%'+edt_nombrematerial.Text+'%''";
 
sql_exp+=" and m.cod_estado_registro=1 order by m.nombre_material,c.nombre_capitulo,g.nombre_grupo";
//edit1.Text:=AQ_stockmateriales.SQL.Text;
AQ_stockmateriales.Open;
//             Edit1.Text:=AQ_stockmateriales.SQL.Text;
 
    */     %>
<DIV ALIGN="CENTER" CLASS="outputText2">
    <br>
    <br>
    <input type="hidden" id="item" name="item" value="<%=items%>">
    <input type="hidden" id="cod_prog" name="cod_prog" value="<%=cod_prog_prod%>">
    <table width="85%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="1" cellspacing="1">
        <tr class="headerClassACliente">  
            <th  align="center" style="border : solid #f2f2f2 1px;">Nro</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Material</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Stock Min</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Stock Max</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Stock Seg</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Unid. Med.</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Prom Mensual</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Aprob</th>
            <%--th  align="center" style="border : solid #f2f2f2 1px;">Salidas</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Devol</th--%>
            <th  align="center" style="border : solid #f2f2f2 1px;">Cuar</th>
            <%--th  align="center" style="border : solid #f2f2f2 1px;">Rech</th--%>
            <th  align="center" style="border : solid #f2f2f2 1px;">Venc</th>
            <%--th  align="center" style="border : solid #f2f2f2 1px;">Obsoletos</th--%>
            <th  align="center" style="border : solid #f2f2f2 1px;">Reserva</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Disponible</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">A Utilizar Prod.</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Diferencia</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Pedido</th>
            <th  align="center" style="border : solid #f2f2f2 1px;">Tránsito</th>
            
            
        </tr>  
        <%
        Statement st2= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs2 = st2.executeQuery(sql_exp);
        int count=0;
        while(rs2.next()){
            System.out.println("erer");
            String codMaterial=rs2.getString(1);
            double stockMinimo=rs2.getDouble(2);
            stockMinimo=redondear(stockMinimo,3);
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat)nf;
            form.applyPattern("#,###.00");
            String stock_minimo=form.format(stockMinimo);
            double stockMaximo=rs2.getDouble(3);
            stockMaximo=redondear(stockMaximo,3);
            String stock_maximo=form.format(stockMaximo);
            double stockSeguridad=rs2.getDouble(4);
            stockSeguridad=redondear(stockSeguridad,3);
            String stock_segu=form.format(stockSeguridad);
            String cod_unidadMedida=rs2.getString(5);
            String nombreMaterial=rs2.getString(6);
            String nombreUnidadMedida=rs2.getString(7);
            double aprobados=rs2.getDouble(8);
            aprobados=redondear(aprobados,3);
            double salidas=rs2.getDouble(9);
            salidas=redondear(salidas,3);
            String salida=form.format(salidas);
            double devoluciones=rs2.getDouble(10);
            devoluciones=redondear(devoluciones,3);
            String devolucion=form.format(devoluciones);
            double cuarentena=rs2.getDouble(11);
            cuarentena=redondear(cuarentena,3);
            String cuaren=form.format(cuarentena);
            double rechazado=rs2.getDouble(12);
            rechazado=redondear(rechazado,3);
            String recha=form.format(rechazado);
            double vencido=rs2.getDouble(13);
            vencido=redondear(vencido,3);
            String venc=form.format(vencido);
            double obsoleto=rs2.getDouble(14);
            obsoleto=redondear(obsoleto,3);
            String obso=form.format(obsoleto);
            double reserva=rs2.getDouble(15);
            reserva=redondear(reserva,3);
            String reser=form.format(reserva);
            double total=aprobados-salidas+devoluciones-rechazado-vencido-obsoleto-reserva;
            total=redondear(total,3);
            String disponible=form.format(total);
            aprobados=aprobados-salidas+devoluciones-rechazado-vencido-obsoleto-reserva-cuarentena;
            aprobados=redondear(aprobados,3);
            String aprob=form.format(aprobados);
            count++;
            sql4="select r.CANTIDAD from RESERVA_DETALLE r " ;
            sql4+=" where r.NRO_OP in ("+cod_prog_prod+") and r.COD_MATERIAL='"+codMaterial+"' " ;
            System.out.println("sql4:"+sql4);
            st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs4 = st4.executeQuery(sql4);
            double cantReservado=0;
            while(rs4.next()){
                cantReservado=rs4.getDouble(1);
            }
            sql4="select ppd.COD_MATERIAL,sum(ppd.CANTIDAD) from PROGRAMA_PRODUCCION_DETALLE ppd";
            sql4+=" where ppd.COD_PROGRAMA_PROD in ("+cod_prog_prod+") and ppd.cod_material='"+codMaterial+"'  group by ppd.cod_material";
            System.out.println("sql4:"+sql4);
            st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs4 = st4.executeQuery(sql4);
            double cantidadProd=0;
            String produccion="";
            while(rs4.next()){
                cantidadProd=rs4.getDouble(2);
                cantidadProd=redondear(cantidadProd,2);
                cantidadProd=cantidadProd-cantReservado;
                produccion=form.format(cantidadProd);
                System.out.println("entrro cantidad:"+cantidadProd);
                
            }
            sql4="select oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,";
            sql4+=" precio_unitario,cantidad_neta,um.NOMBRE_UNIDAD_MEDIDA";
            sql4+=" from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um";
            sql4+=" where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA = 13 AND";
            sql4+=" oc.ESTADO_SISTEMA = 1 and oc.FECHA_ENTREGA>='"+fechaInicio+"' AND oc.FECHA_ENTREGA<='"+fechaFinal+"' AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and";
            sql4+=" cod_material='"+codMaterial+"'  order by oc.FECHA_EMISION asc";
            System.out.println("sql4:"+sql4);
            st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs4 = st4.executeQuery(sql4);
            double cantidad_neta=0;
            String unidad_medida="";
            int cod_unidad_medida_pedido=0;
            String pedido="";
            while(rs4.next()){
                cod_unidad_medida_pedido=rs4.getInt(4);
                cantidad_neta=rs4.getDouble(6);
                unidad_medida=rs4.getString(7);
                
                double equivalencia=compara(Integer.parseInt(cod_unidadMedida),cod_unidad_medida_pedido);
                cantidad_neta=cantidad_neta*equivalencia;
                cantidad_neta=redondear(cantidad_neta,3);
                pedido=form.format(cantidad_neta);
                System.out.println("entor cantidad:"+cantidad_neta);
            }
            sql4="select oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,";
            sql4+=" precio_unitario,cantidad_neta-cantidad_ingreso_almacen,um.NOMBRE_UNIDAD_MEDIDA";
            sql4+=" from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um";
            sql4+=" where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA in (5,6) AND";
            sql4+=" oc.ESTADO_SISTEMA = 1 and oc.FECHA_ENTREGA>='"+fechaInicio+"' AND oc.FECHA_ENTREGA<='"+fechaFinal+"' AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and";
            sql4+=" cod_material='"+codMaterial+"'  order by oc.FECHA_EMISION asc";
            System.out.println("sql4:"+sql4);
            st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            rs4 = st4.executeQuery(sql4);
            double cantidad_neta_transito=0;
            String unidad_medida_transito="";
            int cod_unidad_medida_compra=0;
            String transito="";
            while(rs4.next()){
                cod_unidad_medida_compra=rs4.getInt(4);
                cantidad_neta_transito=rs4.getDouble(6);
                unidad_medida_transito=rs4.getString(7);
                double equivalencia=compara(Integer.parseInt(cod_unidadMedida),cod_unidad_medida_compra);
                cantidad_neta_transito=cantidad_neta_transito*equivalencia;
                cantidad_neta_transito=redondear(cantidad_neta_transito,3);
                transito=form.format(cantidad_neta_transito);
                System.out.println("entor cantidad:"+cantidad_neta_transito);
            }
            
            double prom_mensual=0,sum_promedio=0;
            
            if(sw_promedio==1){
                sql4=" select sum(sad.cantidad_salida_almacen) as cantidad_salida_almacen,sad.cod_unidad_medida,";
                sql4+=" month (fecha_salida_almacen),year (fecha_salida_almacen)";
                sql4+=" from salidas_almacen sa,SALIDAS_ALMACEN_DETALLE sad";
                sql4+=" where sa.cod_salida_almacen = sad.cod_salida_almacen and sad.cod_material = '"+codMaterial+"'  and sa.cod_almacen=1 and";
                sql4+=" sa.cod_estado_salida_almacen = 1 and fecha_salida_almacen >= '"+fechaInicioPromedio+"' and  fecha_salida_almacen <= '"+fechaFinalPromedio+"'";
                sql4+=" group by sad.cod_unidad_medida,month (fecha_salida_almacen),year (fecha_salida_almacen)";
                sql4+=" order by sad.cod_unidad_medida,month (fecha_salida_almacen),year (fecha_salida_almacen)";
                System.out.println("sql4 PROMEDIO:"+sql4);
                st4= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                rs4 = st4.executeQuery(sql4);
                int cod_unidad_medida_prom=0;
                while(rs4.next()){
                    sum_promedio=sum_promedio+rs4.getFloat(1);
                    System.out.println("sum_promedio1:"+rs4.getFloat(1));
                    double equivalencia=compara(Integer.parseInt(cod_unidadMedida),rs4.getInt(2));
                    sum_promedio=sum_promedio*equivalencia;
                    sum_promedio=redondear(sum_promedio,3);
                    System.out.println("sum_promedio2:"+sum_promedio);
                }
                prom_mensual=sum_promedio/meses_promedio;
                prom_mensual=redondear(prom_mensual,2);
                System.out.println("sum_promedio:"+sum_promedio);
                System.out.println("meses_promedio:"+meses_promedio);
                System.out.println("prom_mensual:"+prom_mensual);
            }
        %>
        
        <tr >
            <td   style="border : solid #f2f2f2 1px;"><%=count%></td>
            <td   style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_minimo%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_maximo%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_segu%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=nombreUnidadMedida%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=form.format(prom_mensual)%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=aprob%></td>
            <%--td  align="right" style="border : solid #f2f2f2 1px;"><%=salida%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=devolucion%></td--%>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=cuaren%></td>
            <%--td align="right" style="border : solid #f2f2f2 1px;"><%=recha%></td--%>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=venc%></td>
            <%--td  align="right" style="border : solid #f2f2f2 1px;"><%=obso%></td--%>
            <td  align="right" style="border : solid #f2f2f2 1px;"><%=reser%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;"  ><%=disponible%></td>
            <td  align="right" style="border : solid #f2f2f2 1px;" ><%=produccion%></td>
            <%
            double diferencia=total-cantidadProd;
            diferencia=redondear(diferencia,2);
            String diference=form.format(diferencia);
            if(total<cantidadProd){
            %>
            <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#FC8585"><%=diference%></td>
            <%
            }else{
            %>
            <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#F5D2F3"><%=diference%></td>
            <%
            }
            %>
            <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#CDF6F8"><%=pedido%></td>
            
            <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#B4F5B6"><%=transito%></td>
            
        </tr>
        <%
        }
} catch(SQLException e) {
    e.printStackTrace();
}   
        %> 
    </table>
</div>
<!-- </div>
        </form>
    </body>
</html>
<script language="JavaScript">
	
</script>
-->