


<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.joda.time.Duration" %>
<%@ page import="org.joda.time.Interval" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.joda.time.DateTime" %>



<%@ page contentType="application/vnd.ms-excel" %>


<%! Connection con = null;
    String CadenaAreas = "";
    String areasDependientes = "";
    String sw = "0";
%>
<%
        con = CofarConnection.getConnectionJsp();
%>
<%!    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
%> 
<%!    public String generaCadenaAreasEmpresa(String codigo) {

        try {
            con = CofarConnection.getConnectionJsp();
            String sql1 = "select  cod_area_inferior from areas_dependientes_inmediatas ";
            sql1 += " where cod_area_empresa=" + codigo;
            sql1 += " order by nro_orden asc";
            System.out.println("sql1_areadependiente:" + sql1);
            Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1 = st1.executeQuery(sql1);
//CadenaAreas=CadenaAreas+"-"+codigo;

            while (rs1.next()) {
                CadenaAreas = CadenaAreas + "," + rs1.getString("cod_area_inferior");
                generaCadenaAreasEmpresa(rs1.getString("cod_area_inferior"));

//System.out.println("cod_area_inferior INFERIOR:"+rs1.getString("cod_area_inferior"));
            }
            if (rs1 != null) {
                rs1.close();
                st1.close();
            }
        } catch (SQLException s) {
            s.printStackTrace();
        }
        return CadenaAreas;
    }
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function cancel(){
                // alert('hola');
                location.href="filtro_reporte_nomina.jsp";
            }
            function datosPersona(codigo){
                //alert(codigo);
                izquierda = (screen.width) ? (screen.width-300)/2 : 100
                arriba = (screen.height) ? (screen.height-0)/2 : 100
                url='../personal/datosPersonal.jsf?codigo='+codigo;
                opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=600,height=820,left='+izquierda+ ',top=' + arriba + ''
                window.open(url, 'popUp', opciones)
            }
            function registrar(){
                var tabla=document.getElementById('table');
                var filas=tabla.getElementsByTagName('tr');
                var total=0;
                var j=0;
                var codigo=new Array();
                for(var i=1;i<filas.length;i++){
                    var columnas=filas[i].getElementsByTagName('td');
                    if(columnas[0].firstChild.checked==true){
                        codigo[j]=columnas[0].firstChild.value;
                        j++;
                        codigo[j]=columnas[6].innerHTML;
                        j++;
                    }
                    //codigo[j]=f.elements[i].value;
                    //alert(columnas[0].firstChild.checked);
                }
                if(j==0)
                {	//alert('Debe seleccionar al menos un Registro para poder Registrar.');
                }
                else
                {   //alert('entro else');
                    //alert(codigo);
                    location.href="guardar_actualizacion.jsf?codigo="+codigo;
                }
                return true;
            }
            function editar(f)
            {
                var i;
                var j=0;
                var dato;
                var codigo;
                for(i=0;i<=f.length-1;i++)
                {
                    if(f.elements[i].type=='checkbox')
                    {	if(f.elements[i].checked==true)
                        {
                            codigo=f.elements[i].value;
                            j=j+1;
                        }
                    }
                }

                if(j>1)
                {	alert('Debe seleccionar solo un registro.');
                }
                else
                {
                    if(j==0)
                    {
                        alert('Debe seleccionar un registro para editar sus datos.');
                    }
                    else
                    {
                        location.href="modificar_personal.jsf?codigo="+codigo;
                    }
                }
            }

        </script>
    </head>
    <body >
        <form>

            <div align="center">
                <%
        String codProgramaProd = request.getParameter("codProgProd");
        String codFormula = request.getParameter("codFormula");
        String nombreCompProd = request.getParameter("nombre");
        String cantidadLote = request.getParameter("cantidad");
        String codCompProd = request.getParameter("cod_comp_prod");
        String codLote = request.getParameter("cod_lote");
        String nombreGenerico = "";
        String regSanitario = "";
        String vidaUtil = "";
        String codEnvasePrim = "";
        String codForma = "";
        String nombreEnvasePrim = "";
        String nombreForma = "";

        System.out.println("entro codProgramaProd:" + codProgramaProd);



        try {
            String sql_pre = " select c.NOMBRE_GENERICO,c.REG_SANITARIO,c.VIDA_UTIL,c.cod_forma,c.cod_envaseprim";
            sql_pre += "  from COMPONENTES_PROD c  where c.cod_compprod='" + codCompProd + "' order by c.nombre_prod_semiterminado";
            System.out.println("sql COMPONENTES_PROD:" + sql_pre);
            Statement st_pre = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_pre = st_pre.executeQuery(sql_pre);
            while (rs_pre.next()) {
                nombreGenerico = rs_pre.getString(1);
                regSanitario = rs_pre.getString(2);
                vidaUtil = rs_pre.getString(3);
                codForma = rs_pre.getString(4);
                codEnvasePrim = rs_pre.getString(5);

            }
            sql_pre = "  select  f.nombre_forma from FORMAS_FARMACEUTICAS f where f.cod_forma=1 ";

            System.out.println("sql FORMAS_FARMACEUTICAS:" + sql_pre);
            st_pre = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs_pre = st_pre.executeQuery(sql_pre);
            while (rs_pre.next()) {
                nombreForma = rs_pre.getString(1);
            }
            sql_pre = " select e.nombre_envaseprim from ENVASES_PRIMARIOS e where e.cod_envaseprim=17";
            System.out.println("sql ENVASES_PRIMARIOS:" + sql_pre);
            st_pre = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs_pre = st_pre.executeQuery(sql_pre);
            while (rs_pre.next()) {
                nombreEnvasePrim = rs_pre.getString(1);
            }
        } catch (Exception e) {
        }

        System.out.println("codFormula:" + codFormula);
        System.out.println("nombreCompProd:" + nombreCompProd);
        System.out.println("cantidadLote:" + cantidadLote);

                %>

            </div>
            <table width="78%" height="234" border="0" class="outputText2" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="border : solid #f2f2f2 1px;" width="17%" height="108"><p align="center">LABORATORIOS</p>
                    <p align="center">COFAR S.A</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;">
                        <br><br>
                        <p align="center">ORDEN DE MANUFACTURA</p> <br>
                        <p align="center">FORMULA CUALI-CUANTITATIVA</p>
                    </td>
                    <td width="21%"><table width="100%" border="0"  class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">Nro de Página</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Lote</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Expiracion</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Fecha de Elaboración</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Fecha de Emisión</td>
                            </tr>
                    </table></td>
                    <td width="18%"><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=codLote%></td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Nombre Comercial</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreCompProd%></td>
                    <td style="border : solid #f2f2f2 1px;">Presentación</td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreEnvasePrim%></td>
                </tr>
                <tr>
                    <td height="71" style="border : solid #f2f2f2 1px;"><p>Nombre Genérico/</p>
                    <p>Concentración</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreGenerico%></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;">Nro de Registro Sanitario</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Vida Util del Producto</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Tamaño de Lote Industrial</td>
                            </tr>
                    </table></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;"><%=regSanitario%></td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;"><%=vidaUtil%></td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=cantidadLote%></td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Forma Farmacéutica</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreForma%></td>
                    <td style="border : solid #f2f2f2 1px;">Ordén de Producción</td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                </tr>
            </table>
            <br>
            <table  align="center" width="78%" class="outputText2" id="table" cellspacing="0" style="border : solid #f2f2f2 1px;" >
                <tr>
                    <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5" align="center">FÓRMULA CUALI-CUANTITATIVA</th>

                </tr>
            </table>
            <br>
            <br>
            <table  align="center" class="outputText2" width="799" class="outputText2" id="table" cellspacing="0" style="border : solid #f2f2f2 1px;" >
                <tr>
                    <th style="border : solid #f2f2f2 1px;" align="center">CÓDIGO</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">MATERIA PRIMA</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">TIPO DE MATERIA PRIMA</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO UNIT.</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO LOTE IND.</th>
                </tr>
                <%
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat) nf;
        form.applyPattern("#,###.000");
        cantidadLote = cantidadLote.replace(",", "");
        double cantLote = Double.parseDouble(cantidadLote);
        double cantMateria = 0;
        try {

            String sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo";
            sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
            sql += " where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
            sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormula + "' and ppd.cod_lote_produccion='" + codLote + "' ";
            sql += " and pp.cod_programa_prod='" + codProgramaProd + "' and ppd.COD_COMPPROD=" + codCompProd + " ";
            sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
            sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep where ep.COD_FORMULA_MAESTRA='" + codFormula + "') ";
            sql += " order by m.NOMBRE_MATERIAL";
            System.out.println("sql MP:" + sql);
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                String codMaterial = rs.getString(1);
                String nombreMaterial = rs.getString(2);
                String unidadMedida = rs.getString(3);
                double cantidad = rs.getDouble(4);
                cantMateria = cantidad / cantLote;
                String codUnidadMedida = rs.getString(5);
                String codGrupo = rs.getString(6);
                System.out.println("nombreMaterial:" + nombreMaterial);
                %>
                <tr>
                    <td align="left" style="border : solid #f2f2f2 1px;"><%=codMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantMateria)%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
                </tr>
                <%

                    }
                %>
                <tr>
                    <th colspan="5" style="border : solid #f2f2f2 1px;" align="center">&nbsp;</th>
                </tr>
                <tr>
                    <th style="border : solid #f2f2f2 1px;" align="center">CÓDIGO</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">EMPAQUE PRIMARIO</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">TIPO DE MATERIA PRIMA</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO UNIT.</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO LOTE IND.</th>
                </tr>
                <%

                    sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA";
                    sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                    sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                    sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormula + "' ";
                    sql += " and pp.cod_programa_prod='" + codProgramaProd + "' and ppd.COD_COMPPROD=" + codCompProd + " and ppd.cod_lote_produccion='" + codLote + "'";
                    sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                    sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP ep where ep.COD_FORMULA_MAESTRA='" + codFormula + "') ";
                    sql += " order by m.NOMBRE_MATERIAL";
                    System.out.println("sql EP:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs = st.executeQuery(sql);
                    while (rs.next()) {
                        String codMaterial = rs.getString(1);
                        String nombreMaterial = rs.getString(2);
                        String unidadMedida = rs.getString(3);
                        double cantidad = rs.getDouble(4);
                        cantMateria = cantidad / cantLote;
                        String codUnidadMedida = rs.getString(5);
                %>
                <tr>
                    <td align="left" style="border : solid #f2f2f2 1px;"><%=codMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantMateria)%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
                </tr>
                <%
                    }

                %>
                <tr>
                    <th colspan="5" style="border : solid #f2f2f2 1px;" align="center">&nbsp;</th>
                </tr>
                <tr>
                    <th style="border : solid #f2f2f2 1px;" align="center">CÓDIGO</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">EMPAQUE SECUNDARIO</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">TIPO DE MATERIA PRIMA</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO UNIT.</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO LOTE IND.</th>
                </tr>
                <%
                    sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA";
                    sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                    sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                    sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormula + "' ";
                    sql += " and pp.cod_programa_prod='" + codProgramaProd + "' and ppd.COD_COMPPROD=" + codCompProd + " and ppd.cod_lote_produccion='" + codLote + "'";
                    sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                    sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA='" + codFormula + "') ";
                    sql += " order by m.NOMBRE_MATERIAL";
                    System.out.println("sql ES:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs = st.executeQuery(sql);
                    while (rs.next()) {
                        String codMaterial = rs.getString(1);
                        String nombreMaterial = rs.getString(2);
                        String unidadMedida = rs.getString(3);
                        double cantidad = rs.getDouble(4);
                        cantMateria = cantidad / cantLote;
                        String codUnidadMedida = rs.getString(5);
                %>
                <tr>
                    <td style="border : solid #f2f2f2 1px;"><%=codMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantMateria)%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
                </tr>
                <%
                    }
                %>
                <%--tr>
                    <th style="border : solid #f2f2f2 1px;" align="center">CÓDIGO</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">MATERIAL PROMOCIONAL</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">TIPO DE MATERIA PRIMA</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO UNIT.</th>
                    <th style="border : solid #f2f2f2 1px;" align="center">PESO LOTE IND.</th>
                </tr--%>
                <%
                    sql = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA";
                    sql += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                    sql += " where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                    sql += " and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '" + codFormula + "' ";
                    sql += " and pp.cod_programa_prod='" + codProgramaProd + "' and ppd.COD_COMPPROD=" + codCompProd + " and ppd.cod_lote_produccion='" + codLote + "'";
                    sql += " and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                    sql += " and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MPROM ep where ep.COD_FORMULA_MAESTRA='" + codFormula + "') ";
                    sql += " order by m.NOMBRE_MATERIAL";
                    System.out.println("sql MPROM:" + sql);
                    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs = st.executeQuery(sql);
                    while (rs.next()) {
                        String codMaterial = rs.getString(1);
                        String nombreMaterial = rs.getString(2);
                        String unidadMedida = rs.getString(3);
                        double cantidad = rs.getDouble(4);
                        cantMateria = cantidad / cantLote;
                        String codUnidadMedida = rs.getString(5);
                %>
                <%--tr>
                    <td style="border : solid #f2f2f2 1px;"><%=codMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreMaterial%></td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
       <td style="border : solid #f2f2f2 1px;"><%=form.format(cantidad)%></td>
                    <td style="border : solid #f2f2f2 1px;"><%=form.format(cantMateria)%></td>
                </tr--%>
                <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
                %>
            </table>
            <br>
            <BR>
            <table width="78%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="5"><p>OBSERVACIONES</p>
                        <p>..............................................................................................................................................................................................................</p>
                    </td>
                </tr>
            </table>
            <br>
            <br>
            <table width="78%" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                <tr style="border : solid #f2f2f2 1px;">
                    <td height="28" colspan="2"><div align="center">RESPONSABLE DE AREA</div></td>
                    <td width="57%" colspan="3"><div align="center">DIRECCION TÉCNICA</div></td>

                </tr>
                <tr style="border : solid #f2f2f2 1px;">
                    <td height="28" colspan="2">NOMBRE :</td>
                    <td colspan="3">NOMBRE :</td>

                </tr>
                <tr style="border : solid #f2f2f2 1px;">
                    <td height="28" colspan="2">FIRMA :</td>
                    <td colspan="3">FIRMA :</td>

                </tr>
                <tr style="border : solid #f2f2f2 1px;">
                    <td height="30" colspan="2">FECHA :</td>
                    <td colspan="3">FECHA :</td>

                </tr>
            </table>

            <br><br><br><br><br>
            <%--  *******************************PESAJE************************--%>
            <DIV>
                <table width="78%" height="234" border="0" class="outputText2" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="border : solid #f2f2f2 1px;" width="17%" height="108"><p align="center">LABORATORIOS</p>
                        <p align="center">COFAR S.A</p></td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">
                            <br><br>
                            <p align="center">ORDEN DE MANUFACTURA</p> <br>
                            <p align="center">FORMULA CUALI-CUANTITATIVA</p>
                        </td>
                        <td width="21%"><table width="100%" border="0"  class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                                <tr>
                                    <td height="22" style="border : solid #f2f2f2 1px;">Nro de Página</td>
                                </tr>
                                <tr>
                                    <td height="23" style="border : solid #f2f2f2 1px;">Lote</td>
                                </tr>
                                <tr>
                                    <td height="21" style="border : solid #f2f2f2 1px;">Expiracion</td>
                                </tr>
                                <tr>
                                    <td height="21" style="border : solid #f2f2f2 1px;">Fecha de Elaboración</td>
                                </tr>
                                <tr>
                                    <td height="24" style="border : solid #f2f2f2 1px;">Fecha de Emisión</td>
                                </tr>
                        </table></td>
                        <td width="18%"><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                                <tr>
                                    <td height="22" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td height="23" style="border : solid #f2f2f2 1px;"><%=codLote%></td>
                                </tr>
                                <tr>
                                    <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td height="24" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                                </tr>
                        </table></td>
                    </tr>
                    <tr>
                        <td height="25" style="border : solid #f2f2f2 1px;">Nombre Comercial</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreCompProd%></td>
                        <td style="border : solid #f2f2f2 1px;">Presentación</td>
                        <td style="border : solid #f2f2f2 1px;"><%=nombreEnvasePrim%></td>
                    </tr>
                    <tr>
                        <td height="71" style="border : solid #f2f2f2 1px;"><p>Nombre Genérico/</p>
                        <p>Concentración</p></td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreGenerico%></td>
                        <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                                <tr>
                                    <td height="26" style="border : solid #f2f2f2 1px;">Nro de Registro Sanitario</td>
                                </tr>
                                <tr>
                                    <td height="24" style="border : solid #f2f2f2 1px;">Vida Util del Producto</td>
                                </tr>
                                <tr>
                                    <td height="23" style="border : solid #f2f2f2 1px;">Tamaño de Lote Industrial</td>
                                </tr>
                        </table></td>
                        <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                                <tr>
                                    <td height="26" style="border : solid #f2f2f2 1px;"><%=regSanitario%></td>
                                </tr>
                                <tr>
                                    <td height="24" style="border : solid #f2f2f2 1px;"><%=vidaUtil%></td>
                                </tr>
                                <tr>
                                    <td height="23" style="border : solid #f2f2f2 1px;"><%=cantidadLote%></td>
                                </tr>
                        </table></td>
                    </tr>
                    <tr>
                        <td height="25" style="border : solid #f2f2f2 1px;">Forma Farmacéutica</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreForma%></td>
                        <td style="border : solid #f2f2f2 1px;">Ordén de Producción</td>
                        <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                </table>
                <br><br>
                <table cellspacing="0" cellpadding="0" style="border : solid #f2f2f2 1px;" class="outputText2" >

                    <tr height="20">
                        <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5" align="center">VERIFICACION LIMPIEZA - DESPEJE DE LINEA </th>
                    </tr>
                    <tr height="17">
                        <td height="17" colspan="5">Condiciones    generales </td>
                    </tr>
                    <tr height="8">
                        <td height="8">&nbsp;</td>
                    </tr>
                    <tr height="17">
                        <td height="17" colspan="5">1. Adjunte a la orden de manufactura las etiquetas de  limpieza .</td>
                    </tr>
                    <tr height="17">
                        <td height="17" colspan="5">2. Antes de iniciar cualquier proceso  verifique la limpieza de los equipos y    ambientes  a emplear.</td>
                    </tr>
                </table>
                <br><br>
                <table cellspacing="0" cellpadding="0" style="border : solid #f2f2f2 1px;" class="outputText2" >

                    <tr height="17">
                        <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5">VERIFICACION LIMPIEZA -DESPEJE DE LINEA DE    AMBIENTES</th>
                    </tr>
                    <tr height="17">
                        <th  height="17" width="192">LISTA DE VERIFICACION </th>
                        <th width="120" style="border : solid #f2f2f2 1px;">PESAJE 1</th>
                        <th width="133" style="border : solid #f2f2f2 1px;">PESAJE 2</th>
                        <th colspan="2" width="162" style="border : solid #f2f2f2 1px;">ESCLUSA </th>

                    </tr>
                    <tr height="29">
                        <td  height="29" width="192" style="border : solid #f2f2f2 1px;">1. Se realizó el despeje de linea?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="29" >
                        <td  height="29" width="192" style="border : solid #f2f2f2 1px;">2. Se encuentran las areas organizadas ?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="29">
                        <td  height="29" width="192" style="border : solid #f2f2f2 1px;">3. Se encuentran las areas limpias  ?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>

                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="29">
                        <td height="29" width="192" style="border : solid #f2f2f2 1px;">4. Existen trazas de betalactámicos ?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>

                    </tr>
                    <tr height="29">
                        <td  height="29" width="192" style="border : solid #f2f2f2 1px;">5. Existen trazas de otros productos  segregados ?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2"style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="29">
                        <td  height="29" width="192" style="border : solid #f2f2f2 1px;">6. Se ha registrado la limpieza de los ambientes?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="29">
                        <td height="29" width="192" style="border : solid #f2f2f2 1px;">7. Se encuentran identificadas las pizarras?</td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="37">
                        <td height="37" width="192" style="border : solid #f2f2f2 1px;">NOMBRE RESP. VERIFICACION </td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                    <tr height="28">
                        <td height="28" width="192" style="border : solid #f2f2f2 1px;">FECHA DE VERIFICACION </td>
                        <td width="120" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td width="133" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                        <td colspan="2" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                    </tr>
                </table>
                <br><br>
                <table cellspacing="0" cellpadding="0" style="border : solid #f2f2f2 1px;" class="outputText2">
                    <tr height="20">
                        <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5" align="center">VERIFICACIÓN DE LIMPIEZA DE EQUIPOS</th>
                    </tr>
                    <tr height="54">
                        <th class="border" height="54" width="265">LISTA    DE VERIFICACIÓN </th>
                        <th class="border" width="160">BALANZA <br />
                        OHAUS EP6100</th>
                        <th class="border" width="160">BALANZA <br />
                        KERN STB (SIB50K548)</th>
                        <th class="border" width="91">BALANZA <br />
                        AND HF 3200</th>
                        <th class="border" width="116">BALANZA<br /></th>
                    </tr>
                    <tr height="20">
                        <td class="border" height="20">1. El equipo está    limpio?</td>
                        <td class="border">&nbsp;</td>
                        <td class="border">&nbsp;</td>
                        <td class="border">&nbsp;</td>
                        <td class="border">&nbsp;</td>
                    </tr>
                    <tr height="21">
                        <td class="border" height="21">2. Existen restos    de producto anterior?</td>
                        <td class="border" >&nbsp;</td>
                        <td class="border">&nbsp;</td>
                        <td class="border">&nbsp;</td>
                        <td class="border">&nbsp;</td>
                    </tr>
                </table>
                <br><br>
                <table cellspacing="0" cellpadding="0" style="border : solid #f2f2f2 1px;" class="outputText2">
                    <tr height="20">
                        <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5" align="center">VERIFICACIÓN DE LIMPIEZA DE UTENSILIOS</th>
                    </tr>
                    <tr height="54">
                        <th class="border" >LISTA    DE VERIFICACIÓN </th>
                        <th colspan="2" class="border"  align="center">SI </th>
                        <th colspan="2" class="border"align="center">NO</th>
                    </tr>
                    <tr height="20">
                        <td class="border" height="20">1. Los utensilios a emplearse en el proceso están limpios?</td>
                        <td colspan="2" class="border">&nbsp;</td>
                        <td colspan="2" class="border">&nbsp;</td>
                    </tr>
                    <tr height="21">
                        <td class="border" height="21">2. Existen restos de producto anterior?</td>
                        <td colspan="2" class="border">&nbsp;</td>
                        <td colspan="2" class="border">&nbsp;</td>
                    </tr>
                </table>
                <br>
                <BR>
                <table width="78%" border="0" cellpadding="0" cellspacing="0" class="outputText2" >
                    <tr>
                        <td colspan="5" class="outputText2"><p>OBSERVACIONES</p>
                            <p>..............................................................................................................................................................................................................</p><br>
                            <p>..............................................................................................................................................................................................................</p>
                        </td>
                    </tr>
                    <tr height="20">
                        <th style="border : solid #f2f2f2 1px;" class="outputText2" bgcolor="#F2F2F2" colspan="5" align="center"><br>PESADA DE MATERIA PRIMA</th>
                    </tr>
                </table>

                <br />  <br />
                <p class="outputText2"><b>Precauciones</b></p>
                <p class="outputText2">1. Verifique que las materias primas que se van a pesar, hayan sido aprobadas por el departamento de Control de Calidad y que estén en vigencia.<br />
                2. Pese las materias primas descritas en la fórmula Cuali-Cuantitativa de acuerdo al procedimiento de pesaje.</p>
                <p class="outputText2"><b>Condiciones generales</b></p>
                <p class="outputText2">1. Terminado el pesaje de la materia prima informe al personal responsable del respesado.<br />
                2. Aprobado el respesado de las materias primas realice la entrega de las mismas a las respectivas áreas de producción.</p>
            </DIV>
            <br><br><br>
            <%--  ******************************* DOCUMENTACIÓN ************************--%>

            <table width="78%" height="234" border="1" class="outputText2" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="border : solid #f2f2f2 1px;" width="17%" height="108"><p align="center">LABORATORIOS</p>
                    <p align="center">COFAR S.A</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;">
                        <br><br>
                        <p align="center">FORMULA MAESTRA</p> <br>
                        <p align="center">PROCEDIMIENTOS E INSTRUCTIVOS</p>
                    </td>
                    <td width="21%"><table width="100%" border="0"  class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">Nro de Página</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Lote</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Expiracion</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Fecha de Elaboración</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Fecha de Emisión</td>
                            </tr>
                    </table></td>
                    <td width="18%"><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=codLote%></td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Nombre Comercial</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreCompProd%></td>
                    <td style="border : solid #f2f2f2 1px;">Presentación</td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreEnvasePrim%></td>
                </tr>
                <tr>
                    <td height="71" style="border : solid #f2f2f2 1px;"><p>Nombre Genérico/</p>
                    <p>Concentración</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreGenerico%></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;">Nro de Registro Sanitario</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Vida Util del Producto</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Tamaño de Lote Industrial</td>
                            </tr>
                    </table></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;"><%=regSanitario%></td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;"><%=vidaUtil%></td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=cantidadLote%></td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Forma Farmacéutica</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreForma%></td>
                    <td style="border : solid #f2f2f2 1px;">Ordén de Producción</td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                </tr>
            </table>
            <br>
            <br><br><br>
            <%--  ******************************* LIMPIEZA ************************--%>

            <table width="78%" height="234" border="1" class="outputText2" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="border : solid #f2f2f2 1px;" width="17%" height="108"><p align="center">LABORATORIOS</p>
                    <p align="center">COFAR S.A</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;">
                        <br><br>
                        <p align="center">FORMULA MAESTRA</p> <br>
                        <p align="center">DESPEJE DE LÍNEA, LIMPIEZA DE AMBIENTES, EQUIPOS Y UTENSILIOS</p>
                    </td>
                    <td width="21%"><table width="100%" border="0"  class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">Nro de Página</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Lote</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Expiracion</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Fecha de Elaboración</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Fecha de Emisión</td>
                            </tr>
                    </table></td>
                    <td width="18%"><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=codLote%></td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Nombre Comercial</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreCompProd%></td>
                    <td style="border : solid #f2f2f2 1px;">Presentación</td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreEnvasePrim%></td>
                </tr>
                <tr>
                    <td height="71" style="border : solid #f2f2f2 1px;"><p>Nombre Genérico/</p>
                    <p>Concentración</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreGenerico%></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;">Nro de Registro Sanitario</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Vida Util del Producto</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Tamaño de Lote Industrial</td>
                            </tr>
                    </table></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;"><%=regSanitario%></td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;"><%=vidaUtil%></td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=cantidadLote%></td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Forma Farmacéutica</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreForma%></td>
                    <td style="border : solid #f2f2f2 1px;">Ordén de Producción</td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                </tr>
            </table>
            <br> <br> <br> <br> <br>
            <%--  ******************************* VERIFICACION LIMPIEZA ************************--%>

            <table width="78%" height="234" border="1" class="outputText2" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="border : solid #f2f2f2 1px;" width="17%" height="108"><p align="center"><b>LABORATORIOS</b></p>
                    <p align="center"><b>COFAR S.A</b></p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;">
                        <br><br>
                        <p align="center"><b>FORMULA MAESTRA</b></p> <br>
                        <p align="center"><b>VERIFICACIÓN DE LIMPIEZA  DE AMBIENTES,  EQUIPOS y UTENSILIOS</b></p>
                    </td>
                    <td width="21%"><table width="100%" border="0"  class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">Nro de Página</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Lote</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Expiracion</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Fecha de Elaboración</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Fecha de Emisión</td>
                            </tr>
                    </table></td>
                    <td width="18%"><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=codLote%></td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Nombre Comercial</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreCompProd%></td>
                    <td style="border : solid #f2f2f2 1px;">Presentación</td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreEnvasePrim%></td>
                </tr>
                <tr>
                    <td height="71" style="border : solid #f2f2f2 1px;"><p>Nombre Genérico/</p>
                    <p>Concentración</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreGenerico%></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;">Nro de Registro Sanitario</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Vida Util del Producto</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Tamaño de Lote Industrial</td>
                            </tr>
                    </table></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;"><%=regSanitario%></td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;"><%=vidaUtil%></td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=cantidadLote%></td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Forma Farmacéutica</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreForma%></td>
                    <td style="border : solid #f2f2f2 1px;">Ordén de Producción</td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                </tr>
            </table>
            <br>
            <table cellspacing="0" cellpadding="0" class="outputText2">

                <tr height="20">
                    <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5" align="center">VERIFICACIÓN DE LIMPIEZA     DE AMBIENTES,  EQUIPOS y    UTENSILIOS</th>
                </tr>
                <tr height="10">
                    <td height="10" colspan="5">&nbsp;</td>
                </tr>
                <tr height="74">
                    <td height="74" width="803" colspan="5">Condiciones generales<br />
                        1. Antes de iniciar cualquier proceso verifique la    limpieza de los ambientes, equipos y utensilios a emplear.<br />
                    2. El Técnico de Producción es responsable de verificar la limpieza de    ambientes, equipos y utensilios. Debe registrarse en la tabla adjunta    indicando con la palabra &quot;SI&quot; o &quot;NO&quot;.</td>
                </tr>
            </table>
            <p>&nbsp;</p>
            <table cellspacing="0" cellpadding="0" class="outputText2" style="border : solid #f2f2f2 1px;" >

                <tr>
                    <td  height="37" >Producto anterior: …………………………… </td>
                    <td>Lote:……………………………  </td>
                    <td>Próximo producto: ………………………… </td>
                    <td colspan="2">Lote: …………………………… </td>
                </tr>
            </table>
            <br><br>
            <table cellspacing="0" cellpadding="0" class="outputText2" style="border : solid #f2f2f2 1px;">
                <tr height="20">
                    <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="8" align="center">VERIFICACIÓN DE LIMPIEZA DE AMBIENTES </th>
                </tr>
                <tr height="48">
                    <td class="border" height="48" width="182">LISTA    DE VERIFICACIÓN </td>
                    <td class="border" width="81">LAVADO DE FRASCOS</td>
                    <td class="border" width="80">PREPARADO</td>
                    <td class="border" width="88">DOSIFICADO </td>
                    <td class="border" width="105">EMPAQUE </td>
                    <td class="border" width="98">ALMACEN DE    PRODUCTO <br />
                    SEMITERMINADO </td>
                    <td class="border" width="74">PASILLO </td>
                    <td class="border" width="95">ESCLUSA</td>
                </tr>
                <tr height="35">
                    <td class="border" height="35" width="182">1. Existe material ajeno al proceso?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
                <tr height="34">
                    <td class="border" height="34" width="182">2. Se encuentran las áreas organizadas?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
                <tr height="35">
                    <td class="border" height="35" width="182">3. Se encuentran las áreas limpias?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
                <tr height="33">
                    <td class="border" height="33" width="182">4. Existen restos de producto anterior?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
                <tr height="41">
                    <td class="border"height="41" width="182">5. Se encuentran las áreas identificadas?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
            </table>
            <br><br>
            <table cellspacing="0" cellpadding="0" class="outputText2">
                <tr height="20">
                    <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="8" align="center">VERIFICACIÓN DE LIMPIEZA DE EQUIPOS </th>
                </tr>
                <tr height="48">
                    <th class="border" height="48" width="182">LISTA    DE VERIFICACIÓN </th>
                    <th class="border" width="81">TANQUES DE    PREPARACIÓN </th>
                    <th class="border" width="80">MOLINO COLOIDAL <br />
                    TAN MILLS</th>
                    <th class="border" width="88">AGITADOR<br />
                    STANDARD-MIX</th>
                    <th class="border" width="105">BANDA    TRASNPORTADORA  US ELECTRICA MOTOR </th>
                    <th class="border" width="98">DOSIFICADORA    SEMIAUTOMÁTICA VOLUMÉTRICA DUBASA DP-2</th>
                    <th class="border" width="74">TAPADORA DUBASA</th>
                    <th class="border" width="95">SACHETEADORA    UHLLMAN</th>
                </tr>
                <tr height="34">
                    <td class="border" height="34" width="182">1.    ¿El equipo esta limpio y sanitizado?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
                <tr height="33">
                    <td class="border" height="33" width="182">2.Existen restos de producto anterior?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
                <tr height="33">
                    <td class="border" height="33" width="182">3. Se encuentran identificadas las pizarras?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
            </table>
            <br><br>
            <table cellspacing="0" cellpadding="0" class="outputText2" >
                <tr height="20">
                    <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="8" align="center">VERIFICACIÓN DE LIMPIEZA DE UTENSILIOS </th>
                </tr>
                <tr height="24">
                    <th class="border"  height="24" width="182">LISTA    DE VERIFICACIÓN </th>
                    <th class="border" width="81">VARILLAS </th>
                    <th class="border" width="80">JARRAS y    EMBUDOS </th>
                    <th class="border" width="88">RECIPIENTES    DE  INOX </th>
                    <th class="border" width="105">MATERIAL DE    VIDRIO </th>
                    <th class="border" width="98">BOTELLONES DE    VIDRIO</th>
                    <th class="border" width="74">MANGUERAS    DOSIFICACIÓN </th>
                    <th class="border" width="95">HERRAMIENTAS</th>
                </tr>
                <tr height="37">
                    <td class="border" height="37" width="182">1. Los utensilios a emplear en el proceso están limpios?</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                    <td class="border">&nbsp;</td>
                </tr>
            </table>
            <br />  <br />
            <p class="outputText2">NOMBRE RESP. VERIFICACIÓN</p>
            <p class="outputText2">FECHA DE VERIFICACIÓN</p>
            <BR>
            <table width="78%" border="0" cellpadding="0" cellspacing="0" class="outputText2">
                <tr>
                    <td colspan="5"><p class="outputText2">OBSERVACIONES</p>
                        <p>..............................................................................................................................................................................................................</p>
                    </td>
                </tr>
            </table>

            <%--  ******************************* LAVADO ************************--%>
            <BR>   <BR>   <BR>   <BR>   <BR>
            <table width="78%" height="234" border="0" class="outputText2" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="border : solid #f2f2f2 1px;" width="17%" height="108"><p align="center">LABORATORIOS</p>
                    <p align="center">COFAR S.A</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;">
                        <br><br>
                        <p align="center">ORDEN DE MANUFACTURA</p> <br>
                        <p align="center">FORMULA CUALI-CUANTITATIVA</p>
                    </td>
                    <td width="21%"><table width="100%" border="0"  class="outputText2" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">Nro de Página</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Lote</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Expiracion</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">Fecha de Elaboración</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Fecha de Emisión</td>
                            </tr>
                    </table></td>
                    <td width="18%"><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="22" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=codLote%></td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="21" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">&nbsp;</td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Nombre Comercial</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreCompProd%></td>
                    <td style="border : solid #f2f2f2 1px;">Presentación</td>
                    <td style="border : solid #f2f2f2 1px;"><%=nombreEnvasePrim%></td>
                </tr>
                <tr>
                    <td height="71" style="border : solid #f2f2f2 1px;"><p>Nombre Genérico/</p>
                    <p>Concentración</p></td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreGenerico%></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;">Nro de Registro Sanitario</td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;">Vida Util del Producto</td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;">Tamaño de Lote Industrial</td>
                            </tr>
                    </table></td>
                    <td><table width="100%" class="outputText2" border="0" cellpadding="0" cellspacing="0" style="border : solid #f2f2f2 1px;">
                            <tr>
                                <td height="26" style="border : solid #f2f2f2 1px;"><%=regSanitario%></td>
                            </tr>
                            <tr>
                                <td height="24" style="border : solid #f2f2f2 1px;"><%=vidaUtil%></td>
                            </tr>
                            <tr>
                                <td height="23" style="border : solid #f2f2f2 1px;"><%=cantidadLote%></td>
                            </tr>
                    </table></td>
                </tr>
                <tr>
                    <td height="25" style="border : solid #f2f2f2 1px;">Forma Farmacéutica</td>
                    <td colspan="2" style="border : solid #f2f2f2 1px;"><%=nombreForma%></td>
                    <td style="border : solid #f2f2f2 1px;">Ordén de Producción</td>
                    <td style="border : solid #f2f2f2 1px;">&nbsp;</td>
                </tr>
                <tr height="20">
                    <th style="border : solid #f2f2f2 1px;" bgcolor="#F2F2F2" colspan="5" align="center">ETAPA DE LAVADO</th>
                </tr>
            </table>
            <br><br>
            <br />  <br />
            <p class="outputText2">1.Realice la recepción del material primario, comparando  la cantidad del material entregado con la orden de manufactura.</p>
            <p class="outputText2"></p>
            <p class="outputText2">Nombre del  encargado de recepción:  ………………………………………………………………………………. </p>
            <p class="outputText2">2.Realice el proceso de lavado de frascos conforme al procedimiento LNE-IN-008 "Lavado de frascos"</p>
            <p class="outputText2">3. A continuación se deben registrar los obreros que realizaron el lavado de los frascos:</p>
            <p class="outputText2">1. .......................</p>
            <p class="outputText2">2. ......................</p>
            <p class="outputText2">3. ......................</p>
            <p class="outputText2">4. ......................</p>
            <p class="outputText2">5. ......................</p>
            <p class="outputText2">6. ......................</p>
            <p class="outputText2">7. ......................</p>
            <br><br>
            <table width="78%" border="0" class="outputText2" cellpadding="0" cellspacing="0">
                <tr height="20">
                    <th class="border" bgcolor="#F2F2F2" colspan="5" align="center">RENDIMIENTO</th>
                </tr>
                <tr>
                    <td class="border" >Cantidad de  frascos recibidos </td>
                    <td class="border" colspan="4"><img src="../img/vector.jpg"></td>
                </tr>
                <tr>
                    <td class="border" >Cantidad de  frascos lavados </td>
                    <td class="border" colspan="4"><img src="../img/vector.jpg"></td>
                </tr>
                <tr>
                    <td class="border" >Cantidad total lavada</td>
                    <td class="border" colspan="4"><img src="../img/vector.jpg"></td>
                </tr>
                <tr>
                    <td class="border" >% RENDIMIENTO</td>
                    <td class="border" colspan="4">&nbsp;</td>
                </tr>

            </table>
            <br />  <br />
            <table width="78%" border="0" cellpadding="0" cellspacing="0" class="outputText2">
                <tr>
                    <td colspan="5"><p class="outputText2">OBSERVACIONES</p>
                        <p>..............................................................................................................................................................................................................</p>
                    </td>
                </tr>
            </table>
            <br />  <br />
            <table width="78%"  border="0" class="outputText2" cellpadding="0" cellspacing="0">
                <tr height="20">
                    <th class="border" bgcolor="#F2F2F2" colspan="5" align="center">RESPONSABLE DE PRODUCCIÓN</th>
                </tr>
                <tr>
                    <td class="border" >NOMBRE</td>
                    <td class="border" colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="border" >FIRMA</td>
                    <td class="border" colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="border" >FECHA</td>
                    <td class="border" colspan="4">&nbsp;</td>
                </tr>
            </table>
            <div align="center">
                <input type="button"   class="btn"  size="35" value="Actualizar" name="limpiar" onclick="registrar();">
                <input type="button"   class="btn"  size="35" value="Cancelar" name="cancelar" onclick="cancel();">
            </div>
        </form>
    </body>
</html>
