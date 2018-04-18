package evaluaProveedores;

package calculoPremiosBimensuales_1;


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
<%!    public double verificar(String codigoCategoriaPremio, String codAreaEmpresa, String codCargo, String codLineaComision, String codTipoPremio) {
        int sw_premio = 0;
        double montoPremioCumplimiento = 0;
        try {
            con = Util.openConnection(con);
            String sql0 = " select t.PORCENTAJE";
            sql0 += " from LINEAS_COMISIONES_MKT lc,LINEAS_MKT l,TIPOS_PREMIO_BIMENSUAL_DETALLE t";
            sql0 += " where lc.COD_LINEACOMISION=" + codLineaComision + " and l.COD_LINEAMKT=lc.COD_LINEAMKT and t.COD_TIPO_PREMIO=" + codTipoPremio + " and t.COD_LINEA_MKT=l.COD_LINEAMKT";
            sql0 += " and t.COD_AREA_EMPRESA=" + codAreaEmpresa + " and t.COD_LINEA_MKT=lc.COD_LINEAMKT and t.TIPO_PREMIO_BIMENSUAL=1 order by l.NOMBRE_LINEAMKT";
            System.out.println("sql0:" + sql0);

            Statement st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs0 = st0.executeQuery(sql0);
            double total = 0;
            int c = 0;
            while (rs0.next()) {

                double porcentaje = rs0.getDouble(1);
                if (porcentaje < 100) {
                    sw_premio = 1;
                }
                c++;

            }

            if (sw_premio == 0 && c > 0) {
                String sqlnombre = " select c.MONTO_CUMPLIMIENTO from CARGOS_LINEAS_PREMIOS_BIMENSUAL c where c.COD_CARGO_LINEA_PREMIO=" + codigoCategoriaPremio + "";
                System.out.println("sqlnombrel:" + sqlnombre);
                Statement st_n = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_n = st_n.executeQuery(sqlnombre);
                while (rs_n.next()) {
                    montoPremioCumplimiento = rs_n.getDouble(1);
                }
                String sql_update = "update TIPOS_PREMIO_BIMENSUAL_CARGO set  MONTO_CUMPLIMIENTO=" + montoPremioCumplimiento + "";
                sql_update += " where cod_tipo_premio=" + codTipoPremio + " and cod_cargo=" + codCargo + "  and  cod_area_empresa=" + codAreaEmpresa + " ";
                sql_update += " and COD_LINEA_MKT in (select l.COD_LINEAMKT from LINEAS_COMISIONES_MKT l where l.COD_LINEACOMISION=" + codLineaComision + ")";
                System.out.println("sql_update :" + sql_update);
                Statement st_update = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int rs_update = st_update.executeUpdate(sql_update);
            }
            if (rs0 != null) {
                rs0.close();
                st0.close();
            }
        } catch (SQLException s) {
            s.printStackTrace();
        }
        return montoPremioCumplimiento;
    }
%> 
<%
        con = CofarConnection.getConnectionJsp();
%>
<%!    public int numDiasMes(int mes, int anio) {
        int dias = 31;
        switch (mes) {
            case 2:
                if (bisiesto(anio)) {
                    dias = 29;
                } else {
                    dias = 28;
                }
                break;
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

<%!    public String formatoFecha2(String fecha) {
        System.out.println("fechaaaaaaa" + fecha);
        String fechaFormatoVector[] = fecha.split("/");
        System.out.println("longitud" + fechaFormatoVector.length);
        fecha = fechaFormatoVector[1] + "/" + fechaFormatoVector[0] + "/" + fechaFormatoVector[2];
        return fecha;
    }
%>
<%!    public boolean bisiesto(int anio) {
        return ((anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0));
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
        String cod_tipo_incentivo_regional = request.getParameter("cod_tipo_inc_regional");
        String cod_gestion = request.getParameter("cod_gestion");
        String cod_mes = request.getParameter("cod_mes");
        String nombre_gestion = request.getParameter("nombre_gestion");
        String nombre_mes = request.getParameter("nombre_mes");
        System.out.println("cod_tipo_incentivo_regional:" + cod_tipo_incentivo_regional);
        System.out.println("nombre_gestion:" + nombre_gestion);
        System.out.println("cod_mes:" + cod_mes);
        System.out.println("nombre_mes:" + nombre_mes);


        String codLineaMkt = "";
        String codCategoria = "";
        String nombreCategoria = "Ninguno";
        String nombreLineaComision = "";
        String porcentaje = "";
        double monto = 0;
            %>
            <input type="hidden" name="cod_tipo_incentivo_regional" id="cod_tipo_incentivo_regional"  value="<%=cod_tipo_incentivo_regional%>" >
            <input type="hidden" name="nombre_gestion" id="nombre_gestion"  value="<%=nombre_gestion%>" >
            <input type="hidden" name="nombre_mes" id="nombre_mes"  value="<%=nombre_mes%>" >
            <div align="center" class="outputText2">
            <br> 
            <b><h3> Cálculo Premio Bimensual por  Regional  Gestión : <%=nombre_gestion%> Mes: <%=nombre_mes%></h3>
            <br><br>
                <p align="center">Cuantitativo</p>
            <br>
            <table style="border:gray" width="89%" align="center" class="outputText2" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">

                    <td  align="center" style="border : solid #cccccc 1px;">AREA EMPRESA</td>
                    <td  align="center" style="border : solid #cccccc 1px;">ANALGESICOS</td>
                    <td  align="center" style="border : solid #cccccc 1px;">ANTIBIOTICOS</td>
                    <td  align="center" style="border : solid #cccccc 1px;">CARDIO</td>
                    <td  align="center" style="border : solid #cccccc 1px;">COMMODITY</td>
                    <td  align="center" style="border : solid #cccccc 1px;">GASTRO</td>
                    <td  align="center" style="border : solid #cccccc 1px;">GENERICOS</td>
                    <td  align="center" style="border : solid #cccccc 1px;">OTECE</td>
                    <td  align="center" style="border : solid #cccccc 1px;">VIDILINE</td>
                    <td  align="center" style="border : solid #cccccc 1px;">VITAMINAS MIX</td>

                </tr>
                <%


        try {




            String codCategoriaPremioLinea = "0";
            String nomCategoriaPremioLinea = "0";
            String codLineaComision = "0";
            String sql_n = "SELECT A.COD_AREA_EMPRESA,A.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA A WHERE A.COD_AREA_EMPRESA IN (SELECT DISTINCT T.COD_AREA_EMPRESA FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_incentivo_regional + ")";
            //String sql_n = "select c.COD_CARGO_LINEA_PREMIO,c.NOMBRE_CARGO_LINEA_PREMIO,c.COD_LINEA_COMISION from CARGOS_LINEAS_PREMIOS_BIMENSUAL c where c.COD_ESTADO_REGISTRO=1 and c.COD_CARGO_LINEA_PREMIO in (select ca.COD_CARGO_LINEA from CARGOS_LINEAS_PREMIOS_BIMENSUAL_AGENCIAS ca where ca.COD_AREA_EMPRESA= "+codAreaEmpresa1+")   order by c.NOMBRE_CARGO_LINEA_PREMIO";
            System.out.println("sql-n" + sql_n);
            Statement st_n = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_n = st_n.executeQuery(sql_n);
            while (rs_n.next()) {
                String codAreaEmpresa = rs_n.getString(1);
                String nomAreaEmpresa = rs_n.getString(2);

                sql = "SELECT T.COD_LINEA_MKT,T.PORCENTAJE,T.PORCENTAJE_CALCULADO FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_incentivo_regional + "  AND T.COD_AREA_EMPRESA="+codAreaEmpresa+" ";
                sql += " AND T.TIPO_PREMIO_BIMENSUAL=1 ORDER BY T.COD_LINEA_MKT ";

%>
<tr  class="border" title=" hola" >

                    <td class="border" title=""><%=nomAreaEmpresa%></td>
<%
                System.out.println("sql" + sql);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql);
                int cont = 0;
                while (rs.next()) {
                    cont++;
                    int codLineamkt = rs.getInt(1);
                    double porcentajeObtenido = rs.getDouble(2);
                    double porcentajeCalculado = rs.getDouble(3);
                    %>

                    <td align="right" class="border" title=""><%=porcentajeObtenido%> %</td>

                <%
                                }
                %>
                </tr>
                <%

                            }

                %>
            </table>
            <br><br>
                <p align="center">Cualitativo</p>
                <br>
                                <table style="border:gray" width="89%" align="center" class="outputText2" cellpadding="0" cellspacing="0">
                <tr class="headerClassACliente">

                    <td  align="center" style="border : solid #cccccc 1px;">AREA EMPRESA</td>
                    <td  align="center" style="border : solid #cccccc 1px;">ANALGESICOS</td>
                    <td  align="center" style="border : solid #cccccc 1px;">ANTIBIOTICOS</td>
                    <td  align="center" style="border : solid #cccccc 1px;">CARDIO</td>
                    <td  align="center" style="border : solid #cccccc 1px;">COMMODITY</td>
                    <td  align="center" style="border : solid #cccccc 1px;">GASTRO</td>
                    <td  align="center" style="border : solid #cccccc 1px;">GENERICOS</td>
                    <td  align="center" style="border : solid #cccccc 1px;">OTECE</td>
                    <td  align="center" style="border : solid #cccccc 1px;">VIDILINE</td>
                    <td  align="center" style="border : solid #cccccc 1px;">VITAMINAS MIX</td>

                </tr>
                <%

            sql_n = "SELECT A.COD_AREA_EMPRESA,A.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA A WHERE A.COD_AREA_EMPRESA IN (SELECT DISTINCT T.COD_AREA_EMPRESA FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_incentivo_regional + ")";
            //String sql_n = "select c.COD_CARGO_LINEA_PREMIO,c.NOMBRE_CARGO_LINEA_PREMIO,c.COD_LINEA_COMISION from CARGOS_LINEAS_PREMIOS_BIMENSUAL c where c.COD_ESTADO_REGISTRO=1 and c.COD_CARGO_LINEA_PREMIO in (select ca.COD_CARGO_LINEA from CARGOS_LINEAS_PREMIOS_BIMENSUAL_AGENCIAS ca where ca.COD_AREA_EMPRESA= "+codAreaEmpresa1+")   order by c.NOMBRE_CARGO_LINEA_PREMIO";
            System.out.println("sql-n" + sql_n);
            st_n = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs_n = st_n.executeQuery(sql_n);
            while (rs_n.next()) {
                String codAreaEmpresa = rs_n.getString(1);
                String nomAreaEmpresa = rs_n.getString(2);

                sql = "SELECT T.COD_LINEA_MKT,T.PORCENTAJE,T.PORCENTAJE_CALCULADO FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_incentivo_regional + "  AND T.COD_AREA_EMPRESA="+codAreaEmpresa+" ";
                sql += " AND T.TIPO_PREMIO_BIMENSUAL=2 ORDER BY T.COD_LINEA_MKT ";

%>
<tr  class="border" title=" hola" >

                    <td class="border" title=""><%=nomAreaEmpresa%></td>
<%
                System.out.println("sql" + sql);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(sql);
                int cont = 0;
                while (rs.next()) {
                    cont++;
                    int codLineamkt = rs.getInt(1);
                    double porcentajeObtenido = rs.getDouble(2);
                    double porcentajeCalculado = rs.getDouble(3);
                    %>

                    <td align="right" class="border" title=""><%=porcentajeObtenido%> %</td>

                <%
                                }
                %>
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

        </form>
    </body>
</html>
