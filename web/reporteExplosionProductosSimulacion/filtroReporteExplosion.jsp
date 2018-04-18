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
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>


<%
Connection con = null;
        con = Util.openConnection(con);
%>

<%!    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
%>
<%!    public double compara(int unidad1, int unidad2) {
        String nombre_material = "", nombre_unidad_medida = "", nombre_unidad_medida2 = "";
        Connection con1=null;
        double valor_equivalencia = 1;
        try {
            con1=Util.openConnection(con1);
            String sql = "select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
            sql += " from equivalencias";
            sql += " where cod_unidad_medida=" + unidad1;
            sql += " and cod_unidad_medida2=" + unidad2;
            sql += " and cod_estado_registro=1";
            System.out.println("sql:1***********" + sql);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            int sw = 0;
            double equivalencia = 0;
            while (rs.next()) {
                equivalencia = rs.getDouble(3);
                sw = 1;
            }
            if (sw == 1) {
                valor_equivalencia = 1 / equivalencia;
            } else {
                String sql2 = "select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
                sql2 += " from equivalencias";
                sql2 += " where cod_unidad_medida=" + unidad2;
                sql2 += " and cod_unidad_medida2=" + unidad1;
                sql2 += " and cod_estado_registro=1";
                System.out.println("sql:2***********" + sql2);
                Statement st2 = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2 = st2.executeQuery(sql2);
                sw = 0;
                while (rs2.next()) {
                    sw = 1;
                    equivalencia = rs2.getDouble(3);
                }
                if (sw == 1) {
                    valor_equivalencia = equivalencia;
                }
            }
            con1.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("valor_equivalencia:" + valor_equivalencia);
        return valor_equivalencia;
    }
%>
<%!
public String proveedorUltimaCompra(String codMaterial){
    String proveedor = "";
    Connection con1=null;
    try{
        con1=Util.openConnection(con1);
    String consulta= " select top 1 p.NOMBRE_PROVEEDOR from ORDENES_COMPRA o, ORDENES_COMPRA_DETALLE od, PROVEEDORES p " +
            " where o.COD_ORDEN_COMPRA=od.COD_ORDEN_COMPRA and o.COD_PROVEEDOR=p.COD_PROVEEDOR and " +
            " od.COD_MATERIAL='"+codMaterial+"' and o.COD_ESTADO_COMPRA not in(1,3,4,8,10,11,12) order by o.FECHA_EMISION desc;  ";
    Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    ResultSet rs = st.executeQuery(consulta);
    if(rs.next()){
        proveedor = rs.getString("NOMBRE_PROVEEDOR");
    }
    con1.close();
    }catch(Exception e){
        e.printStackTrace();
    }
    return proveedor;
}
public int materialReanalisis(String codMaterial){
    int cant = 0;
    Connection con1=null;
    try{
    con1=Util.openConnection(con1);
    String consulta= " select sum(i.cantidad_restante) detalle from INGRESOS_ALMACEN ia" +
                        " inner join INGRESOS_ALMACEN_DETALLE iad on iad.COD_INGRESO_ALMACEN = ia.COD_INGRESO_ALMACEN" +
                        " inner join INGRESOS_ALMACEN_DETALLE_ESTADO i" +
                        " on i.COD_INGRESO_ALMACEN = iad.COD_INGRESO_ALMACEN and i.COD_MATERIAL = iad.COD_MATERIAL" +
                        " inner join PROVEEDORES p on p.COD_PROVEEDOR = ia.COD_PROVEEDOR" +
                        " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = iad.COD_UNIDAD_MEDIDA" +
                        " where i.COD_MATERIAL = '"+codMaterial+"' and i.CANTIDAD_RESTANTE>0.01 and i.FECHA_VENCIMIENTO<=getdate()" +
                        " and ia.cod_estado_ingreso_almacen = 1 ";
    System.out.println("consulta " + consulta);
    Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    ResultSet rs = st.executeQuery(consulta);
    if(rs.next()){
        cant = rs.getInt("detalle");
    }
    con1.close();
    }catch(Exception e){
        e.printStackTrace();
    }
    return cant;
}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function enviarForm(f)
            {   //sacar el valor del multiple
                /***** CAPITULO ******/
                f.cod_capitulo.value=f.cod_capitulo.value;
                /*************************** GRUPOS  *************************/
                /*var arrayGrupos=new Array();
                var j=0;
        for(var i=0;i<=f.cod_grupo.options.length-1;i++)
        {	if(f.cod_grupo.options[i].selected)
            {	arrayGrupos[j]=f.cod_grupo.options[i].value;
                                //arrayLineaMkt1[j]=f.cod_grupo.options[i].innerHTML;
                j++;
            }
        }
                f.codGrupos.value=arrayGrupos;
                 */
                /*************************** ITEMS *************************/
                var arrayItem=new Array();
                //var arrayCliente1=new Array();
                var j=0;
                for(var i=0;i<=f.cod_item.options.length-1;i++)
                {	if(f.cod_item.options[i].selected)
                    {	arrayItem[j]=f.cod_item.options[i].value;
                        //arrayCliente1[j]=f.cod_item.options[i].innerHTML;
                        j++;
                    }
                }
                f.codItems.value=arrayItem;
                //f.nombreCliente.value=arrayCliente1;

                /*alert(arrayGrupos);
                alert(arrayItem);
                alert("capitulo:"+f.cod_capitulo.value);
                alert("grupo:"+f.codGrupos.value);
                alert("item:"+f.codItems.value);*/
                /*----- ajax  --------------*/
                var ajax=nuevoAjax();
                var url='../reporteExplosionProductosSimulacion/reporteExplosionProductos.jsf';
                var url2='codigo1='+f.cod_prog.value;
                url2+='&codigo3='+f.codItems.value;
                url2+='&fecha_inicio='+f.fechaInicioPrograma.value;
                url2+='&fecha_final='+f.fechaFinalPrograma.value;
                url2+='&pq='+(Math.random()*1000);

                ajax.open ('post', url, true);
                ajax.onreadystatechange = function() {
                    if (ajax.readyState==1) {

                    }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            var panel=document.getElementById('panel');
                            panel.innerHTML=ajax.responseText;

                        }
                    }
                }
                ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
                ajax.send(url2);





            }
            function retornarAtras(f){
                location.href='planillaSubsidio.jsp';
            }
            function guardar(f){
                f.submit();
            }
            function nuevoAjax()
            {	var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }
                return xmlhttp;
            }
            function grupo(codigo){
                //alert();

                var ajax=nuevoAjax();
                var url='../reporteExplosionProductosSimulacion/explosionGrupoajax.jsp?codigo='+codigo;
                url+='&pq='+(Math.random()*1000);
                // alert(url);
                ajax.open ('GET', url, true);
                ajax.onreadystatechange = function() {
                    //alert(ajax.readyState);
                    if (ajax.readyState==1) {
                        //alert("hola");
                    }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            //alert(ajax.responseText);
                            var mainGrupo=document.getElementById('mainGrupo');
                            mainGrupo.innerHTML=ajax.responseText;
                            f=0;
                            Item(codigo,f);
                        }
                    }
                }
                ajax.send(null);
            }
            function Item(codigo,f){

                var ajax=nuevoAjax();
                if(f==0){
                    codGrupo=0;
                    //alert(codGrupo);
                }else{
                    //alert(f.cod_capitulo.value);
                    // var codGrupo=document.getElementById('cod_capitulo').value;
                    var codGrupo=f.cod_grupo.value;
                    codigo=f.cod_capitulo.value;
                    //alert(codigo);
                    var arrayGrupo=new Array();
                    var j=0;
                    for(var i=0;i<=f.cod_grupo.options.length-1;i++)
                    {
                        if(f.cod_grupo.options[i].selected)
                        {
                            arrayGrupo[j]=f.cod_grupo.options[i].value;
                            j++;
                        }
                    }
                    codGrupo=arrayGrupo;
                }

                //alert(codGrupo);
                var url='../reporteExplosionProductosSimulacion/explosionItemajax.jsp?codigo='+codigo+'&cod_grupo='+codGrupo;
                url+='&pq='+(Math.random()*1000);
                ajax.open ('GET', url, true);
                ajax.onreadystatechange = function() {
                    if (ajax.readyState==1) {

                    }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            //alert(ajax.responseText);
                            var mainItem=document.getElementById('mainItem');
                            mainItem.innerHTML=ajax.responseText;
                        }
                    }
                }
                ajax.send(null);
            }

            function sel_todoItem(f){
                var arrayItem=new Array();
                var j=0;
                for(var i=0;i<=f.cod_item.options.length-1;i++)
                {   if(f.chk_Item.checked==true)
                    {   f.cod_item.options[i].selected=true;
                        arrayItem[j]=f.cod_item.options[i].value;
                        j++;
                    }
                    else
                    {   f.cod_item.options[i].selected=false;
                    }
                }
            }
            function enviarReanalisisMaterial(codCapitulo){
                //alert();

                var elements=document.getElementById('rptExplosion');
                var rowsElement=elements.rows;
                var materiales = "0";
                for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='hidden'){
                                //alert(cel.getElementsByTagName('input')[0].value);
                                materiales = materiales +"," +cel.getElementsByTagName('input')[0].value;
                            }
                        }

                var ajax=nuevoAjax();
                var url='../reporteExplosionProductosSimulacion/ajaxGuardarReanalisis1.jsp?codMaterial='+materiales;
                url+='&pq='+(Math.random()*1000);
                // alert(url);
                ajax.open ('GET', url, true);
                ajax.onreadystatechange = function() {
                    //alert(ajax.readyState);
                    if (ajax.readyState==1) {
                        //alert("hola");
                    }else if(ajax.readyState==4){
                        if(ajax.status==200){
                            //alert(ajax.responseText);
                            //var divGrupo=document.getElementById('div_grupo');
                            //divGrupo.innerHTML=ajax.responseText;
                            alert("se realizo el cambio en los materiales para reanalisis")
                        }
                    }
                }
                ajax.send(null);
            }
            function seleccionarTodo(){
                    //alert('entro');
                    var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
                    var elements=document.getElementById('form1:dataFormula');

                    if(seleccionar_todo.checked==true){
                        //alert('entro por verdad');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=true;
                            }
                        }
                    }
                    else
                    {//alert('entro por false');
                        var rowsElement=elements.rows;
                        for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel=cellsElement[0];
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                cel.getElementsByTagName('input')[0].checked=false;
                            }
                        }

                    }
                    return true;

                }
        </script>
    </head>
    <body>
        <form name="form1" action="../reporteExplosionProductosSimulacion/reporteExplosionProductos.jsp" method="post">
            <%
        String sql = "";
        String sql1 = "";
        String sql2 = "";
        String sql3 = "";
        String consulta = "";
        String sql5 = "";
        String cod_capitulo = "";
        String nombre_capitulo = "";
        String cod_beneficiario = "";
        String nombre_beneficiario = "";
        String cod_subsidio = "";
        String nombre_subsidio = "";
        String monto_subsidio = "";
        String codlote=(request.getParameter("lotes")!=null?request.getParameter("lotes"):"");
        String codProgramaProd = request.getParameter("codProgramaProduccion");
        String codProductos = request.getParameter("codigos");
        codProductos = codProductos + "0";
        String fechaInicio = request.getParameter("fecha_inicio");

        String fechaFinal = request.getParameter("fecha_final");
        boolean conProductosEnProceso = (request.getParameter("conProductosEnProceso").equals("1"));
        System.out.println("codProductos:" + codProductos);
        System.out.println("codProgramaProd:" + codProgramaProd);
        System.out.println("conProductosEnProceso" + conProductosEnProceso);
        /*String sql_max = "select min(pp.FECHA_INICIO),MAX(pp.FECHA_FINAL) from PROGRAMA_PRODUCCION pp";
        sql_max += " where pp.COD_PROGRAMA_PROD='" + codProgramaProd + "'";
        Statement st_max = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_max = st_max.executeQuery(sql_max);
        while (rs_max.next()) {
            fechaInicio = rs_max.getString(1);
            fechaFinal = rs_max.getString(2);
            String fechaInicioVector[] = fechaInicio.split(" ");
            fechaInicioVector = fechaInicioVector[0].split("-");
            fechaInicio = fechaInicioVector[0] + "/" + fechaInicioVector[1] + "/" + fechaInicioVector[2];
            String fechaFinalVector[] = fechaFinal.split(" ");
            fechaFinalVector = fechaFinalVector[0].split("-");
            fechaFinal = fechaFinalVector[0] + "/" + fechaFinalVector[1] + "/" + fechaFinalVector[2];
        }
        System.out.println("fechaInicio:" + fechaInicio);
        System.out.println("fechaFinal:" + fechaFinal);
*/
        //INSERTAMOS EN LA TABLA DE EXPLOSION DE PRODUCTOS
        String vecCodigos[] = codProductos.split(",");
        String sqlBorrarProd = "delete from explosion_productos where cod_programa_produccion=" + codProgramaProd;
        Statement stBorrarProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stBorrarProd.executeUpdate(sqlBorrarProd);
        String sqlInsertaProd = "";
        Statement stInsertaProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        for (int ii = 0; ii <= vecCodigos.length - 2; ii++) {
            sqlInsertaProd = "insert into explosion_productos(cod_programa_produccion, cod_compprod) values(" + codProgramaProd + "," + vecCodigos[ii] + ")";
            Statement stInserta = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            System.out.println("SQL INSERTA PROD: " + sqlInsertaProd);
            stInserta.executeUpdate(sqlInsertaProd);
        }
        //codigos de lotes en proceso
        String codigoProducto = "'0'";
        String codCompProd1 = "0";
        if(conProductosEnProceso){
            consulta = " select cast(p.COD_PROGRAMA_PROD as varchar)+''+cast(p.COD_COMPPROD as varchar)+''+cast(p.COD_TIPO_PROGRAMA_PROD as varchar)+''+cast(p.COD_LOTE_PRODUCCION as varchar) codigo_producto from PROGRAMA_PRODUCCION p" +
                    " where p.COD_ESTADO_PROGRAMA = 7 ";
            System.out.println("consulta " + consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                codigoProducto = codigoProducto+",'"+rs.getString("codigo_producto")+"'";
            }
        }
            %>

            <h4 align="center">Explosión de Materiales</h4>
            <br>
            <table width="65%" align="center" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="1" cellspacing="1">
                <tr class="headerClassACliente">
                    <td  colspan="3" align="center" class=colh style="border : solid #f2f2f2 0px;">Filtrar Por</td>
                </tr>
                <tr class="border">
                    <td >Capítulo  </td>
                    <td >::</td>
                    <td >
                        <%
        try {
            sql5 = "select cod_capitulo,nombre_capitulo from capitulos";
            sql5 += " where cod_estado_registro=1 order by nombre_capitulo";
            System.out.println("sql5 " + sql5);
            Statement st5 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs5 = st5.executeQuery(sql5);
                        %>
                        <select name="cod_capitulo" class="inputText2" onchange ="grupo(this.value)" id="cod_capitulo">
                            <%
                            while (rs5.next()) {
                                cod_capitulo = rs5.getString("cod_capitulo");
                                nombre_capitulo = rs5.getString("nombre_capitulo");
                            %>
                            <option value="<%=cod_capitulo%>"><%=nombre_capitulo%></option>
                            <%
                            }
                            %>
                        </select>
                        <%
        } catch (Exception e) {
        }
                        %>
                    </td>
                </tr>
                <tr class="border">
                    <td >Grupos</td>
                    <td >::</td>
                    <td >
                        <div id="mainGrupo">
                            <select name="cod_grupo" class="inputText2"  multiple>
                                <option>Seleccione una opcion
                            </select>
                        </div>
                    </td>
                </tr>
                <tr class="border">
                    <td >Item</td>
                    <td >::</td>
                    <td >
                        <div id="mainItem">
                            <select name="cod_item" class="inputText2" multiple>
                                <option>Seleccione una opcion
                            </select>

                        </div>

                    </td>
                </tr>

            </table>
            <input type="hidden" name="codGrupos">
            <input type="hidden" name="codItems">
            <input type="hidden" name="fechaInicioPrograma" value="<%=fechaInicio%>">
            <input type="hidden" name="fechaFinalPrograma" value="<%=fechaFinal%>">
            <br>
            <div align="center">
                <input type="button"  class="btn" value="Ver" name="ab" onClick="enviarForm(form1)">

            </div>

            <%
        try {
            String cod_grupos = request.getParameter("codGrupos");
            cod_capitulo = request.getParameter("cod_capitulo");
            String cod_items = request.getParameter("codItems");
            Date fechaActual = new Date();
            SimpleDateFormat f = new SimpleDateFormat("yyyy/MM/dd");
            String fecha_existencia = f.format(fechaActual);
            //fecha_existencia="2009-12-10";
            //String capitulo=" and c.cod_capitulo in ("+cod_capitulo+")";
            //String grupos=" and g.cod_grupo in ("+cod_grupos+")";
            String items = " "; //and m.cod_material in (
            consulta = "select  DISTINCT PPRD.COD_MATERIAL, M.NOMBRE_MATERIAL from PROGRAMA_PRODUCCION PPR INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPRD " +
                    " ON pprd.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                    " and ppr.COD_COMPPROD = pprd.COD_COMPPROD and ppr.COD_TIPO_PROGRAMA_PROD = pprd.COD_TIPO_PROGRAMA_PROD " +
                    " and ppr.COD_LOTE_PRODUCCION = pprd.COD_LOTE_PRODUCCION " +
                    " INNER JOIN MATERIALES M ON PPRD.COD_MATERIAL = M.COD_MATERIAL " +
                    " where PPR.COD_PROGRAMA_PROD in ("+codProgramaProd+")  and PPRD.cod_compprod in ("+codProductos+")  " +
                    " and ( PPRD.COD_MATERIAL in ( select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep where ep.COD_FORMULA_MAESTRA=PPR.COD_FORMULA_MAESTRA) " +
                    " OR PPRD.COD_MATERIAL in ( select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR ep where ep.COD_FORMULA_MAESTRA = PPR.COD_FORMULA_MAESTRA ) " +
                    " OR PPRD.COD_MATERIAL IN (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP ep  where ep.COD_FORMULA_MAESTRA=PPR.COD_FORMULA_MAESTRA) " +
                    " OR PPRD.COD_MATERIAL IN (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA=PPR.COD_FORMULA_MAESTRA ) " +
                    " OR PPRD.COD_MATERIAL IN ( select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MPROM ep where ep.COD_FORMULA_MAESTRA=PPR.COD_FORMULA_MAESTRA ))" +
                    (conProductosEnProceso?" union" +
                    " select DISTINCT PPRD.COD_MATERIAL, M.NOMBRE_MATERIAL from PROGRAMA_PRODUCCION PPR INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPRD " +
                    " ON PPR.COD_PROGRAMA_PROD = PPRD.COD_PROGRAMA_PROD " +
                    " INNER JOIN MATERIALES M ON PPRD.COD_MATERIAL = M.COD_MATERIAL " +
                    " where cast(PPRD.COD_PROGRAMA_PROD as varchar)+''+cast(PPRD.COD_COMPPROD as varchar)+''+cast(PPRD.COD_TIPO_PROGRAMA_PROD as varchar)+''+cast(PPRD.COD_LOTE_PRODUCCION as varchar)  in ("+codigoProducto+") " +
                    " and ( PPRD.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA=PPR.COD_FORMULA_MAESTRA ))  ":"");

            System.out.println("consula inicio" + consulta);
            Statement st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs4 = st4.executeQuery(consulta);
            while (rs4.next()) {
                items += rs4.getString(1) + ",";
            }
            items += "0 "; //0)
            System.out.println("item:" + items);
            String hora="23:59:00";
            String sql_exp = "";
            sql_exp = "select m.cod_material,m.stock_minimo_material,m.stock_maximo_material,m.stock_seguridad,m.cod_unidad_medida,m.nombre_material,u.nombre_unidad_medida,";
            sql_exp += " (select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 " +
                    " and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 " +
                    " and iade.cod_material=iad.cod_material " +
                    " and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            sql_exp += "  and ia.fecha_ingreso_almacen<='" +fecha_existencia+" "+hora+"' )as aprobados,";

            /* --------------------   SALIDAS ----------------------*/
            sql_exp += " (select SUM(sadi.cantidad)";
            sql_exp += " from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa";
            sql_exp += " WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and";
            sql_exp += " sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and";
            sql_exp += " sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA ";
            
            //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and sa.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
            //else sql_exp+="and (sa.cod_almacen=1 or sa.cod_almacen=2)";
            sql_exp += " and sad.cod_material=m.cod_material  and sa.fecha_salida_almacen<='" + fecha_existencia + "')as salidas,";
            /* --------------------   DEVOLUCIONES ----------------------*/
            sql_exp += "(select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad";
            sql_exp += " where ia.cod_devolucion=d.cod_devolucion  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1";
            //if(lcb_almacen.KeyValue<>null)then sql_exp+="and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+' and d.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
            sql_exp += " and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=m.cod_material)as devoluciones,";
            /* --------------------   CUARENTENA ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
            //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
            sql_exp += " and iade.cod_estado_material=1  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "')as cuarentena,";
            /* --------------------   RECHAZADO ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
            //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
            sql_exp += " and iade.cod_estado_material=3  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "')as rechazado,";
            /* --------------------   VENCIDO ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
            //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
            sql_exp += " and iade.cod_estado_material=4  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "'  )as vencido,";
            /* --------------------   OBSOLETO ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)";
            sql_exp += " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia";
            sql_exp += " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen";
            //if(lcb_almacen.KeyValue<>null)then sql_exp+=" and ia.cod_almacen='+inttostr(lcb_almacen.KeyValue)+'";
            //else sql_exp+="and (ia.cod_almacen=1 or ia.cod_almacen=2)";
            sql_exp += " and iade.cod_estado_material=5  and ia.fecha_ingreso_almacen<='" + fecha_existencia + "')as obsoleto,";
            sql_exp += " ( select sum(ppd.CANTIDAD) from reserva r inner join PROGRAMA_PRODUCCION p on p.COD_PROGRAMA_PROD = r.COD_PROGRAMA_PROD " +
                    "and r.COD_COMPPROD = p.COD_COMPPROD and r.COD_LOTE = p.COD_LOTE_PRODUCCION " +
                    "and r.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD inner join PROGRAMA_PRODUCCION_DETALLE ppd on ppd.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD " +
                     "and ppd.COD_COMPPROD = p.COD_COMPPROD and ppd.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD and p.COD_LOTE_PRODUCCION = ppd.COD_LOTE_PRODUCCION " +
                     " and ppd.cod_material = m.cod_material) as reserva, c.NOMBRE_CAPITULO";
            sql_exp += " from materiales m,grupos g,capitulos c,UNIDADES_MEDIDA u ";
            sql_exp += " where m.cod_grupo=g.cod_grupo and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and u.cod_unidad_medida=m.cod_unidad_medida ";
            sql_exp += items;
            sql_exp += " order by m.nombre_material";
            sql_exp = "select m.cod_material,m.stock_minimo_material,m.stock_maximo_material,m.stock_seguridad,m.cod_unidad_medida,m.nombre_material,u.nombre_unidad_medida,";
            sql_exp += " (select SUM(iade.cantidad_restante)" +
                    "from ingresos_almacen_detalle_estado iade, ingresos_almacen_detalle iad, ingresos_almacen ia" +
                    " WHERE iade.cod_material = m.cod_material and ia.cod_estado_ingreso_almacen = 1 " +
                    " and iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and ia.estado_sistema = 1 " +
                    " and iade.cod_material = iad.cod_material and iade.cod_ingreso_almacen = iad.cod_ingreso_almacen " +
                    " and ia.fecha_ingreso_almacen <= '" +fecha_existencia+" "+hora+"' " +
                    " and iade.cod_estado_material in (2, 6,8) and iade.cantidad_restante > 0 and ia.cod_almacen in(1,2,9))as aprobados,";

            /* --------------------   SALIDAS ----------------------*/
            sql_exp += " (0)as salidas,";
            /* --------------------   DEVOLUCIONES ----------------------*/
            sql_exp += "(0)as devoluciones,";
            /* --------------------   CUARENTENA ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)" +
                    "from ingresos_almacen_detalle_estado iade, ingresos_almacen_detalle iad, ingresos_almacen ia" +
                    " WHERE iade.cod_material = m.cod_material and ia.cod_estado_ingreso_almacen = 1 " +
                    " and iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and ia.estado_sistema = 1 " +
                    " and iade.cod_material = iad.cod_material and iade.cod_ingreso_almacen = iad.cod_ingreso_almacen " +
                    " and ia.fecha_ingreso_almacen <= '" +fecha_existencia+" "+hora+"' " +
                    " and iade.cod_estado_material in (1) and iade.cantidad_restante > 0)as cuarentena,";
            /* --------------------   RECHAZADO ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)" +
                    "from ingresos_almacen_detalle_estado iade, ingresos_almacen_detalle iad, ingresos_almacen ia" +
                    " WHERE iade.cod_material = m.cod_material and ia.cod_estado_ingreso_almacen = 1 " +
                    " and iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and ia.estado_sistema = 1 " +
                    " and iade.cod_material = iad.cod_material and iade.cod_ingreso_almacen = iad.cod_ingreso_almacen " +
                    " and ia.fecha_ingreso_almacen <= '" +fecha_existencia+" "+hora+"' " +
                    " and iade.cod_estado_material in (3) and iade.cantidad_restante > 0)as rechazado,";
            /* --------------------   VENCIDO ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)" +
                    "from ingresos_almacen_detalle_estado iade, ingresos_almacen_detalle iad, ingresos_almacen ia" +
                    " WHERE iade.cod_material = m.cod_material and ia.cod_estado_ingreso_almacen = 1 " +
                    " and iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and ia.estado_sistema = 1 " +
                    " and iade.cod_material = iad.cod_material and iade.cod_ingreso_almacen = iad.cod_ingreso_almacen " +
                    " and ia.fecha_ingreso_almacen <= '" +fecha_existencia+" "+hora+"' " +
                    " and iade.cod_estado_material in (4) and iade.cantidad_restante > 0)as vencido,";
            /* --------------------   OBSOLETO ----------------------*/
            sql_exp += " (select SUM(iade.cantidad_restante)" +
                    "from ingresos_almacen_detalle_estado iade, ingresos_almacen_detalle iad, ingresos_almacen ia" +
                    " WHERE iade.cod_material = m.cod_material and ia.cod_estado_ingreso_almacen = 1 " +
                    " and iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and ia.estado_sistema = 1 " +
                    " and iade.cod_material = iad.cod_material and iade.cod_ingreso_almacen = iad.cod_ingreso_almacen " +
                    " and ia.fecha_ingreso_almacen <= '" +fecha_existencia+" "+hora+"' " +
                    " and iade.cod_estado_material in (5) and iade.cantidad_restante > 0)as reanalisis,";
            sql_exp += " (0) as reserva,g.NOMBRE_GRUPO , c.NOMBRE_CAPITULO ";

            sql_exp += " from materiales m,grupos g,capitulos c,UNIDADES_MEDIDA u ";
            sql_exp += " where m.cod_grupo=g.cod_grupo and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and m.movimiento_item = 1 and m.cod_estado_registro = 1 and u.cod_unidad_medida=m.cod_unidad_medida ";
            sql_exp += " and m.cod_material in ( " + items  + " )";
            sql_exp += " order by m.nombre_material";
            System.out.println("sql_exp:" + sql_exp);
            %>

            <DIV ALIGN="CENTER" CLASS="outputText2" >
                <br>
                <br>
                <b> Detalle de Explosión de Materiales</b>
                <br>
                <br>

                <table width="60%" align="center" class="outputText2">
                    <tr>
                        <td>Normal : </td>
                        <td bgcolor="#F5D2F3" width="12%" >&nbsp;</td>
                        <td>Faltante : </td>
                        <td bgcolor="#FC8585" width="12%">&nbsp;</td>
                        <td>Pedido : </td>
                        <td bgcolor="#CDF6F8" width="12%">&nbsp;</td>
                        <td>En Tránsito: </td>
                        <td bgcolor="#B4F5B6" width="12%">&nbsp;</td>
                        <td>Productos en Proceso: </td>
                        <td bgcolor="aqua" width="12%">&nbsp;</td>
                    </tr>
                </table>
            </DIV>
            <DIV ALIGN="CENTER" CLASS="outputText2" ID="panel">
                <br>
                <br>
                <input type="hidden" id="item" name="item" value="<%=items%>">
                <input type="hidden" id="cod_prog" name="cod_prog" value="<%=codProgramaProd%>">
                <table width="95%" align="center" name="rptExplosion" id="rptExplosion" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">
                    <tr class="headerClassACliente">
                        <th  align="center" style="border : solid #f2f2f2 1px;">Nro</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Clasificacion</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Material</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Stock Min</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Stock Reposicion</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Stock Max</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Unid. Med.</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Aprob</th>
                        <!--<th  align="center" style="border : solid #f2f2f2 1px;">Salidas</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Devol</th>!-->
                        <th  align="center" style="border : solid #f2f2f2 1px;">Cuar</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Rech</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Venc</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Reanalisis</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Reserva</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Disponible</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">A Utilizar Prod.</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Diferencia</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Diferencia Stock Reposicion</th>
                        <%--th  align="center" style="border : solid #f2f2f2 1px;">Pedido</th--%>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Tránsito</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Fecha Entrega</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Proveedor Ultima Compra</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Reanalisis</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Datos de Compra</th>
                        <th  align="center" style="border : solid #f2f2f2 1px;">Productos</th>
                    </tr>
                    <%
                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2 = st2.executeQuery(sql_exp);

                int count = 0;
                //BORRAMOS LA TABLA DE EXPLOSION DE MATERIALES
                String sqlBorrarExplosion = "delete from explosion_materiales where cod_programa_produccion in (" + codProgramaProd + ")";
                Statement stBorrarExplosion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                System.out.println("sqlBorraExplosion: " + sqlBorrarExplosion);
                stBorrarExplosion.executeUpdate(sqlBorrarExplosion);

                while (rs2.next()) {
                    System.out.println("erer");
                    String codMaterial = rs2.getString(1);
                    double stockMinimo = rs2.getDouble(2);
                    stockMinimo = redondear(stockMinimo, 3);
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat) nf;
                    form.applyPattern("#,###.00");
                    String stock_minimo = form.format(stockMinimo);
                    double stockMaximo = rs2.getDouble(3);
                    stockMaximo = redondear(stockMaximo, 3);
                    String stock_maximo = form.format(stockMaximo);
                    double stockSeguridad = rs2.getDouble(4);
                    stockSeguridad = redondear(stockSeguridad, 3);
                    String stock_segu = form.format(stockSeguridad);
                    String cod_unidadMedida = rs2.getString(5);
                    String nombreMaterial = rs2.getString(6);
                    String nombreUnidadMedida = rs2.getString(7);
                    double aprobados = rs2.getDouble(8);

                    double salidas = rs2.getDouble(9);
                    salidas = redondear(salidas, 3);
                    String salida = form.format(salidas);
                    double devoluciones = rs2.getDouble(10);
                    devoluciones = redondear(devoluciones, 3);
                    String devolucion = form.format(devoluciones);
                    double cuarentena = rs2.getDouble(11);
                    cuarentena = redondear(cuarentena, 3);
                    String cuaren = form.format(cuarentena);
                    double rechazado = rs2.getDouble(12);
                    rechazado = redondear(rechazado, 3);
                    String recha = form.format(rechazado);
                    double vencido = rs2.getDouble(13);
                    vencido = redondear(vencido, 3);
                    String venc = form.format(vencido);
                    double reanalisis = rs2.getDouble(14);
                    reanalisis = redondear(reanalisis, 3);
                    String obso = form.format(reanalisis);
                    //double reserva =0;
                    Double reserva = rs2.getDouble("reserva");
                    //reserva = redondear(reserva, 3);
                    //String reser = form.format(reserva);

                    System.out.println("aprobados "+aprobados +" salidas "+salidas+" devoluciones "+devoluciones+" rechazado "+rechazado+" vencido "+vencido+" reanalisis "+reanalisis+" reserva"+reserva);
                    double total = aprobados + cuarentena - salidas + devoluciones - rechazado - vencido + reanalisis - reserva;
                    //aprobados = aprobados - salidas + devoluciones - rechazado - vencido - obsoleto - reserva - cuarentena;
                    aprobados = redondear(aprobados, 3);
                    String aprob = form.format(aprobados);
                    total = redondear(total, 3);
                    //String disponible = form.format(total);
                    count++;
                    String nombreCapitulo = rs2.getString("NOMBRE_CAPITULO");
                    consulta = "select r.CANTIDAD from RESERVA_DETALLE r,reserva re ";
                    consulta += " where re.cod_programa_prod in (" + codProgramaProd + ") " ;
                    consulta += "  and r.cod_reserva=re.cod_reserva and r.COD_MATERIAL='" + codMaterial + "' ";
                    System.out.println("consulta:" + consulta);
                    st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs4 = st4.executeQuery(consulta);
                    double cantReservado = 0;
                    while (rs4.next()) {
                        cantReservado = rs4.getDouble(1);
                    }

                    consulta = "select ppd.COD_MATERIAL,ppd.CANTIDAD,ppd.COD_COMPPROD from " +
                            " programa_produccion ppr inner join PROGRAMA_PRODUCCION_DETALLE ppd on ppr.cod_programa_prod = ppd.cod_programa_prod" +
                            " and ppd.cod_compprod = ppr.cod_compprod and ppd.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod and ppd.cod_lote_produccion = ppr.cod_lote_produccion" +
                            " inner join tipos_programa_produccion tpp on tpp.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod" +
                            " inner join tipos_material tm on tm.cod_tipo_material = ppd.cod_tipo_material ";
                    consulta += " where ppd.COD_PROGRAMA_PROD in (" + codProgramaProd + ") and ppd.cod_material='" + codMaterial + "'" +
                            " union all select ppd.COD_MATERIAL,ppd.CANTIDAD,ppd.COD_COMPPROD from PROGRAMA_PRODUCCION_DETALLE ppd inner join formula_maestra fm on fm.cod_compprod = ppd.cod_compprod inner join formula_maestra_detalle_es fmes on fmes.cod_formula_maestra = fm.cod_formula_maestra and fmes.cod_material = ppd.cod_material "+
                            " where ppd.cod_material = '"+codMaterial+"' and cast(ppd.COD_PROGRAMA_PROD as varchar)+''+cast(ppd.COD_COMPPROD as varchar)+''+cast(ppd.COD_TIPO_PROGRAMA_PROD as varchar)+''+cast(ppd.COD_LOTE_PRODUCCION as varchar) in (" + codigoProducto + ")";
                    
                    consulta = " select sum(cantidad) cantidad from (SELECT ppd.CANTIDAD FROM PROGRAMA_PRODUCCION p, COMPONENTES_PROD cp," +
                            "PROGRAMA_PRODUCCION_DETALLE ppd, TIPOS_PROGRAMA_PRODUCCION tpp, tipos_material t " +
                            " where p.COD_PROGRAMA_PROD in ("+codProgramaProd+") and  p.COD_ESTADO_PROGRAMA in (4) and cp.COD_COMPPROD = p.COD_COMPPROD and" +
                            " cp.COD_COMPPROD = ppd.COD_COMPPROD and ppd.COD_COMPPROD = p.COD_COMPPROD and ppd.COD_MATERIAL = '"+codMaterial+"' " +
                            " and ppd.cod_lote_produccion = p.cod_lote_produccion and p.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD " +
                            " and ppd.cod_tipo_programa_prod = p.cod_tipo_programa_prod and tpp.cod_tipo_programa_prod = p.cod_tipo_programa_prod " +
                            (codlote.equals("")?"":" and p.COD_COMPPROD in("+codProductos+") and p.COD_LOTE_PRODUCCION+'$'+cast(p.COD_TIPO_PROGRAMA_PROD as varchar) in ("+codlote+")")+
                            " and t.cod_tipo_material = ppd.cod_tipo_material and ppd.cod_material in (" +
                                     " select fmdmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmdmp where fmdmp.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA " +
                                     " union all select fmdmr.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmdmr where fmdmr.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                                     " union all select fmdep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP fmdep where fmdep.COD_FORMULA_MAESTRA = p.cod_formula_maestra" +
                                     " union all select fmdes.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES fmdes where fmdes.COD_FORMULA_MAESTRA = p.cod_formula_maestra )" +

                            (conProductosEnProceso?" union all SELECT ppd.CANTIDAD FROM PROGRAMA_PRODUCCION p, COMPONENTES_PROD cp, " +
                            " PROGRAMA_PRODUCCION_DETALLE ppd,  TIPOS_PROGRAMA_PRODUCCION tpp,     tipos_material t,     formula_maestra_detalle_es fmes" +
                            " where cast (p.COD_PROGRAMA_PROD as varchar) + '' + cast (p.COD_COMPPROD as varchar) + '' + cast (p.COD_TIPO_PROGRAMA_PROD as varchar) + '' + cast ( " +
                            " p.COD_LOTE_PRODUCCION as varchar) in ("+codigoProducto+") and" +
                            "  p.cod_estado_programa = 7 and   cp.COD_COMPPROD = ppd.COD_COMPPROD and      ppd.COD_COMPPROD = p.COD_COMPPROD and" +
                            "      ppd.COD_MATERIAL = '"+codMaterial+"' and      ppd.cod_lote_produccion = p.cod_lote_produccion and" +
                            "      p.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD and      ppd.cod_tipo_programa_prod = p.cod_tipo_programa_prod and" +
                            "      tpp.cod_tipo_programa_prod = p.cod_tipo_programa_prod and      t.cod_tipo_material = ppd.cod_tipo_material and" +
                            "      fmes.cod_formula_maestra = p.cod_formula_maestra and      fmes.cod_material = ppd.cod_material and ppd.COD_MATERIAL in (" +
                                     " select fmdmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmdmp where fmdmp.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA " +
                                     " union all select fmdmr.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmdmr where fmdmr.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                                     " union all select fmdep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP fmdep where fmdep.COD_FORMULA_MAESTRA = p.cod_formula_maestra" +
                                     " union all select fmdes.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES fmdes where fmdes.COD_FORMULA_MAESTRA = p.cod_formula_maestra )":"") +
                            "  ) as tabla ";

                    System.out.println("consulta lotes : " + consulta);
                    st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs4 = st4.executeQuery(consulta);
                    double cantidadProd = 0;
                    String produccion = "";
                    while (rs4.next()) {
                        cantidadProd = cantidadProd + (rs4.getDouble("cantidad"));
                        cantidadProd = redondear(cantidadProd, 2);
                        //cantidadProd = cantidadProd - cantReservado;
                        produccion = form.format(cantidadProd);
                        System.out.println("entor cantidad:" + cantidadProd);
                    }

                    consulta = "select oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,";
                    consulta += " precio_unitario,cantidad_neta,um.NOMBRE_UNIDAD_MEDIDA";
                    consulta += " from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um";
                    consulta += " where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA = 13 AND";
                        consulta += " oc.ESTADO_SISTEMA = 1  AND oc.FECHA_ENTREGA<='" + fecha_existencia + "' AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and";
                    consulta += " cod_material='" + codMaterial + "'  order by oc.FECHA_EMISION asc";
                    System.out.println("consulta:" + consulta);
                    st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs4 = st4.executeQuery(consulta);
                    double cantidad_neta = 0;
                    String unidad_medida = "";
                    int cod_unidad_medida_pedido = 0;
                    String pedido = "";
                    while (rs4.next()) {
                        cod_unidad_medida_pedido = rs4.getInt(4);
                        cantidad_neta = rs4.getDouble(6);
                        unidad_medida = rs4.getString(7);

                        double equivalencia = compara(Integer.parseInt(cod_unidadMedida), cod_unidad_medida_pedido);
                        cantidad_neta = cantidad_neta * equivalencia;
                        cantidad_neta = redondear(cantidad_neta, 3);
                        pedido = form.format(cantidad_neta);
                        System.out.println("entor cantidad:" + cantidad_neta);
                    }
                    Date fechaInicioEntrega = new Date();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/01");
                    String fechaEntrega="";
                    consulta = "select oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,";
                    consulta += " precio_unitario,cantidad_neta-cantidad_ingreso_almacen,um.NOMBRE_UNIDAD_MEDIDA,oc.FECHA_ENTREGA";
                    consulta += " from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um";
                    consulta += " where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA IN (5,6,13) AND";
                    consulta += " oc.ESTADO_SISTEMA = 1 AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and";
                    consulta += " cod_material='" + codMaterial + "' and oc.FECHA_ENTREGA >= '"+sdf.format(fechaInicioEntrega)+"'  order by oc.FECHA_EMISION asc";
                    System.out.println("consulta***************Pedido:" + consulta);
                    st4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs4 = st4.executeQuery(consulta);
                    double cantidad_neta_transito = 0;
                    String unidad_medida_transito = "";
                    int cod_unidad_medida_compra = 0;
                    String transito = "";
                    while (rs4.next()) {
                        cod_unidad_medida_compra = rs4.getInt(4);
                        cantidad_neta_transito = rs4.getDouble(6);
                        cantidad_neta_transito = cantidad_neta_transito<0?0:cantidad_neta_transito;
                        unidad_medida_transito = rs4.getString(7);
                        fechaEntrega=rs4.getString(8);
                        System.out.println("fechaEntrega:" + fechaEntrega);
                        if(fechaEntrega!=null){
                        String fechaEntregaVector[]=fechaEntrega.split(" ");
                        fechaEntregaVector=fechaEntregaVector[0].split("-");
                        fechaEntrega=fechaEntregaVector[2]+"/"+fechaEntregaVector[1]+"/"+fechaEntregaVector[0];
                        }else{
                            fechaEntrega="";
                        }
                        double equivalencia = compara(Integer.parseInt(cod_unidadMedida), cod_unidad_medida_compra);
                        cantidad_neta_transito = cantidad_neta_transito * equivalencia;
                        cantidad_neta_transito = redondear(cantidad_neta_transito, 3);
                        transito = form.format(cantidad_neta_transito);
                        System.out.println("entor cantidad:" + cantidad_neta_transito);
                    }
                    %>

                    <tr >
                        <td   style="border : solid #f2f2f2 1px;"><%=count%><input type="hidden" value="<%=codMaterial%>" /></td>
                        <td   style="border : solid #f2f2f2 1px;"><%=nombreCapitulo%></td>
                        <td   style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_minimo%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_segu%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=stock_maximo%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=nombreUnidadMedida%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=aprob%></td>
                        <!--<td  align="right" style="border : solid #f2f2f2 1px;"><=salida></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><devolucion></td>!-->
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=cuaren%></td>
                        <td align="right" style="border : solid #f2f2f2 1px;"><%=recha%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=venc%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=obso%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"><%=form.format(reserva)%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;"  ><%=aprobados%></td> <%--disponible  --%>
                        <td  align="right" style="border : solid #f2f2f2 1px;" ><%=produccion%></td>
                        <%
                        double diferencia = total - cantidadProd-reserva;
                        diferencia = redondear(diferencia, 2);
                        String diference = form.format(diferencia);
                        if (total < cantidadProd) {
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#FC8585"><%=diference%></td>
                        <%
                        } else {
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#F5D2F3"><%=diference%></td>
                        <%
                        }
                        %>
                        <%
                        double diferenciaStockReposicion = diferencia - stockSeguridad ;
                        if (diferenciaStockReposicion<0) {
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#FC8585"><%=form.format(diferenciaStockReposicion) %></td>
                        <%
                        } else {
                        %>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#F5D2F3"><%=form.format(diferenciaStockReposicion)%></td>
                        <%
                        }
                        %>

                        <%--td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#CDF6F8"><%=pedido%></td--%>

                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#B4F5B6"><%=(cantidad_neta_transito>0?transito:"")%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#B4F5B6"><%=(cantidad_neta_transito>0?fechaEntrega:"")%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;" bgcolor="#B4F5B6"><%=proveedorUltimaCompra(codMaterial)%></td>
                        <td  align="right" style="border : solid #f2f2f2 1px;" ><%=this.materialReanalisis(codMaterial)%></td>
                        <td align="center" style="border : solid #f2f2f2 1px;">
                            <a href="../reporteExplosionProductosSimulacion/detalleDatosCompraItem.jsf?codigo=<%=codMaterial%>" target="_BLANK">Ver Detalles de Compra</a>
                        </td>
                        <%--td align="center" style="border : solid #f2f2f2 1px;">
                            <a href="../reporteExplosionProductosSimulacion/detalleDatosProductos.jsf?codigo=<%=codMaterial%>&cod_programa=<%=codProgramaProd%>" target="_BLANK">Ver Productos</a>
                        </td--%>
                        <td >

                            <table width="100%" class="outputText2" cellpadding="0" cellspacing="0">
                                <tr bgcolor="#f2f2f2">
                                    <%--td  style="border : solid #f2f2f2 1px;" title="Producto" >Cant.</td--%>
                                    <td  style="border : solid #f2f2f2 1px;" title="Producto" >Producto </td>
                                    <td  style="border : solid #f2f2f2 1px;" title="Producto" >Tipo Material</td>
                                    <td  style="border : solid #f2f2f2 1px;" title="Producto" >Tipo Programa Prod</td>
                                    <%--td align="center" style="border : solid #f2f2f2 1px;" title="Lotes">Lote</td--%>
                                    <td align="right" style="border : solid #f2f2f2 1px;" title="Cantidad">Cantidad</td>
                                </tr>
                                <%
                        try {

                            NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                            DecimalFormat form1 = (DecimalFormat) nf1;
                            form1.applyPattern("#,###.00");

                            String sqlCompra = "SELECT p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppd.CANTIDAD";
                            sqlCompra += " FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd ";
                            sqlCompra += " where p.COD_PROGRAMA_PROD='" + codProgramaProd + "' and p.COD_ESTADO_PROGRAMA=4 ";
                            sqlCompra += " and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD";
                            sqlCompra += " and ppd.COD_COMPPROD=p.COD_COMPPROD and ppd.COD_MATERIAL='" + codMaterial + "' ";
                            sqlCompra += " and ppd.cod_lote_produccion=p.cod_lote_produccion";
                            sqlCompra += " and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD " +
                                         " and ppd.cod_tipo_programa_prod = p.cod_tipo_programa_prod ";
                            
                            sqlCompra = " SELECT  cp.nombre_prod_semiterminado, sum(ppd.CANTIDAD) CANTIDAD,count(p.CANT_LOTE_PRODUCCION) cant,tpp.nombre_tipo_programa_prod,t.nombre_tipo_material,4 cod_estado_programa_prod" +
                                     " FROM PROGRAMA_PRODUCCION p, COMPONENTES_PROD cp, PROGRAMA_PRODUCCION_DETALLE ppd, TIPOS_PROGRAMA_PRODUCCION tpp,tipos_material t" +
                                     " where p.COD_PROGRAMA_PROD in( " + codProgramaProd+ " ) and p.COD_ESTADO_PROGRAMA in( 4) and cp.COD_COMPPROD = p.COD_COMPPROD " +
                                     " and cp.COD_COMPPROD = ppd.COD_COMPPROD and ppd.COD_COMPPROD = p.COD_COMPPROD " +
                                     " and ppd.COD_MATERIAL = '" + codMaterial + "'  and ppd.cod_lote_produccion = p.cod_lote_produccion " +
                                     " and p.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD " +
                                     " and ppd.cod_tipo_programa_prod = p.cod_tipo_programa_prod " +
                                     " and tpp.cod_tipo_programa_prod = p.cod_tipo_programa_prod and t.cod_tipo_material = ppd.cod_tipo_material" +
                                     (codlote.equals("")?"":" and p.COD_COMPPROD in("+codProductos+") and p.COD_LOTE_PRODUCCION+'$'+cast(p.COD_TIPO_PROGRAMA_PROD as varchar) in ("+codlote+")")+
                                     " and ppd.COD_MATERIAL in (" +
                                     " select fmdmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmdmp where fmdmp.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                                     " union all select fmdmr.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmdmr where fmdmr.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                                     " union all select fmdep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP fmdep where fmdep.COD_FORMULA_MAESTRA = p.cod_formula_maestra" +
                                     " union all select fmdes.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES fmdes where fmdes.COD_FORMULA_MAESTRA = p.cod_formula_maestra ) " +
                                     " group by cp.nombre_prod_semiterminado,tpp.nombre_tipo_programa_prod,t.nombre_tipo_material  " +
                                     //" --order by t.nombre_tipo_material,cp.nombre_prod_semiterminado asc " +
                                     (conProductosEnProceso?" union all SELECT  cp.nombre_prod_semiterminado, sum(ppd.CANTIDAD) CANTIDAD,count(p.CANT_LOTE_PRODUCCION) cant,tpp.nombre_tipo_programa_prod,t.nombre_tipo_material,7 cod_estado_programa_prod" +
                                     " FROM PROGRAMA_PRODUCCION p, COMPONENTES_PROD cp, PROGRAMA_PRODUCCION_DETALLE ppd, TIPOS_PROGRAMA_PRODUCCION tpp,tipos_material t,formula_maestra_detalle_es fmes " +
                                     " where cast(p.COD_PROGRAMA_PROD as varchar)+''+cast(p.COD_COMPPROD as varchar)+''+cast(p.COD_TIPO_PROGRAMA_PROD as varchar)+''+cast(p.COD_LOTE_PRODUCCION as varchar)  in ("+codigoProducto+") " +
                                     " and p.cod_estado_programa = 7 and cp.COD_COMPPROD = ppd.COD_COMPPROD and ppd.COD_COMPPROD = p.COD_COMPPROD " +
                                     " and ppd.COD_MATERIAL = '" + codMaterial + "'  and ppd.cod_lote_produccion = p.cod_lote_produccion " +
                                     " and p.COD_PROGRAMA_PROD = ppd.COD_PROGRAMA_PROD " +
                                     " and ppd.cod_tipo_programa_prod = p.cod_tipo_programa_prod " +
                                     " and tpp.cod_tipo_programa_prod = p.cod_tipo_programa_prod and t.cod_tipo_material = ppd.cod_tipo_material and fmes.cod_formula_maestra = p.cod_formula_maestra and fmes.cod_material = ppd.cod_material" +
                                     " and ppd.COD_MATERIAL in (" +
                                     " select fmdmp.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmdmp where fmdmp.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                                     " union all select fmdmr.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmdmr where fmdmr.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA" +
                                     " union all select fmdep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP fmdep where fmdep.COD_FORMULA_MAESTRA = p.cod_formula_maestra" +
                                     " union all select fmdes.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES fmdes where fmdes.COD_FORMULA_MAESTRA = p.cod_formula_maestra ) "+
                                     " group by cp.nombre_prod_semiterminado,tpp.nombre_tipo_programa_prod,t.nombre_tipo_material":"");
                            
                            System.out.println("sql compra: " + sqlCompra);
                            Statement stCompra = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsCompra = stCompra.executeQuery(sqlCompra);
                            double totalCantidad = 0;
                            while (rsCompra.next()) {
                                //int cantidadLotes = rsCompra.getInt("cant");
                                //double cantLote = rsCompra.getDouble(1);
                                String nombreProduto = rsCompra.getString("nombre_prod_semiterminado");
                                double cantidad = rsCompra.getFloat("CANTIDAD");
                                //cantidad = redondear(cantidad, 3);
                                //String cantidadString = form.format(cantidad);
                                totalCantidad = totalCantidad + cantidad;
                                totalCantidad = redondear(totalCantidad, 3);
                                String nombreTipoProgramaProd = rsCompra.getString("nombre_tipo_programa_prod");
                                String nombreTipoMaterial = rsCompra.getString("nombre_tipo_material");
                                String codEstadoProgramaProd = rsCompra.getString("cod_estado_programa_prod");
                                %>
                                <tr style="<%=codEstadoProgramaProd.equals("7")?"background-color:aqua":""%>" >
                                    <%--td  style="border : solid #f2f2f2 1px;" title="Producto" ><%=cantidadLotes%> </td--%>
                                    <td  style="border : solid #f2f2f2 1px;" title="Producto" ><%=nombreProduto%> </td>
                                    <td  style="border : solid #f2f2f2 1px;" title="Producto" ><%=nombreTipoMaterial%> </td>
                                    <td  style="border : solid #f2f2f2 1px;" title="Producto" ><%=nombreTipoProgramaProd%></td>
                                    <%--td align="center" style="border : solid #f2f2f2 1px;" title="Lotes"><%=cantLote%></td--%>
                                    <td align="right" style="border : solid #f2f2f2 1px;" title="Cantidad"><%=form.format( cantidad)%></td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr>
                                    <td align="right" style="border : solid #f2f2f2 1px;" colspan="3"  >TOTAL</td>
                                    <td align="right" style="border : solid #f2f2f2 1px;"><%=form.format(totalCantidad)%></td>
                                </tr>
                                <%

                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                                %>
                            </table>

                        </td>
                        <%--INSERTAMOS EN LA TABLA DE EXPLOSION DE MATERIALES--%>
                        <%
                        String sqlInserta = "insert into explosion_materiales (cod_programa_produccion, cod_material, cod_unidad_medida, cantidad_a_utilizar, cantidad_disponible, cantidad_transito) values " +
                                " (" + codProgramaProd + ", " + codMaterial + ", " + cod_unidadMedida + ", " + cantidadProd + ", " + total + ", " + cantidad_neta_transito + ")";
                        Statement stInserta = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        System.out.println("sqlInserta Explosion: " + sqlInserta);
                        stInserta.executeUpdate(sqlInserta);
                        %>
                    </tr>
                    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
                    %>
                </table>
            </div>

            <%--h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedProgramaProduccion.Cancelar}"/--%>
            <div align="center">
            <input value="Enviar Reanalisis" class="btn" type="button" onclick="if(confirm('Esta seguro de Enviar a Reanalisis?')==true){enviarReanalisisMaterial('')}" />
            </div>
        </form>



        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>
