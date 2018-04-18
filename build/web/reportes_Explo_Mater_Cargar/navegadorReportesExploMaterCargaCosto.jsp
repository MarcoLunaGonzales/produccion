<%@ page import = "java.util.Properties" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "java.util.*"%> 
<%@ page import = "java.text.*"%> 
<%@ page import = "java.lang.Math"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.bean.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "java.io.*"%> 
<%@ page import = "javax.faces.context.FacesContext"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "org.joda.time.DateTime"%>
<%@ page import="javazoom.upload.*" %>
<%@ page import= "com.cofar.CostosCompras" %>
<%@ page import= "java.util.Iterator" %>

            
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore"  />
</jsp:useBean>

<%!Connection con = null;
public double costoMaterial(String codMaterial,String codAlmacen){
    double costoMaterial = 0;
    try{
    double costosMaterial = 0.0;
    String consulta = "  select top 1 c.COD_GESTION,  c.COD_MES,  c.COD_MATERIAL,  c.COD_ALMACEN,  c.COSTO_MATERIAL,  c.FECHA,  c.AJUSTE" +
            " from COSTOS_MATERIAL_POR_MES c where " +
            " c.fecha<=getdate() and c.cod_material= '"+codMaterial+"'" +
            " and c.cod_almacen = '"+codAlmacen+"' and c.costo_material>0 order by c.fecha desc ";
    System.out.println("consulta " + consulta);
    Connection con = null;
    con = Util.openConnection(con);
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(consulta);
    if(rs.next()){
        costoMaterial = rs.getDouble("costo_material");
    }
    }catch(Exception e){
        e.printStackTrace();
    }
    return costoMaterial;
}
public int estaValor(String[] materials,String valor){
    int estaValor = 0;
    for(int i=0;i<materials.length;i++)
        {
        if(materials[i].equals(valor)){
            System.out.println("interacion" +materials[i] );
            estaValor = 1;
        }
    }
    return estaValor;
}
public double ingresosAPTPresentacion(String codLoteProduccion,int codPresentacion){
    double ingresosAPT = 0;
    try{
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        String consulta = " select sum( isnull(((isnull(idv.cantidad, 0) * p.cantidad_presentacion) + isnull(idv.cantidad_unitaria, 0)), 0)) as cantidad_total" +
                " from INGRESOS_VENTAS iv,INGRESOS_DETALLEVENTAS idv,     PRESENTACIONES_PRODUCTO p,     ALMACENES_VENTAS av, tipos_ingresoventas t," +
                " tipos_mercaderia tm,lineas_mkt l" +
                " where iv.cod_estado_ingresoventas <> 2 and iv.cod_ingresoventas = idv.cod_ingresoventas " +
                " and iv.cod_tipoingresoventas = t.cod_tipoingresoventas and p.cod_lineamkt = l.cod_lineamkt" +
                " and p.cod_tipomercaderia = tm.cod_tipomercaderia and idv.cod_presentacion = p.cod_presentacion" +
                " and iv.cod_almacen_venta = av.cod_almacen_venta and av.cod_area_empresa = 1" +
                " and p.cod_tipomercaderia in (1, 5, 8) and iv.cod_tipoingresoventas in (2)" +
                " and iv.cod_almacen_venta in (58, 73, 29, 56, 54, 57, 28, 27, 32) and idv.cod_lote_produccion like '%"+codLoteProduccion+"%'" +
                " and idv.COD_PRESENTACION = '"+codPresentacion+"' ";
               System.out.println("consulta " + consulta);
               ResultSet rs = st.executeQuery(consulta);
               if(rs.next()){
                   ingresosAPT = rs.getDouble("cantidad_total");
               }
    }catch(Exception e){e.printStackTrace();}
    return ingresosAPT;
}
%>
<%

System.out.println("path    ");
String path=request.getSession().getServletContext().getRealPath("");
System.out.println("path    "+path);
path+="\\costosExcelVentas";
String name="";
InputStream stream=null;


if (MultipartFormDataRequest.isMultipartFormData(request)) {
    MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
    String todo = null;    
    if (mrequest != null) todo = mrequest.getParameter("todo");
    if ( (todo != null) && (todo.equalsIgnoreCase("upload")) ) {
        Hashtable files = mrequest.getFiles();
        if ( (files != null) && (!files.isEmpty()) ) {
            UploadFile file = (UploadFile) files.get("uploadfile");
            if (file != null){
                name=file.getFileName();
                stream=file.getInpuStream();
                upBean.store(mrequest, "uploadfile");
            }
        }
    }
}

%>


<html>
<head>
    <title>REPORTE  DE  VERIFICACION  BACO  -  ATLAS (Fórmulas Maestras)</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script src="../js/general.js"></script>
</head>
<body>
    
    <div align="center">
    <table width="100%" >
        <tr >
            <td colspan="3" align="center" >
                <h4>Reporte Formula Maestra</h4>
            </td>
        </tr>
        <tr>
            <td align="left"><img src= "../img/cofar.png"></td> 
        </tr>
    </table>
    
    
    <table width="90%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
       <tr>

            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Lote</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Producto</td>
            <td colspan="6" align="center"><b>BACO</b></td>
            <td colspan="3" align="center"><b>ATLAS</b></td>
            <td align="center"><b>DIFERENCIA</b></td>
        </tr>  
        <tr>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td colspan="4"><b>&nbsp;</b></td>
            <td colspan="2"><b>&nbsp;</b></td> 
            <td colspan="2"><b>&nbsp;</b></td>
        </tr>
        <tr>
            
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">&nbsp;</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Unid</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Salidas</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Costo Salidas</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Devoluc.</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Costo Devoluc.</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Neta</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Costo Neto</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Unid</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Materiales Formula Maestra</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Unid</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Cantidad </td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Costo FM </td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Diferencia</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Diferencia %</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Cant. Env APT.</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Dif. Lote Prod. Env. APT</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Dif. Lotes %</td>
            <td align="center" class="outputTextBlanco"  bgcolor="#000000">Dif. Costos</td>
        </tr>
        <%
        /*SACO LOS DATOS DE LA BASE DE DATOS BACO*/
        int resultFila = 0;
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat)nf;
        form.applyPattern("#,###.00;-#,###.00");
            
        con = Util.openConnection(con);
        String porcentajeVariacion  = request.getParameter("porcentajeVariacion");
        System.out.println("porcentaje variacion" + porcentajeVariacion);
        String materiales = request.getParameter("codMaterials");
        String[] materials1 = materiales!=null?materiales.split(","):new String[1];
        System.out.println("entro proceso"+materiales);
        CostosCompras costos=new CostosCompras();
        //InputStream stream=null;
        System.out.println("sqlnnnnnnnnnnnnnnnnnnnnn ----->" + stream);
        List lista=new ArrayList();
        lista = costos.read(path,stream);
        System.out.println("salio");
        Iterator i=lista.iterator();
        System.out.println("nº de registros"+lista.size());
        
        while (i.hasNext()){
            PresentacionSalida bean = (PresentacionSalida)i.next();
            String CODLOTEPRODUCCION = bean.getCodLoteProduccion();  
            String sql  = " SELECT top 1 (select c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD = s.COD_PROD),s.COD_PROD";                    
                   sql += " FROM SALIDAS_ALMACEN s WHERE COD_LOTE_PRODUCCION IN ('"+ CODLOTEPRODUCCION +"') ";
                   sql = " select distinct s.COD_PROD,cp.nombre_prod_semiterminado,fm.cod_formula_maestra," +
                         " (select sum(iad.CANT_INGRESO_PRODUCCION) from INGRESOS_ACOND ia" +
                         " inner join INGRESOS_DETALLEACOND iad on iad.COD_INGRESO_ACOND = ia.COD_INGRESO_ACOND " +
                         " where iad.COD_LOTE_PRODUCCION = s.cod_lote_produccion and iad.COD_COMPPROD = s.cod_prod and ia.COD_TIPOINGRESOACOND = 1 and ia.COD_ALMACENACOND in (1,3) and ia.cod_estado_ingresoacond not in(1,2)) cant_ingreso_produccion,fm.cantidad_lote " +
                         ", ppr.cod_tipo_programa_prod cod_tipo_programa_prod,0 cantidadEnviadaAPT,tppr.nombre_tipo_programa_prod from SALIDAS_ALMACEN s inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = s.COD_PROD" +
                         " inner join formula_maestra fm on fm.cod_compprod = cp.cod_compprod" +
                         " inner join programa_produccion ppr on ppr.cod_compprod = s.cod_prod and ppr.cod_formula_maestra = fm.cod_formula_maestra and ppr.cod_lote_produccion = s.cod_lote_produccion" +
                         " inner join tipos_programa_produccion tppr on tppr.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                         "where s.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' ";
                   
            Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs  = st_1.executeQuery(sql);
            System.out.println("sql ----->" + sql);
            String nombre_prod_semiterminado="";
            String codCompProd = "";
            String codFormulaMaestra = "";
            String codCompProdAnt = "";
            String codLoteProduccionAnt= "";
            while (rs.next()){
                String consulta ="";
                
                    nombre_prod_semiterminado= rs.getString("nombre_prod_semiterminado");
                    codCompProd = rs.getString("cod_prod");
                    codFormulaMaestra = rs.getString("cod_formula_maestra");
                    double cantidadProducida = rs.getDouble("CANT_INGRESO_PRODUCCION");
                    double cantidadLote = rs.getDouble("cantidad_lote");
                    int codTipoProgramaProd = rs.getInt("cod_tipo_programa_prod");
                    double cantEnviadaAPT = rs.getDouble("cantidadEnviadaAPT");
                    String nombreTipoProgramaProd = rs.getString("nombre_tipo_programa_prod");
                        %>
                        <tr>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b><%=CODLOTEPRODUCCION%> </b>   </td>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;"><b><%=nombre_prod_semiterminado%>&nbsp;(<%=nombreTipoProgramaProd%>)  </b> </td>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;" colspan="6"><b><%=cantidadProducida%>  </b> </td>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;" colspan="5"><b><%=cantidadLote%>  </b> </td>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;" ><b>  </b> </td>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;" ><b></b> </td>
                            <td class=colh align="center" style="border : solid #f2f2f2 1px;" ><b></b> </td>
                        </tr>
                <%
                if(estaValor(materials1,"1")==1){
                        consulta = " select distinct fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,ROUND(fmp.CANTIDAD,2),um.abreviatura,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo,e.nombre_estado_registro," +
                                " (select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas from SALIDAS_ALMACEN_DETALLE sd" +
                                " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"'" +
                                " and s.COD_ESTADO_SALIDA_ALMACEN = 1 and s.ESTADO_SISTEMA = 1 and s.COD_PRESENTACION = sa1.COD_PRESENTACION) salidas_material, " +
                                " (select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) " +
                                " from devoluciones d" +
                                " inner join salidas_almacen sa on d.cod_salida_almacen = sa.cod_salida_almacen" +
                                " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = d.cod_almacen" +
                                " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                " where d.estado_sistema = 1 " +
                                " and sa.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa.cod_almacen = '1'" +
                                " and d.cod_almacen = '1' and c.COD_CAPITULO = 2 and ia.cod_estado_ingreso_almacen = 1" +
                                " and d.cod_estado_devolucion = 1 and sa.COD_TIPO_SALIDA_ALMACEN in (1, 2, 4, 5, 6, 8) and m1.cod_material = m.cod_material and sa.COD_PRESENTACION = sa1.COD_PRESENTACION) devoluciones_material " +
                                " from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MP fmp,estados_referenciales e" +
                                " where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA" +
                                " and m.COD_MATERIAL=fmp.COD_MATERIAL  and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                " where g.COD_GRUPO=m1.COD_GRUPO and g.COD_CAPITULO=2) and fm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and m.cod_estado_registro=1" +
                                " and e.cod_estado_registro=m.cod_estado_registro order by m.NOMBRE_MATERIAL ";
                        /*consulta = " select m1.NOMBRE_MATERIAL,um.ABREVIATURA,(select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas" +
                                 " from SALIDAS_ALMACEN_DETALLE sd" +
                                 " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                 " where sd.COD_MATERIAL = sd1.cod_material and s.COD_LOTE_PRODUCCION = s1.COD_LOTE_PRODUCCION" +
                                 " and s.COD_ESTADO_SALIDA_ALMACEN = 1 and s.ESTADO_SISTEMA = 1) salidas_material," +
                                 " (select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d" +
                                 " inner join salidas_almacen sa on d.cod_salida_almacen = sa.cod_salida_almacen" +
                                 " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = d.cod_almacen" +
                                 " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                 " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                 " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                 " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                 " where d.estado_sistema = 1 and sa.COD_LOTE_PRODUCCION = s1.COD_LOTE_PRODUCCION and sa.cod_almacen = '1' " +
                                 " and d.cod_almacen = '1' and c.COD_CAPITULO = 2 and ia.cod_estado_ingreso_almacen = 1" +
                                 " and d.cod_estado_devolucion = 1 and sa.COD_TIPO_SALIDA_ALMACEN in (1, 2, 4, 5, 6, 8)" +
                                 " and m1.cod_material = sd1.cod_material) devoluciones_material from SALIDAS_ALMACEN s1" +
                                 " inner join SALIDAS_ALMACEN_DETALLE sd1 on sd1.COD_SALIDA_ALMACEN = s1.COD_SALIDA_ALMACEN" +
                                 " inner join materiales m1 on m1.COD_MATERIAL = sd1.COD_MATERIAL" +
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = m1.COD_UNIDAD_MEDIDA" +
                                 " where sd1.COD_MATERIAL IN (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                 " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 2) and s1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"'" +
                                 " and s1.COD_PROD = '"+codCompProd+"' and s1.COD_ESTADO_SALIDA_ALMACEN = 1 ";*/
                        consulta = "select nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura_fm,sum(cantidad_fm1) cantidad_fm1,sum(costo_salida) costo_salida" +
                                "from (" +
                                " select distinct m.nombre_material,um.abreviatura, (select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas" +
                                " from SALIDAS_ALMACEN_DETALLE sd" +
                                " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION and s.COD_ESTADO_SALIDA_ALMACEN = 1" +
                                " and s.ESTADO_SISTEMA = 1) salidas_material," +
                                " ( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d" +
                                " inner join salidas_almacen sa on d.cod_salida_almacen = sa.cod_salida_almacen" +
                                " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = d.cod_almacen" +
                                " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                " where d.estado_sistema = 1 and sa.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION" +
                                " and sa.cod_almacen = '1' and d.cod_almacen = '1' and c.COD_CAPITULO = 2" +
                                " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                " and sa.COD_TIPO_SALIDA_ALMACEN in (1, 2, 4, 5, 6, 8) and m1.cod_material = m.cod_material) devoluciones_material,m2.nombre_material nombre_material_fm,fmdmp.cantidad cantidad_fm,um2.abreviatura abreviatura_fm,0 cantidad_fm1" +
                                " from SALIDAS_ALMACEN sa1" +
                                " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida" +
                                " inner join formula_maestra fm on fm.cod_compprod = sa1.cod_prod "  + //and fm.cod_estado_registro = 1
                                " inner join formula_maestra_detalle_mp fmdmp on fmdmp.cod_formula_maestra = fm.cod_formula_maestra and fmdmp.cod_material = m.cod_material " +
                                " inner join materiales m2 on m2.cod_material = fmdmp.cod_material" +
                                " inner join unidades_medida um2 on um2.cod_unidad_medida = fmdmp.cod_unidad_medida " +
                                " where sa1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa1.COD_PROD = '"+codCompProd+"'" +
                                " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 2) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1" +
                                " union" +
                                " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,0,um.ABREVIATURA,fmdmp.cantidad cantidad_fm1 from COMPONENTES_PROD cp inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                " inner join FORMULA_MAESTRA_DETALLE_MP fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA" +
                                " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL" +
                                " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = fmdmp.COD_UNIDAD_MEDIDA" +
                                " where fm.COD_COMPPROD = '"+codCompProd+"'" +
                                " ) as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura_fm ";
                        consulta = "select cod_material,nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura_fm,sum(cantidad_fm1) cantidad_fm1,sum(costo_salida) costo_salida,sum(costo_devolucion) costo_devolucion" +
                                " from (" +
                                " select distinct m.cod_material,m.nombre_material,um.abreviatura, sad.cantidad_salida_almacen salidas_material," +
                                " isnull(( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0))" +
                                " from devoluciones d" +
                                    " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = 1 " +
                                    " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                    " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                    " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                    " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                    " where d.estado_sistema = 1 " +
                                    " and d.cod_almacen = '1' " +
                                    " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                    " and m1.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN),0) devoluciones_material " +
                                ",m.nombre_material nombre_material_fm,0 cantidad_fm,um.abreviatura abreviatura_fm,0 cantidad_fm1," +
                                " (select sum(sadi.CANTIDAD*sadi.COSTO_SALIDA_ACTUALIZADO_FINAL) from SALIDAS_ALMACEN_DETALLE_INGRESO sadi where sadi.COD_SALIDA_ALMACEN = sad.COD_SALIDA_ALMACEN and sadi.COD_MATERIAL = sad.COD_MATERIAL) costo_salida," +
                                " (select sum(iad.CANT_TOTAL_INGRESO_FISICO * iad.COSTO_UNITARIO_ACTUALIZADO)" +
                                " from devoluciones d" +
                                " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion" +
                                " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and iad.COD_MATERIAL = m.cod_material" +
                                " where d.estado_sistema = 1 and d.cod_almacen = '1' and ia.cod_estado_ingreso_almacen = 1" +
                                " and d.cod_estado_devolucion = 1" +
                                " and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN and ia.cod_almacen = '1'" +
                                " and d.cod_salida_almacen = sa1.cod_salida_almacen) costo_devolucion " +
                                " from SALIDAS_ALMACEN sa1" +
                                " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida" +
                                /*" outer apply(select top 1 m2.nombre_material , fmdmp.cantidad ,um2.abreviatura" +
                                " from formula_maestra fm "  + //and fm.cod_estado_registro = 1
                                " inner join formula_maestra_detalle_mp fmdmp on fmdmp.cod_formula_maestra = fm.cod_formula_maestra and fmdmp.cod_material = m.cod_material " +
                                " inner join materiales m2 on m2.cod_material = fmdmp.cod_material" +
                                " inner join unidades_medida um2 on um2.cod_unidad_medida = fmdmp.cod_unidad_medida where fm.cod_compprod = sa1.cod_prod order by fm.COD_FORMULA_MAESTRA desc) fmx" +*/
                                " where sa1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa1.COD_PROD = '"+codCompProd+"'" +
                                " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g  " +
                                " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 2) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1" +
                                " union" +
                                " select m.cod_material,m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,0,um.ABREVIATURA,fmdmp.cantidad cantidad_fm1,0,0 from COMPONENTES_PROD cp inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                " inner join FORMULA_MAESTRA_DETALLE_MP fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA" +
                                " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL" +
                                " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = fmdmp.COD_UNIDAD_MEDIDA" +
                                " where fm.COD_COMPPROD = '"+codCompProd+"' and fm.cod_estado_registro = 1 " +
                                " ) as tabla group by cod_material,nombre_material,abreviatura,nombre_material_fm,abreviatura_fm order by nombre_material";
                        /* (select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas" +
                                " from SALIDAS_ALMACEN_DETALLE sd" +
                                " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION and s.COD_ESTADO_SALIDA_ALMACEN = 1" +
                                " and s.ESTADO_SISTEMA = 1) */
                        System.out.println("consulta MP "  + consulta);
                        Statement st1 = con.createStatement();
                        ResultSet rs1 = st1.executeQuery(consulta);
                        %>
                        <tr>
                                    <td class=colh align="center" style="border : solid #f2f2f2 1px;;text-align:left"><b>Materia Prima</b></td>
                                    <td class=colh align="center" style="border : solid #f2f2f2 1px;"></td>
                        </tr>
                        <%


                        while(rs1.next()){
                            if(codCompProd.equals(codCompProdAnt) && codLoteProduccionAnt.equals(CODLOTEPRODUCCION)){break;}
                            String nombreMaterial = rs1.getString("nombre_material");
                            //String nombreUnidadMedida = rs1.getString("NOMBRE_UNIDAD_MEDIDA");
                            double salidasMaterial = rs1.getDouble("salidas_material");
                            double devolucionesMaterial = rs1.getDouble("devoluciones_material");
                            String abreviatura = rs1.getString("abreviatura");
                            String nombreMaterialFM = rs1.getString("nombre_material_fm")==null?"":rs1.getString("nombre_material_fm");
                            double cantidadFM = rs1.getDouble("cantidad_fm")==0?rs1.getDouble("cantidad_fm1"):rs1.getDouble("cantidad_fm");
                            String abreviaturaFM = rs1.getString("abreviatura_fm")==null?"":rs1.getString("abreviatura_fm");
                            double diferencia = Math.abs((salidasMaterial-devolucionesMaterial) - cantidadFM);
                            double variacion = cantidadFM *Double.valueOf(porcentajeVariacion)/100;
                            String estilo = diferencia>=variacion?"background-color:#F5A9A9":"";
                            double costoSalidaMaterial = rs1.getDouble("costo_salida");
                            double costoDevolucionMaterial = rs1.getDouble("costo_devolucion");
                            String codMaterial = rs1.getString("cod_material");
                            double costoMaterial= this.costoMaterial(codMaterial,"1");
                            costoSalidaMaterial=(costoSalidaMaterial==0?salidasMaterial*costoMaterial:costoSalidaMaterial);
                            costoDevolucionMaterial =(costoDevolucionMaterial==0?devolucionesMaterial*costoMaterial:costoDevolucionMaterial);
                            %>
                            <tr style="<%=estilo%>">
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=nombreMaterial%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviatura%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(salidasMaterial)%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoSalidaMaterial)%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(devolucionesMaterial)%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoDevolucionMaterial)%>    </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(salidasMaterial-devolucionesMaterial)%>    </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoSalidaMaterial-costoDevolucionMaterial)%>    </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviatura%></td>
                                <%--td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=form.format(0)%>   </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(0)%>   </td--%>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=nombreMaterialFM%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviaturaFM%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidadFM)%></td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidadFM*costoMaterial)%></td><%--this.costoMaterial(codMaterial)--%>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format((salidasMaterial-devolucionesMaterial)-cantidadFM)%>    </td>
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=!nombreMaterial.equals("")?form.format(((salidasMaterial-devolucionesMaterial)-cantidadFM)*100/cantidadFM)+"%":""%> </td>
                                <td colspan="3" />
                                <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format((costoSalidaMaterial-costoDevolucionMaterial)-cantidadFM*costoMaterial)%>    </td>
                                <%--td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=0%>    </td--%>
                            </tr>
                            <%
                        }
                }
                    if(this.estaValor(materials1, "2")==1){
                        /* (select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas" +
                                    " from SALIDAS_ALMACEN_DETALLE sd" +
                                    " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                    " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION and s.COD_ESTADO_SALIDA_ALMACEN = 1" +
                                    " and s.ESTADO_SISTEMA = 1)*/
                            consulta = "select nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura,sum(cantidad_fm1) cantidad_fm1 from (" +
                                    " select distinct m.nombre_material,um.abreviatura, sad.cantidad_salida_almacen salidas_material," +
                                    " isnull(( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d" +
                                    " inner join salidas_almacen sa on d.cod_salida_almacen = sa.cod_salida_almacen" +
                                    " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = d.cod_almacen" +
                                    " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                    " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                    " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                    " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                    " where d.estado_sistema = 1 and sa.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION" +
                                    " and sa.cod_almacen = '1' and d.cod_almacen = '1' and c.COD_CAPITULO = 2" +
                                    " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                    " and sa.COD_TIPO_SALIDA_ALMACEN in (1, 2, 4, 5, 6, 8) and m1.cod_material = m.cod_material),0) devoluciones_material,m2.nombre_material nombre_material_fm,fmdmp.cantidad cantidad_fm,um.abreviatura abreviatura_fm,0 cantidad_fm1" +
                                    " from SALIDAS_ALMACEN sa1" +
                                    " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                    " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                    " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida " +
                                    " inner join formula_maestra fm on fm.cod_compprod = sa1.cod_prod " + //and fm.cod_estado_registro = 1
                                    " inner join programa_produccion ppr on ppr.cod_compprod = sa1.cod_prod and ppr.cod_lote_produccion = sa1.cod_lote_produccion" +
                                    " inner join PRESENTACIONES_PRIMARIAS prp on prp.COD_COMPPROD = ppr.COD_COMPPROD and prp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD "  +
                                    " inner join formula_maestra_detalle_ep fmdmp on fmdmp.cod_formula_maestra = fm.cod_formula_maestra and fmdmp.cod_material = m.cod_material and fmdmp.COD_PRESENTACION_PRIMARIA = prp.COD_PRESENTACION_PRIMARIA" +
                                    " inner join materiales m2 on m2.cod_material = fmdmp.cod_material left outer join unidades_medida um2 on um2.cod_unidad_medida = sad.cod_unidad_medida " + //fmdmp.cod_unidad_medida

                                    " where sa1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa1.COD_PROD = '"+codCompProd+"'" +
                                    " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                    " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 3) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1 " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                    " union all " +
                                    " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,0,um.ABREVIATURA,fmdmp.cantidad cantidad_fm1" +
                                    " from programa_produccion ppr inner join COMPONENTES_PROD cp on cp.cod_compprod = ppr.cod_compprod and ppr.cod_lote_produccion = '"+bean.getCodLoteProduccion()+"'" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                    " inner join PRESENTACIONES_PRIMARIAS prp on prp.COD_COMPPROD = ppr.COD_COMPPROD and prp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                    " inner join FORMULA_MAESTRA_DETALLE_EP fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and fmdmp.COD_PRESENTACION_PRIMARIA = prp.COD_PRESENTACION_PRIMARIA " +
                                    " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL" +
                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA" +
                                    " where fm.COD_COMPPROD = '"+codCompProd+"' " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                    " ) as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura ";

                            /*(select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas" +
                                    " from SALIDAS_ALMACEN_DETALLE sd" +
                                    " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                    " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION and s.COD_ESTADO_SALIDA_ALMACEN = 1" +
                                    " and s.ESTADO_SISTEMA = 1)*/
                            consulta = "select cod_material,nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura,sum(cantidad_fm1) cantidad_fm1,sum(costo_salida) costo_salida,sum(costo_devolucion) costo_devolucion" +
                                    " from (" +
                                    " select distinct m.nombre_material,um.abreviatura,sad.cantidad_salida_almacen  salidas_material," +
                                    " isnull(( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d" +
                                        " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = 1 " +
                                        " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                        " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                        " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                        " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                        " where d.estado_sistema = 1 " +
                                        " and d.cod_almacen = '1' " +
                                        " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                        " and m1.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN),0) devoluciones_material" +
                                    ",m.nombre_material nombre_material_fm,0 cantidad_fm,um.abreviatura abreviatura_fm,0 cantidad_fm1,m.cod_material," +
                                    " (select sum(sadi.CANTIDAD*sadi.COSTO_SALIDA_ACTUALIZADO_FINAL) from SALIDAS_ALMACEN_DETALLE_INGRESO sadi where sadi.COD_SALIDA_ALMACEN = sad.COD_SALIDA_ALMACEN and sadi.COD_MATERIAL = sad.COD_MATERIAL) costo_salida," +
                                    " (select sum(iad.CANT_TOTAL_INGRESO_FISICO * iad.COSTO_UNITARIO_ACTUALIZADO)" +
                                " from devoluciones d" +
                                " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion" +
                                " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and iad.COD_MATERIAL = m.cod_material" +
                                " where d.estado_sistema = 1 and d.cod_almacen = '1' and ia.cod_estado_ingreso_almacen = 1" +
                                " and d.cod_estado_devolucion = 1" +
                                " and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN and ia.cod_almacen = '1'" +
                                " and d.cod_salida_almacen = sa1.cod_salida_almacen) costo_devolucion " +
                                    " from SALIDAS_ALMACEN sa1" +
                                    " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                    " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                    " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida " +
                                    /*" outer apply(select top 1 m2.nombre_material,fmdmp.CANTIDAD,um2.ABREVIATURA from formula_maestra fm" +
                                    " inner join programa_produccion ppr on ppr.cod_compprod = sa1.cod_prod and ppr.cod_lote_produccion = sa1.cod_lote_produccion" +
                                    " inner join PRESENTACIONES_PRIMARIAS prp on prp.COD_COMPPROD = ppr.COD_COMPPROD and prp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD" +
                                    " inner join formula_maestra_detalle_ep fmdmp on fmdmp.cod_formula_maestra = fm.cod_formula_maestra and fmdmp.cod_material = m.cod_material " +
                                    " and fmdmp.COD_PRESENTACION_PRIMARIA = prp.COD_PRESENTACION_PRIMARIA" +
                                    " inner join materiales m2 on m2.cod_material = fmdmp.cod_material" +
                                    " inner join unidades_medida um2 on um2.cod_unidad_medida = sad.cod_unidad_medida" +
                                    " where fm.cod_compprod = sa1.cod_prod order by fm.COD_FORMULA_MAESTRA desc) fmx " + //fmdmp.cod_unidad_medida*/
                                    " where sa1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa1.COD_PROD = '"+codCompProd+"'" +
                                    " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                    " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 3) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1 " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                    " union all " +
                                    " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,0,um.ABREVIATURA,fmdmp.cantidad cantidad_fm1,m.cod_material,0,0" +
                                    " from programa_produccion ppr inner join COMPONENTES_PROD cp on cp.cod_compprod = ppr.cod_compprod and ppr.cod_lote_produccion = '"+bean.getCodLoteProduccion()+"'" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                    " inner join PRESENTACIONES_PRIMARIAS prp on prp.COD_COMPPROD = ppr.COD_COMPPROD and prp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                    " inner join FORMULA_MAESTRA_DETALLE_EP fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA and fmdmp.COD_PRESENTACION_PRIMARIA = prp.COD_PRESENTACION_PRIMARIA " +
                                    " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL" +
                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA" +
                                    " where fm.COD_COMPPROD = '"+codCompProd+"' and fm.cod_estado_registro = 1 and prp.cod_tipo_programa_prod = '"+codTipoProgramaProd+"' " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                    " ) as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura,cod_material order by nombre_material";
                            

                            System.out.println("consulta EP "  + consulta);
                            Statement st2 = con.createStatement();
                            ResultSet rs2 = st2.executeQuery(consulta);
                            %>
                            <tr>
                                        <td class=colh align="center" style="border : solid #f2f2f2 1px;;text-align:left"><b>Materia Empaque primario</b></td>
                                        <td class=colh align="center" style="border : solid #f2f2f2 1px;"></td>
                            </tr>
                            <%
                            while(rs2.next()){
                                String nombreMaterial = rs2.getString("nombre_material");
                                //String nombreUnidadMedida = rs1.getString("NOMBRE_UNIDAD_MEDIDA");
                                double salidasMaterial = rs2.getDouble("salidas_material");
                                double devolucionesMaterial = rs2.getDouble("devoluciones_material");
                                String abreviatura = rs2.getString("abreviatura");
                                String nombreMaterialFM = rs2.getString("nombre_material_fm")==null?"":rs2.getString("nombre_material_fm");
                                double cantidadFM = rs2.getDouble("cantidad_fm")==0?rs2.getDouble("cantidad_fm1"):rs2.getDouble("cantidad_fm");
                                String abreviaturaFM = rs2.getString("abreviatura")==null?"":rs2.getString("abreviatura"); //abreviatura_fm
                                double diferencia = Math.abs((salidasMaterial-devolucionesMaterial) - cantidadFM);
                                double variacion = cantidadFM *Double.valueOf(porcentajeVariacion)/100;
                                String estilo = diferencia>=variacion?"background-color:#F5A9A9":"";
                                double costoSalidaMaterial = rs2.getDouble("costo_salida");
                                double costoDevolucionMaterial = rs2.getDouble("costo_devolucion");
                                String codMaterial = rs2.getString("cod_material");
                                double costoMaterial = this.costoMaterial(codMaterial,"1");
                                costoSalidaMaterial=(costoSalidaMaterial==0?salidasMaterial*costoMaterial:costoSalidaMaterial);
                                costoDevolucionMaterial =(costoDevolucionMaterial==0?devolucionesMaterial*costoMaterial:costoDevolucionMaterial);
                                %>
                                <tr style="<%=estilo%>">
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;">&nbsp;    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=nombreMaterial%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviatura%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(salidasMaterial)%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoSalidaMaterial)%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(devolucionesMaterial)%>    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoDevolucionMaterial)%>    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(salidasMaterial-devolucionesMaterial)%>    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoSalidaMaterial-costoDevolucionMaterial)%>    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviatura%></td>

                                    <%--td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=form.format(0)%>   </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(0)%>   </td--%>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=nombreMaterialFM%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviaturaFM%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidadFM)%></td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidadFM*costoMaterial)%></td> <%-- this.costoMaterial(codMaterial) --%>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format((salidasMaterial-devolucionesMaterial)-cantidadFM)%>    </td>
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=!nombreMaterialFM.equals("")?form.format(((salidasMaterial-devolucionesMaterial)-cantidadFM)*100/cantidadFM )+"%":""%> </td>
                                    <td colspan="3" />
                                    <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format((costoSalidaMaterial-costoDevolucionMaterial)-cantidadFM*costoMaterial)%>    </td>
                                    <%--td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=0%>    </td--%>
                                </tr>

                                <%

                            }
                }
                if(this.estaValor(materials1, "3")==1){
                    /* (select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas" +
                                        " from SALIDAS_ALMACEN_DETALLE sd" +
                                        " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                        " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION and s.COD_ESTADO_SALIDA_ALMACEN = 1" +
                                        " and s.ESTADO_SISTEMA = 1 and s.COD_PRESENTACION = sa1.COD_PRESENTACION) */
                                consulta = "select nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura_fm,cod_presentacion,sum(cantidad_fm1) cantidad_fm1,NOMBRE_PRODUCTO_PRESENTACION from (" +
                                        " select distinct m.nombre_material,um.abreviatura,sad.cantidad_salida_almacen  salidas_material," +
                                        " ( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d" +
                                        " inner join salidas_almacen sa on d.cod_salida_almacen = sa.cod_salida_almacen" +
                                        " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = d.cod_almacen" +
                                        " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                        " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                        " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                        " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                        " where d.estado_sistema = 1 and sa.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION" +
                                        " and sa.cod_almacen = '1' and d.cod_almacen = '1' and c.COD_CAPITULO = 2" +
                                        " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                        " and sa.COD_TIPO_SALIDA_ALMACEN in (1, 2, 4, 5, 6, 8) and m1.cod_material = m.cod_material and sa.COD_PRESENTACION = sa1.COD_PRESENTACION) devoluciones_material,m2.nombre_material nombre_material_fm,fmdmp.cantidad cantidad_fm,um2.abreviatura abreviatura_fm,prp.cod_presentacion,0 cantidad_fm1,prp.NOMBRE_PRODUCTO_PRESENTACION" +
                                        "  " +
                                        " from SALIDAS_ALMACEN sa1" +
                                        " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                        " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                        " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida " +
                                        " inner join formula_maestra fm on fm.cod_compprod = sa1.cod_prod " + //and fm.cod_estado_registro = 1
                                        " inner join programa_produccion ppr on ppr.cod_compprod = sa1.cod_prod and ppr.cod_lote_produccion = sa1.cod_lote_produccion and ppr.cod_estado_programa in (1,2,6,7)" +
                                        //" inner join COMPONENTES_PRESPROD cprp on cprp.COD_COMPPROD = ppr.COD_COMPPROD and cprp.COD_PRESENTACION = sa1.COD_PRESENTACION " +
                                        " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = sa1.COD_PRESENTACION " + //cprp.COD_PRESENTACION //and cprp.COD_PRESENTACION = sa1.COD_PRESENTACION and cprp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD
                                        " left outer join formula_maestra_detalle_es fmdmp on fmdmp.cod_formula_maestra = fm.cod_formula_maestra and fmdmp.cod_material = m.cod_material and fmdmp.COD_PRESENTACION_PRODUCTO = prp.COD_PRESENTACION" + //cprp.COD_PRESENTACION //and fmdmp.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod
                                        " left outer join materiales m2 on m2.cod_material = fmdmp.cod_material left outer join unidades_medida um2 on um2.cod_unidad_medida = fmdmp.cod_unidad_medida " +
                                        " where sa1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa1.COD_PROD = '"+codCompProd+"'" +
                                        " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                        " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO in(4,8)) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1 " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                        " union" +
                                        " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,0 cantidad_fm,um.ABREVIATURA,prp.cod_presentacion,fmdmp.CANTIDAD cantidad_fm1,prp.nombre_producto_presentacion" +
                                        " from programa_produccion ppr inner join COMPONENTES_PROD cp on cp.cod_compprod = ppr.cod_compprod and ppr.cod_lote_produccion = '"+bean.getCodLoteProduccion()+"'" +
                                        //" inner join COMPONENTES_PRESPROD cprp on cprp.COD_COMPPROD = ppr.COD_COMPPROD and cprp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                        " inner join salidas_almacen s on s.cod_lote_produccion = ppr.cod_lote_produccion and s.cod_prod = ppr.cod_compprod and s.cod_almacen = 2"+
                                        " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                        " inner join FORMULA_MAESTRA_DETALLE_ES fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA  and fmdmp.COD_PRESENTACION_PRODUCTO = s.COD_PRESENTACION" + //cprp.COD_PRESENTACION //and fmdmp.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod
                                        " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL" +
                                        " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = fmdmp.COD_UNIDAD_MEDIDA" +
                                        " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = fmdmp.COD_PRESENTACION_PRODUCTO " +
                                        " where fm.COD_COMPPROD = '"+codCompProd+"' " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                        ") as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura_fm,cod_presentacion,nombre_producto_presentacion" +
                                        " order by nombre_producto_presentacion";
                                /* outer apply (select sum(sd.CANTIDAD_SALIDA_ALMACEN) salidas_material" +
                                        " from SALIDAS_ALMACEN_DETALLE sd" +
                                        " inner join SALIDAS_ALMACEN s on s.COD_SALIDA_ALMACEN = sd.COD_SALIDA_ALMACEN" +
                                        " where sd.COD_MATERIAL = m.cod_material and s.COD_LOTE_PRODUCCION = sa1.COD_LOTE_PRODUCCION and s.COD_ESTADO_SALIDA_ALMACEN = 1" +
                                        " and s.ESTADO_SISTEMA = 1 and s.COD_PRESENTACION = sa1.COD_PRESENTACION and s.cod_salida_almacen = sa1.cod_salida_almacen) */
                                consulta = "select cod_material,nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura_fm,cod_presentacion,sum(cantidad_fm1) cantidad_fm1,NOMBRE_PRODUCTO_PRESENTACION,sum(costo_salida) costo_salida,sum(costo_devolucion) costo_devolucion from (" +
                                        " select m.nombre_material,um.abreviatura,sad.cantidad_salida_almacen salidas_material,devoluciones_material.devoluciones_material" +
                                        " ,m.nombre_material nombre_material_fm,0 cantidad_fm,um.abreviatura abreviatura_fm,prp.cod_presentacion,0 cantidad_fm1,prp.NOMBRE_PRODUCTO_PRESENTACION,m.cod_material,costo_salida.costo_salida,costo_devolucion.costo_devolucion" +
                                        " from SALIDAS_ALMACEN sa1" +
                                        " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                        " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                        " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida" +
                                        " inner join presentaciones_producto prp on prp.cod_presentacion = sa1.cod_presentacion " +
                                        /*" outer apply(select top 1 m2.NOMBRE_MATERIAL, fmdes.CANTIDAD, um2.ABREVIATURA, prp.cod_presentacion, prp.NOMBRE_PRODUCTO_PRESENTACION" +
                                        " from formula_maestra fm inner join FORMULA_MAESTRA_DETALLE_ES fmdes on fmdes.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA" +
                                        " inner join materiales m2 on m2.COD_MATERIAL = fmdes.COD_MATERIAL" +
                                        " inner join UNIDADES_MEDIDA um2 on um2.COD_UNIDAD_MEDIDA = m2.COD_UNIDAD_MEDIDA" +
                                        " left outer join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = fmdes.COD_PRESENTACION_PRODUCTO" +
                                        " where fm.COD_COMPPROD = sa1.COD_PROD and prp.cod_presentacion = sa1.COD_PRESENTACION and m2.COD_MATERIAL = sad.COD_MATERIAL) fmx " +*/
                                        "  " +
                                        " outer apply( select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) devoluciones_material from devoluciones d" +
                                        " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = 2" +
                                        " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                        " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                        " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                        " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                        " where d.estado_sistema = 1 " +
                                        " and d.cod_almacen = '2' " +
                                        " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                        " and m1.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN) devoluciones_material" +
                                        " outer apply (select sum(sadi.CANTIDAD*sadi.COSTO_SALIDA_ACTUALIZADO_FINAL) costo_salida from SALIDAS_ALMACEN_DETALLE_INGRESO sadi where sadi.COD_SALIDA_ALMACEN = sad.COD_SALIDA_ALMACEN and sadi.COD_MATERIAL = sad.COD_MATERIAL) costo_salida " +
                                        " outer apply (select sum(iad.CANT_TOTAL_INGRESO_FISICO * iad.COSTO_UNITARIO_ACTUALIZADO) costo_devolucion" +
                                        " from devoluciones d" +
                                        " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion" +
                                        " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and iad.COD_MATERIAL = m.cod_material" +
                                        " where d.estado_sistema = 1 and d.cod_almacen = '2' and ia.cod_estado_ingreso_almacen = 1" +
                                        " and d.cod_estado_devolucion = 1" +
                                        " and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN and ia.cod_almacen = '2'" +
                                        " and d.cod_salida_almacen = sa1.cod_salida_almacen) costo_devolucion " +
                                        " where sa1.COD_LOTE_PRODUCCION = '"+bean.getCodLoteProduccion()+"' and sa1.COD_PROD = '"+codCompProd+"'" +
                                        " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                        " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO in(4,8)) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1 " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                        " union all " +
                                        " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,0 cantidad_fm,um.ABREVIATURA,prp.cod_presentacion,fmdmp.CANTIDAD cantidad_fm1,prp.nombre_producto_presentacion,m.cod_material,0,0" +
                                        " from programa_produccion ppr inner join COMPONENTES_PROD cp on cp.cod_compprod = ppr.cod_compprod and ppr.cod_lote_produccion = '"+bean.getCodLoteProduccion()+"'" +
                                        " inner join COMPONENTES_PRESPROD cprp on cprp.COD_COMPPROD = ppr.COD_COMPPROD and cprp.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                                        //" inner join salidas_almacen s on s.cod_lote_produccion = ppr.cod_lote_produccion and s.cod_prod = ppr.cod_compprod and s.cod_almacen = 2"+
                                        " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                        " inner join FORMULA_MAESTRA_DETALLE_ES fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA  and fmdmp.COD_PRESENTACION_PRODUCTO = cprp.COD_PRESENTACION" + //cprp.COD_PRESENTACION //and fmdmp.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod
                                        " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL" +
                                        " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = fmdmp.COD_UNIDAD_MEDIDA" +
                                        " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = fmdmp.COD_PRESENTACION_PRODUCTO and cprp.cod_presentacion = prp.cod_presentacion " +
                                        " where fm.COD_COMPPROD = '"+codCompProd+"' and fm.cod_estado_registro = 1  and prp.cod_tipo_programa_prod = '"+codTipoProgramaProd+"' " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                        ") as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura_fm,cod_presentacion,nombre_producto_presentacion,cod_material" +
                                        " order by nombre_producto_presentacion";
                                
                                System.out.println("consulta ES "  + consulta);
                                Statement st3 = con.createStatement();
                                ResultSet rs3 = st3.executeQuery(consulta);
                                %>
                                <tr>
                                            <td class=colh align="center" style="border : solid #f2f2f2 1px;text-align:left"><b>Materia Empaque Secundario</b></td>
                                            <td class=colh align="center" style="border : solid #f2f2f2 1px;"></td>
                                </tr>
                                <%
                                String presentacionAnterior = "";
                                while(rs3.next()){
                                    //System.out.println("despues del ciclo");
                                    String nombreMaterial = rs3.getString("nombre_material");
                                    //String nombreUnidadMedida = rs1.getString("NOMBRE_UNIDAD_MEDIDA");
                                    double salidasMaterial = rs3.getDouble("salidas_material");
                                    double devolucionesMaterial = rs3.getDouble("devoluciones_material");
                                    String abreviatura = rs3.getString("abreviatura");
                                    String nombreMaterialFM = rs3.getString("nombre_material_fm")==null?"":rs3.getString("nombre_material_fm");
                                    double cantidadFM = rs3.getDouble("cantidad_fm")==0?rs3.getDouble("cantidad_fm1"):rs3.getDouble("cantidad_fm");;
                                    String abreviaturaFM = rs3.getString("abreviatura_fm")==null?"":rs3.getString("abreviatura_fm");
                                    double diferencia = Math.abs((salidasMaterial-devolucionesMaterial) - cantidadFM);
                                    double variacion = cantidadFM *Double.valueOf(porcentajeVariacion)/100;
                                    String estilo = diferencia>=variacion?"background-color:#F5A9A9":"";
                                    String nombrePresentacionProducto = rs3.getString("nombre_producto_presentacion")==null?"":rs3.getString("nombre_producto_presentacion");
                                    double cantidadIngresoAPT = 0;
                                    double costoSalidaMaterial = rs3.getDouble("costo_salida");
                                    double costoDevolucionMaterial = rs3.getDouble("costo_devolucion");
                                    String codMaterial = rs3.getString("cod_material");
                                    double costoMaterial = this.costoMaterial(codMaterial,"2");
                                    costoSalidaMaterial=(costoSalidaMaterial==0?salidasMaterial*costoMaterial:costoSalidaMaterial);
                                    costoDevolucionMaterial =(costoDevolucionMaterial==0?devolucionesMaterial*costoMaterial:costoDevolucionMaterial);
                                    if(rs3.getInt("cod_presentacion")>0 || rs3.getString("nombre_material_fm")==null){
                                    %>
                                    <tr style="<%=estilo%>">

                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;" colspan="2"><%=nombrePresentacionProducto%></td>

                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=nombreMaterial%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviatura%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(salidasMaterial)%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoSalidaMaterial)%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(devolucionesMaterial)%>    </td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoDevolucionMaterial)%>    </td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(salidasMaterial-devolucionesMaterial)%>    </td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(costoSalidaMaterial-costoDevolucionMaterial)%>    </td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviatura%></td>
                                        <%--td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=form.format(0)%>   </td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(0)%>   </td--%>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;" ><%=nombreMaterialFM%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=abreviaturaFM%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidadFM)%></td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format(cantidadFM*costoMaterial)%></td><%--this.costoMaterial(codMaterial)--%>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format((salidasMaterial-devolucionesMaterial)-cantidadFM)%>    </td>
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=!nombreMaterial.equals("")&&cantidadFM>0?form.format(((salidasMaterial-devolucionesMaterial)-cantidadFM)*100/cantidadFM)+"%":""%></td>
                                        <%
                                        if(!presentacionAnterior.equals(nombrePresentacionProducto)){
                                            cantidadIngresoAPT = this.ingresosAPTPresentacion(CODLOTEPRODUCCION, rs3.getInt("cod_presentacion"));
                                            
                                            out.print("<td class='colh' align='left' style='border : solid #f2f2f2 1px;background-color=FFFFFF'>"+cantidadIngresoAPT+"</td>");
                                            out.print("<td class='colh' align='left' style='border : solid #f2f2f2 1px;background-color=FFFFFF'>"+(cantidadProducida-cantidadIngresoAPT)+"</td>");
                                            out.print("<td class='colh' align='left' style='border : solid #f2f2f2 1px;background-color=FFFFFF'>"+form.format( (cantidadProducida-cantidadIngresoAPT)/cantidadProducida*100)+" %</td>");
                                            presentacionAnterior = nombrePresentacionProducto;
                                        }else{
                                            out.print("<td colspan='3'></td>");
                                        }
                                        %>
                                        
                                        <td class=colh align="left" style="border : solid #f2f2f2 1px;"><%=form.format((costoSalidaMaterial-costoDevolucionMaterial)-cantidadFM*costoMaterial)%>    </td>

                                        <%--td class=colh align="left" style="border : solid #f2f2f2 1px;"> <%=0%>    </td--%>
                                    </tr>

                                    <%
                                    }
                                }

                            codCompProdAnt = codCompProd;
                            codLoteProduccionAnt = CODLOTEPRODUCCION;
                            }
                   }
           }
            
        %>
     </table>
     </div>
   
    
</body>
</html>