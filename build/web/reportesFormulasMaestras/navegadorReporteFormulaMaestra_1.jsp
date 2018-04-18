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
<%@ page errorPage="ExceptionHandler.jsp" %>

<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {
    String nombreproducto = "";
    try {
        con = Util.openConnection(con);
        String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
        System.out.println("PresentacionesProducto:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            String codigo = rs.getString(1);
            nombreproducto = rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreproducto;
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
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Formulas Maestras</h4>
            <table align="center" width="90%">
                <td>
                    <img src="../img/cofar.png">
                </td>
                <td>
                    <%
                    try {
                        String fechaInicio = "";
                        String lote = "";
                        String almacen = "";
                        String pilar = "";
                        String aux = "";
                        String codAreaEmpresa = "";
                        con = Util.openConnection(con);
                        aux = request.getParameter("codAreaEmpresa");
                        codAreaEmpresa = aux;
                        Date fecha=new Date();
                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");
                        fechaInicio=f.format(fecha);
                        System.out.println("aux:" + aux);
                        String areaFabricacion = aux;
                        String nombreAreaFabricacion = "Todos";
                        if (aux != null && !aux.equals("0")) {
                            try {
                                //con=CofarConnection.getConnectionJsp();
                                String sql_aux = "select nombre_area_empresa from areas_empresa " +
                                        "where cod_estado_registro=1 and cod_area_empresa='" + aux + "'";
                                System.out.println("almacen:" + sql_aux);
                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs = st.executeQuery(sql_aux);
                                while (rs.next()) {
                                    nombreAreaFabricacion = "";
                                    nombreAreaFabricacion = rs.getString(1);
                                    System.out.println("nombreAreaFabricacion" + nombreAreaFabricacion);
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        System.out.println("aux:" + aux);
                        if (fechaInicio != null) {
                            System.out.println("entro");
                            fechaInicio = fechaInicio;
                        }
                        System.out.println("fechaInicio:" + fechaInicio);
                    %>
                    
                </td>
                <td align="center" > <br>
                    Area : <b><%=nombreAreaFabricacion%></b>
                    <br><br>
                Fecha : <b><%=fechaInicio%> </b> </td>
            </table>
            <div class="outputText0" align="center">
                
                
            </div>
            <br>
            <table width="100%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">
                    <th  bgcolor="#000000"  class="outputTextBlanco">Formula Maestra </th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Lote</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Estado Registro</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Detalle</th>
                </tr>
                
                <%
                
                
                String sql = "select fm.cod_formula_maestra,fm.cod_compprod,fm.cantidad_lote,fm.estado_sistema,";
                sql += " fm.cod_estado_registro,er.nombre_estado_registro,cp.nombre_prod_semiterminado";
                sql += " from formula_maestra fm, estados_referenciales er, componentes_prod cp ";
                sql += " WHERE fm.estado_sistema=1 and fm.cod_compprod=cp.cod_compprod and fm.cod_estado_registro=er.cod_estado_registro and fm.cod_estado_registro=1 and cp.cod_estado_compprod = 1 ";
                if (!codAreaEmpresa.equals("") && !codAreaEmpresa.equals("0")) {
                    sql += " and cp.cod_area_empresa=" +codAreaEmpresa ;
                }
                sql += " order by cp.nombre_prod_semiterminado asc";
                System.out.println("sql:" + sql);
                con=Util.openConnection(con);
                Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4 = st_4.executeQuery(sql);
                
                while (rs_4.next()) {
                    String codFormulaMaestra = rs_4.getString(1);
                    String codCompprod = rs_4.getString(2);
                    double cantidadLote=rs_4.getDouble(3);
                    String estadoSistema = rs_4.getString(4);
                    String codEstadoRegistro = rs_4.getString(5);
                    String nombreEstadoRegistro=rs_4.getString(6);
                    String nombreProdSemiterminado = rs_4.getString(7);
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat) nf;
                    form.applyPattern("#,###.00");
                %>
                <tr>
                    <td style="border : solid #000000 1px;"  align="left" ><%=nombreProdSemiterminado%></td>
                    <td style="border : solid #000000 1px;"  align="right"><%=form.format(cantidadLote)%></td>
                    <td style="border : solid #000000 1px;"  align="center"><%=nombreEstadoRegistro%></td>
                    
                    <td style="border : solid #000000 1px;" >
                        <table table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Materia Prima</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2" class="border_1"   >Material</th>
                                <th align="center" class="border_1" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border_1" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%    
                            String sql_mat_prima="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo ";
                            sql_mat_prima+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MP fmp";
                            sql_mat_prima+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
                            sql_mat_prima+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
                            sql_mat_prima+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
                            sql_mat_prima+=" and g.COD_CAPITULO=2) and fm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                            sql_mat_prima+=" order by m.NOMBRE_MATERIAL";
                            System.out.println("sql_mat_prima:  "+sql_mat_prima);
                            //setCon(Util.openConnection(getCon()));
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreMaterial=rs.getString(2);
                                double cantidad=rs.getDouble(3);
                                String nombreUnidadMedida=rs.getString(4);
                            %>
                            <tr>
                                <td align="left" class="border_1"><%=nombreMaterial%></td>
                                <td align="right" class="border_1"><%=form.format(cantidad)%></td>
                                <td align="right" class="border_1"><%=nombreUnidadMedida%></td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                        <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Material Reactivo</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2"  class="border_1" >Material</th>
                                <th align="center" class="border_1" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border_1" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%    
                            sql_mat_prima="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material, fmp.nro_preparaciones,m.cod_grupo ";
                            sql_mat_prima+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_MR fmp";
                            sql_mat_prima+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
                            sql_mat_prima+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
                            sql_mat_prima+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
                            sql_mat_prima+=" and g.COD_CAPITULO=2 ) and fm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' ";
                            sql_mat_prima+=" order by m.NOMBRE_MATERIAL";
                            System.out.println("sql_mat_prima r:  "+sql_mat_prima);
                            //and g.cod_grupo=5
                            //setCon(Util.openConnection(getCon()));
                            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreMaterial=rs.getString(2);
                                double cantidad=rs.getDouble(3);
                                String nombreUnidadMedida=rs.getString(4);
                            %>
                            <tr>
                                <td align="left" class="border_1"><%=nombreMaterial%></td>
                                <td align="right" class="border_1"><%=form.format(cantidad)%></td>
                                <td align="right" class="border_1"><%=nombreUnidadMedida%></td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                        
                        
                        
                        <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Empaque Primario</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2" class="border_1"  >Material</th>
                                <th align="center" class="border_1" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border_1" width="40%"  bgcolor="#f2f2f2" >Detalle</th>
                            </tr>   
                            
                            <%    
                            sql_mat_prima= " select fep.COD_FORMULA_MAESTRA,ep.nombre_envaseprim,ep.cod_envaseprim,pp.CANTIDAD,pp.cod_presentacion_primaria";
                            sql_mat_prima+= " from FORMULA_MAESTRA fep,PRESENTACIONES_PRIMARIAS pp,ENVASES_PRIMARIOS ep";
                            sql_mat_prima+= " where PP.COD_COMPPROD=fep.COD_COMPPROD AND fep.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                            sql_mat_prima+= " and ep.cod_envaseprim=pp.cod_envaseprim";
                            sql_mat_prima+= " order by ep.nombre_envaseprim";
                            System.out.println("sql_mat_prima EP:  "+sql_mat_prima);                            
                            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            rs=st.executeQuery(sql_mat_prima);

                            
                            while(rs.next()){
                                String nombreEnvasePrimario=rs.getString(2);
                                double cantidad=rs.getDouble(4);
                                String presentacionPrimaria=rs.getString(5);
                            %>
                            <tr>
                                <td align="left" class="border_1"><%=nombreEnvasePrimario%></td>
                                <td align="right" class="border_1"><%=cantidad%></td>
                                <td align="right" class="border_1">
                                        <%    
                                        String sql_EP="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material";
                                        sql_EP+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_EP fmp";
                                        sql_EP+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
                                        sql_EP+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
                                        sql_EP+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
                                        sql_EP+=" and g.COD_CAPITULO=3) and fmp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and fmp.COD_PRESENTACION_PRIMARIA='"+presentacionPrimaria+"'";
                                        sql_EP+=" order by m.NOMBRE_MATERIAL";
                                        System.out.println("sql_EP:  "+sql_EP);
                                        Statement st_EP=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs_EP=st_EP.executeQuery(sql_EP);
                                        
                                        while(rs_EP.next()){
                                            String nombreMaterial_EP=rs_EP.getString(2);
                                            double cantidad_EP=rs_EP.getDouble(3);
                                            String nombreUnidadMedida_EP=rs_EP.getString(4);
                                        %>
                                        <tr>
                                            <td align="left" class="border_1"><%=nombreMaterial_EP%></td>
                                            <td align="right" class="border_1"><%=form.format(cantidad_EP)%></td>
                                            <td align="right" class="border_1"><%=nombreUnidadMedida_EP%></td>
                                        </tr>
                                        <%
                                        }
                                        %>                                    
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                        
                        
                        
                        <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <th colspan="4" bgcolor="#000000" class="outputTextBlanco" >Empaque Secundario</th>
                            </tr>
                            <tr style="border : solid #000000 1px;">
                                <th width="5%" bgcolor="#f2f2f2" class="border_1" >Codigo</th>
                                <th width="45%" bgcolor="#f2f2f2"  class="border_1"  >Material</th>
                                <th align="center" class="border_1" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border_1" width="40%"  bgcolor="#f2f2f2" >Detalle</th>
                            </tr>
                            <%
                            sql_mat_prima=" select es.NOMBRE_ENVASESEC,es.COD_ENVASESEC,pp.NOMBRE_PRODUCTO_PRESENTACION,";
                            sql_mat_prima+=" pp.cantidad_presentacion ,pp.cod_presentacion";
                            sql_mat_prima+=" from PRESENTACIONES_PRODUCTO pp,ENVASES_SECUNDARIOS es,PRODUCTOS p";
                            sql_mat_prima+=" where es.COD_ENVASESEC=pp.COD_ENVASESEC and pp.cod_prod in (select cp.COD_PROD from COMPONENTES_PROD cp,FORMULA_MAESTRA fm ";
                            sql_mat_prima+=" where fm.COD_COMPPROD=cp.COD_COMPPROD and fm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' ) and p.cod_prod=pp.cod_prod";
                            sql_mat_prima+=" order by es.NOMBRE_ENVASESEC ";

                            sql_mat_prima = " select e.NOMBRE_ENVASESEC,e.COD_ENVASESEC,prp.NOMBRE_PRODUCTO_PRESENTACION,prp.cantidad_presentacion ,prp.cod_presentacion " +
                                    " from ENVASES_SECUNDARIOS e " +
                                    " inner join PRESENTACIONES_PRODUCTO prp on e.COD_ENVASESEC = prp.COD_ENVASESEC" +
                                    " inner join COMPONENTES_PRESPROD cprp on cprp.COD_PRESENTACION = prp.cod_presentacion " +
                                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = cprp.COD_COMPPROD " +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD " +
                                    " where fm.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'  " +
                                    " and prp.cod_presentacion in(select distinct c.COD_PRESENTACION from formula_maestra fm " +
                                    " inner join FORMULA_MAESTRA_DETALLE_ES fmd on fm.COD_FORMULA_MAESTRA = fmd.COD_FORMULA_MAESTRA " +
                                    " inner join COMPONENTES_PRESPROD c on fm.COD_COMPPROD = c.COD_COMPPROD " +
                                    " where fmd.COD_PRESENTACION_PRODUCTO = c.COD_PRESENTACION and fm.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"') ";

                            sql_mat_prima = " select e.NOMBRE_ENVASESEC,e.COD_ENVASESEC,prp.NOMBRE_PRODUCTO_PRESENTACION,prp.cantidad_presentacion ,prp.cod_presentacion " +
                                    " from ENVASES_SECUNDARIOS e " +
                                    " inner join PRESENTACIONES_PRODUCTO prp on e.COD_ENVASESEC = prp.COD_ENVASESEC" +
                                    " inner join COMPONENTES_PRESPROD cprp on cprp.COD_PRESENTACION = prp.cod_presentacion " +
                                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = cprp.COD_COMPPROD " +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD " +
                                    " where fm.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'  " ;

                            System.out.println("sql_mat_prima ES:  "+sql_mat_prima);
                            //setCon(Util.openConnection(getCon()));
                            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreEnvasePrimario=rs.getString(3);
                                double cantidad=rs.getDouble(4);
                                String codPresentacion=rs.getString(5);
                            %>
                            <tr>
                                <td align="left" class="border_1"><%=codPresentacion%></td>
                                <td align="left" class="border_1"><%=nombreEnvasePrimario%></td>
                                <td align="right" class="border_1"><%=cantidad%></td>
                                <td align="right" class="border_1">
                                        <%    
                                        String sql_ES="select fm.COD_FORMULA_MAESTRA,m.NOMBRE_MATERIAL,fmp.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,m.cod_material";
                                        sql_ES+=" from FORMULA_MAESTRA fm,MATERIALES m,UNIDADES_MEDIDA um,FORMULA_MAESTRA_DETALLE_ES fmp";
                                        sql_ES+=" where fm.COD_FORMULA_MAESTRA=fmp.COD_FORMULA_MAESTRA and um.COD_UNIDAD_MEDIDA=fmp.COD_UNIDAD_MEDIDA";
                                        sql_ES+=" and m.COD_MATERIAL=fmp.COD_MATERIAL ";
                                        sql_ES+=" and fmp.COD_MATERIAL IN(select m1.COD_MATERIAL from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO";
                                        sql_ES+=" and g.COD_CAPITULO in(4,8)) and fm.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and fmp.cod_presentacion_producto='"+codPresentacion+"'";
                                        sql_ES+=" order by m.NOMBRE_MATERIAL";
                                        System.out.println("sql_ES:  "+sql_ES);
                                        //setCon(Util.openConnection(getCon()));
                                        Statement st_ES=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rs_ES=st_ES.executeQuery(sql_ES);
                                        while(rs_ES.next()){
                                            String nombreMaterial_ES=rs_ES.getString(2);
                                            double cantidad_ES=rs_ES.getDouble(3);
                                            String nombreUnidadMedida_ES=rs_ES.getString(4);
                                        %>
                                        <tr>
                                            <td align="left" class="border_1">&nbsp;</td>
                                            <td align="left" class="border_1"><%=nombreMaterial_ES%></td>
                                            <td align="right" class="border_1"><%=form.format(cantidad_ES)%></td>
                                            <td align="right" class="border_1"><%=nombreUnidadMedida_ES%></td>
                                        </tr>
                                        <%
                                        }
                                        %>
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                    </td> 
                </tr>
                <%
                }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </table>
            <br>
            
            <br>
            <div align="center">
            </div>
        </form>
    </body>
</html>
