<%@ page contentType="application/vnd.ms-excel"%>
<%@page pageEncoding="UTF-8"%>
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
<%@page import="jxl.Cell" %>
<%@page import="jxl.Range" %>
<%@page import="jxl.Sheet" %>
<%@page import="jxl.Workbook" %>
<%@page import="jxl.read.biff.BiffException;" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
            
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore"  />
</jsp:useBean>

<%

String path=request.getSession().getServletContext().getRealPath("");
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
String materiales = request.getParameter("codMaterials");
%>


<html>
<head>
    <title>REPORTE  DE  VERIFICACION  BACO  -  ATLAS (Fórmulas Maestras)</title>
    <style>
        .tablaReporte
        {
            border-top:1px solid #cccccc;
            border-left:1px solid #cccccc;
        }
        .tablaReporte thead tr td
        {
            font-weight:bold;
            font-size:12px;
            color:white;
            background-color:#9d5a9e;
            text-align:center;
        }

        
        .detalleLote
        {
            
            text-align:center;
        }
        .observado
        {
            background-color:#F5A9A9;
        }
        .celdaMagenta
        {
            font-family:Verdana, Arial, Helvetica, sans-serif;
            color:white;
            border-bottom:1px solid #cccccc;
            text-align:center;
            border-right:1px solid #cccccc;
            font-size:12px;
            font-weight:bold;
            background-color:#9d5a9e;

            
        }
        .celdaAmarilla
        {
            font-size:10px;
            font-family:Verdana, Arial, Helvetica, sans-serif;
            border-bottom:1px solid #cccccc;
            text-align:center;
            border-right:1px solid #cccccc;
            background-color:#ffff61;
        }
        .celdaTexto
        {
            font-size:10px;
            font-family:Verdana, Arial, Helvetica, sans-serif;
            border-bottom:1px solid #dddddd;
            text-align:center;
            color:black;
            border-right:1px solid #dddddd;
            
        }
    </style>
</head>
<body>
    
    <div align="center">
        <%
            boolean filtrarConFecha=request.getParameter("filtrarPorFechaFinal").equals("1");
            String fechaFinal=request.getParameter("fechaFinal");
            String[] arrayfecha=fechaFinal.split("/");
            
        %>
    <table width="100%" >
        <tr >
            <td colspan="3" align="center" >
                <h4>REPORTE  DE  VERIFICACION  BACO  -  ATLAS (Fórmulas Maestras)</h4>
            </td>
        </tr>
        <tr>
            <td align="left"><img src= "../img/cofar.png"></td> 
            <%
            if(filtrarConFecha)
            {
                out.println("<td><span class='outputTextBold'>Salidas y Devoluciones a fecha:</span><span class='outputText2'>"+fechaFinal+"</span></td>");
            }
            %>
        </tr>
    </table>
    
    
    <table width="90%" align="center" class="outputText0 tablaReporte"  cellpadding="0" cellspacing="0" >
        <thead>
       <tr>

            <td align="center" class="celdaMagenta"  >Lote</td>
            <td align="center" class="celdaMagenta"  >Producto</td>
            <td colspan="5" class="celdaMagenta"  ><b>BACO</b></td>
            <td colspan="3" class="celdaMagenta" ><b>ATLAS</b></td>
            <td align="center" class="celdaMagenta"  colspan="<%=(materiales.contains("3")?5:2)%>"><b>DIFERENCIA</b></td>
        </tr>  
        <tr>
            <td align="center" class="celdaMagenta" >&nbsp;</td>
            <td align="center" class="celdaMagenta" >&nbsp;</td>
            <td align="center" class="celdaMagenta" >&nbsp;</td>
            <td align="center" class="celdaMagenta" >Salidas</td>
            <td align="center" class="celdaMagenta" >Devoluc.</td>
            <td align="center" class="celdaMagenta" >Neta</td>
            <td align="center" class="celdaMagenta" >Unid</td>
            <td align="center" class="celdaMagenta" >Materiales Formula Maestra</td>
            <td align="center" class="celdaMagenta" >Cantidad </td>
            <td align="center" class="celdaMagenta" >Unid</td>
            <td align="center" class="celdaMagenta" >Diferencia</td>
            <td align="center" class="celdaMagenta" >Diferencia %</td>
            <%=(materiales.contains("3")?"<td  class='celdaMagenta'>Cant. Env.<br>Apt</td>" +
                    "<td  class='celdaMagenta'>Dif. Lote<br>Prod. Env. APT</td><td class='celdaMagenta'  >Dif.Lotes<br>%</td>":"")%>
        </tr>
        </thead>
        <%
        //leendo datos del excel
        fechaFinal=arrayfecha[2]+"/"+arrayfecha[1]+"/"+arrayfecha[0];
        Workbook w=Workbook.getWorkbook(stream);
        Sheet hoja=w.getSheet(0);
        int cont=0;
        List<String> arrayLotes=new ArrayList<String>();
        while (cont < hoja.getRows()) {
            Cell  c[] =hoja.getRow(cont);
            arrayLotes.add(c[0].getContents());
            cont=cont+1;
        }
        w.close();
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat)nf;
        form.applyPattern("#,###.00;-#,###.00");
        Connection con=null;
        
        try
        {
            con = Util.openConnection(con);
            Double porcentajeVariacion  = Double.valueOf(request.getParameter("porcentajeVariacion"));
            
            for(String codLote:arrayLotes)
            {
                String consulta=consulta = "select distinct cp.COD_COMPPROD,cp.nombre_prod_semiterminado,fmv.cod_formula_maestra,"+
                                  " (select sum(iad.CANT_INGRESO_PRODUCCION) from INGRESOS_ACOND ia inner join INGRESOS_DETALLEACOND iad" +
                                  " on iad.COD_INGRESO_ACOND =ia.COD_INGRESO_ACOND"+
                                  " inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on"+
                                  " ppia.COD_INGRESO_ACOND = ia.COD_INGRESO_ACOND and"+
                                  " ppia.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD and"+
                                  " ppia.COD_COMPPROD = ppr.COD_COMPPROD and ppia.COD_FORMULA_MAESTRA= ppr.COD_FORMULA_MAESTRA" +
                                  " and ppia.COD_LOTE_PRODUCCION =ppr.COD_LOTE_PRODUCCION and ppia.COD_TIPO_PROGRAMA_PROD =ppr.COD_TIPO_PROGRAMA_PROD"+
                                  " where iad.COD_LOTE_PRODUCCION = s.cod_lote_produccion and iad.COD_COMPPROD = s.cod_prod" +
                                  " and ia.COD_TIPOINGRESOACOND = 1 and ia.COD_ALMACENACOND in (1, 3) and ia.cod_estado_ingresoacond not in (1, 2)"+
                                  (filtrarConFecha?" and ia.fecha_ingresoacond<'"+fechaFinal+" 23:59' ":"")+
                                  " ) cant_ingreso_produccion,fmv.cantidad_lote,tppr.nombre_tipo_programa_prod,ppr.cod_tipo_programa_prod cod_tipo_programa_prod" +
                                  " ,ppr.CANT_LOTE_PRODUCCION,tppr.ABREVIATURA AS ABREVIATURATPP"+
                                  " from SALIDAS_ALMACEN s"+
                                  " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = s.COD_PROD"+
                                  " inner join FORMULA_MAESTRA_VERSION fmv on fmv.cod_compprod = cp.cod_compprod"+
                                  " inner join programa_produccion ppr on ppr.cod_compprod = s.cod_prod and"+
                                  " ppr.cod_formula_maestra = fmv.cod_formula_maestra and"+
                                  " ppr.COD_FORMULA_MAESTRA_VERSION=fmv.COD_VERSION and "+
                                  " ppr.cod_lote_produccion = s.cod_lote_produccion"+
                                  " inner join tipos_programa_produccion tppr on tppr.cod_tipo_programa_prod =ppr.cod_tipo_programa_prod"+
                                  " where s.COD_LOTE_PRODUCCION = '"+codLote+"'";
                System.out.println("consulta datos lote programa "+consulta);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet res  = st.executeQuery(consulta);
                if(materiales.contains("1")||materiales.contains("2"))
                {
                        String innerHTMLCabecera="";
                        while(res.next())
                        {
                            innerHTMLCabecera+=(innerHTMLCabecera.equals("")?"":"<tr>")+"<td class='celdaAmarilla' align='center' bgcolor='#ffff61'><b>"+res.getString("nombre_prod_semiterminado")+"("+res.getString("ABREVIATURATPP")+")</b></td>" +
                                    "<td class='celdaAmarilla' align='center' bgcolor='#ffff61' >Cant.Env.Prod:<b>"+res.getInt("cant_ingreso_produccion")+"</b></td>" +
                                    "<td class='celdaAmarilla' align='center' bgcolor='#ffff61' colspan='4' ><b>"+res.getInt("CANT_LOTE_PRODUCCION")+"</b></td>" +
                                    "<td class='celdaAmarilla' align='center' bgcolor='#ffff61' colspan='3'><b>"+res.getInt("cantidad_lote")+"</b></td>" +
                                    "<td class='celdaAmarilla' align='center' bgcolor='#ffff61' colspan='"+(materiales.contains("3")?5:2)+"' >&nbsp;</td>" +
                                    "</tr>";

                        }
                        res.last();
                        out.println("<tr><td class='celdaAmarilla' rowspan='"+res.getRow()+"' ><b>"+codLote+"</b></td>"+innerHTMLCabecera);
                }
                if(materiales.contains("1"))
                    {
                            out.println("<tr><td colspan='"+(materiales.contains("3")?15:12)+"' class='celdaTexto' style='text-align:left'><b>Materia Prima</b></td></tr>");
                            consulta = "select nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm from (" +
                                    " select  m.nombre_material,um.abreviatura, sad.cantidad_salida_almacen salidas_material," +
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
                                        (filtrarConFecha?" and  ia.FECHA_INGRESO_ALMACEN<'"+fechaFinal+" 23:59'":"")+
                                        " and m1.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN),0) devoluciones_material,m.nombre_material nombre_material_fm,0 cantidad_fm,um.abreviatura abreviatura_fm" +
                                    " from SALIDAS_ALMACEN sa1" +
                                    " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                    " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                    " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida" +
                                    " where sa1.COD_LOTE_PRODUCCION = '"+codLote+"' " +
                                    (filtrarConFecha?" and sa1.FECHA_SALIDA_ALMACEN <'"+fechaFinal+" 23:59' ":"")+
                                    " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g  " +
                                    " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 2) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1" +
                                    " union all " +
                                    " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,fmdmp.cantidad*(pp.CANT_LOTE_PRODUCCION/fm.CANTIDAD_LOTE) as cantidad_fm,um.ABREVIATURA"+
                                    " from FORMULA_MAESTRA_VERSION fm inner join FORMULA_MAESTRA_DETALLE_MP_VERSION fmdmp on fmdmp.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA"+
                                    " and fm.COD_VERSION=fmdmp.COD_VERSION"+
                                    " inner join materiales m on m.COD_MATERIAL = fmdmp.COD_MATERIAL"+
                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =fmdmp.COD_UNIDAD_MEDIDA"+
                                    " inner join PROGRAMA_PRODUCCION pp on pp.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA"+
                                    " and pp.COD_FORMULA_MAESTRA_VERSION=fm.COD_VERSION and pp.COD_LOTE_PRODUCCION='"+codLote+"'" +
                                    " ) as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura_fm ";
                            System.out.println("consulta MP"  + consulta);
                            Statement st1 = con.createStatement();
                            ResultSet res1 = st1.executeQuery(consulta);
                            while(res1.next()){
                                double diferencia=(res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material"))-res1.getDouble("cantidad_fm");
                                double porciento=(res1.getDouble("cantidad_fm")>0?((diferencia/res1.getDouble("cantidad_fm"))*100d):100d);
                                out.println("<tr "+(porciento>porcentajeVariacion||porciento<-porcentajeVariacion?"class='observado'":"")+"><td class='celdaTexto' colspan='2'>&nbsp;</td>" +
                                            (res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material")>0?
                                            "<td class='celdaTexto'>"+res1.getString("nombre_material")+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("salidas_material"))+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("devoluciones_material"))+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material"))+"</td>" +
                                            "<td class='celdaTexto'>"+res1.getString("abreviatura")+"</td>":"<td colspan='5'>&nbsp;</td>")+
                                            (res1.getDouble("cantidad_fm")>0?"<td class='celdaTexto'>"+res1.getString("nombre_material_fm")+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("cantidad_fm"))+"</td>" +
                                            "<td class='celdaTexto'>"+res1.getString("abreviatura")+"</td>":"<td colspan='3'>&nbsp;</td>")+
                                            "<td class='celdaTexto'>"+form.format(diferencia)+"</td>"+
                                            "<td class='celdaTexto'>"+form.format(porciento)+"</td>"+
                                            (materiales.contains("3")?"<td colspan='3' class='celdaTexto'>&nbsp;</td>":"")+
                                            "</tr>");

                            }
                    }
                if(materiales.contains("2"))
                {
                    out.println("<tr><td  colspan='"+(materiales.contains("3")?15:12)+"' class='celdaTexto' style='text-align:left'><b>Empaque Primario</b></td></tr>");
                                consulta = "select nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura from (" +
                                        " select  m.nombre_material,um.abreviatura,  sad.cantidad_salida_almacen salidas_material," +
                                        " isnull((select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) from devoluciones d" +
                                        " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen = 1 " +
                                        " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                        " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                        " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                        " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                        " where d.estado_sistema = 1 " +
                                        " and d.cod_almacen = '1' " +
                                        " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                        (filtrarConFecha?" and  ia.FECHA_INGRESO_ALMACEN<'"+fechaFinal+" 23:59'":"")+
                                        " and m1.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN),0) devoluciones_material,m.nombre_material nombre_material_fm,0 cantidad_fm,um.abreviatura abreviatura_fm" +
                                        " from SALIDAS_ALMACEN sa1" +
                                        " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                        " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                        " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida " +
                                        " where sa1.COD_LOTE_PRODUCCION = '"+codLote+"' " +
                                        " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                        " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO = 3) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1 " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                        (filtrarConFecha?" and sa1.FECHA_SALIDA_ALMACEN <'"+fechaFinal+" 23:59' ":"")+
                                        " union all " +
                                        " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,"+
                                        " fmdepv.CANTIDAD*(pp.CANT_LOTE_PRODUCCION/fmv.CANTIDAD_LOTE) as cantidad_fm,um.ABREVIATURA"+
                                        " from PROGRAMA_PRODUCCION pp inner join FORMULA_MAESTRA_VERSION fmv on "+
                                        " pp.COD_FORMULA_MAESTRA_VERSION=fmv.COD_VERSION"+
                                        " inner join PRESENTACIONES_PRIMARIAS_VERSION ppv on "+
                                        " ppv.COD_VERSION=pp.COD_COMPPROD_VERSION and ppv.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                        " inner join FORMULA_MAESTRA_DETALLE_EP_VERSION fmdepv on fmdepv.COD_VERSION=fmv.COD_VERSION"+
                                        " and fmdepv.COD_PRESENTACION_PRIMARIA=ppv.COD_PRESENTACION_PRIMARIA"+
                                        " inner join materiales m on m.COD_MATERIAL=fmdepv.COD_MATERIAL"+
                                        " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA"+
                                        " where pp.COD_LOTE_PRODUCCION='"+codLote+"'" +
                                        " ) as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura ";

                                System.out.println("consulta EP "  + consulta);
                                Statement st1 = con.createStatement();
                                ResultSet res1 = st1.executeQuery(consulta);
                                while(res1.next())
                                {
                                     double diferencia=(res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material"))-res1.getDouble("cantidad_fm");
                                     double porciento=(res1.getDouble("cantidad_fm")>0?((diferencia/res1.getDouble("cantidad_fm"))*100d):100d);
                                     out.println("<tr "+(porciento>porcentajeVariacion||porciento<-porcentajeVariacion?"class='observado'":"")+"><td class='celdaTexto' colspan='2'>&nbsp;</td>" +
                                            (res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material")>0?
                                            "<td class='celdaTexto'>"+res1.getString("nombre_material")+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("salidas_material"))+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("devoluciones_material"))+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material"))+"</td>" +
                                            "<td class='celdaTexto'>"+res1.getString("abreviatura")+"</td>":"<td class='celdaTexto' colspan='5'>&nbsp;</td>")+
                                            (res1.getDouble("cantidad_fm")>0?"<td class='celdaTexto'>"+res1.getString("nombre_material_fm")+"</td>" +
                                            "<td class='celdaTexto'>"+form.format(res1.getDouble("cantidad_fm"))+"</td>" +
                                            "<td class='celdaTexto'>"+res1.getString("abreviatura")+"</td>":"<td class='celdaTexto' colspan='3'>&nbsp;</td>")+
                                            "<td class='celdaTexto'>"+form.format(diferencia)+"</td>"+
                                            "<td class='celdaTexto'>"+form.format(porciento)+"</td>"+
                                            (materiales.contains("3")?"<td colspan='3' class='celdaTexto'>&nbsp;</td>":"")+
                                            "</tr>");

                                }
                    }
                res.first();
                res.previous();
                if(materiales.contains("3"))
                {
                        while (res.next())
                        {
                            out.println("<tr><td class='celdaAmarilla'><b>"+codLote+"</b></td><td class='celdaAmarilla'><b >"+res.getString("nombre_prod_semiterminado")+"("+res.getString("ABREVIATURATPP")+")</b></td>" +
                                    "<td class='celdaAmarilla' >Cant.Env.Prod:<b>"+res.getInt("cant_ingreso_produccion")+"</b></td>" +
                                    "<td class='celdaAmarilla' colspan='4' ><b>"+res.getInt("CANT_LOTE_PRODUCCION")+"</b></td>" +
                                    "<td class='celdaAmarilla' colspan='3' ><b>"+res.getInt("cantidad_lote")+"</b></td>" +
                                    "<td class='celdaAmarilla' colspan='5' >&nbsp;</td>"+
                                    "</tr>");
                            out.println("<tr><td  colspan='"+(materiales.contains("3")?12:9)+"' class='celdaTexto' style='text-align:left'><b>Empaque Secundario</b></td>");
                            consulta = " select sum( isnull(((isnull(idv.cantidad, 0) * p.cantidad_presentacion) + isnull(idv.cantidad_unitaria, 0)), 0)) as cantidad_total" +
                                       " from INGRESOS_VENTAS iv,INGRESOS_DETALLEVENTAS idv,     PRESENTACIONES_PRODUCTO p,     ALMACENES_VENTAS av, tipos_ingresoventas t," +
                                       " tipos_mercaderia tm,lineas_mkt l" +
                                        " where iv.cod_estado_ingresoventas <> 2 and iv.cod_ingresoventas = idv.cod_ingresoventas " +
                                        " and iv.cod_tipoingresoventas = t.cod_tipoingresoventas and p.cod_lineamkt = l.cod_lineamkt" +
                                        " and p.cod_tipomercaderia = tm.cod_tipomercaderia and idv.cod_presentacion = p.cod_presentacion" +
                                        " and iv.cod_almacen_venta = av.cod_almacen_venta and av.cod_area_empresa = 1" +
                                        " and p.cod_tipomercaderia in (1, 5, 8) and iv.cod_tipoingresoventas in (2)" +
                                        " and iv.cod_almacen_venta in (58, 73, 29, 56, 54, 57, 28, 27, 32) and idv.cod_lote_produccion like '"+codLote+"'"+
                                        " and idv.COD_AREA_EMPRESA=iv.COD_AREA_EMPRESA"+
                                        (filtrarConFecha?" and iv.FECHA_INGRESOVENTAS<'"+fechaFinal+" 23:59'":"");
                            System.out.println("consulta registrar "+consulta);
                            Statement stIng=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet resIng=stIng.executeQuery(consulta);
                            resIng.next();
                            out.println("<td class='celdaTexto'>"+resIng.getInt("cantidad_total")+"</td>"+
                                        "<td class='celdaTexto'>"+(res.getInt("CANT_LOTE_PRODUCCION")-resIng.getInt("cantidad_total"))+"</td>"+
                                        "<td class='celdaTexto'>"+form.format(res.getInt("CANT_LOTE_PRODUCCION")>0?((res.getDouble("CANT_LOTE_PRODUCCION")-resIng.getDouble("cantidad_total"))/res.getDouble("CANT_LOTE_PRODUCCION")*100d):100d)+"</td>");
                            out.println("</tr>");                               
                                                        
                            
                        
                                            consulta = "select nombre_material,abreviatura,sum(salidas_material) salidas_material,sum(devoluciones_material) devoluciones_material,nombre_material_fm,sum(cantidad_fm) cantidad_fm,abreviatura_fm,cod_presentacion,sum(cantidad_fm1) cantidad_fm1,NOMBRE_PRODUCTO_PRESENTACION from (" +
                                                    " select  m.nombre_material,um.abreviatura, sad.cantidad_salida_almacen salidas_material," +
                                                    " isnull((select sum(isnull(iad.CANT_TOTAL_INGRESO_FISICO, 0)) devoluciones_material from devoluciones d" +
                                                    " inner join ingresos_almacen ia on d.cod_devolucion = ia.cod_devolucion and ia.cod_almacen in (2,17)" +
                                                    " inner join ingresos_almacen_detalle iad on iad.cod_ingreso_almacen = ia.cod_ingreso_almacen" +
                                                    " inner join MATERIALES m1 on m1.COD_MATERIAL = iad.COD_MATERIAL" +
                                                    " inner join GRUPOS g on g.COD_GRUPO = m1.COD_GRUPO" +
                                                    " inner join CAPITULOS c on c.COD_CAPITULO = g.COD_CAPITULO" +
                                                    " where d.estado_sistema = 1 " +
                                                    " and d.cod_almacen in (2,17) " +
                                                    " and ia.cod_estado_ingreso_almacen = 1 and d.cod_estado_devolucion = 1" +
                                                    (filtrarConFecha?" and  ia.FECHA_INGRESO_ALMACEN<'"+fechaFinal+" 23:59'":"")+
                                                    " and m1.cod_material = m.cod_material and d.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN),0) devoluciones_material,m.nombre_material nombre_material_fm,0 cantidad_fm,um.abreviatura abreviatura_fm,prp.cod_presentacion,0 cantidad_fm1,isnull(prp.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACION" + //fmx.nombre_material nombre_material_fm,fmx.cantidad cantidad_fm,fmx.abreviatura abreviatura_fm
                                                    " from SALIDAS_ALMACEN sa1" +
                                                    " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN = sa1.COD_SALIDA_ALMACEN" +
                                                    " inner join materiales m on m.COD_MATERIAL = sad.COD_MATERIAL" +
                                                    " inner join unidades_medida um on um.cod_unidad_medida = m.cod_unidad_medida" +
                                                    " left outer join presentaciones_producto prp on prp.cod_presentacion = sa1.cod_presentacion" +
                                                    " left outer join componentes_presprod cprp on cprp.cod_presentacion = prp.cod_presentacion and cprp.cod_compprod = '"+res.getInt("COD_COMPPROD")+"' and cprp.cod_tipo_programa_prod = '"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"' " +
                                                    " where sa1.COD_LOTE_PRODUCCION = '"+codLote+"' and sa1.COD_PROD = '"+res.getInt("COD_COMPPROD")+"'" +
                                                    " and m.COD_MATERIAL in (select m1.COD_MATERIAL from MATERIALES m1,grupos g" +
                                                    " where g.COD_GRUPO = m1.COD_GRUPO and g.COD_CAPITULO in(4,8)) and sa1.COD_ESTADO_SALIDA_ALMACEN = 1 and sa1.ESTADO_SISTEMA = 1 " + //and ppr.cod_tipo_programa_prod = '"+codTipoProgramaProd+"'
                                                    (filtrarConFecha?" and sa1.FECHA_SALIDA_ALMACEN <'"+fechaFinal+" 23:59' ":"")+
                                                    " union all " +
                                                    " select m.NOMBRE_MATERIAL,um.ABREVIATURA,0,0,m.NOMBRE_MATERIAL,"+
                                                    " fmdesv.cantidad*(pp.CANT_LOTE_PRODUCCION / fmv.CANTIDAD_LOTE) cantidad_fm,um.ABREVIATURA,ppr.cod_presentacion,fmdesv.CANTIDAD*(pp.CANT_LOTE_PRODUCCION/fmv.CANTIDAD_LOTE) cantidad_fm1,ppr.NOMBRE_PRODUCTO_PRESENTACION"+
                                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PRESPROD  cpp on"+
                                                    " cpp.COD_COMPPROD=pp.COD_COMPPROD and cpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                                    " inner join FORMULA_MAESTRA_DETALLE_ES_VERSION fmdesv on fmdesv.COD_FORMULA_MAESTRA_ES_VERSION=pp.COD_FORMULA_MAESTRA_ES_VERSION"+
                                                    "   and fmdesv.COD_PRESENTACION_PRODUCTO=pp.COD_PRESENTACION"+
                                                    " and fmdesv.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                                    " and fmdesv.COD_PRESENTACION_PRODUCTO=cpp.COD_PRESENTACION"+
                                                    " inner join FORMULA_MAESTRA_VERSION fmv on fmv.COD_VERSION =fmdesv.COD_VERSION"+
                                                    " inner join materiales m on m.COD_MATERIAL = fmdesv.COD_MATERIAL"+
                                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = fmdesv.COD_UNIDAD_MEDIDA"+
                                                    " inner join PRESENTACIONES_PRODUCTO ppr on ppr.cod_presentacion ="+
                                                    " fmdesv.COD_PRESENTACION_PRODUCTO and cpp.cod_presentacion = ppr.cod_presentacion"+
                                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.COD_TIPO_PROGRAMA_PROD='"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'" +
                                                    " and pp.COD_COMPPROD='"+res.getInt("COD_COMPPROD")+"'"+
                                                    ") as tabla group by nombre_material,abreviatura,nombre_material_fm,abreviatura_fm,cod_presentacion,nombre_producto_presentacion" +
                                                    " order by nombre_producto_presentacion";

                                            System.out.println("consulta ES"  + consulta);
                                            Statement st1 = con.createStatement();
                                            ResultSet res1=st1.executeQuery(consulta);
                                            int codPresentacionCabecera=0;
                                            while(res1.next())
                                            {
                                                
                                                if(res1.getDouble("cantidad_fm")>0||res1.getDouble("salidas_material")>0)
                                                {
                                                    double diferencia=(res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material"))-res1.getDouble("cantidad_fm");
                                                    double porciento=(res1.getDouble("cantidad_fm")>0?((diferencia/res1.getDouble("cantidad_fm"))*100d):100d);
                                                    out.println("<tr "+(porciento>porcentajeVariacion||porciento<-porcentajeVariacion?"class='observado'":"")+"><td colspan='2' class='celdaTexto'>"+res1.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>" +
                                                        (res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material")>0?
                                                        "<td class='celdaTexto'>"+res1.getString("nombre_material")+"</td>" +
                                                        "<td class='celdaTexto'>"+form.format(res1.getDouble("salidas_material"))+"</td>" +
                                                        "<td class='celdaTexto'>"+form.format(res1.getDouble("devoluciones_material"))+"</td>" +
                                                        "<td class='celdaTexto'>"+form.format(res1.getDouble("salidas_material")-res1.getDouble("devoluciones_material"))+"</td>" +
                                                        "<td class='celdaTexto'>"+res1.getString("abreviatura")+"</td>":"<td class='celdaTexto' colspan='5'>&nbsp;</td>")+
                                                        (res1.getDouble("cantidad_fm")>0?"<td class='celdaTexto'>"+res1.getString("nombre_material_fm")+"</td>" +
                                                        "<td class='celdaTexto'>"+form.format(res1.getDouble("cantidad_fm"))+"</td>" +
                                                        "<td class='celdaTexto'>"+res1.getString("abreviatura")+"</td>":"<td class='celdaTexto' colspan='3'>&nbsp;</td>")+
                                                        "<td class='celdaTexto'>"+form.format(diferencia)+"</td>"+
                                                        "<td class='celdaTexto'>"+form.format(porciento)+"</td>");
                                                    
                                                        if(codPresentacionCabecera!=res1.getInt("cod_presentacion"))
                                                        {
                                                            codPresentacionCabecera=res1.getInt("cod_presentacion");
                                                            consulta = " select sum( isnull(((isnull(idv.cantidad, 0) * p.cantidad_presentacion) + isnull(idv.cantidad_unitaria, 0)), 0)) as cantidad_total" +
                                                                       " from INGRESOS_VENTAS iv,INGRESOS_DETALLEVENTAS idv,     PRESENTACIONES_PRODUCTO p,     ALMACENES_VENTAS av, tipos_ingresoventas t," +
                                                                       " tipos_mercaderia tm,lineas_mkt l" +
                                                                        " where iv.cod_estado_ingresoventas <> 2 and iv.cod_ingresoventas = idv.cod_ingresoventas " +
                                                                        " and iv.cod_tipoingresoventas = t.cod_tipoingresoventas and p.cod_lineamkt = l.cod_lineamkt" +
                                                                        " and p.cod_tipomercaderia = tm.cod_tipomercaderia and idv.cod_presentacion = p.cod_presentacion" +
                                                                        " and iv.cod_almacen_venta = av.cod_almacen_venta and av.cod_area_empresa = 1" +
                                                                        " and p.cod_tipomercaderia in (1, 5, 8) and iv.cod_tipoingresoventas in (2)" +
                                                                        " and iv.cod_almacen_venta in (58, 73, 29, 56, 54, 57, 28, 27, 32) and idv.cod_lote_produccion like '"+codLote+"'" +
                                                                        " and idv.COD_PRESENTACION = '"+res1.getInt("COD_PRESENTACION")+"' "+
                                                                        " and idv.COD_AREA_EMPRESA=iv.COD_AREA_EMPRESA"+
                                                                        (filtrarConFecha?" and iv.FECHA_INGRESOVENTAS<'"+fechaFinal+" 23:59'":"");
                                                            resIng=stIng.executeQuery(consulta);
                                                            resIng.next();
                                                            out.println("<td class='celdaTexto'>"+resIng.getInt("cantidad_total")+"</td>"+
                                                                        "<td class='celdaTexto'>"+(res.getInt("CANT_LOTE_PRODUCCION")-resIng.getInt("cantidad_total"))+"</td>"+
                                                                        "<td class='celdaTexto'>"+form.format(res.getInt("CANT_LOTE_PRODUCCION")>0?((res.getDouble("CANT_LOTE_PRODUCCION")-resIng.getDouble("cantidad_total"))/res.getDouble("CANT_LOTE_PRODUCCION")*100d):100d)+"</td>");
                                                            
                                                        }
                                                        else
                                                        {
                                                            out.println("<td colspan='3' class='celdaTexto'>&nbsp;</td>");
                                                        }
                                                        out.println("</tr>");
                                                }

                                            }

                            }
                    }

               }
           }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
            
        %>
     </table>
     </div>
   
    
</body>
</html>