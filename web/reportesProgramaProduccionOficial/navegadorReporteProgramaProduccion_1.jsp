

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


<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {
    
    
    
    String nombreproducto = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
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
            <h4 align="center">Reporte Programa Producción</h4>
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
                        aux = request.getParameter("codigosArea");
                        System.out.println("aux..:" + aux);
                        String codprogramaProd= request.getParameter("codProgramaProd");
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
                                String sql_aux = "select nombre_area_empresa from areas_empresa " ;
                                      // sql_aux += "where cod_estado_registro=1 and cod_area_empresa='" + aux + "'";
                                       sql_aux += "where cod_estado_registro=1 and cod_area_empresa IN (" + aux + ")";
                                 //IN (" + codAreaEmpresa + ")" ;       
                                System.out.println("ALMACEN-------------->" + sql_aux);
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
                        //aux = request.getParameter("fecha_inicio");
                        //aux = "09/02/2009";
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
            <table width="90%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">
                    <th  bgcolor="#000000"  class="outputTextBlanco">Producto</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Lote</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Nro. de Lotes a Producir</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Nro de Lote</th>
                    <th  bgcolor="#000000"  class="outputTextBlanco">Fecha Inicio</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Fecha Final</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Tipo Programa Producción</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Categoría</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Observaciones</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Estado Programa</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Detalle</th>
                </tr>
                
                <%
                
                String sql = "select fm.cod_formula_maestra,pp.cod_lote_produccion,";
                sql += " pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion,";
                sql += " cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote,epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD";
                sql += " ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),''),pp.MATERIAL_TRANSITO";
                sql += " from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp,TIPOS_PROGRAMA_PRODUCCION tp";
                sql += " where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa";
                sql += " and tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD and pp.cod_estado_programa in (2,5) and pp.cod_programa_prod="+codprogramaProd;
                               
              if (!codAreaEmpresa.equals("") && !codAreaEmpresa.equals("0")) {
                  //sql += " and cp.cod_area_empresa = " +codAreaEmpresa ;
                    sql += " and cp.cod_area_empresa IN (" + codAreaEmpresa + ")" ;
                }
                
                sql += " order by cp.nombre_prod_semiterminado asc";
                System.out.println("sqlggggggggggggggggg------->:" + sql);
                con=Util.openConnection(con);
                Statement st_4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_4 = st_4.executeQuery(sql);                
                while (rs_4.next()) {
                    
                    String codFormulaMaestra = rs_4.getString(1);
                    String codLoteProduccion = rs_4.getString(2);
                    String fechaInicioPrograma=rs_4.getString(3);
                    if(fechaInicioPrograma==null){
                        fechaInicioPrograma="";
                    }else{
                        String fechaInicioVector[]=fechaInicioPrograma.split(" ");
                        fechaInicioVector=fechaInicioVector[0].split("-");
                        fechaInicioPrograma=fechaInicioVector[2]+"/"+fechaInicioVector[1]+"/"+fechaInicioVector[0];
                    }
                    String fechaFinalPrograma=rs_4.getString(4);
                    if(fechaFinalPrograma==null){
                        fechaFinalPrograma="";
                    }else{
                        String fechaFinalVector[]=fechaFinalPrograma.split(" ");
                        fechaFinalVector=fechaFinalVector[0].split("-");
                        fechaFinalPrograma=fechaFinalVector[2]+"/"+fechaFinalVector[1]+"/"+fechaFinalVector[0];
                    }
                    String codEstadoPrograma = rs_4.getString(5);
                    String observacion = rs_4.getString(6);
                    String nombreCompProd=rs_4.getString(7);
                    String codCompProd = rs_4.getString(8);
                    double cantidadLote=rs_4.getDouble(9);
                    String nombreEstadoPrograma = rs_4.getString(10);
                    String cantidadLoteProduccion=rs_4.getString(11);
                    String codTipoProgramaProd = rs_4.getString(12);
                    String nombreTipoProgramaProd=rs_4.getString(13);
                    String nombreCategoriaCompProd = rs_4.getString(14);
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat) nf;
                    form.applyPattern("#,###.00");
                %>
                <tr>
                    <td style="border : solid #000000 1px;"  align="left" ><%=nombreCompProd%></td>
                    
                    <td style="border : solid #000000 1px;"  align="right"><%=form.format(cantidadLote)%></td>
                    <td style="border : solid #000000 1px;"  align="center"><%=cantidadLoteProduccion%></td>
                    <td style="border : solid #000000 1px;"  align="left" ><%=codLoteProduccion%></td>
                    <td style="border : solid #000000 1px;"  align="right"><%=fechaInicioPrograma%></td>
                    <td style="border : solid #000000 1px;"  align="center"><%=fechaFinalPrograma%></td>
                    <td style="border : solid #000000 1px;"  align="left" ><%=nombreTipoProgramaProd%></td>
                    <td style="border : solid #000000 1px;"  align="right"><%=nombreCategoriaCompProd%></td>
                    <td style="border : solid #000000 1px;"  align="center"><%=observacion%></td>
                    <td style="border : solid #000000 1px;"  align="center"><%=nombreEstadoPrograma%></td>
                    
                    <td style="border : solid #000000 1px;" >
                        <table table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Materia Prima</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%    
                            String sql_mat_prima=" select m.NOMBRE_MATERIAL,ppd.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,um.COD_UNIDAD_MEDIDA" ;
                            sql_mat_prima+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                            sql_mat_prima+=" where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                            sql_mat_prima+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+codFormulaMaestra+"' ";
                            sql_mat_prima+=" and pp.cod_programa_prod='"+codprogramaProd+"' and ppd.cod_compprod='"+codCompProd+"' and ppd.cod_lote_produccion='"+codLoteProduccion+"'";
                            sql_mat_prima+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                            sql_mat_prima+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep where ep.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"') ";                            
                            sql_mat_prima+=" order by m.NOMBRE_MATERIAL";
                            
                            System.out.println("sql_mat_prima:  "+sql_mat_prima);
                            //setCon(Util.openConnection(getCon()));
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreMaterial=rs.getString(1);
                                double cantidad=rs.getDouble(2);
                                String nombreUnidadMedida=rs.getString(3);
                                
                          
                            %>
                            <tr>
                                <td align="left" class="border"><%=nombreMaterial%></td>
                                <td align="right" class="border"><%=form.format(cantidad)%></td>
                                <td align="right" class="border"><%=nombreUnidadMedida%></td>
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
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                                
                            </tr>
                            <%    
                            sql_mat_prima=" select m.NOMBRE_MATERIAL,ppd.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,um.COD_UNIDAD_MEDIDA" ;
                            sql_mat_prima+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                            sql_mat_prima+=" where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                            sql_mat_prima+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+codFormulaMaestra+"' ";
                            sql_mat_prima+=" and pp.cod_programa_prod='"+codprogramaProd+"' and ppd.cod_compprod='"+codCompProd+"' and ppd.cod_lote_produccion='"+codLoteProduccion+"'";
                            sql_mat_prima+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                            sql_mat_prima+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR ep where ep.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"') ";
                            sql_mat_prima+=" order by m.NOMBRE_MATERIAL";
                            System.out.println("sql_mat_prima r:  "+sql_mat_prima);
                            //setCon(Util.openConnection(getCon()));
                            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreMaterial=rs.getString(1);
                                double cantidad=rs.getDouble(2);
                                String nombreUnidadMedida=rs.getString(3);
                            %>
                            <tr>
                                <td align="left" class="border"><%=nombreMaterial%></td>
                                <td align="right" class="border"><%=form.format(cantidad)%></td>
                                <td align="right" class="border"><%=nombreUnidadMedida%></td>
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
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%    
                            sql_mat_prima=" select m.NOMBRE_MATERIAL,ppd.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,um.COD_UNIDAD_MEDIDA" ;
                            sql_mat_prima+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                            sql_mat_prima+=" where    um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                            sql_mat_prima+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+codFormulaMaestra+"' ";
                            sql_mat_prima+=" and pp.cod_programa_prod='"+codprogramaProd+"' and ppd.cod_compprod='"+codCompProd+"' and ppd.cod_lote_produccion='"+codLoteProduccion+"'";
                            sql_mat_prima+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                            sql_mat_prima+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP ep where ep.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"') ";
                            sql_mat_prima+=" order by m.NOMBRE_MATERIAL";
                            System.out.println("sql_mat_prima EP:  "+sql_mat_prima);
                            //setCon(Util.openConnection(getCon()));
                            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreMaterial=rs.getString(1);
                                double cantidad=rs.getDouble(2);
                                String nombreUnidadMedida=rs.getString(3);
                            %>
                            <tr>
                                <td align="left" class="border"><%=nombreMaterial%></td>
                                <td align="right" class="border"><%=form.format(cantidad)%></td>
                                <td align="right" class="border"><%=nombreUnidadMedida%></td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                        <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr >
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco" >Empaque Secundario</th>
                            </tr>
                            <tr style="border : solid #000000 1px;">
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%    
                            sql_mat_prima=" select m.NOMBRE_MATERIAL,ppd.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,um.COD_UNIDAD_MEDIDA" ;
                            sql_mat_prima+=" from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                            sql_mat_prima+=" where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL ";
                            sql_mat_prima+=" and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+codFormulaMaestra+"' ";
                            sql_mat_prima+=" and pp.cod_programa_prod='"+codprogramaProd+"' and ppd.cod_compprod='"+codCompProd+"' and ppd.cod_lote_produccion='"+codLoteProduccion+"'";
                            sql_mat_prima+=" and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod";
                            sql_mat_prima+=" and m.COD_MATERIAL in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"') ";
                            sql_mat_prima+=" order by m.NOMBRE_MATERIAL";
                            System.out.println("sql_mat_prima ES:  "+sql_mat_prima);
                            //setCon(Util.openConnection(getCon()));
                            st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            rs=st.executeQuery(sql_mat_prima);
                            while(rs.next()){
                                String nombreMaterial=rs.getString(1);
                                double cantidad=rs.getDouble(2);
                                String nombreUnidadMedida=rs.getString(3);
                            %>
                            <tr>
                                <td align="left" class="border"><%=nombreMaterial%></td>
                                <td align="right" class="border"><%=form.format(cantidad)%></td>
                                <td align="right" class="border"><%=nombreUnidadMedida%></td>
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
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>
