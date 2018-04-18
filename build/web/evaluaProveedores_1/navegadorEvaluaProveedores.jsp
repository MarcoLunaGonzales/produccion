package evaluaProveedores;


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
<%! Connection con = null;
    String CadenaAreas = "";
    String areasDependientes = "";
    String sw = "0";
%>

<%
        con = Util.openConnection(con);
%>
<%!    public int numDiasMes(int mes, int anio) {
        int dias = 31;
        switch (mes) {
            case 2:
                
            case 4:
            case 6:
            case 9:
            case 11:
                dias = 30;
                break;
        }
        return dias;
    }
%>  


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function busqueda(f){
                var dependencias=document.getElementById('dependencias');
                var valor=dependencias.checked;
                //alert(f.sexo.value);
                location.href="navegadorPlanillaTributaria.jsp?cod_area_empresa="+f.cod_area_empresa.value+"&valor="+valor+"&cod_planilla_trib="+f.cod_planilla_trib.value;
            }
            /*function cargar(){
             document.getElementById('dependencias').checked=<%=request.getParameter("valor")%>;
          }*/
            function incluir_dependencias(f){
                var dependencias=document.getElementById('dependencias');
                var valor=dependencias.checked;
                //alert(f.sexo.value);
                //alert(dependencias.checked);
                //dependencias.checked=valor;
                location.href="navegadorPlanillaTributaria.jsp?cod_area_empresa="+f.cod_area_empresa.value+"&valor="+valor+"&cod_planilla_trib="+f.cod_planilla_trib.value;
                //alert(cod_area_empresa);
                //alert(valor);
            }
            function cancelar(){
                location.href="navegadorTipoIncentivoRegional.jsf";
            }

            /**
             * calcular
             */
            function calcular(f) {
                codigo=f.cod_tipo_incentivo_regional.value;
                location="rptCalculoMontoComisionCatA.jsf?cod_tipo_incentivo_regional="+codigo+"&nombre_gestion="+f.nombre_gestion.value+"&nombre_mes="+f.nombre_mes.value;
            }

            function eliminar1(f){
                var count1=0;
                var elements1=document.getElementById(f);
                var rowsElement1=elements1.rows;
                //alert(rowsElement1.length);
                for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                            if(cel1.getElementsByTagName('input')[0].checked){
                                count1++;
                            }
                        }
                    }

                }
                //alert(count1);
                if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
                }else{


                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;

                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                                //alert('No escogio ningun registro');
                                return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
            }



            function eliminar(f){
                alert(f.check.checked);
                alert(f.length);
                var codigo=new Array();
                var c=0;
                for(var i=0;i<f.length;i++){
                    if(f.elements[i].checked==true){
                        alert('entroor');
                        codigo[c]=f.check.value;
                        c++;
                    }
                }
                if(c==0){
                    alert('No escogio ningun registro');
                    return false;
                }else{
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            alert(codigo);
                            location.href="eliminarPlanillaSubsidioPersonal.jsf?codigo="+codigo+"&cod_planilla_subsidio="+f.cod_planilla_subsidio.value;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }

                }

            }
        </script>
    </head>
    <body >
        <form name="form1" action="filtroPresupuestos1.jsf" method="post" target="_blank" >

            <%!    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
            %>
            <%
        String sql = "";

            %>

            <div align="center" class="outputText2">
            <br> <br><br>
            <b><h3> Evaluacion de Proveedores </h3>
            <br><br>

                <table width="89%" align="center" class="outputText2"  cellpadding="0" cellspacing="0">
                    <tr>
                       
                        <td width="10%" align="right">APROBADOS:&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="GREEN" style="COLOR:#FFFFFF">&nbsp; > 70 %</td>
                       
                        <td width="10%" align="right">APROBADOS (RESERVA):&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="ORANGE" style="COLOR:#FFFFFF">&nbsp; 56 - 69 %</td>
                        <td width="10%" height="30px">&nbsp;</td>
                        <td width="10%" align="right">REPROBADOS:&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="RED" style="COLOR:#FFFFFF">&nbsp; < 55 %</td>
                        <td width="10%" height="30px">&nbsp;</td>
                        <td width="10%" align="right">NO EVALUADOS:&nbsp;</td>
                        <td width="10%" align="CENTER" bgcolor="#123789" style="COLOR:#FFFFFF">&nbsp; SIN PUNTUACION</td>
                       

                    </tr>
                </table>
            <br>
            <br>
            <table style="border:gray" width="89%" align="center" class="outputText2" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">

           
                    <td  align="center" style="border : solid #cccccc 1px;">Proveedor</td>
                    <td  align="center" style="border : solid #cccccc 1px;">Material</td>
                    <td  align="center" style="border : solid #cccccc 1px;">Resultado</td>
                    <td  align="center" style="border : solid #cccccc 1px;">Puntaje %</td>
                    <td  align="center" style="border : solid #cccccc 1px;">&nbsp;</td>

                </tr>
                <%


        try {

            sql = "SELECT DISTINCT O.COD_MATERIAL,M.NOMBRE_MATERIAL,P.NOMBRE_PROVEEDOR,P.COD_PROVEEDOR,  " ;
            sql += "(select isnull( cp.NOMBRE_CATEGORIA_PROVEEDOR,'') from  CATEGORIAS_PROVEEDOR cp,EVALUACION_PROVEEDORES_MATERIAL ep  WHERE cp.COD_CATEGORIA_PROVEEDOR=ep.COD_CATEGORIA_PROVEEDOR and ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL), " ;
            sql += "(select ep.PUNTUACION_TOTAL from  EVALUACION_PROVEEDORES_MATERIAL ep  WHERE ep.COD_PROVEEDOR=p.COD_PROVEEDOR and ep.COD_MATERIAL=m.COD_MATERIAL)" ;
            sql += " FROM ORDENES_COMPRA_DETALLE O,MATERIALES M,PROVEEDORES P  WHERE O.COD_ORDEN_COMPRA IN (";
            sql += " SELECT C.COD_ORDEN_COMPRA FROM ORDENES_COMPRA C WHERE C.COD_ESTADO_COMPRA IN (6,7,14,18) AND C.COD_PROVEEDOR=P.COD_PROVEEDOR";
            sql += " AND C.FECHA_EMISION>='2010/01/01' ) AND M.COD_MATERIAL=O.COD_MATERIAL AND M.COD_ESTADO_REGISTRO=1 AND M.MATERIAL_ALMACEN=1";
            sql += " AND P.COD_PROVEEDOR IN (SELECT OC.COD_PROVEEDOR FROM ORDENES_COMPRA OC WHERE OC.COD_ORDEN_COMPRA=O.COD_ORDEN_COMPRA)";
            sql += " ORDER BY P.NOMBRE_PROVEEDOR,M.NOMBRE_MATERIAL";

            System.out.println("sql" + sql);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            int cont = 0;
            String stylo="";
            while (rs.next()) {
                cont++;
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String nombreProveedor = rs.getString(3);
                String codProveedor = rs.getString(4);
                String nomCategoriaProveedor = rs.getString(5);
                double puntaje = redondear(rs.getDouble(6),2);
                if(nomCategoriaProveedor==null){
                    nomCategoriaProveedor=" NO EVALUADO ";
                    stylo="#123789";
                }
                if(nomCategoriaProveedor.equals("APROBADO")){
                    stylo="GREEN";
                }
                if(nomCategoriaProveedor.equals("APROBADO CON RESERVA")){
                    stylo="ORANGE";
                }
                if(nomCategoriaProveedor.equals("REPROBADO")){
                    stylo="RED";
                }

%>
                <tr  class="border" title=" " >
                    <td height="30px" align="left" style="border : solid #cccccc 1px;"><%=nombreProveedor%></td>
                    <td  align="left" style="border : solid #cccccc 1px;"><%=nombreMaterial%></td>
                    <td width="15%"  bgcolor="<%=stylo%>" align="center" style="border : solid #cccccc 1px;color:#ffffff"><%=nomCategoriaProveedor%></td>
                    <td  align="right" style="border : solid #cccccc 1px;"><%=redondear(puntaje,2)%>&nbsp; </td>
                    <td  align="left" style="border : solid #f3f3f3 1px;"><a href="navegadorEvaluaProveedoresDetalle.jsf?codProveedor=<%=codProveedor%>&nomProveedor=<%=nombreProveedor%>&codMaterial=<%=codMaterial%>&nomMaterial=<%=nombreMaterial%>">&nbsp;Evaluar</a></td>
                </tr>
<%
            }
%>


            </table>
            <%
        } catch (SQLException e) {
            e.printStackTrace();
        }

            %>






            <br><br>
            <div align="center">
                <input type="submit"  class="btn" value="Registrar" >
                <%--input type="button"  class="btn" value="Calcular Comisión Cat A" onclick="calcular(this.form);"--%>
                <input type="button"  class="btn" value="Cancelar" onclick="cancelar(this.form);">
            </div>
        </form>
    </body>
</html>
