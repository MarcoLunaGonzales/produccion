
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
<%@ page import="com.cofar.web.*" %>



<%! Connection con = null;
%>
<%
        con = Util.openConnection(con);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
        </script>
    </head>
    <body>
        <form name="form1" action="">
            <%
        String sql = "";
        String sql2 = "";
        String codProveedor = request.getParameter("codProveedor");
        String fecha_inicio = request.getParameter("fecha_inicio");
        String fechaInVector[] = fecha_inicio.split("/");
        fecha_inicio = fechaInVector[2] + "/" + fechaInVector[1] + "/" + fechaInVector[0];
        String codPëriodoEvaluacion = request.getParameter("cod_tipo_inc_regional");
        System.out.println("codProveedor:" + codProveedor);
        System.out.println("codPëriodoEvaluacion:" + codPëriodoEvaluacion);

        String codMaterial = request.getParameter("codMaterial");
        String nro_oc = request.getParameter("nro_oc");
        String nomProveedor = request.getParameter("nomProveedor");
        String nomMaterial = request.getParameter("nomMaterial");
        String codigos = request.getParameter("codigos");
        System.out.println("codMaterial:" + codMaterial);
        System.out.println("codigos:" + codigos);
        String codigosVector[] = codigos.split(",");
        String cod_tipo_incentivo_regional = "1";
        double puntuacion = 0;
        double valor = 0;
        double contAdm = 0;
        double contTec = 0;
        int categoria_proveedor = 0;
        Statement st_del = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int rs_del = st_del.executeUpdate("delete from EVALUACION_PROVEEDORES_MATERIAL_DETALLE where COD_PROVEEDOR='" + codProveedor + "' and COD_MATERIAL='" + codMaterial + "' and COD_PERIODO_EVALUACION=" + codPëriodoEvaluacion + "");

        for (int i = 0; i < codigosVector.length - 1; i = i + 2) {
            int cod = Integer.parseInt(codigosVector[i]);
            double codDet = Double.parseDouble(codigosVector[i + 1]);

            if (cod == 11) {
                if (codDet == 1) {
                    valor = 1;
                }
                if (codDet == 2) {
                    valor = 50;
                }
                if (codDet == 3) {
                    valor = 70;
                }
            } else {
                if (codDet == 1) {
                    valor = 1;
                }
                if (codDet == 2) {
                    valor = 2.5;
                }
                if (codDet == 3) {
                    valor = 5;
                }
            }
            if (cod == 15) {
                if (codDet == 1) {
                    valor = 1;
                }
                if (codDet == 2) {
                    valor = 5;
                }

            }
            if (cod < 10) {

                contAdm = contAdm + valor;
            } else {
                //alert("2:"+f.elements[i+1].value);
                contTec = contTec + valor;
            }

            String sql_insert = " INSERT INTO EVALUACION_PROVEEDORES_MATERIAL_DETALLE(COD_PROVEEDOR,COD_MATERIAL,COD_EVALUACION,PUNTUACION,cod_puntuacion,COD_PERIODO_EVALUACION) values(";
            sql_insert += " '" + codProveedor + "','" + codMaterial + "'," + cod + "," + valor + ",1," + codPëriodoEvaluacion + ")";
            System.out.println("sql_insert:" + sql_insert);
            Statement st_insert = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs_insert = st_insert.executeUpdate(sql_insert);
        }

        puntuacion = ((contAdm * 1) * 30 / 45) + ((contTec * 1) * 70 / 105);
        if (puntuacion < 56) {
            categoria_proveedor = 2;
        }
        if (puntuacion >= 56 && puntuacion < 70) {
            categoria_proveedor = 3;
        }
        if (puntuacion >= 70) {
            categoria_proveedor = 1;
        }
        try {
            con = Util.openConnection(con);
            String codPersonal = "";
            ManagedAccesoSistema presupuesto = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            codPersonal = presupuesto.getUsuarioModuloBean().getCodUsuarioGlobal();
            System.out.println("presupuesto.getUsuarioModuloBean().getCodUsuarioGlobal():"+presupuesto.getUsuarioModuloBean().getCodUsuarioGlobal());
            //String codPersonal = "7";
            //String codPersonal = "303";
            String codAreaEmpresaPersonal = "0";
            System.out.println("codPersonal:" + codPersonal);
            try {
                
                sql = " select COD_AREA_EMPRESA from areas_empresa where cod_area_empresa in (select P.cod_area_empresa from personal P where p.cod_personal=" + codPersonal + ")";
                System.out.println("sql:" + sql);
                Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs3 = st3.executeQuery(sql);
                while (rs3.next()) {
                    codAreaEmpresaPersonal = rs3.getString(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            String sql_v = "SELECT * FROM EVALUACION_PROVEEDORES_MATERIAL  E WHERE E.COD_PROVEEDOR=" + codProveedor + " AND E.COD_MATERIAL=" + codMaterial + " AND E.COD_PERIODO_EVALUACION=" + codPëriodoEvaluacion + "";
                System.out.println("sql_v:" + sql_v);
                Statement st_v = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_v = st_v.executeQuery(sql_v);
                int sw = 0;
                if (rs_v.next()) {
                    sw = 1;
                }
            if (codAreaEmpresaPersonal.equals("30")) {
                
                if (sw == 0) {
                    st_del = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs_del = st_del.executeUpdate("delete from EVALUACION_PROVEEDORES_MATERIAL where COD_PROVEEDOR='" + codProveedor + "' and COD_MATERIAL='" + codMaterial + "'and COD_PERIODO_EVALUACION=" + codPëriodoEvaluacion + "");
                    sql2 = "insert into EVALUACION_PROVEEDORES_MATERIAL(COD_PROVEEDOR,COD_MATERIAL,COD_ESTADO_REGISTRO,COD_CATEGORIA_PROVEEDOR,PUNTUACION_TOTAL,COD_PERIODO_EVALUACION,FECHA_COMPRAS,NRO_ORDEN_COMPRA)";
                    sql2 += "values('" + codProveedor + "','" + codMaterial + "',1," + categoria_proveedor + "," + puntuacion + "," + codPëriodoEvaluacion + ",'" + fecha_inicio + "',"+nro_oc+")";
                    System.out.println("sql2" + sql2);
                    Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    int rs2 = st2.executeUpdate(sql2);
                }else{
                    sql2 = "update EVALUACION_PROVEEDORES_MATERIAL set COD_CATEGORIA_PROVEEDOR=" + categoria_proveedor + ",PUNTUACION_TOTAL=" + puntuacion + ",FECHA_COMPRAS='" + fecha_inicio + "',NRO_ORDEN_COMPRA="+nro_oc+"" +
                           " where COD_PROVEEDOR='" + codProveedor + "' and COD_MATERIAL='" + codMaterial + "'and COD_PERIODO_EVALUACION=" + codPëriodoEvaluacion + "";

                    System.out.println("sql2" + sql2);
                    Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    int rs2 = st2.executeUpdate(sql2);
                }

            } else {
                    if (sw == 0) {
                         st_del = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                rs_del = st_del.executeUpdate("delete from EVALUACION_PROVEEDORES_MATERIAL where COD_PROVEEDOR='" + codProveedor + "' and COD_MATERIAL='" + codMaterial + "'and COD_PERIODO_EVALUACION=" + codPëriodoEvaluacion + "");
                sql2 = "insert into EVALUACION_PROVEEDORES_MATERIAL(COD_PROVEEDOR,COD_MATERIAL,COD_ESTADO_REGISTRO,COD_CATEGORIA_PROVEEDOR,PUNTUACION_TOTAL,COD_PERIODO_EVALUACION,FECHA_CONTROL,NRO_ORDEN_COMPRA)";
                sql2 += "values('" + codProveedor + "','" + codMaterial + "',1," + categoria_proveedor + "," + puntuacion + "," + codPëriodoEvaluacion + ",'" + fecha_inicio + "',"+nro_oc+")";
                System.out.println("sql2" + sql2);
                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int rs2 = st2.executeUpdate(sql2);
                    }else{
                    sql2 = "update EVALUACION_PROVEEDORES_MATERIAL set COD_CATEGORIA_PROVEEDOR=" + categoria_proveedor + ",PUNTUACION_TOTAL=" + puntuacion + ",FECHA_CONTROL='" + fecha_inicio + "',NRO_ORDEN_COMPRA="+nro_oc+"" +
                           " where COD_PROVEEDOR='" + codProveedor + "' and COD_MATERIAL='" + codMaterial + "'and COD_PERIODO_EVALUACION=" + codPëriodoEvaluacion + "";

                    System.out.println("sql2" + sql2);
                    Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    int rs2 = st2.executeUpdate(sql2);
                    }
               
            }



        } catch (SQLException e) {
            e.printStackTrace();
        }
            %>
        </form>
    </body>
</html>
<script language="JavaScript">
    location.href="navegadorEditarEvaluaProveedores.jsp?cod_tipo_inc_regional=<%=codPëriodoEvaluacion%>";
</script>
