<%@page import="javax.faces.context.FacesContext"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
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


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            .tablaReporte thead tr td
            {
                background-color: rgb(157, 90, 158);
                color: white;
                text-align: center;
            }
            .conexistencia
            {
                background-color:#c6dfc5 !important;
                border:1px solid #87cd83 !important;
            }
            .sinexistencia
            {
                background-color:#eec6bd !important;
                border:1px solid #f77659 !important;
            }
            .enTransito
            {
                background-color:#fde3ff !important;
                border:1px solid #f6bbf9 !important;
            }
        </style>
        <script>
            function buscarExplosionMateriales()
            {
                var textoMateriales = document.getElementById("nombreMaterial").value.toLowerCase();
                var textoCapitulos = document.getElementById("nombreCapitulo").value.toLowerCase();
                var tablaBuscar=document.getElementById("tablaExplosion").getElementsByTagName("tbody")[0];
                var encontrado=false;
                for (var i =0; i < tablaBuscar.rows.length; i++)
                {
                    
                    if(
                         (textoCapitulos.length==0||
                        (tablaBuscar.rows[i].cells[1].innerHTML.toLowerCase().indexOf(textoCapitulos) > -1))&&
                        (textoMateriales.length==0||
                        (tablaBuscar.rows[i].cells[2].innerHTML.toLowerCase().indexOf(textoMateriales) > -1))
                    )
                    {
                        for(var j=0;j<tablaBuscar.rows[i].cells[1].rowSpan;j++)
                        {
                            tablaBuscar.rows[i+j].style.display='';
                        }
                    }
                    else
                    {
                        for(var j=0;j<tablaBuscar.rows[i].cells[1].rowSpan;j++)
                        {
                            tablaBuscar.rows[i+j].style.display='none';
                        }
                    }
                    i+=tablaBuscar.rows[i].cells[1].rowSpan-1
                    
                }
            }
        </script>
    </head>
    <body>
        <center>
            <span class="outputTextTituloSistema">Explosión  de Materiales</span>
            <table>
                <tr>
                    <td class="outputTextBold">Almacenes</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("nombreAlmacen"))%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Con Productos en Proceso</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("conProductosEnProceso").equals("1")?"SI":"NO")%></td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" style="padding:4px;margin-top: 1em" >
                <tr>
                    <td class="outputTextBold">Existencia suficiente</td>
                    <td style="width:4em" class="conexistencia">&nbsp;</td>
                    <td class="outputTextBold">Existencia insuficiente</td>
                    <td style="width:4em" class="sinexistencia">&nbsp;</td>
                    <td class="outputTextBold">En transito</td>
                    <td style="width:4em" class="enTransito">&nbsp;</td>
                </tr>
            </table>
        </center>
        <table cellpadding="0" id="tablaExplosion" style="margin-top:1em;" cellspacing="0" class="tablaReporte">
            <thead>
                <tr>
                    <td rowspan="2">Nro</td>
                    <td rowspan="2">Clasificacion<br><input id="nombreCapitulo" value="" onkeyup="buscarExplosionMateriales();"/></td>
                    <td rowspan="2">Material<br><input id="nombreMaterial" value="" onkeyup="buscarExplosionMateriales();"/></td>
                    <td rowspan="2">Stock Min</td>
                    <td rowspan="2">Stock Reposicion</td>
                    <td rowspan="2">Stock Max</td>
                    <td rowspan="2">Unid. Med.</td>
                    <td rowspan="2">Aprobado Almacen Transitorio E.S</td>
                    <td rowspan="2">Cuarentena Almacen Transitorio E.S</td>
                    <td rowspan="2">Aprob</td>
                    <td rowspan="2">Cuar</td>
                    <td rowspan="2">Rech</td>
                    <td rowspan="2">Venc</td>
                    <td rowspan="2">Reanalisis</td>
                    <td rowspan="2">Disponible</td>
                    <td rowspan="2">A Utilizar Prod.</td>
                    <td rowspan="2">Diferencia</td>
                    <td rowspan="2">Diferencia Stock Reposicion</td>
                    <td rowspan="2">Estado Item</td>
                    <td rowspan="2">Tránsito</td>
                    <td rowspan="2">Fecha Entrega</td>
                    <td rowspan="2">Proveedor Ultima Compra</td>
                    <td rowspan="2">Datos de Compra</td>
                    <td colspan="4">Productos</td>
                </tr>
                <tr>
                    <td>Producto</td>
                    <td>Tipo Material</td>
                    <td>Tipo Programa Producción</td>
                    <td>Cantidad</td>
                </tr>
            </thead>
            <tbody>
        <%
        Connection con=null;
        con=Util.openConnection(con);
        String codigosProducto=request.getParameter("codigos");
        String[] codigosProductoArray=codigosProducto.split(",");
        boolean conProductosEnProceso = (request.getParameter("conProductosEnProceso").equals("1"));
        String codlote=(request.getParameter("lotes")!=null?request.getParameter("lotes"):"");
        String codProgramaProd = request.getParameter("codProgramaProduccion");
        String codAlmacen=request.getParameter("codAlmacen");
        //VERIFICAR FACTIBILDAD DE USO DE LA TABLA
        StringBuilder consulta=new StringBuilder("delete explosion_productos");
                               consulta.append(" where cod_programa_produccion=").append(codProgramaProd);
        System.out.println("consulta eliminar explosion mes "+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se elimino la explosion del mes");
        consulta=new StringBuilder("insert into explosion_productos(cod_programa_produccion, cod_compprod)");
                consulta.append(" values(");
                    consulta.append(codProgramaProd).append(",");
                    consulta.append("?");
                consulta.append(")");
        System.out.println("consulta insert programaProducciom explosion "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(String codigo:codigosProductoArray)
        {
            pst.setString(1,codigo);
            if(pst.executeUpdate()>0)System.out.println("se registro el producto en la explosion "+codigo);
        }
        
        
        //OBTENIENDO LOS MATERIALES NECESARIOS PARA LA EXPLOSION
        consulta=new StringBuilder("select DISTINCT PPRD.COD_MATERIAL,M.NOMBRE_MATERIAL");
                     consulta.append(" from PROGRAMA_PRODUCCION PPR");
                         consulta.append(" INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPRD ON pprd.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD");
                            consulta.append(" and ppr.COD_COMPPROD = pprd.COD_COMPPROD and ppr.COD_TIPO_PROGRAMA_PROD = pprd.COD_TIPO_PROGRAMA_PROD");
                            consulta.append(" and ppr.COD_LOTE_PRODUCCION = pprd.COD_LOTE_PRODUCCION");
                         consulta.append(" INNER JOIN MATERIALES M ON PPRD.COD_MATERIAL = M.COD_MATERIAL");
                    consulta.append(" where ((PPR.COD_PROGRAMA_PROD in (").append(codProgramaProd).append(")");
                        consulta.append(" and  PPR.COD_COMPPROD in("+codigosProducto+")");
                        consulta.append(" and ppr.COD_LOTE_PRODUCCION+'$'+cast(ppr.COD_TIPO_PROGRAMA_PROD as varchar) in (").append(codlote).append("))");
                    if(conProductosEnProceso)
                        consulta.append(" or ppr.COD_ESTADO_PROGRAMA=7");        
                    consulta.append(" )and pprd.COD_MATERIAL in ");
                        consulta.append("(");
                              consulta.append(" select f.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA=ppr.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f1.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ep f1 where f1.COD_FORMULA_MAESTRA=ppr.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f2.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES f2 where f2.COD_FORMULA_MAESTRA=ppr.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f3.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_mr f3 where f3.COD_FORMULA_MAESTRA=ppr.COD_FORMULA_MAESTRA");
                        consulta.append(")");
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        System.out.println("consulta extraer materiales necesario "+consulta.toString());
        ResultSet res=st.executeQuery(consulta.toString());
        StringBuilder items=new StringBuilder("0");
        while (res.next())items.append(",").append(res.getInt("COD_MATERIAL"));
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        //preparestatement de productos que utilizan dicho material
        consulta=new StringBuilder("select sum(ppd.CANTIDAD) as cantidadLote,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                         consulta.append(" ,tm.NOMBRE_TIPO_MATERIAL");
                 consulta.append(" from PROGRAMA_PRODUCCION pp ");
                        consulta.append("  inner join COMPONENTES_PROD cp on pp.COD_COMPPROD=cp.COD_COMPPROD");
                         consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                         consulta.append(" inner join PROGRAMA_PRODUCCION_DETALLE ppd on ppd.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                 consulta.append(" and ppd.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and pp.COD_COMPPROD=ppd.COD_COMPPROD");
                                 consulta.append(" and ppd.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                         consulta.append(" inner join TIPOS_MATERIAL tm on tm.COD_TIPO_MATERIAL=ppd.COD_TIPO_MATERIAL");
                 consulta.append(" where  ppd.cod_material=?");
                 consulta.append(" and ppd.COD_MATERIAL in ");
                        consulta.append("(");
                              consulta.append(" select f.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f1.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ep f1 where f1.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f2.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES f2 where f2.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                              consulta.append(" union select f3.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_mr f3 where f3.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                        consulta.append(")");
                 consulta.append(" and ((");
                         consulta.append(" ppd.COD_PROGRAMA_PROD in (").append(codProgramaProd).append(")");
                         consulta.append(" and pp.COD_ESTADO_PROGRAMA=4");
                         consulta.append(" and pp.COD_COMPPROD in (").append(codigosProducto).append(")");
                         consulta.append(" and pp.COD_LOTE_PRODUCCION + '$' + cast (pp.COD_TIPO_PROGRAMA_PROD as varchar) in (").append(codlote).append(")");
                 consulta.append(" )");
                 if(conProductosEnProceso)
                    consulta.append(" or pp.COD_ESTADO_PROGRAMA=7");
                 consulta.append(" )group by cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,tm.NOMBRE_TIPO_MATERIAL");
                 consulta.append(" order by cp.nombre_prod_semiterminado");
        System.out.println("consulta preparedstatement de productos que utilizan un material "+consulta.toString());
        PreparedStatement pstLotes=con.prepareStatement(consulta.toString());
        ResultSet resLotes;
        StringBuilder innerHTMLLotes;
        Double cantidadUtilizarMaterial=0d;
        int cantidadRowSpan=0;
        //exitencias y stocks por material
        SimpleDateFormat sdfOc=new SimpleDateFormat("yyyy/MM/01 00:00:00");
        consulta=new StringBuilder("select g.NOMBRE_GRUPO,c.NOMBRE_CAPITULO,m.COD_MATERIAL,m.STOCK_MINIMO_MATERIAL,m.STOCK_MAXIMO_MATERIAL,");
                            consulta.append(" m.STOCK_SEGURIDAD,m.COD_UNIDAD_MEDIDA,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,");
                            consulta.append(" aprobados.cantidad as cantidadAprobados,cuarentena.cantidad as cantidadCuarentena,");
                            consulta.append(" aprobadosTransitorio.cantidad as cantidadAprobadosTransitorio,cuarentenaTransitorio.cantidad as cantidadCuarentenaTransitorio,");
                            consulta.append(" rechazado.cantidad as cantidadRechazados,vencido.cantidad as cantidadVencido,");
                            consulta.append(" reanalisis.cantidad as cantidadReanalisis");
                            consulta.append(" ,datosOrdenCompra.cantidadTransito,datosOrdenCompra.fecha_Entrega");
                            consulta.append(" ,isnull(datoProveedor.NOMBRE_PROVEEDOR,'&nbsp;') as NOMBRE_PROVEEDOR");
                            consulta.append(" ,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO,m.MOVIMIENTO_ITEM");
                    consulta.append(" from materiales m");
                            consulta.append(" inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=m.COD_ESTADO_REGISTRO");
                            consulta.append(" inner join grupos g on g.COD_GRUPO=m.COD_GRUPO");
                            consulta.append(" inner JOIN capitulos c on c.COD_CAPITULO=g.COD_CAPITULO");
                            consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (2,6,8,9)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN in (").append(codAlmacen).append(")");
                            consulta.append(" ) as aprobados");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (2,6,8,9)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN =17");
                            consulta.append(" ) as aprobadosTransitorio");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");		
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (1)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN in (").append(codAlmacen).append(")");
                            consulta.append(" ) as cuarentena");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");		
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (1)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN =17");
                            consulta.append(" ) as cuarentenaTransitorio");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (3)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN in (").append(codAlmacen).append(")");
                            consulta.append(" ) as rechazado");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1	");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (4)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN in (").append(codAlmacen).append(")");
                            consulta.append(" ) as vencido");
                            consulta.append(" outer apply");
                            consulta.append(" (");
                                    consulta.append(" select SUM(iade.cantidad_restante) as cantidad");
                                    consulta.append(" from INGRESOS_ALMACEN_DETALLE_ESTADO iade");
                                    consulta.append(" inner join INGRESOS_ALMACEN ia on iade.COD_INGRESO_ALMACEN=ia.COD_INGRESO_ALMACEN");
                                    consulta.append(" where iade.COD_MATERIAL=m.COD_MATERIAL");
                                            consulta.append(" and ia.COD_ESTADO_INGRESO_ALMACEN=1");
                                            consulta.append(" and ia.ESTADO_SISTEMA=1");
                                            consulta.append(" and ia.FECHA_INGRESO_ALMACEN<'").append(sdf.format(new Date())).append("'");
                                            consulta.append(" and iade.COD_ESTADO_MATERIAL in (5)");
                                            consulta.append(" and iade.CANTIDAD_RESTANTE>0");
                                            consulta.append(" and ia.COD_ALMACEN in (").append(codAlmacen).append(")");
                            consulta.append(" ) as reanalisis");
                            consulta.append(" outer APPLY");
                            consulta.append(" (");
                                consulta.append(" select top 1 (ocd.CANTIDAD_NETA-ocd.CANTIDAD_INGRESO_ALMACEN)*isnull(equivalencia.equivalencia,1) as cantidadTransito,oc.FECHA_ENTREGA");
                                consulta.append(" from ORDENES_COMPRA oc");
                                        consulta.append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA=ocd.COD_ORDEN_COMPRA");
                                        consulta.append(" outer APPLY");
                                        consulta.append(" (");
                                            consulta.append(" select (case WHEN ocd.COD_UNIDAD_MEDIDA=e.COD_UNIDAD_MEDIDA then e.VALOR_EQUIVALENCIA else 1/e.VALOR_EQUIVALENCIA end) as equivalencia");
                                            consulta.append(" from EQUIVALENCIAS e where ");
                                            consulta.append(" (e.COD_UNIDAD_MEDIDA=ocd.COD_UNIDAD_MEDIDA and e.COD_UNIDAD_MEDIDA2=m.COD_UNIDAD_MEDIDA) or");
                                            consulta.append(" (e.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and e.COD_UNIDAD_MEDIDA2=ocd.COD_UNIDAD_MEDIDA)");
                                        consulta.append(" ) as equivalencia");
                                consulta.append(" where oc.COD_ESTADO_COMPRA in (2,6,13)");
                                        consulta.append(" and oc.ESTADO_SISTEMA=1");
                                    consulta.append(" and ocd.COD_MATERIAL=m.COD_MATERIAL");
                                    consulta.append(" and oc.FECHA_ENTREGA>'").append(sdfOc.format(new Date())).append("'");
                                    consulta.append(" and (ocd.CANTIDAD_NETA-ocd.CANTIDAD_INGRESO_ALMACEN)>0");
                               consulta.append(" order by oc.FECHA_EMISION desc");
                             consulta.append(" ) as datosOrdenCompra");
                             consulta.append(" outer apply");
                             consulta.append(" (");
                                 consulta.append(" select top 1 p.NOMBRE_PROVEEDOR");
                                consulta.append(" from ORDENES_COMPRA oc");
                                        consulta.append(" inner join ORDENES_COMPRA_DETALLE ocd on oc.COD_ORDEN_COMPRA=ocd.COD_ORDEN_COMPRA");
                                    consulta.append(" inner join PROVEEDORES p on p.COD_PROVEEDOR=oc.COD_PROVEEDOR");
                                consulta.append(" where ocd.COD_MATERIAL=m.COD_MATERIAL and oc.COD_ESTADO_COMPRA  in (2,5,6,7,13,14,18)");//aprobada,en transito,ingresada parcialmente,ingresada en su totalidad enviadas al proveedor,ejecutada en su totalidad
                               consulta.append(" order by oc.FECHA_EMISION desc");
                             consulta.append(" ) as datoProveedor");
                    consulta.append(" where m.COD_MATERIAL in(").append(items.toString()).append(")");
                    consulta.append(" order by m.NOMBRE_MATERIAL");
        System.out.println("consulta exitencias almacen "+consulta.toString());
        res=st.executeQuery(consulta.toString());
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat formato = (DecimalFormat) nf;
        formato.applyPattern("#,##0.00");
        sdf=new SimpleDateFormat("dd/MM/yyyy");
        while(res.next())
        {
            //datos de lotes que utilizan un material
                pstLotes.setInt(1,res.getInt("cod_material"));
                resLotes=pstLotes.executeQuery();
                innerHTMLLotes=new StringBuilder("");
                cantidadUtilizarMaterial=0d;
                cantidadRowSpan=1;
                while(resLotes.next())
                {
                    if(resLotes.getRow()>1)
                        innerHTMLLotes.append("<tr>");
                            innerHTMLLotes.append("<td>").append(resLotes.getString("nombre_prod_semiterminado")).append("</td>");
                            innerHTMLLotes.append("<td>").append(resLotes.getString("NOMBRE_TIPO_MATERIAL")).append("</td>");
                            innerHTMLLotes.append("<td>").append(resLotes.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                            innerHTMLLotes.append("<td align='right'>").append(formato.format(resLotes.getDouble("cantidadLote"))).append("</td>");
                    innerHTMLLotes.append("</tr>");
                    cantidadUtilizarMaterial+=resLotes.getDouble("cantidadLote");
                    cantidadRowSpan++;
                }
                innerHTMLLotes.append("<tr>");
                    innerHTMLLotes.append("<td colspan=3 align='right' class='outputTextBold'>Total::</td>");
                    innerHTMLLotes.append("<td align='right' class='outputTextBold' >").append(formato.format(cantidadUtilizarMaterial)).append("</td>");
                innerHTMLLotes.append("</tr>");
            //datos calculados
            Double cantidadDisponible=res.getDouble("cantidadAprobadosTransitorio")+res.getDouble("cantidadCuarentenaTransitorio")+res.getDouble("cantidadAprobados")+res.getDouble("cantidadCuarentena")+res.getDouble("cantidadReanalisis");
            //imprimiendo datos obtenidos
            out.println("<tr>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getRow()+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_CAPITULO")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_MATERIAL")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("STOCK_MINIMO_MATERIAL"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("STOCK_SEGURIDAD"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("STOCK_MAXIMO_MATERIAL"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadAprobadosTransitorio"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadCuarentenaTransitorio"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadAprobados"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadCuarentena"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadRechazados"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadVencido"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(res.getDouble("cantidadReanalisis"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(cantidadDisponible)+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'>"+formato.format(cantidadUtilizarMaterial)+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right'  class='"+(cantidadDisponible-cantidadUtilizarMaterial>0?"conexistencia":"sinexistencia")+"'>"+formato.format(cantidadDisponible-cantidadUtilizarMaterial)+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right' class='"+(cantidadDisponible-cantidadUtilizarMaterial-res.getDouble("STOCK_SEGURIDAD")>0?"conexistencia":"sinexistencia")+"'>"+formato.format(cantidadDisponible-cantidadUtilizarMaterial-res.getDouble("STOCK_SEGURIDAD"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right' class='"+(res.getInt("MOVIMIENTO_ITEM")==1&&res.getInt("COD_ESTADO_REGISTRO")==1?"conexistencia":"sinexistencia")+"'>"+res.getString("NOMBRE_ESTADO_REGISTRO")+";"+(res.getInt("MOVIMIENTO_ITEM")==1?"con":"sin")+" movimiento</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' align='right' class='enTransito'>"+formato.format(res.getDouble("cantidadTransito"))+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+(res.getTimestamp("fecha_Entrega")!=null?sdf.format(res.getTimestamp("fecha_Entrega")):"&nbsp;")+"</td>");
                out.println("<td rowspan='"+cantidadRowSpan+"' class='enTransito'>"+res.getString("NOMBRE_PROVEEDOR")+"</td>");
                
                out.println("<td rowspan='"+cantidadRowSpan+"'><a href=\"../reporteExplosionProductosSimulacion/detalleDatosCompraItem.jsf?codigo="+res.getInt("cod_material")+">\" target='_BLANK'>Ver Detalles de Compra</a></td>");
                
                out.println(innerHTMLLotes.toString());
        }
        %>
            </tbody>
        </table>
        <center>
            <button class="btn" onclick="window.location.href='navegadorProgramaProduccionSimulacion.jsf?data='+(new Date()).getTime().toString();">Volver</button>
        </center>
    </body>
</html>
