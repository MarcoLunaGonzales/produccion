package reportes.reporte;

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
            fechaInicio1= fechaInicio1.minusDays(2);
            fechaFinal1=fechaFinal1.minusDays(1);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            String consulta = " select ae.nombre_area_empresa,p.COD_LOTE_PRODUCCION,segui.horas_hombre,segui.unidades_producidas,segui.unidades_producidas_extra,segui.horas_maquina,cp1.nombre_prod_semiterminado,envAPT.cantidadEnviada,envAPT1.cantidadEnviadaAPT" +
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
                    " and afm1.COD_AREA_EMPRESA in(96,84,102,1003))as tabla" +
                    " group by nombre_area_empresa_cp,COD_LOTE_PRODUCCION,nombre_prod_semiterminado,NOMBRE_AREA_EMPRESA_actv,horas_maquina_std,horas_hombre_std,nombre_actividad,cod_actividad_formula,orden_actividad" +
                    " order by cod_lote_produccion,orden_actividad ";
            consulta = " select nombre_area_empresa_cp,COD_LOTE_PRODUCCION,    sum(horas_hombre) horas_hombre,  sum(unidades_producidas) unidades_producidas," +
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
                    "  when COD_AREA_EMPRESA_actv = 97 then 2" +
                    "  when COD_AREA_EMPRESA_actv = 96 then 3" +
                    "  when COD_AREA_EMPRESA_actv = 84 then 4  else 100 end  ";
                    //" order by cod_lote_produccion ";

            System.out.println("consulta " + consulta);
            //con = null;
            //con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate("set dateformat ymd");
            ResultSet rs = st.executeQuery(consulta);
            String nombreAreaEmpresa = "";
            String mensajeCorreo =
                    " Ingeniero:<br/> Se registro la siguiente informacion de seguimiento a programa de produccion con fechas desde "+sdf1.format(fechaInicio1.toDate())+" hasta  "+sdf1.format(fechaFinal1.toDate())+":<br/> "  +
                    "<table  align='center' width='60%' style='text-align:left' style = 'font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 10px;border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>";
            mensajeCorreo += " <tr class='tablaFiltroReporte'>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTO</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >LOTE PRODUCCION</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >UNIDADES PRODUCIDAS EXTRA</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >AREA</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >ACTIVIDAD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS HOMBRE STD</th>" +
                            " <th  align='center' style='border : solid #f2f2f2 1px;' >HORAS MAQUINA STD</th>" +
                            //" <th  align='center' style='border : solid #f2f2f2 1px;' >PRODUCTIVIDAD</th>" +
                            " </tr>";
            List reportes = new ArrayList();
            //cargado de reportes
            while(rs.next()){
                Map f = new HashMap();
                f.put("nombreProdSemiterminado",rs.getString("nombre_prod_semiterminado"));
                f.put("nombreAreaEmpresaCp", rs.getString("nombre_area_empresa_cp"));
                f.put("codLoteProduccion",rs.getString("cod_lote_produccion"));
                f.put("horasHombre",rs.getDouble("horas_hombre"));
                f.put("horasMaquina",rs.getDouble("horas_maquina"));
                f.put("unidadesProducidas",rs.getDouble("unidades_producidas"));
                f.put("unidadesProducidasExtra",rs.getDouble("unidades_producidas_extra"));
                f.put("nombreAreaEmpresaActv",rs.getString("nombre_area_empresa_actv"));
                //f.put("nombreActividad",rs.getString("nombre_actividad"));
                f.put("horasHombreStd",rs.getDouble("horas_hombre_std"));
                f.put("horasMaquinaStd",rs.getDouble("horas_maquina_std"));
                //f.put("codAreaEmpresaActv",rs.getDouble("cod_area_empresa_actv"));
                f.put("codAreaEmpresaActv", rs.getInt("cod_area_empresa_actv"));
                f.put("codCompProd",rs.getInt("cod_compprod"));
                f.put("codFormulaMaestra",rs.getInt("cod_formula_maestra"));
                f.put("codProgramaProd",rs.getInt("cod_programa_prod"));
                reportes.add(f);
                
//                reporte[i][0]= rs.getString("nombre_prod_semiterminado");
//                reporte[i][1]= rs.getString("cod_lote_produccion");
//                reporte[i][2]= rs.getDouble("horas_hombre");
//                reporte[i][3]= rs.getDouble("horas_maquina");
//                reporte[i][4]= rs.getDouble("unidades_producidas");
//                reporte[i][5]= rs.getDouble("unidades_producidas_extra");
//                reporte[i][6]= rs.getString("nombre_area_empresa_actv");
//                reporte[i][7]= rs.getString("nombre_actividad");
//                reporte[i][8]= rs.getDouble("horas_hombre_std");
//                reporte[i][9]= rs.getDouble("horas_maquina_std");
//                i++;
            }
            System.out.println("entro !!!!");
            //impresion de reporte
            Iterator ii = reportes.iterator();

            String codLoteProduccion = "";
            String nombreAreaEmpresaCp = "";
            String nombreProdSemiterminado = "";
            while(ii.hasNext()){
                HashMap f = (HashMap) ii.next();
                
                mensajeCorreo +=
                    " <tr class='tablaFiltroReporte'>";
                if(!codLoteProduccion.equals(f.get("codLoteProduccion").toString()) || !nombreAreaEmpresaCp.equals(f.get("nombreAreaEmpresaCp").toString()) || !nombreProdSemiterminado.equals(f.get("nombreProdSemiterminado").toString())){
                    mensajeCorreo+= " <td  align='center' style='border : solid #f2f2f2 1px;' rowspan = '"+this.cantidadFilas(f.get("nombreProdSemiterminado").toString(), f.get("codLoteProduccion").toString(),f.get("nombreAreaEmpresaCp").toString(), reportes)+"' >"+f.get("nombreProdSemiterminado").toString()+"</td>";
                    mensajeCorreo+= " <td  align='center' style='border : solid #f2f2f2 1px;' rowspan='"+this.cantidadFilas(f.get("nombreProdSemiterminado").toString(), f.get("codLoteProduccion").toString(),f.get("nombreAreaEmpresaCp").toString(), reportes)+"' ><a href='#' onclick=\"openPopup('reporteDetalles.jsf?codCompProd="+f.get("codCompProd").toString()+"&codFormulaMaestra="+f.get("codFormulaMaestra").toString()+"&codProgramaProd="+f.get("codProgramaProd").toString()+"&codLoteProduccion="+f.get("codLoteProduccion").toString()+"&codAreaEmpresaActv="+f.get("codAreaEmpresaActv").toString()+"');return false;\">"+f.get("codLoteProduccion").toString()+"</a></td>";
                    codLoteProduccion = f.get("codLoteProduccion").toString();
                    nombreAreaEmpresaCp= f.get("nombreAreaEmpresaCp").toString();
                    nombreProdSemiterminado=f.get("nombreProdSemiterminado").toString();
                }

                mensajeCorreo+= " <td  align='center' style='border : solid #f2f2f2 1px;'>"+formato.format(f.get("horasHombre"))+"</td>"+
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasMaquina"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("unidadesProducidas"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("unidadesProducidasExtra"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' ><a href='#' onclick=\"openPopup('reporteDetalles1.jsf?codCompProd="+f.get("codCompProd").toString()+"&codFormulaMaestra="+f.get("codFormulaMaestra").toString()+"&codProgramaProd="+f.get("codProgramaProd").toString()+"&codLoteProduccion="+f.get("codLoteProduccion").toString()+"&codAreaEmpresaActv="+f.get("codAreaEmpresaActv").toString()+"');return false;\">"+f.get("nombreAreaEmpresaActv")+"</a></td>" +
                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+f.get("nombreActividad")+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasHombreStd"))+"</td>" +
                    " <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(f.get("horasMaquinaStd"))+"</td>" +
                    //" <td  align='center' style='border : solid #f2f2f2 1px;' >"+formato.format(rs.getDouble("cantidadEnviadaAPT")/rs.getDouble("horas_hombre"))+"</td>" +
                    "</tr>";
            }
            mensajeCorreo +="</table><br/><br/>Sistema Atlas";
            //out.print(mensajeCorreo);
            //out.print(mensajeCorreo);
            
            //enviarCorreo("1479,780", mensajeCorreo, "Notificacion de seguimiento Programa Produccion", "Notificacion",con);

%>

<html>
    <body bgcolor="white"  ><%-- onload="location='../servlets/pdf'" --%>
        <%
        //System.out.println(mensajeCorreo);
        out.print(mensajeCorreo);
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>
    </body>
</html>



