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
        System.out.println("codProveedor:"+codProveedor);

        String codMaterial = request.getParameter("codMaterial");
        String nomProveedor = request.getParameter("nomProveedor");
        String nomMaterial = request.getParameter("nomMaterial");
        String codigos = request.getParameter("codigos");
        System.out.println("codMaterial:"+codMaterial);
        System.out.println("codigos:"+codigos);
        String codigosVector[] = codigos.split(",");
        String cod_tipo_incentivo_regional = "1";
        double puntuacion = 0;
        double valor = 0;
        double contAdm = 0;
        double contTec = 0;
        int categoria_proveedor = 0;
        for (int i = 0; i < codigosVector.length-1; i=i+2) {
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
            if (cod < 10) {

                contAdm = contAdm + valor;
            } else {
                //alert("2:"+f.elements[i+1].value);
                contTec = contTec + valor;
            }
        }
        puntuacion=((contAdm*1)*30/45)+((contTec*1)*70/105);
        if(puntuacion<56){
            categoria_proveedor=2;
        }
        if(puntuacion>=56 && puntuacion<70){
            categoria_proveedor=3;
        }
        if(puntuacion>=70){
            categoria_proveedor=1;
        }
        try {
            Statement st_del = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs_del = st_del.executeUpdate("delete from EVALUACION_PROVEEDORES_MATERIAL where COD_PROVEEDOR='" + codProveedor + "' and COD_MATERIAL='" + codMaterial + "'");
            sql2 = "insert into EVALUACION_PROVEEDORES_MATERIAL(COD_PROVEEDOR,COD_MATERIAL,COD_ESTADO_REGISTRO,COD_CATEGORIA_PROVEEDOR,PUNTUACION_TOTAL)";
            sql2 += "values('" + codProveedor + "','" + codMaterial + "',1,"+categoria_proveedor+","+puntuacion+")";
            System.out.println("sql2" + sql2);
            Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs2 = st2.executeUpdate(sql2);

        } catch (SQLException e) {
            e.printStackTrace();
        }
            %>
        </form>
    </body>
</html>
<script language="JavaScript">
    location.href="navegadorEvaluaProveedores.jsp";
</script>
