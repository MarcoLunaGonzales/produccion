<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
ServletOutputStream sout = response.getOutputStream();
Connection con=null;
try 
{
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=certificado.pdf");
    response.setHeader("Cache-control", "public");
    int codVersion=Integer.valueOf(request.getParameter("codVersion"));

    try {
        con = Util.openConnection(con);
        StringBuilder consulta = new StringBuilder("select c.CERTIFICADO_REGISTRO_SANITARIO");
                                consulta.append(" from COMPONENTES_PROD_VERSION c");
                                consulta.append(" where c.COD_VERSION=").append(codVersion);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet res = st.executeQuery(consulta.toString());
        
        byte[] imagen=null;
        if(res.next()) {
            imagen = res.getBytes("CERTIFICADO_REGISTRO_SANITARIO");
            sout.write(imagen);
        }
        sout.flush();



    } catch (SQLException ex) {
        ex.printStackTrace();
    } catch (Exception ex) {
        System.out.println("entro exception");
        ex.printStackTrace();
        response.setContentType("text/html");
        sout.println("<html>"+
                "<head><title>Archivo no subido</title></head>"+
                "<body>"+
                "<h2>El registro sanitario no se encuentra en sistema.</h2>"+
                "</body></html>");
    } 

}
finally
{
    sout.close();
    try
    {
        con.close();
    }catch(Exception ex){ex.printStackTrace();}
}
%>