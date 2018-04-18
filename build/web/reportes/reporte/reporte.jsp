<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.util.*"%>
<%@ page import="com.cofar.bean.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="org.joda.time.DateTime"%>
<script  type="text/javascript">
    function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                       
    }
</script>
<%!
public int cantidadFilas(String nombreProdSemiterminado,String codLoteProduccion,String nombreAreaEmpresa,List reporte){
        int cantidadFilas = 0;
        Iterator i = reporte.iterator();
        System.out.println(" nombreProdSemiterminado "+nombreProdSemiterminado + " codLoteProduccion " +  codLoteProduccion + " nombreAreaEmpresa " +  nombreAreaEmpresa);
        while(i.hasNext()){
            HashMap f = (HashMap) i.next();
            //System.out.println(f.get("nombreProdSemiterminado")+" " + nombreProdSemiterminado+" "+ f.get("codLoteProduccion")+ " " + codLoteProduccion + " " + f.get("nombreAreaEmpresaCp") + " " + nombreAreaEmpresa);
            if(f.get("nombreProdSemiterminado").equals(nombreProdSemiterminado) && f.get("codLoteProduccion").equals(codLoteProduccion)&&f.get("nombreAreaEmpresaCp").equals(nombreAreaEmpresa)){
                cantidadFilas = cantidadFilas +1;
                //break;
            }
        }
        System.out.println("cantidad filas " + cantidadFilas);
        return cantidadFilas;
    }
public double cantidadEnvAcond(int codCompProd,String codLoteProduccion){
    double cantEnviada = 0.0;
    try{
        String consulta = " select sum(i.CANT_INGRESO_PRODUCCION) enviados_acond" +
                "     from PROGRAMA_PRODUCCION ppr" +
                "     inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria on" +
                "     ppr.COD_PROGRAMA_PROD = ppria.COD_PROGRAMA_PROD and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION and ppr.COD_COMPPROD = ppria.COD_COMPPROD and" +
                "     ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA and" +
                "     ppr.COD_TIPO_PROGRAMA_PROD = ppria.COD_TIPO_PROGRAMA_PROD" +
                "     inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppria.COD_INGRESO_ACOND" +
                "     inner join INGRESOS_DETALLEACOND i on ia.COD_INGRESO_ACOND = i.COD_INGRESO_ACOND and ppria.COD_LOTE_PRODUCCION = i.COD_LOTE_PRODUCCION" +
                "     and i.COD_COMPPROD = ppria.COD_COMPPROD" +
                "     where ppria.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and ppria.COD_COMPPROD = '"+codCompProd+"' and ia.COD_ESTADO_INGRESOACOND <> 2 ";
        System.out.println("consulta " + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnviada = rs.getDouble("enviados_acond");
        }
    }catch(Exception e){e.printStackTrace();}
    return cantEnviada;
}
public double cantidadEnvAPT(int codCompProd,String codLoteProduccion){
    double cantEnviada = 0.0;
    try{
        String consulta = " select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT" +
                " from SALIDAS_ACOND sa" +
                " inner join SALIDAS_DETALLEACOND sd on sa.COD_SALIDA_ACOND =  sd.COD_SALIDA_ACOND" +
                " where sa.COD_ALMACEN_VENTA in ( select av.COD_ALMACEN_VENTA" +
                " from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA = 1" +
                " ) and sd.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sd.COD_COMPPROD = '"+codCompProd+"'" +
                " and sa.COD_ESTADO_SALIDAACOND not in (2)";
        System.out.println("consulta " + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnviada = rs.getDouble("cantidadEnviadaAPT");
        }
    }catch(Exception e){e.printStackTrace();}
    return cantEnviada;
}
%>


<%
            try {
                Connection con = null;
                con = Util.openConnection(con);
            DecimalFormat formato=null;
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            formato = (DecimalFormat) numeroformato;
            formato.applyPattern("###0.00;(###0.00)");
            DateTime fechaInicio1= new DateTime();
            DateTime fechaFinal1 = new DateTime();
			fechaInicio1= fechaInicio1.minusDays(2);//2            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
 SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy");            String consulta = " select ae.nombre_area_empresa,p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada,envAPT1.cantidadEnviadaAPT" +
                    " from programa_produccion p inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa " +
                    " cross apply( select sum(datediff(second,s.FECHA_INICIO,s.FECHA_FINAL))/60.0/60.0 horas_hombre,sum(s.UNIDADES_PRODUCIDAS) unidades_producidas" +
                    "     ,sum(s.UNIDADES_PRODUCIDAS_EXTRA)unidades_producidas_extra,sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    "     from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    "     inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    "     and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "     and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "     and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA " +
                    "     inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                    "     and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1" +
                    "     inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    "     inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "     where s.FECHA_INICIO between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    "     and s.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59 '" +
                    "     and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                    "     and s.COD_COMPPROD = p.COD_COMPPROD" +
                    "     and s.COD_FORMULA_MAESTRA =p.COD_FORMULA_MAESTRA" +
                    "     and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    "     and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui " +
                    " cross apply (select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviada"+
                    " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                    " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                    " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                    " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                    " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT" +
                    " cross apply( select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                          " and sd.COD_LOTE_PRODUCCION=p.cod_lote_produccion and sd.COD_COMPPROD=p.cod_compprod and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2)) envAPT1 " +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION " +
                    " in (select distinct sp.COD_LOTE_PRODUCCION " +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp where sp.FECHA_INICIO" +
                    " between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59'" +
                    " and sp.FECHA_FINAL between '"+sdf.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf.format(fechaFinal1.toDate())+" 23:59:59') and segui.horas_hombre >0 order by ae.nombre_area_empresa";
            System.out.println("consulta " + consulta);
            consulta = "select nombre_area_empresa_cp, COD_LOTE_PRODUCCION,  sum(horas_hombre),   sum(unidades_producidas),  sum(unidades_producidas_extra)," +
                    "      sum(horas_maquina),       nombre_prod_semiterminado,       nombre_area_empresa_actv from (select ae.nombre_area_empresa nombre_area_empresa_cp," +
                    "       p.COD_LOTE_PRODUCCION,      segui.horas_hombre,       segui.unidades_producidas,       segui.unidades_producidas_extra,       segui.horas_maquina," +
                    "       cp1.nombre_prod_semiterminado,       ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actvfrom programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod     inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD" +
                    " and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION" +
                    " and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD" +
                    "            and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    "            and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    "            inner join ACTIVIDADES_FORMULA_MAESTRA afm on" +
                    "            afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and" +
                    "            afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and" +
                    "            afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    "            inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1            inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    "       where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "             and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and             s.COD_COMPPROD = p.COD_COMPPROD and" +
                    "             s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and             s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and" +
                    "             s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD     ) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and      p.COD_LOTE_PRODUCCION in (                                 select distinct sp.COD_LOTE_PRODUCCION" +
                    "                                 from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL             sp" +
                    "            where  sp.FECHA_INICIO >=                                 '2014/02/01 00:00:00' and                                       sp.FECHA_FINAL <= '2014/02/13 23:59:59'" +
                    "      ) and      segui.horas_hombre > 0      and afm1.COD_AREA_EMPRESA in(96,84,102,1003)" +
                    ")      as tabla group by nombre_area_empresa_cp,       COD_LOTE_PRODUCCION,       nombre_prod_semiterminado,       NOMBRE_AREA_EMPRESA_actv ";

            consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    "nombre_area_empresa_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    "segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    "ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA,afm1.orden_actividad " +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/02/01 00:00:00' and s.FECHA_FINAL <= '2014/02/28 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/02/26 00:00:00' and sp.FECHA_FINAL <= '2014/02/27 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96,84,102,1003,40,75,76,84,96,97,1001))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,NOMBRE_AREA_EMPRESA_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " order by cod_lote_produccion,orden_actividad ";
            /*consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
                    " sum(unidades_producidas_extra) unidades_producidas_extra, sum(horas_maquina) horas_maquina,nombre_prod_semiterminado," +
                    " nombre_area_empresa_actv,cod_area_empresa_actv,sum(horas_maquina_std) horas_maquina_std,sum(horas_hombre_std) horas_hombre_std,cod_compprod,cod_formula_maestra,cod_programa_prod" +
                    " from ( select ae.nombre_area_empresa nombre_area_empresa_cp, p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas," +
                    " segui.unidades_producidas_extra,segui.horas_maquina, cp1.nombre_prod_semiterminado," +
                    " ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,ae1.cod_area_empresa cod_area_empresa_actv,maf.HORAS_HOMBRE horas_hombre_std,maf.HORAS_MAQUINA horas_maquina_std," +
                    " apr.NOMBRE_ACTIVIDAD,afm1.COD_ACTIVIDAD_FORMULA,afm1.orden_actividad,cp1.cod_compprod,f.cod_formula_maestra,p.cod_programa_prod " +
                    " from programa_produccion p" +
                    " inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod" +
                    " inner join areas_empresa ae on ae.cod_area_empresa = cp1.cod_area_empresa" +
                    " inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD and f.COD_ESTADO_REGISTRO = 1" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA" +
                    " inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD = afm1.COD_ACTIVIDAD" +
                    " inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA = afm1.COD_AREA_EMPRESA" +
                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1" +
                    " cross apply( select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0 / 60.0 horas_hombre," +
                    " sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra," +
                    " sum(sppr.HORAS_MAQUINA) horas_maquina" +
                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s" +
                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on sppr.COD_COMPPROD = s.COD_COMPPROD and sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA" +
                    " and sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD" +
                    " and sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA" +
                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA" +
                    " inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD = afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1" +
                    " inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL" +
                    " where s.FECHA_INICIO >= '2014/05/05 00:00:00' and s.FECHA_FINAL <= '2014/05/06 23:59:59'" +
                    " and s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and s.COD_COMPPROD = p.COD_COMPPROD" +
                    " and s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                    " and s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD) segui" +
                    " where p.COD_TIPO_PROGRAMA_PROD = 1 and p.COD_LOTE_PRODUCCION" +
                    " in (select distinct sp.COD_LOTE_PRODUCCION from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sp" +
                    " where  sp.FECHA_INICIO >= '2014/05/05 00:00:00' and sp.FECHA_FINAL <= '2014/05/06 23:59:59') and segui.horas_hombre > 0" +
                    " and afm1.COD_AREA_EMPRESA in(96, 84, 102, 1003,97,76))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,nombre_area_empresa_actv,cod_area_empresa_actv,cod_compprod,cod_formula_maestra,cod_programa_prod,cod_lote_produccion" +
                    "  order by cod_lote_produccion,case when COD_AREA_EMPRESA_actv = 76 then 1" +
                    "  when COD_AREA_EMPRESA_actv =, 97 then 2" +
                    "  when COD_AREA_EMPRESA_actv = 96 then 3" +
                    "  when COD_AREA_EMPRESA_actv = 84 then 4  else 100 end  ";*/
                    //" order by cod_lote_produccion ";
            consulta = "	select nombre_area_empresa_cp,	"+
                        "	       COD_LOTE_PRODUCCION,	"+
                        "	       sum(horas_hombre) horas_hombre,	"+
                        "	       sum(unidades_producidas) unidades_producidas,	"+
                        "	       sum(unidades_producidas_extra) unidades_producidas_extra,	"+
                        "	       sum(horas_maquina) horas_maquina,	"+
                        "	       cod_compprod," +
                        "          nombre_prod_semiterminado,	"+
                        "	       nombre_area_empresa_actv,	"+
                        "	       cod_area_empresa_actv,	"+
                        "	       sum(horas_maquina_std) horas_maquina_std,	"+
                        "	       sum(horas_hombre_std) horas_hombre_std	"+
                        "	from (	"+
                        "	       select ae.nombre_area_empresa nombre_area_empresa_cp,	"+
                        "	              p.COD_LOTE_PRODUCCION,	"+
                        "	              segui.horas_hombre,	"+
                        "	              segui.unidades_producidas,	"+
                        "	              segui.unidades_producidas_extra,	"+
                        "	              segui.horas_maquina," +
                        "                 cp1.cod_compprod,	"+
                        "	              cp1.nombre_prod_semiterminado,	"+
                        "	              ae1.NOMBRE_AREA_EMPRESA nombre_area_empresa_actv,	"+
                        "	              ae1.COD_AREA_EMPRESA cod_area_empresa_actv,	"+
                        "	              maf.HORAS_HOMBRE horas_hombre_std,	"+
                        "	              maf.HORAS_MAQUINA horas_maquina_std,	"+
                        "	              apr.NOMBRE_ACTIVIDAD,	"+
                        "	              afm1.COD_ACTIVIDAD_FORMULA,	"+
                        "	              afm1.orden_actividad	"+
                        "	       from programa_produccion p	"+
                        "	            inner join componentes_prod cp1 on cp1.cod_compprod = p.cod_compprod	"+
                        "	            inner join areas_empresa ae on ae.cod_area_empresa =	"+
                        "	            cp1.cod_area_empresa	"+
                        "	            inner join FORMULA_MAESTRA f on f.COD_COMPPROD = cp1.COD_COMPPROD	"+
                        "	            and f.COD_ESTADO_REGISTRO = 1	"+
                        "	            inner join ACTIVIDADES_FORMULA_MAESTRA afm1 on	"+
                        "	            afm1.COD_FORMULA_MAESTRA = f.COD_FORMULA_MAESTRA	"+
                        "	            inner join ACTIVIDADES_PRODUCCION apr on apr.COD_ACTIVIDAD =	"+
                        "	            afm1.COD_ACTIVIDAD	"+
                        "	            inner join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA =	"+
                        "	            afm1.COD_AREA_EMPRESA "+
                        "	            left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on	"+
                        "	            maf.COD_ACTIVIDAD_FORMULA = afm1.COD_ACTIVIDAD_FORMULA and	"+
                        "	            maf.COD_ESTADO_REGISTRO = 1	"+
                        "	            cross apply	"+
                        "	            (	"+
                        "	              select sum(datediff(second, s.FECHA_INICIO, s.FECHA_FINAL)) / 60.0	"+
                        "	              / 60.0 horas_hombre,	"+
                        "	                     sum(s.UNIDADES_PRODUCIDAS) unidades_producidas,	"+
                        "	                     sum(s.UNIDADES_PRODUCIDAS_EXTRA) unidades_producidas_extra,	"+
                        "	                     sum(sppr.HORAS_MAQUINA) horas_maquina	"+
                        "	              from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s	"+
                        "	                   inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr on	"+
                        "	                   sppr.COD_COMPPROD = s.COD_COMPPROD and	"+
                        "	                   sppr.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and	"+
                        "	                   sppr.COD_LOTE_PRODUCCION = s.COD_LOTE_PRODUCCION and	"+
                        "	                   sppr.COD_TIPO_PROGRAMA_PROD = s.COD_TIPO_PROGRAMA_PROD and	"+
                        "	                   sppr.COD_PROGRAMA_PROD = s.COD_PROGRAMA_PROD and	"+
                        "	                   sppr.COD_ACTIVIDAD_PROGRAMA = s.COD_ACTIVIDAD_PROGRAMA	"+
                        "	                   inner join ACTIVIDADES_FORMULA_MAESTRA afm on	"+
                        "	                   afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA and	"+
                        "	                   afm.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and	"+
                        "	                   afm.COD_ESTADO_REGISTRO = 1 and afm.COD_ACTIVIDAD_FORMULA =	"+
                        "	                   afm1.COD_ACTIVIDAD_FORMULA	"+
                        "	                   inner join ACTIVIDADES_PRODUCCION a on a.COD_ACTIVIDAD =	"+
                        "	                   afm.COD_ACTIVIDAD and a.COD_ESTADO_REGISTRO = 1	"+
                        //"	                   inner join personal pe on pe.COD_PERSONAL = s.COD_PERSONAL	"+
                        "	              where " +
 //                       "s.FECHA_INICIO >= '2014/02/01 00:00:00' and	"+
 //                       "	                    s.FECHA_FINAL <= '2014/02/28 23:59:59' and	"+
                        "	                    s.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION and	"+
                        "	                    s.COD_COMPPROD = p.COD_COMPPROD and	"+
                        "	                    s.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and	"+
                        "	                    s.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD and	"+
                        "	                    s.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD	"+
                        "	            ) segui	"+
                        "	       where 	"+ //p.COD_TIPO_PROGRAMA_PROD = 1 and
                        "	             p.COD_LOTE_PRODUCCION in " +
                        "   (select distinct iad.COD_LOTE_PRODUCCION from INGRESOS_ACOND ia" +
                        " inner join INGRESOS_DETALLEACOND iad on iad.COD_INGRESO_ACOND = ia.COD_INGRESO_ACOND" +
                        " inner join SALIDAS_DETALLEINGRESOACOND sd on sd.COD_COMPPROD = iad.COD_COMPPROD and sd.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI = iad.COD_LOTE_PRODUCCION " +
                        " and sd.COD_INGRESO_ACOND = iad.COD_INGRESO_ACOND" +
                        " inner join SALIDAS_DETALLEACOND sad on sad.COD_LOTE_PRODUCCION = sd.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI and sad.COD_COMPPROD = sd.COD_COMPPROD" +
                        " and sad.COD_SALIDA_ACOND = sd.COD_SALIDA_ACOND" +
                        " inner join SALIDAS_ACOND sa on sa.COD_SALIDA_ACOND = sad.COD_SALIDA_ACOND" +
                        " where sa.FECHA_SALIDAACOND between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59'" +
                        " and iad.CANT_RESTANTE=0 ) and	"+
                        "	             segui.horas_hombre > 0 and	"+
                        "	             afm1.COD_AREA_EMPRESA in (96, 84, 102, 1003,40,75,76,84,96,97,1001)" +
                        "	         union all" +
                        "            select top 1 '0','999999999999','0','0','0','0','0','0','0','0','0','0','0','0','0' from programa_produccion"+
                        "	     ) as tabla	"+
                        "	group by nombre_area_empresa_cp,	"+
                        "	         COD_LOTE_PRODUCCION," +
                        "            cod_compprod, "+
                        "	         nombre_prod_semiterminado,	"+
                        "	         NOMBRE_AREA_EMPRESA_actv,	"+
                        "	         cod_Area_empresa_actv	"+
                       "  order by cod_lote_produccion,	"+
                        "	         case	"+
                        "	           when cod_Area_empresa_actv = 76 then 1	"+
                        "	           when cod_area_empresa_actv = 97 then 2	"+
                        "	           when cod_Area_empresa_actv = 96 then 3	"+
                        "	           when cod_Area_empresa_Actv = 84 then 4	"+
                        "	           else 10  "+
                        "	         end";
                        
                      

                        /*	"+
                        "	select distinct ppia.COD_LOTE_PRODUCCION" +
                        "   from" +
                        "   PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia" +
                        "   inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND" +
                        "   where ia.fecha_ingresoacond between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59'	"+*/


            /* "+
                        "	select distinct ppia.COD_LOTE_PRODUCCION" +
                        "   from" +
                        "   PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia" +
                        "   inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND" +
                        "   where ia.fecha_ingresoacond between '"+sdf1.format(fechaInicio1.toDate())+" 00:00:00' and '"+sdf1.format(fechaInicio1.toDate())+" 23:59:59' "+
                        "	              */

            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreProducto = "";
            String codLoteProduccion = "";
            int count = 0;
            //en la primera pasada sacamos los rowspan para el producto y lote
            String detalle = "";
            String reporteLote = "";
            if(rs.next()){
                nombreProducto = rs.getString("nombre_prod_semiterminado");
                codLoteProduccion = rs.getString("cod_lote_produccion");
            }
            rs.beforeFirst();
            double cantidadProducida = 0.0;
            double totalHorasHombreLote = 0.0;
            double totalHorasMaquinaLote = 0.0;
            
            double totalHorasHombreStd = 0.0;
            double totalHorasMaquinaStd = 0.0;
            
            double totalHorasHombre = 0.0;
            double totalHorasMaquina = 0.0;

            double cantUnitariaTotal = 0.0;
            double cantMMTotal = 0.0;
            double cantEstabilidad = 0.0 ;
            double cantCCTotal = 0.0;
            double cantSaldos = 0.0;

            //this.tamLote(rs.getInt("cod_compprod"), codLoteProduccion)*100)

            
            
            while(rs.next()){
                //PRIMERO GUARDAR EL DETALLE Y CONTABILIZAR CADA DETALLE DESPUES GUARDAR CON LA CABEZERA
                //System.out.println("lote repasado " + rs.getString("cod_lote_produccion"));

                if(!(nombreProducto+codLoteProduccion).equals(rs.getString("nombre_prod_semiterminado")+rs.getString("cod_lote_produccion"))){

                    
                    reporteLote += "<tr class='tablaFiltroReporte'><td rowspan='"+count+"' style='border : solid #f2f2f2 1px;'>"+codLoteProduccion+"</td>" +
                                   "<td rowspan='"+count+"' style='border : solid #f2f2f2 1px;'>"+nombreProducto+"</td>"+detalle+"  ";
                    //detalle producto y tiempos
                    

                      cantUnitariaTotal +=   this.cantUnitariaTotal(rs.getInt("cod_compprod"), codLoteProduccion);
                      cantMMTotal +=   this.cantMMTotal(rs.getInt("cod_compprod"), codLoteProduccion);
                      cantEstabilidad +=  this.cantEstabilidadTotal(rs.getInt("cod_compprod"), codLoteProduccion);

                       cantCCTotal += this.cantCCTotal(rs.getInt("cod_compprod"), codLoteProduccion);
                       cantSaldos +=  this.saldos(rs.getInt("cod_compprod"), codLoteProduccion);


                    


                    
                    count = 0;
                    detalle = "";
                    nombreProducto=rs.getString("nombre_prod_semiterminado");
                    
                    
                  }
                if(!codLoteProduccion.equals(rs.getString("cod_lote_produccion"))){
                    reporteLote += "<tr class='tablaFiltroReporte' style='background-color:#f2f2f2'>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:right' colspan=3><b>total</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasHombreLote)+"</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasMaquinaLote)+"</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasHombreStd)+"</b></td>" +
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+formato.format(totalHorasMaquinaStd)+"</b></td>"+
                            " <td style='border : solid #f2f2f2 1px;text-align:center'><b>"+cantidadProducida+"</b></td>" +

                            " <td  align='center' style='border : solid #f2f2f2 1px;' ><b>"+formato.format(( //this.cantEnvAPT(rs.getInt("cod_compprod"), codLoteProduccion)+
                                                                                                                     (cantUnitariaTotal
                                                                                                                    +cantMMTotal
                                                                                                                    +cantEstabilidad
                                                                                                                    +cantCCTotal+cantSaldos)/this.tamLote(rs.getInt("cod_CompProd"), codLoteProduccion)*100));
                                          
                   cantUnitariaTotal=0.0;
                   cantMMTotal = 0.0;
                   cantEstabilidad=0.0;
                   cantCCTotal=0.0;
                   cantSaldos=0.0;
                                                                                                                                                                                                                                                                                                           
                    reporteLote += " ";
                    totalHorasHombreLote = 0.0;
                    totalHorasMaquinaLote = 0.0;
                    totalHorasHombreStd = 0.0;
                    totalHorasMaquinaStd = 0.0;
                    nombreProducto=rs.getString("nombre_prod_semiterminado");
                    codLoteProduccion=rs.getString("cod_lote_produccion");
                }
                 count ++;

                 //if(rs.getInt("cod_Area_empresa_actv")==96)
                 //    cantidadProducida = this.cantidadEnvAcond(rs.getInt("cod_compprod"),rs.getString("cod_lote_produccion"));
                 //if(rs.getInt("cod_Area_empresa_actv")==84)
                     cantidadProducida = this.cantidadEnvAPT(rs.getInt("cod_compprod"),rs.getString("cod_lote_produccion"));
                 //<td  align='center' style='border : solid #f2f2f2 1px;'>"+rs.getString("cod_lote_produccion")+" - "+count+"</td>
                 detalle += "<td  align='center' style='border : solid #f2f2f2 1px;'>"+rs.getString("nombre_area_empresa_actv")+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;'>"+formato.format(rs.getDouble("horas_hombre"))+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina"))+"</td>" +
                    
                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("unidades_producidas_extra"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_hombre_std"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("horas_maquina_std"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' ></td><td></td>" +//"+formato.format(cantidadProducida)+"
                    
                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviadaAPT")/rs.getDouble("horas_hombre"))+"</td>" +
                    "</tr> ";
                 totalHorasHombreLote +=rs.getDouble("horas_hombre");
                 totalHorasMaquinaLote +=rs.getDouble("horas_maquina");
                 totalHorasHombreStd+=rs.getDouble("horas_hombre_std");
                 totalHorasMaquinaStd +=rs.getDouble("horas_maquina_std");
                 
                 
            }

            
            String mensajeCorreo =
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >AREA ETAPA</th>" +
                            
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                              " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >CANT ENV. APT</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >RENDIMIENTO</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >AREA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >ACTIVIDAD</th>" +
                          
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTIVIDAD</th>" +
                            " </tr>"+reporteLote;
            
            mensajeCorreo +="</table><br/><br/><span style='color:blue'>Sistema Atlas</span>";
            //out.print(mensajeCorreo);
            //out.print(mensajeCorreo);
            
            //enviarCorreo("1479,780", mensajeCorreo, "Notificacion de seguimiento Programa Produccion", "Notificacion",con);

%>

<html>
    <body bgcolor="white" style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;'  ><%-- onload="location='../servlets/pdf'" --%>
        <%
        //System.out.println(mensajeCorreo);
        out.print(mensajeCorreo);
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
    </body>
</html>
<%!
double cantEnvAPT(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) cant"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (54,56,57)"+ //select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1
                          " and sd.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and sd.COD_COMPPROD='"+codCompProd+"' and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2) ";
        /*(case when t.COD_TIPO_PROGRAMA_PROD=1 then 54 else 0 end," +
                          " case when t.COD_TIPO_PROGRAMA_PROD=2 then 56 else 0 end," +
                          " case when t.COD_TIPO_PROGRAMA_PROD=3 then 57 else 0 end)*/
        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        con.close();



    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double cantUnitariaTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select sum((p.cantidad_presentacion * id.CANTIDAD) + id.CANTIDAD_UNITARIA) cant "+
                    " from INGRESOS_VENTAS i,   INGRESOS_DETALLEVENTAS id,     PRESENTACIONES_PRODUCTO p "+
                    " where id.COD_INGRESOVENTAS = i.COD_INGRESOVENTAS and "+
                    " id.COD_PRESENTACION = p.cod_presentacion and  i.COD_AREA_EMPRESA = 1 and "+
                    " id.COD_AREA_EMPRESA = 1 and i.COD_ALMACEN_VENTA in (54, 56) and "+
                    " i.FECHA_INGRESOVENTAS <= getdate() "+
                    " and   i.COD_ESTADO_INGRESOVENTAS not in  (2)  and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' "+
                    //sql+=" and id.COD_PRESENTACION="+codPresentacion;
                    " group by id.COD_LOTE_PRODUCCION";
        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        con.close();



    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
double cantMMTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select sum(sad.CANT_TOTAL_SALIDADETALLEACOND),  " +
                            " (select sum((id.CANTIDAD*p.cantidad_presentacion)+id.CANTIDAD_UNITARIA)  from INGRESOS_VENTAS i, INGRESOS_DETALLEVENTAS id, " +
                            " PRESENTACIONES_PRODUCTO p where id.COD_INGRESOVENTAS = i.COD_INGRESOVENTAS and " +
                            " i.COD_AREA_EMPRESA = 1 and i.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA and id.COD_PRESENTACION=p.cod_presentacion " +
                            " and id.COD_AREA_EMPRESA = 1 and i.COD_ALMACEN_VENTA in (57) and i.FECHA_INGRESOVENTAS <= getdate() and " +
                            " id.COD_LOTE_PRODUCCION in ('"+codLoteProduccion+"') and i.COD_ESTADO_INGRESOVENTAS <> 2)as cantidadAPT "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and sad.COD_SALIDA_ACOND in( "+
                    " select  DISTINCT i.COD_SALIDA_ACOND from INGRESOS_VENTAS i,INGRESOS_DETALLEVENTAS id where id.COD_INGRESOVENTAS=i.COD_INGRESOVENTAS "+
                    " and i.COD_AREA_EMPRESA=1 and id.COD_AREA_EMPRESA=1 and i.COD_ALMACEN_VENTA in(57) "+
                    " and i.FECHA_INGRESOVENTAS <= getdate() and id.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' "+
                    " and i.COD_ESTADO_INGRESOVENTAS<>2 ) and sa.COD_ESTADO_SALIDAACOND<>2 group by COD_COMPPROD,COD_LOTE_PRODUCCION,cod_presentacion ";
        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        con.close();
        
    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double cantEstabilidadTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) cant "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(6) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        con.close();



    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double cantCCTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) cant "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACEN_VENTA in (29) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                     
        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        con.close();

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
double cantSaldosTotal(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = "select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) cant "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(4) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";
                    
        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("cant");
        }
        rs.close();
        st.close();
        con.close();

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}

double tamLote(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = "  select sum(cant_lote_produccion) tam_lote_produccion" +
                " from programa_produccion p where p.cod_lote_produccion='"+codLoteProduccion+"' ";

        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("tam_lote_produccion");
        }
        rs.close();
        st.close();
        con.close();

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}
double saldos(int codCompProd,String codLoteProduccion){
    double cantEnvAPT = 0.0;
    try{
        String consulta = " select  (select  c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD=sad.COD_COMPPROD), "+
                    " sad.COD_COMPPROD,sad.COD_LOTE_PRODUCCION,sum(sad.CANT_TOTAL_SALIDADETALLEACOND) "+
                    " from SALIDAS_ACOND sa,SALIDAS_DETALLEACOND sad where sa.COD_SALIDA_ACOND=sad.COD_SALIDA_ACOND and "+
                    " sa.COD_ESTADO_SALIDAACOND<>2  and sa.COD_ALMACENACOND_DESTINO in(4) and  COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and COD_COMPPROD="+codCompProd+" group by COD_COMPPROD,COD_LOTE_PRODUCCION ";

        //System.out.println("consulta ->>>>>>" + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            cantEnvAPT = rs.getDouble("tam_lote_produccion");
        }
        rs.close();
        st.close();
        con.close();

    }catch(Exception e){
        e.printStackTrace();
    }
    return cantEnvAPT;
}




%>



