
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
        String codProgramaPeriodo = request.getParameter("codProgramaPeriodo");
        System.out.println("codProgramaPeriodo:" + codProgramaPeriodo);
        String sql2 = "";
        String sql3 = "";
        int tamanio = 0;
        String codigos[] = codProgramaPeriodo.split(",");
        tamanio = codigos.length;
        System.out.println(tamanio);
        System.out.println(tamanio);
        for (int i = 0; i < tamanio; i++) {
            codProgramaPeriodo = codigos[i];
            System.out.println(codProgramaPeriodo);
            try {
                con=Util.openConnection(con);
                sql2 = " delete from PROGRAMA_PRODUCCION_PERIODO";
                sql2 += " where COD_PROGRAMA_PROD='" + codProgramaPeriodo + "'";
                System.out.println("sql2" + sql2);
                PreparedStatement pst = con.prepareStatement(sql2);
                if(pst.executeUpdate()>0)System.out.println("se elimino el programa periodo");

                sql3 = " delete from PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD= '" + codProgramaPeriodo + "'";
                System.out.println("sql3" + sql3);
                pst=con.prepareStatement(sql3);
                if(pst.executeUpdate()>0)System.out.println("se elimino el programa produccion ");

                sql3 = " delete from PROGRAMA_PRODUCCION_DETALLE where COD_PROGRAMA_PROD= '" + codProgramaPeriodo + "'";
                System.out.println("sql3" + sql3);
                pst=con.prepareStatement(sql3);
                if(pst.executeUpdate()>0)System.out.println("se elimino el detalle del programa produccion");
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

            %>

        </form>
    </body>
</html>
<script language="JavaScript">
    location.href="navgador_programa_periodo.jsp";
</script>
